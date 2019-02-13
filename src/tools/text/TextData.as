package tools.text 
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class TextData 
	{
		static private var _instance:TextData;
		
		private var _size:int;
		private var _bold:Boolean;
		private var _italic:Boolean;
		private var _underline:Boolean;
		private var _smoothness:int;
		private var _align:String;
		private var _opacity:Number;
		private var _autoSize:String;
		
		private var _transform:Boolean;
		
		private var _alignArray:Array = new Array(TextFormatAlign.LEFT,TextFormatAlign.RIGHT,TextFormatAlign.CENTER,TextFormatAlign.JUSTIFY);
		
		public function TextData() 
		{
			if (_instance)
				throw new Error("TextData singleTon Error");
		}
		
		public function setDefault():void
		{
			_size = 30;
			_opacity = 1;
			_bold = false;
			_italic = false;
			_underline = false;
			_transform = false;
			_smoothness = 0;
			_align = TextFormatAlign.LEFT;
			_autoSize = TextFieldAutoSize.LEFT;
			
		}
		
		static public function get instance():TextData 
		{
			if (!_instance)
			{
				_instance = new TextData;
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
		}
		
		public function get bold():Boolean 
		{
			return _bold;
		}
		
		public function set bold(value:Boolean):void 
		{
			_bold = value;
		}
		
		public function get italic():Boolean 
		{
			return _italic;
		}
		
		public function set italic(value:Boolean):void 
		{
			_italic = value;
		}
		
		public function get underline():Boolean 
		{
			return _underline;
		}
		
		public function set underline(value:Boolean):void 
		{
			_underline = value;
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function set align(value:String):void 
		{
			_align = value;
			
			if (value == TextFormatAlign.LEFT)
			{
				_autoSize = TextFieldAutoSize.LEFT;
			}
			else if (value == TextFormatAlign.RIGHT)
			{
				_autoSize = TextFieldAutoSize.RIGHT;
			}
			else
				_autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function get smoothness():int 
		{
			return _smoothness;
		}
		
		public function set smoothness(value:int):void 
		{
			_smoothness = value;
		}
		
		public function get transform():Boolean 
		{
			return _transform;
		}
		
		public function set transform(value:Boolean):void 
		{
			_transform = value;
		}
		
		public function get opacity():Number 
		{
			return _opacity;
		}
		
		public function set opacity(value:Number):void 
		{
			_opacity = value;
		}
		
		public function get autoSize():String 
		{
			return _autoSize;
		}
		
		public function get alignArray():Array 
		{
			return _alignArray;
		}
		
	}

}