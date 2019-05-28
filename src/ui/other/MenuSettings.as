package ui.other 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import settings.System;
	import flash.filters.DropShadowFilter;
	import flash.utils.getDefinitionByName;
	import ui.message.SaveMessage;
	import flash.net.SharedObject;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class MenuSettings extends Sprite
	{
		public static const ON_LEFT:Boolean = true;
		
		public static var currentMenu:Array;
		
		public static var option1:String;
		public static var option2:String;
		
		private var _exitHandler:Function;
		private var sW:int;
		private var sH:int;
		private var videoHolder:Sprite;
		private var supportHolder:Sprite;
		private var txtFormat:TextFormat;
		
		private var menuList:Array;
		private var holder:Sprite;
		private var catBtnHolder:Sprite;
		private var btnHolder:Sprite;
		private var heading:TextField;
		
		private var menuPresets:Array;
		
		private var buttonsCategory:Array = ["Tool switcher","Tools","Brush settings","Layers","Colors","Others"];
		
		private var tools:Array = ["Tools","BlurTool","EraseTool","SprayPaint","BrushTool","FreeTrans","SmudgeTool","BucketTool","ShapeTool","MoveLayer","ClipTool","MagGlass","ColorPicker","CurveTool","TextTool","LassoTool","TS"];
		
		private var brushSettings:Array = ["Brushes","Si","Fl","Sm","Sp","BOp"];
		
		private var layers:Array = ["Layer","LayerSwitcher","Plus","CopyLayer","Merge","Delete","Visible","LOp","LS"];
		
		private var colors:Array = ["Colors","#","More","Swatch"];
		
		private var others:Array = ["Undo","Redo","PanZoom"];
		
		public function MenuSettings(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var so:SharedObject = SharedObject.getLocal("Menus", "/");
			so.clear();
			if (so.data.menuPresets == undefined)
			{
				menuPresets = new Array();
				so.data.menuPresets = menuPresets;
			}
			else
			{
				menuPresets = so.data.menuPresets;
				
			}
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
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Menu";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			TweenLite.to(textField, 0.6, { x: sW * 0.1, ease:Strong.easeOut } );
			
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
			TweenLite.to(sp, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Create";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.33;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, createMenu);
			TweenLite.to(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Preset";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.45;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, showPreset);
			TweenLite.to(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Settings";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.57;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			//sp.addEventListener(MouseEvent.CLICK, addSupportHolder);
			TweenLite.to(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
		}
		
		private function showPreset(e:MouseEvent):void
		{
			if(menuPresets.length != 0)
			{
				currentMenu = menuPresets[0].list;
				option1 = menuPresets[0].option1;
				option2 = menuPresets[0].option2;
			}
		}
		
		private function createMenu(e:MouseEvent):void
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			this.removeChildren();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var sp:Sprite; var textField:TextField;
			
			catBtnHolder = new Sprite();
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083*0.5;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Select a category for custom menu button";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.1;
			textField.y = sH * 0.033;
			addChild(textField);
			
			heading = textField;
			
			for(var i:int = 0;i<buttonsCategory.length;i++)
			{
				sp = new Sprite;
				sp.name = buttonsCategory[i];
				sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW * 0.15, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.4;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = buttonsCategory[i];
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				catBtnHolder.addChild(sp);
				sp.x = sW * 0.01 + (int(i%5)*sp.width) + int(i%5)*sW*0.01;
				sp.y = textField.y + textField.height*4 + (int(i/5)*sp.height*1.5);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void 	{ e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void 		{ e.currentTarget.scaleX = e.currentTarget.scaleY = 1;   createCatButtons(e.currentTarget.name)});
			}
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Discard";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.01;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {_exitHandler();});
			
			
			/*sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Add";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, addMenuBtn);
			TweenLite.to(sp, 1, { x: sW * 0.495 - sp.width, ease:Strong.easeOut } );*/
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.5 - sp.width/2;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				addChild(new SaveMessage(SaveMessage.MENU_TYPE,nameSelected,"Menu Preset","","my_menu"));
				});
			
			addChild(catBtnHolder);
			
			menuList = ["File"];
			
			refreshMenu();
		}
		
		private function nameSelected(rn:String):void
		{	
			var menuObj:Object = new Object();
			menuObj.list = menuList;
			menuObj.option1 = option1;
			menuObj.option2 = option2;
			menuObj.name = rn;
			
			menuPresets.push(menuObj);
			
			var so:SharedObject = SharedObject.getLocal("Menus", "/");
			
			so.clear();
			so.data.menuPresets = menuPresets;
			so.flush();
			so.close();
			
			currentMenu = menuList;
			
			_exitHandler();
		}
		
		private function createCatButtons(category:String):void
		{
			catBtnHolder.visible = false;
			
			if(btnHolder)	btnHolder.removeChildren();
			else			btnHolder = new Sprite();
			
			btnHolder.visible = true;
			
			option1 = null;
			option2 = null;
			
			/*if(category == buttonsCategory[0] && menuList.indexOf("ToolSwitcher")!=-1)
			{
				menuList.splice(menuList.indexOf("ToolSwitcher"),1);
				TweenLite.to(holder, 0.5, { x: sW, ease:Linear.easeNone, onComplete:function():void { removeChild(holder); refreshMenu(); } } );
			}*/
			
			var catArray:Array;
			switch(category)
			{
				case 	buttonsCategory[0]: 
						heading.text = "Select 2 tools to switch in between";
						catArray = tools.slice(1,tools.length-1);
				break;
				case 	buttonsCategory[1]: 
						heading.text = "Select a tool to create a shortcut";
						catArray = tools;
				break;
				case 	buttonsCategory[2]: 
						heading.text = "Select a brush's setting to create a shortcut";
						catArray = brushSettings;
				break;
				case 	buttonsCategory[3]: 
						heading.text = "Select a layer's option to create a shortcut";
						catArray = layers;
				break;
				case 	buttonsCategory[4]: 
						heading.text = "Select a color's submenu to create a shortcut";
						catArray = colors;
				break;
				case 	buttonsCategory[5]: 
						heading.text = "Select a option to create its shortcut";
						catArray = others;
				break;
			}
			
			var sp:Sprite;
			var sp2:Sprite;
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.25;
			var typeTxt:TextField;
			var symbolTxt:TextField;
			var cT:ColorTransform;
			
			var c:Class;
			for(var i:int = 0;i<catArray.length;i++)
			{
				sp = new Sprite;
				sp.name = catArray[i];
				sp.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.color2); 
				sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.15); sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;	
				txtFormat.size = sH * 0.083 * 0.25;
				typeTxt = new TextField;typeTxt.embedFonts = true;
				typeTxt.defaultTextFormat = txtFormat;
				
				
				try
				{
					c = getDefinitionByName(catArray[i]+"Icon") as Class;
				
					sp2 = new c;
					typeTxt.text = catArray[i];
					
					sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
					cT = new ColorTransform;
					cT.color = CustomUI.color1;
					sp2.transform.colorTransform = cT;
					sp2.x = sp.width * 0.5;
					sp2.y = sp.height * 0.5;
					sp.addChild(sp2);
				
				}
				catch(e:*)
				{
					symbolTxt = new TextField;symbolTxt.embedFonts = true;
					txtFormat.size = sH * 0.083 * 0.4;
					symbolTxt.defaultTextFormat = txtFormat;
					symbolTxt.text = catArray[i];
					
					symbolTxt.selectable = false;
					symbolTxt.autoSize = TextFieldAutoSize.CENTER;
					symbolTxt.x = sp.width / 2 - symbolTxt.width / 2; symbolTxt.y = sp.height/2 - symbolTxt.height*0.5;
					sp.addChild(symbolTxt);
					
					switch(catArray[i])
					{
						case "Si": typeTxt.text = "Size"; 		break;
						case "Fl": typeTxt.text = "Flow"; 		break;
						case "Sm": typeTxt.text = "Smoothness"; break;
						case "Sp": typeTxt.text = "Spacing"; 	break;
						case "BOp": typeTxt.text = "Opacity";	break;
						case "LOp": typeTxt.text = "Opacity";	break;
						case "#":  typeTxt.text = "HexColor";	break;
						case "TS":  typeTxt.text = "ToolSetting";	break;
						case "LS":  typeTxt.text = "LayerSetting";	break;
					}
				}
				
				typeTxt.selectable = false;
				typeTxt.autoSize = TextFieldAutoSize.CENTER;
				typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height - typeTxt.height*1.2;
				sp.addChild(typeTxt);
				
				sp.x = (sp.width * int(i%5)) + sW*0.1;
				sp.y = (sp.height * int(i/5)) + sH*0.1;
				btnHolder.addChild(sp);
				
				sp.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
				{
					if(category == buttonsCategory[0])
					{
						if(option1 == null)
						{
							option1 = e.currentTarget.name;
							e.currentTarget.alpha = 0.5;
						}
						else if(option1 != e.currentTarget.name)
						{
							catBtnHolder.visible = true;
							btnHolder.visible = false;
							option2 = e.currentTarget.name;
							heading.text = "Select a category for custom menu button";
							addMenuBtn("ToolSwitcher",option1,option2);
						}
					}
					else
					{
						catBtnHolder.visible = true;
						btnHolder.visible = false;
						heading.text = "Select a category for custom menu button";
						addMenuBtn(e.currentTarget.name,null,null);
					}
				});
			}
			addChild(btnHolder);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			var textField:TextField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Back";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			btnHolder.addChild(sp);
			sp.x = sW * 0.49 - sp.width/2 - sp.width;
			sp.y = sH - sH * 0.016 - sp.height;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{btnHolder.visible = false; catBtnHolder.visible = true; heading.text = "Select a category for custom menu button";});
			
		}
		
		private function addMenuBtn(btnName:String,option1:String,option2:String):void
		{
			if(menuList.indexOf(btnName) != -1)
			{
				heading.text = "This button already exists in menu.Select another";
				return;
			}
			if(menuList.length > 10) 
			{
				heading.text = "Menu is at maximum button limit.";
				return;
			}
			
			menuList.push(btnName);
			
			TweenLite.to(holder, 0.5, { x: sW, ease:Linear.easeNone, onComplete:function():void { removeChild(holder); refreshMenu(); } } );
		}
		
		private function removeMenuBtn(e:MouseEvent):void
		{
			var index:uint = uint((e.currentTarget as Sprite).name);
			menuList.splice(index,1);
			
			TweenLite.to(holder, 0.5, { x: sW, ease:Linear.easeNone, onComplete:function():void { removeChild(holder); refreshMenu(); } } );
		}
		
		private function refreshMenu():void
		{
			var sp:Sprite;
			var typeTxt:TextField;
			var sp2:Sprite;
			
			holder = new Sprite;
			
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color2;
			
			var menuBtns:uint = menuList.length;
			var c:Class;
			
			var closeBtn:Sprite;
			
			for (var i:int = 0; i < menuBtns; i++)
			{
				sp = new Sprite;
				sp.graphics.lineStyle(sW*0.001, CustomUI.color2); sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(-sH * 0.0417,-sH * 0.0417,sH * 0.083, sH * 0.083); sp.graphics.endFill();
		
				sp2 = new CloseIcon;
				
				sp.name = String(i);
				sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
				sp2.transform.colorTransform = cT;
				sp.addChild(sp2);
				sp.x = sp.width/2; sp.y = i*sH/menuBtns + (sH/(menuBtns*2));
				sp.addEventListener(MouseEvent.CLICK,removeMenuBtn);
				holder.addChild(sp);
				
				if(menuList[i] == "File")
				{
					sp.visible = false;
				}
				
				sp = new Sprite;
				sp.graphics.lineStyle(sW*0.0034,CustomUI.color2); sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW*0.08, sH/menuBtns); sp.graphics.endFill();
				
				try
				{
					c = getDefinitionByName(menuList[i]+"Icon") as Class;
				
					sp2 = new c;
					
					sp2.width = sp2.height = (sW * 0.08 / 1.5);
					cT = new ColorTransform;
					cT.color = CustomUI.color2;
					sp2.transform.colorTransform = cT;
					sp2.x = sp.width * 0.5;
					sp2.y = sp.height * 0.5;
					sp.addChild(sp2);
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
				
				sp.x = sH * 0.12; sp.y = i*sH/menuBtns;
				holder.addChild(sp);
			}
			holder.x = sW;
			addChild(holder);
			
			TweenLite.to(holder, 1, { x: sW-holder.width, ease:Strong.easeOut } );
		}
		
		private function removeSubMenu():void 
		{
			if (videoHolder && videoHolder.stage)
			{
				TweenLite.to(videoHolder, 0.5, { x: sW * 0.5 + videoHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(videoHolder); videoHolder = null; } } );
			}
			if (supportHolder && supportHolder.stage)
			{
				TweenLite.to(supportHolder, 0.5, { x: sW * 0.5 + supportHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(supportHolder); supportHolder = null; } } );
			}
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			_exitHandler();
		}
		
	}

}