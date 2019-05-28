package ui.menu 
{
	import com.greensock.easing.*;
	import com.greensock.TweenNano;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.history.HistoryManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import settings.CustomUI;
	import settings.Prefrences;
	import settings.System;
	import flash.geom.ColorTransform;
	import ui.other.MenuSettings;
	import flash.utils.getDefinitionByName;
	import tools.brushes.PresetInterface;
	import tools.brushes.BrushData;
	import layers.setups.LayerList;
	import tools.ToolManager;
	import tools.ToolType;
	import layers.setups.LayerSetup;
	import tools.brushes.BrushSettings;
	import tools.eraser.EraserSettings;
	import tools.spray.SpraySettings;
	import tools.blur.BlurSettings;
	import tools.smudge.SmudgeSettings;
	import tools.shape.ShapeSettings;
	import tools.text.TextSettings;
	import colors.setups.ColorSetup;
	import tools.line.LineSettings;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Menu extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var tween:TweenNano;
		private var txtFormat:TextFormat;
		
		private var fileSubMenu:FileSubmenu;
		private var colorSubMenu:ColorSubmenu;
		private var layerSubMenu:LayerSubmenu;
		private var toolSubMenu:ToolSubmenu;
		private var panZoomMenu:PanZoom;
		private var hexSubMenu:HexSubmenu;
		private var swatchSubMenu:SwatchesSubmenu;
		
		private var brush:BrushData = BrushData.instance;
		
		private var layerSetup:LayerSetup;
		private var toolSettings:*;
		private var colorSetup:ColorSetup;
		
		private var toolBtn:Sprite;
		private var layerBtn:Sprite;
		private var panZoomBtn:Sprite;
		private var colorsBtn:Sprite;
		private var brushesBtn:Sprite;
		private var hexBtn:Sprite;
		private var swatchBtn:Sprite;
		
		private var totalBtns:uint;
		
		private var layer1:Object;
		private var layer2:Object;
		
		private var holder:Sprite;
		private var activeSubMenu:Sprite;
		private var prevSubMenu:Sprite;
		private var _exitHandler:Function;

		private var presets:PresetInterface;
		
		private var customSlider:CustomSlider;
		
		public function Menu(exitHandler:Function)
		{
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			if(MenuSettings.currentMenu == null) defaultInit();
			else 								 customInit();
		}
		
		private function defaultInit():void
		{
			var sp:Sprite;
			var typeTxt:TextField;
			
			var sp2:Sprite;
			var cT:ColorTransform;
			
			totalBtns = 6;
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN,tweenOut);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.MOUSE_DOWN, updateMenus);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.CLICK, updateMenus);
			
			holder = new Sprite;
			
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			
			for (var i:int = 0; i < 6; i++)
			{
				sp = new Sprite;
				sp.graphics.lineStyle(sW*0.0034,CustomUI.color2); sp.graphics.beginFill(CustomUI.backColor); 
				sp.graphics.drawRect(0, 0, sW*0.08, sH/6); sp.graphics.endFill();
				
				if (i == 0) { sp2 = new FileIcon; sp.addEventListener(MouseEvent.CLICK, createFileMenu); }
				if (i == 1) { sp2 = new LayerIcon; sp.addEventListener(MouseEvent.CLICK, createLayerMenu); layerBtn=sp; }
				if (i == 2) { sp2 = new ToolsIcon; sp.addEventListener(MouseEvent.CLICK, createToolsMenu); toolBtn=sp;  }
				if (i == 3) { sp2 = new PanZoomIcon; sp.addEventListener(MouseEvent.CLICK, createPanZoomMenu); panZoomBtn=sp; }
				if (i == 4) { sp2 = new UndoIcon; sp.addEventListener(MouseEvent.MOUSE_DOWN, performUndo); }
				if (i == 5) { sp2 = new RedoIcon; sp.addEventListener(MouseEvent.MOUSE_DOWN, performRedo); }
				
				sp2.width = sp2.height = (sW * 0.08 / 1.5);
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width / 2;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
			
				sp.x = 0; sp.y = i*sH/6;
				holder.addChild(sp);
			}
			addChild(holder);
			var dropShadow:DropShadowFilter = new DropShadowFilter;
			dropShadow.angle = 0; dropShadow.quality = 3; dropShadow.strength = 0.5;
			dropShadow.distance = 7;
			
			if(!MenuSettings.ON_LEFT)
			{
				dropShadow.angle = 180;
				holder.x = sW;
			}
			else
			{
				dropShadow.angle = 0;
				holder.x = -holder.width;
			}
			holder.filters = [dropShadow];
			
			if (!Prefrences.hideMenu)
			{
				tweenIn();
			}
			
			//stage.addEventListener(MouseEvent.MIDDLE_CLICK, tweenIn);
		}
		
		private function customInit():void
		{
			var sp:Sprite;
			var typeTxt:TextField;
			
			var sp2:Sprite;
			var cT:ColorTransform;
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN,tweenOut);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.MOUSE_DOWN, updateMenus);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.CLICK, updateMenus);
			
			holder = new Sprite;
			
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			
			var menuList:Array = MenuSettings.currentMenu;
			var menuBtns:uint = menuList.length;
			var c:Class;
			
			totalBtns = menuBtns;
			
			for (var i:int = 0; i < menuBtns; i++)
			{
				sp = new Sprite;
				sp.name = menuList[i];
				sp.graphics.lineStyle(sW*0.0034,CustomUI.color2); sp.graphics.beginFill(CustomUI.backColor); 
				sp.graphics.drawRect(0, 0, sW*0.08, sH/menuBtns); sp.graphics.endFill();
				
				try
				{
					c = getDefinitionByName(menuList[i]+"Icon") as Class;
				
					sp2 = new c;
					
					sp2.width = sp2.height = (sW * 0.08 / 1.5);
					cT = new ColorTransform;
					cT.color = CustomUI.color1;
					sp2.transform.colorTransform = cT;
					sp2.x = sp.width * 0.5;
					sp2.y = sp.height * 0.5;
					sp.addChild(sp2);
					
					if(menuList[i] == "BrushTool")
					{
						toggleButton(sp,true);
					}
				}
				catch(e:*)
				{
					var symbolTxt:TextField = new TextField;symbolTxt.embedFonts = true;
					txtFormat.size = sH * 0.083 * 0.6;
					symbolTxt.defaultTextFormat = txtFormat;
					symbolTxt.text = menuList[i];
					
					symbolTxt.selectable = false; 
					symbolTxt.autoSize = TextFieldAutoSize.CENTER;
					symbolTxt.x = sp.width / 2 - symbolTxt.width / 2; symbolTxt.y = sp.height/2 - symbolTxt.height*0.5;
					sp.addChild(symbolTxt);
				}
				sp.addEventListener(MouseEvent.CLICK,customButtonPress);
				sp.x = 0; sp.y = i*sH/menuBtns;
				holder.addChild(sp);
			}
			
			
			addChild(holder);
			var dropShadow:DropShadowFilter = new DropShadowFilter;
			dropShadow.angle = 0; dropShadow.quality = 3; dropShadow.strength = 0.5;
			dropShadow.distance = 7;
			
			if(!MenuSettings.ON_LEFT)
			{
				dropShadow.angle = 180;
				holder.x = sW;
			}
			else
			{
				dropShadow.angle = 0;
				holder.x = -holder.width;
			}
			holder.filters = [dropShadow];
			
			
			if (!Prefrences.hideMenu)
			{
				tweenIn();
			}
			
		}
		
		private function customButtonPress(e:MouseEvent):void
		{
			var btnName:String = e.currentTarget.name;
			var sp:Sprite = e.currentTarget as Sprite;
			if(btnName == "File" || btnName == "Tools" || btnName == "Layer" || btnName == "PanZoom" || btnName == "Colors" || btnName == "Brushes" ||btnName == "#"||btnName == "Swatch")
			{
				switch(btnName)
				{
					case "Tools": 	toolBtn = sp; 		break;
					case "Layer": 	layerBtn = sp; 		break;
					case "PanZoom": panZoomBtn = sp; 	break;
					case "Colors": 	colorsBtn = sp; 	break;
					case "Brushes": brushesBtn = sp; 	break;
					case "Swatch": 	swatchBtn = sp; 	break;
					case "#":		hexBtn = sp;btnName="Hex";		break;
				}
				var functionName:String = "create"+btnName+"Menu";
				this[functionName](null);
			}
			else if(btnName == "Si"||btnName == "Fl"||btnName == "Sm"||btnName == "Sp"||btnName == "BOp"||btnName == "LOp")
			{
				switch(btnName){
				case "Si":	customSlider = new CustomSlider("Brush Size", brush.size, 1, BrushData.MAX_SIZE);	break;
				case "Fl":	customSlider = new CustomSlider("Brush flow", brush.flow*100, 0, 100);				break;
				case "Sm":	customSlider = new CustomSlider("Smoothness", brush.smoothness, 0, 10);				break;
				case "Sp":	customSlider = new CustomSlider("Spacing in pattern", brush.spacing, 1, 100);		break;
				case "BOp":	customSlider = new CustomSlider("Brush opacity", brush.alpha*100, 0, 100);			break;
				case "LOp": customSlider = new CustomSlider("Layer Opacity", LayerList.instance.currentLayerObject.bitmap.alpha*100, 0, 100);
				}
				customSlider.name = btnName;
				this.addChild(customSlider);
				customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			}
			else if(btnName == "BlurTool"||btnName == "EraseTool"||btnName == "SprayPaint"||btnName == "BrushTool"||btnName == "FreeTrans"||btnName == "SmudgeTool"||btnName == "BucketTool"||btnName == "ShapeTool"||btnName == "MoveLayer"||btnName == "ClipTool"||btnName == "MagGlass"||btnName == "ColorPicker"||btnName == "CurveTool"||btnName == "TextTool"||btnName == "LassoTool")
			{
				checkAllTools(btnName);
				
				var tN:int;
				tN = ToolType.getToolNumber(btnName);
				ToolManager.toggle(tN);
				
				toggleButton(sp,sp.alpha == 1);
			}
			else if(btnName == "ToolSwitcher")
			{
				var tN1:int = ToolType.getToolNumber(MenuSettings.option1);
				var tN2:int = ToolType.getToolNumber(MenuSettings.option2);
				
				if(sp.alpha == 1)
				{
					ToolManager.toggle(tN1);
					toggleButton(sp,true);
				}
				else
				{
					ToolManager.toggle(tN2);
					toggleButton(sp,false);
				}
				
			}
			else if(btnName == "LayerSwitcher")
			{
				if(layer1 == null || layer1 != LayerList.instance.getLayerByName(layer1.name) || layer2 == null || layer2 != LayerList.instance.getLayerByName(layer2.name))
				{
					layer1 = null; layer2 = null;
					layer1 = LayerList.instance.currentLayerObject;
					LayerList.instance.initNewLayer(System.canvasWidth, System.canvasHeight);
					layer2 = LayerList.instance.currentLayerObject;
					System.updateCanvas();
					
					toggleButton(sp,true);
				}
				else
				{
					if(sp.alpha<1)
					{LayerList.instance.currentLayerObject = layer1;	toggleButton(sp,false);}
					else
					{LayerList.instance.currentLayerObject = layer2;	toggleButton(sp,true);}
				}
				
			}
			else if(btnName == "Plus"||btnName == "CopyLayer"||btnName == "Merge"||btnName == "Delete"||btnName == "Visible")
			{
				var layerList:LayerList = LayerList.instance;
				var selectedLayer:Object = layerList.currentLayer;
				
				switch(btnName)
				{
					case "Plus": 
						layerList.initNewLayer(System.canvasWidth, System.canvasHeight);
					break;
					case "Delete":
						layerList.deleteLayer(selectedLayer);
						HistoryManager.flush();
						ToolManager.workArea(System.canvas, layerList.currentLayer);
					break;
					case "CopyLayer":
						layerList.initNewLayer(selectedLayer.bitmap.bitmapData.width, selectedLayer.bitmap.bitmapData.height, true, selectedLayer.bitmap.bitmapData);
						ToolManager.workArea(System.canvas, layerList.currentLayer);
					break;
					case "Merge":
						layerList.deleteLayer(selectedLayer, true);
						ToolManager.workArea(System.canvas, layerList.currentLayer);
						HistoryManager.flush();
					break;
					case "Visible":
						selectedLayer.bitmap.visible = !selectedLayer.bitmap.visible;
						toggleButton(sp,selectedLayer.bitmap.visible);
					break;
				}
				System.updateCanvas();
			}
			else if(btnName == "TS"||btnName == "LS"||btnName == "More"||btnName == "Undo"||btnName == "Redo")
			{
				switch(btnName)
				{
					case "TS":		createToolSetting();	break;
					case "LS":		createLayerSetup();		break;
					case "More":	createColorSettings();	break;
					case "Undo":	performUndo(null);		break;
					case "Redo":	performRedo(null);		break;
				}
			}
		}
		
		private function createToolSetting():void 
		{
			switch(ToolManager.currentSingleActive)
			{
				case ToolType.BRUSH:
					toolSettings = new BrushSettings();
				break;
				
				case ToolType.ERASER:
					toolSettings = new EraserSettings();
				break;
				
				case ToolType.SPRAY:
					toolSettings = new SpraySettings();
				break;
				
				case ToolType.BLUR:
					toolSettings = new BlurSettings();
				break;
				
				case ToolType.SMUDGE:
					toolSettings = new SmudgeSettings();
				break;
				
				case ToolType.SHAPE:
					toolSettings = new ShapeSettings();
				break;
				
				case ToolType.LINE:
					toolSettings = new LineSettings();
				break;
				
				case ToolType.TEXT:
					toolSettings = new TextSettings();
				break;
			}
			BackBoard.instance.addChild(toolSettings);
		}
		
		private function createLayerSetup():void 
		{
			layerSetup = new LayerSetup(returnLayerSetup);
			BackBoard.instance.addChild(layerSetup);
		}
		
		private function returnLayerSetup():void 
		{
			BackBoard.instance.removeChild(layerSetup);
		}
		
		private function createColorSettings():void
		{
			colorSetup = new ColorSetup(ToolManager.fillColor, setColor);
			BackBoard.instance.addChild(colorSetup);
		}
		
		private function setColor():void 
		{
			ToolManager.fillColor = colorSetup.color;
			BackBoard.instance.removeChild(colorSetup);
			colorSetup = null;
		}
		
		private function checkAllTools(exception:String):void
		{
			var sp:Sprite;
			var tN:int;
			for(var i:int = 0;i<holder.numChildren;i++)
			{
				sp = holder.getChildAt(i) as Sprite;
				
				tN = ToolType.getToolNumber(sp.name);
				if(ToolType.multiActive.indexOf(tN) != -1 || sp.alpha == 1 || sp.name == exception) continue;
				
				//ToolManager.toggle(tN);
				toggleButton(sp,false);
			}
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			switch(e.currentTarget.name)
			{
				case "Si":		brush.size = customSlider.value;		break;
				case "Fl":		brush.flow = customSlider.value/100;	break;
				case "Sm":		brush.smoothness = customSlider.value;	break;
				case "Sp":		brush.spacing = customSlider.value;		break;
				case "BOp":		brush.alpha = customSlider.value / 100;	break;
				case "LOp":		LayerList.instance.currentLayerObject.bitmap.alpha = customSlider.value / 100;	break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		
		private function createFileMenu(e:MouseEvent):void 
		{
			/*if (activeSubMenu)
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut } );
				if (activeSubMenu == fileSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (fileSubMenu==null)
			{
				fileSubMenu = new FileSubmenu;
				addChild(fileSubMenu);
				swapChildren(fileSubMenu, holder);
			}
			else
				swapChildren(fileSubMenu, activeSubMenu);
			
			TweenNano.to(fileSubMenu, 0.5, { y:sH * 0.082, ease:Strong.easeOut } );
			
			activeSubMenu = fileSubMenu;*/
			
			fileSubMenu = new FileSubmenu;
			fileSubMenu.x=0;fileSubMenu.y=0;
			fileSubMenu.addEventListener(Event.COMPLETE,function(e:Event):void{
				removeChild(fileSubMenu);
			});
			addChild(fileSubMenu);
		}
		
		private function createToolsMenu(e:MouseEvent):void 
		{
			if (toolSubMenu==null)
			{
				toolSubMenu = new ToolSubmenu;
				addChild(toolSubMenu);
				swapChildren(toolSubMenu, holder);
			}
			
			if(MenuSettings.ON_LEFT)
			{
				if(toolBtn.alpha == 1)
				{
					toggleButton(toolBtn,true);
					toolSubMenu.x = -toolSubMenu.width;
					TweenNano.to(toolSubMenu, 0.5, { x:sW * 0.08, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(toolBtn,false);
					TweenNano.to(toolSubMenu, 1, { x:-toolSubMenu.width, ease:Strong.easeOut} );
				}
			}
			else
			{
				if(toolBtn.alpha == 1)
				{
					toggleButton(toolBtn,true);
					toolSubMenu.x = sW;
					TweenNano.to(toolSubMenu, 0.5, { x:(sW*0.92) - toolSubMenu.width, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(toolBtn,false);
					TweenNano.to(toolSubMenu, 1, { x:sW, ease:Strong.easeOut} ); 
				}
			}
			
			//activeSubMenu = toolSubMenu;
		}
		
		private function createLayerMenu(e:MouseEvent):void 
		{
			if (layerSubMenu && layerSubMenu.y>=0) 
			{
				toggleButton(layerBtn,false);
				TweenNano.to(layerSubMenu, 1, { y:-layerSubMenu.height, ease:Strong.easeOut} );return;
				
				//if (activeSubMenu == layerSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (layerSubMenu==null)
			{
				layerSubMenu = new LayerSubmenu();
				if(MenuSettings.ON_LEFT)
					layerSubMenu.x = sW*0.6;
				else
					layerSubMenu.x = 0;
				layerSubMenu.y = -layerSubMenu.height;
				addChild(layerSubMenu);
				//swapChildren(layerSubMenu, holder);
			}
			else
			{
				layerSubMenu.update();
			}
			
			toggleButton(layerBtn,true);
			
			TweenNano.to(layerSubMenu, 0.5, { y:0, ease:Strong.easeOut } );
		}
		
		private function createPanZoomMenu(e:MouseEvent):void
		{
			if(panZoomMenu == null)
			{
				panZoomMenu = new PanZoom();
				if(MenuSettings.ON_LEFT)
					panZoomMenu.x = sW*0.75;
				else
					panZoomMenu.x = sW*0.25;
				panZoomMenu.y = sH*0.5;
			}
			
			if(panZoomMenu.stage)
			{
				removeChild(panZoomMenu);
				toggleButton(panZoomBtn,false);
			
			}
			else
			{
				addChild(panZoomMenu);
				toggleButton(panZoomBtn,true);
			
			}
			
		}
		
		private function createColorsMenu(e:MouseEvent):void 
		{
			if (colorSubMenu==null)
			{
				colorSubMenu = new ColorSubmenu;
				addChild(colorSubMenu);
				swapChildren(colorSubMenu, holder);
			}
			
			if(MenuSettings.ON_LEFT)
			{
				if(colorsBtn.alpha == 1)
				{
					toggleButton(colorsBtn,true);
					colorSubMenu.x = -colorSubMenu.width;
					TweenNano.to(colorSubMenu, 0.5, { x:sW * 0.08, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(colorsBtn,false);
					TweenNano.to(colorSubMenu, 1, { x:-colorSubMenu.width, ease:Strong.easeOut} );
				}
			}
			else
			{
				if(colorsBtn.alpha == 1)
				{
					toggleButton(colorsBtn,true);
					colorSubMenu.x = sW;
					TweenNano.to(colorSubMenu, 0.5, { x:(sW*0.92) - colorSubMenu.width, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(colorsBtn,false);
					TweenNano.to(colorSubMenu, 1, { x:sW, ease:Strong.easeOut} ); 
				}
			}
		}
		private function createHexMenu(e:MouseEvent):void 
		{
			if (hexSubMenu==null)
			{
				hexSubMenu = new HexSubmenu;
				addChild(hexSubMenu);
				swapChildren(hexSubMenu, holder);
			}
			
			if(MenuSettings.ON_LEFT)
			{
				if(hexBtn.alpha == 1)
				{
					toggleButton(hexBtn,true);
					hexSubMenu.x = -hexSubMenu.width;
					TweenNano.to(hexSubMenu, 0.5, { x:sW * 0.08, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(hexBtn,false);
					TweenNano.to(hexSubMenu, 1, { x:-hexSubMenu.width, ease:Strong.easeOut} );
				}
			}
			else
			{
				if(hexBtn.alpha == 1)
				{
					toggleButton(hexBtn,true);
					hexSubMenu.x = sW;
					TweenNano.to(hexSubMenu, 0.5, { x:(sW*0.92) - hexSubMenu.width, ease:Strong.easeOut } );
				}
				else
				{
					toggleButton(hexBtn,false);
					TweenNano.to(hexSubMenu, 1, { x:sW, ease:Strong.easeOut} ); 
				}
			}
		}
		
		private function createBrushesMenu(e:MouseEvent):void
		{
			if(presets == null)
			{
				presets = new PresetInterface();
				if(MenuSettings.ON_LEFT)
					presets.x = sW*0.08;
				else
					presets.x = sW*0.92 - presets.width;
				presets.y = sW*0.2;
			}
			
			if(presets.stage)
			{
				toggleButton(brushesBtn,false);
				removeChild(presets);
			}
			else
			{
				toggleButton(brushesBtn,true);
				addChild(presets);
				swapChildren(presets, holder);
			}
		}
		
		private function createSwatchMenu(e:MouseEvent):void
		{
			if(swatchSubMenu == null)
			{
				swatchSubMenu = new SwatchesSubmenu();
				if(MenuSettings.ON_LEFT)
					swatchSubMenu.x = sW*0.08;
				else
					swatchSubMenu.x = sW*0.92 - swatchSubMenu.width;
			}
			
			if(swatchSubMenu.stage)
			{
				toggleButton(swatchBtn,false);
				removeChild(swatchSubMenu);
			}
			else
			{
				toggleButton(swatchBtn,true);
				addChild(swatchSubMenu);
				swapChildren(swatchSubMenu, holder);
			}
		}
		
		private function toggleButton(btn:Sprite,onState:Boolean):void
		{
			var bgColor:uint;
			var lineColor:uint;
			var iconColor:uint;
			
			if(onState)
			{
				btn.alpha = 0.99;
			}
			else
			{
				btn.alpha = 1;
			}
			
			if(onState)
			{
				bgColor = CustomUI.color1;
				lineColor = CustomUI.color2;
				iconColor = CustomUI.color2;
			}
			else
			{
				bgColor = CustomUI.backColor;
				lineColor = CustomUI.color2;
				iconColor = CustomUI.color1;
			}
			
			if(btn.getChildAt(0) is Sprite)
			{
				var icon:Sprite = btn.getChildAt(0) as Sprite;
				
				var cT:ColorTransform = new ColorTransform;
				cT.color = iconColor;
				
				icon.transform.colorTransform = cT;
			}
			else if(btn.getChildAt(0) is TextField)
			{
				var tF:TextFormat = new TextFormat;
				tF.font = CustomUI.font;
				
				var symbolTxt:TextField = btn.getChildAt(0) as TextField;
				tF.color = iconColor;
				symbolTxt.defaultTextFormat = tF;
				symbolTxt.text = symbolTxt.text;
			}
			
			btn.graphics.clear();
				
			btn.graphics.lineStyle(sW*0.0034,lineColor); btn.graphics.beginFill(bgColor); 
			btn.graphics.drawRect(0, 0, sW*0.08, sH/totalBtns); btn.graphics.endFill();
		}
		
		private function performUndo(e:MouseEvent):void 
		{
			HistoryManager.undo();
			
			if (layerSubMenu && layerSubMenu.y>=0)
				layerSubMenu.update();
		}
		
		private function performRedo(e:MouseEvent):void 
		{
			HistoryManager.redo();
			
			if (layerSubMenu && layerSubMenu.y>=0)
				layerSubMenu.update();
		}
		
		private function tweenOut(e:MouseEvent = null):void
		{
			/*if (activeSubMenu is ToolSubmenu && mouseY < sH * 0.6) return
			else if (mouseY < sH * 0.3) return;
			
			if (!Prefrences.hideMenu && activeSubMenu && mouseY > sH * 0.167)
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut,onComplete:removeAllSubmenu } );
			}
			else if (Prefrences.hideMenu)
			{
				if (activeSubMenu && mouseY < sH * 0.167)
				{
					return;
				}
				removeAllSubmenu();
				TweenNano.to(holder, 0.5, { y: -sH * 0.086, ease:Strong.easeOut } );
				TweenNano.to(drawerLine, 0.5, { y:-sH*0.086, ease:Strong.easeOut} );
			}*/
		}
		
		private function tweenIn(event:MouseEvent = null):void
		{
			//if (holder.y == 0) return;
			
			if(MenuSettings.ON_LEFT)
				TweenNano.to(holder, 0.5, { x:0, ease:Strong.easeOut } );
			else
				TweenNano.to(holder, 0.5, { x:sW-holder.width, ease:Strong.easeOut } );
			//TweenNano.to(drawerLine, 0.5, { y:0, ease:Strong.easeOut } );
		}
		
		private function removeAllSubmenu():void 
		{
			if (fileSubMenu && fileSubMenu.stage) 
			{
				removeChild(fileSubMenu);
				fileSubMenu = null;
			}
			if (colorSubMenu && colorSubMenu.stage) 
			{
				removeChild(colorSubMenu);
				colorSubMenu = null;
			}
			if (layerSubMenu && layerSubMenu.stage) 
			{
				removeChild(layerSubMenu);
				layerSubMenu = null;
			}
			if (toolSubMenu && toolSubMenu.stage) 
			{
				removeChild(toolSubMenu);
				toolSubMenu = null;
			}
		}
		
		private function updateMenus(event:MouseEvent):void
		{
			if(toolSubMenu && toolSubMenu.x>=0)
			{
				toolSubMenu.update(event.type);
			}
			
			if (layerSubMenu && layerSubMenu.y>=0 && event.type == MouseEvent.CLICK)
			{
				layerSubMenu.update();
			}
			
			if (colorSubMenu && event.type == MouseEvent.MOUSE_DOWN)
			{
				colorSubMenu.updateColorArray();
			}
			
			if (hexSubMenu && event.type == MouseEvent.MOUSE_DOWN)
			{
				hexSubMenu.update();
			}
		}
		
		public function deactivateTweenOut():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, tweenOut );
		}
		
		public function activeTweenOut():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, tweenOut );
		}
		
		public function redraw()
		{
			var child:*;
			for (var i:int = 0; i < 5; i++)
			{
				child = holder.getChildAt(i);
				
				child.graphics.lineStyle(sW*0.003,CustomUI.color2); child.graphics.beginFill(CustomUI.color1); 
				child.graphics.drawRect(0, 0, sW * 0.1995, sH * 0.083); child.graphics.endFill();
				
				txtFormat.font = CustomUI.font;
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				child = child.getChildAt(0);
				child.setTextFormat(txtFormat);
			}
		}
		
		public function get exitHandler():Function 
		{
			return _exitHandler;
		}
	}
}