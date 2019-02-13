package ui.other 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import settings.CustomUI;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class HelpUI extends Sprite
	{
		private var _exitHandler:Function;
		private var sW:int;
		private var sH:int;
		private var videoHolder:Sprite;
		private var supportHolder:Sprite;
		private var txtFormat:TextFormat;
		
		public function HelpUI(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var sp:Sprite; var textField:TextField;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Help";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			TweenLite.to(textField, 0.6, { x: sW * 0.1, ease:Strong.easeOut } );
			
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
			sp.x = -sp.width;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack);
			TweenLite.to(sp, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Video";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.33;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addVideoHolder);
			TweenLite.to(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Support";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.45;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addSupportHolder);
			TweenLite.to(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
		}
		
		private function addVideoHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (videoHolder) return;
			
			removeSubMenu();
			
			videoHolder = new Sprite;
			
			videoHolder.graphics.beginFill(CustomUI.color1);
			videoHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			videoHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField; var sp2:Sprite;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0,0,sW * 0.43, sH * 0.46); sp.graphics.endFill();
			sp2 = new VideoIcon;
			sp2.x = sW * 0.02;
			sp2.y = sH * 0.033;
			sp.addChild(sp2);
			sp.x = sW * 0.0488;
			sp.y = sH *0.5 - sp.height / 2;
			videoHolder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, onVideo);
			
			videoHolder.x = sW * 0.5 + videoHolder.width * 0.5;
			
			addChild(videoHolder);
			TweenLite.to(videoHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function onVideo(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var req:URLRequest;
			req = new URLRequest("http://www.youtube.com/watch?v=XyftsBxDkyo"); 
			navigateToURL(req, "_blank");
		}
		
		private function addSupportHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (supportHolder) return;
			
			removeSubMenu();
			
			supportHolder = new Sprite;
			
			supportHolder.graphics.beginFill(CustomUI.color1);
			supportHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			supportHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField; var sp2:Sprite; var cT:ColorTransform;
			
			for (var i:int = 0; i < 3; i++) 
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); 
				sp.graphics.drawRect(0, 0, sW * 0.4297, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
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
				cT.color = CustomUI.color1;
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width - sp2.width / 2 - sW * 0.01;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
				sp.x = sW * 0.0488;
				sp.y = sH * 0.0667 + i*(sp.height + sH * 0.083);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, goToLink);
				supportHolder.addChild(sp);
			}
			
			supportHolder.x = sW * 0.5 + supportHolder.width * 0.5;
			
			addChild(supportHolder);
			TweenLite.to(supportHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function goToLink(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			var req:URLRequest;
			
			if (e.currentTarget.name == "Facebook")
			{
				req = new URLRequest("http://www.facebook.com/pages/GrafixGames/179078332129073"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Twitter")
			{
				req = new URLRequest("https://twitter.com/GrafixGames"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Mail")
			{
				req = new URLRequest("mailto:grafixgames@gmail.com"); 
				navigateToURL(req, "_blank");
			}
		}
		
		private function removeSubMenu():void 
		{
			if (videoHolder && videoHolder.stage)
			{
				TweenLite.to(videoHolder, 0.5, { x: sW * 0.5 + videoHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(videoHolder); videoHolder = null; } } );
			}
			if (supportHolder && supportHolder.stage)
			{
				TweenLite.to(supportHolder, 0.5, { x: sW * 0.5 + supportHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(supportHolder); supportHolder = null; } } );
			}
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			_exitHandler();
		}
		
	}

}