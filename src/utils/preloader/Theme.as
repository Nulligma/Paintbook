package utils.preloader 
{
	import flash.display.GradientType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Theme 
	{
		static private var _bgType:String;
		static private var _bgColors:Array;
		static private var _bgAlpha:Array;
		static private var _bgRatio:Array;
		
		static private var _loaderType:String;
		static private var _loaderColors:Array;
		static private var _loaderAlpha:Array;
		static private var _loaderRatio:Array;
		
		public function Theme() 
		{
			
		}
		
		static public function setTheme()
		{
			_bgType= GradientType.LINEAR;
			_bgColors= [0x000000, 0x333333];
			_bgAlpha = [1,1];
			_bgRatio = [0,255];
			
			_loaderType = GradientType.LINEAR;
			_loaderColors = [0x66CC00, 0x336600];
			_loaderAlpha = [1,1];
			_loaderRatio = [0,255];
		}
		
		static public function get bgType():String 
		{
			return _bgType;
		}
		
		static public function get bgColors():Array 
		{
			return _bgColors;
		}
		
		static public function get bgAlpha():Array 
		{
			return _bgAlpha;
		}
		
		static public function get bgRatio():Array 
		{
			return _bgRatio;
		}
		
		static public function get loaderType():String 
		{
			return _loaderType;
		}
		
		static public function get loaderColors():Array 
		{
			return _loaderColors;
		}
		
		static public function get loaderAlpha():Array 
		{
			return _loaderAlpha;
		}
		
		static public function get loaderRatio():Array 
		{
			return _loaderRatio;
		}
		
	}

}