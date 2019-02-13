package tools.mag 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import settings.CustomUI;
	import settings.System;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class MagGlass extends Sprite
	{
		private var sW:int;
		private var sH:int;
		private var bitMap:Bitmap;
		
		private var _size:int;
		private var mat:Matrix;
		private var halfSize:Number;
		
		static private var prevX:Number = 0;
		static private var prevY:Number = 0;
		
		public function MagGlass() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.lineStyle(2, CustomUI.color2);
			graphics.beginFill(CustomUI.color1);
			graphics.drawRect(0, 0, sW* 0.2, sW * 0.2);
			graphics.endFill();
			
			graphics.lineStyle(0);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(sW * 0.02, sW * 0.02, sW * 0.16, sW * 0.16);
			graphics.endFill();
			
			var bd:BitmapData = new BitmapData(sW * 0.08, sW * 0.08,true,0x000000);
			
			bitMap = new Bitmap(bd);
			bitMap.x = bitMap.y = sW * 0.02;
			bitMap.scaleX = bitMap.scaleY = 2;
			addChild(bitMap);
			
			_size = sW * 0.08;
			halfSize = _size * 0.5;
			
			prevY = prevY == 0?sH - width:prevY;
			
			x = prevX;
			y = prevY;
			
			addEventListener(MouseEvent.MOUSE_DOWN, drag);
		}
		
		private function drag(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			startDrag(false, new Rectangle(0, sH * 0.175, System.stageWidth - width, System.stageHeight - height - sH * 0.175));
		}
		
		private function endDrag(e:MouseEvent):void 
		{
			stopDrag();
			
			prevX = x;
			prevY = y;
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
		}
		
		public function update(X:Number,Y:Number)
		{
			bitMap.bitmapData = new BitmapData(sW * 0.08, sW * 0.08, true, 0x000000);
			
			X = X > halfSize?X - halfSize:0;
			Y = Y > halfSize?Y - halfSize:0;
			
			mat = new Matrix(1,0,0,1,-X,-Y);
			bitMap.bitmapData.draw(System.canvas, mat, null, null, new Rectangle(0,0, _size, _size));
			
		}
		
	}

}