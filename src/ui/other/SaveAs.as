package ui.other 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import utils.encoder.JPEGAsyncEncoder;
	import utils.encoder.JPEGAsyncCompleteEvent;
	import layers.save.LayerToArray;
	import settings.CustomUI;
	import settings.System;
	import utils.preloader.Preloader;
	import utils.taskLoader.TaskLoader;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import ui.message.SaveMessage;
	import flash.media.CameraRoll;
	import flash.events.PermissionEvent;
	import flash.permissions.PermissionStatus;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SaveAs extends Sprite
	{
		private var _exitHandler;
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var statusTxt:TextField;
		private var encoder:JPEGAsyncEncoder;
		private var preloader:Preloader;
		
		private var cameraRoll: CameraRoll;
		
		public function SaveAs(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "SaveAs";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			tween = new TweenNano(textField, 0.6, { x: sW * 0.1, ease:Strong.easeOut } );
			
			statusTxt = new TextField;statusTxt.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.align = "center";
			statusTxt.defaultTextFormat = txtFormat;
			statusTxt.text = "";
			statusTxt.selectable = false; 
			statusTxt.autoSize = TextFieldAutoSize.CENTER;
			statusTxt.x = sW * 0.684;
			statusTxt.y = sH * 0.5 - statusTxt.height * 0.5;
			addChild(statusTxt);
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Back";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack);
			tween = new TweenNano(sp, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "New Canvas";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.33;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;} );
			sp.addEventListener(MouseEvent.CLICK, newCanvasLoader);
			tween = new TweenNano(sp, 0.8, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Image";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.45;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; statusTxt.text = "Saving"; } );
			sp.addEventListener(MouseEvent.CLICK, saveImage);
			tween = new TweenNano(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
		}
		
		private function saveImage(e:MouseEvent):void 
		{
			cameraRoll = new CameraRoll();
			if (CameraRoll.permissionStatus != PermissionStatus.GRANTED)
			{
				cameraRoll.addEventListener(PermissionEvent.PERMISSION_STATUS, cameraRollPermissionStatus);

				try
				{
					cameraRoll.requestPermission();
				}
				catch (e: Error)
				{

				}

			}
			else
			{
				addToCameraRoll();
			}
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			/*var bd:BitmapData = new BitmapData(System.canvasWidth, System.canvasHeight, false, 0);
			bd.draw(System.canvas);
			
			encoder = new JPEGAsyncEncoder(80);
			encoder.PixelsPerIteration = 400;
			encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onE);
			encoder.addEventListener(ProgressEvent.PROGRESS, onEncodeProgress);
			encoder.encode(bd);
			
			preloader = new Preloader(sW * 0.195, sH * 0.033);
			preloader.x = sW * 0.684 - sW * 0.195 * 0.5;
			addChild(preloader);*/
		}
		
		private function addToCameraRoll(): void
		{
			var bd:BitmapData = new BitmapData(System.canvasWidth, System.canvasHeight, false, 0);
			bd.draw(System.canvas);
			
			cameraRoll.addBitmapData(bd);
			
			
			statusTxt.text = "Image Saved in gallery";

		}
		private function cameraRollPermissionStatus(e: PermissionEvent): void
		{
			cameraRoll.removeEventListener(PermissionEvent.PERMISSION_STATUS, cameraRollPermissionStatus);

			if (e.status == PermissionStatus.GRANTED)
			{
				addToCameraRoll();
			}
		}


		private function onEncodeProgress(e:ProgressEvent):void 
		{
			statusTxt.text = "Encoding";
			statusTxt.y = sH * 0.5 - statusTxt.height * 0.5;
			
			preloader.y = statusTxt.y + sH * 0.1667;
			preloader.update(e.bytesLoaded / e.bytesTotal);
		}
		
		private function onE(e:Event):void
		{
			var sm:SaveMessage = new SaveMessage("Image",onEncoded,"Image file","Image files will be saved under PaintBook_Images folder");
			addChild(sm);
		}
		
		private function onEncoded(e:Event):void 
		{
			var byteArray:ByteArray = encoder.ImageData;
			
			var storage:File = File.documentsDirectory.resolvePath("PaintBook_Images");
			//var storage:File = File.desktopDirectory.resolvePath("AIRTesT");
			if(!storage.exists)
			{
				storage.createDirectory();
			}
			
			var num:int = 0;
			var file:File;
			do
			{
				file = File.documentsDirectory.resolvePath("PaintBook_Images/Image"+num+".jpg");
				//file = File.desktopDirectory.resolvePath("AIRTesT/Image"+num+".jpeg");
				num++;
				
			}while (file.exists)
			
			statusTxt.text = "Saved Under\n\n PaintBook_Images";
			removeChild(preloader);
			
			var stream:FileStream = new FileStream();
			stream.openAsync(file, FileMode.WRITE);
			//stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgress);
			stream.writeBytes(byteArray);
		}
		
		private function onSaved(e:Event):void 
		{
			statusTxt.text = "Image Saved";
			removeChild(preloader);
		}
		
		private function newCanvasLoader(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var taskLoader:TaskLoader = new TaskLoader;
			taskLoader.container = this;
			taskLoader.message = "Saving into new canvas\n\nPlease Wait...";
			LayerToArray.update(taskLoader.progressUpdater);
			taskLoader.applyProgressEvent = true;
			taskLoader.addEventListener(TaskLoader.TASK_COMPLETE, onTaskComplete);
			taskLoader.wrap(saveNewCanvas);
		}
		
		private function saveNewCanvas():void
		{
			LayerToArray.save(true);
		}
		
		private function onTaskComplete(e:Event):void 
		{
			statusTxt.text = "Saved";
			OpenUI.instance.addNewCanvas();
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			_exitHandler();
		}
		
	}

}