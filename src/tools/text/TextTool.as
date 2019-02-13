package tools.text 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import layers.history.HistoryManager;
	import layers.setups.LayerList;
	import settings.System;
	import tools.ToolManager;
	import tools.ToolType;
	import tools.transform.FreeTransform;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class TextTool 
	{
		static private var _instance:TextTool;
		
		private var text:TextData = TextData.instance;
		
		private var _bitData:BitmapData;
		private var _canvas:Sprite;
		private var textSprite:Sprite;
		private var activated:Boolean = false;
		private var txtFormat:TextFormat;
		private var txtField:TextField;
		private var freeTrans:FreeTransform;
		private var mask:Sprite;
		private var firstY:Number;
		private var firstX:Number;
		
		private var layerList:LayerList;
		
		public function TextTool() 
		{
			if (_instance)
				throw new Error("TextTool singleTon Error");
		}
		
		public function activate(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitData = bitData;
			
			layerList= LayerList.instance;
			_canvas.addEventListener(MouseEvent.CLICK, onClick);
			
			activated = true;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			HistoryManager.pushList();
			
			textSprite = new Sprite;
			_canvas.addChild(textSprite);
			
			txtFormat = new TextFormat;
			
			txtFormat.size = text.size;
			txtFormat.color = ToolManager.fillColor;
			txtFormat.font = "Default";
			txtFormat.align = text.align;
			
			txtFormat.bold = text.bold;
			txtFormat.italic = text.italic;
			txtFormat.underline = text.underline;
			
			textSprite.filters = [new BlurFilter(text.smoothness, text.smoothness, 2)];
			
			txtField = new TextField;txtField.embedFonts = true;
			txtField.defaultTextFormat = txtFormat;
			txtField.alpha = text.opacity;
			txtField.type = TextFieldType.INPUT;
			txtField.multiline = true;
			//TODO:ReqKewBoard
			//txtField.requestSoftKeyboard();
			txtField.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void { txtField.autoSize = text.autoSize; } );
			
			firstX = _canvas.mouseX;
			firstY = _canvas.mouseY;
			
			txtField.x = _canvas.mouseX;
			txtField.y = _canvas.mouseY;
			textSprite.addChild(txtField);
			
			_canvas.stage.focus = txtField;
			
			_canvas.removeEventListener(MouseEvent.CLICK, onClick);
			
			if (!text.transform)
				_canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, printText);
			else
				_canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, createFreeTransform);
		}
		
		private function printText(e:MouseEvent):void 
		{
			if (txtField)
			{
				txtField.type = TextFieldType.DYNAMIC;
				if (ToolManager.lassoMask)
				{
					var bd:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
					bd.draw(textSprite);
					var bm:Bitmap = new Bitmap(bd);
					
					bm.mask = ToolManager.lassoMask;
					_bitData.draw(bm);
					
					bm.mask = null;
					bm = null;
					bd.dispose();
				}
				else
					_bitData.draw(textSprite,null,null,null,ToolManager.clipRect);
			}
			if (textSprite)
			{
				_canvas.removeChild(textSprite);
				textSprite = null;
			}
			
			_canvas.addEventListener(MouseEvent.CLICK, onClick);
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, printText);
		}
		
		private function createFreeTransform(e:MouseEvent):void 
		{
			txtField.type = TextFieldType.DYNAMIC;
			txtField.selectable = false;
			txtField.x = 0; txtField.y = 0;
			
			var bd:BitmapData = new BitmapData(txtField.width, txtField.height,true,0x000000);
			bd.draw(textSprite,null,null,null,null,true);
			
			//var sp:Sprite = new Sprite();
			//sp.addChild(txtField);
			
			_canvas.removeChild(textSprite);
			textSprite = null;
			
			freeTrans = new FreeTransform( { bitData:bd } );
			freeTrans.x = firstX+freeTrans.width/2;
			freeTrans.y = firstY+freeTrans.height/2;
			_canvas.addChildAt(freeTrans, _canvas.getChildIndex(layerList.currentLayerObject.bitmap) + 1);
			
			mask = new Sprite;
			mask.graphics.beginFill(0x000000, 0); mask.graphics.drawRect(0, 0, _canvas.width, _canvas.height);
			_canvas.addChild(mask);
			freeTrans.mask = mask;
			
			_canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, createFreeTransform);
		}
		
		public function deactivate():void
		{
			if (freeTrans)
			{
				freeTrans.clearAll();
				
				if (ToolManager.lassoMask)
				{
					var bd:BitmapData = new BitmapData(_bitData.width, _bitData.height, true, 0x00000000);
					bd.draw(freeTrans, freeTrans.transform.matrix, null, null, ToolManager.clipRect);
					
					var bm:Bitmap = new Bitmap(bd);
					bm.mask = ToolManager.lassoMask;
					
					_bitData.draw(bm);
					
					bm.mask = ToolManager.lassoMask;
					bm = null;
					bd.dispose();
				}
				else
				{
					_bitData.draw(freeTrans, freeTrans.transform.matrix, null, null, ToolManager.clipRect);
				}
				_canvas.removeChild(mask);
				
				_canvas.removeChild(freeTrans);
				freeTrans = null;
			}
			
			if (textSprite)
			{
				_canvas.removeChild(textSprite);
				textSprite = null;
			}
			_canvas.removeEventListener(MouseEvent.CLICK, onClick);
			
			activated = false;
		}
		
		static public function get instance():TextTool 
		{
			if (!_instance)
				_instance = new TextTool;
			return _instance;
		}
		
	}

}