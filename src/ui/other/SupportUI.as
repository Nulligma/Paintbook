package ui.other 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SupportUI extends Sprite
	{
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		private var _exitHandler:Function;
		
		public function SupportUI(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
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
			var sp2:Sprite;
			var textField:TextField
			var cT:ColorTransform;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Support";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW / 2 - textField.width / 2;
			textField.y = -textField.height;
			addChild(textField);
			TweenLite.to(textField, 1, { y: sH * 0.05, ease:Strong.easeOut } );
			
			for (var i:int = 0; i < 3; i++) 
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW * 0.293, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				
				if (i == 0)
				{
					textField.text = sp.name = "Mail";
					sp2 = new MailIcon;
				}
				else if (i == 1)
				{
					textField.text = sp.name = "Facebook";
					sp2 = new FbIcon;
				}
				else
				{
					textField.text = sp.name = "Twitter";
					sp2 = new twitterIcon;
				}
				
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
				cT = new ColorTransform;
				cT.color = CustomUI.color2;
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width - sp2.width / 2 - sW * 0.01;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
				addChild(sp);
				sp.x = -sp.width;
				sp.y = sH * 0.5 - sp.height - sH * 0.033;
				TweenLite.to(sp, 1, { x: sW * 0.0502 + i * (sp.width + sW * 0.01) , ease:Strong.easeOut } );
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, goToLink);
			}
			
			var msg:String = "Found a bug? Or have a nice suggestion for PaintBook?\nContact Us by any of the above method";
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			txtFormat.align = "center";
			textField.defaultTextFormat = txtFormat;
			textField.text = msg;
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW;
			textField.y = sH * 0.5 + sH * 0.033;
			addChild(textField);
			TweenLite.to(textField, 1, { x: sW / 2 - textField.width / 2, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Back";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack);
			TweenLite.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
		}
		
		private function goToLink(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			_exitHandler();
		}
		
	}

}