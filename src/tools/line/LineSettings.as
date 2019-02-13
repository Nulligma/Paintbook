package tools.line 
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
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LineSettings extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var line:LineData = LineData.instance;
		private var layerList:LayerList = LayerList.instance;
		
		private var colorSprite:Sprite;
		private var canvasBG:Sprite;
		private var canvasHolder:Sprite;
		private var canvas:Bitmap;
		
		private var txtFormat:TextFormat;
		
		private var typeTxt:TextField;
		private var brushTxt:TextField;
		private var sizeTxt:TextField;
		private var flowTxt:TextField;
		private var blurTxt:TextField;
		private var colorTxt:TextField;
		private var spaceTxt:TextField;
		private var opaqueTxt:TextField;
		
		private var customSlider:CustomSlider;
		private var colorSetup:ColorSetup;
		private var snx:Sprite;
		private var sny:Sprite;
		
		public function LineSettings() 
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
			tween = new TweenNano(sp, 0.5, { y:0, ease:Strong.easeOut } );
			
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
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.2, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			if(line.lineMode)
				typeTxt.text = "Line";
			else
				typeTxt.text = "Curve";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeType );
			tween = new TweenNano(sp, 0.5, { y:sH * 0.0167, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(0x000000); sp.graphics.drawRect(0, 0, sW * 0.781, sH * 0.1);
			sp.x = sW * 0.21; sp.y = sH * 0.012;
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color2); sp.graphics.moveTo(0, 0); sp.graphics.lineTo(sW-sW * 0.02, 0);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			tween = new TweenNano(sp, 0.5, { y:sH * 0.125, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField;sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+line.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.6, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
			sp.name = "Opacity";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			flowTxt = new TextField;flowTxt.embedFonts = true;
			flowTxt.defaultTextFormat = txtFormat;
			flowTxt.text = "Opacity "+line.opacity*100+"%";
			flowTxt.selectable = false;
			flowTxt.autoSize = TextFieldAutoSize.CENTER;
			flowTxt.x = sp.width / 2 - flowTxt.width / 2; flowTxt.y = sp.height / 2 - flowTxt.height / 2;
			sp.addChild(flowTxt);
			sp.x = sp.width + sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.7, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0,sW * 0.185, sH * 0.083); sp.graphics.endFill();
			sp.name = "Smooth";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			blurTxt = new TextField;blurTxt.embedFonts = true;
			blurTxt.defaultTextFormat = txtFormat;
			blurTxt.text = "Smooth "+line.smoothness;
			blurTxt.selectable = false;
			blurTxt.autoSize = TextFieldAutoSize.CENTER;
			blurTxt.x = sp.width / 2 - blurTxt.width / 2; blurTxt.y = sp.height / 2 - blurTxt.height / 2;
			sp.addChild(blurTxt);
			sp.x = sp.width*2 + sW * 0.03; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
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
			sp.x = sp.width*3 + sW * 0.04; sp.y = -sp.height;
			colorSprite = new Sprite;
			redrawColorSP();
			colorSprite.x = sp.width - sW * 0.01-colorSprite.width; colorSprite.y = sH * 0.017;
			sp.addChild(colorSprite);
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; colorSetup = new ColorSetup(ToolManager.fillColor, changeColor); addChild(colorSetup); } );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.15, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.name = "Cap";
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.185, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			spaceTxt = new TextField;spaceTxt.embedFonts = true;
			spaceTxt.defaultTextFormat = txtFormat;
			spaceTxt.text = "Cap "+ line.cap;
			spaceTxt.selectable = false;
			spaceTxt.autoSize = TextFieldAutoSize.CENTER;
			spaceTxt.x = sp.width / 2 - spaceTxt.width / 2; spaceTxt.y = sp.height / 2 - spaceTxt.height / 2;
			sp.addChild(spaceTxt);
			sp.x = sp.width*4 + sW * 0.05; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 1, { y:sH * 0.15, ease:Strong.easeOut } );
			
			var txtField:TextField;
			
			for (var i:int = 0; i < 3; i++)
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
				txtFormat.size = sp.height * 0.56;
				txtFormat.color = CustomUI.color1;
				txtField = new TextField;txtField.embedFonts = true;
				txtField.defaultTextFormat = txtFormat;
				
				if (i == 0) { sp.name = "X"; txtField.text = "Snap to X"; sp.alpha = line.snapX?1:0.7; snx = sp}
				if (i == 1) { sp.name = "Y"; txtField.text = "Snap to Y"; sp.alpha = line.snapY?1:0.7; sny = sp}
				if (i == 2) { sp.name = "L"; txtField.text = "Line Trail"; sp.alpha = line.lineTrail?1:0.7; }
				
				txtField.selectable = false;
				txtField.autoSize = TextFieldAutoSize.CENTER;
				txtField.x = sp.width / 2 - txtField.width / 2; txtField.y = sp.height / 2 - txtField.height / 2;
				sp.addChild(txtField);
				sp.x = (sW * 0.318 * i) + sW*0.02; sp.y = -sp.height;
				addChild(sp);
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, changeBools );
				tween = new TweenNano(sp, 0.8+i/10, { y:sH * 0.25, ease:Strong.easeOut } );
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
			
			if (typeTxt.text == "Line")
				typeTxt.text = "Curve"
			else
				typeTxt.text = "Line";
			
			line.lineMode = !line.lineMode;
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Line Size", line.size, 1, 200);
				break;
				
				case "Opacity":
					customSlider = new CustomSlider("Line Opacity", line.opacity*100, 0, 100);
				break;
				
				case "Smooth":
					customSlider = new CustomSlider("Smoothness", line.smoothness, 0, 10);
				break;
				
				case "Cap":
					customSlider = new CustomSlider("Cap Style ", line.capArray.indexOf(line.cap), 0, 2,line.capArray);
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
					line.size = customSlider.value;
					sizeTxt.text = "Size " + customSlider.value;
				break;
				
				case "Opacity":
					line.opacity = customSlider.value/100;
					flowTxt.text = "Opacity " + customSlider.value+"%";
				break;
				
				case "Smooth":
					line.smoothness = customSlider.value;
					blurTxt.text = "Smooth " + customSlider.value;
				break;
				
				case "Cap":
					line.cap = line.capArray[customSlider.value];
					spaceTxt.text = "Cap " + line.cap;
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
				case "X":
					line.snapX = !line.snapX; 
					line.snapY = false;
					sny.alpha = 0.7;
				break;
				
				case "Y":
					line.snapY = !line.snapY; 
					line.snapX = false;
					snx.alpha = 0.7;
				break;
				
				case "L":
					line.lineTrail = !line.lineTrail; break;
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