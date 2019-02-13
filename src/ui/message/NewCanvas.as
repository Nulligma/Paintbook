package ui.message 
{
	import com.greensock.TweenNano;
	import fl.transitions.easing.Strong;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import utils.preloader.Preloader;
	//import flash.filesystem.File;
	//import flash.filesystem.FileMode;
	//import flash.filesystem.FileStream;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import layers.save.LayerToArray;
	import layers.setups.LayerList;
	import settings.CustomUI;
	import settings.System;
	import utils.taskLoader.TaskLoader;
	import flash.media.CameraRoll;
	import flash.permissions.PermissionStatus;
	import flash.events.MediaEvent;
	import flash.media.MediaPromise;
	import flash.events.PermissionEvent;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class NewCanvas extends Sprite
	{
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		
		private var canvasWidth:int;
		private var canvasHeight:int;
		private var layerList:LayerList;
		
		private var _status:int;
		private var _exitHandler:Function;
		private var widthTxt:TextField;
		private var heightTxt:TextField;
		private var checkedIcon:Sprite;
		private var blankBox:Sprite;
		private var imageBox:Sprite;
		private var okBtn:Sprite;
		private var cT:ColorTransform;
		private var bitData:BitmapData;
		private var drawImage:Boolean = false;
		
		private var minVal:int = 100;
		private var maxVal:int = 2000;
		private var loadImage:FileReference;
		private var preloader:Preloader;
		
		public function NewCanvas(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			canvasWidth = sW;
			canvasHeight = sH;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			graphics.beginFill(CustomUI.backColor); 
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			var tween:TweenNano;
			
			var textField:TextField = new TextField;
			textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "New Canvas";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.5 - textField.width * 0.5;
			textField.y = -textField.height;
			addChild(textField);
			tween = new TweenNano(textField, 1, { y: sH * 0.033, ease:Strong.easeOut } );
			
			
			var sp:Sprite;
			
			okBtn = new Sprite;
			okBtn.graphics.beginFill(CustomUI.color1); 
			okBtn.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); okBtn.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "OK";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = okBtn.width / 2 - textField.width / 2; textField.y = okBtn.height / 2 - textField.height / 2;
			okBtn.addChild(textField);
			addChild(okBtn);
			okBtn.x = sW * 0.01;
			okBtn.y = sH;
			okBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			okBtn.addEventListener(MouseEvent.CLICK, onOK);
			tween = new TweenNano(okBtn, 1, { y: sH - sH * 0.016 - okBtn.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Cancel";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW - sp.width - sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onCancel);
			tween = new TweenNano(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color1); sp.graphics.moveTo(0, 0);
			sp.graphics.lineTo(sW - sW * 0.02, 0);
			sp.x = -sp.width; sp.y = sH * 0.3;
			addChild(sp);
			tween = new TweenNano(sp, 0.8, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.lineStyle(1, CustomUI.color1); sp.graphics.moveTo(0, 0);
			sp.graphics.lineTo(sW - sW * 0.02, 0);
			sp.x = -sp.width; sp.y = sH * 0.633;
			addChild(sp);
			tween = new TweenNano(sp, 0.8, { x: sW * 0.01, ease:Strong.easeOut } );
			
			checkedIcon = new CheckIcon;
			checkedIcon.scaleX = checkedIcon.scaleY = (sH * 0.067 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			checkedIcon.transform.colorTransform = cT;
			checkedIcon.x = checkedIcon.width / 2;
			checkedIcon.y = checkedIcon.height / 2;
			
			blankBox = new Sprite;
			blankBox.graphics.beginFill(CustomUI.color1); 
			blankBox.graphics.drawRect(0, 0, sH * 0.067, sH * 0.067); blankBox.graphics.endFill();
			blankBox.x = sW;
			blankBox.y = sH * 0.267;
			//addChild(blankBox);
			tween = new TweenNano(blankBox, 1, { x: sW - blankBox.width - sW * 0.0488, ease:Strong.easeOut } );
			blankBox.addChild(checkedIcon);
			blankBox.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			blankBox.addEventListener(MouseEvent.CLICK, makeBlank);
			
			imageBox = new Sprite;
			imageBox.graphics.beginFill(CustomUI.color1); 
			imageBox.graphics.drawRect(0, 0, sH * 0.067, sH * 0.067); imageBox.graphics.endFill();
			imageBox.x = sW;
			imageBox.y = sH * 0.6;
			//addChild(imageBox);
			tween = new TweenNano(imageBox, 1, { x: sW - imageBox.width - sW * 0.0488, ease:Strong.easeOut } );
			imageBox.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			imageBox.addEventListener(MouseEvent.CLICK, makeImage);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.195, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Blank";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH * 0.25;
			tween = new TweenNano(sp, 1, { x: sW * 0.0488, ease:Strong.easeOut } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, makeBlank);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.195, sH * 0.1); sp.graphics.endFill();
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
			sp.x = -sp.width;
			sp.y = sH * 0.583;
			tween = new TweenNano(sp, 1, { x: sW * 0.0488, ease:Strong.easeOut } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, makeImage);
			
			sp = new Sprite;
			sp.name = "Width";
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Width";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			txtFormat.color = CustomUI.color1;
			widthTxt = new TextField;widthTxt.embedFonts = true;
			widthTxt.defaultTextFormat = txtFormat;
			widthTxt.text = String(canvasWidth);
			widthTxt.type = TextFieldType.INPUT;
			widthTxt.background = true;
			widthTxt.backgroundColor = CustomUI.color2;
			widthTxt.autoSize = TextFieldAutoSize.CENTER;
			widthTxt.maxChars = 4;
			widthTxt.restrict = "0-9";
			widthTxt.x = sp.width - widthTxt.width - sW * 0.029; widthTxt.y = sp.height / 2 - widthTxt.height / 2;
			sp.addChild(widthTxt);
			sp.x = -sp.width;
			sp.y = sH * 0.383;
			tween = new TweenNano(sp, 1, { x: sW * 0.195, ease:Strong.easeOut } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, setFocus);
			
			sp = new Sprite;
			sp.name = "Height";
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Height";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			txtFormat.color = CustomUI.color1;
			heightTxt = new TextField;heightTxt.embedFonts = true;
			heightTxt.defaultTextFormat = txtFormat;
			heightTxt.text = String(canvasHeight);
			heightTxt.type = TextFieldType.INPUT;
			heightTxt.background = true;
			heightTxt.backgroundColor = CustomUI.color2;
			heightTxt.autoSize = TextFieldAutoSize.CENTER;
			heightTxt.x = sp.width - heightTxt.width - sW * 0.029; heightTxt.y = sp.height / 2 - heightTxt.height / 2;
			heightTxt.maxChars = 4;
			heightTxt.restrict = "0-9";
			sp.addChild(heightTxt);
			addChild(sp);
			sp.x = sW;
			sp.y = sH * 0.383;
			tween = new TweenNano(sp, 1, { x: sW - sW * 0.195 - sp.width, ease:Strong.easeOut } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, setFocus);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Select Image";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH * 0.7167;
			tween = new TweenNano(sp, 1, { x: sW * 0.195, ease:Strong.easeOut } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, showDialog);
			sp.addEventListener(MouseEvent.CLICK, getImage);
			
			addEventListener(MouseEvent.MOUSE_DOWN, checkVals);
		}
		
		private function getImage(e:MouseEvent):void 
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				if (CameraRoll.permissionStatus != PermissionStatus.GRANTED)
				{
					var roll: CameraRoll = new CameraRoll();
					roll.addEventListener(PermissionEvent.PERMISSION_STATUS, function (e: PermissionEvent): void
					{
						if (e.status == PermissionStatus.GRANTED)
						{
							launchCameraRoll();
						}
					});

					try
					{
						roll.requestPermission();
					}
					catch (e: Error)
					{
						// another request is in progress  
					}
				}
				else
				{
					launchCameraRoll();
				}
			}
			else
			{
				trace( "Image browsing is not supported on this device.");
			} 
			
			//var file:File = File.userDirectory;
			//file.addEventListener(Event.SELECT, onFileSelected);
			//file.browseForOpen("Open file", [new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png; *.JPG")]);
			
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
		}
		
		private function launchCameraRoll(): void
		{
			var roll: CameraRoll = new CameraRoll();
			roll.addEventListener(MediaEvent.SELECT, imageSelected);
			roll.browseForImage();
		}

		private function imageSelected( event:MediaEvent ):void
		{
			//log( "Image selected..." );
			
			var imagePromise:MediaPromise = event.data;
			
			var imageLoader:Loader = new Loader();
			if( imagePromise.isAsync )
			{
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageParse );
				//imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, imageLoadFailed );
				imageLoader.loadFilePromise( imagePromise );
			}
			else
			{
				trace( "Synchronous media promise." );
				//imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
				//imageLoader.loadFilePromise( imagePromise );
				//this.addChild( imageLoader );
			}
		}
		
		
		private function showDialog(e:MouseEvent):void 
		{
			okBtn.visible = false;
			
			loadImage = new FileReference();
			loadImage.addEventListener(Event.SELECT, onFileSelected);
			loadImage.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png; *.JPG")]);
		}
		
		private function onFileSelected(e:Event):void 
		{
			if (!preloader)
			{
				preloader = new Preloader(sW * 0.195, sH * 0.033);
				preloader.x = sW/2 - sW * 0.195;
				preloader.y = sH/2 - sH * 0.033;
			}
			addChild(preloader);
			
			loadImage.addEventListener(Event.COMPLETE, onFileLoaded);
			loadImage.addEventListener(ProgressEvent.PROGRESS, showProgress);
			loadImage.load();
		}
		
		private function showProgress(e:ProgressEvent):void 
		{
			preloader.update(e.bytesLoaded / e.bytesTotal);
		}
		
		private function onFileLoaded(e:Event):void 
		{
			loadImage.removeEventListener(Event.COMPLETE, onFileLoaded);
			var image:Loader = new Loader();
			image.loadBytes(loadImage.data);
			image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
		}
		
		private function onImageParse(e:Event):void 
		{
			//removeChild(preloader);
			
			var bm:Bitmap = LoaderInfo(e.target).content as Bitmap;
			bitData = bm.bitmapData;
			
			drawImage = true;
			onOK(null);
			
			//okBtn.visible = true;
		}
		
		private function makeImage(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			imageBox.addChild(checkedIcon);
			
			if (bitData == null)
			{
				okBtn.visible = false;
			}
			drawImage = true;
		}
		
		private function makeBlank(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			blankBox.addChild(checkedIcon);
			drawImage = false;
			okBtn.visible = true;
		}
		
		private function setFocus(e:MouseEvent):void 
		{
			if (e.currentTarget.name == "Width")
			{
				stage.focus = widthTxt;
				//TODO:RequestKeyBoard
				//widthTxt.requestSoftKeyboard();
				widthTxt.setSelection(widthTxt.text.length, widthTxt.text.length);
			}
			else
			{
				stage.focus = heightTxt;
				//heightTxt.requestSoftKeyboard();
				heightTxt.setSelection(heightTxt.text.length, heightTxt.text.length);
			}
		}
		
		private function checkVals(e:MouseEvent):void 
		{
			var tempWidth:int = int(widthTxt.text);
			var tempHeight:int = int(heightTxt.text);
			
			tempWidth = tempWidth > maxVal?maxVal:tempWidth < minVal?minVal:tempWidth;
			tempHeight = tempHeight > maxVal?maxVal:tempHeight < minVal?minVal:tempHeight;
			
			widthTxt.text = String(tempWidth);
			heightTxt.text = String(tempHeight);
			
			canvasWidth = tempWidth;
			canvasHeight = tempHeight;
		}
		
		private function onCancel(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			_status = 0;
			_exitHandler();
		}
		
		private function onOK(e:MouseEvent):void 
		{
			if(e!=null)
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var taskLoader:TaskLoader = new TaskLoader;
			taskLoader.container = this;
			taskLoader.message = "Generating new canvas\n\nPlease Wait...";
			LayerToArray.update(taskLoader.progressUpdater);
			taskLoader.applyProgressEvent = true;
			taskLoader.addEventListener(TaskLoader.TASK_COMPLETE,onTaskComplete);
			taskLoader.wrap(createNewCanvas);
		}
		
		private function createNewCanvas():void
		{
			_status = 1;
			
			if (drawImage)
			{
				canvasWidth = bitData.width;
				canvasHeight = bitData.height;
			}
			
			LayerList.loadWith(new LayerList());
			layerList = LayerList.instance;
			layerList.initNewLayer(canvasWidth, canvasHeight);
			
			if (drawImage)
				layerList.currentLayer.copyPixels(bitData, bitData.rect,new Point(0,0));
			
			System.canvasWidth = canvasWidth;
			System.canvasHeight = canvasHeight;
			System.createCanvas();
			
			System.currentCanvasIndex = 0;
			
			var canvasData:Array = new Array();
			
			canvasData[0] = canvasWidth;
			canvasData[1] = canvasHeight;
			
			System.canvasList.unshift(canvasData);
			
			LayerToArray.save();
		}
		
		private function onTaskComplete(e:Event):void 
		{
			_exitHandler();
		}
		
		public function get status():int 
		{
			return _status;
		}
		
	}

}