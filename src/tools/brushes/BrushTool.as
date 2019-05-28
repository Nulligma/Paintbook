package tools.brushes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	
	public class BrushTool
	{
		static private var _instance:BrushTool;
		
		private var brush:BrushData = BrushData.instance;
		
		private var _bitData:BitmapData;
		private var _canvas:Sprite;
		
		private var oldX:Number;
		private var oldY:Number;
		private var newDrawPoint:Point;
		private var easing:Number = 0.22;
		private var easingForPressure:Number = 0.02;
		private var pressureInc:Number = 0.085;
		
		private var lastDrawnPoints:Array = new Array;
		
		private var colorTrans:ColorTransform = new ColorTransform;
		
		//private var pointsVec:Vector.<Point> = new Vector.<Point>;
		//private var currentPoint:Point;
		
		private var pattern:Sprite;
		private var scattering:Boolean;
		private var randomRotate:Boolean;
		private var randomColor:Boolean;
		private var xSymmetry:Boolean;
		private var ySymmetry:Boolean;
		private var canvasWidth:Number;
		private var canvasHeight:Number;
		private var spacing:Number;
		private var scatSize:Number;
		private var halfSize:Number;
		private var clipRect:Rectangle;
		private var subRect:Rectangle;
		private var brushBitData:BitmapData;
		
		private var brushHolder:Bitmap;
		private var holderData:BitmapData;
		
		private var pressed:Boolean = false;
		public var activated:Boolean = false;
		
		private var layerList:LayerList;
		private var _canvasBounds:Rectangle;
		private var pressureDist:Number;
		private var oldPd:Number;
		private var psCount:Number;
		
		public function BrushTool()
		{
			if (_instance)
				throw new Error("BrushTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_bitData = bitData;
			_canvas = canvas;;
			_canvasBounds = System.canvasBounds;
			
			layerList= LayerList.instance;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 100);
			//_canvas.addEventListener(Event.ENTER_FRAME, drawPoints);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 100);
			//_canvas.stage.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			
			canvasWidth = _canvas.width;
			canvasHeight = _canvas.height;
			
			brush.adjustBrush();
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void
		{
			oldX = _canvas.mouseX;
			oldY = _canvas.mouseY;
			
			oldPd = pressureDist = 0.2;// brush.size * 0.25 * 0.085;
			//psCount = (brush.pressureSensivity)*0.08;
			psCount = (brush.pressureSensivity) * 0.3;
			
			initBrushProp();
			
			HistoryManager.pushList();
			
			if(brushHolder!= null)
			{
				_canvas.removeChild(brushHolder);
				brushHolder = null;
			}
			
			holderData = new BitmapData(_canvas.width, _canvas.height, true, 0x000000);
			brushHolder = new Bitmap(holderData);
			brushHolder.alpha = brush.alpha;
			
			if(System.canvas == _canvas)
				_canvas.addChildAt(brushHolder, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			else
				_canvas.addChild(brushHolder);
			
			if (spacing > 1)
				lastDrawnPoints[0] = new Point(_canvas.mouseX, _canvas.mouseY);
			
			draw(_canvas.mouseX, _canvas.mouseY, 0);
			
			if (ySymmetry)
			{
				if (spacing > 1)
					lastDrawnPoints[1] = new Point(canvasWidth - oldX, _canvas.mouseY);
				
				draw(canvasWidth - oldX, _canvas.mouseY, 1);
			}
			if (xSymmetry)
			{
				if (spacing > 1)
					lastDrawnPoints[2] = new Point(_canvas.mouseX, canvasHeight - oldY);
				
				draw(_canvas.mouseX, canvasHeight - oldY, 2);
			}
			if (xSymmetry && ySymmetry)
			{
				if (spacing > 1)
					lastDrawnPoints[3] = new Point(canvasWidth - oldX, canvasHeight - oldY);
				
				draw(canvasWidth - oldX, canvasHeight - oldY, 3);
			}
			
			_canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void
		{
			newDrawPoint = new Point(oldX + (_canvas.mouseX - oldX) * easing, oldY + (_canvas.mouseY - oldY) * easing);
			
			if(brush.pressureSensivity != 0)
				betterCaclcPressure(newDrawPoint);
			
			efla(oldX, oldY, newDrawPoint.x, newDrawPoint.y, 0);
				
			if (ySymmetry)
				efla(canvasWidth - oldX, oldY, canvasWidth - newDrawPoint.x, newDrawPoint.y, 1);
			
			if (xSymmetry)
				efla(oldX, canvasHeight - oldY, newDrawPoint.x, canvasHeight - newDrawPoint.y, 2);
			
			if (xSymmetry && ySymmetry)
				efla(canvasWidth - oldX, canvasHeight - oldY, canvasWidth - newDrawPoint.x, canvasHeight - newDrawPoint.y, 3);
			
			oldX = newDrawPoint.x;
			oldY = newDrawPoint.y;
		}
		
		private function betterCaclcPressure(newDrawPoint:Point):void
		{
			pressureDist = Math.sqrt(distanceSquared(newDrawPoint, new Point(oldX, oldY)));
			pressureDist = pressureDist < 2?2:pressureDist>18?18:pressureDist;
			pressureDist *= 0.085;
			pressureDist < 1?pressureDist *= (1 - psCount):pressureDist *= (1 + psCount);
			pressureDist = oldPd + (pressureDist - oldPd) * easingForPressure;
			oldPd = pressureDist;
		}
		
		private function calcPressure(newDrawPoint:Point):void 
		{
			pressureDist = distanceSquared(newDrawPoint, new Point(oldX, oldY));
			//pressureDist = uint(newDrawPoint.x - oldX) + uint(newDrawPoint.y - oldY) 
			pressureDist = pressureDist < 4?4:pressureDist>300?300:pressureDist;
			pressureDist *= psCount*psCount;
			//pressureDist < 1?pressureDist *= (1 - psCount):pressureDist *= (1 + psCount);
			pressureDist = oldPd + (pressureDist - oldPd) * easingForPressure;
			
			//pressureDist < 0.05?pressureDist=0.05:0;
			oldPd = pressureDist;
		}
		
		/*private function drawPoints(e:Event):void 
		{
			while (pointsVec.length>0) 
			{
				currentPoint = pointsVec.pop();
				
				efla(oldX, oldY, currentPoint.x, currentPoint.y, 0);
					
				if (brush.ySymmetry)
					efla(canvasWidth - oldX, oldY, canvasWidth - currentPoint.x,currentPoint.y, 1);
				
				if (brush.xSymmetry)
					efla(oldX, canvasHeight - oldY, currentPoint.x, canvasHeight - currentPoint.y, 2);
				
				if (brush.xSymmetry && brush.ySymmetry)
					efla(canvasWidth - oldX, canvasHeight - oldY, canvasWidth - currentPoint.x, canvasHeight - currentPoint.y, 3);
				
				oldX = currentPoint.x;
				oldY = currentPoint.y;
			}
		}*/
		
		private function onUp(e:MouseEvent):void
		{
			if (brushHolder)
			{
				if (ToolManager.lassoMask)
					brushHolder.mask = ToolManager.lassoMask;
				
				_bitData.draw(brushHolder, null, brushHolder.transform.colorTransform, null, clipRect, true);
				
				if (ToolManager.lassoMask)
					brushHolder.mask = null;
				
				_canvas.removeChild(brushHolder);
				brushHolder = null;
				holderData.dispose();
				holderData = null;
			}
			
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function efla(x:int, y:int, x2:int, y2:int, pointIndex:int):void
		{
			var shortLen:int = y2 - y;
			var longLen:int = x2 - x;
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
					Y = y + i;
					X = x + i * multDiff;
					
					if (spacing > 1)
					{
						if (distanceSquared(new Point(X, Y), lastDrawnPoints[pointIndex]) > spacing * spacing)
						{
							if (_canvasBounds.contains(X,Y))
								draw(X, Y, pointIndex);
						}
					}
					else
					{
						if (_canvasBounds.contains(X, Y))
							draw(X, Y, pointIndex);
					}
					
				}
			}
			else
			{
				for (i = 0; i != longLen; i += inc)
				{
					X = x + i;
					Y = y + i * multDiff;
					if (spacing > 1)
					{
						if (distanceSquared(new Point(X, Y), lastDrawnPoints[pointIndex]) > spacing * spacing)
						{
							if (_canvasBounds.contains(X, Y))
								draw(X, Y, pointIndex);
						}
					}
					else
					{
						if (_canvasBounds.contains(X, Y))
							draw(X, Y, pointIndex);
					}
				}
			}
		}
		
		private function draw(X:int, Y:int, pointIndex:int):void
		{
			/*if (scattering && randomRotate)
			{
				pattern.scaleX = pattern.scaleY = brush.scalingFactor * Math.random();
				pattern.rotation = int(Math.random() * 180);
				if (randomColor)
				{
					colorTrans.color = Math.random() * 0xFFFFFF;
					colorTrans.alphaMultiplier = brush.flow;
					pattern.transform.colorTransform = colorTrans;
				}
				pattern.x = X;
				pattern.y = Y;
				holderData.draw(pattern, pattern.transform.matrix, pattern.transform.colorTransform);
			}*
			if (brush.pressureSensivity != 0)
			{
				pattern.scaleX = pattern.scaleY = brush.scalingFactor * pressureDist;
				if (randomRotate)
					pattern.rotation = int(Math.random() * 180);
				if (randomColor)
				{
					colorTrans.color = Math.random() * 0xFFFFFF;
					colorTrans.alphaMultiplier = brush.flow;
					pattern.transform.colorTransform = colorTrans;
				}
				pattern.x = X;
				pattern.y = Y;
				holderData.draw(pattern, pattern.transform.matrix, pattern.transform.colorTransform);
			}
			else
			{*/
				brushBitData = brush.brushBitData;
				
				
				if (brush.pressureSensivity != 0)
				{
					scatSize = int(brush.size * brush.scalingFactor * pressureDist)+1;
					if(randomRotate)
						brushBitData = brush.bitVector[scatSize][int(Math.random() * BrushData.TOTAL_ROTATION)];
					else
						brushBitData = brush.bitVector[scatSize][0];
					halfSize = scatSize * 0.5;
				}
				else
				{
					if (scattering)
					{
						//scatSize = int(Math.random()*brush.scaleVector.length-1)
						scatSize = int(Math.random()*brush.size)+1;
						brushBitData =  brush.bitVector[scatSize][0];
						halfSize = scatSize * 0.5;
					}
					if (randomRotate)
					{
						brushBitData = brush.bitVector[brush.size][int(Math.random() * BrushData.TOTAL_ROTATION)];
					}
				}
				
				if (randomColor)
				{
					colorTrans.color = Math.random() * 0xFFFFFF;
					colorTrans.alphaMultiplier = 1;
					brushBitData.colorTransform(brushBitData.rect, colorTrans);
				}
				
				halfSize = brushBitData.width*0.5;
				holderData.copyPixels(brushBitData, brushBitData.rect, new Point(X-halfSize, Y-halfSize), null, null, true);
			//}
			
			if (spacing > 1)
				lastDrawnPoints[pointIndex] = new Point(X, Y);
		}
		
		private function distanceSquared(p2:Point, p1:Point):Number
		{
			return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y);
		}
		
		private function initBrushProp():void 
		{
			brush.adjustBrush(true);
			
			pattern = brush.pattern;
			scattering = brush.scattering;
			randomRotate = brush.randomRotate;
			randomColor = brush.randomColor;
			xSymmetry = brush.xSymmetry;
			ySymmetry = brush.ySymmetry;
			spacing = brush.spacing;
			halfSize = brush.smoothness > 0 ? brush.bluredSize * 0.5 : brush.size * 0.5;
			clipRect = ToolManager.clipRect;
			
			colorTrans.color = brush.fillColor;
			colorTrans.alphaMultiplier = brush.flow;
			brush.pattern.transform.colorTransform = colorTrans;
			pattern.rotation = 0;
		}
		
		public function customDown(startPoint:Point):void
		{
			oldPd = pressureDist = 0.2;// brush.size * 0.25 * 0.085;
			//psCount = (brush.pressureSensivity)*0.08;
			psCount = (brush.pressureSensivity) * 0.3;
			
			initBrushProp();
			
			holderData = _bitData;
			
			if (spacing > 1)
				lastDrawnPoints[0] = new Point(startPoint.x, startPoint.y);
			
			draw(startPoint.x,startPoint.y, 0);
			
			oldX = startPoint.x;
			oldY = startPoint.y;
		}
		
		public function customMove(newPoint:Point,drawSym:Boolean = false):void
		{
			newDrawPoint = new Point(oldX + (newPoint.x - oldX) * 1, oldY + (newPoint.y - oldY) * 1);
			
			if(brush.pressureSensivity != 0)
				betterCaclcPressure(newDrawPoint);
			
			efla(oldX, oldY, newDrawPoint.x, newDrawPoint.y, 0);
			
			if (drawSym) 
			{
				if (ySymmetry)
					efla(canvasWidth - oldX, oldY, canvasWidth - newDrawPoint.x, newDrawPoint.y, 1);
				
				if (xSymmetry)
					efla(oldX, canvasHeight - oldY, newDrawPoint.x, canvasHeight - newDrawPoint.y, 2);
				
				if (xSymmetry && ySymmetry)
					efla(canvasWidth - oldX, canvasHeight - oldY, canvasWidth - newDrawPoint.x, canvasHeight - newDrawPoint.y, 3);
			}	
			
			oldX = newDrawPoint.x;
			oldY = newDrawPoint.y;
		}
		
		public function deactivate():void
		{
			
			if(brushHolder!= null)
			{
				_canvas.removeChild(brushHolder);
				brushHolder = null;
			}
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
		}
		
		static public function get instance():BrushTool 
		{
			if (!_instance)
				_instance = new BrushTool;
			
			return _instance;
		}
		
	}

}