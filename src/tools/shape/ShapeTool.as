package tools.shape 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.transform.FreeTransform;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ShapeTool 
	{
		static private var _instance:ShapeTool;
		
		private var layerList:LayerList;
		private var shape:ShapeData = ShapeData.instance;
		
		private var activated:Boolean = false;
		private var makeShape:Boolean = true;
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var freeTrans:FreeTransform;
		
		public function ShapeTool() 
		{
			if (_instance)
				throw new Error("ShapeTool singleTon Error");
		}
		
		public function activate(canvas:Sprite,bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList= LayerList.instance;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			activated = true;
		}
		
		private function onDown(event:MouseEvent):void
		{
			if (makeShape)
			{
				HistoryManager.pushList();
				
				var design:Design = new Design(shape.designType,shape.size,shape.lineThickness,ToolManager.lineColor,ToolManager.fillColor,shape.edges);
				freeTrans = new FreeTransform({vecData:design});
				freeTrans.x = _canvas.mouseX;
				freeTrans.y = _canvas.mouseY;
				freeTrans.maintainRatio = false;
				
				_canvas.addChildAt(freeTrans, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
				
				
				makeShape = false;
			}
		}
		
		public function deactivate():void
		{
			if (freeTrans) 
			{
				freeTrans.clearAll();
				
				if (ToolManager.lassoMask)
				{
					var bd:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
					bd.draw(freeTrans, freeTrans.transform.matrix, null, null, ToolManager.clipRect);
					
					var bm:Bitmap = new Bitmap(bd);
					bm.mask = ToolManager.lassoMask;
					
					_bitData.draw(bm);
					
					bm.mask = ToolManager.lassoMask;
					bm = null;
					bd.dispose();
				}
				else
				{
					_bitData.draw(freeTrans, freeTrans.transform.matrix, null, null, ToolManager.clipRect);
				}
				
				_canvas.removeChild(freeTrans);
				freeTrans = null;
			}
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			activated = false;
			makeShape = true;
		}
		
		static public function get instance():ShapeTool 
		{
			if (!_instance)
			 _instance = new ShapeTool;
			return _instance;
		}
		
		
	}

}