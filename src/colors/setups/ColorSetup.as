package colors.setups
{
	import colors.convertor.ConvertColor;
	import colors.spectrums.Spectrum;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import com.greensock.easing.*;
	
	import colors.colorGradient.ColorSpectrumChart;
	import colors.colorGradient.ColorUtils;
	import colors.setups.ColorCustomizer;
	import settings.CustomUI;
	import settings.System;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ColorSetup extends Sprite 
	{
		private var sW:Number;
		private var sH:Number;
		
		private var _newColor:uint;
		private var _oldColor:uint;
		private var pressed:Boolean;
		private var currentMode:String = "Spectrum";
		
		private var exitFunction:Function;
		
		private var okBtn:Sprite;
		private var cancelBtn:Sprite;
		private var colorCust:ColorCustomizer; 
		private var spectrumBG:Sprite;
		private var spectrumHolder:Sprite;
		private var switchModeSprite:Sprite;
		private var ring:Sprite;
		private var codeBox:Sprite;
		
		private var radialSpectrum:ColorSpectrumChart;
		private var spectrum:ColorSpectrumChart;
		
		private var spriteArray:Array;
		
		private var txtFormat:TextFormat;
		
		private var colorCodeTxt:TextField;
		
		public function ColorSetup(color:uint, exitHandler:Function) 
		{
			_newColor =_oldColor= color;
			exitFunction = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			spectrum = Spectrum.gradLinearSpectrum;
			radialSpectrum = Spectrum.radialSpectrum;
			
			var bg:Sprite = new Sprite;
			bg.graphics.beginFill(CustomUI.backColor); bg.graphics.drawRect(0, 0, sW, sH);
			addChild(bg);
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			okBtn = new Sprite;
			okBtn.graphics.beginFill(CustomUI.color1); okBtn.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); okBtn.graphics.endFill();
			txtFormat.size = okBtn.height * 0.6;
			txtFormat.color = CustomUI.color2;
			var txt1:TextField = new TextField;txt1.embedFonts = true;
			txt1.embedFonts = true;
			txt1.defaultTextFormat = txtFormat;
			txt1.text = "OK";
			txt1.selectable = false;
			txt1.autoSize = TextFieldAutoSize.CENTER;
			txt1.x = okBtn.width / 2 - txt1.width / 2; txt1.y = okBtn.height / 2 - txt1.height / 2;
			okBtn.addChild(txt1);
			okBtn.x = sW * 0.01; okBtn.y = sH;
			okBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { okBtn.scaleX = okBtn.scaleY = 0.97; } );
			okBtn.addEventListener(MouseEvent.MOUSE_UP, okBtnHandler);
			addChild(okBtn);
			TweenLite.to(okBtn,1,{y:sH - sH * 0.016 - okBtn.height,ease:Strong.easeOut});
			
			cancelBtn = new Sprite;
			cancelBtn.graphics.beginFill(CustomUI.color1); cancelBtn.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); cancelBtn.graphics.endFill();
			txt1 = new TextField;txt1.embedFonts = true;
			txt1.embedFonts = true;
			txt1.defaultTextFormat = txtFormat;
			txt1.text = "Cancel";
			txt1.selectable = false;
			txt1.autoSize = TextFieldAutoSize.CENTER;
			txt1.x = cancelBtn.width / 2 - txt1.width / 2; txt1.y = cancelBtn.height / 2 - txt1.height / 2;
			cancelBtn.addChild(txt1);
			cancelBtn.x = sW - cancelBtn.width - sW * 0.01; cancelBtn.y = sH;
			cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { cancelBtn.scaleX = cancelBtn.scaleY = 0.97; } );
			cancelBtn.addEventListener(MouseEvent.MOUSE_UP, cancelBtnHandler);
			addChild(cancelBtn);
			TweenLite.to(cancelBtn,1,{y:sH - sH * 0.016 - cancelBtn.height,ease:Strong.easeOut});
			
			spectrumBG = new Sprite;
			spectrumBG.graphics.beginFill(CustomUI.color1); spectrumBG.graphics.drawRect(0, 0, sW * 0.51, sH * 0.7); spectrumBG.graphics.endFill();
			spectrumBG.x = sW * 0.45; spectrumBG.y = sH * 0.56 - spectrumBG.height * 0.5;
			addChild(spectrumBG);
			TweenLite.to(spectrumBG,1,{x:sW * 0.5 - spectrumBG.width * 0.5,ease:Strong.easeOut});
			
			spectrumHolder = new Sprite;
			spectrumHolder.x = sW * 0.01; spectrumHolder.y =  sH * 0.016;
			spectrumBG.addChild(spectrumHolder);
			spectrumHolder.addChild(spectrum);
			
			colorCust = new ColorCustomizer(ColorCustomizer.CUST_SPECTRUM, _oldColor);
			addChild(colorCust);
			colorCust.y = -colorCust.height
			TweenLite.to(colorCust, 1, { y:0, ease:Strong.easeOut } );
			
			codeBox = new Sprite();
			codeBox.graphics.beginFill(CustomUI.color1);
			codeBox.graphics.drawRect(0, 0, sW * 0.146, sW * 0.146);
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sW * 0.0244;
			colorCodeTxt = new TextField();colorCodeTxt.embedFonts = true;
			colorCodeTxt.embedFonts = true;
			colorCodeTxt.defaultTextFormat = txtFormat;
			colorCodeTxt.text = ConvertColor.UintToHexString(_newColor);
			colorCodeTxt.type = TextFieldType.INPUT;
			colorCodeTxt.maxChars = 6;
			colorCodeTxt.autoSize = TextFieldAutoSize.CENTER;
			colorCodeTxt.x = codeBox.width / 2 - colorCodeTxt.width / 2;
			colorCodeTxt.y = sW * 0.025;
			codeBox.addChild(colorCodeTxt);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.117, sW * 0.0488); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sW * 0.0244;
			var tf = new TextField;tf.embedFonts = true;
			tf.embedFonts = true;
			tf.defaultTextFormat = txtFormat;
			tf.text = "Apply";
			tf.selectable = false; 
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.x = sp.width / 2 - tf.width / 2; tf.y = sp.height / 2 - tf.height / 2;
			sp.addChild(tf);
			sp.x = codeBox.width / 2 - sp.width / 2;
			sp.y = codeBox.height - sp.height - sW * 0.01;
			codeBox.addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, changeColor_Code );
			codeBox.x = sW; codeBox.y =  sH * 0.45;
			addChild(codeBox);
			TweenLite.to(codeBox, 1, { x:sW - codeBox.width - sW * 0.01, ease:Strong.easeOut } );
			
			colorCust.updateObject = colorCodeTxt;
			
			switchModeSprite = new Sprite;
			switchModeSprite.graphics.beginFill(CustomUI.color1); switchModeSprite.graphics.drawRect(0, 0, sW * 0.088, sW * 0.088); switchModeSprite.graphics.endFill();
			switchModeSprite.graphics.beginFill(0xCE0000); switchModeSprite.graphics.drawRect(switchModeSprite.width/2 - sW * 0.025 - sW * 0.025/5, switchModeSprite.height/2 - sW * 0.025 - sW * 0.025/5, sW * 0.025, sW * 0.025); switchModeSprite.graphics.endFill();
			switchModeSprite.graphics.beginFill(0x0000A0); switchModeSprite.graphics.drawRect(switchModeSprite.width/2 + sW * 0.025/5, switchModeSprite.height/2 - sW * 0.025-sW * 0.025/5, sW * 0.025, sW * 0.025); switchModeSprite.graphics.endFill();
			switchModeSprite.graphics.beginFill(0x008000); switchModeSprite.graphics.drawRect(switchModeSprite.width/2 - sW * 0.025-sW * 0.025/5, switchModeSprite.height/2 + sW * 0.025/4, sW * 0.025, sW * 0.025); switchModeSprite.graphics.endFill();
			switchModeSprite.graphics.beginFill(0xFFCC00); switchModeSprite.graphics.drawRect(switchModeSprite.width/2 + sW * 0.025/5, switchModeSprite.height/2 + sW * 0.025/5, sW * 0.025, sW * 0.025); switchModeSprite.graphics.endFill();
			switchModeSprite.x = -switchModeSprite.width; switchModeSprite.y =  sH / 2;
			addChild(switchModeSprite);
			TweenLite.to(switchModeSprite, 1, { x:sW * 0.01, ease:Strong.easeOut } );
			
			radialSpectrum.x = sW * 0.01; radialSpectrum.y = sW*0.01;
			
			ring = new Sprite;
			ring.graphics.lineStyle(sH * 0.013, CustomUI.color1); ring.graphics.drawCircle( 0,0, sH * 0.083/2); 
			ring.graphics.lineStyle(sH * 0.013, CustomUI.color1); ring.graphics.drawCircle( 0,0, sH * 0.067/2);
			ring.graphics.lineStyle(sH * 0.013, CustomUI.color2); ring.graphics.drawCircle( 0,0,sH * 0.075/2); 
			
			spectrumHolder.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
			ring.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			switchModeSprite.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { switchModeSprite.scaleX = switchModeSprite.scaleY = 0.97 } );
			switchModeSprite.addEventListener(MouseEvent.MOUSE_UP, switchMode);
		}
		
		private function changeColor_Code(e:MouseEvent):void 
		{
			var str:String = "0x" + colorCodeTxt.text; 
			
			if (ring.stage)
				spectrumBG.removeChild(ring);
			
			colorCust.removeRing();
			colorCust.color = uint(str);
		}
		
		private function switchMode(e:MouseEvent):void 
		{
			switchModeSprite.scaleX = switchModeSprite.scaleY = 1;
			_newColor = colorCust.color;
			if (currentMode == "Spectrum")
			{
				TweenLite.to(spectrumBG, 0.4, { x:sW * 0.45, ease:Linear.easeIn, onComplete:createSwatcheNames} );
				TweenLite.to(colorCust, 0.4, { y:-colorCust.height, ease:Linear.easeIn} );
				TweenLite.to(switchModeSprite, 0.4, { x: -switchModeSprite.width, ease:Linear.easeIn } );
				TweenLite.to(codeBox, 0.4, { x: sW, ease:Linear.easeIn } );
				
				currentMode = "Swatch";
			}
			else
			{
				currentMode = "Spectrum";
				TweenLite.to(colorCust, 0.5, { y: -colorCust.height, ease:Linear.easeIn, onComplete:createSpectrum } );
				
				TweenLite.to(switchModeSprite, 0.5, { x: -switchModeSprite.width, ease:Linear.easeIn } );
				
				for each(var sp:Sprite in spriteArray)
				{
					TweenLite.to(sp, 0.5, { x: sW, ease:Linear.easeIn } );
				}
			}
		}
		
		private function createSwatcheNames():void 
		{
			if (ring.stage)
				spectrumBG.removeChild(ring);
			
			removeChild(spectrumBG); removeChild(colorCust); 
			
			var sp:Sprite, txt1:TextField, i:int = 0;
			spriteArray = new Array;
			
			for each(var s:String in Swatches.SwatchNames)
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color1);sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
				txtFormat.size = okBtn.height * 0.6;
				txtFormat.color = CustomUI.color2;
				txt1 = new TextField;txt1.embedFonts = true;
				txt1.defaultTextFormat = txtFormat;
				txt1.text = s;
				txt1.selectable = false;
				txt1.autoSize = TextFieldAutoSize.CENTER;
				txt1.x = sp.width / 2 - txt1.width / 2; txt1.y = sp.height / 2 - txt1.height / 2;
				sp.addChild(txt1);
				sp.x = sW; sp.y = ((sH * 0.13) * int(i / 4)) + sH * 0.33;
				
				TweenLite.to(sp, 1, { x: ((sW * 0.16) * (i % 4)) + sW * 0.178 , ease:Strong.easeOut } );
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.MOUSE_UP, createSwatches);
				
				sp.name = s;
				addChild(sp);
				
				spriteArray.push(sp);
				
				i++;
			}
			
			switchModeSprite.addChild(radialSpectrum);
			switchModeSprite.x = -switchModeSprite.width;
			TweenLite.to(switchModeSprite, 1, { x: sW * 0.01, ease:Strong.easeOut } );
		}
		
		private function createSwatches(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			if (!colorCust.stage)
			{
				colorCust = new ColorCustomizer(e.currentTarget.name,_oldColor,_newColor);
				addChild(colorCust);
				colorCust.y = -colorCust.height;
				TweenLite.to(colorCust, 0.5, { y:0, ease:Strong.easeOut } );
			}
			else
			{
				_newColor = colorCust.color;
				removeChild(colorCust);
				colorCust = new ColorCustomizer(e.currentTarget.name,_oldColor,_newColor);
				addChild(colorCust);
			}
		}
		
		private function createSpectrum():void
		{
			for each(var sp:Sprite in spriteArray)
			{
				removeChild(sp); sp = null;
			}
			
			colorCust = new ColorCustomizer(ColorCustomizer.CUST_SPECTRUM, _oldColor,_newColor);
			addChild(colorCust); 
			colorCust.updateObject = colorCodeTxt;
			
			addChild(spectrumBG);
			
			switchModeSprite.removeChild(radialSpectrum);
			
			switchModeSprite.x = -switchModeSprite.width;
			TweenLite.to(switchModeSprite, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			spectrumBG.x = sW * 0.45;
			TweenLite.to(spectrumBG, 1, { x: sW * 0.5 - spectrumBG.width * 0.5, ease:Strong.easeOut } );
			
			colorCust.y = -colorCust.height;
			TweenLite.to(colorCust, 1, { y: 0, ease:Strong.easeOut } );
			
			colorCodeTxt.text = ConvertColor.UintToHexString(_newColor);
			TweenLite.to(codeBox, 1, { x: sW - codeBox.width - sW * 0.01, ease:Strong.easeOut } );
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (pressed)
			{
				pressed = false;
				spectrumHolder.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (pressed)
			{
				_newColor =  uint("0x" + spectrum.bitmapData.getPixel(spectrum.mouseX, spectrum.mouseY).toString(16));
				colorCust.color = _newColor;
				ring.x = spectrumHolder.mouseX;
				ring.y = spectrumHolder.mouseY;
			}
		}
		
		private function onPressed(e:MouseEvent):void 
		{
			pressed = true;
			spectrumHolder.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			_newColor =  uint("0x" + spectrum.bitmapData.getPixel(spectrum.mouseX, spectrum.mouseY).toString(16));
			colorCust.color = _newColor;
			
			if (!ring.stage)
			{
				spectrumBG.addChild(ring);
			}
			
			ring.x = spectrumHolder.mouseX;
			ring.y = spectrumHolder.mouseY;
		}
		
		public function get color():uint
		{
			return _newColor;
		}
		
		public function okBtnHandler(e:MouseEvent):void
		{
			okBtn.scaleX = okBtn.scaleY = 1;
			_newColor = colorCust.color; 
			TweenLite.to(this, 0.5, { y: -height, ease:Linear.easeIn,onComplete:exitFunction } );
			
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0, 0); sp.graphics.drawRect(0, 0, sW, sH);
			addChild(sp);
		}
		
		public function cancelBtnHandler(e:MouseEvent):void
		{
			cancelBtn.scaleX = cancelBtn.scaleY = 1; 
			_newColor = _oldColor;
			TweenLite.to(this, 0.5, { y: -height, ease:Linear.easeIn,onComplete:exitFunction } );
			
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0, 0); sp.graphics.drawRect(0, 0, sW, sH);
			addChild(sp);
		}
	}

}