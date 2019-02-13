package tools.eraser 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
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
	import settings.CustomUI;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class EraserSettings extends Sprite
	{
		private var eraser:EraserData = EraserData.instance;
		
		private var sW:int;
		private var sH:int;
		
		static private var selectedBrush:int = 0;
		static private var brushType:String = "Art";
		
		private var txtFormat:TextFormat;
		private var typeTxt:TextField;
		private var blurTxt:TextField;
		private var indicator:Sprite;
		private var patternBG:Sprite;
		private var patternHolder:Sprite;
		private var sizeTxt:TextField;
		private var flowTxt:TextField;
		private var customSlider:CustomSlider;
		
		private var index:int = 0;
		
		public function EraserSettings() 
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
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = ">>";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
			sp.addChild(typeTxt);
			sp.x = sW * 0.99 - sp.width; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, nextBrushes );
			tween = new TweenNano(sp, 1, { y:sH * 0.0167 , ease:Strong.easeOut } );
			
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
			tween = new TweenNano(sp, 0.7, { y:sH * 0.0167, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(0x000000); sp.graphics.drawRect(0, 0, sW * 0.781, sH * 0.1);
			sp.x = sW * 0.21; sp.y = sH * 0.012;
			
			indicator = new Sprite;
			indicator.graphics.beginFill(CustomUI.color2); indicator.graphics.drawRect(0, 0, sH * 0.034, sH * 0.034);
			
			patternBG = new Sprite;
			patternBG.graphics.beginFill(CustomUI.color2); patternBG.graphics.drawRect(0, 0, sW * 0.785, sH * 0.09);
			patternBG.x = sW * 0.208; patternBG.y = -patternBG.height;
			//addChild(patternBG);
			tween = new TweenNano(patternBG, 0.7, { y:sH * 0.012, ease:Strong.easeOut } );
			
			patternHolder = new Sprite;
			addChild(patternHolder);
			generatePatternFor(typeTxt.text);
			patternHolder.x = sW * 0.215; patternHolder.y = -patternHolder.height;
			patternHolder.mask = sp;
			tween = new TweenNano(patternHolder, 0.4, { y:sH * 0.0167, ease:Strong.easeOut } );
			//patternHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {patternHolder.startDrag(false, new Rectangle(-patternHolder.width + sW*0.99, sH * 0.0167, patternHolder.width-sW*0.775, 0)); } );
			//stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { patternHolder.stopDrag() } );
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color2); sp.graphics.moveTo(0, 0); sp.graphics.lineTo(sW-sW * 0.02, 0);
			sp.x = sW * 0.01; sp.y = -sp.height;
			addChild(sp);
			tween = new TweenNano(sp, 0.7, { y:sH * 0.167, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Size";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			sizeTxt = new TextField;sizeTxt.embedFonts = true;
			sizeTxt.defaultTextFormat = txtFormat;
			sizeTxt.text = "Size "+eraser.size;
			sizeTxt.selectable = false;
			sizeTxt.autoSize = TextFieldAutoSize.CENTER;
			sizeTxt.x = sp.width / 2 - sizeTxt.width / 2; sizeTxt.y = sp.height / 2 - sizeTxt.height / 2;
			sp.addChild(sizeTxt);
			sp.x = sW * 0.02; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.8, { y:sH * 0.217, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Flow";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			flowTxt = new TextField;flowTxt.embedFonts = true;
			flowTxt.defaultTextFormat = txtFormat;
			flowTxt.text = "Flow "+Math.round(eraser.flow*100)+"%";
			flowTxt.selectable = false;
			flowTxt.autoSize = TextFieldAutoSize.CENTER;
			flowTxt.x = sp.width / 2 - flowTxt.width / 2; flowTxt.y = sp.height / 2 - flowTxt.height / 2;
			sp.addChild(flowTxt);
			sp.x = sW * 0.347; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 0.9, { y:sH * 0.217, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.308, sH * 0.083); sp.graphics.endFill();
			sp.name = "Smooth";
			txtFormat.size = sp.height * 0.56;
			txtFormat.color = CustomUI.color1;
			blurTxt = new TextField;blurTxt.embedFonts = true;
			blurTxt.defaultTextFormat = txtFormat;
			blurTxt.text = "Smooth "+eraser.smoothness;
			blurTxt.selectable = false;
			blurTxt.autoSize = TextFieldAutoSize.CENTER;
			blurTxt.x = sp.width / 2 - blurTxt.width / 2; blurTxt.y = sp.height / 2 - blurTxt.height / 2;
			sp.addChild(blurTxt);
			sp.x = sW * 0.674; sp.y = -sp.height;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeVars );
			tween = new TweenNano(sp, 1, { y:sH * 0.217, ease:Strong.easeOut } );
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "Size":
					customSlider = new CustomSlider("Brush Size", eraser.size, 1, 200);
				break;
				
				case "Flow":
					customSlider = new CustomSlider("Brush Flow", eraser.flow*100, 0, 100);
				break;
				
				case "Smooth":
					customSlider = new CustomSlider("Smoothness", eraser.smoothness, 0, 10);
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
					eraser.size = customSlider.value;
					sizeTxt.text = "Size " + eraser.size;
				break;
				
				case "Flow":
					eraser.flow = customSlider.value/100;
					flowTxt.text = "Flow " + customSlider.value+"%";
				break;
				
				case "Smooth":
					eraser.smoothness = customSlider.value;
					blurTxt.text = "Smooth " + eraser.smoothness;
				break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function generatePatternFor(type:String):void 
		{
			while (patternHolder.numChildren > 0)
			{
				patternHolder.removeChildAt(0);
			}
			patternHolder.x = sW * 0.215;
			
			var patternArray:Array = eraser.getSprites(type);
			
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
				
				sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { eraser.changePattern(typeTxt.text, int(e.currentTarget.name)); e.currentTarget.addChild(indicator); selectedBrush = int(e.currentTarget.name); } );
			}
		}
		
		private function nextBrushes(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var patternArray:Array = eraser.getSprites(typeTxt.text);
			
			if(patternArray[index+6] == null) index = 0;
			else							  index += 6;
			
			eraser.changePattern(typeTxt.text, index);
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
			eraser.changePattern(typeTxt.text, 0);
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