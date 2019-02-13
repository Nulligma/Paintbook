package tools.shape 
{
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ShapeData 
	{
		static private var _instance:ShapeData;
		
		private var _size:int;
		private var _designType:String;
		private var _lineThickness:int;
		private var _edges:uint;
		
		public static var POLYGON:String = "polygon";
		public static var STAR:String = "star";
		public static var CIRCLE:String = "circle";
		
		private var _typeArray:Array = new Array("polygon", "star", "circle","square");
		
		public function ShapeData() 
		{
			if (_instance)
				throw new Error("ShapeData singleTon Error");
		}
		
		private function setDefault():void
		{
			_size = 40;
			_designType = "circle";
			_lineThickness = 2;
			_edges = 5;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
		}
		
		public function get designType():String 
		{
			return _designType;
		}
		
		public function set designType(value:String):void 
		{
			_designType = value;
		}
		
		public function get lineThickness():int 
		{
			return _lineThickness;
		}
		
		public function set lineThickness(value:int):void 
		{
			_lineThickness = value;
		}
		
		public function get edges():uint 
		{
			return _edges;
		}
		
		public function set edges(value:uint):void 
		{
			_edges = value;
		}
		
		static public function get instance():ShapeData 
		{
			if (!_instance)
			{
				_instance = new ShapeData;
				_instance.setDefault();
			}
			return _instance;
		}
		
		public function get typeArray():Array 
		{
			return _typeArray;
		}
		
	}

}