package layers.setups 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenNano;
	import fl.motion.AdjustColor;
	import fl.motion.Color;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import layers.history.HistoryManager;
	
	import layers.filters.FiltersManager;
	import layers.setups.LayerList;
	import colors.setups.ColorSetup;
	import settings.CustomUI;
	import colors.spectrums.Spectrum;
	import settings.System;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LayerProperties extends Sprite
	{
		private var _layerObject:Object;
		private var _canvasBitmap:Bitmap;
		
		private var nameTxt:TextField;
		private var txtFormat:TextFormat;
		
		private var opacityTxt:TextField, blendTxt:TextField, filterTxt:TextField;
		private var angleTxt:TextField, distanceTxt:TextField, strenghtTxt:TextField, blurText:TextField, qualityTxt:TextField;
		private var adjustNameTxt:TextField, adjustValueTxt:TextField;
		
		private var visibleClip:Sprite,sp:Sprite;
		private var angleClip:MovieClip, distanceClip:MovieClip, strengthClip:MovieClip; 
		private var blurClip:MovieClip; 
		private var qualityClip:MovieClip;
		
		private var addFilterBtn:Sprite, removeFilterBtn:Sprite;
		private var btnsHolder:Sprite;
		private var maskSp:Sprite;
		private var spectrumBG:Sprite;
		private var spectrumCaller:MovieClip;
		private var filterColor1:MovieClip, filterColor2:MovieClip,colorClip:MovieClip;
		
		private var customSlider:CustomSlider;
		
		private var blendArray:Array = new Array( BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT );
		private var filterArray:Array = new Array( "Inner Glow", "Outer Glow", "Inner Shadow", "Drop Shadow", "Bevel", "Tint");
		private var adjustArray:Array = new Array("Hue", "Saturation", "Contrast", "Brightness");
		private var adjustValueArray:Array = new Array(0, 0, 0, 0);
		
		private var adjustProp:int = 0;
		private	var colorFilter:AdjustColor;
		private var mColorMatrix:ColorMatrixFilter;
		private var mMatrix:Array = [];
		
		private var filterManager:FiltersManager = FiltersManager.getInstance();
		private var currentFilter:Object;
		
		private var currentPropertyClip:MovieClip;
		private var colorSetup:ColorSetup;
		
		private var tintAlpha:Number = 0.0;
		private var sW:int;
		private var sH:int;
		
		private var layerList:LayerList;
		
		public function LayerProperties(layerObject:Object) 
		{
			_layerObject = layerObject;
			_canvasBitmap = _layerObject.bitmap;
			filterManager.updateFiltersFor(_canvasBitmap);
			
			layerList = LayerList.instance;
			
			layerList.currentLayerObject = _layerObject;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			HistoryManager.pushList();
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			var tintFilter:Object = filterManager.getfilterObject(5);
			tintAlpha = layerList.currentLayerObject.tintAlpha;
			
			graphics.beginFill(CustomUI.color1);
			graphics.lineStyle(sH*0.003, CustomUI.color2);
			graphics.drawRect(0, 0, sW / 2, sH);
			graphics.endFill();
			
			nameTxt = new TextField;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH*0.083;
			txtFormat.color = CustomUI.color2;
			nameTxt.embedFonts = true;
			nameTxt.defaultTextFormat = txtFormat;
			
			nameTxt.text = _layerObject.name;
			nameTxt.width = width/2;
			nameTxt.x = sW*0.02;
			nameTxt.y = sH * 0.0167;
			nameTxt.type = TextFieldType.DYNAMIC;
			nameTxt.selectable = false;
			nameTxt.maxChars = 10;
			addChild(nameTxt);
			nameTxt.addEventListener(MouseEvent.CLICK, changeName);
			
			colorClip = new MovieClip;
			colorClip.graphics.lineStyle(sH*0.0083,CustomUI.color2,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			colorClip.graphics.beginFill(_layerObject.color);
			colorClip.graphics.drawRect(0,0, sH*0.083, sH*0.083);
			colorClip.graphics.endFill();
			colorClip.color = _layerObject.color
			colorClip.x = width - sW*0.112; colorClip.y = sH*0.0417;
			colorClip.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { colorClip.scaleX = colorClip.scaleY = 0.97; } );
			colorClip.addEventListener(MouseEvent.MOUSE_UP, addSpectrum);
			addChild(colorClip);
			
			initVisible();
			initOpacity();
			initBlend();
			initFilter();
			initAdjust();
		}
		
		private function changeName(e:MouseEvent):void 
		{
			e.currentTarget.requestSoftKeyboard();
			
			nameTxt.type = TextFieldType.INPUT;
			nameTxt.selectable = true;
			stage.focus = nameTxt;
			
			nameTxt.setSelection(nameTxt.length, nameTxt.length);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { nameTxt.type = TextFieldType.DYNAMIC; _layerObject.name = nameTxt.text; nameTxt.selectable = false; } );
		}
		
		private function changeLayerColor(color:uint):void 
		{
			_layerObject.color = color;
			colorClip.color = color;
			colorClip.graphics.clear();
			colorClip.graphics.lineStyle(sH*0.0083,CustomUI.color2,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			colorClip.graphics.beginFill(_layerObject.color);
			colorClip.graphics.drawRect(0,0, sH*0.083, sH*0.083);
			colorClip.graphics.endFill();
		}
		
		private function initVisible():void 
		{
			visibleClip = new Sprite;
			visibleClip.graphics.lineStyle(sW * 0.001, CustomUI.color1); visibleClip.graphics.beginFill(CustomUI.color2);
			visibleClip.graphics.drawRect(0, 0, sW * 0.078, sH * 0.1167); visibleClip.graphics.endFill();
			var sp2:Sprite;
			addChild(visibleClip);
			visibleClip.x = sW * 0.029;
			visibleClip.y = sH * 0.167;
			
			visibleClip.addEventListener(MouseEvent.MOUSE_UP, visiblePress);
			visibleClip.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { visibleClip.scaleX = visibleClip.scaleY = 0.97 } );
			
			if (_canvasBitmap.visible)
			{
				sp2 = new VisibleIcon;
			}
			else
			{
				sp2 = new NotVisibleIcon;
			}
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = visibleClip.width / 2;
			sp2.y = visibleClip.height / 2;
			visibleClip.addChild(sp2);
		}
		
		private function visiblePress(e:MouseEvent):void 
		{
			visibleClip.scaleX = visibleClip.scaleY = 1;
			var sp2:Sprite;
			
			if (_canvasBitmap.visible)
			{
				visibleClip.removeChildAt(0);
				sp2 = new NotVisibleIcon;
				
			}
			else
			{
				visibleClip.removeChildAt(0);
				sp2= new VisibleIcon;
			}
			
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = visibleClip.width / 2;
			sp2.y = visibleClip.height / 2;
			visibleClip.addChild(sp2);
			
			_canvasBitmap.visible = !_canvasBitmap.visible;
		}
		
		private function initOpacity():void 
		{
		 	sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.136, sH * 0.1167); sp.graphics.endFill();
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			opacityTxt = new TextField; opacityTxt.embedFonts = true;
			opacityTxt.defaultTextFormat = txtFormat;
			opacityTxt.text = "O: "+String(Math.round(_canvasBitmap.alpha * 100)) + "%";
			opacityTxt.selectable = false;
			opacityTxt.autoSize = TextFieldAutoSize.CENTER;
			opacityTxt.x = sp.width / 2 - opacityTxt.width / 2; opacityTxt.y = sp.height / 2 - opacityTxt.height / 2;
			sp.addChild(opacityTxt);
			sp.x = sW * 0.117; sp.y = sH*0.167;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, opacityPress);
		}
		
		private function opacityPress(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("Layer Opacity",_canvasBitmap.alpha*100,0,100);
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminateOpacityDrag);
		}
		
		private function terminateOpacityDrag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminateOpacityDrag);
			_canvasBitmap.alpha = Number(customSlider.value / 100);
			
			removeChild(customSlider);
			customSlider = null;
			opacityTxt.text = "O: "+String(Math.round(_canvasBitmap.alpha * 100)) + "%";
		}
		
		private function initBlend():void 
		{
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, width - sW * 0.263, sH * 0.1167); sp.graphics.endFill();
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			blendTxt = new TextField; blendTxt.embedFonts = true;
			blendTxt.defaultTextFormat = txtFormat;
			blendTxt.text = "Blend: " + _canvasBitmap.blendMode;
			blendTxt.selectable = false;
			blendTxt.autoSize = TextFieldAutoSize.CENTER;
			blendTxt.x = sp.width / 2 - blendTxt.width / 2; blendTxt.y = sp.height / 2 - blendTxt.height / 2;
			sp.addChild(blendTxt);
			sp.x = sW * 0.263; sp.y = sH*0.167;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, onblendDown);
		}
		
		private function onblendDown(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("Belnd Mode: ",blendArray.indexOf(_canvasBitmap.blendMode),0,13,blendArray);
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminateBlendDrag);
			blendTxt.text = "Blend: " + _canvasBitmap.blendMode;
		}
		
		private function terminateBlendDrag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminateBlendDrag);
			_canvasBitmap.blendMode = String(blendArray[customSlider.value]);
			
			removeChild(customSlider);
			customSlider = null;
			blendTxt.text = "Blend: " + _canvasBitmap.blendMode;
		}
		
		private function initFilter():void
		{
			graphics.lineStyle(1, CustomUI.color2); graphics.moveTo(sW*0.01, sH*0.425); graphics.lineTo(width - sW*0.01, sH*0.425);
			
			currentFilter = filterManager.getfilterObject(0);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.195, sH * 0.1167); sp.graphics.endFill();
			txtFormat.size = sH*0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			filterTxt = new TextField; filterTxt.embedFonts = true;
			filterTxt.defaultTextFormat = txtFormat;
			filterTxt.text = "Inner Glow";
			filterTxt.selectable = false;
			filterTxt.autoSize = TextFieldAutoSize.CENTER;
			filterTxt.x = sp.width / 2 - filterTxt.width / 2; filterTxt.y = sp.height / 2 - filterTxt.height / 2;
			sp.addChild(filterTxt);
			sp.x = sW * 0.029; sp.y = sH*0.367;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, onFilterDown);
			
			addFilterBtn = new Sprite;
			addFilterBtn.graphics.beginFill(CustomUI.color2); 
			addFilterBtn.graphics.drawRect(0, 0, sH * 0.067, sH * 0.067); addFilterBtn.graphics.endFill();
			
			addFilterBtn.graphics.lineStyle(sH * 0.005, CustomUI.color1, 1, false, "normal", CapsStyle.SQUARE); 
			addFilterBtn.graphics.moveTo(sW * 0.01, sH * 0.033); addFilterBtn.graphics.lineTo(sW * 0.03, sH * 0.033); 
			addFilterBtn.graphics.moveTo(sW * 0.02, sH * 0.0167); addFilterBtn.graphics.lineTo(sW * 0.02, sH * 0.05);
			
			addFilterBtn.x = sW*0.468 - addFilterBtn.width; addFilterBtn.y = sH*0.391;
			addFilterBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { addFilterBtn.scaleX = 0.93;addFilterBtn.scaleY = 0.93} );
			addFilterBtn.addEventListener(MouseEvent.MOUSE_UP, addFilter);
			
			removeFilterBtn = new Sprite;
			removeFilterBtn.graphics.beginFill(CustomUI.color2); removeFilterBtn.graphics.drawRect(0, 0, sH * 0.067, sH * 0.067); removeFilterBtn.graphics.endFill();
			removeFilterBtn.graphics.lineStyle(3, CustomUI.color1, 1, false, "normal", CapsStyle.SQUARE); 
			removeFilterBtn.graphics.moveTo(sW * 0.01, sH * 0.033); removeFilterBtn.graphics.lineTo(sW * 0.03, sH * 0.033);
			removeFilterBtn.x = sW*0.468 - removeFilterBtn.width; removeFilterBtn.y = sH * 0.391;
			removeFilterBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { removeFilterBtn.scaleX = 0.93;removeFilterBtn.scaleY = 0.93} );
			removeFilterBtn.addEventListener(MouseEvent.MOUSE_UP, removeFilter);
			
			if(!currentFilter.applied)
				addChild(addFilterBtn);
			else
				addChild(removeFilterBtn);
			
			filterColor1 = new MovieClip;
			createColor(filterColor1, currentFilter.filter.color);
			filterColor1.x = sW*0.0488; filterColor1.y = sH*0.5167;
			addChild(filterColor1);
			filterColor1.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { filterColor1.scaleX = filterColor1.scaleY = 0.97; } );
			filterColor1.addEventListener(MouseEvent.MOUSE_UP, addSpectrum);
			
			filterColor2 = new MovieClip;
			createColor(filterColor2, 0x000000);
			filterColor2.x = sW*0.0488; filterColor2.y = sH*0.633;
			filterColor2.visible = false;
			filterColor2.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { filterColor2.scaleX = filterColor2.scaleY = 0.97; } );
			filterColor2.addEventListener(MouseEvent.MOUSE_UP, addSpectrum);
			addChild(filterColor2);
			
			angleClip = new MovieClip;
			angleClip.graphics.beginFill(CustomUI.color2); angleClip.graphics.drawRect(0, 0, sW*0.117, sH*0.1); angleClip.graphics.endFill();
			angleTxt = new TextField; angleTxt.embedFonts = true;
			angleTxt.name = "Angle";
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			angleTxt.defaultTextFormat = txtFormat;
			angleTxt.text = "A: 100";
			angleTxt.selectable = false;
			angleTxt.autoSize = TextFieldAutoSize.CENTER;
			angleTxt.x = angleClip.width / 2 - angleTxt.width / 2; angleTxt.y = angleClip.height / 2 - angleTxt.height / 2;
			angleClip.addChild(angleTxt);
			angleClip.addEventListener(MouseEvent.CLICK, changeFilterProp);
			angleClip.visible = false;
			angleClip.name = "Angle"; angleClip.minVal = 0; angleClip.maxVal = 360; angleClip.prop = "angle";
			addChild(angleClip);
			angleClip.x = sW*0.137; angleClip.y = sH*0.625;
			
			distanceClip = new MovieClip;
			distanceClip.graphics.beginFill(CustomUI.color2); distanceClip.graphics.drawRect(0, 0, sW*0.117, sH*0.1); distanceClip.graphics.endFill();
			distanceTxt = new TextField; distanceTxt.embedFonts = true;
			distanceTxt.name = "Distance";
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			distanceTxt.defaultTextFormat = txtFormat;
			distanceTxt.text = "D: 100";
			distanceTxt.selectable = false;
			distanceTxt.autoSize = TextFieldAutoSize.CENTER;
			distanceTxt.x = distanceClip.width / 2 - distanceTxt.width / 2; distanceTxt.y = distanceClip.height / 2 - distanceTxt.height / 2;
			distanceClip.addChild(distanceTxt);
			distanceClip.addEventListener(MouseEvent.CLICK, changeFilterProp);
			distanceClip.visible = false;
			distanceClip.name = "Distance"; distanceClip.minVal = 0; distanceClip.maxVal = 255; distanceClip.prop = "distance";
			addChild(distanceClip);
			distanceClip.x = angleClip.x + angleClip.width + sW*0.01; distanceClip.y = angleClip.y;
			
			strengthClip = new MovieClip;
			strengthClip.graphics.beginFill(CustomUI.color2); strengthClip.graphics.drawRect(0, 0, sW*0.117, sH*0.1); strengthClip.graphics.endFill();
			strenghtTxt = new TextField; strenghtTxt.embedFonts = true;
			strenghtTxt.name = "Strength";
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			strenghtTxt.defaultTextFormat = txtFormat;
			strenghtTxt.text = "S: " + String(currentFilter.filter.strength);
			strenghtTxt.selectable = false;
			strenghtTxt.autoSize = TextFieldAutoSize.CENTER;
			strenghtTxt.x = strengthClip.width / 2 - strenghtTxt.width / 2; strenghtTxt.y = strengthClip.height / 2 - strenghtTxt.height / 2;
			strengthClip.addChild(strenghtTxt);
			strengthClip.addEventListener(MouseEvent.CLICK, changeFilterProp);
			strengthClip.name = "Strength"; strengthClip.minVal = 0; strengthClip.maxVal = 255; strengthClip.prop = "strength";
			addChild(strengthClip);
			strengthClip.x = sW*0.137 ; strengthClip.y = sH*0.508;
			
			blurClip = new MovieClip;
			blurClip.graphics.beginFill(CustomUI.color2); blurClip.graphics.drawRect(0, 0, sW*0.117, sH*0.1); blurClip.graphics.endFill();
			blurText = new TextField; blurText.embedFonts = true;
			blurText.name = "Blur";
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			blurText.defaultTextFormat = txtFormat;
			blurText.text = "B: " + String(currentFilter.filter.blurX);
			blurText.selectable = false;
			blurText.autoSize = TextFieldAutoSize.CENTER;
			blurText.x = blurClip.width / 2 - blurText.width / 2; blurText.y = blurClip.height / 2 - blurText.height / 2;
			blurClip.addChild(blurText);
			blurClip.addEventListener(MouseEvent.CLICK, changeFilterProp);
			blurClip.name = "Blur"; blurClip.minVal = 0; blurClip.maxVal = 255; blurClip.prop = "blurX";
			addChild(blurClip);
			blurClip.x = strengthClip.x + strengthClip.width + sW*0.01; blurClip.y = strengthClip.y;
			
			qualityClip = new MovieClip;
			qualityClip.graphics.beginFill(CustomUI.color2); qualityClip.graphics.drawRect(0, 0, sW*0.078, sH*0.1); qualityClip.graphics.endFill();
			qualityTxt = new TextField; qualityTxt.embedFonts = true;
			qualityTxt.name = "Quality";
			txtFormat.size = sH * 0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			qualityTxt.defaultTextFormat = txtFormat;
			qualityTxt.text = "Q: " + String(currentFilter.filter.quality);
			qualityTxt.selectable = false;
			qualityTxt.autoSize = TextFieldAutoSize.CENTER;
			qualityTxt.x = qualityClip.width / 2 - qualityTxt.width / 2; qualityTxt.y = qualityClip.height / 2 - qualityTxt.height / 2;
			qualityClip.addChild(qualityTxt);
			qualityClip.addEventListener(MouseEvent.CLICK, changeFilterProp);
			qualityClip.name = "Quality"; qualityClip.minVal = 1; qualityClip.maxVal = 3; qualityClip.prop = "quality";
			addChild(qualityClip);
			qualityClip.x = blurClip.x + blurClip.width + sW * 0.01; qualityClip.y = blurClip.y;
		}
		
		private function onFilterDown(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("",currentFilter.number,0,5,filterArray);
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminateFilterDrag);
		}
		
		private function terminateFilterDrag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminateFilterDrag);
			
			filterTxt.text = String(filterArray[customSlider.value]);
			currentFilter = filterManager.getfilterObject(customSlider.value);
			
			if (currentFilter.number == 0 || currentFilter.number == 1)
			{
				filterColor2.visible = false; angleClip.visible = false; distanceClip.visible = false; 
				
				strenghtTxt.text = "S: " + String(currentFilter.filter.strength);
				blurText.text = "B: " + String(currentFilter.filter.blurX);
				qualityTxt.text = "Q: " + String(currentFilter.filter.quality);
				
				createColor(filterColor1, currentFilter.filter.color);
				blurClip.visible = true; qualityClip.visible = true;
			}
			else if (currentFilter.number == 2 || currentFilter.number == 3)
			{
				filterColor2.visible = false; 
				
				strenghtTxt.text = "S: " + String(currentFilter.filter.strength);
				angleTxt.text = "A: " + String(currentFilter.filter.angle);
				distanceTxt.text = "D: " + String(currentFilter.filter.distance);
				blurText.text = "B: " + String(currentFilter.filter.blurX);
				qualityTxt.text = "Q: " + String(currentFilter.filter.quality);
				createColor(filterColor1, currentFilter.filter.color);
				angleClip.visible = true; distanceClip.visible = true; blurClip.visible = true; qualityClip.visible = true;
			}
			else if (currentFilter.number == 4)
			{
				filterColor2.visible = true; 
				
				strenghtTxt.text = "S: " + String(currentFilter.filter.strength);
				angleTxt.text = "A: " + String(currentFilter.filter.angle);
				distanceTxt.text = "D: " + String(currentFilter.filter.distance);
				blurText.text = "B: " + String(currentFilter.filter.blurX);
				qualityTxt.text = "Q: " + String(currentFilter.filter.quality);
				createColor(filterColor1, currentFilter.filter.highlightColor);
				createColor(filterColor2, currentFilter.filter.shadowColor);
				angleClip.visible = true; distanceClip.visible = true; blurClip.visible = true; qualityClip.visible = true;
			}
			else if (currentFilter.number == 5)
			{
				blurClip.visible = false; qualityClip.visible = false;
				filterColor2.visible = false; angleClip.visible = false; distanceClip.visible = false;
				strenghtTxt.text = "S: " + String(Math.round(tintAlpha * 100));
				createColor(filterColor1, layerList.currentLayerObject.tintColor);
			}
			
			if (currentFilter.applied)
			{
				if (addFilterBtn.stage)	removeChild(addFilterBtn);
				addChild(removeFilterBtn);
			}
			else
			{
				if (removeFilterBtn.stage)	removeChild(removeFilterBtn);
				addChild(addFilterBtn);
			}
			
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function createColor(clip:MovieClip, color:uint):void 
		{
			color = uint("0x" + color.toString(16));
			clip.graphics.clear();
			clip.graphics.lineStyle(sH*0.0083,CustomUI.color2,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			clip.graphics.beginFill(color);
			clip.graphics.drawRect(0,0, sH*0.083, sH*0.083);
			clip.graphics.endFill();
			clip.color = color;
		}
		
		private function changeColor1(color:uint):void 
		{
			if (currentFilter.number == 0 || currentFilter.number == 1 || currentFilter.number == 2 || currentFilter.number == 3)
			{
				currentFilter.filter.color = color;
				if (currentFilter.applied)
				{
					filterManager.remove(_canvasBitmap, currentFilter.filter);
					filterManager.add(_canvasBitmap, currentFilter.filter);
				}
			}
			else if (currentFilter.number == 4)
			{
				currentFilter.filter.highlightColor = color;
				if (currentFilter.applied)
				{
					filterManager.remove(_canvasBitmap, currentFilter.filter);
					filterManager.add(_canvasBitmap, currentFilter.filter);
				}
			}
			else if (currentFilter.number == 5)
			{
				layerList.currentLayerObject.tintColor = color;
				if (currentFilter.applied)
				{
					var color1:Color = new Color;
					color1.setTint(color, tintAlpha);
					
					layerList.currentLayerObject.tintColor = filterColor1.color;
					layerList.currentLayerObject.tintAlpha = tintAlpha;
					
					_canvasBitmap.transform.colorTransform = color1;
				}
			}
			
			createColor(filterColor1, color);
		}
		
		private function changeColor2(color:uint):void 
		{
			createColor(filterColor2, color);
			currentFilter.filter.shadowColor = color;
			if (currentFilter.applied)
			{
				filterManager.remove(_canvasBitmap, currentFilter.filter);
				filterManager.add(_canvasBitmap, currentFilter.filter);
			}
		}
		
		private function changeFilterProp(e:MouseEvent):void 
		{
			currentPropertyClip = e.currentTarget as MovieClip;
			if(currentFilter.number <5)
				customSlider = new CustomSlider(e.currentTarget.name, currentFilter.filter[currentPropertyClip.prop], e.currentTarget.minVal, e.currentTarget.maxVal);
			else
				customSlider = new CustomSlider("Strenght", tintAlpha*100, 0, 100);
			
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminateFilterPropDrag);
		}
		
		private function terminateFilterPropDrag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminateFilterPropDrag);
			
			if (currentFilter.number < 5)
			{
				currentFilter.filter[currentPropertyClip.prop] = customSlider.value;
				
				var tempTxt:TextField = currentPropertyClip.getChildByName(String(currentPropertyClip.name)) as TextField;
				tempTxt.text = String(currentPropertyClip.name.charAt(0)+": "+customSlider.value);
				
				if(currentPropertyClip.prop == "blurX") 	currentFilter.filter["blurY"] = customSlider.value;
				
				if (currentFilter.applied)
				{
					filterManager.remove(_canvasBitmap, currentFilter.filter);
					filterManager.add(_canvasBitmap, currentFilter.filter);
				}
			}
			else
			{
				tintAlpha = customSlider.value / 100;
				strenghtTxt.text = "S: " + customSlider.value;
				if (currentFilter.applied)
				{
					var color:Color = new Color;
					color.setTint(filterColor1.color, tintAlpha);
					
					layerList.currentLayerObject.tintColor = filterColor1.color;
					layerList.currentLayerObject.tintAlpha = tintAlpha;
					
					_canvasBitmap.transform.colorTransform = color;
				}
			}
			
			removeChild(customSlider);
			customSlider = null;
			
		}
		
		private function addFilter(e:MouseEvent):void 
		{
			removeChild(addFilterBtn);
			addChild(removeFilterBtn);
			
			removeFilterBtn.scaleX = 1; removeFilterBtn.scaleY = 1;
			currentFilter.applied = true;
			
			if (currentFilter.number < 5)
				filterManager.add(_canvasBitmap, currentFilter.filter);
			else
			{
				var color:Color = new Color;
				color.setTint(filterColor1.color, tintAlpha);
				
				layerList.currentLayerObject.tintColor = filterColor1.color;
				layerList.currentLayerObject.tintAlpha = tintAlpha;
				
				_canvasBitmap.transform.colorTransform = color;
			}
		}
		
		private function removeFilter(e:MouseEvent):void 
		{
			removeChild(removeFilterBtn);
			addChild(addFilterBtn);
			
			addFilterBtn.scaleX = 1; addFilterBtn.scaleY = 1;
			currentFilter.applied = false;
			
			if (currentFilter.number < 5)
				filterManager.remove(_canvasBitmap, currentFilter.filter);
			else
			{
				var color:Color = new Color;
				color.setTint(filterColor1.color, 0);
				
				layerList.currentLayerObject.tintColor = filterColor1.color;
				layerList.currentLayerObject.tintAlpha = 0;
				
				_canvasBitmap.transform.colorTransform = color;
			}
		}
		
		private function initAdjust():void 
		{
			graphics.lineStyle(1, CustomUI.color2); graphics.moveTo(sW*0.01, sH*0.875); graphics.lineTo(width - sW*0.01, sH*0.875);
			
			colorFilter = new AdjustColor;
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.195, sH * 0.1167); sp.graphics.endFill();
			txtFormat.size = sH*0.083 * 0.6;
			txtFormat.color = CustomUI.color1;
			adjustNameTxt = new TextField; adjustNameTxt.embedFonts = true;
			adjustNameTxt.defaultTextFormat = txtFormat;
			adjustNameTxt.text = "Hue";
			adjustNameTxt.selectable = false;
			adjustNameTxt.autoSize = TextFieldAutoSize.CENTER;
			adjustNameTxt.x = sp.width / 2 - adjustNameTxt.width / 2; adjustNameTxt.y = sp.height / 2 - adjustNameTxt.height / 2;
			sp.addChild(adjustNameTxt);
			sp.x = sW * 0.029; sp.y = sH*0.817;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, On_AN_Press);
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.1, sH * 0.067); sp.graphics.endFill();
			txtFormat.size = sH*0.083 * 0.5;
			txtFormat.color = CustomUI.color1;
			adjustValueTxt = new TextField;adjustValueTxt.embedFonts = true;
			adjustValueTxt.defaultTextFormat = txtFormat;
			adjustValueTxt.text = "0";
			adjustValueTxt.selectable = false;
			adjustValueTxt.autoSize = TextFieldAutoSize.CENTER;
			adjustValueTxt.x = sp.width / 2 - adjustValueTxt.width / 2; adjustValueTxt.y = sp.height / 2 - adjustValueTxt.height / 2;
			sp.addChild(adjustValueTxt);
			sp.x = sW*0.468 - sp.width; sp.y = sH*0.85;
			addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, On_AV_Press);
			
		}
		
		private function On_AN_Press(e:MouseEvent):void 
		{
			customSlider = new CustomSlider("",adjustProp,0,3,adjustArray);
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminate_AN_Drag);
		}
		
		private function terminate_AN_Drag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminate_AN_Drag);
			
			adjustProp = customSlider.value;
			removeChild(customSlider);
			customSlider = null;
			
			adjustNameTxt.text = String(adjustArray[adjustProp]);
			adjustValueTxt.text = String(adjustValueArray[adjustProp]);
		}
		
		private function On_AV_Press(e:MouseEvent):void 
		{
			if(adjustProp == 0)
				customSlider = new CustomSlider("Value", adjustValueArray[adjustProp], -180, 180);
			else
				customSlider = new CustomSlider("Value", adjustValueArray[adjustProp], -100, 100);
			
			addChild(customSlider);
			customSlider.x = - System.stageWidth / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, terminate_AV_Drag);
		}
		
		private function terminate_AV_Drag(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, terminate_AV_Drag);
			filterManager.remove(_canvasBitmap, mColorMatrix, true);
			
			adjustValueArray[adjustProp] = customSlider.value;
			adjustValueTxt.text = String(customSlider.value);
			
			removeChild(customSlider);
			customSlider = null;
			
			colorFilter.hue = adjustValueArray[0]== 0?1:adjustValueArray[0];
			colorFilter.saturation = adjustValueArray[1]== 0?1:adjustValueArray[1];
			colorFilter.contrast = adjustValueArray[2]== 0?1:adjustValueArray[2];
			colorFilter.brightness = adjustValueArray[3]== 0?1:adjustValueArray[3];
		 
			mMatrix = colorFilter.CalculateFinalFlatArray();
			mColorMatrix = new ColorMatrixFilter(mMatrix);
			
			filterManager.add(_canvasBitmap, mColorMatrix);
		}
		
		public function checkForChange():void
		{
			for each(var val:int in adjustValueArray)
			{
				if (val != 0)
				{
					filterManager.remove(_canvasBitmap, mColorMatrix);
					break;
				}
			}
		}
		
		private function addSpectrum(e:MouseEvent):void
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			spectrumCaller = e.currentTarget as MovieClip;
			
			spectrumBG = new Sprite;
			spectrumBG.graphics.beginFill(0, 0); spectrumBG.graphics.drawRect(0, 0, sW, sH);
			addChild(spectrumBG);
			spectrumBG.x = - sW / 2;
			//spectrumBG.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { removeChild(btnsHolder); removeChild(maskSp); removeChild(spectrumBG); } );
			
			btnsHolder = new Sprite;
			
			var spectrum:Bitmap = Spectrum.linearSpectrum;
			var spectrumHolder:Sprite = new Sprite;
			spectrumHolder.addChild(spectrum);
			spectrumHolder.x = sH * 0.083;
			spectrumHolder.width = sW * 0.244;
			spectrumHolder.height = sH * 0.083;
			spectrumHolder.addEventListener(MouseEvent.MOUSE_DOWN, onSpectrumDown);
			btnsHolder.addChild(spectrumHolder);
			
			var sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2);
			sp1.graphics.drawRect(0,0,sH * 0.083, sH * 0.083); sp1.graphics.endFill();
			var sp2:Sprite = new PlusIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			addChild(sp1);
			sp1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { colorSetup = new ColorSetup(spectrumCaller.color, csExitHandler); BackBoard.instance.addChild(colorSetup); removeChild(btnsHolder); removeChild(maskSp); removeChild(spectrumBG); } );
			btnsHolder.addChild(sp1);
			
			btnsHolder.x = e.currentTarget.x;
			btnsHolder.y = e.currentTarget.y;
			
			maskSp = new Sprite;
			maskSp.graphics.beginFill(0, 1); maskSp.graphics.drawRect(0, 0, btnsHolder.width + sW*0.01, btnsHolder.height);
			maskSp.x = e.currentTarget.x - btnsHolder.width - sW*0.01;
			maskSp.y = e.currentTarget.y;
			addChild(maskSp);
			btnsHolder.mask = maskSp;
			
			addChild(btnsHolder);
			
			var tween:TweenNano = new TweenNano(btnsHolder, 0.5, { x:e.currentTarget.x - btnsHolder.width - sW*0.01, ease:Strong.easeOut } );
			
		}
		
		private function onSpectrumDown(e:MouseEvent):void 
		{
			e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, onSpectrumMove);
		}
		
		private function onSpectrumMove(e:MouseEvent):void 
		{
			var spectrum:Bitmap = e.currentTarget.getChildAt(0) as Bitmap;
			
			var color:uint = uint("0x" + spectrum.bitmapData.getPixel(spectrum.mouseX, spectrum.mouseY).toString(16));
			
			if (spectrumCaller == filterColor1)
				changeColor1(color);
			else if (spectrumCaller == filterColor2)
				changeColor2(color);
			else if (spectrumCaller == colorClip)
				changeLayerColor(color);
			
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onSpectrumDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSpectrumUP);
		}
		
		private function onSpectrumUP(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSpectrumUP);
			
			removeChild(btnsHolder); 
			removeChild(maskSp); 
			removeChild(spectrumBG);
		}
		
		private function csExitHandler():void 
		{
			var color:uint = colorSetup.color;
			BackBoard.instance.removeChild(colorSetup);
			
			if (spectrumCaller == filterColor1)
				changeColor1(color);
			else if (spectrumCaller == filterColor2)
				changeColor2(color);
			else if (spectrumCaller == colorClip)
				changeLayerColor(color);
		}
		
	}
}