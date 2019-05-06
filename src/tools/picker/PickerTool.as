package tools.picker 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import tools.ToolManager;
	import tools.ToolType;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class PickerTool 
	{
		static private var _instance:PickerTool;
		private var _canvas:Sprite;
		private var _bitData:BitmapData;
		private var activated:Boolean = false;
		private var prevTool:int;
		
		private var colorBox:PickerColorBox;
		
		public function PickerTool() 
		{
			if (_instance)
				throw new Error("PickerTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			activated = true;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			colorBox = new PickerColorBox();
			_canvas.stage.addChild(colorBox);
			colorBox.updatePos(_canvas.stage.mouseX, _canvas.stage.mouseY);
			
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			colorBox.updateColor(_bitData.getPixel(_canvas.mouseX, _canvas.mouseY));
			colorBox.updatePos(_canvas.stage.mouseX, _canvas.stage.mouseY);
		}
		
		private function onUp(e:MouseEvent):void 
		{	
			if (colorBox.stage)
			{
				_canvas.stage.removeChild(colorBox);
				ToolManager.fillColor = _bitData.getPixel(_canvas.mouseX, _canvas.mouseY);
				//ToolManager.toggle(ToolType.BRUSH);
			}
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		public function deactivate():void
		{
			if (colorBox && colorBox.stage)
			{
				_canvas.stage.removeChild(colorBox);
			}
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			activated = false;
		}
		
		static public function get instance():PickerTool 
		{
			if (!_instance)
				_instance = new PickerTool;
			return _instance;
		}
		
	}

}