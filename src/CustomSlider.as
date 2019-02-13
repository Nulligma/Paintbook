package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import settings.System;
	
	public final class CustomSlider extends Sprite
	{
		public var value:int = 6;
		private var startX:int = 289;
		private var startY:int = 338.15;
		
		private var range:int;
		private var startPos:Number;
		
		private var maxWidth:Number;
		
		private var _minVal:int;
		private var _maxVal:int;
		private var _details:String;
		private var ratio:Number;
		
		private var _dataArray:Array;
		
		public final function CustomSlider(details:String,startValue:Number,minVal:int,maxVal:int,dataArray:Array=null):void
		{
			range = maxVal - minVal;
			value = Math.round(startValue);
			
			_maxVal = maxVal;
			_minVal = minVal;
			
			_dataArray = dataArray;
			_details = details;
			
			maxWidth = bg.width - head.width;
			
			if (_dataArray != null)
			{
				detailsTxt.text = details + _dataArray[value];
			}
			else
			{
				detailsTxt.text = details;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event)
		{
			head.txtTF.text = value;
			
			this.width = System.stageWidth;
			this.height = System.stageHeight;
			
			ratio = (value-_minVal)/range;
			if (ratio > 0.995)
				ratio = 1;
			ratio = 1 - ratio;
			
			var maxX:Number = maxWidth + startX;
			head.x = maxX - ((maxX - startX) * ratio);
			
			addListeners();
		}
		
		private final function addListeners():void
		{
			head.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}
		
		private final function initDrag(e:MouseEvent):void
		{
			head.startDrag(false, new Rectangle(startX, startY, bg.width - head.width, 0));
			addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
		}
		
		private final function onSliderMove(e:MouseEvent):void
		{
			ratio = (head.x - startX) / maxWidth;
			
			if (ratio > 0.995)
				ratio = 1;
			
			ratio = 1 - ratio;
			
			value = _maxVal - ((_maxVal - _minVal) * ratio);
			head.txtTF.text = value;
			
			if (_dataArray != null)
			{
				detailsTxt.text = _details + _dataArray[value];
			}
		}
	}
}