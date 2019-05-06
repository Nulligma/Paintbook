package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import settings.System;
	import settings.CustomUI;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public final class CustomSlider extends Sprite
	{
		public  var value:int = 6;
		private var startX:int;
		private var startY:int;
		
		private var range:int;
		private var startPos:Number;
		
		private var maxWidth:Number;
		
		private var _minVal:int;
		private var _maxVal:int;
		private var _details:String;
		private var ratio:Number;
		
		private var customWidth:int;
		private var customHeight:int;
		
		private var bgColor:uint;
		
		private var _dataArray:Array;
		
		private var withClose:Boolean;
		
		private var detailsTxt:TextField;
		private var bg:Sprite;
		private var head:Sprite;
		private var txtTF:TextField;
		
		public var closeBtn:Sprite;
		
		public final function CustomSlider(details:String,startValue:Number,minVal:int,maxVal:int,dataArray:Array=null,width:int=0,height:int=0,bgColor:uint=0x00000000,withClose:Boolean=false):void
		{
			range = maxVal - minVal;
			value = Math.round(startValue);
			
			_maxVal = maxVal;
			_minVal = minVal;
			
			_dataArray = dataArray;
			_details = details;
			
			customWidth = width;
			customHeight = height;
			
			this.bgColor = bgColor;
			
			this.withClose = withClose;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event)
		{
			var w:Number;
			var h:Number;
			
			if(customWidth == 0)
			{
				w = System.stageWidth;
				h = System.stageHeight;
			}
			else
			{
				w = customWidth;
				h = customHeight;
			}
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(CustomUI.backColor);
			background.graphics.drawRect(0, 0, w, h);
			background.graphics.endFill();
			this.addChild(background);
			
			var triangleHeight:uint = height/6;
			var triangleWidth:uint = width/1.5;
			bg = new Sprite();
			bg.graphics.beginFill(CustomUI.color2);
			bg.graphics.moveTo(0,0);
			bg.graphics.lineTo(triangleWidth, -triangleHeight/2);
			bg.graphics.lineTo(triangleWidth, triangleHeight/2);
			bg.graphics.lineTo(0,0);
			bg.x = width/2 - bg.width/2;
			bg.y = height/2 - bg.height/2;
			addChild(bg);
			
			startX = bg.x;
			startY = bg.y;
			
			maxWidth = bg.width;
			
			ratio = (value-_minVal)/range;
			if (ratio > 0.995)
				ratio = 1;
			ratio = 1 - ratio;
			
			var maxX:Number = maxWidth + startX;
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.align = "center";
			txtFormat.color = CustomUI.color1;
			
			detailsTxt = new TextField();detailsTxt.embedFonts = true;
			txtFormat.size = height * 0.083;
			detailsTxt.defaultTextFormat = txtFormat;
			if (_dataArray != null)
			{
				detailsTxt.text = _details + _dataArray[value];
			}
			else
			{
				detailsTxt.text = _details;
			}
			detailsTxt.selectable = false; 
			detailsTxt.autoSize = TextFieldAutoSize.CENTER;
			detailsTxt.x = width/2 - detailsTxt.width/2;
			detailsTxt.y = height/2 - height/4 - detailsTxt.height/2;
			addChild(detailsTxt);
			
			head = new Sprite();
			head.graphics.beginFill(CustomUI.color1);
			head.graphics.drawCircle(0,0,triangleHeight/2);
			head.graphics.endFill();
			head.y = height/2 - head.height/2;
			head.x = maxX - ((maxX - startX) * ratio);
			this.addChild(head);
			
			txtTF = new TextField();txtTF.embedFonts = true;
			txtFormat.size = height * 0.083;
			txtTF.defaultTextFormat = txtFormat;
			txtTF.text = String(value);
			txtTF.selectable = false; 
			txtTF.autoSize = TextFieldAutoSize.CENTER;
			txtTF.x = width/2 - txtTF.width/2;
			txtTF.y = height/2 + txtTF.height/2;
			addChild(txtTF);
			
			if(withClose)
			{
				closeBtn = new Sprite;
				closeBtn.graphics.beginFill(CustomUI.color1); 
				closeBtn.graphics.drawRect(0, 0, width * 0.146, height * 0.083); closeBtn.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = height * 0.083 * 0.6;
				var textField:TextField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = "Cancel";
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = closeBtn.width / 2 - textField.width / 2; textField.y = closeBtn.height / 2 - textField.height / 2;
				closeBtn.addChild(textField);
				addChild(closeBtn);
				closeBtn.x = width/2 - closeBtn.width/2;
				closeBtn.y = height/2 + height/3;
				closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				//closeBtn.addEventListener(MouseEvent.CLICK, onYes);
				this.addChild(closeBtn);
			}
			
			addListeners();
		}
		
		private final function addListeners():void
		{
			head.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}
		
		private final function initDrag(e:MouseEvent):void
		{
			head.startDrag(false, new Rectangle(startX, startY, bg.width, 0));
			addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
		}
		
		private final function onSliderMove(e:MouseEvent):void
		{
			ratio = (head.x - startX) / maxWidth;
			
			if (ratio > 0.995)
				ratio = 1;
			
			ratio = 1 - ratio;
			
			value = _maxVal - ((_maxVal - _minVal) * ratio);
			txtTF.text = String(value);
			
			if (_dataArray != null)
			{
				detailsTxt.text = _details + _dataArray[value];
			}
		}
	}
}