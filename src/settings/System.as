package settings 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class System 
	{
		static private var _canvasWidth:int;
		static private var _canvasHeight:int;
		static private var _canvasBounds:Rectangle;
		static private var _currentCanvasIndex:int;
		
		static private var _baseCanvas:Sprite;
		
		static private var layerList:LayerList;
		static private var _canvasList:Array;
		
		static private var _stageWidth:int;
		static private var _stageHeight:int;
		
		static private var _isFullScreen:Boolean;
		
		public function System() 
		{
			
		}
		
		public static function createCanvas():void
		{
			_canvasBounds = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
			
			_baseCanvas = new Sprite;
			_baseCanvas.graphics.beginFill(0xFFFFFF); 
			_baseCanvas.graphics.drawRect(0, 0, _canvasWidth, _canvasHeight); 
			_baseCanvas.graphics.endFill();
			
			var layerObject:Object;
			
			layerList = LayerList.instance;
			
			if (layerList.tailObject() == null)
			{
				layerList.initNewLayer(_canvasWidth, _canvasHeight);
				layerObject = layerList.tailObject();
				
				_baseCanvas.addChild(layerObject.bitmap);
			}
			else
			{
				layerObject = layerList.tailObject();
				while (layerObject != null)
				{
					_baseCanvas.addChild(layerObject.bitmap);
					layerObject = layerObject.front;
				}
			}
			
			if (!ToolManager.initialized)
			{
				ToolManager.initTool();
			}
			
			ToolManager.clipRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
			
			HistoryManager.init();
			ToolManager.workArea(_baseCanvas, layerList.currentLayer);
		}
		
		public static function get canvas():Sprite
		{
			return _baseCanvas;
		}
		
		public static function updateCanvas():void
		{
			if (ToolManager.activeTools.indexOf(ToolType.TRANSFORM) != -1 || ToolManager.activeTools.indexOf(ToolType.SHAPE) != -1 || ToolManager.activeTools.indexOf(ToolType.TEXT) != -1)
			{
				ToolManager.toggle(ToolManager.currentSingleActive);
			}
			for (var i:int = 0; i < ToolType.selectionTools.length; i++)
			{
				if (ToolManager.activeTools.indexOf(ToolType.selectionTools[i]) != -1)
				{
					ToolManager.toggle(ToolType.selectionTools[i]);
				}
			}
			
			while (_baseCanvas.numChildren > 0)
			{
				_baseCanvas.removeChildAt(0);
			}
			
			var layerObject:Object = layerList.tailObject();
			while (layerObject != null)
			{
				_baseCanvas.addChild(layerObject.bitmap);
				layerObject = layerObject.front;
			}
		}
		
		static public function get canvasWidth():int 
		{
			return _canvasWidth;
		}
		
		static public function set canvasWidth(value:int):void 
		{
			_canvasWidth = value;
		}
		
		static public function get canvasHeight():int 
		{
			return _canvasHeight;
		}
		
		static public function set canvasHeight(value:int):void 
		{
			_canvasHeight = value;
		}
		
		static public function get canvasList():Array 
		{
			return _canvasList;
		}
		
		static public function get currentCanvasIndex():int 
		{
			return _currentCanvasIndex;
		}
		
		static public function set currentCanvasIndex(value:int):void 
		{
			_currentCanvasIndex = value;
		}
		
		static public function get stageWidth():int 
		{
			return _stageWidth;
		}
		
		static public function get stageHeight():int 
		{
			return _stageHeight;
		}
		
		static public function set stageWidth(value:int):void 
		{
			_stageWidth = value;
		}
		
		static public function set stageHeight(value:int):void 
		{
			_stageHeight = value;
		}
		
		static public function get canvasBounds():Rectangle 
		{
			return _canvasBounds;
		}
		
		static public function get isFullScreen():Boolean 
		{
			return _isFullScreen;
		}
		
		static public function set isFullScreen(value:Boolean):void 
		{
			_isFullScreen = value;
		}
		
		static public function loadCanvasList(list:Array = null):void
		{
			if (list != null)
			{
				_canvasList = list;
				
				//var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
				//so.clear();
				
				//so.data.canvasList = _canvasList;
				
				return;
			}
			
			try 
			{
				var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
				
				if (so.data.canvasList == undefined)
				{
					_canvasList = new Array();
				}
				else
				{
					_canvasList = so.data.canvasList;
				}
				
				so.close();
			} 
			catch (err:Error) 
			{
				trace(err);
			}
		}
		
	}

}