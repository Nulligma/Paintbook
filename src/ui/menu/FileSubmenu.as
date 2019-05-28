﻿package ui.menu 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenNano;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import layers.history.HistoryManager;
	import layers.save.LayerToArray;
	import layers.setups.LayerList;
	import settings.ClipBoard;
	import settings.CustomUI;
	import settings.Prefrences;
	import tools.ToolManager;
	import tools.ToolType;
	import ui.other.ImportUI;
	import ui.other.SaveAs;
	import utils.taskLoader.TaskLoader;
	import settings.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import ui.other.DrawGrid;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class FileSubmenu extends Sprite
	{
		private var sW:int;
		private var sH:int;
		private var importUI:ImportUI;
		private var tween:TweenNano;
		private var tempStage:Stage;
		private var saveAsUI:SaveAs;
		private var gridUI:DrawGrid;
		private var taskLoader:TaskLoader;
		private var cT:ColorTransform;
		
		private var _parent:Menu;
		
		private var removedMagGlass:Boolean;
		
		public function FileSubmenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if(ToolManager.activeTools.indexOf(ToolType.MAG_GLASS) != -1)
			{
				ToolManager.toggle(ToolType.MAG_GLASS);
				removedMagGlass = true;
			}
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor); 
			graphics.drawRect(0, 0, sW, sH); 
			graphics.endFill();
			
			var sp:Sprite;
			var sp2:Sprite;
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.4;
			var typeTxt:TextField;
			
			for (var i:int = 0; i <= 9; i++)
			{
				sp = new Sprite;
				sp.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
				sp.graphics.drawRect(0, 0, sW * 0.1112, sH * 0.207); sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				typeTxt = new TextField;typeTxt.embedFonts = true;
				typeTxt.defaultTextFormat = txtFormat;
				
				switch(i)
				{
					case 0:
						sp2 = new SaveIcon; typeTxt.text = "SAVE";			break;
					case 1:
						sp2 = new SaveAsIcon; typeTxt.text = "SAVE AS";	 	break;
					case 2:
						sp2 = new ImportIcon; typeTxt.text = "IMPORT";	 	break;
					case 3:
						sp2 = new DeleteIcon; typeTxt.text = "CLEAR";	 	break;
					case 4:
						sp2 = new CutIcon; typeTxt.text = "CUT";	 		break;
					case 5:
						sp2 = new CopyIcon; typeTxt.text = "COPY";	 		break;
					case 6:
						sp2 = new PasteIcon; typeTxt.text = "PASTE";	 	break;
					case 7:
						sp2 = new PanZoomIcon; typeTxt.text = "RESET";		break;
					case 8:
						sp2 = new GridIcon; typeTxt.text = "GRID";			break;
					case 9:
						sp2 = new CloseIcon; typeTxt.text = "CLOSE";		break;
				}
				
				sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
				cT = new ColorTransform;
				cT.color = CustomUI.color1;
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width * 0.5;
				sp2.y = sp.height * 0.5;
				sp.addChild(sp2);
				
				typeTxt.selectable = false;
				typeTxt.autoSize = TextFieldAutoSize.CENTER;
				typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height - typeTxt.height*1.2;
				sp.addChild(typeTxt);
				
				sp.x = ((sW/5) * int(i%5)) + sp.width/2; 
				sp.y = (sH/2 * int(i/5)) + sp.height/2;
				addChild(sp);
				
				sp.name = String(i);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, performAction);
			}
			
			var textField:TextField;
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
			sp.x = sW/2 - sp.width/2;
			sp.y = sH - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				dispatchEvent(new Event(Event.COMPLETE,true));
				
				if(removedMagGlass)
				{
					ToolManager.toggle(ToolType.MAG_GLASS);
				}
			
			});
			addChild(sp);
			
			_parent = this.parent as Menu;
			
		}
		
		private function performAction(e:MouseEvent):void 
		{
			var type:String = e.currentTarget.name as String;
			
			dispatchEvent(new Event(Event.COMPLETE,true));
			
			if(removedMagGlass)
			{
				ToolManager.toggle(ToolType.MAG_GLASS);
			}
			
			switch(type)
			{
				case "0" :
					quickSave(); 
				break;
				
				case "1" :
					saveAsMenu(); 
				break;
				
				case "2" :
					importFiles(); 
				break;
				
				case "3" :
					clear(); 
				break;
				
				case "4" :
					ClipBoard.copy(true);
				break;
				
				case "5" :
					ClipBoard.copy(false); 
				break;
				
				case "6" :
					ClipBoard.paste(); 
				break;
				
				case "7" :
					reset(); 
				break;
				
				case "8" :
					gridMenu(); 
				break;
				
				case "9" :
					closeMenu(); 
				break;
			}
		}
		
		private function reset():void
		{
			BackBoard.instance.canvasHolder.scaleX = BackBoard.instance.canvasHolder.scaleY = 1;
			BackBoard.instance.canvasHolder.x = BackBoard.instance.canvasHolder.y = 0;
		}
		
		private function clear():void 
		{
			HistoryManager.pushList();
			
			if (ToolManager.activeTools.indexOf(ToolType.CLIP) != -1)
			{
				LayerList.instance.currentLayer.fillRect(ToolManager.clipRect, 0x00000000);
			}
			else if (ToolManager.lassoMask)
			{
				LayerList.instance.currentLayer.draw(ToolManager.lassoMask,null,null,BlendMode.ERASE);
			}
			else
			{
				LayerList.instance.currentLayer.fillRect(LayerList.instance.currentLayer.rect, 0x00000000);
			}
		}
		
		private function gridMenu():void
		{
			gridUI = new DrawGrid(onGridRetrun);
			
			BackBoard.instance.addChild(gridUI);
			tempStage = stage;
		}
		
		private function onGridRetrun():void 
		{
			tween = new TweenNano(gridUI, 0.5, { y: -gridUI.height, ease:Linear.easeIn, onComplete:function():void { BackBoard.instance.removeChild(gridUI); } } );
		}
		
		private function saveAsMenu():void 
		{
			saveAsUI = new SaveAs(onSaveAsRetrun);
			
			BackBoard.instance.addChild(saveAsUI);
			tempStage = stage;
		}
		
		private function onSaveAsRetrun():void 
		{
			tween = new TweenNano(saveAsUI, 0.5, { y: -saveAsUI.height, ease:Linear.easeIn, onComplete:function():void { BackBoard.instance.removeChild(saveAsUI); } } );
		}
		
		private function importFiles():void 
		{
			importUI = new ImportUI(onImportReturn);
			
			BackBoard.instance.addChild(importUI);
			tempStage = stage;
		}
		
		private function onImportReturn():void 
		{
			tween = new TweenNano(importUI, 0.5, { y: -importUI.height, ease:Linear.easeIn, onComplete:function():void { BackBoard.instance.removeChild(importUI); } } );
		}
		
		private function closeMenu():void 
		{
			var activeClone:Array = ToolManager.activeTools.slice();
			
			for each(var tool:int in activeClone)
			{
				ToolManager.toggle(tool);
			}
			
			if (Prefrences.saveOnClose)
			{
				taskLoader = new TaskLoader;
				taskLoader.container = BackBoard.instance;
				taskLoader.message = "Saving canvas\n\nPlease Wait...";
				LayerToArray.update(taskLoader.progressUpdater);
				taskLoader.applyProgressEvent = true;
				taskLoader.addEventListener(TaskLoader.TASK_COMPLETE,onTaskComplete);
				taskLoader.wrap(LayerToArray.save);
			}
			else
			{
				HistoryManager.flush();
				_parent.exitHandler();
			}
			
		}
		
		private function onTaskComplete(e:Event):void 
		{
			HistoryManager.flush();
			_parent.exitHandler();
		}
		
		private function quickSave():void 
		{
			taskLoader = new TaskLoader;
			taskLoader.container = BackBoard.instance;
			taskLoader.message = "Saving canvas\n\nPlease Wait...";
			LayerToArray.update(taskLoader.progressUpdater);
			taskLoader.applyProgressEvent = true;
			
			taskLoader.wrap(LayerToArray.save);
		}
		
	}

}