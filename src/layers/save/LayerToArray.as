package layers.save 
{
	import fl.motion.Color;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import layers.filters.FiltersManager;
	import layers.setups.LayerList;
	import settings.System;
	import ui.other.OpenUI;
	import utils.bitmapData.AsyncGetPixels;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LayerToArray 
	{
		static private var layerList:LayerList;
		static private var layerObject:Object;
		static private var layerArray:Array;
		static private var progressMsg:String;
		
		static private var currentLoadIndex:int;
		
		static private var _update:Function;
		static private var convertor:AsyncGetPixels;
		
		public function LayerToArray() 
		{
			
		}
		
		static public function save(newCanvas:Boolean = false):void
		{
			layerList = LayerList.instance;
			
			if (newCanvas)
			{
				OpenUI.instance.updatePreivew();
				
				var canvasData:Array = new Array();
				canvasData[0] = System.canvasWidth;
				canvasData[1] = System.canvasHeight;
				
				System.currentCanvasIndex = 0;
				System.currentCanvasIndex = 0;
				System.canvasList.unshift(canvasData);
			}
			
			var tempWidth:int = System.canvasWidth;
			var tempHeight:int = System.canvasHeight;
			
			//var mat:Matrix = new Matrix(1, 0, 0, 1, -System.canvasWidth * 0.5 + System.stageWidth * 0.5, -System.canvasHeight * 0.5 + System.stageHeight * 0.5);
			var bd:BitmapData = new BitmapData(tempWidth, tempHeight, true, 0x000000);
			bd.draw(System.canvas);
			
			layerArray = new Array();
			
			progressMsg = "Processing";
			convertor = new AsyncGetPixels(bd, bd.width, bd.height);
			convertor.addEventListener(AsyncGetPixels.COMPLETE, onPreviewEncoded);
			convertor.addEventListener(ProgressEvent.PROGRESS, onProgress);
			convertor.convert();
		}
		
		static private function onPreviewEncoded(e:Event):void
		{
			var layerPreview:ByteArray = convertor.bytes;
			layerPreview.compress();
			System.canvasList[System.currentCanvasIndex][2] = layerPreview;
			
			layerObject = layerList.tailObject();
			saveNextLayer();
		}
		
		static private function saveNextLayer():void
		{
			if (layerObject == null) 
			{
				saveComplete();
				return;
			}
			
			var layerDataArray:Array = new Array();
				
			layerDataArray.push(layerObject.name);
			layerDataArray.push(layerObject.color);
			
			layerDataArray.push(layerObject.bitmap.visible);
			layerDataArray.push(layerObject.bitmap.alpha);
			layerDataArray.push(layerObject.bitmap.blendMode);
			layerDataArray.push(layerObject.bitmap.filters);
			
			layerDataArray.push(layerObject.tintColor);
			layerDataArray.push(layerObject.tintAlpha);
			
			layerArray.push(layerDataArray);
			
			progressMsg = "Saving " + layerObject.name;
			var bd:BitmapData = layerObject.bitmap.bitmapData;
			convertor = new AsyncGetPixels(bd, bd.width, bd.height);
			convertor.addEventListener(AsyncGetPixels.COMPLETE, onlayerEncoded);
			convertor.addEventListener(ProgressEvent.PROGRESS, onProgress);
			convertor.convert();
		}
		
		static private function onlayerEncoded(e:Event):void 
		{
			var byteArray:ByteArray = convertor.bytes;
			byteArray.compress();
			layerArray[layerArray.length-1].push(byteArray);
			
			layerObject = layerObject.front;
			saveNextLayer();
		}
		
		static private function saveComplete():void 
		{
			System.canvasList[System.currentCanvasIndex][3] = layerArray;
			
			var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
			so.clear();
			so.data.canvasList = System.canvasList;
			
			/*if (so.data.canvasList == undefined || newCanvas)
			{
				so.data.canvasList = canvasList;
			}
			else
			{
				so.data.canvasList[currentIndex] = canvasList[currentIndex];
			}*/
			so.flush();
			so.close();
			_update(-1, -1, "complete");
		}
		
		static private function onProgress(e:ProgressEvent):void 
		{
			_update(e.bytesLoaded, e.bytesTotal, progressMsg);
		}
		
		static public function update(progressUpdater:Function):void
		{
			_update = progressUpdater;
		}
		
		static public function load():void
		{
			var index:int = System.currentCanvasIndex;
			var canvasArray:Array = System.canvasList[index];
			
			System.canvasWidth = canvasArray[0];
			System.canvasHeight = canvasArray[1];
			
			var color:Color;
			var byteArray:ByteArray;
			var layerArray:Array = canvasArray[3];
			
			LayerList.loadWith(new LayerList());
			layerList = LayerList.instance;
			var filterManager:FiltersManager = FiltersManager.getInstance();
			
			for (var i:int = 0; i < layerArray.length; i++)
			{
				layerList.initNewLayer(System.canvasWidth, System.canvasHeight);
				
				layerList.currentLayerObject.name = layerArray[i][0];
				layerList.currentLayerObject.color = layerArray[i][1];
				
				layerList.currentLayerObject.bitmap.visible = layerArray[i][2];
				layerList.currentLayerObject.bitmap.alpha = layerArray[i][3];
				layerList.currentLayerObject.bitmap.blendMode = layerArray[i][4];
				
				for each(var filter:BitmapFilter in layerArray[i][5])
				{
					filter = filter.clone();
					filterManager.add(layerList.currentLayerObject.bitmap, filter);
				}
				
				layerList.currentLayerObject.tintColor = layerArray[i][6];
				layerList.currentLayerObject.tintAlpha = layerArray[i][7];
				
				color = new Color;
				color.setTint(layerArray[i][6], layerArray[i][7]);
				layerList.currentLayerObject.bitmap.transform.colorTransform = color;
				
				byteArray = new ByteArray();
				byteArray.writeBytes(layerArray[i][8]);
				byteArray.uncompress();
				layerList.currentLayerObject.bitmap.bitmapData.setPixels(new Rectangle(0, 0, System.canvasWidth, System.canvasHeight), byteArray);
				
			}
			
			System.createCanvas();
		}
		
	}

}