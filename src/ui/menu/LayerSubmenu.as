package ui.menu 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import layers.setups.LayerList;
	import layers.setups.LayerSetup;
	import settings.CustomUI;
	import settings.Prefrences;
	import settings.System;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LayerSubmenu extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var layerList:LayerList;
		
		private var txtFormat:TextFormat;
		private var indicator:Sprite;
		private var layerHolder:Sprite;
		private var selectedLayer:Sprite;
		
		private var customSlider:CustomSlider;
		private var timer:Timer;
		private var pressedForSec:Boolean = false;
		private var oldX:Number;
		private var layerSetup:LayerSetup;
		private var tempStage:Stage;
		private var drawerLine:Sprite;
		
		public function LayerSubmenu() 
		{
			layerList = LayerList.instance;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var sp1:Sprite; var sp2:Sprite;
			var cT:ColorTransform;
			var typeTxt:TextField;
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			indicator = new Sprite;
			indicator.graphics.beginFill(CustomUI.color2);
			indicator.graphics.drawRect(0, 0, sW * 0.146, sH * 0.0167);
			//indicator.x = sW * 0.146 - sH * 0.034;
			indicator.y = sH * 0.207 - indicator.height;
			
			layerHolder = new Sprite;
			//layerHolder.graphics.beginFill(CustomUI.color2); 
			//layerHolder.graphics.drawRect(0, 0, sW * 0.8, sH * 0.207); layerHolder.graphics.endFill();
			generateLayers();
			addChild(layerHolder);
			layerHolder.x = sW * 0.1 * 3;
			layerHolder.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {if(layerHolder.width>sW*0.801 && !pressedForSec) layerHolder.startDrag(false, new Rectangle(sW-layerHolder.width-sW*0.1, 0, layerHolder.width -sW*0.7+sW*0.1, 0)); } );
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { layerHolder.stopDrag()} );
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0,0,sW * 0.1, sH * 0.207); sp1.graphics.endFill();
			sp2 = new SettingsIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK, createLayerSetup);
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2);
			sp1.graphics.drawRect(0,0,sW * 0.1, sH * 0.207); sp1.graphics.endFill();
			sp2 = new VisibleIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			addChild(sp1);
			sp1.x = sW * 0.1;
			sp1.addEventListener(MouseEvent.CLICK, visibleHandler);
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0, 0, sW * 0.1, sH * 0.207); sp1.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.6;
			typeTxt = new TextField;typeTxt.embedFonts = true;
			typeTxt.defaultTextFormat = txtFormat;
			typeTxt.text = "O";
			typeTxt.selectable = false;
			typeTxt.autoSize = TextFieldAutoSize.CENTER;
			typeTxt.x = sp1.width / 2 - typeTxt.width / 2; typeTxt.y = sp1.height / 2 - typeTxt.height / 2;
			sp1.addChild(typeTxt);
			addChild(sp1);
			sp1.x = sW * 0.2;
			sp1.addEventListener(MouseEvent.CLICK, opacityHandler);
			
			var dropShadow:DropShadowFilter = new DropShadowFilter;
			dropShadow.angle = 0; dropShadow.quality = 3;
			sp1.filters = [dropShadow];
			
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2);
			sp1.graphics.drawRect(0,0,sW * 0.1, sH * 0.207); sp1.graphics.endFill();
			sp2 = new PlusIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			addChild(sp1);
			sp1.x = sW - sW * 0.1;
			sp1.addEventListener(MouseEvent.CLICK, newLayerHandler);
			
			dropShadow.angle = 180; dropShadow.quality = 3;
			sp1.filters = [dropShadow];
			
			drawerLine = new Sprite;
			drawerLine.graphics.lineStyle(sW * 0.0025, CustomUI.color1); 
			drawerLine.graphics.moveTo(0, sH * 0.207); drawerLine.graphics.lineTo(sW, sH * 0.207);
			addChild(drawerLine);
		}
		
		private function generateLayers():void 
		{
			var bg:Sprite;
			var bmp:Bitmap;
			var bd:BitmapData;
			var matrix:Matrix = new Matrix();
			var i:int = 0;
			var sf:Number = 1;
			var w:int = System.canvasWidth; 
			var h:int = System.canvasHeight;
			var nameTxt:TextField;
			
			clearLayerHolder();
			
			while (h*sf > sH * 0.207 || w*sf > sW * 0.146)
			{
				sf -= 0.01;
			}
			matrix.scale(sf, sf);
			
			var LO:Object = layerList.headObject();
			while (LO != null)
			{
				if (Prefrences.layerPreview) 
				{
					bg = new Sprite;
					createCheckBoxes(bg,LO);
					bg.name = LO.name;
					
					bd = new BitmapData(LO.bitmap.bitmapData.width * sf, LO.bitmap.bitmapData.height * sf, false, 0xFFFFFF);
					bd.draw(LO.bitmap.bitmapData, matrix, null, null, null, true);
					
					bmp = new Bitmap(bd, "never", true);
					bmp.x = bg.width / 2 - bmp.width / 2;
					bg.addChild(bmp);
					
					bg.x = i * sW * 0.146;
					layerHolder.addChild(bg);
				}
				else
				{
					bg = new Sprite;
					createCheckBoxes(bg,LO);
					bg.name = LO.name;
					
					txtFormat.color = CustomUI.color1;
					txtFormat.size = sH * 0.083 * 0.4;
					nameTxt = new TextField;nameTxt.embedFonts = true;
					nameTxt.defaultTextFormat = txtFormat;
					nameTxt.text = String(LO.name);
					nameTxt.selectable = false;
					nameTxt.autoSize = TextFieldAutoSize.CENTER;
					nameTxt.background = true;
					nameTxt.backgroundColor = CustomUI.color2;
					nameTxt.x = bg.width / 2 - nameTxt.width / 2; nameTxt.y = bg.height / 2 - nameTxt.height / 2;
					bg.addChild(nameTxt);
					
					bg.x = i * sW * 0.146;
					layerHolder.addChild(bg);
				}
				
				if (pressedForSec && LO == layerList.currentLayerObject)
				{
					bg.alpha = 0.5;
					selectedLayer = bg;
				}
				
				bg.addEventListener(MouseEvent.CLICK, setCurrentLayer);
				bg.addEventListener(MouseEvent.MOUSE_DOWN, onLayerPressed);
				bg.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void { timer.stop(); timer.reset(); } );
				
				if (LO == layerList.currentLayerObject)
				{
					bg.addChild(indicator);
					selectedLayer = bg;
				}
				
				LO = LO.back;
				i++;
			}
			
			layerHolder.graphics.clear();
			layerHolder.graphics.beginFill(CustomUI.color2);
			var width:Number = layerHolder.width > sW * 0.8?layerHolder.width:sW * 0.8;
			layerHolder.graphics.drawRect(0, 0, width, sH * 0.207); layerHolder.graphics.endFill();
			
			System.updateCanvas();
		}
		
		private function onLayerPressed(e:MouseEvent):void 
		{
			selectedLayer = e.currentTarget as Sprite;
			oldX = mouseX; 
			timer.start();
			layerList.currentLayerObject = layerList.getLayerByName(String(e.currentTarget.name));
			e.currentTarget.addChild(indicator);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onLayerDraged);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onLayerDraged); 
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			pressedForSec = false; 
			if (selectedLayer)
				selectedLayer.alpha = 1;
		}
		
		private function onLayerDraged(e:MouseEvent):void 
		{
			if (pressedForSec)
			{
				if (mouseX - oldX > selectedLayer.width && layerList.currentLayerObject!= layerList.tailObject())
				{
					layerList.pick(layerList.currentLayerObject);
					layerList.move("down");
					layerList.drop();
					generateLayers();
					oldX = mouseX;
				}
				else if (oldX - mouseX > selectedLayer.width && layerList.currentLayerObject!= layerList.headObject())
				{
					layerList.pick(layerList.currentLayerObject);
					layerList.move("up");
					layerList.drop();
					generateLayers();
					oldX = mouseX;
				}
			}
			else if (Math.abs(oldX - mouseX) > 20)
			{
				timer.stop()
				timer.reset();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onLayerDraged);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				
			}
		}
		
		private function setCurrentLayer(e:MouseEvent):void 
		{
			layerList.currentLayerObject = layerList.getLayerByName(String(e.currentTarget.name));
			e.currentTarget.addChild(indicator);
			timer.stop(); 
			timer.reset();
			pressedForSec = false;
			selectedLayer.alpha = 1;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onLayerDraged);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function createLayerSetup(e:MouseEvent):void 
		{
			layerSetup = new LayerSetup(returnLayerSetup);
			BackBoard.instance.addChild(layerSetup);
			tempStage = stage; 
		}
		
		private function returnLayerSetup():void 
		{
			BackBoard.instance.removeChild(layerSetup);
		}
		
		private function visibleHandler(e:MouseEvent):void 
		{
			layerList.currentLayerObject.bitmap.visible = !layerList.currentLayerObject.bitmap.visible;
			
			createCheckBoxes(selectedLayer,layerList.currentLayerObject);
		}
		
		private function createCheckBoxes(sp:Sprite,layerObject:Object):void 
		{
			if (layerObject.bitmap.visible)
			{
				sp.graphics.clear();
				
				sp.graphics.lineStyle(sW * 0.001, CustomUI.color1); 
				
				if (Prefrences.layerPreview) 
				{
					sp.graphics.beginFill(CustomUI.backColor); 
				}
				else
				{
					sp.graphics.beginFill(layerObject.color); 
				}
				
				sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.207);
			}
			else
			{
				var bool:Boolean = true;
				sp.graphics.lineStyle(0, 0xFFFFFF);
				
				for (var i:int=0; i < 3; i++)
				{
					for (var j:int=0; j < 9; j++)
					{
						if (bool)
							sp.graphics.beginFill(0xC0C0C0);
						else
							sp.graphics.beginFill(0xFFFFFF);
						
						sp.graphics.drawRect(j*sW * 0.0163, i*sH * 0.069, sW * 0.0163, sH * 0.069);
						bool = !bool;
					}
				}
				
				sp.graphics.endFill();
				
				sp.graphics.lineStyle(sW * 0.001, CustomUI.color1);
				sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083);
				
			}
		}
		
		private function opacityHandler(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("Layer Opacity", layerList.currentLayerObject.bitmap.alpha*100, 0, 100);
			BackBoard.instance.addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			(this.parent as Menu).deactivateTweenOut();
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			layerList.currentLayerObject.bitmap.alpha = customSlider.value / 100;
			(this.parent as Menu).activeTweenOut();
			BackBoard.instance.removeChild(customSlider);
		}
		
		private function newLayerHandler(e:MouseEvent):void 
		{
			layerList.initNewLayer(System.canvasWidth, System.canvasHeight);
			generateLayers();
		}
		
		private function clearLayerHolder():void 
		{
			while (layerHolder.numChildren > 0)
			{
				layerHolder.removeChildAt(0);
			}
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			timer.stop();
			timer.reset();
			oldX = mouseX;
			pressedForSec = true;
			
			selectedLayer.alpha = 0.5;
		}
		
		public function update():void
		{
			if (!Prefrences.layerPreview) return;
			
			generateLayers();
		}
		
	}

}