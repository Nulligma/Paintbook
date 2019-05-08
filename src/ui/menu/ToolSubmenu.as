package ui.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.setups.LayerList;
	import settings.CustomUI;
	import settings.System;
	import tools.blur.BlurSettings;
	import tools.brushes.BrushSettings;
	import tools.brushes.PresetInterface;
	import tools.eraser.EraserSettings;
	import tools.line.LineSettings;
	import tools.shape.ShapeSettings;
	import tools.smudge.SmudgeSettings;
	import tools.spray.SpraySettings;
	import tools.text.TextSettings;
	import tools.ToolManager;
	import tools.ToolType;
	import colors.setups.ColorSetup;
	import flash.display.Bitmap;
	import colors.spectrums.Spectrum;
	import colors.convertor.ConvertColor;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ToolSubmenu extends Sprite
	{
		private const COLOR_HISTORY:int = 16;
		
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		
		private var prevToolSprite:Sprite;
		private var toolHolder:Sprite;
		private var drawerLine:Sprite;
		private var toolSettings:Sprite;
		private var settingsCover:Sprite;
		
		private var customSlider:CustomSlider;
		private var settingIcon:Sprite;
		
		private var presets:PresetInterface;
		
		private var colorsArray:Array;
		private var colorsSprites:Array;
		private var spectrum:Bitmap;
		private var gradient:Bitmap;
		
		private var _oldColor:uint;
		private var _newColor:uint;
		
		private var spectrumHolder:Sprite;
		private var colorsHolder:Sprite;
		private var c1Sprite:Sprite;
		private var c2Sprite:Sprite;
		
		private var recentColorBtn:Sprite;
		private var spectrumBtn:Sprite;
		
		private var pressed:Boolean;
		
		private var colorSetup:ColorSetup;
		
		public function ToolSubmenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if(ToolManager.activeTools.indexOf(ToolType.MAG_GLASS) == -1)
			{
				ToolManager.toggle(ToolType.MAG_GLASS);
			}
			
			var sp1:Sprite, sp2:Sprite;
			var typeTxt:TextField;
			var cT:ColorTransform;
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			graphics.beginFill(CustomUI.color2); graphics.drawRect(0, 0, sW*0.32, sH); graphics.endFill();
			
			toolHolder = new Sprite();
			
			for (var i:int = 0; i < ToolType.TOTAL_TOOLS; i++)
			{
				sp1 = new Sprite;
				sp1.name = String(i);
				
				if (ToolManager.activeTools.indexOf(i)!=-1)
				{
					drawIconOn(sp1, true);
					prevToolSprite = sp1;
				}
				else
					drawIconOn(sp1, false);
				
				sp1.x = (sW * 0.08 * int(i%4));
				sp1.y = sH*0.1 * int(i/4);
				toolHolder.addChild(sp1);
				sp1.addEventListener(MouseEvent.CLICK, changeTool);
			}
			
			addChild(toolHolder);
			//toolHolder.x = sW * 0.25;
			toolHolder.x = 0;
			//toolHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { toolHolder.startDrag(false, new Rectangle(sW - toolHolder.width, 0, toolHolder.width -sW * 0.75, 0)); } );
			//stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { toolHolder.stopDrag() } );
			
			if(ToolManager.activeTools.indexOf(ToolType.BRUSH) != -1 && presets == null)
			{
				presets = new PresetInterface();
				presets.x = sW*0.32;
				presets.y = sW*0.2;
				presets.addEventListener(Event.CHANGE,updateSize);
				this.addChild(presets);
			}
			
			settingIcon = new Sprite;
			settingIcon.graphics.lineStyle(sW * 0.001, CustomUI.color1); settingIcon.graphics.beginFill(CustomUI.backColor); 
			settingIcon.graphics.drawRect(0, 0, sW * 0.16, sH * 0.1); settingIcon.graphics.endFill();
			
			sp2 = new SettingsIcon;
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = settingIcon.width / 2;
			sp2.y = settingIcon.height / 2;
			settingIcon.addChild(sp2);
			settingIcon.y = sH*0.4;
			addChild(settingIcon);
			settingIcon.addEventListener(MouseEvent.CLICK, createToolSetting);
			
			sp1 = new Sprite();
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.backColor); 
			sp1.graphics.drawRect(0, 0, sW * 0.16, sH * 0.1); sp1.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = "SIZE";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp1.width / 2 - typeTxt.width / 2; typeTxt.y = sp1.height / 2 - typeTxt.height / 2;
			sp1.addChild(typeTxt);
			addChild(sp1);
			sp1.x = sW * 0.16;
			sp1.y = sH*0.4;
			sp1.addEventListener(MouseEvent.CLICK, changeSize);
			
			settingsCover = new Sprite();
			settingsCover.graphics.lineStyle(sW * 0.001, CustomUI.color1);
			settingsCover.graphics.beginFill(CustomUI.color2);
			settingsCover.graphics.drawRect(0, 0, sW*0.32, sH * 0.1);
			settingsCover.y = sH*0.4;
			settingsCover.graphics.endFill();
			
			if (ToolManager.activeTools.length == 0 || ToolManager.currentToolProp == null)
				addChild(settingsCover);
			
			colorsHolder = new Sprite();
			
			colorsArray = new Array();
			colorsSprites = new Array();
			for (i = 0; i < COLOR_HISTORY; i++)
			{
				colorsArray.push(0);
				
				sp1 = new Sprite;
				sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1);
				sp1.graphics.beginFill(colorsArray[i]);
				sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
				sp1.name = String(i);
				
				sp1.x = (sW * 0.08 * int(i%4));
				sp1.y = sH*0.1 * int(i/4);
				colorsHolder.addChild(sp1);
				sp1.addEventListener(MouseEvent.CLICK, setColor);
				colorsSprites.push(sp1);
			}
			
			colorsHolder.y = sH*0.5;
			//addChild(colorsHolder);
			
			spectrumHolder = new Sprite();
			spectrumHolder.addEventListener(MouseEvent.MOUSE_DOWN, onSpectrumPressed);
			
			spectrum = Spectrum.smallGradientLinear;
			spectrum.x = sW*0.32 - spectrum.width;
			spectrum.y = sH*0.5;
			spectrumHolder.addChild(spectrum);
			
			addChild(spectrumHolder);
			
			c1Sprite = new Sprite;
			c1Sprite.graphics.beginFill(ToolManager.fillColor); c1Sprite.graphics.drawRect(0, 0, sW*0.08, sH * 0.1);
			c1Sprite.x = c1Sprite.width*2;
			c1Sprite.y = sH-c1Sprite.height;
			addChild(c1Sprite);
			
			c2Sprite = new Sprite;
			c2Sprite.graphics.beginFill(ToolManager.fillColor); c2Sprite.graphics.drawRect(0, 0, sW*0.08, sH * 0.1); c2Sprite.graphics.endFill();
			c2Sprite.x = c2Sprite.width*3;
			c2Sprite.y = sH-c2Sprite.height;
			addChild(c2Sprite);
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.backColor); 
			sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
			sp2 = new MoreIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			sp1.y = sH-sp1.height;
			addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { colorSetup = new ColorSetup(ToolManager.fillColor, setColor); BackBoard.instance.addChild(colorSetup);} );
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.backColor); 
			sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
			sp2 = new RecentColorIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			sp1.x=sp1.width;
			sp1.y = sH-sp1.height;
			addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK,changeColorSelector);
			recentColorBtn = sp1;
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.backColor); 
			sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
			sp2 = new SpectrumIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			sp1.x=sp1.width;
			sp1.y = sH-sp1.height;
			//addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK,changeColorSelector);
			spectrumBtn = sp1;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			//var dropShadow:DropShadowFilter = new DropShadowFilter;
			///dropShadow.angle = 0; dropShadow.quality = 3;
			//sp1.filters = [dropShadow];
			
			//drawerLine = new Sprite;
			//drawerLine.graphics.lineStyle(sW * 0.0025, CustomUI.color1);
			//drawerLine.graphics.moveTo(0, sH * 0.207); drawerLine.graphics.lineTo(sW, sH * 0.207);
			//addChild(drawerLine);
			
			createGradient();
		}
		
		private function changeColorSelector(e:MouseEvent):void
		{
			if(spectrumBtn.stage)
			{
				removeChild(spectrumBtn);
				removeChild(colorsHolder);
				
				addChild(recentColorBtn);
				addChild(spectrumHolder);
			}
			else if(recentColorBtn.stage)
			{
				removeChild(recentColorBtn);
				removeChild(spectrumHolder);
				
				addChild(spectrumBtn);
				addChild(colorsHolder);
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			if (pressed)
			{
				pressed = false;
				spectrumHolder.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		private function onMove(e:MouseEvent):void 
		{
			if (pressed)
			{
				if(this.mouseX>sW*0.08)
				{
					_newColor =  uint("0x" + spectrum.bitmapData.getPixel(spectrum.mouseX, spectrum.mouseY).toString(16));
					createGradient();
				}
				else
				{
					_newColor = uint("0x" + gradient.bitmapData.getPixel(gradient.mouseX, gradient.mouseY).toString(16));
				}
				ToolManager.fillColor = _newColor;
				update_NewColor_Sprite();
			}
		}
		
		private function onSpectrumPressed(e:MouseEvent):void
		{
			pressed = true;
			spectrumHolder.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function createGradient():void 
		{
			if(gradient == null)
			{
				gradient = new Bitmap;
				gradient.bitmapData = new BitmapData(60, 800, false, 0x000000);
				
				gradient.width = sW*0.08;
				gradient.height = sH*0.4;
				gradient.x = 0;
				gradient.y = sH * 0.5;
				
				spectrumHolder.addChild(gradient);
			}
			
			var tempColor:uint;
			var rgb:Object = ConvertColor.HexToRGB(_newColor);
			var hsl:Object = ConvertColor.RGBtoHSL(rgb.r, rgb.g, rgb.b);
			
			gradient.bitmapData.lock();
			for (var i:int = 0; i <= 200; i++)
			{
				tempColor = ConvertColor.HSLtoColor(hsl.h, hsl.s, (200-i) * 0.005);
				tempColor = uint("0x" + tempColor.toString(16).toUpperCase());
				
				for (var ti:int = i*4; ti < i*4+4; ti++) 
				{
					gradient.bitmapData.setPixel(0, ti, tempColor);
				}
			}
			gradient.bitmapData.unlock();
			
			for (var k:int = 0; k < 60; k++) 
			{
				gradient.bitmapData.copyPixels(gradient.bitmapData , new Rectangle(0, 0, 1, 800), new Point(k, 0));
			}
			
			//update_NewColor_Sprite();
			
			/*if(!gradient.stage)
				gradientHolder.addChild(gradient);
			if (!gradientHolder.stage)
				addChild(gradientHolder);*/
		}
		
		private function update_NewColor_Sprite():void 
		{
			c2Sprite.graphics.clear();
			c2Sprite.graphics.beginFill(_newColor);
			c2Sprite.graphics.drawRect(0, 0, sW*0.08, sH * 0.1);
			c2Sprite.graphics.endFill();
		}
		
		private function createToolSetting(e:MouseEvent):void 
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
		
		private function changeSize(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("Size", ToolManager.currentToolProp.size, 1, 200,null,sW*0.32,sH*0.5,0,true);
			this.addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			customSlider.closeBtn.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				removeChild(customSlider);
			});
			//(parent as Menu).deactivateTweenOut();
		}
		
		private function updateSize(e:Event):void
		{
			if(customSlider && customSlider.stage)
			{
				removeChild(customSlider);
				customSlider = null;
				changeSize(null);
			}
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			ToolManager.currentToolProp.size = customSlider.value;
			
			//this.removeChild(customSlider);
			//customSlider = null;
			
			//(parent as Menu).activeTweenOut();
		}
		
		private function changeTool(e:MouseEvent):void 
		{
			var toolNumber:int = int(e.currentTarget.name);
			
			ToolManager.toggle(toolNumber);
			
			if(ToolManager.activeTools.indexOf(ToolType.BRUSH) != -1 && presets == null)
			{
				presets = new PresetInterface();
				presets.x = sW*0.32;
				presets.y = sW*0.2;
				presets.addEventListener(Event.CHANGE,updateSize);
				this.addChild(presets);
			}
			
			if(ToolManager.activeTools.indexOf(ToolType.BRUSH) == -1 && presets != null)
			{
				this.removeChild(presets);
				presets = null;
			}
			
			settingIcon.removeChild(settingIcon.getChildAt(0));
			var sp2:Sprite;
			sp2 = new SettingsIcon;
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = settingIcon.width / 2;
			sp2.y = settingIcon.height / 2;
			settingIcon.addChild(sp2);
			
			if (ToolManager.currentToolProp == null)
			{
				addChild(settingsCover);
			}
			else if(settingsCover.stage)
			{
				removeChild(settingsCover);
			}
			
			var i:int = 0;
			while (toolHolder.numChildren > i)
			{
				if(ToolManager.activeTools.indexOf(i) != -1)
					drawIconOn(toolHolder.getChildAt(i) as Sprite, true);
				else
					drawIconOn(toolHolder.getChildAt(i) as Sprite, false);
				i++;
			}
		}
		
		private function drawIconOn(sp1:Sprite, selectTool:Boolean = false)
		{
			var sp2:Sprite;
			var cT:ColorTransform;
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.4;
			
			var typeTxt:TextField;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			
			if (sp1.numChildren > 0)
				sp1.removeChildAt(0);
			
			cT = new ColorTransform;
			if (selectTool)
			{
				sp1.graphics.lineStyle(sW * 0.001, CustomUI.color2); 
				sp1.graphics.beginFill(CustomUI.color1); 
				cT.color = CustomUI.color2;
				txtFormat.color = CustomUI.color2;
			}
			else
			{
				sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); 
				sp1.graphics.beginFill(CustomUI.color2); 
				cT.color = CustomUI.color1;
				txtFormat.color = CustomUI.color1;
			}
			sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
			
			typeTxt.defaultTextFormat = txtFormat;
			switch(int(sp1.name))
			{
				case ToolType.BLUR: sp2 = new BlurToolIcon; 		typeTxt.text = "BLUR";	
				break;
				case ToolType.ERASER: sp2 = new EraseToolIcon; 		typeTxt.text = "ERASER";	 
				break;
				case ToolType.SPRAY: sp2 = new SprayPaintIcon; 		typeTxt.text = "SPRAY";	 
				break;
				case ToolType.BRUSH: sp2 = new BrushToolIcon; 		typeTxt.text = "BRUSH";	 
				break;
				case ToolType.TRANSFORM: sp2 = new FreeTransIcon; 	typeTxt.text = "TRANSFORM";	 
				break;
				case ToolType.SMUDGE: sp2 = new SmudgeToolIcon; 	typeTxt.text = "SMUDGE";	 
				break;
				case ToolType.BUCKET: sp2 = new BucketToolIcon; 	typeTxt.text = "BUCKET";	 
				break;
				case ToolType.SHAPE: sp2 = new ShapeToolIcon; 		typeTxt.text = "SHAPE";	 
				break;
				case ToolType.SCROLL: sp2 = new MoveLayerIcon; 		typeTxt.text = "MOVE";	 
				break;
				case ToolType.CLIP: sp2 = new ClipToolIcon; 		typeTxt.text = "CLIP";	 
				break;
				case ToolType.MAG_GLASS: sp2 = new MagGlassIcon; 	typeTxt.text = "MAGNIFY";	
				break;
				case ToolType.PICKER: sp2 = new ColorPickerIcon; 	typeTxt.text = "PICKER";	 
				break;
				case ToolType.LINE: sp2 = new CurveToolIcon; 		typeTxt.text = "CURVE";	
				break;
				case ToolType.TEXT: sp2 = new TextToolIcon; 		typeTxt.text = "TEXT";	
				break;
				case ToolType.LASSO: sp2 = new LassoToolIcon; 		typeTxt.text = "LASSO";	
				break;
			}
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp1.width / 2 - typeTxt.width / 2; typeTxt.y = sp2.y + typeTxt.height;
			//sp1.addChild(typeTxt);
		}
		
		private function setColor(e:MouseEvent=null):void 
		{
			if (e != null)
			{
				ToolManager.fillColor = colorsArray[int(e.currentTarget.name)];
				c2Sprite.graphics.beginFill(ToolManager.fillColor);
				c2Sprite.graphics.drawRect(0, 0, c2Sprite.width, sH * 0.1);
				c2Sprite.graphics.endFill();
			}
			else
			{
				ToolManager.fillColor = colorSetup.color;
				BackBoard.instance.removeChild(colorSetup);
				colorSetup = null;
				c2Sprite.graphics.beginFill(ToolManager.fillColor);
				c2Sprite.graphics.drawRect(0, 0, c2Sprite.width, sH * 0.1);
				c2Sprite.graphics.endFill();
			}
		}
		
		public function updateColorArray():void 
		{
			if (colorsArray.indexOf(ToolManager.fillColor) == -1)
			{
				colorsArray.unshift(ToolManager.fillColor);
				colorsArray.pop();
				
				var sp1:Sprite;
				for(var i:int = 0; i<colorsSprites.length;i++)
				{
					sp1 = colorsSprites[i] as Sprite;
					sp1.graphics.clear();
					sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1);
					sp1.graphics.beginFill(colorsArray[i]);
					sp1.graphics.drawRect(0, 0, sW * 0.08, sH * 0.1); sp1.graphics.endFill();
					sp1.graphics.endFill();
				}
				
				c1Sprite.graphics.beginFill(ToolManager.fillColor);
				c1Sprite.graphics.drawRect(0, 0, sW*0.08, sH * 0.1);
				c1Sprite.graphics.endFill();
			}
		}
		
		public function update(eventType:String):void
		{
			if(ToolManager.activeTools.indexOf(ToolType.PICKER) == -1 && eventType == MouseEvent.MOUSE_DOWN)
			{
				_oldColor = ToolManager.fillColor;
				c1Sprite.graphics.clear();
				c1Sprite.graphics.beginFill(_oldColor);
				c1Sprite.graphics.drawRect(0, 0, sW*0.08, sH * 0.1);
				c1Sprite.graphics.endFill();
				updateColorArray();
			}
			else if(ToolManager.activeTools.indexOf(ToolType.PICKER) != -1 && eventType == MouseEvent.CLICK)
			{
				_newColor = ToolManager.fillColor;
				update_NewColor_Sprite();
			}
			
			
		}
		
	}

}