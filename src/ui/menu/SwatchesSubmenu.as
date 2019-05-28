package ui.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import settings.System;
	import ui.other.MenuSettings;
	import settings.CustomUI;
	import colors.setups.Swatches;
	import flash.events.MouseEvent;
	import tools.ToolManager;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;

	public class SwatchesSubmenu extends Sprite
	{
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		
		private var swatchHolder:Sprite;
		
		private var checkBtn:Sprite;
		
		public function SwatchesSubmenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.color2); graphics.drawRect(0, 0,sW*0.2, sW*0.2); graphics.endFill();
			
			
			swatchHolder = new Sprite();
			changeSwatch("Snow");
			addChild(swatchHolder);
			
			checkBtn = new CheckIcon();
			checkBtn.scaleX = checkBtn.scaleY = (sH * 0.083 / 50);
			
			
			var sp:Sprite = new Sprite;
			sp.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.backColor); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sW * 0.05); sp.graphics.endFill();
			var sp2:Sprite = new MoveLayerIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp.width / 2;
			sp2.y = sp.height / 2;
			sp.addChild(sp2);
			sp.y = sW*0.15;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				startDrag(false,new Rectangle(0,0,sW-width,sH-height/2));
			});
			sp.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				stopDrag();
			});
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp.graphics.beginFill(CustomUI.backColor); 
			sp.graphics.drawRect(0, 0, sW * 0.1, sW * 0.05); sp.graphics.endFill();
			sp2 = new FileIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp.width / 2;
			sp2.y = sp.height / 2;
			sp.addChild(sp2);
			sp.x = sW*0.1;
			sp.y = sW*0.15;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, changeFolder);
			
		}
		
		private function changeFolder(e:MouseEvent):void 
		{
			var holder:Sprite = new Sprite();
			holder.graphics.beginFill(CustomUI.backColor); 
			holder.graphics.drawRect(0, 0, sW, sH);
			holder.graphics.endFill();
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			var textField:TextField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Select swatch folder";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW/2 - textField.width/2;
			textField.y = 0;
			holder.addChild(textField);
			
			var sp:Sprite = new Sprite;
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
			holder.addChild(sp);
			sp.x = sW/2 - sp.width/2;
			sp.y = sH - sp.height*2;
			
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 1; BackBoard.instance.removeChild(holder); } );
			
			var folders:Sprite;
			var swatchNames:Array = Swatches.SwatchNames;
			for(var i:int = 0;i<swatchNames.length;i++)
			{
				sp = new Sprite;
				sp.name = swatchNames[i];
				sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = swatchNames[i];
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				holder.addChild(sp);
				
				sp.x = sW; sp.y = ((sH * 0.13) * int(i / 6)) + sH * 0.33;
				TweenLite.to(sp, 1, { x: ((sW * 0.16) * (i % 6)) + sW * 0.01 , ease:Strong.easeOut } );
				
				sp.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { 
					BackBoard.instance.removeChild(holder);
					changeSwatch(String((e.currentTarget as Sprite).name));
					}
				);
			}
			
			BackBoard.instance.addChild(holder);
			
			/*customSlider = new CustomSlider("", Preset.folderNames.indexOf(Preset.currentFolder[0][0]), 0, Preset.folderNames.length - 1, Preset.folderNames);
			addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateNameChange);*/
		}
		
		private function changeSwatch(swatchName:String):void
		{
			var swatches:Array = Swatches.getSwatchColors(swatchName);
			
			swatchHolder.removeChildren();
			var sp1:Sprite;
			for (var i:int = 0; i < swatches.length; i++)
			{
				sp1 = new Sprite;
				sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1);
				sp1.graphics.beginFill(swatches[i]);
				sp1.graphics.drawRect(0, 0, sW * 0.05, sW*0.05); sp1.graphics.endFill();
				sp1.name = String(i);
				
				sp1.x = (sW * 0.05 * int(i%4));
				sp1.y = sW*0.05 * int(i/4);
				swatchHolder.addChild(sp1);
				sp1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					var sp:Sprite = e.currentTarget as Sprite;
					checkBtn.x = sp.width/2;
					checkBtn.y = sp.height/2;
					sp.addChild(checkBtn);
					
					ToolManager.fillColor = swatches[int(sp.name)];
				});
			}
		}
	}
}