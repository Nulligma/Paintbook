package tools.copy_paste 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class CopyPasteTool 
	{
		static private var _instance:CopyPasteTool;
		
		private var _bitData:BitmapData;
		private var activated:Boolean = false;
		
		private var copyData:BitmapData;
		
		public function CopyPasteTool() 
		{
			if (_instance)
				throw new Error("CutPasteTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_bitData = bitData;
			
			if (copyData)
			{
				LayerList.instance.currentLayer.draw(copyData);
				
				copyData.dispose();
				copyData = null;
				
				ToolManager.copyAvail = false;
				
				return;
			}
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
			{
				copyData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
				copyData.copyPixels(_bitData, ToolManager.clipRect, new Point(ToolManager.clipRect.x, ToolManager.clipRect.y));
			}
			else if (ToolManager.lassoMask)
			{
				LayerList.instance.currentLayerObject.bitmap.mask = ToolManager.lassoMask;
				copyData.draw(LayerList.instance.currentLayerObject.bitmap);
				
				LayerList.instance.currentLayerObject.bitmap.mask = null;
			}
			else
			{
				copyData.copyPixels(_bitData, _bitData.rect, new Point(0, 0));
			}
			
			ToolManager.copyAvail = true;
			ToolManager.toggle(ToolType.COPY_PASTE);
			
			activated = true;
		}
		
		public function deactivate():void
		{
			activated = false;
		}
		
		static public function get instance():CopyPasteTool 
		{
			if (!_instance)
				_instance = new CopyPasteTool;
			
			return _instance;
		}
		
		
	}

}