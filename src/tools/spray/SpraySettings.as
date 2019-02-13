﻿package tools.spray 
{
	import fl.transitions.Tween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	
	import colors.setups.ColorSetup;
	import settings.CustomUI;
	import com.greensock.TweenLite;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SpraySettings extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var spray:SprayData = SprayData.instance;
		private var layerList:LayerList = LayerList.instance;
		
		static private var selectedBrush:int = 0;
		static private var brushType:String = "Art";
		
		private var colorSprite:Sprite;
		private var canvasBG:Sprite;
		private var canvasHolder:Sprite;
		private var canvas:Bitmap;
		private var patternHolder:Sprite;
		private var patternBG:Sprite;
		private var indicator:Sprite;
		
		private var txtFormat:TextFormat;
		
		private var typeTxt:TextField;
		private var brushTxt:TextField;
		private var sizeTxt:TextField;
		private var flowTxt:TextField;
		private var blurTxt:TextField;
		private var colorTxt:TextField;
		private var opaqueTxt:TextField;
		private var spaceTxt:TextField;
		private var psizeTxt:TextField;
		
		private var customSlider:CustomSlider;
		private var colorSetup:ColorSetup;
		
		private var index:int = 0;
		
		public function SpraySettings() 
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
			tween = new TweenNano(sp, 0.4, { y:0, ease:Strong.easeOut } );
			
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
			
			var tempText:TextField
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.14, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			tempText = new TextField; tempText.embedFonts = true;
			tempText.defaultTextFormat = txtFormat;
			tempText.text = ">>";
			tempText.selectable = false;
			tempText.autoSize = TextFieldAutoSize.CENTER;
			tempText.x = sp.width / 2 - tempText.width / 2; tempText.y = sp.height / 2 - tempText.height / 2;
			sp.addChild(tempText);
			sp.x = sW * 0.99 - sp.width; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, nextBrushes );
			tween = new TweenNano(sp, 1, { y:sH * 0.0167, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = brushType;
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeType );
			tween = new TweenNano(sp, 0.4, { y:sH * 0.0167, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(0x000000); sp.graphics.drawRect(0, 0, sW * 0.781, sH * 0.1);
			sp.x = sW * 0.21; sp.y = sH * 0.012;
			
			indicator = new Sprite;
			indicator.graphics.beginFill(CustomUI.color2); indicator.graphics.drawRect(0, 0, sH * 0.034, sH * 0.034);
			
			patternBG = new Sprite;
			patternBG.graphics.beginFill(CustomUI.color2); patternBG.graphics.drawRect(0, 0, sW * 0.785, sH * 0.09);
			patternBG.x = sW * 0.208; patternBG.y = -patternBG.height;
			//addChild(patternBG);
			tween = new TweenNano(patternBG, 0.4, { y:sH * 0.012, ease:Strong.easeOut } );
			
			patternHolder = new Sprite;
			addChild(patternHolder);
			generatePatternFor(typeTxt.text);
			patternHolder.x = sW * 0.215; patternHolder.y = -patternHolder.height;
			patternHolder.mask = sp;
			tween = new TweenNano(patternHolder, 0.4, { y:sH * 0.0167, ease:Strong.easeOut } );
			patternHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {patternHolder.startDrag(false, new Rectangle(-patternHolder.width + sW*0.99, sH * 0.0167, patternHolder.width-sW*0.775, 0)); } );
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { patternHolder.stopDrag()} );
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color2); sp.graphics.moveTo(0, 0); sp.graphics.lineTo(sW-sW * 0.02, 0);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			tween = new TweenNano(sp, 0.4, { y:sH * 0.125, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField;sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+spray.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.5, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Flow";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			flowTxt = new TextField;flowTxt.embedFonts = true;
			flowTxt.defaultTextFormat = txtFormat;
			flowTxt.text = "Flow "+Math.round(spray.flow*100)+"%";
			flowTxt.selectable = false;
			flowTxt.autoSize = TextFieldAutoSize.CENTER;
			flowTxt.x = sp.width / 2 - flowTxt.width / 2; flowTxt.y = sp.height / 2 - flowTxt.height / 2;
			sp.addChild(flowTxt);
			sp.x = sW * 0.174; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.6, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Smooth";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			blurTxt = new TextField;blurTxt.embedFonts = true;
			blurTxt.defaultTextFormat = txtFormat;
			blurTxt.text = "Smooth "+spray.smoothness;
			blurTxt.selectable = false;
			blurTxt.autoSize = TextFieldAutoSize.CENTER;
			blurTxt.x = sp.width / 2 - blurTxt.width / 2; blurTxt.y = sp.height / 2 - blurTxt.height / 2;
			sp.addChild(blurTxt);
			sp.x = sW * 0.338; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.7, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Color";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			colorTxt = new TextField;colorTxt.embedFonts = true;
			colorTxt.defaultTextFormat = txtFormat;
			colorTxt.text = "Color";
			colorTxt.selectable = false;
			colorTxt.autoSize = TextFieldAutoSize.CENTER;
			colorTxt.x = sp.width / 2.5 - colorTxt.width / 2; colorTxt.y = sp.height / 2 - colorTxt.height / 2;
			sp.addChild(colorTxt);
			sp.x = sW * 0.502; sp.y = -sp.height;
			colorSprite = new Sprite;
			redrawColorSP();
			colorSprite.x = sp.width - sW * 0.01-colorSprite.width; colorSprite.y = sH * 0.017;
			sp.addChild(colorSprite);
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; colorSetup = new ColorSetup(ToolManager.fillColor, changeColor); addChild(colorSetup); } );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Density";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			spaceTxt = new TextField;spaceTxt.embedFonts = true;
			spaceTxt.defaultTextFormat = txtFormat;
			spaceTxt.text = "Density " + spray.density;
			spaceTxt.selectable = false;
			spaceTxt.autoSize = TextFieldAutoSize.CENTER;
			spaceTxt.x = sp.width / 2 - spaceTxt.width / 2; spaceTxt.y = sp.height / 2 - spaceTxt.height / 2;
			sp.addChild(spaceTxt);
			sp.x = sW * 0.666; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Opaque";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.166, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			opaqueTxt = new TextField;opaqueTxt.embedFonts = true;
			opaqueTxt.defaultTextFormat = txtFormat;
			opaqueTxt.text = "O " + Math.round(spray.alpha) * 100 + "%";
			opaqueTxt.selectable = false;
			opaqueTxt.autoSize = TextFieldAutoSize.CENTER;
			opaqueTxt.x = sp.width / 2 - opaqueTxt.width / 2; opaqueTxt.y = sp.height / 2 - opaqueTxt.height / 2;
			sp.addChild(opaqueTxt);
			sp.x = sW * 0.83; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 1, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Psize";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.225, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			psizeTxt = new TextField;psizeTxt.embedFonts = true;
			psizeTxt.defaultTextFormat = txtFormat;
			psizeTxt.text = "P Size " + spray.psize;
			psizeTxt.selectable = false;
			psizeTxt.autoSize = TextFieldAutoSize.CENTER;
			psizeTxt.x = sp.width / 2 - psizeTxt.width / 2; psizeTxt.y = sp.height / 2 - psizeTxt.height / 2;
			sp.addChild(psizeTxt);
			sp.x = sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.5, { y:sH * 0.25, ease:Strong.easeOut } );
			
			var txtField:TextField;
			
			for (var i:int = 1; i < 4; i++)
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.225, sH * 0.083); sp.graphics.endFill();
				txtFormat.size = sp.height * 0.56;
				txtFormat.color = CustomUI.color1;
				txtField = new TextField;txtField.embedFonts = true;
				txtField.defaultTextFormat = txtFormat;
				
				if (i == 1) { sp.name = "Random Rotate"; txtField.text = "Rotate"; sp.alpha = spray.randomRotate?1:0.7; }
				if (i == 2) { sp.name = txtField.text = "Scattering"; sp.alpha = spray.scattering?1:0.7; }
				if (i == 3) { sp.name = "Random Color";txtField.text = "Colors"; sp.alpha = spray.randomColor?1:0.7; }
				
				txtField.selectable = false;
				txtField.autoSize = TextFieldAutoSize.CENTER;
				txtField.x = sp.width / 2 - txtField.width / 2; txtField.y = sp.height / 2 - txtField.height / 2;
				sp.addChild(txtField);
				sp.x = (sW * 0.245 * i) + sW * 0.02; sp.y = -sp.height;
				addChild(sp);
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, changeBools );
				tween = new TweenNano(sp, 0.6+i/10, { y:sH * 0.25, ease:Strong.easeOut } );
			}
			
			canvasBG = new Sprite;
			canvasBG.graphics.beginFill(CustomUI.color1); canvasBG.graphics.drawRect(0, 0, sW * 0.488, sH * 0.5); canvasBG.graphics.endFill();
			canvasBG.graphics.beginFill(CustomUI.color2); canvasBG.graphics.drawRect(sW * 0.02, sH * 0.1, sW * 0.488 - sW * 0.04, sH * 0.5 - sH * 0.117);
			canvasBG.x = sW / 1.5; canvasBG.y = sH * 0.4;
			addChild(canvasBG);
			
			canvas = new Bitmap;
			canvas.bitmapData = new BitmapData(sW * 0.488 - sW * 0.06, sH * 0.5 - sH * 0.15, false, 0xFFFFFF);
			
			canvasHolder = new Sprite;
			canvasHolder.x = sW * 0.03; canvasHolder.y = sH * 0.117;
			addChild(canvasHolder);
			canvasHolder.addChild(canvas);
			canvasBG.addChild(canvasHolder);
			
			sp = new Sprite;
			sp.name = "Clear";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			txtField = new TextField;txtField.embedFonts = true;
			txtField.defaultTextFormat = txtFormat;
			txtField.text = "Clear";
			txtField.selectable = false;
			txtField.autoSize = TextFieldAutoSize.CENTER;
			txtField.x = sp.width / 2 - txtField.width / 2; txtField.y = sp.height / 2 - txtField.height / 2;
			sp.addChild(txtField);
			sp.x = canvasBG.width - sW * 0.02-sp.width; sp.y = sH * 0.008;
			canvasBG.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; canvas.bitmapData.fillRect(canvas.bitmapData.rect, 0xFFFFFF); } );
			
			txtFormat.color = CustomUI.color2;
			txtField = new TextField;txtField.embedFonts = true;
			txtField.defaultTextFormat = txtFormat;
			txtField.text = "Draw Here";
			txtField.selectable = false;
			txtField.autoSize = TextFieldAutoSize.CENTER;
			txtField.x = sW*0.02; txtField.y = sH * 0.008;
			canvasBG.addChild(txtField);
			
			tween = new TweenNano(canvasBG, 1, { x:sW / 2 - canvasBG.width / 2, ease:Strong.easeOut } );
			
			ToolManager.workArea(canvasHolder, canvas.bitmapData);
		}
		
		private function generatePatternFor(type:String):void 
		{
			while (patternHolder.numChildren > 0)
			{
				patternHolder.removeChildAt(0);
			}
			patternHolder.x = sW * 0.215;
			
			var patternArray:Array = new Array;
			
			patternArray = spray.getSprites(type);
			
			var sp:Sprite; var i:int = 0; var bm:Bitmap; var mat:Matrix;var pattern:Sprite;
			for(i = 0 ; i<6 ; i++)
			{
				pattern = patternArray[i+index];
				sp = new Sprite; bm = new Bitmap; mat = new Matrix;
				sp.graphics.lineStyle(4, CustomUI.color2); sp.graphics.beginFill(0xFFFFFF);
				sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
				sp.name = String(i);
				
				mat.scale(0.9*(sH * 0.083/50), 0.9*(sH * 0.083/50));
				mat.tx = sW * 0.05; mat.ty = sH * 0.0417;
				
				bm.bitmapData = new BitmapData(sW * 0.1, sH * 0.083);
				bm.bitmapData.draw(pattern, mat);
				
				sp.addChild(bm);
				if (i == selectedBrush) sp.addChild(indicator);
				
				sp.x = i * sW * 0.1;
				patternHolder.addChild(sp);
				
				sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { spray.changePattern(typeTxt.text, int(e.currentTarget.name)); e.currentTarget.addChild(indicator); selectedBrush = int(e.currentTarget.name); } );
			}
		}
		
		private function nextBrushes(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var patternArray:Array = spray.getSprites(typeTxt.text);
			
			if(patternArray[index+6] == null) index = 0;
			else							  index += 6;
			
			spray.changePattern(typeTxt.text, index);
			generatePatternFor(typeTxt.text);
		}
		
		private function changeColor():void 
		{
			removeChild(colorSetup);
			ToolManager.fillColor = colorSetup.color;
			redrawColorSP();
			
			colorSetup = null;
		}
		
		private function changeType(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (typeTxt.text == "Art") 
			{
				typeTxt.text = "Calligraphy";
			}
			else if (typeTxt.text == "Calligraphy") 
			{
				typeTxt.text = "Art";
			}
			
			index = 0;
			
			brushType = typeTxt.text;
			selectedBrush = 0;
			generatePatternFor(typeTxt.text);
			spray.changePattern(typeTxt.text, 0);
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Spray Size", spray.size, 1, 200);
				break;
				
				case "Flow":
					customSlider = new CustomSlider("Spray Flow", spray.flow*100, 0, 100);
				break;
				
				case "Smooth":
					customSlider = new CustomSlider("Smoothness", spray.smoothness, 0, 10);
				break;
				
				case "Density":
					customSlider = new CustomSlider("Denisty of particles", spray.density, 1, 100);
				break;
				
				case "Opaque":
					customSlider = new CustomSlider("Color Opacity", spray.alpha*100, 0, 100);
				break;
				
				case "Psize":
					customSlider = new CustomSlider("Particle Size", spray.psize, 1, 50);
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
					spray.size = customSlider.value;
					sizeTxt.text = "Size " + spray.size;
				break;
				
				case "Flow":
					spray.flow = customSlider.value/100;
					flowTxt.text = "Flow " + customSlider.value+"%";
				break;
				
				case "Smooth":
					spray.smoothness = customSlider.value;
					blurTxt.text = "Smooth " + spray.smoothness;
				break;
				
				case "Density":
					spray.density = customSlider.value;
					spaceTxt.text = "Density " + spray.density;
				break;
				
				case "Opaque":
					spray.alpha = customSlider.value / 100;
					opaqueTxt.text = "O " + customSlider.value+"%";
				break;
				
				case "Psize":
					spray.psize = customSlider.value;
					psizeTxt.text = "P Size " + customSlider.value;
				break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function changeBools(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			e.currentTarget.alpha = e.currentTarget.alpha == 1?0.7:1;
			
			switch(e.currentTarget.name)
			{
				case "Random Rotate":
					spray.randomRotate = !spray.randomRotate; break;
				
				case "Scattering":
					spray.scattering = !spray.scattering; break;
				
				case "Random Color":
					spray.randomColor = !spray.randomColor; break;
			}
		}
		
		private function redrawColorSP():void
		{
			colorSprite.graphics.clear(); 
			colorSprite.graphics.lineStyle(sH*0.003, CustomUI.color1);
			colorSprite.graphics.beginFill(ToolManager.fillColor);colorSprite.graphics.drawRect(0,0,sH * 0.05, sH * 0.05);
		}
		
		private function onBack(e:MouseEvent):void 
		{
			var tween:TweenNano = new TweenNano(this, 0.5, { y: -height, ease:Linear.easeIn, onComplete:removeMe } );
			
			ToolManager.workArea(System.canvas, layerList.currentLayer);
		}
		
		private function removeMe():void 
		{
			BackBoard.instance.removeChild(this);
		}
		
	}

}