package tools.smudge 
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import layers.filters.FiltersManager;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SmudgeData 
	{
		static private var _instance:SmudgeData;
		
		private var _size:int;
		private var _flow:Number;
		private var _smoothness:int;
		private var _blend:String;
		private var _blur:BlurFilter;
		private var _filterManager:FiltersManager;
		private var _pattern:Sprite;
		
		private var _blendArray:Array = new Array( BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT );
		
		public function SmudgeData() 
		{
			if (_instance)
				throw new Error("SmudgeData singleTon Error");
		}
		
		private function setDefault():void 
		{
			_size = 30; 
			_flow = 0.5; 
			_smoothness = 0;
			_blend = BlendMode.NORMAL;
			
			_pattern = ToolManager.artBrushSprite[0];
			
			_blur = new BlurFilter;
			_blur.quality = 2;
			
			_filterManager = FiltersManager.getInstance();
			
			adjustSmudge();
		}
		
		public function adjustSmudge():void 
		{
			_pattern.scaleX = _pattern.scaleY = _size * 0.02;
			
			_blur.blurX = _smoothness;
			_blur.blurY = _smoothness;
			
			if (ToolManager.activeTools.indexOf(ToolType.SMUDGE)!=-1)
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
				adjustSmudge();
			}
			else if (type == "Calligraphy")
			{
				_pattern = ToolManager.calBrushSprite[brushIndex];
				adjustSmudge();
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
		
		static public function get instance():SmudgeData 
		{
			if (!_instance)
			{
				_instance = new SmudgeData;
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
			adjustSmudge();
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
			adjustSmudge();
		}
		
		public function get blend():String 
		{
			return _blend;
		}
		
		public function set blend(value:String):void 
		{
			_blend = value;
		}
		
		public function get pattern():Sprite 
		{
			return _pattern;
		}
		
		public function get blendArray():Array 
		{
			return _blendArray;
		}
		
	}

}