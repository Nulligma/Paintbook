package tools.brushes 
{
	import flash.display.Sprite;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Preset 
	{
		static private var defaultPreset:Array;
		static private var presetList:Array;
		static private var _folderNames:Array;
		
		static private var _currentFolder:Array;
		static private var _currnentBrush:int;
		
		static private var brush:BrushData;
		
		public function Preset() 
		{
			
		}
		
		static public function load():void
		{
			brush = BrushData.instance;
			
			defaultPreset = new Array(
										new Array("Default","Brush", "Art", 0, 35, 0.3, 0, 0, 1, 1, false, false, false, false, false),
										new Array("Default","Pressure Brush", "Art", 0, 50, 0.3, 0, 2, 1, 1, false, false, false, false, false),
										new Array("Default","Pencil", "Art", 0, 8, 0.4, 0, 2, 1, 0.9, false, false, false, false, false),
										new Array("Default","Air Brush", "Art", 4, 60, 0.5, 0, 0, 8, 1, false, false, false, false, false),
										new Array("Default","Air Brush-2", "Art", 2, 80, 0.09, 0, 0, 12, 1, false, false, false, false, false),
										new Array("Default","Pen", "Art", 0, 4, 1, 2, 0, 1, 1, false, false, false, false, false),
										new Array("Default","Marker", "Calligraphy", 9, 30, 0.1, 0, 0, 1, 0.75, false, false, false, false, false)
			);
			
			_folderNames = new Array();
			_currentFolder = defaultPreset;
			_currnentBrush = 0;
			
			var so:SharedObject = SharedObject.getLocal("Presets", "/");
			
			if (so.data.presetList == undefined)
			{
				presetList = new Array();
				presetList.push(defaultPreset);
				_folderNames.push("Default");
				so.data.presetList = presetList;
			}
			else
			{
				presetList = so.data.presetList;
				
				for (var i:int = 0; i < presetList.length; i++)
				{
					_folderNames.push(presetList[i][0][0]);
				}
			}
		}
		
		static public function save(folderIndex:int, folderName:String, brushName:String, createFolder:Boolean):void
		{
			var newPreset:Array = new Array(folderName,
										  brushName,
										  brush.type,
										  brush.brushIndex,
										  brush.size,
										  brush.flow,
										  brush.smoothness,
										  brush.pressureSensivity,
										  brush.spacing,
										  brush.alpha,
										  brush.xSymmetry,
										  brush.ySymmetry,
										  brush.randomRotate,
										  brush.scattering,
										  brush.randomColor
			);
			
			if (!createFolder)
			{
				presetList[folderIndex].push(newPreset);
				
				_currentFolder = presetList[folderIndex];
				_currnentBrush = presetList[folderIndex].length - 1;
			}
			else
			{
				_folderNames.push(folderName);
				
				presetList[presetList.length] = new Array();
				presetList[presetList.length - 1].push(newPreset);
				
				_currentFolder = presetList[presetList.length - 1];
				_currnentBrush = presetList[presetList.length - 1].length - 1;
			}
			
			var so:SharedObject = SharedObject.getLocal("Presets", "/");
			so.clear();
			so.data.presetList = presetList;
			so.flush();
			so.close();
		}
		
		static public function get currentFolder():Array 
		{
			return _currentFolder;
		}
		
		static public function setCurrentFolder(index:int):void 
		{
			_currentFolder = presetList[index];
		}
		
		static public function get currnentBrush():int 
		{
			return _currnentBrush;
		}
		
		static public function set currnentBrush(value:int):void 
		{
			_currnentBrush = value;
		}
		
		static public function get folderNames():Array 
		{
			return _folderNames;
		}
		
	}

}