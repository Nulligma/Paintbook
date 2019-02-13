package settings
{
	import flash.net.SharedObject;
	import flash.text.Font;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class CustomUI 
	{
		static private var _backColor:uint;
		static private var _color1:uint;
		static private var _color2:uint;
		
		static private var _font:String;
		
		static private var _colorArray:Array;
		static private var _fontArray:Array;
		
		static private var _colorSet:int;
		
		public function CustomUI() 
		{
			
		}
		
		public static function load():void
		{
			_fontArray = new Array("Kelson Sans Regular","Mosk Bold 700","Lobster 1.4","GelPen");
			
			Font.registerFont(Font0);
			Font.registerFont(Font1);
			Font.registerFont(Font2);
			Font.registerFont(Font5);
			
			
			_colorArray = new Array(
										new Array(0x637173, 0xB4BFBB, 0x2F3F48),
										new Array(0x382313, 0xF1EED9, 0x2E221F),
										new Array(0xE65159, 0xF4F7CF, 0xA63343),
										new Array(0x185359, 0xBFB38E, 0x261507),
										new Array(0x6E755F, 0xAFC2AA, 0x403F33),
										new Array(0x594C25, 0xF2E5BD, 0x26240C),
										new Array(0x008584, 0xE9E9E9, 0x006666),
										new Array(0x6B5C39, 0xABC46C, 0x54733E),
										new Array(0x948C75, 0xD9CEB2, 0x7A6A53),
										new Array(0x005F6B, 0x008C9E, 0x343838),
										new Array(0x9ED54C, 0xF0F2DD, 0x59A80F),
										new Array(0x732F41, 0xA6465F, 0x3D322D),
										new Array(0xC5BC8E, 0xEEE6AB, 0x696758),
										new Array(0x83AF9B, 0xF9CDAD, 0xFE4365),
										new Array(0x73626E, 0xF0B49E, 0x413E4A),
										new Array(0x5A3D31, 0xE5EDB8, 0x300018),
										new Array(0xB97F67, 0xF6E2BB, 0x9F5C4D),
										new Array(0x44522F, 0x718351, 0x172214),
										new Array(0x4D3B3B, 0xFFD0B3, 0xDE6262),
										new Array(0x51386E, 0x656566, 0x2A2333),
										new Array(0x718C6A, 0x9FC49F, 0x543122),
										new Array(0x94667A, 0xFFFACC, 0x78485D),
										new Array(0x3E606F, 0x91AA9D, 0x193441),
										new Array(0x69A62D, 0xE5F2B6, 0x1A5908),
										new Array(0x525856, 0xD2CDA3, 0x474B4E),
										new Array(0x13747D, 0xFCF7C5, 0x29221F),
										new Array(0x7F7966, 0xE5DBB8, 0x403D33),
										new Array(0x3B5998, 0xCDD8EA, 0x121436)
									);
			
			var so:SharedObject = SharedObject.getLocal("Theme", "/");
			
			var colorSet:int;
			if (so.data.colorSet == undefined)
			{
				colorSet = 0;
				_font = "Kelson Sans Regular";
			}
			else
			{
				colorSet = so.data.colorSet;
				_font = so.data.font;
			}
			
			
			_colorSet = colorSet;
			_backColor = _colorArray[colorSet][0];
			_color1 = _colorArray[colorSet][1];
			_color2 = _colorArray[colorSet][2];
			
		}
		
		public static function changeColors(colorSet:int):void
		{
			_colorSet = colorSet;
			
			_backColor = _colorArray[colorSet][0];
			_color1 = _colorArray[colorSet][1];
			_color2 = _colorArray[colorSet][2];
			
			/*switch(colorSet)
			{
				
				//Dark ---- light --- darkest
				
				case 0:
					_backColor = 0x2D002D; _color1 = 0xF8E6FF; _color2 = 0x1C001C; break;
				case 1:
					_backColor = 0x6E755F;_color1 = 0xAFC2AA; _color2 = 0x403F33; break;
				case 2:
					_backColor = 0xE65159;_color1 = 0xF4F7CF; _color2 = 0xA63343; break;
				case 3:
					_backColor = 0x594C25;_color1 = 0xF2E5BD; _color2 = 0x26240C; break;
				case 4:
					_backColor = 0x185359; _color1 = 0xBFB38E; _color2 = 0x261507; break;
				case 5:
					_backColor = 0x382313; _color1 = 0xF1EED9; _color2 = 0x2E221F; break;
				case 6:
					_backColor = 0x3E3F41; _color1 = 0xF7F7F7; _color2 = 0x030000; break;
				case 7:
					_backColor = 0x008584; _color1 = 0xE9E9E9; _color2 = 0x006666; break;
				case 8:
					_backColor = 0x1C1919; _color1 = 0x424140; _color2 = 0x000000; break;
				case 9:
					_backColor = 0x637173; _color1 = 0xB4BFBB; _color2 = 0x2F3F48; break;
			}*/
		}
		
		public static function get color1():uint
		{
			return _color1;
		}
		
		public static function get color2():uint
		{
			return _color2;
		}
		
		public static function get backColor():uint
		{
			return _backColor;
		}
		
		public static function get font():String
		{
			return _font;
		}
		
		static public function set font(value:String):void 
		{
			_font = value;
		}
		
		static public function get colorArray():Array 
		{
			return _colorArray;
		}
		
		static public function get fontArray():Array 
		{
			return _fontArray;
		}
		
		static public function get colorSet():int 
		{
			return _colorSet;
		}
	}

}