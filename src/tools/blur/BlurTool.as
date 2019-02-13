package tools.blur 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BlurTool 
	{
		static private var _instance:BlurTool;
		
		private var blur:BlurData = BlurData.instance;
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		
		private var activated:Boolean = false;
		private var _pressed:Boolean = false;
		
		private var diameter:int;
		private var radius:Number;
		private var oldX:Number;
		private var oldY:Number;
		private var newX:Number;
		private var newY:Number;
		
		private var _bitClone:BitmapData;
		private var blurFilter:BlurFilter;
		private var clipRect:Rectangle;
		private var lassoMask:Sprite;
		private var _oldBd:BitmapData;
		
		private var _brushBd:BitmapData;
		private var _alphaBd:BitmapData;
		private var convoFilter:ConvolutionFilter;
		
		public function BlurTool() 
		{
			if (_instance)
				throw new Error("BlurTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			_pressed = true;
			
			diameter = blur.size;
			radius = diameter / 2;
			
			clipRect = ToolManager.clipRect;
			lassoMask = ToolManager.lassoMask;
			
			blurFilter = new BlurFilter(blur.strength+1, blur.strength+1, 3);
			
			HistoryManager.pushList();
			
			_bitClone = _bitData.clone();
			
			if (blur.type == 0)
			{
				_bitClone.applyFilter(_bitClone, _bitClone.rect, new Point(0, 0), blurFilter);
			}
			else if (blur.type == 1)
			{
				convoFilter = new ConvolutionFilter(3, 3, new Array( 0, 0, 0, 0, 1, 0, 0, 0, 0), 1);
				var a:Number = blur.strength / -10;
				var b:Number = blur.strength / -20;
				var c:Number = a * -4 + b * -4 + 1;
				convoFilter.matrix = [b, a, b,
									  a, c, a,
									  b, a, b]
				
				_bitClone.applyFilter(_bitClone, _bitClone.rect, new Point(0, 0), convoFilter);
			}
			else if (blur.type == 2)
			{
				convoFilter = new ConvolutionFilter(3, 3, new Array( -1, -1, -1, -1, 19, -1, -1, -1, -1),11 - blur.strength);
				_bitClone.applyFilter(_bitClone, _bitClone.rect, new Point(0, 0), convoFilter);
			}
			else if (blur.type == 3)
			{
				convoFilter = new ConvolutionFilter(3, 3, new Array( -1, -1, -1, -1, 18, -1, -1, -1, -1),10 + blur.strength);
				_bitClone.applyFilter(_bitClone, _bitClone.rect, new Point(0, 0), convoFilter);
			}
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1 || lassoMask)
				_oldBd = _bitData.clone();
			
			/*var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawCircle(radius, radius, diameter);
			
			_alphaBd = new BitmapData(diameter, diameter, true, 0x00000000);
			_alphaBd.draw(sp);
			
			_brushBd = new BitmapData(diameter, diameter, true, 0x00000000);
			*/
			oldX = _canvas.mouseX - radius;
			oldY = _canvas.mouseY - radius;
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (_pressed) 
			{
				newX = _canvas.mouseX-radius;
				newY = _canvas.mouseY-radius;
				
				elfa(oldX, oldY, newX, newY);
				
				oldX = newX;
				oldY = newY;
			}
		}
		
		private function elfa(x:Number, y:Number, x2:Number, y2:Number):void 
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
					Y = y+i;
					
					//_brushBd.copyPixels(_bitClone, new Rectangle(X, Y, diameter, diameter), new Point(0, 0));
					
					//_bitData.threshold(_brushBd, _brushBd.rect, new Point(X, Y), ">", 0x00000000, _brushBd.getPixel32(X, Y));
					
					_bitData.copyPixels(_bitClone, new Rectangle(X, Y, diameter, diameter), new Point(X, Y));
				}
			}
			else
			{
				for (i = 0; i != longLen; i += inc)
				{
					X = x+i;
					Y = y+i*multDiff;
					
					_bitData.copyPixels(_bitClone, new Rectangle(X, Y, diameter, diameter), new Point(X, Y));
					
				}
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (_pressed) 
			{
				if (lassoMask)
				{
					_oldBd.draw(lassoMask, null, null, BlendMode.ERASE);
					
					var tempBmp:Bitmap = new Bitmap(_bitData);
					tempBmp.mask = lassoMask;
					_oldBd.draw(tempBmp);
					tempBmp.mask = null;
					
					_bitData.copyPixels(_oldBd, _oldBd.rect, new Point(0, 0));
					
					_oldBd.dispose();
				}
				else if(ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
				{
					_oldBd.copyPixels(_bitData, clipRect, new Point(clipRect.x, clipRect.y));
					_bitData.copyPixels(_oldBd, _oldBd.rect, new Point(0, 0));
					
					_oldBd.dispose();
				}
				
				_bitClone.dispose();
			}
			_pressed = false;
		}
		
		static public function get instance():BlurTool 
		{
			if (!_instance)
				_instance = new BlurTool;
			
			return _instance;
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
		}
		
	}

}