package settings 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	import tools.transform.TransformTool;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ClipBoard 
	{
		static private var _copyData:BitmapData;
		static private var copyRect:Rectangle;
		
		public function ClipBoard() 
		{
			
		}
		
		static public function copy(withCut:Boolean = false):void
		{
			if (ToolManager.activeTools.indexOf(ToolType.TRANSFORM) != -1) ToolManager.toggle(ToolType.TRANSFORM);
			
			if (_copyData)
				_copyData.dispose();
			
			var layerList:LayerList = LayerList.instance;
			
			if (withCut)
				HistoryManager.pushList();
			
			_copyData = new BitmapData(System.canvas.width, System.canvas.height, true, 0x00000000);
			
			if (ToolManager.activeTools.indexOf(ToolType.LASSO) == -1)
			{
				_copyData.copyPixels(layerList.currentLayer, ToolManager.clipRect, new Point(ToolManager.clipRect.x, ToolManager.clipRect.y));
				
				copyRect = ToolManager.clipRect;
				
				if (withCut)
					layerList.currentLayer.fillRect(ToolManager.clipRect, 0x00000000);
			}
			else
			{
				copyRect = ToolManager.lassoMask.getRect(ToolManager.lassoMask);
				
				var tempBM:Bitmap = new Bitmap(layerList.currentLayer);
				tempBM.mask = ToolManager.lassoMask;
				
				_copyData.draw(tempBM);
				
				tempBM.mask = null;
				tempBM = null;
				
				if (withCut)
					layerList.currentLayer.draw(ToolManager.lassoMask,null,null,BlendMode.ERASE);
			}
		}
		
		static public function paste():void
		{
			if (!_copyData) return;
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1) ToolManager.toggle(ToolType.CLIP);
			if (ToolManager.activeTools.indexOf(ToolType.LASSO) != -1) ToolManager.toggle(ToolType.LASSO);
			if (ToolManager.activeTools.indexOf(ToolType.TRANSFORM) != -1) ToolManager.toggle(ToolType.TRANSFORM);
			
			ToolManager.clipRect = copyRect;
			TransformTool.instance.splData = _copyData;
			ToolManager.toggle(ToolType.TRANSFORM);
			ToolManager.clipRect = new Rectangle(0, 0, System.canvasWidth, System.canvasHeight);
		}
		
		static public function get copyData():BitmapData 
		{
			return _copyData;
		}
		
		static public function set copyData(value:BitmapData):void 
		{
			_copyData = value;
		}
		
	}

}