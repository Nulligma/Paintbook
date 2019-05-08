package tools.brushes 
{
	import fl.transitions.Tween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.filters.FiltersManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	
	import colors.setups.ColorSetup;
	import settings.CustomUI;
	/**
	 * ...
	 * @author ...
	 */
	public class BrushSettings extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var brush:BrushData = BrushData.instance;
		
		static private var selectedBrush:int = 0;
		static private var brushType:String = "Art";
		
		private var psArray:Array = ["Off", "Low", "Med", "High"];
		
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
		private var spaceTxt:TextField;
		private var opaqueTxt:TextField;
		private var psTxt:TextField;
		
		private var index:int = 0;
		
		private var customSlider:CustomSlider;
		private var colorSetup:ColorSetup;
		
		private var layerList:LayerList = LayerList.instance;
		
		public function BrushSettings() 
		{
			TweenPlugin.activate([TransformMatrixPlugin]);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			selectedBrush = brush.brushIndex;
			brushType = brush.type;
			
			graphics.beginFill(CustomUI.backColor); graphics.drawRect(0, 0, sW, sH); graphics.endFill();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			var sp:Sprite;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW, sH * 0.359); sp.graphics.endFill();
			addChild(sp);
			sp.y = -sp.height;
			TweenLite.to(sp, 0.4, { transformMatrix:{ y:0 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color2;
			typeTxt = new TextField; typeTxt.embedFonts = true;
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
			TweenLite.to(sp, 1, { transformMatrix:{ y:sH - sH * 0.016 - sp.height }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color2;
			typeTxt = new TextField; typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = "Save";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW - sp.width - sW * 0.01; sp.y = sH;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onSave );
			TweenLite.to(sp, 1, { transformMatrix:{ y:sH - sH * 0.016 - sp.height }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			typeTxt = new TextField; typeTxt.embedFonts = true;
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
			TweenLite.to(sp, 0.4, { transformMatrix:{ y:sH * 0.0167 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(0x000000); sp.graphics.drawRect(0, 0, sW * 0.781, sH * 0.1);
			sp.x = sW * 0.21; sp.y = sH * 0.012;
			
			indicator = new Sprite;
			indicator.graphics.beginFill(CustomUI.color2); indicator.graphics.drawRect(0, 0, sH * 0.034, sH * 0.034);
			
			patternBG = new Sprite;
			patternBG.graphics.beginFill(CustomUI.color2); patternBG.graphics.drawRect(0, 0, sW * 0.785, sH * 0.09);
			patternBG.x = sW * 0.208; patternBG.y = -patternBG.height;
			addChild(patternBG);
			TweenLite.to(sp, 0.4, { transformMatrix:{ y:sH * 0.012 }, ease:Strong.easeOut } );
			
			patternHolder = new Sprite;
			addChild(patternHolder);
			generatePatternFor(brushType);
			patternHolder.x = sW * 0.215; patternHolder.y = -patternHolder.height;
			patternHolder.mask = sp;
			TweenLite.to(patternHolder, 0.4, { transformMatrix:{ y:sH * 0.0167 }, ease:Strong.easeOut } );
			//patternHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {patternHolder.startDrag(false, new Rectangle(-patternHolder.width + sW*0.99, sH * 0.0167, patternHolder.width-sW*0.775, 0)); } );
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { patternHolder.stopDrag()} );
			
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
			TweenLite.to(sp, 0.4, { transformMatrix:{ y:sH * 0.0167 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color2); sp.graphics.moveTo(0, 0); sp.graphics.lineTo(sW-sW * 0.02, 0);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			TweenLite.to(sp, 0.4, { transformMatrix:{ y:sH * 0.125 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField;sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+brush.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 0.5, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Flow";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			flowTxt = new TextField;flowTxt.embedFonts = true;
			flowTxt.defaultTextFormat = txtFormat;
			flowTxt.text = "Flow "+int(brush.flow*100)+"%";
			flowTxt.selectable = false;
			flowTxt.autoSize = TextFieldAutoSize.CENTER;
			flowTxt.x = sp.width / 2 - flowTxt.width / 2; flowTxt.y = sp.height / 2 - flowTxt.height / 2;
			sp.addChild(flowTxt);
			sp.x = sW * 0.174; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 0.6, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			sp.name = "Smooth";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			blurTxt = new TextField;blurTxt.embedFonts = true;
			blurTxt.defaultTextFormat = txtFormat;
			blurTxt.text = "Smooth "+brush.smoothness;
			blurTxt.selectable = false;
			blurTxt.autoSize = TextFieldAutoSize.CENTER;
			blurTxt.x = sp.width / 2 - blurTxt.width / 2; blurTxt.y = sp.height / 2 - blurTxt.height / 2;
			sp.addChild(blurTxt);
			sp.x = sW * 0.338; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 0.7, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "PS";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			psTxt = new TextField;psTxt.embedFonts = true;
			psTxt.defaultTextFormat = txtFormat;
			psTxt.text = "PS " + psArray[brush.pressureSensivity];
			psTxt.selectable = false;
			psTxt.autoSize = TextFieldAutoSize.CENTER;
			psTxt.x = sp.width / 2 - psTxt.width / 2; psTxt.y = sp.height / 2 - psTxt.height / 2;
			sp.addChild(psTxt);
			sp.x = sW * 0.502; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 0.8, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Space";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.154, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			spaceTxt = new TextField;spaceTxt.embedFonts = true;
			spaceTxt.defaultTextFormat = txtFormat;
			spaceTxt.text = "Space " + brush.spacing;
			spaceTxt.selectable = false;
			spaceTxt.autoSize = TextFieldAutoSize.CENTER;
			spaceTxt.x = sp.width / 2 - spaceTxt.width / 2; spaceTxt.y = sp.height / 2 - spaceTxt.height / 2;
			sp.addChild(spaceTxt);
			sp.x = sW * 0.666; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 0.9, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Opaque";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.166, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			opaqueTxt = new TextField;opaqueTxt.embedFonts = true;
			opaqueTxt.defaultTextFormat = txtFormat;
			opaqueTxt.text = "O " + brush.alpha * 100 + "%";
			opaqueTxt.selectable = false;
			opaqueTxt.autoSize = TextFieldAutoSize.CENTER;
			opaqueTxt.x = sp.width / 2 - opaqueTxt.width / 2; opaqueTxt.y = sp.height / 2 - opaqueTxt.height / 2;
			sp.addChild(opaqueTxt);
			sp.x = sW * 0.83; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			TweenLite.to(sp, 1, { transformMatrix:{ y:sH * 0.15 }, ease:Strong.easeOut } );
			
			var txtField:TextField;
			
			for (var i:int = 0; i < 5; i++)
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
				txtFormat.size = sp.height * 0.56;
				txtFormat.color = CustomUI.color1;
				txtField = new TextField;txtField.embedFonts = true;
				txtField.defaultTextFormat = txtFormat;
				
				if (i == 0) { sp.name = txtField.text = "X-Symmetry"; sp.alpha = brush.xSymmetry?1:0.7; }
				if (i == 1) { sp.name = txtField.text = "Y-Symmetry"; sp.alpha = brush.ySymmetry?1:0.7; }
				if (i == 2) { sp.name = "Random Rotate"; txtField.text = "Rotate"; sp.alpha = brush.randomRotate?1:0.7; }
				if (i == 3) { sp.name = txtField.text = "Scattering"; sp.alpha = brush.scattering?1:0.7; }
				if (i == 4) { sp.name = "Random Color";txtField.text = "Colors"; sp.alpha = brush.randomColor?1:0.7; }
				
				txtField.selectable = false;
				txtField.autoSize = TextFieldAutoSize.CENTER;
				txtField.x = sp.width / 2 - txtField.width / 2; txtField.y = sp.height / 2 - txtField.height / 2;
				sp.addChild(txtField);
				sp.x = (sW * 0.195 * i) + sW*0.02; sp.y = -sp.height;
				addChild(sp);
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, changeBools );
				TweenLite.to(sp, 0.6 + i / 10, { transformMatrix:{ y:sH * 0.25 }, ease:Strong.easeOut } );
			}
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); sp.graphics.drawRect(0, 0, sW * 0.1, sW * 0.1); sp.graphics.endFill();
			sp.name = "Color";
			txtFormat.size = sH * 0.083 * 0.56;
			txtFormat.color = CustomUI.color2;
			colorTxt = new TextField;colorTxt.embedFonts = true;
			colorTxt.defaultTextFormat = txtFormat;
			colorTxt.text = "Color";
			colorTxt.selectable = false;
			colorTxt.autoSize = TextFieldAutoSize.CENTER;
			colorTxt.x = sp.width * 0.5 - colorTxt.width * 0.5; /*colorTxt.y = sp.height / 2 - colorTxt.height / 2;*/
			sp.addChild(colorTxt);
			sp.x = -sp.width; sp.y = sH * 0.55;
			colorSprite = new Sprite;
			redrawColorSP();
			colorSprite.x = sp.width * 0.5 - colorSprite.width * 0.5; colorSprite.y = sp.height - colorSprite.height - sH * 0.01;
			sp.addChild(colorSprite);
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; colorSetup = new ColorSetup(brush.fillColor, changeColor); addChild(colorSetup); } );
			TweenLite.to(sp, 1, { transformMatrix: { x:sW * 0.02 }, ease:Strong.easeOut } );
			
			canvasBG = new Sprite;
			canvasBG.graphics.beginFill(CustomUI.color1); canvasBG.graphics.drawRect(0, 0, sW * 0.488, sH * 0.5); canvasBG.graphics.endFill();
			canvasBG.graphics.beginFill(CustomUI.color2); canvasBG.graphics.drawRect(sW * 0.02, sH * 0.1, sW * 0.488 - sW * 0.04, sH * 0.5 - sH * 0.117);
			canvasBG.x = sW / 1.7 - canvasBG.width * 0.5; canvasBG.y = sH * 0.4;
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
			TweenLite.to(canvasBG, 1, { transformMatrix:{ x:sW / 2 - canvasBG.width / 2 }, ease:Strong.easeOut, cacheAsBitmap:true } );
			
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
			
			patternArray = brush.getSprites(type);
			
			var fM:FiltersManager = FiltersManager.getInstance();
			var sp:Sprite; var i:int; var bm:Bitmap; var mat:Matrix; var blur:BlurFilter;var pattern:Sprite;
			for(i = 0 ; i<6 ; i++)
			{
				pattern = patternArray[i+index];

				if(pattern == null) return;
				
				sp = new Sprite; bm = new Bitmap; mat = new Matrix;
				sp.graphics.lineStyle(4, CustomUI.color2); sp.graphics.beginFill(0xFFFFFF);
				sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
				sp.name = String(i+index);
				
				blur = new BlurFilter(brush.smoothness, brush.smoothness, 2);
				fM.remove(pattern, blur);
				
				mat.scale(0.9*(sH * 0.083/50), 0.9*(sH * 0.083/50));
				mat.tx = sW * 0.05; mat.ty = sH * 0.0417;
				
				bm.bitmapData = new BitmapData(sW * 0.1, sH * 0.083);
				bm.bitmapData.draw(pattern, mat);
				
				fM.add(pattern, blur);
				sp.addChild(bm);
				if (i == selectedBrush) sp.addChild(indicator);
				
				sp.x = i * sW * 0.1;
				patternHolder.addChild(sp);
				
				sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { brush.changePattern(typeTxt.text, int(e.currentTarget.name)); e.currentTarget.addChild(indicator); selectedBrush = int(e.currentTarget.name)} );
			}
		}
		
		private function changeColor():void 
		{
			removeChild(colorSetup);
			brush.fillColor = colorSetup.color;
			redrawColorSP();
			
			colorSetup = null;
		}
		
		private function nextBrushes(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var patternArray:Array = brush.getSprites(typeTxt.text);
			
			if(patternArray[index+6] == null) index = 0;
			else							  index += 6;
			
			brush.changePattern(typeTxt.text, index);
			generatePatternFor(typeTxt.text);
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
			brush.changePattern(typeTxt.text, 0);
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Brush Size", brush.size, 1, 200);
				break;
				
				case "Flow":
					customSlider = new CustomSlider("Brush flow", brush.flow*100, 0, 100);
				break;
				
				case "Smooth":
					customSlider = new CustomSlider("Smoothness", brush.smoothness, 0, 10);
				break;
				
				case "Space":
					customSlider = new CustomSlider("Spacing in pattern", brush.spacing, 1, 100);
				break;
				
				case "Opaque":
					customSlider = new CustomSlider("Color opacity", brush.alpha*100, 0, 100);
				break;
				
				case "PS":
					customSlider = new CustomSlider("Pressure simulation ", brush.pressureSensivity, 0, 3, psArray);
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
					brush.size = customSlider.value;
					sizeTxt.text = "Size " + customSlider.value;
				break;
				
				case "Flow":
					brush.flow = customSlider.value/100;
					flowTxt.text = "Flow " + customSlider.value+"%";
				break;
				
				case "Smooth":
					brush.smoothness = customSlider.value;
					blurTxt.text = "Smooth " + customSlider.value;
				break;
				
				case "Space":
					brush.spacing = customSlider.value;
					spaceTxt.text = "Space " + customSlider.value;
				break;
				
				case "Opaque":
					brush.alpha = customSlider.value / 100;
					opaqueTxt.text = "O " + customSlider.value+"%";
				break;
				
				case "PS":
					brush.pressureSensivity = customSlider.value;
					psTxt.text = "PS " + psArray[customSlider.value];
					if (brush.pressureSensivity != 0)
					{
						brush.scattering = false;
						for (var i:int = 0; i < this.numChildren; i++)
						{
							if (this.getChildAt(i).name == "Scattering")
							{
								this.getChildAt(i).alpha = 0.5; break;
							}
						}
					}
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
				case "X-Symmetry":
					brush.xSymmetry = !brush.xSymmetry; break;
				
				case "Y-Symmetry":
					brush.ySymmetry = !brush.ySymmetry; break;
				
				case "Random Rotate":
					brush.randomRotate = !brush.randomRotate; break;
				
				case "Scattering":
					brush.scattering = !brush.scattering;
					brush.pressureSensivity = 0;
					psTxt.text = "PS Off";
				break;
				
				case "Random Color":
					brush.randomColor = !brush.randomColor; break;
			}
		}
		
		private function redrawColorSP():void
		{
			colorSprite.graphics.clear(); 
			colorSprite.graphics.lineStyle(2, CustomUI.color2);
			colorSprite.graphics.beginFill(brush.fillColor);colorSprite.graphics.drawRect(0,0,sW * 0.04, sW * 0.04);
		}
		
		private function onBack(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.5, { transformMatrix: { y: -height }, ease:Linear.easeIn, onComplete:removeMe } );
			
			ToolManager.workArea(System.canvas, layerList.currentLayer);
		}
		
		private function onSave(e:MouseEvent):void 
		{
			ToolManager.workArea(System.canvas, layerList.currentLayer);
			
			BackBoard.instance.addChild(new SaveInterface());
			
			BackBoard.instance.removeChild(this);
		}
		
		private function removeMe():void 
		{
			BackBoard.instance.removeChild(this);
		}
		
	}

}