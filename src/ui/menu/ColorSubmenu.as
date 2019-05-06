package ui.menu 
{
	import colors.colorGradient.ColorSpectrumChart;
	import colors.spectrums.Spectrum;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import tools.ToolManager;
	import colors.setups.ColorSetup;
	import settings.CustomUI;
	import settings.System;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ColorSubmenu extends Sprite
	{
		private var sH:int;
		private var sW:int;
		private var colorsArray:Array = new Array(0x000000, 0x000000, 0x000000, 0x000000, 0x000000);
		private var colorsSprites:Array;
		private var spectrum:Bitmap;
		
		private var spectrumHolder:Sprite;
		private var c1Sprite:Sprite;
		private var c2Sprite:Sprite;
		
		private var txtFormat:TextFormat;
		private var pressed:Boolean;
		
		private var colorSetup:ColorSetup;
		private var tempStage:Stage;
		
		public function ColorSubmenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			sW= System.stageWidth;
			sH = System.stageHeight;
			
			spectrum = Spectrum.linearSpectrum;
			
			var sp1:Sprite; var sp2:Sprite;
			var typeTxt:TextField;
			var tween:TweenNano;
			var cT:ColorTransform;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.6;
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW*0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0,0,sW * 0.1, sH * 0.207); sp1.graphics.endFill();
			
			sp2 = new PlusIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			
			addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { colorSetup = new ColorSetup(ToolManager.fillColor, setColor); BackBoard.instance.addChild(colorSetup); tempStage = stage; } );
			
			spectrumHolder = new Sprite;
			spectrum.y = 1;
			spectrumHolder.addChild(spectrum);
			spectrumHolder.graphics.lineStyle(sW * 0.001, CustomUI.color1);
			spectrumHolder.graphics.drawRect(0,0,spectrumHolder.width,sH * 0.207);
			spectrumHolder.x = (6 * sW * 0.1);
			addChild(spectrumHolder);
			spectrumHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { pressed = true; collectColor()} );
			spectrumHolder.addEventListener(MouseEvent.MOUSE_MOVE, collectColor);
			spectrumHolder.stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { pressed = false; } );
			
			var i:int = 0;
			colorsSprites = new Array();
			for each(var color:int in colorsArray)
			{
				sp1 = new Sprite;
				sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(color); 
				sp1.graphics.drawRect(0, 0, sW * 0.1, sH * 0.207); sp1.graphics.endFill();
				sp1.name = String(i);
				
				sp1.x = (i * sW * 0.1) + sW * 0.1;
				addChild(sp1);
				i++;
				sp1.addEventListener(MouseEvent.CLICK, setColor);
				colorsSprites.push(sp1);
			}
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.drawRect(0, 0, sW - (6 * sW * 0.05) - spectrumHolder.width, sH * 0.207);
			sp1.x = sW - sp1.width;
			//addChild(sp1);
			
			c1Sprite = new Sprite;
			c1Sprite.graphics.beginFill(ToolManager.fillColor); c1Sprite.graphics.drawRect(0, 0, sW/2, sH * 0.04);
			//c1Sprite.x = sp1.x + sW * 0.002;
			c1Sprite.y = sH*0.207;
			addChild(c1Sprite);
			
			c2Sprite = new Sprite;
			c2Sprite.graphics.beginFill(ToolManager.fillColor); c2Sprite.graphics.drawRect(0, 0, sW/2, sH * 0.04); c2Sprite.graphics.endFill();
			c2Sprite.x = sW/2;
			c2Sprite.y = sH*0.207;
			addChild(c2Sprite);
			
			graphics.lineStyle(sW * 0.006, CustomUI.color1); 
			graphics.moveTo(0, sH * 0.247); graphics.lineTo(sW, sH * 0.247);
		}
		
		private function setColor(e:MouseEvent=null):void 
		{
			if (e != null)
			{
				ToolManager.fillColor = colorsArray[int(e.currentTarget.name)];
				c2Sprite.graphics.beginFill(ToolManager.fillColor); c2Sprite.graphics.drawRect(0, 0, c2Sprite.width, sH * 0.04);
				c2Sprite.graphics.endFill();
			}
			else
			{
				ToolManager.fillColor = colorSetup.color;
				BackBoard.instance.removeChild(colorSetup);
				colorSetup = null;
				updateColorArray();
			}
		}
		
		private function collectColor(e:MouseEvent=null):void 
		{
			if (pressed) 
			{
				var color:uint = uint("0x" + spectrum.bitmapData.getPixel(spectrum.mouseX, spectrum.mouseY).toString(16));
				ToolManager.fillColor = color;
				c2Sprite.graphics.beginFill(ToolManager.fillColor); c2Sprite.graphics.drawRect(0, 0, c2Sprite.width, sH * 0.04);
				c2Sprite.graphics.endFill();
			}
		}
		
		public function updateColorArray():void 
		{
			if (colorsArray.indexOf(ToolManager.fillColor) == -1)
			{
				colorsArray.unshift(ToolManager.fillColor);
				colorsArray.pop();
				
				var sp1:Sprite;
				for(var i:int = 0; i<colorsSprites.length;i++)
				{
					sp1 = colorsSprites[i] as Sprite;
					sp1.graphics.clear();
					sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(colorsArray[i]); 
					sp1.graphics.drawRect(0, 0, sW * 0.1, sH * 0.207); sp1.graphics.endFill();
				}
				
				c1Sprite.graphics.beginFill(ToolManager.fillColor); c1Sprite.graphics.drawRect(0, 0, c1Sprite.width, sH * 0.04);
				c1Sprite.graphics.endFill();
			}
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			updateColorArray();
		}
	}

}