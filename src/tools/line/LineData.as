package tools.line 
{
	import flash.display.CapsStyle;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LineData 
	{
		static private var _instance:LineData;
		
		private var _size:int;
		private var _opacity:Number;
		private var _smoothness:int;
		private var _cap:String;
		private var _snapX:Boolean;
		private var _snapY:Boolean;
		private var _lineTrail:Boolean;
		
		private var _lineMode:Boolean;
		
		private var _capArray:Array = new Array(CapsStyle.NONE, CapsStyle.ROUND, CapsStyle.SQUARE);
		
		public function LineData() 
		{
			if (_instance)
				throw new Error("LineData singleTon Error");
		}
		
		public function setDefault():void
		{
			_size = 10; 
			_opacity = 1;
			_smoothness = 0;
			_cap = CapsStyle.ROUND;
			_snapX = false;
			_snapY = false;
			_lineTrail = false;
			
			_lineMode = true;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
		}
		
		public function get opacity():Number 
		{
			return _opacity;
		}
		
		public function set opacity(value:Number):void 
		{
			_opacity = value;
		}
		
		public function get smoothness():int 
		{
			return _smoothness;
		}
		
		public function set smoothness(value:int):void 
		{
			_smoothness = value;
		}
		
		public function get cap():String 
		{
			return _cap;
		}
		
		public function set cap(value:String):void 
		{
			_cap = value;
		}
		
		public function get snapX():Boolean 
		{
			return _snapX;
		}
		
		public function set snapX(value:Boolean):void 
		{
			_snapX = value;
		}
		
		public function get snapY():Boolean 
		{
			return _snapY;
		}
		
		public function set snapY(value:Boolean):void 
		{
			_snapY = value;
		}
		
		public function get lineTrail():Boolean 
		{
			return _lineTrail;
		}
		
		public function set lineTrail(value:Boolean):void 
		{
			_lineTrail = value;
		}
		
		public function get lineMode():Boolean 
		{
			return _lineMode;
		}
		
		public function set lineMode(value:Boolean):void 
		{
			_lineMode = value;
		}
		
		public function get capArray():Array 
		{
			return _capArray;
		}
		
		static public function get instance():LineData 
		{
			if (!_instance)
			{
				_instance = new LineData;
				_instance.setDefault();
			}
			return _instance;
		}
		
	}

}