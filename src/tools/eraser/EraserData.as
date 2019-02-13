package tools.eraser 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import layers.filters.FiltersManager;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class EraserData 
	{
		static private var _instance:EraserData;
		
		private var _size:int;
		private var _pattern:Sprite;
		private var _flow:Number;
		private var _smoothness:int;
		
		private var _blur:BlurFilter;
		private var _filterManager:FiltersManager;
		
		public function EraserData() 
		{
			if (_instance)
				throw new Error("EraserData singleTon Error");
		}
		
		public function setDefault():void
		{
			_size = 30;
			_flow = 1;
			_smoothness = 0;
			_pattern = ToolManager.artBrushSprite[0];
			
			_blur = new BlurFilter;
			_blur.quality = 2;
			
			_filterManager = FiltersManager.getInstance();
			adjustEraser();
		}
		
		public function changePattern(type:String, brushIndex:int):void
		{
			if (type == "Art")
			{
				_pattern = ToolManager.artBrushSprite[brushIndex];
				adjustEraser();
			}
			else if (type == "Calligraphy")
			{
				_pattern = ToolManager.calBrushSprite[brushIndex];
				adjustEraser();
			}
		}
		
		public function getSprites(type:String):Array
		{
			if (type == "Art")
				return ToolManager.artBrushSprite;
			else if (type == "Calligraphy")
				return ToolManager.calBrushSprite;
			
			return new Array;
		}
		
		public function adjustEraser():void
		{
			_pattern.scaleX = _pattern.scaleY = _size * 0.02;
			
			_blur.blurX = _smoothness;
			_blur.blurY = _smoothness;
			
			if (_smoothness > 0)
			{
				var tempBd:BitmapData = new BitmapData(_size, _size, true, 0x000000);
				tempBd.draw(_pattern, _pattern.transform.matrix, _pattern.transform.colorTransform, null, null, true);
				
				var rect:Rectangle = tempBd.generateFilterRect(tempBd.rect, _blur);
				_size = rect.width - rect.x;
			}
			
			if (ToolManager.activeTools.indexOf(ToolType.ERASER)!=-1)
			{
				_filterManager.remove(_pattern, _blur);
				_filterManager.add(_pattern, _blur);
			}
		}
		
		static public function get instance():EraserData 
		{
			if (!_instance)
			{
				_instance = new EraserData;
				_instance.setDefault();
			}
			
			return _instance;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
			adjustEraser();
		}
		
		public function get pattern():Sprite 
		{
			return _pattern;
		}
		
		public function get flow():Number 
		{
			return _flow;
		}
		
		public function set flow(value:Number):void 
		{
			_flow = value;
		}
		
		public function get smoothness():int 
		{
			return _smoothness;
		}
		
		public function set smoothness(value:int):void 
		{
			_smoothness = value;
			adjustEraser();
		}
	}

}