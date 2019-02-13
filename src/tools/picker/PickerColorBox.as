package tools.picker 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import settings.CustomUI;
	import tools.ToolManager;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class PickerColorBox extends Sprite
	{
		private var prevColorBox:Sprite;
		private var newColorBox:Sprite;
		private var sW:int;
		private var sH:int;
		
		public function PickerColorBox() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			prevColorBox = new Sprite;
			prevColorBox.graphics.lineStyle(1, CustomUI.color2);
			prevColorBox.graphics.beginFill(ToolManager.fillColor);
			prevColorBox.graphics.drawRect( -sW * 0.05, -sW * 0.0244, sW * 0.05, sW * 0.05);
			prevColorBox.graphics.endFill();
			addChild(prevColorBox);
			
			newColorBox = new Sprite;
			newColorBox.graphics.lineStyle(1, CustomUI.color2);
			newColorBox.graphics.beginFill(ToolManager.fillColor);
			newColorBox.graphics.drawRect( 0, -sW * 0.0244, sW * 0.05, sW * 0.05);
			newColorBox.graphics.endFill();
			addChild(newColorBox);
		}
		
		public function updateColor(newColor:uint):void
		{
			newColorBox.graphics.clear();
			newColorBox.graphics.lineStyle(1, CustomUI.color2);
			newColorBox.graphics.beginFill(newColor);
			newColorBox.graphics.drawRect( 0, -sW * 0.0244, sW * 0.05, sW * 0.05);
			newColorBox.graphics.endFill();
		}
		
		public function updatePos(X:int, Y:int):void
		{
			x = X;
			y = Y - sH * 0.05 - height / 2;
		}
	}

}