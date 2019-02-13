package tools.transform
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class FreeTransform extends Sprite
	{
		private var _bitData:BitmapData;
		private var displayObject:DisplayObject;
		private var _boundary:Sprite;
		
		private var _currentSprite:Sprite;
		private var _container:Sprite;
		
		private var _maintainRatio:Boolean = true;
		
		private var _copyBmp:Bitmap;
		private var _copyData:BitmapData;
		
		private var luSq:Sprite;
		private var rbSq:Sprite;
		
		private var lbSq:Sprite;
		
		private var rotatePressed:Boolean = false;
		private var resizePressed:Boolean = false;
		private var imgPressed:Boolean = false;
		private var copyPressed:Boolean = false;
		
		private var oldX:Number;
		private var oldY:Number;
		
		private var dx:Number;
		private var dy:Number;
		private var radians:Number;
		private var rect:Rectangle;
		
		public function FreeTransform(conf:Object)
		{
			if (conf.bitData)
			{
				_bitData = conf.bitData as BitmapData;
				displayObject = new Bitmap(_bitData);
				
				init();
			}
			else if (conf.vecData)
			{
				displayObject = new Sprite;
				displayObject = conf.vecData;
				
				init();
			}
		}
		
		private function init():void
		{
			_container = new Sprite;
			_currentSprite = new Sprite;
			_container.x = -(displayObject.width / 2);
			_container.y = -(displayObject.height / 2);
			_container.addChild(displayObject);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					imgPressed = true;
					dx = stage.mouseX - _currentSprite.x;
					dy = stage.mouseY - _currentSprite.y;
				});
			
			addChild(_currentSprite);
			_currentSprite.addChild(_container);
			
			_boundary = new Sprite;
			_boundary.graphics.lineStyle(1, 0x00CCFF);
			
			rect = displayObject.getBounds(this);
			_boundary.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			_currentSprite.addChild(_boundary);
			
			rbSq = new Sprite
			rbSq.graphics.beginFill(0xCC0000);
			rbSq.graphics.drawRect(-15, -15, 30, 30);
			rbSq.graphics.endFill();
			rbSq.x = _container.x + _container.width;
			rbSq.y = _container.y + _container.height;
			rbSq.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					rotatePressed = true;
				})
			_currentSprite.addChild(rbSq);
			
			luSq = new Sprite;
			luSq.graphics.beginFill(0x00CCFF);
			luSq.graphics.drawRect(-15, -15, 30, 30);
			luSq.graphics.endFill();
			luSq.x = _container.x;
			luSq.y = _container.y;
			luSq.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					resizePressed = true;
					oldX = stage.mouseX;
					oldY = stage.mouseY;
				})
			_currentSprite.addChild(luSq);
			
			lbSq = new Sprite;
			lbSq.graphics.beginFill(0x00CC00);
			lbSq.graphics.drawRect(-15, -15, 30, 30);
			lbSq.graphics.endFill();
			lbSq.x = _container.x;
			lbSq.y = _container.y + _container.height;
			lbSq.addEventListener(MouseEvent.MOUSE_DOWN, copyDown)
			_currentSprite.addChild(lbSq);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			if (_bitData)
			{
				displayObject = null;
				_bitData.dispose();
				_bitData = null;
			}
		}
		
		private function onMove(e:MouseEvent):void
		{
			if (imgPressed)
			{
				_currentSprite.x = stage.mouseX - dx;
				_currentSprite.y = stage.mouseY - dy;
			}
			else if (resizePressed)
			{
				dx = stage.mouseX - oldX;
				
				_currentSprite.scaleX -= dx * 0.01;
				
				if(_maintainRatio)
					_currentSprite.scaleY = _currentSprite.scaleX;
				else
				{
					dy = stage.mouseY - oldY;
					_currentSprite.scaleY -= dy * 0.01;
				}
				
				oldX = stage.mouseX;
				oldY = stage.mouseY;
			}
			else if (rotatePressed)
			{
				dx = mouseX - _currentSprite.x;
				dy = mouseY - _currentSprite.y;
				radians = Math.atan2(dy, dx);
				_currentSprite.rotation = radians * 180 / Math.PI - 45;
			}
			else if (copyPressed)
			{
				_copyBmp.x = mouseX - _copyBmp.width * 0.5;
				_copyBmp.y = mouseY - _copyBmp.height * 0.5;
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			resizePressed = false;
			rotatePressed = false;
			imgPressed = false;
			copyPressed = false;
		}
		
		private function copyDown(e:MouseEvent):void
		{
			copyPressed = true;
			
			clearAll(false);
			
			var prevX:Number = _currentSprite.x;
			var prevY:Number = _currentSprite.y;
			
			_copyData = new BitmapData(_currentSprite.width + 10, _currentSprite.height, true, 0x000000);
			_currentSprite.x = _currentSprite.width / 2;
			_currentSprite.y = _currentSprite.height / 2;
			_copyData.draw(_currentSprite, _currentSprite.transform.matrix);
			_currentSprite.x = prevX;
			_currentSprite.y = prevY;
			
			reAddAll();
			
			_copyBmp = new Bitmap(_copyData, "auto", true);
			_copyBmp.x = mouseX - _copyBmp.width * 0.5;
			_copyBmp.y = mouseY - _copyBmp.height * 0.5;
			addChild(_copyBmp);
		}
		
		public function clearAll(removeListners:Boolean = true):void
		{
			if (_currentSprite)
			{
				_currentSprite.removeChild(_boundary);
				_currentSprite.removeChild(rbSq);
				_currentSprite.removeChild(luSq);
				_currentSprite.removeChild(lbSq);
			}
			
			if (removeListners)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}
		
		public function reAddAll():void
		{
			_currentSprite.addChild(_boundary);
			_currentSprite.addChild(rbSq);
			_currentSprite.addChild(luSq);
			_currentSprite.addChild(lbSq);
		}
		
		public function set maintainRatio(value:Boolean):void 
		{
			_maintainRatio = value;
		}
	}

}
