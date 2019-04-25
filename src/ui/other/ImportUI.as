package ui.other 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.LoaderContext;
	import flash.system.Security;
	//import flash.filesystem.FileMode;
	//import flash.filesystem.FileStream;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	//import flash.filesystem.File;
	import flash.utils.ByteArray;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	import tools.transform.TransformTool;
	import utils.preloader.Preloader;
	
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.CustomUI;
	import flash.filesystem.File;
	import flash.media.CameraRoll;
	import flash.events.MediaEvent;
	import flash.media.MediaPromise;
	import flash.permissions.PermissionStatus;
	import flash.events.PermissionEvent;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ImportUI extends Sprite
	{
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var _exitHandler:Function;
		
		private var selectedPaper:int = -1;
		private var urlBitData:BitmapData;
		
		private var paperHolder:Sprite;
		private var checkIcon:Sprite;
		private var customSlider:CustomSlider;
		
		private var layerList:LayerList;
		private var urlHolder:Sprite;
		private var imagePreview:Sprite;
		private var urlTxt:TextField;
		private var urlLoader:Loader;
		
		private var doneButton:Sprite;
		
		private var imageHolder:Sprite;
		private var imageBitData:BitmapData;
		
		private var allowedExtentions:Array = new Array("jpg", "png", "gif", "jpeg", "JPG", "PNG", "GIF", "JPEG", ".jpg", ".png", ".gif", ".JPG", ".PNG", ".GIF");
		private var preloader:Preloader;
		private var url:String;
		
		private var proxyUrl:String = "http://nulligma.com/projects/paintbook/tmpDownload.php?url=";
		private var imageLoader:Loader;
		
		
		public function ImportUI(exitHandler:Function) 
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
			
			textField = new TextField; textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Import";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			tween = new TweenNano(textField, 0.6, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField; textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Done";
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
			textField.text = "Image";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.2917;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addImage);
			tween = new TweenNano(sp, 0.8, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Paper";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.4083;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addPapers);
			tween = new TweenNano(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "URL";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.525;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addURL);
			tween = new TweenNano(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
			
			checkIcon = new Sprite;
			checkIcon.graphics.beginFill(CustomUI.color2);
			checkIcon.graphics.drawRect(0, 0, sH * 0.067, sH * 0.067);
			checkIcon.graphics.endFill();
			var sp2:Sprite = new CheckIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.067 / 50);
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp2.width / 2;
			sp2.y = sp2.height / 2;
			checkIcon.addChild(sp2);
		}
		
		private function addImage(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (imageHolder) return;
			
			removeSubMenu();
			
			imageHolder = new Sprite;
			
			imageHolder.graphics.beginFill(CustomUI.color1);
			imageHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			imageHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			imagePreview = new Sprite;
			imagePreview.graphics.beginFill(CustomUI.color2);
			imagePreview.graphics.drawRect(0, 0, sW * 0.43, sH * 0.5);
			imagePreview.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Image Preview";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = imagePreview.width / 2 - textField.width / 2; textField.y = imagePreview.height / 2 - textField.height / 2;
			imagePreview.addChild(textField);
			imagePreview.x = sW * 0.0488;
			imagePreview.y = sH * 0.0667;
			imageHolder.addChild(imagePreview);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.137, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Clear";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.767;
			imageHolder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, clearLoadedImage );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.137, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Load";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.3428;
			sp.y = sH * 0.767;
			imageHolder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, loadImage );
			
			imageHolder.x = sW * 0.5 + imageHolder.width * 0.5;
			
			addChild(imageHolder);
			tween = new TweenNano(imageHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function loadImage(e:MouseEvent):void 
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
			
			imageLoader = new Loader();
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
		
		private function onFileSelected(e:Event):void 
		{
			var file:File = e.currentTarget as File;
			
			imageLoader = new Loader();
			var urlReq:URLRequest = new URLRequest(file.url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
			imageLoader.load(urlReq);
		}
		
		private function onFileLoaded(e:Event):void 
		{
			//imageLoader.removeEventListener(Event.COMPLETE, onFileLoaded);
			//var image:Loader = new Loader();
			//image.loadBytes(imageLoader.data);
			//image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
		}
		
		private function onImageParse(e:Event):void 
		{
			var bm:Bitmap = LoaderInfo(e.target).content as Bitmap;
			imageBitData = bm.bitmapData;
			
			var w:int = bm.width; var h:int = bm.height; var sf:Number = 1.00;
			while (w * sf > imagePreview.width || h * sf > imagePreview.height)
			{
				sf -= 0.01;
			}
			
			bm.scaleX = bm.scaleY = sf;
			bm.x = imagePreview.width / 2 - bm.width / 2;
			bm.y = imagePreview.height / 2 - bm.height / 2;
			imagePreview.addChild(bm);
		}
		
		private function addURL(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (urlHolder) return;
			
			removeSubMenu();
			
			urlHolder = new Sprite;
			
			urlHolder.graphics.beginFill(CustomUI.color1);
			urlHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			urlHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			imagePreview = new Sprite;
			imagePreview.graphics.beginFill(CustomUI.color2);
			imagePreview.graphics.drawRect(0, 0, sW * 0.43, sH * 0.5);
			imagePreview.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Image Preview";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = imagePreview.width / 2 - textField.width / 2; textField.y = imagePreview.height / 2 - textField.height / 2;
			imagePreview.addChild(textField);
			imagePreview.x = sW * 0.0488;
			imagePreview.y = sH * 0.0667;
			urlHolder.addChild(imagePreview);
			
			txtFormat.color = CustomUI.color1;
			txtFormat.align = "center";
			txtFormat.size = sH * 0.083 * 0.6;
			urlTxt = new TextField;urlTxt.embedFonts = true;
			urlTxt.defaultTextFormat = txtFormat;
			urlTxt.text = "Paste URL here";
			urlTxt.background = true;
			urlTxt.backgroundColor = CustomUI.color2;
			urlTxt.type = TextFieldType.INPUT;
			urlTxt.width = sW * 0.43;
			urlTxt.height = sH * 0.083;
			urlTxt.x = sW * 0.0488;
			urlTxt.y = sH * 0.667;
			urlTxt.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { if (urlTxt.text == "Paste URL here") { urlTxt.text = ""; } } );
			urlHolder.addChild(urlTxt);
			
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.137, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Clear";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.767;
			urlHolder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, clearLoadedImage );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.137, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Load";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.3428;
			sp.y = sH * 0.767;
			urlHolder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, loadUrl );
			
			urlHolder.x = sW * 0.5 + urlHolder.width * 0.5;
			
			addChild(urlHolder);
			tween = new TweenNano(urlHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
			
		}
		
		private function loadUrl(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			url = urlTxt.text as String; 
			
			var textField:TextField;
			
			if (url== null || url == "") return;
			
			var imageExtension:String = new String(url.substring(url.length-4,url.length))
			if (allowedExtentions.indexOf(imageExtension) != -1)
			{
				var sp:Sprite = new Sprite;
				sp.graphics.beginFill(0, 0.5);
				sp.graphics.drawRect(0, 0, urlHolder.width, urlHolder.height);
				txtFormat.color = 0xFFFFFF;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = "Loading";
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				
				preloader = new Preloader(sW * 0.195, sH * 0.033);
				preloader.x = sp.width / 2 - sW * 0.195 * 0.5;
				preloader.y = textField.y + sH * 0.1667;
				sp.addChild(preloader);
			
				urlHolder.addChild(sp);
				
				var req:URLRequest = new URLRequest(url);
				urlLoader = new Loader();
				urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
				urlLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				urlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOerrorHandler);
				urlLoader.load(req,new LoaderContext(true));
			}
			else
			{
				while (imagePreview.numChildren > 0)
				{
					imagePreview.removeChildAt(0);
				}
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.4;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = "Only .jpg .png .gif\ncan be loaded";
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = imagePreview.width / 2 - textField.width / 2; textField.y = imagePreview.height / 2 - textField.height / 2;
				imagePreview.addChild(textField);
			}
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			var sp:Sprite = urlHolder.getChildAt(urlHolder.numChildren - 1) as Sprite;
			var txtF:TextField = sp.getChildAt(0) as TextField;
			
			txtF.text = "Loading";
			preloader.update(e.bytesLoaded / e.bytesTotal);
		}
		
		private function IOerrorHandler(e:IOErrorEvent):void 
		{
			urlHolder.removeChildAt(urlHolder.numChildren - 1);
			
			while (imagePreview.numChildren > 0)
			{
				imagePreview.removeChildAt(0);
			}
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			var textField:TextField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Cannot load URL";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = imagePreview.width / 2 - textField.width / 2; textField.y = imagePreview.height / 2 - textField.height / 2;
			imagePreview.addChild(textField);
			
			urlLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader = null;
		}
		
		private function onLoaded(e:Event):void 
		{
			urlHolder.removeChildAt(urlHolder.numChildren - 1);
			
			while (imagePreview.numChildren > 0)
			{
				imagePreview.removeChildAt(0);
			}
			
			var bm:Bitmap; 
			
			try
            {
               bm = urlLoader.content as Bitmap;
            } 
            catch(error:SecurityError) 
            {
                throw error;
            }
			
			urlBitData = bm.bitmapData;
			
			var w:int = bm.width; var h:int = bm.height; var sf:Number = 1.00;
			while (w * sf > imagePreview.width || h * sf > imagePreview.height)
			{
				sf -= 0.01;
			}
			
			bm.scaleX = bm.scaleY = sf;
			bm.x = imagePreview.width / 2 - bm.width / 2;
			bm.y = imagePreview.height / 2 - bm.height / 2;
			imagePreview.addChild(bm);
			
			urlLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader = null;
		}
		
		private function clearLoadedImage(e:MouseEvent):void 
		{
			if (e)
			{
				e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			}
			
			urlBitData = null; imageBitData = null;
			
			while (imagePreview.numChildren > 0)
			{
				imagePreview.removeChildAt(0);
			}
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			var textField:TextField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Image Preview";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = imagePreview.width / 2 - textField.width / 2; textField.y = imagePreview.height / 2 - textField.height / 2;
			imagePreview.addChild(textField);
			
			urlTxt.text = "";
		}
		
		private function addPapers(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (paperHolder) return;
			
			removeSubMenu();
			
			paperHolder = new Sprite;
			
			paperHolder.graphics.beginFill(CustomUI.color1);
			paperHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			paperHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			var bmp:Bitmap;
			for (var i:int = 0; i < 7; i++)
			{
				sp = new Sprite;
				sp.name = String(i);
				sp.graphics.beginFill(CustomUI.color2);
				sp.graphics.drawRect(0, 0, sW * 0.21, sH * 0.21);
				sp.graphics.endFill();
				
				bmp = new Bitmap;
				if (i == 0)
					bmp.bitmapData = new APrev;
				else if (i == 1)
					bmp.bitmapData = new CPrev;
				else if (i == 2)
					bmp.bitmapData = new DPrev;
				else if (i == 3)
					bmp.bitmapData = new HLPrev;
				else if (i == 4)
					bmp.bitmapData = new LPrev;
				else if (i == 5)
					bmp.bitmapData = new MPrev;
				else if (i == 6)
					bmp.bitmapData = new SPrev;
				
				bmp.x = sp.width / 2 - bmp.width / 2;
				bmp.y = sp.height / 2 - bmp.height / 2;
				sp.addChild(bmp);
				
				paperHolder.addChild(sp);
				sp.x = (i % 2) * (sW * 0.21 + sW * 0.01) + sW * 0.0488;
				sp.y = int(i / 2) * (sH * 0.21 + sH * 0.01667) + sH * 0.0667;
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, changePaper );
			}
			
			paperHolder.x = sW * 0.5 + paperHolder.width * 0.5;
			
			addChild(paperHolder);
			tween = new TweenNano(paperHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function changePaper(e:MouseEvent):void 
		{
			var sp:Sprite = e.currentTarget as Sprite;
			
			sp.scaleX = sp.scaleY = 1;
			
			if (sp.contains(checkIcon))
			{
				selectedPaper = -1;
				sp.removeChild(checkIcon);
			}
			else
			{
				sp.addChild(checkIcon);
				selectedPaper = int(sp.name);
			}
		}
		
		private function removeSubMenu():void 
		{
			var tween:TweenNano;
			
			if (imageHolder && imageHolder.stage)
			{
				imageBitData = null;
				
				tween = new TweenNano(imageHolder, 0.5, { x: sW * 0.5 + imageHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(imageHolder); imageHolder = null; } } );
			}
			if (urlHolder && urlHolder.stage)
			{
				urlBitData = null;
				
				if (urlLoader)
				{
					urlLoader.close();
					urlLoader.unloadAndStop(true);
					urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
					urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOerrorHandler);
					urlLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				}
				tween = new TweenNano(urlHolder, 0.5, { x: sW * 0.5 + urlHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(urlHolder); urlHolder = null; } } );
			}
			if (paperHolder && paperHolder.stage)
			{
				selectedPaper = -1;
				if (checkIcon.stage)
				{
					(checkIcon.parent as Sprite).removeChild(checkIcon);
				}
				tween = new TweenNano(paperHolder, 0.5, { x: sW * 0.5 + paperHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(paperHolder); paperHolder = null; } } );
			}
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			var bd:BitmapData;
			if (selectedPaper != -1)
			{
				if (selectedPaper == 0)
					bd = new AxisImg;
				else if (selectedPaper == 1)
					bd = new CheckPaperImg;
				else if (selectedPaper == 2)
					bd = new DotsImg;
				else if (selectedPaper == 3)
					bd = new HalfLinedImg;
				else if (selectedPaper == 4)
					bd = new LinedImg;
				else if (selectedPaper == 5)
					bd = new MultiGraphImg;
				else if (selectedPaper == 6)
					bd = new StaffImg;
			}
			else if (urlBitData)
			{
				bd = urlBitData;
			}
			else if (imageBitData)
			{
				bd = imageBitData;
			}
			
			if (urlLoader)
			{
				urlLoader.close();
				urlLoader.unloadAndStop(true);
				urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
				urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOerrorHandler);
				urlLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			}
			
			if (bd)
			{
				
				if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1) ToolManager.toggle(ToolType.CLIP);
				if (ToolManager.activeTools.indexOf(ToolType.LASSO) != -1) ToolManager.toggle(ToolType.LASSO);
				if (ToolManager.activeTools.indexOf(ToolType.TRANSFORM) != -1) ToolManager.toggle(ToolType.TRANSFORM);
				
				ToolManager.clipRect = bd.rect;
				TransformTool.instance.splData = bd;
				ToolManager.toggle(ToolType.TRANSFORM);
				ToolManager.clipRect = new Rectangle(0, 0, System.canvasWidth, System.canvasHeight);
			}
			
			_exitHandler();
		}
		
	}

}