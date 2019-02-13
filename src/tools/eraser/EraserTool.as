package tools.eraser 
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class EraserTool 
	{
		static private var _instance:EraserTool;
		
		private var eraser:EraserData = EraserData.instance;
		
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		
		private var activated:Boolean = false;
		
		private var toolSize:int;
		private var toolOffset:Number;
		private var basePoint:Point;
		private var eraseBitData:BitmapData;
		private var pattern:Sprite;
		private var rect:Rectangle;
		
		private var cX:Number;
		private var cY:Number;
		private var oldX:Number;
		private var oldY:Number;
		private var newX:Number;
		private var newY:Number;
		private var clipRect:Rectangle;
		private var subRect:Rectangle;
		private var bitDataClone:BitmapData;
		
		//TODO:Redesign eraser
		
		public function EraserTool() 
		{
			if (_instance)
				throw new Error("EraserTool singleTon Error");
			
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			clipRect = ToolManager.clipRect;
			
			eraser.adjustEraser();
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			HistoryManager.pushList();
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1 || ToolManager.activeTools.indexOf(ToolType.LASSO) != -1) 
			{
				if (bitDataClone)
					bitDataClone.dispose();
				
				bitDataClone = _bitData.clone();
			}
			
			toolSize = eraser.size;
			toolOffset = toolSize / 2;
			
			basePoint = new Point(0, 0);
			
			pattern = eraser.pattern;
			pattern.x = pattern.y = toolOffset;
			
			eraseBitData = new BitmapData(toolSize, toolSize, true, 0XFFFFFFFF);
			rect = eraseBitData.rect;
			
			var cT:ColorTransform = new ColorTransform;
			cT.alphaMultiplier = eraser.flow;
			eraseBitData.draw(pattern,pattern.transform.matrix,cT);
			eraseBitData.copyChannel(eraseBitData, eraseBitData.getColorBoundsRect(0xFFFFFF, 0xFFFFFF, false), basePoint, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			
			oldX = _canvas.mouseX - toolOffset;
			oldY = _canvas.mouseY - toolOffset;
			
			if(clipRect.contains(oldX,oldY))
				_bitData.copyPixels(_bitData, new Rectangle(oldX, oldY, toolSize, toolSize), new Point(oldX, oldY), eraseBitData, basePoint, false);
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			newX = _canvas.mouseX - toolOffset;
			newY = _canvas.mouseY - toolOffset;
			
			erase(oldX, oldY, newX, newY);
			
			oldX = newX;
			oldY = newY;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
			{
				bitDataClone.copyPixels(_bitData, clipRect, new Point(clipRect.x, clipRect.y));
				_bitData.copyPixels(bitDataClone, bitDataClone.rect, new Point(0, 0));
			}
			else if (ToolManager.activeTools.indexOf(ToolType.LASSO) != -1)
			{
				bitDataClone.draw(ToolManager.lassoMask, null, null, BlendMode.ERASE);
				
				LayerList.instance.currentLayerObject.bitmap.mask = ToolManager.lassoMask;
				bitDataClone.draw(LayerList.instance.currentLayerObject.bitmap);
				LayerList.instance.currentLayerObject.bitmap.mask = null;
				
				_bitData.copyPixels(bitDataClone, bitDataClone.rect, new Point(0, 0));
			}
			
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function erase(x:Number, y:Number, x2:Number, y2:Number):void 
		{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
			var X:int;
			var Y:int;
			
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
			{
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
				
				var yLonger:Boolean = true;
			}
			else
			{
				yLonger = false;
			}
			
			var inc:int = longLen < 0 ? -1 : 1;
			
			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;
			
			if (yLonger)
			{
				for (var i:int = 0; i != longLen; i += inc)
				{
					X = x + i*multDiff;
					Y = y + i;
					
					//if(clipRect.contains(X,Y))
						_bitData.copyPixels(_bitData, new Rectangle(X, Y, toolSize, toolSize), new Point(X, Y), eraseBitData, basePoint, false);
					/*else
					{
						subRect = clipRect.intersection(new Rectangle(X, Y, toolSize, toolSize));
						_bitData.copyPixels(_bitData, subRect, subRect.topLeft, eraseBitData, basePoint, false);
					}*/
				}
			}
			else
			{
				for (i = 0; i != longLen; i += inc)
				{
					X = x+i;
					Y = y+i*multDiff;
					
					//if(clipRect.contains(X,Y))
						_bitData.copyPixels(_bitData, new Rectangle(X, Y, toolSize, toolSize), new Point(X, Y), eraseBitData, basePoint, false);
					/*else
					{
						subRect = clipRect.intersection(new Rectangle(X, Y, toolSize, toolSize));
						_bitData.copyPixels(_bitData, subRect, subRect.topLeft, eraseBitData, basePoint, false);
					}*/
				}
			}
		}
		
		static public function get instance():EraserTool 
		{
			if (!_instance)
				_instance = new EraserTool;
			
			return _instance;
		}
		
		public function deactivate():void
		{
			if (bitDataClone)
				bitDataClone.dispose();
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
		}
		
	}

}