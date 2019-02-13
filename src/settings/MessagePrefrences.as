package settings 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class MessagePrefrences 
	{
		static private var _hideMergeWarning:Boolean;
		static private var _hideDeleteWarning:Boolean;
		static private var _hideDonateWarning:Boolean;
		
		public function MessagePrefrences() 
		{
			
		}
		
		static public function setDefault()
		{
			_hideDeleteWarning = false;
			_hideMergeWarning = false;
			_hideDonateWarning = false;
		}
		
		static public function save():void
		{
			var so:SharedObject = SharedObject.getLocal("Warn", "/");
			
			so.data.hideMergeWarning = _hideMergeWarning;
			so.data.hideDeleteWarning = _hideDeleteWarning;
			so.data.hideDonateWarning = _hideDonateWarning;
		}
		
		static public function load():void
		{
			var so:SharedObject = SharedObject.getLocal("Warn", "/");
			
			if (so.data.hideDeleteWarning == undefined)
			{
				setDefault();
			}
			else
			{
				_hideDeleteWarning = so.data.hideDeleteWarning;
				_hideMergeWarning = so.data.hideMergeWarning;
				_hideDonateWarning = so.data.hideDonateWarning;
			}
		}
		
		static public function get hideMergeWarning():Boolean 
		{
			return _hideMergeWarning;
		}
		
		static public function set hideMergeWarning(value:Boolean):void 
		{
			_hideMergeWarning = value;
		}
		
		static public function get hideDeleteWarning():Boolean 
		{
			return _hideDeleteWarning;
		}
		
		static public function set hideDeleteWarning(value:Boolean):void 
		{
			_hideDeleteWarning = value;
		}
		
		static public function get hideDonateWarning():Boolean 
		{
			return _hideDonateWarning;
		}
		
		static public function set hideDonateWarning(value:Boolean):void 
		{
			_hideDonateWarning = value;
		}
	}

}