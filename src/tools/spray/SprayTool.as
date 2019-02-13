package tools.spray 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SprayTool 
	{
		static private var _instance:SprayTool;
		
		private var spray:SprayData = SprayData.instance;
		
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean;
		private var pattern:Sprite;
		private var cT:ColorTransform;
		private var angle:Number;
		private var radius:Number;
		private var xpos:Number;
		private var ypos:Number;
		private var clipRect:Rectangle;
		
		private var holderData:BitmapData;
		private var sprayHolder:Bitmap;
		private var layerList:LayerList;
		
		public function SprayTool() 
		{
			if (_instance)
				throw new Error("SprayTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
			
			layerList = LayerList.instance;
			
			spray.adjustSpray();
		}
		
		private function onDown(e:MouseEvent):void 
		{
			HistoryManager.pushList();
			
			pattern = spray.pattern;
			
			pattern.rotation = 0;
			
			holderData = new BitmapData(_canvas.width, _canvas.height, true, 0x000000);
			sprayHolder = new Bitmap(holderData);
			sprayHolder.alpha = spray.alpha;
			
			if(System.canvas == _canvas)
				_canvas.addChildAt(sprayHolder, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			else
				_canvas.addChild(sprayHolder);
			
			cT = new ColorTransform;
			cT.color = ToolManager.fillColor;
			cT.alphaMultiplier = spray.flow;
			pattern.transform.colorTransform = cT;
			
			clipRect = ToolManager.clipRect;
			
			_canvas.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void 
		{
			for(var i:int = 0; i < spray.density; i++)
			{
				angle = Math.random() * 6.283;
				radius = Math.random() * spray.size;
				xpos = _canvas.mouseX + Math.cos(angle) * radius;
				ypos = _canvas.mouseY + Math.sin(angle) * radius;
				
				if (spray.scattering)
				{
					pattern.scaleX = pattern.scaleY = spray.psize * 0.02 * Math.random();
				}
				
				if (spray.randomRotate)
				{
					pattern.rotation = int(Math.random() * 180);
				}
				
				if (spray.randomColor)
				{
					cT.color = Math.random() * 0xFFFFFF;
					cT.alphaMultiplier = spray.flow;
					pattern.transform.colorTransform = cT;
				}
				
				pattern.x = xpos;
				pattern.y = ypos;
				
				holderData.draw(pattern, pattern.transform.matrix, pattern.transform.colorTransform);
				//_bitData.draw(pattern, pattern.transform.matrix, pattern.transform.colorTransform,null,clipRect,true);
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (sprayHolder)
			{
				if (ToolManager.lassoMask)
					sprayHolder.mask = ToolManager.lassoMask;
				
				_bitData.draw(sprayHolder, null,sprayHolder.transform.colorTransform, null, clipRect, true);
				
				_canvas.removeChild(sprayHolder);
				
				if (ToolManager.lassoMask)
					sprayHolder.mask = null;
				
				sprayHolder = null;
				holderData.dispose();
				holderData = null;
			}
			
			_canvas.removeEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		public function deactivate():void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = false;
		}
		
		static public function get instance():SprayTool 
		{
			if (!_instance)
				_instance = new SprayTool;
			return _instance;
		}
		
	}

}