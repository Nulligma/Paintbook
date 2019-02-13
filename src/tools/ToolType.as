package tools 
{
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ToolType 
	{
		static public const BRUSH:int = 0;
		static public const ERASER:int = 1;
		static public const SPRAY:int = 2;
		static public const LINE:int = 3;
		static public const TEXT:int = 4;
		static public const TRANSFORM:int = 5;
		
		static public const BLUR:int = 6;
		static public const SMUDGE:int = 7;
		static public const BUCKET:int = 8;
		static public const SHAPE:int = 9;
		static public const SCROLL:int = 10;
		static public const CLIP:int = 11;
		static public const LASSO:int = 12;
		static public const MAG_GLASS:int = 13;
		static public const PICKER:int = 14;
		
		static public const TOTAL_TOOLS = 15;
		
		static private var _multiActive:Array = new Array(CLIP, MAG_GLASS, LASSO);
		
		static private var _selectionTools:Array = new Array(CLIP, LASSO, SCROLL, TRANSFORM); // Used in System.updateCanvas();
		
		public function ToolType() 
		{
			
		}
		
		static public function get multiActive():Array 
		{
			return _multiActive;
		}
		
		static public function get selectionTools():Array 
		{
			return _selectionTools;
		}
		
	}

}