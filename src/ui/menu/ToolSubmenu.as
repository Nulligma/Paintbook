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
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ToolSubmenu extends Sprite
	{
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
		
		
		public function ToolSubmenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var sp1:Sprite, sp2:Sprite;
			var typeTxt:TextField;
			var cT:ColorTransform;
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			graphics.beginFill(CustomUI.color2); graphics.drawRect(0, 0, sW, sH * 0.415); graphics.endFill();
			
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
				
				sp1.x = (sW * 0.125 * int(i%8));
				sp1.y = sH*0.207 * int(i/8);
				toolHolder.addChild(sp1);
				sp1.addEventListener(MouseEvent.CLICK, changeTool);
			}
			
			addChild(toolHolder);
			//toolHolder.x = sW * 0.25;
			toolHolder.x = 0;
			//toolHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { toolHolder.startDrag(false, new Rectangle(sW - toolHolder.width, 0, toolHolder.width -sW * 0.75, 0)); } );
			//stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { toolHolder.stopDrag() } );
			
			settingIcon = new Sprite;
			settingIcon.graphics.lineStyle(sW * 0.001, CustomUI.color1); settingIcon.graphics.beginFill(CustomUI.color2); 
			settingIcon.graphics.drawRect(0, 0, sW * 0.5, sH * 0.1); settingIcon.graphics.endFill();
			
			if(ToolManager.activeTools.indexOf(ToolType.BRUSH) == -1)
				sp2 = new SettingsIcon;
			else
				sp2 = new DropDownIcon;
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = settingIcon.width / 2;
			sp2.y = settingIcon.height / 2;
			settingIcon.addChild(sp2);
			settingIcon.y = toolHolder.height;
			addChild(settingIcon);
			settingIcon.addEventListener(MouseEvent.CLICK, createToolSetting);
			
			sp1 = new Sprite();
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0, 0, sW * 0.5, sH * 0.1); sp1.graphics.endFill();
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
			sp1.x = sW * 0.5;
			sp1.y = toolHolder.height;
			sp1.addEventListener(MouseEvent.CLICK, changeSize);
			
			settingsCover = new Sprite();
			settingsCover.graphics.lineStyle(sW * 0.001, CustomUI.color1);
			settingsCover.graphics.beginFill(CustomUI.color2);
			settingsCover.graphics.drawRect(0, 0, sW, sH * 0.1);
			settingsCover.y = toolHolder.height;
			settingsCover.graphics.endFill();
			
			if (ToolManager.activeTools.length == 0 || ToolManager.currentToolProp == null)
				addChild(settingsCover);
			
			//var dropShadow:DropShadowFilter = new DropShadowFilter;
			///dropShadow.angle = 0; dropShadow.quality = 3;
			//sp1.filters = [dropShadow];
			
			drawerLine = new Sprite;
			drawerLine.graphics.lineStyle(sW * 0.0025, CustomUI.color1); 
			drawerLine.graphics.moveTo(0, sH * 0.207); drawerLine.graphics.lineTo(sW, sH * 0.207);
			//addChild(drawerLine);
		}
		
		private function createToolSetting(e:MouseEvent):void 
		{
			var br:Boolean = false;
			switch(ToolManager.currentSingleActive)
			{
				case ToolType.BRUSH:
					toolSettings = new BrushSettings();
					br = true;
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
			if (br)
				BackBoard.instance.addChild(new PresetInterface);
			else
				BackBoard.instance.addChild(toolSettings);
		}
		
		private function changeSize(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("Size", ToolManager.currentToolProp.size, 1, 200);
			BackBoard.instance.addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			(parent as Menu).deactivateTweenOut();
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			ToolManager.currentToolProp.size = customSlider.value;
			
			BackBoard.instance.removeChild(customSlider);
			customSlider = null;
			
			(parent as Menu).activeTweenOut();
		}
		
		private function changeTool(e:MouseEvent):void 
		{
			var toolNumber:int = int(e.currentTarget.name);
			
			ToolManager.toggle(toolNumber);
			
			settingIcon.removeChild(settingIcon.getChildAt(0));
			var sp2:Sprite;
			if(ToolManager.activeTools.indexOf(ToolType.BRUSH) == -1)
				sp2 = new SettingsIcon;
			else
				sp2 = new DropDownIcon;
			
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
			sp1.graphics.drawRect(0, 0, sW * 0.125, sH * 0.207); sp1.graphics.endFill();
			
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
			sp1.addChild(typeTxt);
				
		}
		
	}

}