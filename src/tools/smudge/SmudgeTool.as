package tools.smudge 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
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
	public class SmudgeTool 
	{
		static private var _instance:SmudgeTool;
		
		private var smudge:SmudgeData = SmudgeData.instance;
		
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean = false;
		private var pattern:Sprite;
		private var diameter:int;
		private var radius:Number;
		private var oldX:Number;
		private var oldY:Number;
		private var brushAlpha:BitmapData;
		private var tempData:BitmapData;
		private var cT:ColorTransform;
		private var mat:Matrix;
		
		private var blendMode:String;
		private var newX:Number;
		private var newY:Number;
		private var clipRect:Rectangle;
		private var bitDataClone:BitmapData;
		
		//TODO: Improve smudge tool
		
		public function SmudgeTool() 
		{
			if (_instance)
				throw new Error("SmudgeTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData)
		{
			_canvas = canvas;
			_bitData = bitData;
			smudge.adjustSmudge();
			
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
			
			pattern = smudge.pattern;
			blendMode = smudge.blend;
			
			diameter = smudge.size;
			radius = diameter * 0.5;
			
			cT = new ColorTransform;
			cT.alphaMultiplier = smudge.flow;
			pattern.transform.colorTransform = cT;
			
			brushAlpha = new BitmapData(diameter, diameter, true, 0x00FFFFFF);
			tempData = new BitmapData(diameter, diameter, true, 0x00FFFFFF);
			
			pattern.x = pattern.y = radius;
			brushAlpha.draw(pattern,pattern.transform.matrix,pattern.transform.colorTransform);
			
			oldX = _canvas.mouseX - radius;
			oldY = _canvas.mouseY - radius;
			
			clipRect = ToolManager.clipRect;
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			newX = _canvas.mouseX - radius;
			newY = _canvas.mouseY - radius;
			
			elfa(oldX, oldY, newX, newY);
			
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
		
		private function elfa(x:int, y:int, x2:int, y2:int):void 
		{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
			var X:int;
			var Y:int;
			
			var tempOldX:int = x;
			var tempOldY:int = y;

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
					
					//X -= radius;
					//Y -= radius;
					
					tempData.copyPixels(_bitData,
								new Rectangle(tempOldX, tempOldY, diameter, diameter),
								new Point(0, 0), brushAlpha, new Point(0,0), true);
								
					mat = new Matrix(1, 0, 0, 1, X, Y);
					_bitData.draw(tempData, mat, null, blendMode, clipRect);
					
					tempData.dispose();
					tempData = new BitmapData(diameter, diameter, true, 0x00FFFFFF);
					
					tempOldX = X;
					tempOldY = Y;
				}
			}
			else
			{
				for (i = 0; i != longLen; i += inc)
				{
					X = x+i;
					Y = y + i * multDiff;
					
					//X -= radius;
					//Y -= radius;
					
					tempData.copyPixels(_bitData,
								new Rectangle(tempOldX, tempOldY, diameter, diameter),
								new Point(0, 0), brushAlpha, new Point(0,0), true);
								
					mat = new Matrix(1, 0, 0, 1, X, Y);
					_bitData.draw(tempData, mat, null, blendMode, clipRect);
					
					tempData.dispose();
					tempData = new BitmapData(diameter, diameter, true, 0x00FFFFFF);
					
					tempOldX = X;
					tempOldY = Y;
				}
			}
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
		}
		
		static public function get instance():SmudgeTool 
		{
			if (!_instance)
				_instance = new SmudgeTool;
			return _instance;
		}
		
	}

}