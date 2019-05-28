package ui.other 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import settings.System;
	import flash.text.TextFormatAlign;
	import layers.setups.LayerList;
	import flash.geom.Rectangle;
	import tools.ToolManager;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class DrawGrid extends Sprite
	{
		private var txtFormat:TextFormat;
		private var sW:int;
		private var sH:int;
		
		private var cW:int;
		private var cH:int;
		
		private var _exitHandler:Function;
		private var customSlider:CustomSlider;
		
		private var varArray:Array;
		private var txtArray:Array;
		
		static public var area:Rectangle;
		static public var cell:Rectangle;
		
		
		public function DrawGrid(exitHandler:Function) 
		{
			_exitHandler = exitHandler;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			cW = System.canvasWidth;
			cH = System.canvasHeight;
			
			txtFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.color = CustomUI.color1;
			
			graphics.beginFill(CustomUI.backColor); 
			graphics.drawRect(0, 0, sW, sH);
			graphics.endFill();
			
			var holder:Sprite;
			var sp:Sprite;
			var sp2:Sprite;
			var textField:TextField;
			var textField2:TextField;
			var cT:ColorTransform;
			
			textField = new TextField;textField.embedFonts = true;
			txtFormat.size = sH * 0.083 * 0.75;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Draw grid on current layer";
			textField.selectable = false; 
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sW / 2 - textField.width / 2;
			textField.y = -textField.height;
			addChild(textField);
			TweenLite.to(textField, 1, { y: sH * 0.05, ease:Strong.easeOut } );
			
			varArray = [0,0,25,100,100,25];
			txtArray = new Array();
			for (var i:int = 0; i < 6; i++) 
			{
				sp = new Sprite;
				sp.graphics.beginFill(CustomUI.color1); 
				sp.graphics.drawRect(0, 0, sW * 0.293, sH * 0.083); sp.graphics.endFill();
				txtFormat.color = CustomUI.color2;
				txtFormat.size = sH * 0.083 * 0.6;
				textField = new TextField;textField.embedFonts = true;
				textField.defaultTextFormat = txtFormat;
				textField2 = new TextField;textField2.embedFonts = true;
				txtFormat.align = TextFormatAlign.RIGHT;
				textField2.defaultTextFormat = txtFormat;
				txtFormat.align = TextFormatAlign.LEFT;
				
				if (i == 0)
				{
					textField.text = sp.name = "X: ";
					textField2.text = "0%"; 
				}
				else if (i == 1)
				{
					textField.text = sp.name = "Y: ";
					textField2.text = "0%"; 
				}
				else if (i == 2)
				{
					textField.text = sp.name = "Columns: ";
					textField2.text = "25"; 
				}
				else if (i == 3)
				{
					textField.text = sp.name = "Width: ";
					textField2.text = "100%"; 
				}
				else if (i == 4)
				{
					textField.text = sp.name = "Height: ";
					textField2.text = "100%"; 
				}
				else
				{
					textField.text = sp.name = "Rows: ";
					textField2.text = "25"; 
				}
				
				txtArray.push(textField2);
				
				//textField.border = textField2.border = true;
				
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField2.selectable = false;
				textField2.width = sp.width/2;
				textField2.height = sH * 0.083 * 0.75;
				textField.x = sW*0.01; textField.y = sp.height / 2 - textField.height / 2;
				sp.addChild(textField);
				textField2.x = sp.width - textField2.width - sW * 0.01;
				textField2.y = textField.y;
				sp.addChild(textField2);
				addChild(sp);
				sp.x = -sp.width;
				sp.y = i>2?sH * 0.5 + sp.height + sH * 0.033:sH * 0.5 - sp.height - sH * 0.033;
				TweenLite.to(sp, 1, { x: sW * 0.0502 + int(i%3) * (sp.width + sW * 0.01) , ease:Strong.easeOut } );
				sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
				sp.addEventListener(MouseEvent.CLICK, changeVars);
			}
			
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
			sp.x = sW * 0.01;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onBack);
			TweenLite.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Hide";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.5 - sp.width/2;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onVisible);
			TweenLite.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
			
			var hideBtn:Sprite = sp;
			
			if(ToolManager.grid == null) hideBtn.visible = false;
			else
			{
				if(ToolManager.grid.visible) 	hideBtn.name = textField.text = "Hide";
				else							hideBtn.name = textField.text = "Show";
			}
			
			sp = new Sprite;
			sp.graphics.beginFill(CustomUI.color1); 
			sp.graphics.drawRect(0, 0, sW * 0.146, sH * 0.083); sp.graphics.endFill();
			txtFormat.color = CustomUI.color2;
			txtFormat.size = sH * 0.083 * 0.6;
			textField = new TextField;textField.embedFonts = true;
			textField.defaultTextFormat = txtFormat;
			textField.text = "Draw";
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = sp.width / 2 - textField.width / 2; textField.y = sp.height / 2 - textField.height / 2;
			sp.addChild(textField);
			addChild(sp);
			sp.x = sW * 0.99 - sp.width;
			sp.y = sH;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { e.currentTarget.scaleX = e.currentTarget.scaleY = 0.97; } );
			sp.addEventListener(MouseEvent.CLICK, onDraw);
			TweenLite.to(sp, 1, { y: sH - sH * 0.016 - sp.height, ease:Strong.easeOut } );
		}
		
		private function onVisible(e:MouseEvent):void
		{
			var sp:Sprite = e.currentTarget as Sprite;
			var tf:TextField = sp.getChildAt(0) as TextField;
			
			if(sp.name == "Hide")
			{
				sp.name = tf.text = "Show";
				ToolManager.grid.visible = false;
			}
			else if(sp.name == "Show")
			{
				sp.name = tf.text = "Hide";
				ToolManager.grid.visible = true;
			}
			
			_exitHandler();
		}
		
		private function changeVars(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			
			switch(e.currentTarget.name)
			{
				case "X: ":
					customSlider = new CustomSlider("X coordinate", varArray[0], 0, 100);
				break;
				
				case "Y: ":
					customSlider = new CustomSlider("Y coordinate", varArray[1], 0, 100);
				break;
				
				case "Columns: ":
					customSlider = new CustomSlider("Number of Columns", varArray[2], 10, 100);
				break;
				
				case "Width: ":
					customSlider = new CustomSlider("Width of grid", varArray[3], 0, 100);
				break;
				
				case "Height: ":
					customSlider = new CustomSlider("Height of grid", varArray[4], 0, 100);
				break;
				
				case "Rows: ":
					customSlider = new CustomSlider("Number of Rows", varArray[5], 10, 100);
				break;
				
			}
			
			customSlider.name = e.currentTarget.name;
			addChild(customSlider);
			customSlider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			switch(e.currentTarget.name)
			{
				case "X: ":
					varArray[0] = customSlider.value;
					txtArray[0].text = customSlider.value + "%";
				break;
				
				case "Y: ":
					varArray[1] = customSlider.value;
					txtArray[1].text = customSlider.value + "%";
				break;
				
				case "Columns: ":
					varArray[2] = customSlider.value;
					txtArray[2].text = customSlider.value;
				break;
				
				case "Width: ":
					varArray[3] = customSlider.value;
					txtArray[3].text = customSlider.value + "%";
				break;
				
				case "Height: ":
					varArray[4] = customSlider.value;
					txtArray[4].text = customSlider.value + "%";
				break;
				
				case "Rows: ":
					varArray[5] = customSlider.value;
					txtArray[5].text = customSlider.value;
				break;
			}
			removeChild(customSlider);
			customSlider = null;
		}
		
		private function onDraw(e:MouseEvent):void 
		{
			var grid:Sprite = ToolManager.grid;
			
			if(grid!=null)
				grid.graphics.clear();
			else
			{
				grid = new Sprite();
				ToolManager.grid = grid;
			}
			
			grid.graphics.clear();
			grid.graphics.lineStyle(0.1, 0x999995);
			
			var numColumns:uint = varArray[2];
			var numRows:uint = varArray[5];
			
			var cellWidth:Number = cW * (varArray[3]/100)/numColumns;
			var cellHeight:Number = cH * (varArray[4]/100)/numRows;

			// we drop in the " + 1 " so that it will cap the right and bottom sides.
			for (var col:Number = 0; col < numColumns + 1; col++)
			{
				for (var row:Number = 0; row < numRows + 1; row++)
				{
					grid.graphics.moveTo(col * cellWidth, 0);
					grid.graphics.lineTo(col * cellWidth, cellHeight * numRows);
					grid.graphics.moveTo(0, row * cellHeight);
					grid.graphics.lineTo(cellWidth * numColumns, row * cellHeight);
				}
			}
			
			//addChild(grid);
			
			grid.x = cW * varArray[0]/100;
			grid.y = cH * varArray[1]/100;
			
			area = new Rectangle(grid.x,grid.y,grid.width,grid.height);
			cell = new Rectangle(0,0,cellWidth,cellHeight);
			
			ToolManager.workingCanvas.addChild(grid);
			_exitHandler();
			
			
			
		}
		
		private function onBack(e:MouseEvent):void 
		{
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			_exitHandler();
		}
		
	}

}