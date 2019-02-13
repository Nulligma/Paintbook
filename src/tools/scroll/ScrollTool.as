package tools.scroll 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ScrollTool 
	{
		private static var _instance:ScrollTool;
		private var _bitData:BitmapData;
		private var _canvas:Sprite;
		private var activated:Boolean = false;
		private var mat:Matrix;
		private var startX:Number;
		private var startY:Number;
		
		private var tempBitData:BitmapData;
		private var tempBitMap:Bitmap;
		
		private var layerList:LayerList;
		private var clipRect:Rectangle;
		
		public function ScrollTool() 
		{
			if (_instance)
				throw new Error("ScrollTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData)
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList = LayerList.instance;
			clipRect = ToolManager.clipRect;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			if (!tempBitData)
			{
				HistoryManager.pushList();
				
				if (ToolManager.activeTools.indexOf(ToolType.LASSO) == -1)
				{
					tempBitData = new BitmapData(clipRect.width, clipRect.height, true, 0x00000000);
					tempBitData.copyPixels(_bitData, clipRect, new Point(0, 0));
				
					tempBitMap = new Bitmap(tempBitData);
					tempBitMap.x = clipRect.x;
					tempBitMap.y = clipRect.y;
					
					_bitData.fillRect(clipRect, 0x00000000);
				}
				else
				{
					var tempBM:Bitmap = new Bitmap(_bitData);
					tempBM.mask = ToolManager.lassoMask;
					
					tempBitData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
					tempBitData.draw(tempBM);
					
					tempBM.mask = null;
					tempBM = null;
					
					_bitData.draw(ToolManager.lassoMask,null,null,BlendMode.ERASE);
					
					tempBitMap = new Bitmap(tempBitData);
				}
				
				_canvas.addChildAt(tempBitMap, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
				
			}
			
			startX = tempBitMap.mouseX
			startY = tempBitMap.mouseY;
		}
		
		private function onMove(e:MouseEvent):void 
		{
			tempBitMap.x = _canvas.mouseX - startX;
			tempBitMap.y = _canvas.mouseY - startY;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			if (tempBitData)
			{
				_bitData.copyPixels(tempBitData, tempBitData.rect, new Point(tempBitMap.x, tempBitMap.y),null,null,true);
				
				_canvas.removeChild(tempBitMap);
				tempBitMap = null;
				tempBitData.dispose();
				tempBitData = null;
			}
			
			activated = false;
		}
		
		static public function get instance():ScrollTool 
		{
			if (!_instance)
				_instance = new ScrollTool;
			return _instance;
		}
		
	}

}