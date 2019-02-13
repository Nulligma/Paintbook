package tools.clip 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ClipTool 
	{
		static private var _instance:ClipTool;
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean;
		
		private var regionSprite:Sprite;
		
		private var startY:Number;
		private var startX:Number;
		private var clipX:Number = 0;
		private var clipY:Number = 0;
		private var pressed:Boolean = false;
		private var layerList:LayerList;
		
		public function ClipTool() 
		{
			if (_instance)
				throw new Error("ClipTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList= LayerList.instance;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown,false,1);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			if (ToolManager.currentSingleActive != -1)
			{
				if (regionSprite)
				{
					_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
					return;
				}
				ToolManager.toggle(ToolManager.currentSingleActive);
			}
			
			if (ToolManager.activeTools.indexOf(ToolType.LASSO) != -1)
			{
				ToolManager.toggle(ToolType.LASSO);
			}
			
			if (!regionSprite)
			{
				regionSprite = new Sprite;
				_canvas.addChildAt(regionSprite, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			}
			else
			{
				regionSprite.graphics.clear();
			}
			
			startX = _canvas.mouseX;
			startY = _canvas.mouseY;
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			pressed = true;
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (pressed) 
			{
				clipX = _canvas.mouseX;
				clipY = _canvas.mouseY;
				
				regionSprite.graphics.clear();
				regionSprite.graphics.lineStyle(1, 0x00CCFF);
				regionSprite.graphics.drawRect(startX,startY,clipX-startX,clipY-startY);
			}
			
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (!pressed)
			{	return;		}
			
			if (clipX != 0 && clipY != 0)
			{
				var tempWidth:Number = clipX-startX==0?1:Math.abs(clipX-startX);
				var tempHeight:Number = clipY-startY==0?1:Math.abs(clipY-startY);
				
				var tempX:Number = clipX>startX?startX:clipX;
				var tempY:Number = clipY > startY?startY:clipY;
				
				ToolManager.clipRect = new Rectangle(tempX, tempY, tempWidth, tempHeight);
			}
			else
				ToolManager.clipRect = new Rectangle(0, 0, System.canvasWidth, System.canvasHeight);
			
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			pressed = false;
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			ToolManager.clipRect = new Rectangle(0, 0, System.canvasWidth, System.canvasHeight);
			
			if (regionSprite)
			{
				_canvas.removeChild(regionSprite);
				regionSprite = null;
			}
		}
		
		static public function get instance():ClipTool 
		{
			if (!_instance)
				_instance = new ClipTool;
			return _instance;
		}
		
	}

}