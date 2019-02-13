package layers.history 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import layers.filters.FiltersManager;
	import layers.setups.LayerList;
	import settings.Prefrences;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class HistoryManager 
	{
		static private var layerList:LayerList;
		
		static private var undoPtrList:Array;
		static private var undoDataList:Array;
		
		static private var index:int;
		static private var currIndex:int;
		
		static private var overrideTools:Array = [ToolType.TRANSFORM, ToolType.SHAPE, ToolType.TEXT, ToolType.SCROLL];
		
		public function HistoryManager() 
		{
			
		}
		
		static public function init():void
		{
			if (undoPtrList)
				flush();
			
			undoPtrList = new Array;
			undoDataList = new Array;
			
			layerList = LayerList.instance;
			
			index = -1;
		}
		
		static public function pushList():void
		{
			if (ToolManager.workingCanvas == System.canvas)
			{
				index == Prefrences.undoLimit?index = 0:index = index+1;
				currIndex = index;
				if (undoPtrList[index] != null && undoDataList[index] != null)
				{
					undoPtrList[index] = null;
					undoDataList[index].bitmapData.dispose();
					undoDataList[index] = null;
				}
				
				undoPtrList[index] = layerList.currentLayerObject;
				undoDataList[index] = new Bitmap(new BitmapData(System.canvasWidth,System.canvasHeight,true,0x000000));
				copy(layerList.currentLayerObject.bitmap,undoDataList[index]);
			}
		}
		
		static public function undo():void
		{
			if (isNull()) return;
			
			if(currIndex == 20 && index == 0) return;
			if(index == currIndex+1) return;
			
			if (overrideTools.indexOf(ToolManager.currentSingleActive) != -1)
			{
				return;
			}
			
			copy(undoDataList[index],undoPtrList[index].bitmap);
			
			//undoPtrList[index] = null;
			//undoDataList[index].bitmapData.dispose();
			//undoDataList[index] = null;
			
			index = index == 0? Prefrences.undoLimit:index - 1;
		}
		
		static public function redo():void
		{
			if (overrideTools.indexOf(ToolManager.currentSingleActive) != -1)
			{
				return;
			}
			
			if(index == currIndex) return;
			
			index == Prefrences.undoLimit?index = 0:index = index+1;
			if (isNull()) return;
			
			copy(undoDataList[index],undoPtrList[index].bitmap);
			
			//undoPtrList[index] = null;
			//undoDataList[index].bitmapData.dispose();
			//undoDataList[index] = null;
		}
		
		static public function flush():void
		{
			if (allNull()) return;
			
			for (var i:int = 0; i < undoPtrList.length; i++)
			{
				if (undoPtrList[i] == null) continue;
				
				undoPtrList[i] = null;
				undoDataList[i].bitmapData.dispose();
				undoDataList[i] = null;
			}
			
			index = -1;
		}
		
		static private function isNull():Boolean
		{
			if(allNull()) return true;
			
			if (undoPtrList[index] != null) return false;
			
			return true;
		}
		
		static private function allNull():Boolean
		{
			if (undoPtrList.length == 0) return true;
			
			for (var i:int = 0; i < undoPtrList.length; i++)
			{
				if (undoPtrList[i] != null) return false;
			}
			
			return true;
		}
		
		static private function copy(orignal:Bitmap,duplicate:Bitmap):void
		{
			duplicate.bitmapData.copyPixels(orignal.bitmapData, orignal.bitmapData.rect, new Point(0, 0));
			
			duplicate.visible = orignal.visible;
			duplicate.alpha = orignal.alpha;
			duplicate.blendMode = orignal.blendMode;
			duplicate.filters = orignal.filters;
			duplicate.transform.colorTransform = orignal.transform.colorTransform;
			
			var fM:FiltersManager = FiltersManager.getInstance();
			fM.updateDictOf(duplicate);
		}
	}

}