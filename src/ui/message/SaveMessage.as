package ui.message 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import settings.CustomUI;
	import settings.MessagePrefrences;
	import settings.System;

	public class SaveMessage extends Sprite
	{
		private var _heading:String;
		private var _message:String;
		private var _exitHandler:Function;
		private var _type:uint;
		private var _fileName:String;
		
		private var nameTxt:TextField;
		
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		
		public static const MENU_TYPE:uint = 1;
		public static const CANVAS_TYPE:uint = 2;
		public static const IMAGE_TYPE:uint = 2;
		
		public function SaveMessage(type:uint,exitHandler:Function,heading:String = null, message:String=null, fileName:String = null) 
		{
			_type = type;
			_exitHandler = exitHandler;
			
			_fileName = fileName;
			
			heading == null?_heading = "Warning!":_heading = heading;
			message == null?_message = "Are you sure?":_message = message;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			graphics.beginFill(CustomUI.backColor); 
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			
			var holder:Sprite;
			var sp:Sprite;
			var textField:TextField
			var cT:ColorTransform;
			
			holder = new Sprite;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = _heading;
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.03;
			textField.y = -textField.height /8;
			holder.addChild(textField);
			
			holder.x = sW / 2 - holder.width / 2;
			holder.y = -holder.height;
			addChild(holder);
			TweenNano.to(holder, 1, { y: sH * 0.05, ease:Strong.easeOut } );
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.05;
			txtFormat.align = "center";
			textField.defaultTextFormat = txtFormat;
			textField.text = _message;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW;
			textField.y = sH * 0.4;
			addChild(textField);
			TweenNano.to(textField, 1, { x: sW / 2 - textField.width / 2, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW/4 - sp.width/2;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onOK);
			TweenNano.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Cancel";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = 3*sW/4 - sp.width/2;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onCancel);
			TweenNano.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Width";
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.5, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = (_type==CANVAS_TYPE||_type==IMAGE_TYPE)?"File Name":"Preset Name";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			txtFormat.color = CustomUI.color1;
			nameTxt = new TextField;nameTxt.embedFonts = true;
			nameTxt.defaultTextFormat = txtFormat;
			nameTxt.text = _fileName;
			nameTxt.type = TextFieldType.INPUT;
			nameTxt.background = true;
			nameTxt.backgroundColor = CustomUI.color2;
			nameTxt.autoSize = TextFieldAutoSize.CENTER;
			nameTxt.maxChars = 15;
			nameTxt.x = sp.width - nameTxt.width - sW * 0.029; nameTxt.y = sp.height / 2 - nameTxt.height / 2;
			sp.addChild(nameTxt);
			sp.x = -sp.width;
			sp.y = sH - sH * 0.3 - sp.height;
			TweenNano.to(sp, 1, { x: sW/2 - sp.width/2, ease:Strong.easeOut } );
			//sp.addEventListener(MouseEvent.MOUSE_DOWN, setFocus);
			
		}
		
		private function onOK(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			_exitHandler(nameTxt.text);
		}
		
		private function onCancel(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			this.parent.removeChild(this);
		}
		
	}
	
}
