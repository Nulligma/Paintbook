package tools.line 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LineTool 
	{
		static private var _instance:LineTool;
		
		private var layerList:LayerList;
		private var line:LineData = LineData.instance;
		
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean = false;
		private var tempSprite:Sprite;
		private var startPoint:Point;
		private var endPoint:Point;
		
		private var step:uint = 1;
		
		public function LineTool() 
		{
			if (_instance)
				throw new Error("LineTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList= LayerList.instance;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			HistoryManager.pushList();
			
			if (step == 1)
			{
				tempSprite = new Sprite;
				tempSprite.alpha = 0.5;
				
				if(_canvas == settings.System.canvas)
					_canvas.addChildAt(tempSprite, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
				else
					_canvas.addChild(tempSprite);
				
				tempSprite.graphics.lineStyle(line.size, ToolManager.fillColor, line.opacity, false, "normal", line.cap);
				
				startPoint = new Point(_canvas.mouseX, _canvas.mouseY);
				tempSprite.graphics.moveTo(startPoint.x, startPoint.y);
				tempSprite.filters = [new BlurFilter(line.smoothness, line.smoothness, 2)];
			}
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (!line.lineTrail)
			{
				tempSprite.graphics.clear();
				tempSprite.graphics.lineStyle(line.size, ToolManager.fillColor, line.opacity, false, "normal", line.cap);
			}
			
			tempSprite.graphics.moveTo(startPoint.x, startPoint.y);
			if (step == 1)
			{
				if (line.snapX)
					endPoint = new Point(_canvas.mouseX, startPoint.y);
				else if (line.snapY)
					endPoint = new Point(startPoint.x, _canvas.mouseY);
				else
					endPoint = new Point(_canvas.mouseX, _canvas.mouseY);
				
				tempSprite.graphics.lineTo(endPoint.x, endPoint.y);
				tempSprite.graphics.moveTo(startPoint.x, startPoint.y);
			}
			else
			{
				if(endPoint)
					tempSprite.graphics.curveTo(_canvas.mouseX, _canvas.mouseY,endPoint.x, endPoint.y);
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (tempSprite)
			{
				if (line.lineMode)
					clear();
				else if (step == 2)
					clear();
				else
					step++;
				
			}
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function clear():void 
		{
			if (tempSprite.stage)
			{
				if (ToolManager.lassoMask)
				{
					var bd:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
					bd.draw(tempSprite);
					var bm:Bitmap = new Bitmap(bd);
					
					bm.mask = ToolManager.lassoMask;
					_bitData.draw(bm);
					
					bm.mask = null;
					bm = null;
					bd.dispose();
				}
				else
					_bitData.draw(tempSprite,null,null,null,ToolManager.clipRect);
				
				_canvas.removeChild(tempSprite);
				tempSprite = null;
			}
			
			step = 1;
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			tempSprite = null;
			activated = false;
		}
		
		static public function get instance():LineTool 
		{
			if (!_instance)
				_instance = new LineTool
			return _instance;
		}
		
	}

}