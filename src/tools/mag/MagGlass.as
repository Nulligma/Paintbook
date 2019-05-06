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
			
			//graphics.lineStyle(2, CustomUI.color2);
			graphics.beginFill(CustomUI.color1);
			graphics.drawRect(0, 0, sW* 0.2, sW * 0.2);
			graphics.endFill();
			
			//graphics.lineStyle(0);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(sW * 0.01, sW * 0.01, sW * 0.18, sW * 0.18);
			graphics.endFill();
			
			_size = sW * 0.09;
			halfSize = _size * 0.5;
			
			var bd:BitmapData = new BitmapData(_size,_size,true,0x000000);
			
			bitMap = new Bitmap(bd);
			bitMap.x = bitMap.y = (sW*0.1) - _size;
			bitMap.scaleX = bitMap.scaleY = 2;
			addChild(bitMap);
			
			//prevY = prevY == 0?sH - width:prevY;
			
			prevX = sW*0.4;
			
			x = prevX;
			y = prevY;
			
			addEventListener(MouseEvent.MOUSE_DOWN, drag);
		}
		
		private function drag(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			startDrag(false, new Rectangle(sW*0.4,0, System.stageWidth - width-sW*0.4, System.stageHeight - height));
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
			bitMap.bitmapData = new BitmapData(_size, _size, true, 0x000000);
			
			X = X > halfSize?X - halfSize:0;
			Y = Y > halfSize?Y - halfSize:0;
			
			mat = new Matrix(1,0,0,1,-X,-Y);
			bitMap.bitmapData.draw(System.canvas, mat, null, null, new Rectangle(0,0, _size, _size));
			
		}
		
	}

}