package tools.blur 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BlurSettings extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var txtFormat:TextFormat;
		
		private var blur:BlurData = BlurData.instance;
		private var tween:TweenNano;
		private var sizeTxt:TextField;
		private var strengthTxt:TextField;
		private var typeTxt:TextField;
		private var customSlider:CustomSlider;
		
		private var typeArray:Array = ["Blur", "Sharpen", "Dodge", "Burn"];
		
		public function BlurSettings() 
		{
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
			txtFormat.size = sH * 0.083 * 0.6;
			
			var sp:Sprite;
			var txtField:TextField;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW, sH * 0.359); sp.graphics.endFill();
			addChild(sp);
			sp.y = -sp.height;
			tween = new TweenNano(sp, 0.5, { y:0, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Type";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			typeTxt = new TextField; typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = blur.type == 0?"Blur":(blur.type == 1?"Sharpen":(blur.type == 2?"Dodge":"Burn"));
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.217, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField; sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+blur.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.347; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.217, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Str";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			strengthTxt = new TextField; strengthTxt.embedFonts = true;
			strengthTxt.defaultTextFormat = txtFormat;
			strengthTxt.text = "Strength "+blur.strength*10;
			strengthTxt.selectable = false;
			strengthTxt.autoSize = TextFieldAutoSize.CENTER;
			strengthTxt.x = sp.width / 2 - strengthTxt.width / 2; strengthTxt.y = sp.height / 2 - strengthTxt.height / 2;
			sp.addChild(strengthTxt);
			sp.x = sW * 0.674; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 1, { y:sH * 0.217, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.6;
			txtFormat.color = CustomUI.color2;
			txtField = new TextField; txtField.embedFonts = true;
			txtField.defaultTextFormat = txtFormat;
			txtField.text = "Back";
			txtField.selectable = false;
			txtField.autoSize = TextFieldAutoSize.CENTER;
			txtField.x = sp.width / 2 - txtField.width / 2; txtField.y = sp.height / 2 - txtField.height / 2;
			sp.addChild(txtField);
			sp.x = sW * 0.01; sp.y = sH;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack );
			tween = new TweenNano(sp, 1, { y:sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
		}
		
		private function changeVars(e:Event):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Size", blur.size, 1, 200);
				break;
				
				case "Type":
					customSlider = new CustomSlider("Type ", blur.type, 0, 3, typeArray);
				break;
				
				case "Str":
					customSlider = new CustomSlider("Strength", blur.strength*10, 1, 100);
				break;
				
			}
			
			customSlider.name = e.currentTarget.name;
			addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			switch(e.currentTarget.name)
			{
				case "Size":
					blur.size = customSlider.value;
					sizeTxt.text = "Size " + blur.size;
				break;
				
				case "Type":
					blur.type = customSlider.value;
					typeTxt.text = typeArray[customSlider.value];
				break;
				
				case "Str":
					blur.strength = customSlider.value/10;
					strengthTxt.text = "Strength " + customSlider.value;
				break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function onBack(e:MouseEvent):void 
		{
			var tween:TweenNano = new TweenNano(this, 0.5, { y: -height, ease:Linear.easeIn, onComplete:removeMe } );
		}
		
		private function removeMe():void 
		{
			BackBoard.instance.removeChild(this);
		}
	}

}