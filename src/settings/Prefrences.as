package settings 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Prefrences 
	{
		static private var _hideMenu:Boolean;
		static private var _layerPreview:Boolean;
		static private var _saveOnClose:Boolean;
		
		static private var _undoLimit:int;
		
		public function Prefrences() 
		{
			
		}
		
		static public function setDefault():void
		{
			_hideMenu = false;
			_layerPreview = true;
			_saveOnClose = true;
			_undoLimit = 20;
		}
		
		static public function save():void
		{
			var so:SharedObject = SharedObject.getLocal("Pref", "/");
			
			so.data.hideMenu = _hideMenu;
			so.data.layerPreview = _layerPreview;
			so.data.saveOnClose = _saveOnClose;
			so.data.undoLimit = _undoLimit;
		}
		
		static public function load():void
		{
			var so:SharedObject = SharedObject.getLocal("Pref", "/");
			
			if (so.data.hideMenu == undefined)
			{
				setDefault();
			}
			else
			{
				_hideMenu = so.data.hideMenu;
				_layerPreview = so.data.layerPreview;
				_saveOnClose = so.data.saveOnClose;
				_undoLimit = so.data.undoLimit;
			}
		}
		
		static public function get hideMenu():Boolean 
		{
			return _hideMenu;
		}
		
		static public function set hideMenu(value:Boolean):void 
		{
			_hideMenu = value;
		}
		
		static public function get layerPreview():Boolean 
		{
			return _layerPreview;
		}
		
		static public function set layerPreview(value:Boolean):void 
		{
			_layerPreview = value;
		}
		
		static public function get undoLimit():int 
		{
			return _undoLimit;
		}
		
		static public function set undoLimit(value:int):void 
		{
			_undoLimit = value;
		}
		
		static public function get saveOnClose():Boolean 
		{
			return _saveOnClose;
		}
		
		static public function set saveOnClose(value:Boolean):void 
		{
			_saveOnClose = value;
		}
		
	}
}