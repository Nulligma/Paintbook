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

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Warning extends Sprite
	{
		private var _heading:String;
		private var _message:String;
		private var _exitHandler:Function;
		private var _type:String;
		
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		
		private var checkedIcon:Sprite;
		private var tween:TweenNano;
		
		private var _status:int;
		private var submessageTxt:TextField;
		
		static public const DONATE_MSG:Array = ["This app maybe free but sadly food is not.Donate some food?", "Are you gonna do something? Or just sit there and click 'No'?",
											"Be a YES-MAN!", "We still live in world where money can be transfered on wire but not love.", "Will you make me an offer I cannot refuse?",
											"Do you know whats good? Money, and whats better? More money!", "Sometimes all we need is a lil love, but for now a lil money will do",
											"Go ahead. Make my day."];
		
		static public const LAYER_MERGE:String = "MERGE";
		static public const LAYER_DELETE:String = "DELETE";
		static public const DONATE:String = "DONATE";
		
		static public const UNSTOPPABLE:String = "unstoppable";
		
		public function Warning(type:String,exitHandler:Function,heading:String = null, message:String=null) 
		{
			_type = type;
			_exitHandler = exitHandler;
			
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
			sp = new WarningIcon;
			sp.scaleX = sp.scaleY = (sH * 0.083 / 40);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp.transform.colorTransform = cT;
			sp.x = sp.width / 2;
			sp.y = sp.height / 2;
			holder.addChild(sp);
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = _heading;
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width + sW * 0.03;
			textField.y = -textField.height /8;
			holder.addChild(textField);
			
			holder.x = sW / 2 - holder.width / 2;
			holder.y = -holder.height;
			addChild(holder);
			tween = new TweenNano(holder, 1, { y: sH * 0.05, ease:Strong.easeOut } );
			
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
			tween = new TweenNano(textField, 1, { x: sW / 2 - textField.width / 2, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Yes";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onYes);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "No";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW - sp.width - sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onNo);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			if (_type == UNSTOPPABLE) return;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.05;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Do not show this message again";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width ;
			textField.y = sH * 0.73;
			addChild(textField);
			tween = new TweenNano(textField, 1, { x: sW *  0.48-textField.width/2, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sH * 0.083, sH * 0.083);
			sp.x = -sp.width;
			sp.y = sH * 0.73;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changePref);
			tween = new TweenNano(sp, 1, { x: sW * 0.52+textField.width/2, ease:Strong.easeOut } );
			
			checkedIcon = new CheckIcon;
			checkedIcon.scaleX = checkedIcon.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			checkedIcon.transform.colorTransform = cT;
			checkedIcon.x = checkedIcon.width / 2;
			checkedIcon.y = checkedIcon.height / 2;
			
		}
		
		private function onYes(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			_status = 1; 
			_exitHandler();
		}
		
		private function onNo(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			_status = 0;
			_exitHandler();
		}
		
		private function changePref(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var sp:Sprite = e.currentTarget as Sprite;
			
			if (sp.numChildren > 0)
				sp.removeChildAt(0);
			else
				sp.addChild(checkedIcon);
			
			switch(_type)
			{
				case LAYER_MERGE: MessagePrefrences.hideMergeWarning = !MessagePrefrences.hideMergeWarning; break;
				
				case LAYER_DELETE: MessagePrefrences.hideDeleteWarning = !MessagePrefrences.hideDeleteWarning; break;
				
				case DONATE: MessagePrefrences.hideDonateWarning = !MessagePrefrences.hideDonateWarning; break;
				
			}
			
			MessagePrefrences.save();
		}
		
		public function get status():int 
		{
			return _status;
		}
	}

}