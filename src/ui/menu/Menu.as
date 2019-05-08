package ui.menu 
{
	import com.greensock.easing.*;
	import com.greensock.TweenNano;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import layers.history.HistoryManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import settings.CustomUI;
	import settings.Prefrences;
	import settings.System;
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Menu extends Sprite
	{
		private var sW:int;
		private var sH:int;
		
		private var tween:TweenNano;
		private var txtFormat:TextFormat;
		
		private var fileSubMenu:FileSubmenu;
		private var colorSubMenu:ColorSubmenu;
		private var layerSubMenu:LayerSubmenu;
		private var toolSubMenu:ToolSubmenu;
		private var panZoomMenu:PanZoom;
		
		private var toolBtn:Sprite;
		private var layerBtn:Sprite;
		private var panZoomBtn:Sprite;
		
		private var holder:Sprite;
		private var activeSubMenu:Sprite;
		private var prevSubMenu:Sprite;
		private var drawerLine:Sprite;
		private var _exitHandler:Function;
		
		public function Menu(exitHandler:Function)
		{
			_exitHandler = exitHandler;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			var sp:Sprite;
			var typeTxt:TextField;
			
			var sp2:Sprite;
			var cT:ColorTransform;
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN,tweenOut);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.MOUSE_DOWN, updateMenus);
			BackBoard.instance.canvasHolder.addEventListener(MouseEvent.CLICK, updateMenus);
			
			drawerLine = new Sprite;
			drawerLine.graphics.lineStyle(sW * 0.01, CustomUI.color1); 
			drawerLine.graphics.moveTo(sW * 0.08,0); drawerLine.graphics.lineTo(sW*0.08, sH);
			drawerLine.x = -sW * 0.08;
			addChild(drawerLine);
			
			holder = new Sprite;
			
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			
			for (var i:int = 0; i < 6; i++)
			{
				sp = new Sprite;
				sp.graphics.lineStyle(sW*0.0034,CustomUI.color2); sp.graphics.beginFill(CustomUI.backColor); 
				sp.graphics.drawRect(0, 0, sW*0.08, sH/6); sp.graphics.endFill();
				
				if (i == 0) { sp2 = new FileIcon; sp.addEventListener(MouseEvent.CLICK, createFileMenu); }
				if (i == 1) { sp2 = new LayerIcon; sp.addEventListener(MouseEvent.CLICK, createLayerMenu); layerBtn=sp; }
				if (i == 2) { sp2 = new ToolsIcon; sp.addEventListener(MouseEvent.CLICK, createToolsMenu); toolBtn=sp;  }
				if (i == 3) { sp2 = new PanZoomIcon; sp.addEventListener(MouseEvent.CLICK, createPanZoomMenu); panZoomBtn=sp; }
				if (i == 4) { sp2 = new UndoIcon; sp.addEventListener(MouseEvent.MOUSE_DOWN, performUndo); }
				if (i == 5) { sp2 = new RedoIcon; sp.addEventListener(MouseEvent.MOUSE_DOWN, performRedo); }
				
				sp2.width = sp2.height = (sW * 0.08 / 1.5);
				sp2.transform.colorTransform = cT;
				sp2.x = sp.width / 2;
				sp2.y = sp.height / 2;
				sp.addChild(sp2);
			
				sp.x = 0; sp.y = i*sH/6;
				holder.addChild(sp);
			}
			holder.y = -holder.height;
			addChild(holder);
			var dropShadow:DropShadowFilter = new DropShadowFilter;
			dropShadow.angle = 0; dropShadow.quality = 3; dropShadow.strength = 0.5;
			dropShadow.distance = 7;
			holder.filters = [dropShadow];
			
			if (!Prefrences.hideMenu)
			{
				tweenIn();
			}
			
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, tweenIn);
		}
		
		private function createFileMenu(e:MouseEvent):void 
		{
			/*if (activeSubMenu)
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut } );
				if (activeSubMenu == fileSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (fileSubMenu==null)
			{
				fileSubMenu = new FileSubmenu;
				addChild(fileSubMenu);
				swapChildren(fileSubMenu, holder);
			}
			else
				swapChildren(fileSubMenu, activeSubMenu);
			
			TweenNano.to(fileSubMenu, 0.5, { y:sH * 0.082, ease:Strong.easeOut } );
			
			activeSubMenu = fileSubMenu;*/
			
			fileSubMenu = new FileSubmenu;
			fileSubMenu.x=0;fileSubMenu.y=0;
			fileSubMenu.addEventListener(Event.COMPLETE,function(e:Event):void{
				removeChild(fileSubMenu);
			});
			addChild(fileSubMenu);
		}
		
		private function createToolsMenu(e:MouseEvent):void 
		{
			if (toolSubMenu && toolSubMenu.x>=0) 
			{
				toggleButton(toolBtn,false);
				TweenNano.to(toolSubMenu, 1, { x:-toolSubMenu.width, ease:Strong.easeOut} ); return;
				
				//if (activeSubMenu == toolSubMenu && activeSubMenu.x >= sW * 0.08) return;
			}
			
			if (toolSubMenu==null)
			{
				toolSubMenu = new ToolSubmenu;
				addChild(toolSubMenu);
				swapChildren(toolSubMenu, holder);
			}
			//else if(activeSubMenu)
				//swapChildren(toolSubMenu, activeSubMenu);
			
			toggleButton(toolBtn,true);
			TweenNano.to(toolSubMenu, 0.5, { x:sW * 0.08, ease:Strong.easeOut } );
			
			//activeSubMenu = toolSubMenu;
		}
		
		private function createLayerMenu(e:MouseEvent):void 
		{
			if (layerSubMenu && layerSubMenu.y>=0) 
			{
				toggleButton(layerBtn,false);
				TweenNano.to(layerSubMenu, 1, { y:-layerSubMenu.height, ease:Strong.easeOut} );return;
				
				//if (activeSubMenu == layerSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (layerSubMenu==null)
			{
				layerSubMenu = new LayerSubmenu();
				layerSubMenu.x = sW*0.6;
				layerSubMenu.y = -layerSubMenu.height;
				addChild(layerSubMenu);
				//swapChildren(layerSubMenu, holder);
			}
			else
			{
				layerSubMenu.update();
			}
			
			toggleButton(layerBtn,true);
			
			TweenNano.to(layerSubMenu, 0.5, { y:0, ease:Strong.easeOut } );
		}
		
		private function createPanZoomMenu(e:MouseEvent):void
		{
			if(panZoomMenu == null)
			{
				panZoomMenu = new PanZoom();
				panZoomMenu.x = sW*0.75;
				panZoomMenu.y = sH*0.5;
			}
			
			if(panZoomMenu.stage)
			{
				removeChild(panZoomMenu);
				toggleButton(panZoomBtn,false);
			
			}
			else
			{
				addChild(panZoomMenu);
				toggleButton(panZoomBtn,true);
			
			}
			
		}
		
		private function createColorMenu(e:MouseEvent):void 
		{
			if (activeSubMenu) 
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut} );
				if (activeSubMenu == colorSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (colorSubMenu==null)
			{
				colorSubMenu= new ColorSubmenu;
				addChild(colorSubMenu);
				swapChildren(colorSubMenu, holder);
			}
			else if(activeSubMenu)
				swapChildren(colorSubMenu, activeSubMenu);
			
			TweenNano.to(colorSubMenu, 0.5, { y:sH * 0.082, ease:Strong.easeOut } );
			
			activeSubMenu = colorSubMenu;
		}
		
		private function toggleButton(btn:Sprite,onState:Boolean):void
		{
			var bgColor:uint;
			var lineColor:uint;
			var iconColor:uint;
			
			if(onState)
			{
				bgColor = CustomUI.color1;
				lineColor = CustomUI.color2;
				iconColor = CustomUI.color2;
			}
			else
			{
				bgColor = CustomUI.backColor;
				lineColor = CustomUI.color2;
				iconColor = CustomUI.color1;
			}
			
			var icon:Sprite = btn.getChildAt(0) as Sprite;
			
			btn.graphics.clear();
			
			btn.graphics.lineStyle(sW*0.0034,lineColor); btn.graphics.beginFill(bgColor); 
			btn.graphics.drawRect(0, 0, sW*0.08, sH/6); btn.graphics.endFill();
			
			var cT:ColorTransform = new ColorTransform;
			cT.color = iconColor;
			
			icon.transform.colorTransform = cT;
		}
		
		private function performUndo(e:MouseEvent):void 
		{
			HistoryManager.undo();
			
			if (layerSubMenu && layerSubMenu.y>=0)
				layerSubMenu.update();
		}
		
		private function performRedo(e:MouseEvent):void 
		{
			HistoryManager.redo();
			
			if (layerSubMenu && layerSubMenu.y>=0)
				layerSubMenu.update();
		}
		
		private function tweenOut(e:MouseEvent = null):void
		{
			/*if (activeSubMenu is ToolSubmenu && mouseY < sH * 0.6) return
			else if (mouseY < sH * 0.3) return;
			
			if (!Prefrences.hideMenu && activeSubMenu && mouseY > sH * 0.167)
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut,onComplete:removeAllSubmenu } );
			}
			else if (Prefrences.hideMenu)
			{
				if (activeSubMenu && mouseY < sH * 0.167)
				{
					return;
				}
				removeAllSubmenu();
				TweenNano.to(holder, 0.5, { y: -sH * 0.086, ease:Strong.easeOut } );
				TweenNano.to(drawerLine, 0.5, { y:-sH*0.086, ease:Strong.easeOut} );
			}*/
		}
		
		private function tweenIn(event:MouseEvent = null):void
		{
			if (holder.y == 0) return;
			
			TweenNano.to(holder, 0.5, { y:0, ease:Strong.easeOut } );
			TweenNano.to(drawerLine, 0.5, { y:0, ease:Strong.easeOut } );
		}
		
		private function removeAllSubmenu():void 
		{
			if (fileSubMenu && fileSubMenu.stage) 
			{
				removeChild(fileSubMenu);
				fileSubMenu = null;
			}
			if (colorSubMenu && colorSubMenu.stage) 
			{
				removeChild(colorSubMenu);
				colorSubMenu = null;
			}
			if (layerSubMenu && layerSubMenu.stage) 
			{
				removeChild(layerSubMenu);
				layerSubMenu = null;
			}
			if (toolSubMenu && toolSubMenu.stage) 
			{
				removeChild(toolSubMenu);
				toolSubMenu = null;
			}
		}
		
		private function updateMenus(event:MouseEvent):void
		{
			if(toolSubMenu && toolSubMenu.x>=0)
			{
				toolSubMenu.update(event.type);
			}
			
			if (layerSubMenu && layerSubMenu.y>=0 && event.type == MouseEvent.CLICK)
			{
				layerSubMenu.update();
			}
		}
		
		public function deactivateTweenOut():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, tweenOut );
		}
		
		public function activeTweenOut():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, tweenOut );
		}
		
		public function redraw()
		{
			drawerLine.graphics.clear();
			drawerLine.graphics.lineStyle(sW * 0.01, CustomUI.color1); 
			drawerLine.graphics.moveTo(0, sH * 0.083); drawerLine.graphics.lineTo(sW, sH * 0.083);
			
			var child:*;
			for (var i:int = 0; i < 5; i++)
			{
				child = holder.getChildAt(i);
				
				child.graphics.lineStyle(sW*0.003,CustomUI.color2); child.graphics.beginFill(CustomUI.color1); 
				child.graphics.drawRect(0, 0, sW * 0.1995, sH * 0.083); child.graphics.endFill();
				
				txtFormat.font = CustomUI.font;
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				child = child.getChildAt(0);
				child.setTextFormat(txtFormat);
			}
		}
		
		public function get exitHandler():Function 
		{
			return _exitHandler;
		}
	}
}