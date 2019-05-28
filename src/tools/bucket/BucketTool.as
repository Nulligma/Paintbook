package tools.bucket 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import tools.ToolManager;
	import ui.other.DrawGrid;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BucketTool 
	{
		static private var _instance:BucketTool;
		private var _bitData:BitmapData;
		private var _canvas:Sprite;
		private var activated:Boolean = false;
		private var color:uint;
		private var clipRect:Rectangle;
		
		public function BucketTool() 
		{
			if (_instance)
				throw new Error("BucketTool singleTon Error");
		}
		
		public function activate(canvas:Sprite,bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			_canvas.addEventListener(MouseEvent.CLICK, onClick);
			
			activated = true;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			clipRect = ToolManager.clipRect;
			
			if(DrawGrid.area && ToolManager.grid.visible && DrawGrid.area.contains(_canvas.mouseX, _canvas.mouseY))
			{
				var aX:Number = _canvas.mouseX - DrawGrid.area.x;
				var bX:uint = aX/DrawGrid.cell.width;
				
				var cX:uint = DrawGrid.cell.width * bX;
				var dX:Number = DrawGrid.area.x + cX;
				
				var aY:Number = _canvas.mouseY - DrawGrid.area.y;
				var bY:uint = aY/DrawGrid.cell.height;
				
				var cY:uint = DrawGrid.cell.height * bY;
				var dY:Number = DrawGrid.area.y + cY;
				
				DrawGrid.cell.x = dX;
				DrawGrid.cell.y = dY;
				
				clipRect = DrawGrid.cell;
			}
			
			HistoryManager.pushList();
			
			color = 0;
			color += ToolManager.fillColor;
			color += (0xFF << 24);
			
			var tempData:BitmapData;
			
			if (ToolManager.lassoMask)
			{
				var bd:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
				bd.draw(ToolManager.lassoMask);
				
				tempData = _bitData.clone();
				tempData.floodFill(_canvas.mouseX, _canvas.mouseY, color);
				
				tempData.copyPixels(tempData, tempData.rect, new Point(0, 0), bd, new Point(0, 0));
				_bitData.draw(ToolManager.lassoMask,null,null,BlendMode.ERASE);
				_bitData.draw(tempData);
				
				bd.dispose();
				tempData.dispose();
			}
			else if (clipRect.height == _bitData.height && clipRect.width == _bitData.width)
				_bitData.floodFill(_canvas.mouseX, _canvas.mouseY, color);
			else
			{
				if (!clipRect.contains(_canvas.mouseX, _canvas.mouseY)) return;
				
				tempData = new BitmapData(clipRect.width, clipRect.height, true, 0x000000);
				//var rect:Rectangle = new Rectangle(_canvas.mouseX - clipRect.width * 0.5, _canvas.mouseY - clipRect.height * 0.5, clipRect.width * 0.5, clipRect.height * 0.5);
				tempData.copyPixels(_bitData, clipRect, new Point(0, 0));
				
				tempData.floodFill(_canvas.mouseX - clipRect.x, _canvas.mouseY - clipRect.y, color);
				
				_bitData.copyPixels(tempData, tempData.rect, new Point(clipRect.x, clipRect.y));
				tempData.dispose();
			}
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		static public function get instance():BucketTool 
		{
			if (!_instance)
				_instance = new BucketTool;
			return _instance;
		}
		
	}

}