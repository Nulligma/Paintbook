package layers.setups
{
	import com.greensock.easing.*;
	import com.greensock.TweenNano;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import layers.history.HistoryManager;
	import settings.System;
	import tools.ToolManager;
	
	import settings.MessagePrefrences;
	import ui.message.Warning;
	import layers.setups.LayerList;
	import layers.setups.LayerProperties;
	import settings.CustomUI;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LayerSetup extends Sprite
	{
		private var layerProperties:LayerProperties;
		
		private var selectedLayer:Object;
		
		private	var holder:Sprite;
		private var backBtn:Sprite;
		private var expandBtn:Sprite;
		private var reduceBtn:Sprite;
		private var mergeBtn:Sprite;
		private var copyBtn:Sprite;
		private var deleteBtn:Sprite;
		
		private var txtFormat:TextFormat;
		private var _exitHandler:Function;
		
		private var warning:Warning;
		private var sW:int;
		private var sH:int;
		
		private var tween:TweenNano;
		private var tempStage:Stage;
		
		private var layerList:LayerList;
		private var cT:ColorTransform;
		private var sf:Number = 1.00;
		
		public function LayerSetup(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			layerList = LayerList.instance;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor);
			graphics.drawRect(0, 0, System.stageWidth, System.stageHeight);
			graphics.endFill();
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH*0.083 * 0.6;
			txtFormat.color = CustomUI.color2;
			
			init();
		}
		
		private function init():void 
		{
			holder = new Sprite;
			holder.graphics.beginFill(0xFFFFFF); holder.graphics.drawRect(0, 0, System.canvasWidth, System.canvasHeight); holder.graphics.endFill();
			
			var layerObject:Object = layerList.tailObject();
			
			while (layerObject != null)
			{
				holder.addChild(layerObject.bitmap);
				layerObject = layerObject.front;
			}
			
			var tW:int = holder.width; var tH:int = holder.height;
			while (tW*sf > sW * 0.4 || tH*sf > sH * 0.4)
			{
				sf -= 0.01;
			}
			
			holder.scaleX = holder.scaleY = sf;
			holder.x = -holder.width / 3;
			holder.y = sH * 0.25;
			addChild(holder);
			holder.addEventListener(MouseEvent.MOUSE_DOWN, OnHolderPress);
			tween = new TweenNano(holder, 1, { x:sW * 0.02, ease:Strong.easeOut } );
			
			backBtn = new Sprite;
			backBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); backBtn.graphics.beginFill(CustomUI.color1); 
			backBtn.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); backBtn.graphics.endFill();
			var txtField:TextField = new TextField; txtField.embedFonts = true;
			txtField.defaultTextFormat = txtFormat;
			txtField.text = "Back";
			txtField.selectable = false; 
			txtField.autoSize = TextFieldAutoSize.CENTER;
			txtField.x = backBtn.width / 2 - txtField.width / 2; 
			txtField.y = backBtn.height / 2 - txtField.height / 2;
			backBtn.addChild(txtField);
			backBtn.x = -holder.width / 3;
			backBtn.y = sH - backBtn.height - sH*0.033;
			addChild(backBtn);
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { backBtn.scaleX = backBtn.scaleY = 0.97; } );
			backBtn.addEventListener(MouseEvent.CLICK, GoBack);
			tween = new TweenNano(backBtn, 1, { x:sW * 0.02, ease:Strong.easeOut } );
			
			var sp2:Sprite;
			
			expandBtn = new Sprite;
			expandBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); expandBtn.graphics.beginFill(CustomUI.color1); 
			expandBtn.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); expandBtn.graphics.endFill();
			sp2 = new ExpandIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			sp2.transform.colorTransform = cT;
			sp2.x = expandBtn.width / 2;
			sp2.y = expandBtn.height / 2;
			expandBtn.addChild(sp2);
			expandBtn.y = sH - expandBtn.height - sH*0.033;
			expandBtn.x = sW / 6;
			addChild(expandBtn);
			expandBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { expandBtn.scaleX = expandBtn.scaleY = 0.97; } );
			expandBtn.addEventListener(MouseEvent.CLICK, OnASPress);
			tween = new TweenNano(expandBtn, 1, { x:sW * 0.264, ease:Strong.easeOut } );
			
			reduceBtn = new Sprite;
			reduceBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); reduceBtn.graphics.beginFill(CustomUI.color1); 
			reduceBtn.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); reduceBtn.graphics.endFill();
			sp2 = new ReduceIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			sp2.transform.colorTransform = cT;
			sp2.x = expandBtn.width / 2;
			sp2.y = expandBtn.height / 2;
			reduceBtn.addChild(sp2);
			reduceBtn.y = sH - reduceBtn.height - sH*0.033;
			reduceBtn.x = sW * 0.264;
			reduceBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { reduceBtn.scaleX = reduceBtn.scaleY = 0.97; } );
			reduceBtn.addEventListener(MouseEvent.CLICK, OnRsPress);
			
			mergeBtn = new Sprite;
			mergeBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); mergeBtn.graphics.beginFill(CustomUI.color1); 
			mergeBtn.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); mergeBtn.graphics.endFill();
			sp2 = new MergeIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			sp2.transform.colorTransform = cT;
			sp2.x = mergeBtn.width / 2;
			sp2.y = mergeBtn.height / 2;
			mergeBtn.addChild(sp2);
			mergeBtn.y = sH - mergeBtn.height - sH*0.033;
			mergeBtn.x = sW / 6;
			addChild(mergeBtn);
			mergeBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { mergeBtn.scaleX = mergeBtn.scaleY = 0.97; } );
			mergeBtn.addEventListener(MouseEvent.CLICK, OnMergePress);
			tween = new TweenNano(mergeBtn, 1, { x:sW * 0.264 + sW * 0.05 + sW * 0.01, ease:Strong.easeOut } );
			
			copyBtn = new Sprite;
			copyBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); copyBtn.graphics.beginFill(CustomUI.color1); 
			copyBtn.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); copyBtn.graphics.endFill();
			sp2 = new CopyLayerIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			sp2.transform.colorTransform = cT;
			sp2.x = copyBtn.width / 2;
			sp2.y = copyBtn.height / 2;
			copyBtn.addChild(sp2);
			copyBtn.y = sH - copyBtn.height - sH*0.033;
			copyBtn.x = sW / 6;
			addChild(copyBtn);
			copyBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { copyBtn.scaleX = copyBtn.scaleY = 0.97; } );
			copyBtn.addEventListener(MouseEvent.CLICK, OnCopyPress);
			tween = new TweenNano(copyBtn, 1, { x:sW * 0.264 + sW * 0.1 + sW * 0.01, ease:Strong.easeOut } );
			
			deleteBtn = new Sprite;
			deleteBtn.graphics.lineStyle(sH * 0.005, CustomUI.color2); deleteBtn.graphics.beginFill(CustomUI.color1); 
			deleteBtn.graphics.drawRect(0,0,sW * 0.05, sH * 0.083); deleteBtn.graphics.endFill();
			sp2 = new DeleteIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 50);
			cT = new ColorTransform;
			cT.color = CustomUI.color2;
			sp2.transform.colorTransform = cT;
			sp2.x = deleteBtn.width / 2;
			sp2.y = deleteBtn.height / 2;
			deleteBtn.addChild(sp2);
			deleteBtn.y = sH - deleteBtn.height - sH*0.033;
			deleteBtn.x = sW / 6;
			addChild(deleteBtn);
			deleteBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { deleteBtn.scaleX = deleteBtn.scaleY = 0.97; } );
			deleteBtn.addEventListener(MouseEvent.CLICK, OnDeletePress);
			tween = new TweenNano(deleteBtn, 1, { x:sW * 0.264 + sW * 0.15 + sW * 0.01, ease:Strong.easeOut } );
			
			selectedLayer = layerList.currentLayerObject;
			layerProperties = new LayerProperties(selectedLayer);
			addChild(layerProperties);
			layerProperties.x = System.stageWidth - System.stageWidth / 3;
			tween = new TweenNano(layerProperties, 1, {x:System.stageWidth - System.stageWidth / 2,ease:Strong.easeOut } );
			
		}
		
		private function OnHolderPress(e:MouseEvent):void 
		{
			if (reduceBtn && reduceBtn.stage)
			{
				holder.startDrag(false, new Rectangle( -System.canvasWidth + sW * 0.0488, -System.canvasHeight + sH * 0.0833, (System.canvasWidth), (System.canvasHeight)));
				stage.addEventListener(MouseEvent.MOUSE_UP, OnHolderUp);
				layerProperties.alpha = 0.3;
				reduceBtn.alpha = 0.3;
				backBtn.alpha = 0.3;
				mergeBtn.alpha = 0.3;
				copyBtn.alpha = 0.3;
				deleteBtn.alpha = 0.3;
			}
		}
		
		private function OnHolderUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, OnHolderUp);
			holder.stopDrag();
			layerProperties.alpha = 1;
			reduceBtn.alpha = 1;
			backBtn.alpha = 1;
			mergeBtn.alpha = 1;
			copyBtn.alpha = 1;
			deleteBtn.alpha = 1;
		}
		
		private function GoBack(e:MouseEvent = null):void 
		{
			if (backBtn.alpha == 1)
			{
				backBtn.scaleX = backBtn.scaleY = 1;
				backBtn.removeEventListener(MouseEvent.MOUSE_UP, GoBack);
				
				mergeBtn.removeEventListener(MouseEvent.MOUSE_UP, OnMergePress);
				copyBtn.removeEventListener(MouseEvent.MOUSE_UP, OnCopyPress);
				deleteBtn.removeEventListener(MouseEvent.MOUSE_UP, OnDeletePress);
				
				System.updateCanvas();
				tween = new TweenNano(this, 0.5, { y: -height, ease:Linear.easeIn, onComplete:_exitHandler } );
			}
			
		}
		
		private function OnASPress(e:MouseEvent):void 
		{
			holder.scaleX = holder.scaleY = 1;
			holder.x = 0; holder.y = 0;
			removeChild(expandBtn);
			addChild(reduceBtn);
			reduceBtn.scaleX = reduceBtn.scaleY = 1;
			swapChildren(reduceBtn, layerProperties);
		}
		
		private function OnRsPress(e:MouseEvent):void 
		{
			if (reduceBtn.alpha == 1)
			{
				holder.scaleX = holder.scaleY = sf;
				holder.y = System.stageHeight * 0.25; holder.x = sW*0.02;
				removeChild(reduceBtn);
				addChild(expandBtn);
				expandBtn.scaleX = expandBtn.scaleY = 1;
				swapChildren(expandBtn, layerProperties);
			}
		}
		
		private function OnMergePress(e:MouseEvent):void 
		{
			if (mergeBtn.alpha == 1)
			{
				mergeBtn.scaleX = mergeBtn.scaleY = 1;
				if (MessagePrefrences.hideMergeWarning)
				{
					layerList.deleteLayer(selectedLayer, true);
					ToolManager.workArea(System.canvas, layerList.currentLayer);
					System.updateCanvas();
					HistoryManager.flush();
					GoBack();
				}
				else
				{
					var msg:String = "Merging this layer with below layer cannot be undone\nand it will clear all undo\nDo you want to continue?";
					warning = new Warning(Warning.LAYER_MERGE, mergWarnReturn, "Warning!", msg);
					BackBoard.instance.addChild(warning);
					tempStage = stage;
				}
			}
		}
		
		private function mergWarnReturn():void
		{
			tween = new TweenNano(warning, 0.5, { y: -warning.height, ease:Linear.easeIn, onComplete:function():void { BackBoard.instance.removeChild(warning); } } );
			if (warning.status == 1)
			{
				layerList.deleteLayer(selectedLayer, true);
				
				ToolManager.workArea(System.canvas, layerList.currentLayer);
				System.updateCanvas();
				HistoryManager.flush();
				_exitHandler();
			}
		}
		
		private function OnCopyPress(e:MouseEvent):void 
		{
			if (copyBtn.alpha == 1) 
			{
				copyBtn.scaleX = copyBtn.scaleY = 1;
				layerList.initNewLayer(selectedLayer.bitmap.bitmapData.width, selectedLayer.bitmap.bitmapData.height, true, selectedLayer.bitmap.bitmapData);
				
				ToolManager.workArea(System.canvas, layerList.currentLayer);
				GoBack();
			}
		}
		
		private function OnDeletePress(e:MouseEvent):void 
		{
			if (deleteBtn.alpha == 1) 
			{
				deleteBtn.scaleX = deleteBtn.scaleY = 1;
				
				if (MessagePrefrences.hideDeleteWarning)
				{
					layerList.deleteLayer(selectedLayer);
					HistoryManager.flush();
					ToolManager.workArea(System.canvas, layerList.currentLayer);
					System.updateCanvas();
				
					GoBack();
				}
				else
				{
					var msg:String = "Deleting this layer cannot be undone\nand it will clear all undo\nDo you want to continue?";
					warning = new Warning(Warning.LAYER_DELETE, delWarnReturn, "Warning!", msg);
					BackBoard.instance.addChild(warning);
					tempStage = stage;
				}
			}
		}
		
		private function delWarnReturn():void 
		{
			tween = new TweenNano(warning, 0.5, { y: -warning.height, ease:Linear.easeIn,onComplete:function():void { BackBoard.instance.removeChild(warning); } } );
			if (warning.status == 1)
			{
				layerList.deleteLayer(selectedLayer);
				
				HistoryManager.flush();
				ToolManager.workArea(System.canvas, layerList.currentLayer);
				System.updateCanvas();
				_exitHandler();
			}
		}
		
	}

}