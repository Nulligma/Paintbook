package  
{
	import colors.setups.Swatches;
	import colors.spectrums.Spectrum;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import fl.motion.MatrixTransformer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.ui.Keyboard;
	import layers.history.HistoryManager;
	import layers.save.LayerToArray;
	import settings.CustomUI;
	import settings.MessagePrefrences;
	import settings.Prefrences;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	import ui.menu.Menu;
	import ui.message.Warning;
	import ui.other.OpenUI;
	import utils.taskLoader.TaskLoader;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.events.GesturePhase;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BackBoard extends Sprite
	{
		static private var _instance:BackBoard;
		
		private var added:Boolean = false;
		private var openUI:OpenUI;
		private var _canvasHolder:Sprite;
		private var menu:Menu;
		private var tween:TweenNano;
		private var maxScale:Number = 8;
		private var minScale:Number = 0.2;
		private var toolList:Array;
		private var warning:Warning;
		private var taskLoader:TaskLoader;
		private var prevMouseX:Number=0;
		private var prevMouseY:Number = 0;
		
		public function BackBoard() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if (added) return;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, System.stageWidth, System.stageHeight);
			graphics.endFill();
			
			openUI= new OpenUI(addCanvas);
			addChild(openUI);
			
			added = true;
			this.stage.addEventListener(Event.RESIZE, resizeListener, false, int.MAX_VALUE, true);
			
		}
		public function loadAssets():void
		{
			CustomUI.load();
			Prefrences.load();
			MessagePrefrences.load();
			Swatches.load();
			
			registerClasses();
			
			System.loadCanvasList();
		}
		
		public function redraw():void
		{
			graphics.clear();
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, System.stageWidth, System.stageHeight);
			graphics.endFill();
			
			openUI.redraw();
			
			//if (ToolManager.activeTools.indexOf(ToolType.MAG_GLASS) != -1)
				//ToolManager.toggle(ToolType.MAG_GLASS);
			//
			//if (menu.stage)
				//menu.redraw();
		}
		
		private function registerClasses():void 
		{
			registerClassAlias("GlowAlias", GlowFilter);
			registerClassAlias("ShadowAlias", DropShadowFilter);
			registerClassAlias("BevelAlias", BevelFilter);
		}
		
		private function addCanvas():void 
		{
			removeChild(openUI);
			
			Spectrum.createSpectrum(System.stageWidth, System.stageHeight);
			
			_canvasHolder = new Sprite;
			_canvasHolder.addChild(System.canvas);
			_canvasHolder.x = -System.canvasWidth / 2 + System.stageWidth / 2;
			_canvasHolder.y = -System.canvasHeight / 2 + System.stageHeight/ 2;
			addChild(_canvasHolder);
			_canvasHolder.scaleX = _canvasHolder.scaleY = 1;
			ToolManager.toggle(ToolType.BRUSH);
			
			/*if(!this.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN , onPan);
			
			if(!canvasHolder.hasEventListener(MouseEvent.MOUSE_WHEEL))
				_canvasHolder.addEventListener(MouseEvent.MOUSE_WHEEL , onZoom);*/
			
			
			if(!this.hasEventListener(TransformGestureEvent.GESTURE_PAN))
				this.addEventListener(TransformGestureEvent.GESTURE_PAN , onPan, false, -99);
			
			if(!this.hasEventListener(TransformGestureEvent.GESTURE_ZOOM))
				this.addEventListener(TransformGestureEvent.GESTURE_ZOOM , onZoom, false , -99);
			
			menu = new Menu(addOpenUI);
			addChild(menu);
		}
		
		private function warnReturn():void 
		{
			if (warning.status == 1)
			{
				taskLoader = new TaskLoader;
				taskLoader.container = this;
				taskLoader.message = "Saving canvas\n\nPlease Wait...";
				LayerToArray.update(taskLoader.progressUpdater);
				taskLoader.addEventListener(TaskLoader.TASK_COMPLETE,onSaveComplete);
				taskLoader.applyProgressEvent = true;
				
				taskLoader.wrap(LayerToArray.save);
			}
			else
				tween = new TweenNano(warning, 0.5, { y: -warning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(warning); } } );
		}
		
		private function onSaveComplete(e:Event):void 
		{
			HistoryManager.flush();
			tween = new TweenNano(warning, 0.5, { y: -warning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(warning); } } );
		}
		
		private function onPan(event:TransformGestureEvent):void 
		{
			if(event.phase == GesturePhase.BEGIN)
				deactivateTools();
			if(event.phase == GesturePhase.END)
				activateTools();
			
			//event.stopImmediatePropagation();
			var prevX:Number=_canvasHolder.x;
			var prevY:Number=_canvasHolder.y;
			_canvasHolder.x+=event.offsetX;
			_canvasHolder.y+=event.offsetY;
			if (event.offsetX >= 0 && _canvasHolder.x > stage.stageWidth / 2)
			{
				_canvasHolder.x=prevX;
			}
			if (event.offsetX < 0 && _canvasHolder.x < -_canvasHolder.width + stage.stageWidth / 2)
			{
				_canvasHolder.x=prevX;
			}
			if (event.offsetY >= 0 && _canvasHolder.y > stage.stageHeight / 2)
			{
				_canvasHolder.y=prevY;
			}
			if (event.offsetY < 0 && _canvasHolder.y < -_canvasHolder.height + stage.stageHeight / 2)
			{
				_canvasHolder.y=prevY;
			}
			/*if (event.keyCode != Keyboard.SPACE)
			{
				return;
			}
			
			var panDX:Number, panDY:Number;
			
			panDX = mouseX - prevMouseX; panDY = mouseY - prevMouseY;
			
			prevMouseX = mouseX; prevMouseY = mouseY;
			
			if (panDX > 100 || panDX < -100 || panDY > 100 || panDY < -100) return;
		
			
			var prevX:Number=_canvasHolder.x;
			var prevY:Number=_canvasHolder.y;
			_canvasHolder.x+=panDX;
			_canvasHolder.y+=panDY;
			if (_canvasHolder.x > System.stageWidth / 2)
			{
				_canvasHolder.x=prevX;
			}
			if (_canvasHolder.x < -_canvasHolder.width + System.stageWidth / 2)
			{
				_canvasHolder.x=prevX;
			}
			if (_canvasHolder.y > System.stageHeight / 2)
			{
				_canvasHolder.y=prevY;
			}
			if (_canvasHolder.y < -_canvasHolder.height + System.stageHeight / 2)
			{
				_canvasHolder.y=prevY;
			}*/
		}
		
		private function onZoom(event:TransformGestureEvent):void  
		{
			event.stopImmediatePropagation();
			
			if(event.phase == GesturePhase.BEGIN)
				deactivateTools();
			if(event.phase == GesturePhase.END)
				activateTools();
			
			var locX:Number=event.localX;
			var locY:Number=event.localY;
			var stX:Number=event.stageX;
			var stY:Number=event.stageY;
			var prevScaleX:Number=_canvasHolder.scaleX;
			var prevScaleY:Number=_canvasHolder.scaleY;
			var mat:Matrix;
			var externalPoint=new Point(stX,stY);
			var internalPoint=new Point(locX,locY);
			
			_canvasHolder.scaleX *= event.scaleX;
			_canvasHolder.scaleY *= event.scaleY;
			
			var dX:Number = Math.abs(_canvasHolder.scaleX - prevScaleX);
			var dY:Number = Math.abs(_canvasHolder.scaleY - prevScaleY);
			
			if(dX > dY) _canvasHolder.scaleY = _canvasHolder.scaleX;
			else		_canvasHolder.scaleX = _canvasHolder.scaleY;
				
			if (event.scaleX > 1 && _canvasHolder.scaleX > maxScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (event.scaleY > 1 && _canvasHolder.scaleY > maxScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (event.scaleX < 1 && _canvasHolder.scaleX < minScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (event.scaleY < 1 && _canvasHolder.scaleY < minScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			mat=_canvasHolder.transform.matrix.clone();
			MatrixTransformer.matchInternalPointWithExternal(mat,internalPoint,externalPoint);
			_canvasHolder.transform.matrix = mat;
			
			/*if (event.delta == 0)
			{
				return;
			}
			
			var mScaleX:Number, mScaleY:Number;
			mScaleX = mScaleY = 1/event.delta;
			
			
			var locX:Number=event.localX;
			var locY:Number=event.localY;
			var stX:Number=event.stageX;
			var stY:Number=event.stageY;
			var prevScaleX:Number=_canvasHolder.scaleX;
			var prevScaleY:Number=_canvasHolder.scaleY;
			var mat:Matrix;
			var externalPoint=new Point(stX,stY);
			var internalPoint=new Point(locX,locY);
			_canvasHolder.scaleX += mScaleX;
			_canvasHolder.scaleY += mScaleY;
			
			if (_canvasHolder.scaleX > 0.8 && canvasHolder.scaleX < 1.2)
			{
				_canvasHolder.scaleX = _canvasHolder.scaleY = 1;
			}
			
			if (_canvasHolder.scaleX > maxScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (_canvasHolder.scaleY > maxScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (_canvasHolder.scaleX < minScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			if (_canvasHolder.scaleY < minScale)
			{
				_canvasHolder.scaleX=prevScaleX;
				_canvasHolder.scaleY=prevScaleY;
			}
			
			
			mat=_canvasHolder.transform.matrix.clone();
			MatrixTransformer.matchInternalPointWithExternal(mat,internalPoint,externalPoint);
			_canvasHolder.transform.matrix = mat;*/
			
		}
		
		private function deactivateTools():void 
		{
			if (toolList != null) return;
			
			toolList = ToolManager.activeTools.slice();
			
			for each(var tool:int in toolList)
			{
				ToolManager.toggle(tool);
			}
		}
		
		private function activateTools():void 
		{
			for each(var tool:int in toolList)
			{
				ToolManager.toggle(tool);
			}
			
			toolList = null;
		}
		
		private function addOpenUI():void 
		{
			removeChild(canvasHolder);
			
			addChild(openUI);
			openUI.update();
			//swapChildren(_canvasHolder, openUI);
			removeChild(menu);
			
			//tween = new TweenNano(_canvasHolder, 0.5, { scaleX:0.5, ease:Strong.easeOut, onComplete:function():void { removeChild(_canvasHolder); } } );
			//tween = new TweenNano(_canvasHolder, 0.5, { scaleY:0.5, ease:Strong.easeOut, overwrite:false } );
		}
		
		public function restartApp()
		{
			graphics.clear();
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, System.stageWidth, System.stageHeight);
			graphics.endFill();
			
			removeChild(openUI);
			openUI = new OpenUI(addCanvas);
			addChild(openUI);
			
		}
		
		private function resizeListener(e:Event):void 
		{
			if (!openUI.stage) return;
			
			System.stageHeight = stage.stageHeight;
			System.stageWidth = stage.stageWidth;
			
			restartApp();
		}
		
		static public function get instance():BackBoard 
		{
			if (!_instance)
				_instance = new BackBoard;
			
			return _instance;
		}
		
		public function get canvasHolder():Sprite 
		{
			return _canvasHolder;
		}
		
	}

}