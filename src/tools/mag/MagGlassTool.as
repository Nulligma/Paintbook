package tools.mag 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import settings.System;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class MagGlassTool 
	{
		static private var _instance:MagGlassTool;
		
		private var magGlass:MagGlass;
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var pressed:Boolean = false;
		private var lastY:Number;
		private var lastX:Number;
		
		public function MagGlassTool() 
		{
			if (_instance)
				throw new Error("MagGlassTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onUp,false,-2);
			
			magGlass = new MagGlass;
			BackBoard.instance.addChild(magGlass);
		}
		
		private function onDown(e:MouseEvent):void 
		{
			pressed = true;
			magGlass.update(_canvas.mouseX, _canvas.mouseY);
			
			lastX = _canvas.mouseX;
			lastY = _canvas.mouseY;
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			magGlass.update(_canvas.mouseX, _canvas.mouseY);
			lastX = _canvas.mouseX;
			lastY = _canvas.mouseY;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if(pressed)
				magGlass.update(_canvas.mouseX, _canvas.mouseY);
			else
				magGlass.update( lastX, lastY);
			
			pressed = false;
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		public function deactivate():void
		{
			if (magGlass.stage)
			{
				BackBoard.instance.removeChild(magGlass);
				magGlass = null;
			}
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		static public function get instance():MagGlassTool 
		{
			if (!_instance)
				_instance = new MagGlassTool;
			return _instance;
		}
		
	}

}