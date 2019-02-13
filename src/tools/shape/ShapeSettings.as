package tools.shape 
{
	import colors.setups.ColorSetup;
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
	import tools.ToolManager;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ShapeSettings extends Sprite
	{
		private var shape:ShapeData = ShapeData.instance;
		private var typeTxt:TextField;
		private var sizeTxt:TextField;
		private var thickTxt:TextField;
		private var edgeTxt:TextField;
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var colorSetup:ColorSetup;
		private var colorTxt:TextField;
		private var linecolorSprite:Sprite;
		private var fillColorSprite:Sprite;
		private var customSlider:CustomSlider;
		private var designTxt:TextField;
		
		public function ShapeSettings() 
		{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor); graphics.drawRect(0, 0, sW, sH); graphics.endFill();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			var sp:Sprite;
			var tween:TweenNano;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW, sH * 0.359); sp.graphics.endFill();
			addChild(sp);
			sp.y = -sp.height;
			tween = new TweenNano(sp, 0.7, { y:0, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color2;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = "Back";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW * 0.01; sp.y = sH;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack );
			tween = new TweenNano(sp, 1, { y:sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField;sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+shape.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.073, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Thickness";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			thickTxt = new TextField;thickTxt.embedFonts = true;
			thickTxt.defaultTextFormat = txtFormat;
			thickTxt.text = "Thickness " + shape.lineThickness;
			thickTxt.selectable = false;
			thickTxt.autoSize = TextFieldAutoSize.CENTER;
			thickTxt.x = sp.width / 2 - thickTxt.width / 2; thickTxt.y = sp.height / 2 - thickTxt.height / 2;
			sp.addChild(thickTxt);
			sp.x = sW * 0.347; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.073, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Edges";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			edgeTxt = new TextField;edgeTxt.embedFonts = true;
			edgeTxt.defaultTextFormat = txtFormat;
			edgeTxt.text = "Edges "+shape.edges;
			edgeTxt.selectable = false;
			edgeTxt.autoSize = TextFieldAutoSize.CENTER;
			edgeTxt.x = sp.width / 2 - edgeTxt.width / 2; edgeTxt.y = sp.height / 2 - edgeTxt.height / 2;
			sp.addChild(edgeTxt);
			sp.x = sW * 0.674; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 1, { y:sH * 0.073, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Type";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			designTxt = new TextField;designTxt.embedFonts = true;
			designTxt.defaultTextFormat = txtFormat;
			designTxt.text = "Type "+shape.designType;
			designTxt.selectable = false;
			designTxt.autoSize = TextFieldAutoSize.CENTER;
			designTxt.x = sp.width / 2 - designTxt.width / 2; designTxt.y = sp.height / 2 - designTxt.height / 2;
			sp.addChild(designTxt);
			sp.x = sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.25 , ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "linecolor";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			colorTxt = new TextField;colorTxt.embedFonts = true;
			colorTxt.defaultTextFormat = txtFormat;
			colorTxt.text = "linecolor";
			colorTxt.selectable = false;
			colorTxt.autoSize = TextFieldAutoSize.CENTER;
			colorTxt.x = sp.width / 2.5 - colorTxt.width / 2; colorTxt.y = sp.height / 2 - colorTxt.height / 2;
			sp.addChild(colorTxt);
			sp.x = sW * 0.347; sp.y = -sp.height;
			linecolorSprite = new Sprite;
			redrawColorSP(linecolorSprite);
			linecolorSprite.x = sp.width - sW * 0.01-linecolorSprite.width; linecolorSprite.y = sH * 0.017;
			sp.addChild(linecolorSprite);
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; colorSetup = new ColorSetup(ToolManager.lineColor, changelineColor); addChild(colorSetup); } );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.25 , ease:Strong.easeOut } );
			
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "fillcolor";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			colorTxt = new TextField;colorTxt.embedFonts = true;
			colorTxt.defaultTextFormat = txtFormat;
			colorTxt.text = "fillcolor";
			colorTxt.selectable = false;
			colorTxt.autoSize = TextFieldAutoSize.CENTER;
			colorTxt.x = sp.width / 2.5 - colorTxt.width / 2; colorTxt.y = sp.height / 2 - colorTxt.height / 2;
			sp.addChild(colorTxt);
			sp.x = sW * 0.674; sp.y = -sp.height;
			fillColorSprite = new Sprite;
			redrawColorSP(fillColorSprite);
			fillColorSprite.x = sp.width - sW * 0.01-fillColorSprite.width; fillColorSprite.y = sH * 0.017;
			sp.addChild(fillColorSprite);
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; colorSetup = new ColorSetup(ToolManager.fillColor, changeFillColor); addChild(colorSetup); } );
			tween = new TweenNano(sp, 1, { y:sH * 0.25 , ease:Strong.easeOut } );
			
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Shape Size", shape.size, 1, 200);
				break;
				
				case "Thickness":
					customSlider = new CustomSlider("Line Thickness", shape.lineThickness, 0, 50);
				break;
				
				case "Edges":
					customSlider = new CustomSlider("Edges in Shape", shape.edges, 1, 30);
				break;
				
				case "Type":
					customSlider = new CustomSlider("Shape Type ", shape.typeArray.indexOf(shape.designType), 0, shape.typeArray.length-1,shape.typeArray);
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
					shape.size = customSlider.value;
					sizeTxt.text = "Size " + shape.size;
				break;
				
				case "Thickness":
					shape.lineThickness = customSlider.value;
					thickTxt.text = "Thickness " + customSlider.value;
				break;
				
				case "Edges":
					shape.edges = customSlider.value;
					edgeTxt.text = "Edges " + shape.edges;
				break;
				
				case "Type":
					shape.designType = shape.typeArray[customSlider.value] as String;
					designTxt.text = "Type " + shape.designType;
				break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function redrawColorSP(sprite:Sprite):void 
		{
			sprite.graphics.clear(); 
			sprite.graphics.lineStyle(sH * 0.003, CustomUI.color1);
			
			if (sprite == linecolorSprite)
				sprite.graphics.beginFill(ToolManager.lineColor);
			else
				sprite.graphics.beginFill(ToolManager.fillColor);
			
			sprite.graphics.drawRect(0,0,sH * 0.05, sH * 0.05);
		}
		
		private function changelineColor():void 
		{
			removeChild(colorSetup);
			ToolManager.lineColor = colorSetup.color;
			redrawColorSP(linecolorSprite);
			
			colorSetup = null;
		}
		
		private function changeFillColor():void 
		{
			removeChild(colorSetup);
			ToolManager.fillColor = colorSetup.color;
			redrawColorSP(fillColorSprite);
			
			colorSetup = null;
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