package ui.other 
{
	import colors.convertor.ColorComponent;
	import colors.convertor.ConvertColor;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import utils.taskLoader.TaskLoader;
	
	import layers.save.LayerToArray;
	import settings.CustomUI;
	import settings.System;
	import ui.message.NewCanvas;
	import ui.message.Warning;
	import flash.filesystem.File;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import ui.message.SaveMessage;
	import flash.permissions.PermissionStatus;
	import flash.events.PermissionEvent;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.text.TextField;
	import com.greensock.TweenLite;
	import flash.text.TextFieldAutoSize;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class OpenUI extends Sprite
	{
		private static var _instance:OpenUI;
		
		private var addedOnce:Boolean = false;
		
		private var sW:int;
		private var sH:int;
		private var oldX:Number;
		private var spriteList:Array;
		private var lastIndex:int;
		private var spWidth:Number;
		private var halfWidth:Number;
		private var cT:ColorTransform;
		private var currentCanvasSP:Sprite;
		
		private var tween:TweenNano;
		private var select:Boolean = false;
		private var canvasList:Array;
		private var newCanvasMsg:NewCanvas;
		private var tempStage:Stage;
		private var _exitHandler:Function;
		private var selectedIndex:int;
		private var deleteWarning:Warning;
		private var deleteBtn:Sprite;
		
		private var sp:Sprite;
		private var lineSp:Sprite;
		private var shadowSp:Sprite;
		private var bitMap:Bitmap;
		private var bd:BitmapData;
		private var byteArray:ByteArray;
		private var tempWidth:int;
		private var tempHeight:int;
		private var settingsUI:SettingsUI;
		private var currentPressed:Sprite;
		
		private var openBtnsHolder:Sprite;
		private var openIndex:int;
		
		private var canvasRotationFactor:Number;
		private var loadCanvases:FileReference;
		
		private var sm:SaveMessage;
		
		private var buttonGroup:Sprite;
		
		private const NUM_ICONS:int = 6;
		
		//TODO: Improve OpenUI
		
		public function OpenUI(exitHandler:Function) 
		{
			_instance = this;
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if (addedOnce) return;
			
			init();
		}
		
		private function init()
		{
			//BackBoard.instance.stage.addEventListener(Event.RESIZE, resizeListener);
			
			canvasList = System.canvasList;
			lastIndex = canvasList.length-1;
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			halfWidth = sW * 0.5;
			spWidth = sW * 0.5;
			
			canvasRotationFactor = 153.6/sW;
			
			var color2:uint = ConvertColor.changeColorComponent(CustomUI.backColor, ColorComponent.LUMINANCE, -1, 1, 0.1);
			
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(sW,sH,0,0,0);
			graphics.beginGradientFill(GradientType.RADIAL, [CustomUI.backColor, color2], [1, 1], [0, 255],mtx);
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			var sp2:Sprite;
			
			buttonGroup = new Sprite();
			addChild(buttonGroup);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new SaveToBox;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW * 0.01 + sp.width/2;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, saveToRack);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new OpenFromBox;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = (sp.width*1.5) + sW * 0.02;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, openFromRack);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new newBox;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = (sp.width*2.5) + sW * 0.03;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, newRack);
			
			/*sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new HelpIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW - (sp.width*1.5) - sW * 0.02;
			sp.y = sH * 0.01667 + sp.height / 2;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, onSettings);*/
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new SettingsIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW - sp.width/2 - sW * 0.01;
			sp.y = sH * 0.01667 + sp.height / 2;
			buttonGroup.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, onSettings);
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW*0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
			sp2 = new PlusIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp.addChild(sp2);
			sp.x = sW * 0.5 - sp.width / 2 - sW * 0.0195;
			sp.y = sH -  sH * 0.033 - sp.height / 2;
			buttonGroup.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.MOUSE_UP, onNewCanvas);
			
			deleteBtn = new Sprite;
			deleteBtn.graphics.lineStyle(sW*0.001, CustomUI.color1); deleteBtn.graphics.beginFill(CustomUI.color2); 
			deleteBtn.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); deleteBtn.graphics.endFill();
			sp2 = new DeleteIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			deleteBtn.addChild(sp2);
			deleteBtn.x = sW * 0.5 + deleteBtn.width / 2 + sW * 0.0195;
			deleteBtn.y = sH -  sH * 0.033 - deleteBtn.height / 2;
			buttonGroup.addChild(deleteBtn);
			if (lastIndex < 0)
			{
				deleteBtn.alpha = 0.5;
				return;
			}
			else
			{
				deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
				deleteBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			}
			
			spriteList = new Array;
			
			for (var i:int = 0; i <= lastIndex; i++)
			{
				createCanvasSprite(i);
			}
			currentCanvasSP = spriteList[0] as Sprite;
			byteArray = null;
			
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stagePress);
		}
		
		private function gotoReddit(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("https://www.reddit.com/r/paintbook"), "_blank");
		}
		
		private function onFullScreen(e:MouseEvent):void 
		{
			System.isFullScreen = !System.isFullScreen;
			BackBoard.instance.stage.displayState = System.isFullScreen?StageDisplayState.FULL_SCREEN_INTERACTIVE:StageDisplayState.NORMAL;
		}
		
		/*private function resizeListener(e:Event):void 
		{
			if (!this.stage) return;
			
			BackBoard.instance.stage.removeEventListener(Event.RESIZE, resizeListener);
			
			System.stageWidth = BackBoard.instance.stage.stageWidth;
			System.stageHeight = BackBoard.instance.stage.stageHeight;
			
			BackBoard.instance.restartApp();
		}*/
		
		private function newRack(e:MouseEvent):void
		{
			var head:String = "New Canvas Rack!";
			var msg:String = "Are you sure you want to create a new rack and delete all current canvases?\nCanvases that are not saved in .rack file will be lost";
			deleteWarning = new Warning(Warning.UNSTOPPABLE, confirmNewRack, head, msg);
			addChild(deleteWarning);
		}
		
		private function confirmNewRack():void
		{
			if(deleteWarning.status == 0)
				tween = new TweenNano(deleteWarning, 0.5, { y: -deleteWarning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(deleteWarning); } } );
			else
			{
				var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
				so.clear();
				
				var canvasList:Array = new Array();
				System.loadCanvasList(canvasList);
				
				redrawCanvasList();
				
				tween = new TweenNano(deleteWarning, 0.5, { y: -deleteWarning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(deleteWarning); } } );
			}
		}
		
		private function openFromRack(e:MouseEvent):void 
		{
			//loadCanvases = new FileReference();
			//loadCanvases.addEventListener(Event.SELECT, onFileSelected);
			//loadCanvases.browse([new FileFilter("Canvas rack (*.rack)", "*.rack")]);
			
			var file:File = File.documentsDirectory.resolvePath("PaintBook_Saves");
			if(!file.exists)
			{
				file.createDirectory();
			}
			
			openBtnsHolder = new Sprite();
			openIndex = 0;
			addChild(openBtnsHolder);
			
			openBtnsHolder.graphics.beginFill(CustomUI.backColor); 
			openBtnsHolder.graphics.drawRect(0, 0, sW, sH);
			openBtnsHolder.graphics.endFill();
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var textField:TextField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Select a canvas rack";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW/2 - textField.width/2;
			textField.y = 0;
			openBtnsHolder.addChild(textField);
			
			var sp = new Sprite;
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
			openBtnsHolder.addChild(sp);
			sp.x = sW/2 - sp.width/2;
			sp.y = sH - sp.height*2;
			
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; removeChild(openBtnsHolder); } );
			
			var FLIST:Array = file.getDirectoryListing();
			var File_Ext:String;
			for (var s:int = 0; s < FLIST.length; s++)
			{
				File_Ext = "" + FLIST[s].extension;

				if (File_Ext.toLowerCase() == "rack")
				{
					createOpenBtns(FLIST[s].name);
				}
			}
			//file.addEventListener(Event.SELECT, onFileSelected);
			//file.browse([new FileFilter("Canvas rack (*.rack)", "*.rack")]);
		}
		
		private function createOpenBtns(fileName:String):void
		{
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var sp = new Sprite;
			sp.name = fileName;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.35;
			var textField:TextField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = fileName;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			openBtnsHolder.addChild(sp);
			sp.x = sp.width;
			sp.y = sH;
			
			sp.x = sW; sp.y = ((sH * 0.13) * int(openIndex / 6)) + sH * 0.33;
			TweenLite.to(sp, 1, { x: ((sW * 0.16) * (openIndex % 6)) + sW * 0.01 , ease:Strong.easeOut } );
				
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, openFile);
			
			openIndex++;
		}
		
		private function openFile(e:MouseEvent):void 
		{
			//var file:File = e.currentTarget as File;
			
			var sp:Sprite = e.currentTarget as Sprite;
			sp.scaleX = sp.scaleY = 1;
			
			removeChild(openBtnsHolder);
			trace(sp.name);
			var file:File = File.documentsDirectory.resolvePath("PaintBook_Saves/" + sp.name);
			file.addEventListener(Event.COMPLETE, onFileLoaded);
			file.load();
			
			//loadCanvases.addEventListener(Event.COMPLETE, onFileLoaded);
			//loadCanvases.load();
		}
		
		private function onFileSelected(e:Event):void 
		{
			var file:File = e.currentTarget as File;
			file.addEventListener(Event.COMPLETE, onFileLoaded);
			file.load();
		}
		
		private function onFileLoaded(e:Event):void
		{
			var loadCanvases:File = e.currentTarget as File;
			
			var canvasList:Array = new Array();
			canvasList = loadCanvases.data.readObject() as Array;
			
			System.loadCanvasList(canvasList);
			redrawCanvasList();
			
		}
		
		private function saveToRack(e:MouseEvent):void 
		{
			currentPressed.scaleX = currentPressed.scaleY = 1;
			
			sm = new SaveMessage("Canvas",nameSelected,"Canvas Rack","Canvases will be saved under PaintBook_Saves folder in a *.rack file","Untitled_rack");
			addChild(sm);
		}
		
		private function nameSelected(rn:String):void
		{	
			rn += ".rack";
			
			//var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
			
			var storage:File = File.documentsDirectory.resolvePath("PaintBook_Saves");
			//var storage:File = File.desktopDirectory.resolvePath("AIRTesT");
			
			if(!storage.exists)
			{
				storage.createDirectory();
			}
			
			storage = File.documentsDirectory.resolvePath("PaintBook_Saves/" + rn);
			
			storage.addEventListener(PermissionEvent.PERMISSION_STATUS, function(e:PermissionEvent):void {
                        // does not reach to this point if user declined permission request
				if (e.status == PermissionStatus.GRANTED)
				{
					var ba:ByteArray = new ByteArray();
					ba.writeObject(System.canvasList);
					
					var stream:FileStream = new FileStream();
					stream.open(storage, FileMode.WRITE);                                         
					
					removeChild(sm);
					
					stream.writeBytes(ba);
					stream.close();
					//storage.save(ba, rn);
				}});

			try {
				storage.requestPermission();
			} catch(e:Error)
			{
				// another request is in progress
				trace("REQUEST ERROR!!!");
			}
			
			
		}
		
		private function stagePress(e:MouseEvent):void 
		{
			if (currentPressed)
			{
				currentPressed.scaleX = currentPressed.scaleY = 1;
				currentPressed = null;
			}
		}
		
		private function onSettings(e:MouseEvent):void 
		{
			settingsUI = new SettingsUI(onSettingsRetrun);
			
			addChild(settingsUI);
		}
		
		private function onSettingsRetrun():void 
		{
			tween = new TweenNano(settingsUI, 0.5, { y: -settingsUI.height, ease:Linear.easeIn, onComplete:function():void { removeChild(settingsUI); } } );
		}
		
		private function createCanvasSprite(i:int):void
		{
			tempWidth = canvasList[i][0] >= sW?sW:canvasList[i][0];
			tempHeight = canvasList[i][1] >= sH?sH:canvasList[i][1];
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2, 1);
			sp.graphics.drawRect(-sW * 0.25,-sH * 0.25, spWidth, sH * 0.5);
			sp.graphics.endFill();
			sp.name = String(i);
			
			
			byteArray = new ByteArray();
			byteArray.writeBytes(canvasList[i][2] as ByteArray);
			byteArray.uncompress();
			
			bd = new BitmapData(tempWidth, tempHeight, false, 0xFFFFFF);
			bd.setPixels(new Rectangle(0, 0, tempWidth, tempHeight), byteArray);
			byteArray.clear();
			
			bitMap = new Bitmap(bd);
			bitMap.scaleX = bitMap.scaleY = 0.5;
			bitMap.x = -bitMap.width / 2; bitMap.y = -bitMap.height / 2;
			sp.addChild(bitMap);
			
			lineSp = new Sprite;
			lineSp.graphics.lineStyle(sH*0.01667,CustomUI.color1,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			lineSp.graphics.drawRect(-sW * 0.25,-sH * 0.25, spWidth, sH * 0.5);
			lineSp.graphics.endFill();
			sp.addChild(lineSp);
			
			sp.x = (i * spWidth) + halfWidth;
			sp.y = sH / 2;
			
			shadowSp = new Sprite;
			shadowSp.graphics.beginFill(0, 1);
			shadowSp.graphics.drawEllipse( -sW * 0.25, -sH * 0.25, spWidth, sH * 0.0083);
			shadowSp.graphics.endFill();
			shadowSp.y = sp.height;
			shadowSp.filters = [new BlurFilter(10, 10, 3)];
			sp.addChild(shadowSp);
			
			sp.rotationY = (sp.x - halfWidth) * canvasRotationFactor;
			
			spriteList.push(sp);
			addChild(sp);
			sp.alpha = 0;
			new TweenNano(sp, 0.5, { alpha: 1, ease:Linear.easeIn } );
			sp.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		private function createDeleteMsg(e:MouseEvent):void 
		{
			var head:String = "Delete Canvas!";
			deleteWarning = new Warning(Warning.UNSTOPPABLE, returnDeleteMsg, head);
			addChild(deleteWarning);
			
		}
		
		private function returnDeleteMsg():void 
		{
			if(deleteWarning.status == 0)
				tween = new TweenNano(deleteWarning, 0.5, { y: -deleteWarning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(deleteWarning); } } );
			else
			{
				var taskLoader:TaskLoader = new TaskLoader;
				taskLoader.container = deleteWarning;
				taskLoader.message = "Deleting canvas\n\nPlease Wait...";
				taskLoader.addEventListener(TaskLoader.TASK_COMPLETE,onDeleteComplete);
				taskLoader.wrap(deleteCanvas);
			}
		}
		
		private function deleteCanvas():void 
		{
			var index:int = int(currentCanvasSP.name);
			var i:int;
			
			var sp:Sprite;
			if (index < lastIndex)
			{
				for (i = index + 1; i < spriteList.length; i++)
				{
					sp = spriteList[i];
					sp.x -= spWidth;
					sp.rotationY = (sp.x - halfWidth) * canvasRotationFactor;
				}
			}
			else
			{
				for (i = index -1; i >= 0; i--)
				{
					sp = spriteList[i];
					sp.x += spWidth;
					sp.rotationY = (sp.x - halfWidth) * canvasRotationFactor;
				}
			}
			
			spriteList.splice(spriteList.indexOf(currentCanvasSP), 1);
			removeChild(currentCanvasSP);
			currentCanvasSP = null;
			
			for (i = 0; i < spriteList.length; i++)
			{
				spriteList[i].name = String(i);
			}
			
			currentCanvasSP = getCenterCanvas();
			
			canvasList.splice(index, 1);
			lastIndex = canvasList.length - 1;
			
			var so:SharedObject = SharedObject.getLocal("SavedCanvas", "/");
			so.clear();
			so.data.canvasList = canvasList;
			so.close();
			so = null;
			
			if (canvasList.length == 0)
			{
				deleteBtn.alpha = 0.5;
				deleteBtn.removeEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
		}
		
		private function onDeleteComplete(e:Event):void 
		{
			tween = new TweenNano(deleteWarning, 0.5, { y: -deleteWarning.height, ease:Linear.easeIn, onComplete:function():void { removeChild(deleteWarning); } } );
		}
		
		private function onNewCanvas(e:MouseEvent):void 
		{
			newCanvasMsg = new NewCanvas(onNewCanvasReturn);
			
			BackBoard.instance.addChild(newCanvasMsg);
			tempStage = stage;
		}
		
		private function onNewCanvasReturn():void 
		{
			tween = new TweenNano(newCanvasMsg, 0.5, { y: -newCanvasMsg.height, ease:Linear.easeIn, onComplete:function():void { BackBoard.instance.removeChild(newCanvasMsg); } } );
			
			if (newCanvasMsg.status == 1)
			{
				addNewCanvas();
				_exitHandler();
			}
		}
		
		public function addNewCanvas():void 
		{
			if (spriteList == null)
			{
				spriteList = new Array;
				deleteBtn.alpha = 1;
				deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
			
			var i:uint = 1; 
			var currentIndex:int = currentCanvasSP?int(currentCanvasSP.name):0;
			for each(var sp:Sprite in spriteList)
			{
				sp.x += spWidth + (currentIndex*spWidth);
				sp.rotationY = (sp.x - halfWidth) * canvasRotationFactor;
				
				sp.name = String(i);
				i++;
			}
			
			selectedIndex = 0;
			createCanvasSprite(0);
			currentCanvasSP = getCenterCanvas();
			spriteList.unshift(spriteList.pop());
			lastIndex = spriteList.length - 1; 
		}
		
		private function onDown(e:MouseEvent):void 
		{
			oldX = stage.mouseX;
			
			select = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (select && Math.abs(oldX - stage.mouseX) < 20) return;
			
			select = false;
			
			if (spriteList[0].x >= halfWidth && stage.mouseX > oldX) return;
			
			if (spriteList[lastIndex].x <= halfWidth && stage.mouseX < oldX) return;
			
			for each(var sp:Sprite in spriteList)
			{
				sp.x += stage.mouseX - oldX;
				
				if (sp.x > -spWidth && sp.x < sW + spWidth)
				{
					if (!sp.stage)
						addChild(sp);
					sp.rotationY = (sp.x - halfWidth) * canvasRotationFactor;
				}
				else
				{
					if (sp.stage)
						removeChild(sp);
					sp.rotationY = 0;
				}
			}
			oldX = stage.mouseX;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			selectIf: if (select)
			{
				if (e.target != currentCanvasSP) break selectIf;
				
				var selectedSp:Sprite = e.target as Sprite;
				setChildIndex(selectedSp,this.numChildren - 1);
				selectedSp.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				
				selectedIndex = int(selectedSp.name);
				
				tween = new TweenNano(selectedSp, 0.5, { scaleX:2, scaleY:2, ease:Strong.easeOut, onComplete:loadLayers } );
			}
			else
			{
				var newX:Number;
				var newRotY:Number;
				
				/*var sign:int = currentCanvasSP.x < halfWidth? -1:1;
				var time:Number = currentCanvasSP.x / halfWidth;
				time = time > 1? 1 - time:time;*/
				
				for each(var sp:Sprite in spriteList)
				{
					newX = spWidth * (Math.round(sp.x / spWidth));
					
					if (newX > -spWidth && newX < sW + spWidth)
					{
						newRotY = (newX - halfWidth) * canvasRotationFactor;
						tween = new TweenNano(sp, 0.5, { x:newX, rotationY:newRotY, ease:Strong.easeOut } );
					}
					else
					{
						sp.x = newX;
					}
					
					sp.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				}
				oldX = stage.mouseX;
				
				tween = new TweenNano(this, 0.5, { alpha:1, onComplete:onSnap } );
			}
			
			removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function loadLayers():void 
		{
			System.currentCanvasIndex = selectedIndex;
			
			currentCanvasSP.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			var taskLoader:TaskLoader = new TaskLoader;
			taskLoader.container = BackBoard.instance;
			taskLoader.message = "Loading layers\n\nPlease Wait...";
			taskLoader.addEventListener(TaskLoader.TASK_COMPLETE, onLoadComplete);
			taskLoader.wrap(LayerToArray.load);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			currentCanvasSP.scaleX = 1; currentCanvasSP.scaleY = 1;
			resetIndex();
			_exitHandler();
		}
		
		private function onSnap():void 
		{
			for each(var sp:Sprite in spriteList)
			{
				sp.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			}
			currentCanvasSP = getCenterCanvas();
		}
		
		private function getCenterCanvas():Sprite 
		{
			if (spriteList.length == 0) return null;
			
			for each(var sp:Sprite in spriteList)
			{
				if (sp.x == sW * 0.5)
				{
					return sp;
				}
			}
			return null;
		}
		
		public function update():void
		{
			if (!currentCanvasSP)
			{
				spriteList = new Array;
				createCanvasSprite(0);
				currentCanvasSP = spriteList[0] as Sprite;
				lastIndex = 0;
				
				deleteBtn.alpha = 1;
				deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
			else
			{
				if (deleteBtn.alpha != 1)
				{
					deleteBtn.alpha = 1;
					deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
				}
				
				var tW:int = Math.min(sW, System.canvasWidth);
				var tH:int = Math.min(sH, System.canvasWidth);
				
				var bitMap:Bitmap = currentCanvasSP.getChildAt(0) as Bitmap;
				byteArray = new ByteArray();
				byteArray.writeBytes(System.canvasList[System.currentCanvasIndex][2]);
				byteArray.uncompress();
				bitMap.bitmapData.setPixels(new Rectangle(0, 0, tW, tH), byteArray);
			}
			
			currentCanvasSP.scaleX = currentCanvasSP.scaleY = 2;
			setChildIndex(currentCanvasSP, numChildren - 1);
			tween = new TweenNano(currentCanvasSP, 1, { scaleX:1,scaleY:1, ease:Strong.easeOut,onComplete:resetIndex } );
		}
		
		public function updatePreivew():void
		{
			if (!currentCanvasSP)
			{
				spriteList = new Array;
				createCanvasSprite(0);
				currentCanvasSP = spriteList[0] as Sprite;
				lastIndex = 0;
				
				deleteBtn.alpha = 1;
				deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
			
			var tW:int = Math.min(sW, System.canvasWidth);
			var tH:int = Math.min(sH, System.canvasWidth);
			
			var bitMap:Bitmap = currentCanvasSP.getChildAt(0) as Bitmap;
			byteArray = new ByteArray();
			byteArray.writeBytes(System.canvasList[System.currentCanvasIndex][2]);
			byteArray.uncompress();
			bitMap.bitmapData.setPixels(new Rectangle(0, 0, tW, tH), byteArray);
		}
		
		private function resetIndex():void 
		{
			if (selectedIndex - 1 >= 0)
				setChildIndex(currentCanvasSP, getChildIndex(spriteList[selectedIndex - 1]) + 1);
			else
				setChildIndex(currentCanvasSP, getChildIndex(buttonGroup)+1);
		}
		
		public function redraw():void
		{
			var color2:uint = ConvertColor.changeColorComponent(CustomUI.backColor, ColorComponent.LUMINANCE, -1, 1, 0.1);
			
			graphics.clear();
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(sW,sH,0,0,0);
			graphics.beginGradientFill(GradientType.RADIAL, [CustomUI.backColor, color2], [1, 1], [0, 255],mtx);
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			var child:*;
			for (var i:int = 0; i < buttonGroup.numChildren; i++) 
			{
				child = buttonGroup.getChildAt(i);
				child.graphics.lineStyle(sW*0.001, CustomUI.color1); child.graphics.beginFill(CustomUI.color2); 
				child.graphics.drawRect( -sH * 0.0417, -sH * 0.0417, sH * 0.083, sH * 0.083); child.graphics.endFill();
				child = child.getChildAt(0);
				cT = new ColorTransform;
				cT.color = CustomUI.color1;
				child.transform.colorTransform = cT;
			}
			
			for each(var sp:Sprite in spriteList)
			{
				sp.graphics.beginFill(CustomUI.color2, 1);
				sp.graphics.drawRect(-sW * 0.25,-sH * 0.25, spWidth, sH * 0.5);
				sp.graphics.endFill();
				
				child = sp.getChildAt(1);
				child.graphics.lineStyle(sH*0.01667,CustomUI.color1,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
				child.graphics.drawRect(-sW * 0.25,-sH * 0.25, spWidth, sH * 0.5);
				child.graphics.endFill();
			}
		}
		
		private function redrawCanvasList()
		{
			if (!spriteList || spriteList.length == 0)
			{
				addLoadedCanvases();
			}
			else
			{
				for each(var canvas:Sprite in spriteList)
				{
					new TweenNano(canvas, 0.5, { alpha: 0, ease:Linear.easeIn, onComplete:function():void { removeChild(spriteList.pop()); addLoadedCanvases(); } } );
				}
			}
			
		}
		
		private function addLoadedCanvases()
		{
			if (spriteList && spriteList.length > 0) return;
			
			spriteList = new Array;
			canvasList = System.canvasList;
			lastIndex = canvasList.length-1;
			
			for (var i:int = 0; i <= lastIndex; i++)
			{
				createCanvasSprite(i);
			}
			
			currentCanvasSP = spriteList[0] as Sprite;
			byteArray = null;
			
			if (spriteList.length == 0)
			{
				deleteBtn.alpha = 0.5;
				deleteBtn.removeEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
			else if (deleteBtn.alpha != 1)
			{
				deleteBtn.alpha = 1;
				deleteBtn.addEventListener(MouseEvent.CLICK, createDeleteMsg);
			}
		}
		
		static public function get instance():OpenUI 
		{
			return _instance;
		}
	}

}