package tools.transform 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	
	public class TransformTool 
	{
		static private var _instance:TransformTool;
		
		private var layerList:LayerList;
		
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		
		private var pressed:Boolean = false;
		private var oldX:Number;
		private var oldY:Number;
		
		private var clipX:Number;
		private var clipY:Number;
		private var clipRect:Rectangle;
		private var regionSprite:Sprite = new Sprite;
		
		private var freeTrans:FreeTransform;
		private var tempData:BitmapData;
		
		private var activated:Boolean = false;
		
		private var _splData:BitmapData;

		public function TransformTool():void
		{
			if (_instance)
				throw new Error("TransformTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList= LayerList.instance;
			
			init();
			activated = true;
		}
		
		private function init():void
		{
			clipRect = new Rectangle(0,0,_canvas.width,_canvas.height);
			
			if (ToolManager.clipRect && (ToolManager.clipRect.width != System.canvasWidth || ToolManager.clipRect.height != System.canvasHeight))
			{
				HistoryManager.pushList();
				
				copyFrom(ToolManager.clipRect);
				
				if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
					ToolManager.toggle(ToolType.CLIP);
			}
			else if (ToolManager.lassoMask)
			{
				HistoryManager.pushList();
				
				var bm:Bitmap = new Bitmap(_bitData);
				bm.mask = ToolManager.lassoMask;
				
				var bd1:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
				bd1.draw(bm);
				bm.mask = null;
				var rect:Rectangle = bd1.getColorBoundsRect(0xFF000000, 0x00000000,false);
				
				var bd:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
				bd.copyPixels(bd1, rect, new Point(0, 0));
				
				_bitData.draw(ToolManager.lassoMask, null, null, BlendMode.ERASE);
				
				freeTrans = new FreeTransform({bitData:bd});
				freeTrans.x = rect.x+rect.width*0.5;
				freeTrans.y = rect.y+rect.height*0.5;
				_canvas.addChildAt(freeTrans, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
				
				bm = null;
				bd1.dispose();
				bd = null;
				
				if (ToolManager.activeTools.indexOf(ToolType.LASSO) != -1)
					ToolManager.toggle(ToolType.LASSO);
			}
			else if (_splData)
			{
				HistoryManager.pushList();
				
				copyFrom(ToolManager.clipRect);
			}
			else
			{
				_canvas.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				_canvas.addEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
			HistoryManager.pushList();
			
			oldX = _canvas.mouseX;oldY = _canvas.mouseY;
			clipX = _canvas.mouseX; clipY = _canvas.mouseY;
			_canvas.addChild(regionSprite);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void
		{
			clipX = _canvas.mouseX; clipY = _canvas.mouseY;
			regionSprite.graphics.clear();
			regionSprite.graphics.lineStyle(1,0x00CCFF);
			regionSprite.graphics.drawRect(oldX, oldY, clipX - oldX, clipY - oldY);
		}
		
		private function onUp(e:MouseEvent):void
		{
			var tempWidth:Number = clipX-oldX==0?1:Math.abs(clipX-oldX);
			var tempHeight:Number = clipY-oldY==0?1:Math.abs(clipY-oldY);
			
			var tempX:Number = clipX>oldX?oldX:clipX;
			var tempY:Number = clipY>oldY?oldY:clipY;
			
			clipRect = new Rectangle(tempX,tempY,tempWidth,tempHeight);
			
			if(clipX == oldX || clipY==oldY || clipRect.width <= 1 || clipRect.height <= 1)
				return;
			
			copyFrom(clipRect);
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function copyFrom(rect:Rectangle)
		{
			tempData = new BitmapData(rect.width,rect.height);
			tempData.copyPixels(_splData?_splData:_bitData, rect, new Point(0, 0));
			
			freeTrans = new FreeTransform({bitData:tempData});
			freeTrans.x = rect.x + rect.width * 0.5;
			freeTrans.y = rect.y + rect.height * 0.5;
			_canvas.addChildAt(freeTrans, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			
			if (!_splData)
				_bitData.fillRect(rect, 0x00000000);
			
			if(regionSprite.stage)
				_canvas.removeChild(regionSprite);
			
			tempData = null;
		}
		
		public function deactivate():void
		{
			if (freeTrans) 
			{
				freeTrans.clearAll();
				
				_bitData.draw(freeTrans,freeTrans.transform.matrix);
				_canvas.removeChild(freeTrans);
				freeTrans = null;
			}
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
			_splData = null;
		}
		
		static public function get instance():TransformTool 
		{
			if (!_instance)
				_instance = new TransformTool;
			
			return _instance;
		}
		
		public function set splData(value:BitmapData):void 
		{
			_splData = value;
		}
	}
	
}
