package utils.taskLoader 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import layers.save.LayerToArray;
	import settings.System;
	import ui.other.OpenUI;
	import utils.preloader.Preloader;
	import settings.CustomUI;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class TaskLoader extends EventDispatcher
	{
		public static const TASK_COMPLETE:String = "taskComplete";
		
		private var _container:Sprite;
		
		private var _width:Number = -1;
		private var _height:Number = -1;
		
		private var backGround:Sprite;
		private var newCanvas:Boolean = false;
		private var delay:int = 30;
		private var _taskFunction:Function;
		private var loadingText:TextField;
		
		private var _applyProgressEvent:Boolean = false;
		
		private var _message:String;
		private var preloader:Preloader;
		
		public function TaskLoader() 
		{
			
		}
		
		public function wrap(taskFunction:Function)
		{
			if (_container == null)
			{
				throw new Error("Task Container is Null");
			}
			
			_taskFunction = taskFunction;
			
			if (_message == null || _message == "")
			{
				_message = "Please Wait...";
			}
			
			if (_width == -1) _width = System.stageWidth;
			if (_height == -1) _height = System.stageHeight;
			
			backGround = new Sprite;
			backGround.graphics.beginFill(0, 0.5);
			backGround.graphics.drawRect(0, 0, _width, _height);
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.color = 0xFFFFFF;
			txtFormat.font = CustomUI.font;
			txtFormat.size = _height * 0.083 * 0.6;
			txtFormat.align = "center";
			loadingText = new TextField;loadingText.embedFonts = true;
			loadingText.defaultTextFormat = txtFormat;
			loadingText.text = _message;
			loadingText.selectable = false;
			loadingText.autoSize = TextFieldAutoSize.CENTER;
			loadingText.x = backGround.width / 2 - loadingText.width / 2; loadingText.y = backGround.height / 2 - loadingText.height / 2;
			backGround.addChild(loadingText);
			_container.addChild(backGround);
			
			if (_applyProgressEvent)
			{
				preloader = new Preloader(_width * 0.39, _height * 0.05);
				preloader.x = backGround.width / 2 - _width * 0.195;
				preloader.y = loadingText.y + _height * 0.25;
				backGround.addChild(preloader);
			}
			
			setTimeout(startTask, delay);
			//TweenLite.delayedCall(delay, startTask);
		}
		
		private function startTask():void 
		{
			try 
			{
				_taskFunction();
				
				if(!_applyProgressEvent)
					setTimeout(taskComplete, delay);
				//TweenLite.delayedCall(delay, taskComplete);
			}
			catch (err:Error)
			{
				loadingText.text = "An error occured\nErrorCode: "+err.errorID+"\n\nPlease restart PaintBook";
				//loadingText.text = err.getStackTrace+"\n"+err.errorID + "\n" + err.name + "\n" + err.message+"\nTell this error to Mr. Shantanu";
				loadingText.y = backGround.height / 2 - loadingText.height / 2;
			}
		}
		
		public function progressUpdater(bytesLoaded:Number, bytesTotal:Number, progressMsg:String = ""):void
		{
			if (bytesLoaded == -1 && bytesTotal == -1 && progressMsg == "complete")
			{	
				setTimeout(taskComplete, delay);
				//TweenLite.delayedCall(delay, taskComplete);
			}
			else
			{
				loadingText.text = progressMsg;
				preloader.update(bytesLoaded / bytesTotal);
			}
		}
		
		private function taskComplete():void 
		{
			_container.removeChild(backGround);
			
			dispatchEvent(new Event(TaskLoader.TASK_COMPLETE));
		}
		
		public function set container(value:Sprite):void 
		{
			_container = value;
		}
		
		public function set message(value:String):void 
		{
			_message = value;
		}
		
		public function set applyProgressEvent(value:Boolean):void 
		{
			_applyProgressEvent = value;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
	}

}