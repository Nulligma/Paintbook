package ui.other 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import flash.geom.ColorTransform;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import settings.System;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import layers.history.HistoryManager;
	import settings.CustomUI;
	import settings.MessagePrefrences;
	import settings.Prefrences;
	import ui.message.Warning;
	import utils.taskLoader.TaskLoader;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SettingsUI extends Sprite
	{
		private var _exitHandler:Function;
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var themeHolder:Sprite;
		private var prefHolder:Sprite;
		
		private var customSlider:CustomSlider;
		private var undoTxt:TextField;
		
		private var prevTheme:int;
		private var warning:Warning;
		
		private var supportHolder:Sprite;
		private var tutorialHolder:Sprite;
		
		private var currentPressed:Sprite;
		private var loadFile:FileReference;
		
		public function SettingsUI(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			prevTheme = CustomUI.colorSet;
			
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
			textField.text = "Options";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			tween = new TweenNano(textField, 0.7, { x: sW * 0.1, ease:Strong.easeOut } );
			
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
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;  currentPressed = e.currentTarget as Sprite; } );
			sp.addEventListener(MouseEvent.CLICK, onBack);
			tween = new TweenNano(sp, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Theme";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.2917;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
			sp.addEventListener(MouseEvent.CLICK, addTheme);
			tween = new TweenNano(sp, 0.8, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Preferences";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.4083;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.CLICK, addPref);
			tween = new TweenNano(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Support";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH*0.525;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
			sp.addEventListener(MouseEvent.CLICK, addSupportHolder);
			tween = new TweenNano(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Tutorial";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.6417;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
			sp.addEventListener(MouseEvent.CLICK, addTutorialHolder);
			tween = new TweenNano(sp, 1.1, { x: sW * 0.1, ease:Strong.easeOut } );
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stagePress);
		}
		
		private function gotoTutorial(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("https://www.youtube.com"), "_blank");
		}
		
		private function stagePress(e:MouseEvent):void 
		{
			if (currentPressed)
			{
				currentPressed.scaleX = currentPressed.scaleY = 1;
				currentPressed = null;
			}
		}

		private function addPref(e:MouseEvent):void 
		{
			if (prefHolder) return;
			
			removeSubMenu();
			
			prefHolder = new Sprite;
			
			prefHolder.graphics.beginFill(CustomUI.color1);
			prefHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			prefHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "General";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.0667;
			prefHolder.addChild(textField);
			
			prefHolder.graphics.lineStyle(1, CustomUI.color2);
			prefHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			prefHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			prefHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			prefHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			for (var i:int = 0; i < 2; i++)
			{
				sp = new Sprite;
				sp.name = String(i);
				sp.graphics.beginFill(CustomUI.color2);
				sp.graphics.drawRect(0, 0, sW * 0.2148, sH * 0.083);
				sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = i == 0?"AutoHide Menu":"Layer Preview";
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				prefHolder.addChild(sp);
				sp.x = sW * 0.0488 + i * (sW * 0.2246);
				sp.y = sH * 0.1667;
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;  currentPressed = e.currentTarget as Sprite; } );
				sp.addEventListener(MouseEvent.CLICK, changePref );
				
				if (i == 0)
					sp.alpha = Prefrences.hideMenu?1:0.5;
				else
					sp.alpha = Prefrences.layerPreview?1:0.5;
			}
			
			sp = new Sprite;
			sp.name = String(2);
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.2148, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save on Close";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			prefHolder.addChild(sp);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.2667;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97;  currentPressed = e.currentTarget as Sprite;} );
			sp.addEventListener(MouseEvent.CLICK, changePref );
			sp.alpha = Prefrences.saveOnClose?1:0.5;
			
			sp = new Sprite;
			sp.name = String(3);
			sp.graphics.beginFill(CustomUI.color2);
			sp.graphics.drawRect(0, 0, sW * 0.2148, sH * 0.083);
			sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			undoTxt = new TextField;undoTxt.embedFonts = true;
			undoTxt.defaultTextFormat = txtFormat;
			undoTxt.text = "Undo Limit "+Prefrences.undoLimit;
			undoTxt.selectable = false;
			undoTxt.autoSize = TextFieldAutoSize.CENTER;
			undoTxt.x = sp.width / 2 - undoTxt.width / 2; undoTxt.y = sp.height / 2 - undoTxt.height / 2;
			sp.addChild(undoTxt);
			prefHolder.addChild(sp);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.3667;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
			sp.addEventListener(MouseEvent.CLICK, changePref );
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Messages";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.533;
			prefHolder.addChild(textField);
			
			prefHolder.graphics.lineStyle(1, CustomUI.color2);
			prefHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			prefHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			prefHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			prefHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			for (var j:int = 0; j < 2; j++)
			{
				sp = new Sprite;
				sp.name = String(4+j);
				sp.graphics.beginFill(CustomUI.color2);
				sp.graphics.drawRect(0, 0, sW * 0.2148, sH * 0.083);
				sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				switch(j)
				{
					case 0: textField.text = "Merge layer"; sp.alpha = MessagePrefrences.hideMergeWarning?0.5:1; break;
					case 1: textField.text = "Delete Layer"; sp.alpha = MessagePrefrences.hideDeleteWarning?0.5:1; break;
					case 2: textField.text = "Donate"; sp.alpha = MessagePrefrences.hideDonateWarning?0.5:1; break;
				}
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				prefHolder.addChild(sp);
				sp.x = sW * 0.0488 + j%2 * (sW * 0.2246);
				sp.y = sH * 0.633 + int(j/2) * (sH * 0.1);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
				sp.addEventListener(MouseEvent.CLICK, changePref );
			}
			
			prefHolder.x = sW * 0.5 + prefHolder.width * 0.5;
			
			addChild(prefHolder);
			tween = new TweenNano(prefHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function changePref(e:MouseEvent):void 
		{
			var name:int = int(e.currentTarget.name);
			
			switch(name)
			{
				//case 0: Prefrences.hideMenu = !Prefrences.hideMenu; e.currentTarget.alpha = Prefrences.hideMenu?1:0.5; break;
				case 1: Prefrences.layerPreview = !Prefrences.layerPreview; e.currentTarget.alpha = Prefrences.layerPreview?1:0.5; break;
				case 2: Prefrences.saveOnClose = !Prefrences.saveOnClose; e.currentTarget.alpha = Prefrences.saveOnClose?1:0.5; break;
				
				case 4: MessagePrefrences.hideMergeWarning = !MessagePrefrences.hideMergeWarning; e.currentTarget.alpha = MessagePrefrences.hideMergeWarning?0.5:1; break;
				case 5: MessagePrefrences.hideDeleteWarning = !MessagePrefrences.hideDeleteWarning; e.currentTarget.alpha = MessagePrefrences.hideDeleteWarning?0.5:1; break;
				case 6: MessagePrefrences.hideDonateWarning = !MessagePrefrences.hideDonateWarning; e.currentTarget.alpha = MessagePrefrences.hideDonateWarning?0.5:1; break;
				
				case 3:
					customSlider = new CustomSlider("Undo Limit", Prefrences.undoLimit, 5, 50);
					addChild(customSlider);
					customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateUndoDrag);
				break;
			}
			
			Prefrences.save();
			MessagePrefrences.save();
		}
		
		private function terminateUndoDrag(e:MouseEvent):void 
		{
			customSlider.removeEventListener(MouseEvent.MOUSE_UP, terminateUndoDrag);
			
			Prefrences.undoLimit = customSlider.value;
			undoTxt.text = "Undo Limit " + Prefrences.undoLimit;
			removeChild(customSlider);
			customSlider = null;
			Prefrences.save();
		}
		
		private function addTheme(e:MouseEvent):void 
		{
			if (themeHolder) return;
			
			removeSubMenu();
			
			themeHolder = new Sprite;
			
			themeHolder.graphics.beginFill(CustomUI.color1);
			themeHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			themeHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			var tween:TweenNano;
			
			generateThemeColors();
			
			themeHolder.x = sW * 0.5 + themeHolder.width * 0.5;
			
			addChild(themeHolder);
			tween = new TweenNano(themeHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function generateThemeColors():void 
		{
			var colorArray:Array = CustomUI.colorArray;
			
			var sp:Sprite; var i:int = 0;
			for each(var arr:Array in colorArray)
			{
				sp = new Sprite;
				sp.name = String(i);
				sp.graphics.beginFill(arr[0]);
				sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.083);
				sp.graphics.endFill();
				
				sp.graphics.lineStyle(sH*0.0083,arr[1],1,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
				sp.graphics.beginFill(arr[2]);
				sp.graphics.drawRect(sp.width * 0.5 - sH * 0.033, sp.height * 0.5 - sH * 0.033, sH * 0.0667, sH * 0.0667);
				sp.graphics.endFill();
				
				sp.x = (i % 4) * (sW * 0.1 + sW * 0.01) + sW * 0.0488;
				sp.y = int(i / 4) * (sH * 0.083 + sH * 0.01667) + sH * 0.0667;
				themeHolder.addChild(sp);
				
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
				sp.addEventListener(MouseEvent.CLICK, redraw);
				
				i++;
			}
			
			var textField:TextField;
			for (var j:int = 0; j < 4; j++)
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2);
				sp.graphics.drawRect(0, 0, sW * 0.2148, sH * 0.083);
				sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				switch(j)
				{
					case 0: sp.name = textField.text = "Kelson Sans"; break;
					case 1: sp.name = textField.text = "Mosk Bold 700"; break;
					case 2: sp.name = textField.text = "Lobster"; break;
					case 3: sp.name = textField.text = "GelPen"; break;
				}
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				themeHolder.addChild(sp);
				sp.x = sW * 0.0488 + j%2 * (sW * 0.2246);
				sp.y = sH * 0.783 + int(j/2) * (sH * 0.1);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; currentPressed = e.currentTarget as Sprite; } );
				sp.addEventListener(MouseEvent.CLICK, changeFont );
				
				//if (i == 0)
					//sp.alpha = MessagePrefrences.hideMergeWarning?0.5:1;
				//else
					//sp.alpha = MessagePrefrences.hideDeleteWarning?0.5:1;
			}
		}
		
		private function changeFont(e:MouseEvent):void 
		{
			var name:String = e.currentTarget.name;
			
			switch(name)
			{
				case "Kelson Sans":CustomUI.font = "Kelson Sans Regular"; break;
				case "Mosk Bold 700":CustomUI.font = "Mosk Bold 700"; break;
				case "Lobster":CustomUI.font = "Lobster 1.4"; break;
				case "GelPen":CustomUI.font = "GelPen"; break;
			}
			
			redraw();
		}
		
		private function redraw(e:MouseEvent=null):void 
		{
			if (e != null)
				CustomUI.changeColors(int(e.currentTarget.name));
			
			graphics.clear();
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			var child:*; var txt:TextField;
			var innerChild:*;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				child = getChildAt(i);
				if (child == themeHolder)
				{
					themeHolder.graphics.clear();
					themeHolder.graphics.beginFill(CustomUI.color1);
					themeHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
					themeHolder.graphics.endFill();
					
					for (var j:int = 0; j < themeHolder.numChildren; j++)
					{
						
						innerChild = themeHolder.getChildAt(j);
						
						var name:String = innerChild.name;
						
						if (name.length < 4) continue;
						
						innerChild.graphics.beginFill(CustomUI.color2); 
						innerChild.graphics.drawRect(0, 0, innerChild.width, innerChild.height);
						
						txtFormat.font = CustomUI.font;
						txtFormat.color = CustomUI.color1;
						txtFormat.size = sH * 0.083 * 0.6;
						txt = innerChild.getChildAt(0);
						txt.setTextFormat(txtFormat);
					}
				}
				else if (Class(getDefinitionByName(getQualifiedClassName(child))) == Sprite)
				{
					child.graphics.beginFill(CustomUI.color1); 
					child.graphics.drawRect(0, 0, child.width,child.height); 
					child.graphics.endFill();
					
					txtFormat.font = CustomUI.font;
					txtFormat.color = CustomUI.color2;
					txtFormat.size = sH * 0.083 * 0.6;
					txt = child.getChildAt(0);
					txt.setTextFormat(txtFormat);
				}
				else if (Class(getDefinitionByName(getQualifiedClassName(child))) == TextField)
				{
					txtFormat.font = CustomUI.font;
					txtFormat.color = CustomUI.color1;
					txtFormat.size = sH * 0.083;
					child.setTextFormat(txtFormat);
				}
			}
		}
		
		private function addSupportHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (supportHolder) return;
			
			removeSubMenu();
			
			supportHolder = new Sprite;
			
			supportHolder.graphics.beginFill(CustomUI.color1);
			supportHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			supportHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField; var sp2:Sprite; var cT:ColorTransform;
			
			for (var i:int = 0; i < 4; i++) 
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); 
				sp.graphics.drawRect(0, 0, sW * 0.4297, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				
				if (i == 0)
				{
					textField.text = sp.name = "Official_Forums";
					sp2 = new HelpIcon;
				}
				else if (i == 1)
				{
					textField.text = sp.name = "Reddit";
					sp2 = new RedditIcon;
				}
				else if (i == 2)
				{
					textField.text = sp.name = "Facebook";
					sp2 = new FbIcon;
				}
				else
				{
					textField.text = sp.name = "Twitter";
					sp2 = new twitterIcon;
				}
				
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
				cT = new ColorTransform;
				cT.color = CustomUI.color1;
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width - sp2.width / 2 - sW * 0.01;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
				sp.x = sW * 0.0488;
				sp.y = sH * 0.0667 + i*(sp.height + sH * 0.083);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, goToLink);
				supportHolder.addChild(sp);
			}
			
			supportHolder.x = sW * 0.5 + supportHolder.width * 0.5;
			
			addChild(supportHolder);
			new TweenNano(supportHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function goToLink(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			var req:URLRequest;
			
			if (e.currentTarget.name == "Official_Forums")
			{
				req = new URLRequest("http://forums.nulligma.com/viewforum.php?f=1"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Facebook")
			{
				req = new URLRequest("http://www.facebook.com/Nulligma"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Twitter")
			{
				req = new URLRequest("https://twitter.com/Nulligma"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Reddit")
			{
				req = new URLRequest("https://www.reddit.com/r/paintbook/"); 
				navigateToURL(req, "_blank");
			}
		}
				
		private function addTutorialHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (tutorialHolder) return;
			
			removeSubMenu();
			
			tutorialHolder = new Sprite;
			
			tutorialHolder.graphics.beginFill(CustomUI.color1);
			tutorialHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			tutorialHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField; var sp2:Sprite; var cT:ColorTransform;var textField2:TextField;
			
			for (var i:int = 0; i < 2; i++) 
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color2); 
				sp.graphics.drawRect(0, 0, sW * 0.4297, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color1;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				
				
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.4;
				textField2 = new TextField;textField2.embedFonts = true;
				textField2.defaultTextFormat = txtFormat;
				
				if (i == 0)
				{
					textField.text = sp.name = "Forums";
					textField2.text = "Submit your tutorials to help the art community.";
					sp2 = new HelpIcon;
				}
				else if (i == 1)
				{
					textField.text = sp.name = "Youtube";
					textField2.text = "I am creating/uploading tutorials.Subscribe here.";
					sp2 = new YoutubeIcon;
				}
				
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sW*0.029; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				
				sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
				cT = new ColorTransform;
				cT.color = CustomUI.color1;
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width - sp2.width / 2 - sW * 0.01;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
				sp.x = sW * 0.0488;
				sp.y = sH * 0.0667 + i*(sp.height + sH * 0.083 * 5);
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, goToLink2);
				tutorialHolder.addChild(sp);
				
				textField2.selectable = false;
				textField2.autoSize = TextFieldAutoSize.CENTER;
				textField2.x = sp.x + sW*0.029; textField2.y = sp.y + sp.height + textField2.height / 2;
				tutorialHolder.addChild(textField2);
			}
			
			tutorialHolder.x = sW * 0.5 + tutorialHolder.width * 0.5;
			
			addChild(tutorialHolder);
			new TweenNano(tutorialHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function goToLink2(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			var req:URLRequest;
			
			if (e.currentTarget.name == "Youtube")
			{
				req = new URLRequest("https://www.youtube.com/channel/UCn928rnKyfeW2YaHXIGvx6A"); 
				navigateToURL(req, "_blank");
			}
			else if (e.currentTarget.name == "Forums")
			{
				req = new URLRequest("http://forums.nulligma.com/viewforum.php?f=2"); 
				navigateToURL(req, "_blank");
			}
		}
		
		private function removeSubMenu():void 
		{
			var tween:TweenNano;
			
			if (supportHolder && supportHolder.stage)
			{
				tween = new TweenNano(supportHolder, 0.5, { x: sW * 0.5 + supportHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(supportHolder); supportHolder = null; } } );
			}
			if (tutorialHolder && tutorialHolder.stage)
			{
				tween = new TweenNano(tutorialHolder, 0.5, { x: sW * 0.5 + tutorialHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(tutorialHolder); tutorialHolder = null; } } );
			}
			if (prefHolder && prefHolder.stage)
			{
				tween = new TweenNano(prefHolder, 0.5, { x: sW * 0.5 + prefHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(prefHolder); prefHolder = null; } } );
			}
			if (themeHolder && themeHolder.stage)
			{
				tween = new TweenNano(themeHolder, 0.5, { x: sW * 0.5 + themeHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(themeHolder); themeHolder = null; } } );
			}
		}
		
		private function onBack(e:MouseEvent):void 
		{
			if (CustomUI.colorSet != prevTheme)
			{
				var so:SharedObject = SharedObject.getLocal("Theme", "/");
				so.data.font = CustomUI.font;
				so.data.colorSet = CustomUI.colorSet;
				
				BackBoard.instance.redraw();
			}
			
			_exitHandler();
		}
		
	}

}