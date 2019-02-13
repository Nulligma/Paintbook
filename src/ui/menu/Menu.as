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
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.6;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, tweenOut );
			
			drawerLine = new Sprite;
			drawerLine.graphics.lineStyle(sW * 0.01, CustomUI.color1); 
			drawerLine.graphics.moveTo(0, sH * 0.083); drawerLine.graphics.lineTo(sW, sH * 0.083);
			drawerLine.y = -sH * 0.083;
			addChild(drawerLine);
			
			holder = new Sprite;
			
			for (var i:int = 0; i < 6; i++)
			{
				sp = new Sprite;
				sp.graphics.lineStyle(sW*0.0034,CustomUI.color2); sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW/6, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				typeTxt = new TextField;typeTxt.embedFonts = true;
				typeTxt.defaultTextFormat = txtFormat;
				
				if (i == 0) { typeTxt.text = "Canvas"; sp.addEventListener(MouseEvent.CLICK, createFileMenu); }
				if (i == 1) { typeTxt.text = "Layers"; sp.addEventListener(MouseEvent.CLICK, createLayerMenu); }
				if (i == 2) { typeTxt.text = "Tools"; sp.addEventListener(MouseEvent.CLICK, createToolsMenu); }
				if (i == 3) { typeTxt.text = "Colors"; sp.addEventListener(MouseEvent.CLICK, createColorMenu); }
				if (i == 4) { typeTxt.text = "Undo"; sp.addEventListener(MouseEvent.MOUSE_DOWN, performUndo); }
				if (i == 5) { typeTxt.text = "Redo"; sp.addEventListener(MouseEvent.MOUSE_DOWN, performRedo); }
				
				typeTxt.selectable = false;
				typeTxt.autoSize = TextFieldAutoSize.CENTER;
				typeTxt.x = sp.width / 2 - typeTxt.width / 2; typeTxt.y = sp.height / 2 - typeTxt.height / 2;
				sp.addChild(typeTxt);
				sp.x = i*sW/6; sp.y = 0;
				holder.addChild(sp);
			}
			holder.y = -holder.height;
			addChild(holder);
			var dropShadow:DropShadowFilter = new DropShadowFilter;
			dropShadow.angle = 90; dropShadow.quality = 3; dropShadow.strength = 0.5;
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
			if (activeSubMenu)
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
			
			activeSubMenu = fileSubMenu;
		}
		
		private function createToolsMenu(e:MouseEvent):void 
		{
			if (activeSubMenu) 
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut} );
				if (activeSubMenu == toolSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (toolSubMenu==null)
			{
				toolSubMenu = new ToolSubmenu;
				addChild(toolSubMenu);
				swapChildren(toolSubMenu, holder);
			}
			else if(activeSubMenu)
				swapChildren(toolSubMenu, activeSubMenu);
			
			TweenNano.to(toolSubMenu, 0.5, { y:sH * 0.082, ease:Strong.easeOut } );
			
			activeSubMenu = toolSubMenu;
		}
		
		private function createLayerMenu(e:MouseEvent):void 
		{
			if (activeSubMenu) 
			{
				TweenNano.to(activeSubMenu, 1, { y:-activeSubMenu.height, ease:Strong.easeOut} );
				if (activeSubMenu == layerSubMenu && activeSubMenu.y >= sH * 0.08) return;
			}
			
			if (layerSubMenu==null)
			{
				layerSubMenu = new LayerSubmenu();
				addChild(layerSubMenu);
				swapChildren(layerSubMenu, holder);
			}
			else if (activeSubMenu)
			{
				swapChildren(layerSubMenu, activeSubMenu);
				layerSubMenu.update();
			}
			
			TweenNano.to(layerSubMenu, 0.5, { y:sH * 0.082, ease:Strong.easeOut } );
			
			activeSubMenu = layerSubMenu;
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
		
		private function performUndo(e:MouseEvent):void 
		{
			HistoryManager.undo();
			
			if (activeSubMenu && activeSubMenu == layerSubMenu)
				layerSubMenu.update();
		}
		
		private function performRedo(e:MouseEvent):void 
		{
			HistoryManager.redo();
			
			if (activeSubMenu && activeSubMenu == layerSubMenu)
				layerSubMenu.update();
		}
		
		private function tweenOut(e:MouseEvent = null):void
		{
			if (activeSubMenu is ToolSubmenu && mouseY < sH * 0.6) return
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
			}
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