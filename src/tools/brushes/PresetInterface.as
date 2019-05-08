package tools.brushes 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.setups.LayerList;
	import settings.CustomUI;
	import settings.System;
	import utils.taskLoader.TaskLoader;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class PresetInterface extends Sprite
	{
		private var brush:BrushData;
		private var _bdArray:Array;
		private var sW:int;
		private var sH:int;
		private var txtFormat:TextFormat;
		private var checkBox:Sprite;
		private var customSlider:CustomSlider;
		
		private var holder:Sprite;
		private var bmHolder:Sprite;
		private var folderName:TextField;
		private var taskLoader:TaskLoader;
		private var dummySp:Sprite;
		
		public function PresetInterface() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			brush = BrushData.instance;
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			
			/*var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x000000, 0);
			bg.graphics.drawRect(0, 0, sW, sH);
			addChild(bg);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, removeMe );*/
			
			checkBox = new Sprite();
			checkBox.graphics.beginFill(0x0000FF, 1);
			checkBox.graphics.drawRect(0, 0, sW * 0.025, sW * 0.025);
			
			holder = new Sprite();
			//holder.graphics.lineStyle(sW*0.01, CustomUI.color2);
			holder.graphics.beginFill(CustomUI.color1, 1);
			holder.graphics.drawRect(0, 0, sW * 0.2, sH - (sW * 0.2));
			addChild(holder);
			//holder.x = sW * 0.4;
			//holder.y = sW * 0.2;
			//holder.alpha = 0.3;
			
			dummySp = new Sprite();
			dummySp.graphics.beginFill(0x000000, 0);
			dummySp.graphics.drawRect(0, 0, sW * 0.20, sH - (sW * 0.2));
			
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.096, sH * 0.083); sp.graphics.endFill();
			var sp2:Sprite = new FileIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp.width / 2;
			sp2.y = sp.height / 2;
			sp.addChild(sp2);
			sp.x = holder.width - sp.width - sW * 0.002; sp.y = sH * 0.0083;
			holder.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, changeFolder );
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); sp.graphics.endFill();
			sp2 = new NotVisibleIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp.width / 2;
			sp2.y = sp.height / 2;
			sp.addChild(sp2);
			sp.x = sW * 0.002;
			sp.y = sH*0.0083;
			holder.addChild(sp);
			sp.addEventListener(MouseEvent.CLICK, hide);
			
			//TweenLite.to(holder, 0.2, { y:(sW * 0.2), alpha:1 , ease:Linear.easeOut,onComplete:loadPreset } );
			
			loadPreset();
		}
		
		private function hide(e:MouseEvent):void
		{
			removeChild(holder);
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(CustomUI.color2); sp.graphics.drawRect(0, 0, sW * 0.05, sH * 0.083); sp.graphics.endFill();
			var sp2:Sprite = new VisibleIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			var cT:ColorTransform = new ColorTransform();
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp.width / 2;
			sp2.y = sp.height / 2;
			sp.addChild(sp2);
			sp.x = sW * 0.002;
			sp.y = sH*0.0083;
			this.addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, show );
		}
		
		private function show(e:MouseEvent):void
		{
			this.removeChildren();
			
			this.addChild(holder);
		}
		
		private function loadPreset():void 
		{
			holder.addChild(dummySp);
			
			taskLoader = new TaskLoader;
			taskLoader.container = dummySp;
			taskLoader.width = dummySp.width;
			taskLoader.height = dummySp.height;
			taskLoader.message = "Loding Presets\n\nPlease Wait...";
			taskLoader.applyProgressEvent = false;
			taskLoader.addEventListener(TaskLoader.TASK_COMPLETE, function (e:Event) { holder.removeChild(dummySp); } );
			
			taskLoader.wrap(drawBMs);
		}
		
		private function drawBMs():void
		{
			if (bmHolder)
			{
				holder.removeChildAt(2);
				var dO:DisplayObject
				for (var j:int = 0; j < bmHolder.numChildren; j++)
				{
					dO = bmHolder.getChildAt(j);
					bmHolder.removeChild(dO);
					dO = null;
				}
			}
			
			bmHolder = new Sprite;
			
			createBDs(Preset.currentFolder);
			
			var bm:Bitmap; var tempSp:Sprite;
			for (var i:int = 0; i < _bdArray.length; i++)
			{
				bm = new Bitmap(_bdArray[i]);
				
				tempSp = new Sprite();
				tempSp.name = String(i);
				tempSp.addChild(bm);
				tempSp.x = sW*0.005;//(i % 2) * (bm.width + sW * 0.002);
				tempSp.y = i * (bm.height + sH * 0.0034);
				tempSp.addEventListener(MouseEvent.CLICK, changeSettings);
				
				bmHolder.addChild(tempSp);
				
				if (i == Preset.currnentBrush)
					tempSp.addChild(checkBox);
			}
			
			var maskSp:Sprite = new Sprite();
			maskSp.graphics.beginFill(0x000000, 1);
			maskSp.graphics.drawRect(0, 0, sW * 0.2, sH * 0.635);
			maskSp.graphics.endFill();
			maskSp.y = sH * 0.1;
			holder.addChild(maskSp);
			
			bmHolder.y = sH * 0.1;
			bmHolder.mask = maskSp;
			
			var heightDiff:Number =  bmHolder.height - (maskSp.height/1.25);
			var dragY:Number = bmHolder.y - heightDiff;
			
			bmHolder.addEventListener(MouseEvent.MOUSE_DOWN, 
			function(e:MouseEvent):void 
			{ 
				if (bmHolder.height <= maskSp.height) return;
				
				bmHolder.startDrag(false, new Rectangle( 
															e.currentTarget.x, 
															dragY, 
															0, 
															heightDiff
															)
									); 
			} );
			
			stage.addEventListener(MouseEvent.MOUSE_UP,stopHolderDrag);
			
			holder.addChild(bmHolder);
		}
		
		private function stopHolderDrag(e:MouseEvent):void 
		{
			bmHolder.stopDrag();
		}
		
		private function changeFolder(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			if (Preset.folderNames.length == 1)
				return;
			
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
			textField.text = "Select custom brush folder";
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
			for(var i:int = 0;i<Preset.folderNames.length;i++)
			{
				sp = new Sprite;
				sp.name = String(i);
				sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = Preset.folderNames[i];
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				holder.addChild(sp);
				
				sp.x = sW; sp.y = ((sH * 0.13) * int(i / 6)) + sH * 0.33;
				TweenLite.to(sp, 1, { x: ((sW * 0.16) * (i % 6)) + sW * 0.01 , ease:Strong.easeOut } );
				
				sp.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void { 
					BackBoard.instance.removeChild(holder);
					terminateNameChange(int((e.currentTarget as Sprite).name));
					}
				);
			}
			
			BackBoard.instance.addChild(holder);
			
			/*customSlider = new CustomSlider("", Preset.folderNames.indexOf(Preset.currentFolder[0][0]), 0, Preset.folderNames.length - 1, Preset.folderNames);
			addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateNameChange);*/
		}
		
		private function terminateNameChange(index:int):void 
		{
			//customSlider.removeEventListener(MouseEvent.MOUSE_UP, terminateNameChange);
			
			//var index:int = customSlider.value;
			
			//folderName.text = Preset.folderNames[index];
			
			Preset.setCurrentFolder(index);
			Preset.currnentBrush = 0;
			setBrushData(Preset.currentFolder[0]);
			
			//removeChild(customSlider);
			//customSlider = null;
			
			loadPreset();
		}
		
		private function createToolSetting(e:MouseEvent):void 
		{
			Preset.currnentBrush = -1;
			BackBoard.instance.addChild(new BrushSettings);
			remove();
		}
		
		private function createBDs(folderArray:Array):void 
		{
			var dummySp:Sprite = new Sprite();
			addChild(dummySp);
			var tool:BrushTool = BrushTool.instance;
			
			var oldData:Array = new Array("folderName",
										  "brushName",
										  brush.type,
										  brush.brushIndex,
										  brush.size,
										  brush.flow,
										  brush.smoothness,
										  brush.pressureSensivity,
										  brush.spacing,
										  brush.alpha,
										  brush.xSymmetry,
										  brush.ySymmetry,
										  brush.randomRotate,
										  brush.scattering,
										  brush.randomColor
			);
			
			txtFormat.size = sW * 0.0175;
			txtFormat.color = 0x0000FF;
			
			var textField:TextField;
			
			if (_bdArray)
			{
				for each(var bitData:BitmapData in _bdArray)
				{
					bitData.dispose();
					bitData = null;
				}
			}
			
			_bdArray = new Array;
			
			var bd:BitmapData;
			for (var i:int = 0; i < folderArray.length; i++)
			{
				bd = new BitmapData(sW*0.19, sH / 4.8, false, 0xFFFFFF);
				
				setBrushData(folderArray[i]);
				
				tool.deactivate();
				tool.activate(dummySp, bd);
				
				tool.customDown(new Point(bd.width * 0.098, bd.height * 0.72));
				tool.customMove(new Point(bd.width * 0.17578125, bd.height * 0.664));
				tool.customMove(new Point(bd.width * 0.25390625, bd.height * 0.608));
				tool.customMove(new Point(bd.width * 0.33203125, bd.height * 0.552));
				tool.customMove(new Point(bd.width * 0.41015625, bd.height * 0.496));
				tool.customMove(new Point(bd.width * 0.48828125, bd.height * 0.44));
				tool.customMove(new Point(bd.width * 0.56640625, bd.height * 0.384));
				tool.customMove(new Point(bd.width * 0.64453125, bd.height * 0.328));
				tool.customMove(new Point(bd.width * 0.72265625, bd.height * 0.272));
				tool.customMove(new Point(bd.width * 0.80078125, bd.height * 0.216));
				tool.customMove(new Point(bd.width * 0.879, bd.height * 0.16));
				
				textField = new TextField();textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField.text = folderArray[i][1];
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.x = bd.width * 0.5 - textField.width * 0.5;
				textField.y = bd.height - textField.height;
				
				bd.draw(textField, textField.transform.matrix);
				
				_bdArray.push(bd);
			}
			
			setBrushData(oldData);
			
			tool.deactivate();
			tool.activate(System.canvas, LayerList.instance.currentLayer);
		}
		
		private function changeSettings(e:MouseEvent):void 
		{
			var index:int = int(e.currentTarget.name);
			
			Preset.currnentBrush = index;
			e.currentTarget.addChild(checkBox);
			
			setBrushData(Preset.currentFolder[index]);
			
			dispatchEvent(new Event(Event.CHANGE,true));
		}
		
		private function setBrushData(array:Array):void 
		{
			brush.changePattern(array[2], array[3]);
			brush.size = array[4];
			brush.flow = array[5];
			brush.smoothness = array[6];
			brush.pressureSensivity = array[7];
			brush.spacing = array[8];
			brush.alpha = array[9];
			brush.xSymmetry = array[10];
			brush.ySymmetry = array[11];
			brush.randomRotate = array[12];
			brush.scattering = array[13];
			brush.randomColor = array[14];
		}
		
		private function removeMe(e:MouseEvent):void 
		{
			if (this.y != 0) return;
			
			TweenLite.to(this, 0.2, { y:-sH * 0.0383, alpha:0.3 , ease:Linear.easeIn,onComplete:remove } );
		}
		
		private function remove():void 
		{
			BackBoard.instance.removeChild(this);
		}
		
	}

}