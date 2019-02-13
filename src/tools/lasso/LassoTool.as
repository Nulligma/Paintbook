package tools.lasso 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LassoTool 
	{
		private static var _instance:LassoTool
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean = false;
		private var regionSprite:Sprite;
		private var dummySprite:Sprite;
		private var layerList:LayerList;
		private var pressed:Boolean = false;
		private var startX:Number;
		private var startY:Number;
		
		public function LassoTool() 
		{
			if (_instance)
				throw new Error("LassoTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData)
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList = LayerList.instance;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown,false,20);
			
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
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
			{
				ToolManager.toggle(ToolType.CLIP);
			}
			
			if (!regionSprite)
			{
				regionSprite = new Sprite();
				regionSprite.graphics.lineStyle(1, 0x00CCFF);
				regionSprite.graphics.moveTo(_canvas.mouseX, _canvas.mouseY);
				
				dummySprite = new Sprite();
				dummySprite.graphics.beginFill(0x000000, 1);
				dummySprite.graphics.moveTo(_canvas.mouseX, _canvas.mouseY);
			}
			else
			{
				regionSprite.graphics.clear();
				regionSprite.graphics.lineStyle(1, 0x00CCFF);
				regionSprite.graphics.moveTo(_canvas.mouseX, _canvas.mouseY);
				
				dummySprite.graphics.clear();
				dummySprite.graphics.beginFill(0x000000, 1);
				dummySprite.graphics.moveTo(_canvas.mouseX, _canvas.mouseY);
			}
			_canvas.addChildAt(regionSprite, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			
			startX = _canvas.mouseX;
			startY = _canvas.mouseY;
			
			pressed = true;
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			regionSprite.graphics.lineTo(_canvas.mouseX, _canvas.mouseY);
			dummySprite.graphics.lineTo(_canvas.mouseX, _canvas.mouseY);
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (!pressed)
			{	return;		}
			
			regionSprite.graphics.lineTo(startX, startY);
			
			pressed = false;
			
			ToolManager.lassoMask = dummySprite;
			
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			ToolManager.lassoMask = null;
			
			/*if (tempBitData)
			{
				_bitData.copyPixels(tempBitData, tempBitData.rect, new Point(tempBitMap.x, tempBitMap.y));
				
				_canvas.removeChild(tempBitMap);
				tempBitMap = null;
				tempBitData.dispose();
				tempBitData = null;
			}*/
			
			if (regionSprite)
			{
				_canvas.removeChild(regionSprite);
				regionSprite = null;
			}
			
			activated = false;
		}
		
		static public function get instance():LassoTool 
		{
			if (!_instance)
				_instance = new LassoTool();
			return _instance;
		}
		
	}

}