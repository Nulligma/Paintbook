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
	import fl.transitions.Tween;
	import com.greensock.TweenNano;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ShopUI extends Sprite
	{
		
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		
		private var exitHandler:Function;
		
		private var buttonGroup:Sprite;
		
		public function ShopUI(eH:Function) 
		{
			exitHandler = eH;
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
			
			var sp:Sprite;
			var sp2:Sprite;
			var cT:ColorTransform;
			var tween:TweenNano;
			
			buttonGroup = new Sprite();
			addChild(buttonGroup);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
			sp2 = new themesIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW * 0.01 + sp.width/2;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			//sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, changeShop);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
			sp2 = new BrushesIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = (sp.width*1.5) + sW * 0.02;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			//sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, changeShop);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
			sp2 = new menuIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = (sp.width*2.5) + sW * 0.03;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			//sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, changeShop);
			
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
			sp2 = new CloseIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW * 0.99 - sp.width/2;
			sp.y = sH * 0.01667 + sp.height / 2;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; exitHandler();} );
			
			var textField:TextField;
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.155, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Upload";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, onCancel);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.155, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Create";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.02 + sp.width;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, onCancel);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.05, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "<<";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.99 - (sp.width*3) - (sW*0.02);
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, onCancel);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.05, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.4;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "99/99";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.99 - (sp.width*2) - (sW*0.01);
			sp.y = sH;
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.05, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = ">>";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.99 - sp.width;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, onCancel);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
		}
		
		private function changeShop(e:MouseEvent):void
		{
			var target:Sprite = e.currentTarget as Sprite;
			
			var sp:Sprite; var icon:Sprite; var cT:ColorTransform;
			for(var i:int=0; i<buttonGroup.numChildren;i++)
			{
				sp = buttonGroup.getChildAt(i) as Sprite;
			
				icon = sp.getChildAt(0) as Sprite;
				cT = new ColorTransform();
				
				if(sp == target)
				{
					cT.color = CustomUI.color2;
					sp.graphics.lineStyle(sW*0.001, CustomUI.color2); sp.graphics.beginFill(CustomUI.color1); 
					sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
				}
				else
				{
					cT.color = CustomUI.color1;
					sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
					sp.graphics.drawRect(-sW * 0.05,-sH * 0.0417,sW * 0.1, sH * 0.083); sp.graphics.endFill();
				}
				
				icon.transform.colorTransform = cT;
			}
		}
	}
}