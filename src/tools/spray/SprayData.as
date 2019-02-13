package tools.spray 
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import layers.filters.FiltersManager;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SprayData 
	{
		static private var _instance:SprayData;
		
		private var _size:int;
		private var _psize:int;
		private var _density:int;
		private var _flow:Number;
		private var _smoothness:uint;
		private var _alpha:Number;
		
		private var _randomColor:Boolean;
		private var _randomRotate:Boolean;
		private var _scattering:Boolean;
		
		private var _pattern:Sprite;
		
		private var _blur:BlurFilter;
		private var _filterManager:FiltersManager;
		
		public function SprayData() 
		{
			if (_instance)
				throw new Error("SprayData singleTon Error");
		}
		
		private function setDefault():void 
		{
			_size = 50; _psize = 3;  _flow = 1; _smoothness = 0; _alpha = 1; _density = 10;
			_randomRotate = false; _randomColor = false; _scattering = true;
			
			_pattern = ToolManager.artBrushSprite[0];
			
			_blur = new BlurFilter;
			_blur.quality = 2;
			
			_filterManager = FiltersManager.getInstance();
			
			adjustSpray();
		}
		
		public function adjustSpray():void 
		{
			_pattern.scaleX = _pattern.scaleY = _psize * 0.02;
			
			_blur.blurX = _smoothness;
			_blur.blurY = _smoothness;
			
			if (ToolManager.activeTools.indexOf(ToolType.SPRAY)!=-1)
			{
				_filterManager.remove(_pattern, _blur);
				_filterManager.add(_pattern, _blur);
			}
		}
		
		public function changePattern(type:String, brushIndex:int):void
		{
			if (type == "Art")
			{
				_pattern = ToolManager.artBrushSprite[brushIndex];
				adjustSpray();
			}
			else if (type == "Calligraphy")
			{
				_pattern = ToolManager.calBrushSprite[brushIndex];
				adjustSpray();
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
		
		static public function get instance():SprayData 
		{
			if (!_instance)
			{
				_instance = new SprayData;
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
			adjustSpray();
		}
		
		public function get density():int 
		{
			return _density;
		}
		
		public function set density(value:int):void 
		{
			_density = value;
		}
		
		public function get flow():Number 
		{
			return _flow;
		}
		
		public function set flow(value:Number):void 
		{
			_flow = value;
		}
		
		public function get smoothness():uint 
		{
			return _smoothness;
		}
		
		public function set smoothness(value:uint):void 
		{
			_smoothness = value;
			adjustSpray();
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
		
		public function get randomColor():Boolean 
		{
			return _randomColor;
		}
		
		public function set randomColor(value:Boolean):void 
		{
			_randomColor = value;
		}
		
		public function get randomRotate():Boolean 
		{
			return _randomRotate;
		}
		
		public function set randomRotate(value:Boolean):void 
		{
			_randomRotate = value;
		}
		
		public function get pattern():Sprite 
		{
			return _pattern;
		}
		
		public function get scattering():Boolean 
		{
			return _scattering;
			adjustSpray();
		}
		
		public function set scattering(value:Boolean):void 
		{
			_scattering = value;
			adjustSpray();
		}
		
		public function get psize():int 
		{
			return _psize;
		}
		
		public function set psize(value:int):void 
		{
			_psize = value;
			adjustSpray();
		}
		
	}

}