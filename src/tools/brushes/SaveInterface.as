package tools.brushes 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import settings.System;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class SaveInterface extends Sprite
	{
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var newHolder:Sprite;
		private var oldHolder:Sprite;
		
		private var brushName:TextField;
		private var folderName:TextField;
		
		private var customSlider:CustomSlider;
		
		public function SaveInterface() 
		{
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
			
			var sp:Sprite; var textField:TextField;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save Preset";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = -textField.width;
			textField.y = sH * 0.033;
			addChild(textField);
			TweenLite.to(textField, 0.7, { x: sW * 0.1, ease:Strong.easeOut } );
			
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
			sp.addEventListener(MouseEvent.CLICK, onBack);
			TweenLite.to(sp, 1, { x: sW * 0.01, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Old folder";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = sH*0.33;
			
			if (Preset.folderNames.length == 1)
				sp.alpha = 0.5;
			else
				sp.addEventListener(MouseEvent.CLICK, addOFHolder);
			
			TweenLite.to(sp, 0.9, { x: sW * 0.1, ease:Strong.easeOut } );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.244, sH * 0.1); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "New Folder";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = - sp.width;
			sp.y = sH * 0.45;
			sp.addEventListener(MouseEvent.CLICK, addNFHolder);
			TweenLite.to(sp, 1, { x: sW * 0.1, ease:Strong.easeOut } );
		}
		
		private function addNFHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (newHolder) return;
			
			removeSubMenu();
			
			newHolder = new Sprite;
			
			newHolder.graphics.beginFill(CustomUI.color1);
			newHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			newHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Brush Name";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.0667;
			newHolder.addChild(textField);
			
			newHolder.graphics.lineStyle(1, CustomUI.color2);
			newHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			newHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			newHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			newHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			sp = new Sprite;
			sp.name = "Brush";
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.32, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			brushName = new TextField;brushName.embedFonts = true;
			brushName.defaultTextFormat = txtFormat;
			brushName.text = "My Brush";
			brushName.type = TextFieldType.INPUT;
			brushName.maxChars = 15;
			brushName.autoSize = TextFieldAutoSize.CENTER;
			brushName.x = sp.width / 2 - brushName.width / 2; brushName.y = sp.height / 2 - brushName.height / 2;
			sp.addChild(brushName);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.167;
			sp.addEventListener(MouseEvent.CLICK, changeName);
			newHolder.addChild(sp);
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "New Folder";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.34;
			newHolder.addChild(textField);
			
			newHolder.graphics.lineStyle(1, CustomUI.color2);
			newHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			newHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			newHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			newHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			sp = new Sprite;
			sp.name = "Folder";
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.32, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			folderName = new TextField;folderName.embedFonts = true;
			folderName.defaultTextFormat = txtFormat;
			folderName.text = "My Folder";
			folderName.type = TextFieldType.INPUT;
			folderName.maxChars = 15;
			folderName.autoSize = TextFieldAutoSize.CENTER;
			folderName.x = sp.width / 2 - folderName.width / 2; folderName.y = sp.height / 2 - folderName.height / 2;
			sp.addChild(folderName);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.433;
			sp.addEventListener(MouseEvent.CLICK, changeName);
			newHolder.addChild(sp);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			sp.x = newHolder.width - sp.width - sW * 0.01;
			sp.y = sH - sp.height - sH * 0.016;
			sp.addEventListener(MouseEvent.CLICK, onSave);
			newHolder.addChild(sp);
			
			newHolder.x = sW * 0.5 + newHolder.width * 0.5;
			
			addChild(newHolder);
			TweenLite.to(newHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function addOFHolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (oldHolder) return;
			
			removeSubMenu();
			
			oldHolder = new Sprite;
			
			oldHolder.graphics.beginFill(CustomUI.color1);
			oldHolder.graphics.drawRect(0, 0, sW * 0.5, sH);
			oldHolder.graphics.endFill();
			
			var sp:Sprite; var textField:TextField;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Brush Name";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.0667;
			oldHolder.addChild(textField);
			
			oldHolder.graphics.lineStyle(1, CustomUI.color2);
			oldHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			oldHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			oldHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			oldHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			sp = new Sprite;
			sp.name = "Brush";
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.32, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			brushName = new TextField;brushName.embedFonts = true;
			brushName.defaultTextFormat = txtFormat;
			brushName.text = "My Brush";
			brushName.type = TextFieldType.INPUT;
			brushName.maxChars = 15;
			brushName.autoSize = TextFieldAutoSize.CENTER;
			brushName.x = sp.width / 2 - brushName.width / 2; brushName.y = sp.height / 2 - brushName.height / 2;
			sp.addChild(brushName);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.167;
			sp.addEventListener(MouseEvent.CLICK, changeName);
			oldHolder.addChild(sp);
			
			textField = new TextField;
			txtFormat.size = sH * 0.083 * 0.8;
			txtFormat.color = CustomUI.color2;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Select Folder";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW * 0.0488;
			textField.y = sH * 0.33;
			oldHolder.addChild(textField);
			
			oldHolder.graphics.lineStyle(1, CustomUI.color2);
			oldHolder.graphics.moveTo(sW * 0.02, textField.y + textField.height * 0.5);
			oldHolder.graphics.lineTo(textField.x, textField.y + textField.height * 0.5);
			oldHolder.graphics.moveTo(textField.x + textField.width, textField.y + textField.height * 0.5);
			oldHolder.graphics.lineTo(sW * 0.48, textField.y + textField.height * 0.5);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.32, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			folderName = new TextField;folderName.embedFonts = true;
			folderName.defaultTextFormat = txtFormat;
			folderName.text = Preset.folderNames[1];
			folderName.selectable = false; 
			folderName.autoSize = TextFieldAutoSize.CENTER;
			folderName.x = sp.width / 2 - folderName.width / 2; folderName.y = sp.height / 2 - folderName.height / 2;
			sp.addChild(folderName);
			sp.x = sW * 0.0488;
			sp.y = sH * 0.433;
			if (Preset.folderNames.length != 2)
				sp.addEventListener(MouseEvent.CLICK, changeFolder);
			oldHolder.addChild(sp);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Save";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			sp.x = oldHolder.width - sp.width - sW * 0.01;
			sp.y = sH - sp.height - sH * 0.016;
			sp.addEventListener(MouseEvent.CLICK, onSave);
			oldHolder.addChild(sp);
			
			oldHolder.x = sW * 0.5 + oldHolder.width * 0.5;
			
			addChild(oldHolder);
			TweenLite.to(oldHolder, 1, { x: sW * 0.5, ease:Strong.easeOut } );
		}
		
		private function changeFolder(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("",Preset.folderNames.indexOf(folderName.text), 1, Preset.folderNames.length-1, Preset.folderNames);
			addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateNameChange);
		}
		
		private function terminateNameChange(e:MouseEvent):void 
		{
			customSlider.removeEventListener(MouseEvent.MOUSE_UP, terminateNameChange);
			
			folderName.text = Preset.folderNames[customSlider.value];
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function changeName(e:MouseEvent):void 
		{
			if (e.currentTarget.name == "Brush")
			{
				stage.focus = brushName;
				//TODO:RequestKeyBoard-2
				//brushName.requestSoftKeyboard();
				brushName.setSelection(brushName.length, brushName.length);
			}
			else
			{
				stage.focus = folderName;
				//heightTxt.requestSoftKeyboard();
				folderName.setSelection(folderName.length, folderName.length);
			}
		}
		
		private function onSave(e:MouseEvent):void 
		{
			var index:int = Preset.folderNames.indexOf(folderName.text);
			
			if (oldHolder && oldHolder.stage)
			{
				Preset.save(index, folderName.text, brushName.text, false);
			}
			else
			{
				Preset.save(-1, folderName.text, brushName.text, true);
			}
			
			onBack(null);
		}
		
		private function removeSubMenu():void 
		{
			if (oldHolder && oldHolder.stage)
			{
				TweenLite.to(oldHolder, 0.5, { x: sW * 0.5 + oldHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(oldHolder); oldHolder = null; } } );
			}
			if (newHolder && newHolder.stage)
			{
				TweenLite.to(newHolder, 0.5, { x: sW * 0.5 + newHolder.width * 0.5, ease:Linear.easeNone, onComplete:function():void { removeChild(newHolder); newHolder = null; } } );
			}
		}
		
		private function onBack(e:MouseEvent):void 
		{
			if (this.y != 0) return;
			
			TweenLite.to(this, 0.5, { y:-height, ease:Linear.easeIn,onComplete:remove } );
		}
		
		private function remove():void 
		{
			BackBoard.instance.removeChild(this);
		}
		
	}

}