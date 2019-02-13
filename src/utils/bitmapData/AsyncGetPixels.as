package utils.bitmapData 
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class AsyncGetPixels extends EventDispatcher
	{
		public static const COMPLETE:String = "complete";
		
		private var _bitData:BitmapData;
		private var _width:int;
		private var _height:int;
		
		private var _bytes:ByteArray;
		private var currentHeight:Number;
		private var delay:Number = 10;
		
		private var hpi:int;
		private var extraHeight:int;
		private var _reportBacks:uint = 7;
		
		public function AsyncGetPixels(bitmapData:BitmapData,width:int,height:int) 
		{
			_bitData = bitmapData;
			_width = width;
			_height = height;
			
			hpi = _height / _reportBacks;
			extraHeight = _height % _reportBacks;
			
			_bytes = new ByteArray();
			
			currentHeight = 0;
		}
		
		public function convert():void 
		{
			var tempBytes:ByteArray = _bitData.getPixels(new Rectangle(0, currentHeight, _width, hpi));
			_bytes.writeBytes(tempBytes);
			
			setTimeout(reportProgress, delay);
			//TweenLite.delayedCall(delay, reportProgress);
		}
		
		private function reportProgress():void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, currentHeight, _height));
			
			if (currentHeight == _height-extraHeight)
			{
				if (extraHeight != 0)
				{
					var tempBytes:ByteArray = _bitData.getPixels(new Rectangle(0, currentHeight, _width, extraHeight));
					_bytes.writeBytes(tempBytes);
				}
				
				dispatchEvent(new Event(AsyncGetPixels.COMPLETE));
			}
			else
			{
				currentHeight+=hpi;
				setTimeout(convert, delay);
				//TweenLite.delayedCall(delay,convert);
			}
		}
		
		public function get bytes():ByteArray 
		{
			return _bytes;
		}
		
		public function set reportBacks(value:uint):void 
		{
			value <= 0?1:value>100?100:value;
			
			_reportBacks = value;
		}
		
	}

}