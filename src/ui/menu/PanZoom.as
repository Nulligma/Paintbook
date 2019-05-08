package ui.menu 
{
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.display.Sprite;
	import settings.System;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import settings.CustomUI;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import fl.transitions.Zoom;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class PanZoom extends Sprite
	{
		private var sW:int;
		private var sH:int;
		private var cT:ColorTransform;
		
		private var zoomBtn:Sprite;
		private var panBtn:Sprite;
		private var moveBtn:Sprite;
		
		private var panning:Boolean;
		private var zooming:Boolean;
		
		private var startY:Number;
		private var newScale:Number;
		
		
		public function PanZoom()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			panning = false;
			zooming = false;
			
			var sp:Sprite;
			var sp2:Sprite;
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.size = sH * 0.083 * 0.4;
			var typeTxt:TextField;
			
			var textField:TextField;
			sp = new Sprite;
			sp.graphics.lineStyle(sW * 0.001, CustomUI.color1);
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.07, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Pan";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = -sp.width;
			sp.y = -sp.height/2;
			sp.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			addChild(sp);
			panBtn = sp;
			
			sp = new Sprite;
			sp.graphics.lineStyle(sW * 0.001, CustomUI.color1);
			sp.graphics.beginFill(CustomUI.color2); 
			sp.graphics.drawRect(0, 0, sW * 0.07, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color1;
			txtFormat.size = sH * 0.083 * 0.4;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Zoom";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			//sp.x = sp.width;
			sp.y = -sp.height/2;
			sp.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown );
			addChild(sp);
			zoomBtn = sp;
			
			var sp1:Sprite;
			sp1 = new Sprite;
			sp1.graphics.lineStyle(sW * 0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0,0,sW * 0.035, sH * 0.083); sp1.graphics.endFill();
			sp2 = new MoveLayerIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 75);
			cT = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			sp1.x = sW * 0.07;//sp1.width / 2;
			sp1.y = -sp1.height / 2;
			addChild(sp1);
			moveBtn = sp1;
			sp1.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				startDrag(false,new Rectangle(sW*0.15,height/2,sW,sH-height/2));
			});
			sp1.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				stopDrag();
			});
			
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void
			{
				zoomBtn.alpha = 100;
				zoomBtn.visible = true;
				
				panBtn.alpha = 100;
				panBtn.visible = true;
				
				zooming = false;
				panning = false;
				
				moveBtn.visible = true;
				
				
				BackBoard.instance.canvasHolder.stopDrag();
			});
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		
		private function onBtnDown(e:MouseEvent):void
		{
			var btn:Sprite = e.currentTarget as Sprite;
			
			if(btn == zoomBtn)
			{
				zoomBtn.alpha = 0.5;
				panBtn.visible = false;
				
				zooming = true;
				
				startY = stage.mouseY;
				newScale = BackBoard.instance.canvasHolder.scaleX;
				
			}
			else if(btn == panBtn)
			{
				panBtn.alpha = 0.5;
				zoomBtn.visible = false;
				
				panning = true;
				
				
				
				BackBoard.instance.canvasHolder.startDrag();
			}
			
			moveBtn.visible = false;
		}
		
		private function onMove(e:MouseEvent):void
		{
			if(zooming)
			{
				var diff:Number = stage.mouseY - startY;
				
				var scale:Number = (startY + diff)/startY;
				
				//BackBoard.instance.canvasHolder.scaleX = BackBoard.instance.canvasHolder.scaleY = newScale*scale;
				
				scaleFromCenter(BackBoard.instance.canvasHolder,newScale*scale,newScale*scale);
			}
		}
		
		private function scaleFromCenter(dis:*, sX:Number, sY:Number):void
		{
			var prevW:Number = dis.width;
			var prevH:Number = dis.height;
			dis.scaleX = sX;
			dis.scaleY = sY;
			dis.x += (prevW - dis.width) / 2;
			dis.y += (prevH - dis.height) / 2;
		}

		
	}
	
}