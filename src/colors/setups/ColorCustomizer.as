package colors.setups 
{
	import colors.convertor.ConvertColor;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	import colors.setups.Swatches;
	import settings.CustomUI;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ColorCustomizer extends Sprite
	{
		private var sW:Number;
		private var sH:Number;
		
		private var _type:String;
		private var _oldColor:uint;
		private var _newColor:uint;
		private var _updateObject:*;
		private var pressed:Boolean;
		private var lum:Number=0.5;
		
		private var gradientHolder:Sprite;
		private var gradient:Bitmap;
		private var newColorSprite:Sprite;
		private var oldColorSprite:Sprite;
		private var pressedSwatch:MovieClip;
		private var ring:Sprite;
		private var timer:Timer;
		
		public static const CUST_SPECTRUM:String = "Spectrum";
		
		public function ColorCustomizer(type:String,oldColor:uint,newColor:uint = 1,exitHandler:Function=null) 
		{
			_type = type;
			
			if(newColor == 1)
				_oldColor = _newColor = oldColor;
			else
			{	_oldColor = oldColor; _newColor = newColor }
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			graphics.beginFill(CustomUI.color1); graphics.drawRect(0, 0, sW, sH*0.167); graphics.endFill();
			
			graphics.beginFill(CustomUI.color2); graphics.drawCircle(sW * 0.02 + sW * 0.067, sH * 0.0167 + sH * 0.067, sH * 0.067); graphics.endFill();
			
			oldColorSprite = new Sprite;
			oldColorSprite.graphics.beginFill(_oldColor); halfCircle(oldColorSprite, 0, 0, sW * 0.03); oldColorSprite.graphics.endFill();
			oldColorSprite.rotation = 90;
			oldColorSprite.x = sW * 0.02 + sW * 0.067;
			oldColorSprite.y = sH * 0.0167 + sH * 0.067;
			addChild(oldColorSprite);
			
			newColorSprite = new Sprite;
			newColorSprite.rotation = -90;
			newColorSprite.x = sW * 0.02 + sW * 0.067;
			newColorSprite.y = sH * 0.0167 + sH * 0.067;
			update_NewColor_Sprite();
			addChild(newColorSprite);
			
			
			if (_type == "Spectrum")
			{
				graphics.beginFill(CustomUI.color2); graphics.drawRect(sW - sW * 0.8 - sW * 0.01, sH * 0.0167, sW * 0.8, sH * 0.13);
				
				gradientHolder = new Sprite;
				createGradient();
				gradientHolder.addEventListener(MouseEvent.MOUSE_DOWN, onGradientPress);
				stage.addEventListener(MouseEvent.MOUSE_UP, onGradientUp);
				
				ring = new Sprite;
				ring.graphics.lineStyle(sH * 0.013, CustomUI.color2); ring.graphics.drawCircle( 0,0, sH * 0.083/2); 
				ring.graphics.lineStyle(sH * 0.013, CustomUI.color2); ring.graphics.drawCircle( 0,0, sH * 0.067/2);
				ring.graphics.lineStyle(sH * 0.013, CustomUI.color1); ring.graphics.drawCircle( 0,0,sH * 0.075/2);
				ring.addEventListener(MouseEvent.MOUSE_DOWN, onGradientPress);
			}
			else if(Swatches.SwatchNames.indexOf(_type) != -1)
			{
				var colors:Array = Swatches.getSwatchColors(_type);
				
				var sp:MovieClip,i:int=0;
				for each(var c:uint in colors)
				{
					sp = new MovieClip;
					sp.graphics.lineStyle(sW * 0.005, CustomUI.color2); sp.graphics.beginFill(c); sp.graphics.drawRect(0, 0, sW*0.049, sW*0.049);sp.graphics.endFill();
					sp.color = c;
					sp.name = String(i);
					
					sp.x = i * sW * 0.068 + (sW - sW * 0.8 - sW * 0.01); sp.y = height / 2 - sp.height / 2;
					sp.addEventListener(MouseEvent.MOUSE_DOWN, swatchPressed);
					
					addChild(sp);
					i++;
				}
			}
		}
		
		private function createGradient():void 
		{
			gradient = new Bitmap;
			gradient.bitmapData = new BitmapData(800, 60, false, 0x000000);
			
			var tempColor:uint;
			var rgb:Object = ConvertColor.HexToRGB(_newColor);
			var hsl:Object = ConvertColor.RGBtoHSL(rgb.r, rgb.g, rgb.b);
			
			gradient.bitmapData.lock();
			for (var i:int = 0; i <= 200; i++)
			{
				tempColor = ConvertColor.HSLtoColor(hsl.h, hsl.s, (200-i) * 0.005);
				tempColor = uint("0x" + tempColor.toString(16).toUpperCase());
				
				for (var ti:int = i*4; ti < i*4+4; ti++) 
				{
					gradient.bitmapData.setPixel(ti, 0, tempColor);
				}
			}
			gradient.bitmapData.unlock();
			
			for (var k:int = 0; k < 60; k++) 
			{
				gradient.bitmapData.copyPixels(gradient.bitmapData , new Rectangle(0, 0, 800, 1), new Point(0, k));
			}
			
			gradient.scaleX = sW * 0.78 / 800;
			gradient.scaleY = sH * 0.1 / 60;
			gradient.x = sW - gradient.width - sW * 0.02;
			gradient.y = sH * 0.03;
			
			update_NewColor_Sprite();
			
			if(!gradient.stage)
				gradientHolder.addChild(gradient);
			if (!gradientHolder.stage)
				addChild(gradientHolder);
		}
		
		private function halfCircle(sp:Sprite, x:Number, y:Number, r:Number):void 
		{
			var c1:Number=r * (Math.SQRT2 - 1);
			var c2:Number=r * Math.SQRT2 / 2;
			sp.graphics.moveTo(x+r,y);
			sp.graphics.curveTo(x+r,y+c1,x+c2,y+c2);
			sp.graphics.curveTo(x+c1,y+r,x,y+r);
			sp.graphics.curveTo(x-c1,y+r,x-c2,y+c2);
			sp.graphics.curveTo(x-r,y+c1,x-r,y);
		}
		
		private function swatchPressed(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;
			pressedSwatch = e.currentTarget as MovieClip;
			
			if (_type.indexOf("Custom") !=-1)
			{
				timer.start();
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, swatchUP);
		}
		
		private function swatchUP(e:MouseEvent):void 
		{
			timer.stop();
			timer.reset();
			
			pressedSwatch.scaleX = pressedSwatch.scaleY = 1; _newColor = pressedSwatch.color;
			
			update_NewColor_Sprite();
			stage.removeEventListener(MouseEvent.MOUSE_UP, swatchUP);
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			timer.stop();
			timer.reset();
			
			Swatches.setCustomColors(_type, int(pressedSwatch.name), _newColor);
			
			pressedSwatch.color = _newColor;
			pressedSwatch.graphics.clear();
			pressedSwatch.graphics.lineStyle(sW * 0.005, CustomUI.color2); 
			pressedSwatch.graphics.beginFill(_newColor); pressedSwatch.graphics.drawRect(0, 0, sW * 0.049, sW * 0.049);
			pressedSwatch.graphics.endFill();
		}
		
		private function update_NewColor_Sprite():void 
		{
			newColorSprite.graphics.clear();
			newColorSprite.graphics.beginFill(_newColor);
			halfCircle(newColorSprite, 0, 0, sW * 0.03); 
			newColorSprite.graphics.endFill();
		}
		
		private function onGradientPress(e:MouseEvent):void 
		{
			pressed = true;
			gradientHolder.addEventListener(MouseEvent.MOUSE_MOVE, onGradientMove);
			
			_newColor = uint("0x" + gradient.bitmapData.getPixel(gradient.mouseX, gradient.mouseY).toString(16));
			var rgb:Object = ConvertColor.HexToRGB(_newColor);
			var hsl:Object = ConvertColor.RGBtoHSL(rgb.r, rgb.g, rgb.b);
			lum = hsl.l;
			update_NewColor_Sprite();
			
			ring.x = mouseX;
			ring.y = height / 2;
			
			if (!ring.stage)
				addChild(ring);
		}
		
		private function onGradientMove(e:MouseEvent):void 
		{
			_newColor = uint("0x" + gradient.bitmapData.getPixel(gradient.mouseX, gradient.mouseY).toString(16));
			if(ring.stage)
			{	
				_newColor = uint("0x" + gradient.bitmapData.getPixel(gradient.mouseX, gradient.mouseY).toString(16));
			}
			update_NewColor_Sprite();
			
			updateTheObject();
			
			ring.x = mouseX;
		}
		
		private function onGradientUp(e:MouseEvent):void 
		{
			if (pressed)
			{
				pressed = false;
				gradientHolder.removeEventListener(MouseEvent.MOUSE_MOVE, onGradientMove);
			}
		}
		
		private function updateTheObject():void 
		{
			if (_updateObject == null) return;
			
			if(Class(getDefinitionByName(getQualifiedClassName(_updateObject))) == TextField)
			{
				_updateObject.text = ConvertColor.UintToHexString(_newColor);
			}
		}
		
		public function set color(c:uint):void
		{
			_newColor = c;
			if (_type == "Spectrum")
			{	createGradient();}
			
			if(ring.stage)
			{	
				_newColor = uint("0x" + gradient.bitmapData.getPixel(ring.x - gradient.x, ring.y - gradient.y).toString(16));
				update_NewColor_Sprite();
			}
			
			updateTheObject();
		}
		
		public function get color():uint
		{
			return uint("0x" + _newColor.toString(16).toUpperCase());
		}
		
		public function set updateObject(value:*):void 
		{
			_updateObject = value;
		}
		
		public function removeRing():void
		{
			if(ring.stage)
				removeChild(ring);
		}
	}

}