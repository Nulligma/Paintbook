package tools.blur 
{
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BlurData 
	{
		static private var _instance:BlurData;
		
		private var _size:int;
		private var _strength:Number;
		private var _type:int;
		
		public function BlurData() 
		{
			if (_instance)
				throw new Error("BlurData singleTon Error");
		}
		
		public function setDefault():void
		{
			_size = 30; 
			_strength = 3;
			_type = 0;
		}
		
		static public function get instance():BlurData 
		{
			if (!_instance)
			{
				_instance = new BlurData;
				_instance.setDefault();
			}
			
			return _instance;
		}
		
		public function get strength():Number 
		{
			return _strength;
		}
		
		public function set strength(value:Number):void 
		{
			_strength = value;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
	}

}