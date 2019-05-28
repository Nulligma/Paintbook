package ui.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import settings.CustomUI;
	import flash.text.TextField;
	import tools.ToolManager;
	import settings.System;
	import flash.text.TextFieldAutoSize;
	import colors.convertor.ConvertColor;
	import flash.text.TextFieldType;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class HexSubmenu extends Sprite
	{
		private var sH:int;
		private var sW:int;
		
		private var c1Sprite:Sprite;
		private var c2Sprite:Sprite;
		
		private var nameTxt:TextField;
		
		private var newColor:uint;
		private var oldColor:uint;
		
		private var rCS:CustomSlider;
		private var gCS:CustomSlider;
		private var bCS:CustomSlider;
		
		private var hCS:CustomSlider;
		private var sCS:CustomSlider;
		private var brCS:CustomSlider;
		
		public function HexSubmenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			sW = System.stageWidth;
			sH = System.stageHeight;
			
			graphics.beginFill(CustomUI.backColor); graphics.drawRect(0, 0,sW*0.2, sH); graphics.endFill();
			
			oldColor = newColor = ToolManager.fillColor;
			createUI();
		}
		
		private function createUI():void
		{
			removeChildren();
			
			c1Sprite = new Sprite;
			c1Sprite.graphics.beginFill(oldColor); c1Sprite.graphics.drawRect(0, 0, sW*0.05, sW*0.07);
			addChild(c1Sprite);
			
			var txtFormat:TextFormat = new TextFormat;
			txtFormat.font = CustomUI.font;
			txtFormat.align = "center";
			txtFormat.color = CustomUI.color1;
			
			var txtTF:TextField;
			txtTF = new TextField();txtTF.embedFonts = true;
			txtFormat.size = sW * 0.083 * 0.25;
			txtTF.defaultTextFormat = txtFormat;
			txtTF.text = "#" + ConvertColor.UintToHexString(oldColor);
			txtTF.selectable = false; 
			txtTF.autoSize = TextFieldAutoSize.CENTER;
			txtTF.x = c1Sprite.x + c1Sprite.width;
			txtTF.y = 0;
			addChild(txtTF);
			
			var rgb:Object = ConvertColor.HexToRGB(oldColor);
			var hsb:Object = ConvertColor.RGBToHSB(rgb.r,rgb.g,rgb.b);
			
			txtTF = new TextField();txtTF.embedFonts = true;
			txtFormat.size = sW * 0.083 * 0.18;
			txtTF.defaultTextFormat = txtFormat;
			txtTF.text = "r:"+rgb.r+" g:"+rgb.g+" b:"+rgb.b;
			txtTF.selectable = false; 
			txtTF.autoSize = TextFieldAutoSize.CENTER;
			txtTF.x = c1Sprite.x + c1Sprite.width;
			txtTF.y = txtTF.height*1.5;
			addChild(txtTF);
			
			txtTF = new TextField();txtTF.embedFonts = true;
			txtFormat.size = sW * 0.083 * 0.18;
			txtTF.defaultTextFormat = txtFormat;
			txtTF.text = "h:"+hsb.h+" s:"+hsb.s+" b:"+hsb.b;
			txtTF.selectable = false; 
			txtTF.autoSize = TextFieldAutoSize.CENTER;
			txtTF.x = c1Sprite.x + c1Sprite.width;
			txtTF.y = txtTF.height*2.75;
			addChild(txtTF);
			
			c2Sprite = new Sprite;
			c2Sprite.graphics.beginFill(newColor); c2Sprite.graphics.drawRect(0, 0, sW*0.05, sW*0.05);
			c2Sprite.y = c2Sprite.height*1.75;
			
			nameTxt = new TextField;nameTxt.embedFonts = true;
			txtFormat.size = sW * 0.083 * 0.3;
			nameTxt.defaultTextFormat = txtFormat;
			nameTxt.text = ConvertColor.UintToHexString(newColor);
			nameTxt.type = TextFieldType.INPUT;
			nameTxt.background = true;
			nameTxt.backgroundColor = CustomUI.color2;
			nameTxt.autoSize = TextFieldAutoSize.CENTER;
			nameTxt.maxChars = 6;
			nameTxt.x = c2Sprite.x + c2Sprite.width;
			nameTxt.y = c2Sprite.y;
			//nameTxt.addEventListener(Event.CHANGE, onTxtChange);
			
			var sp1:Sprite = new Sprite;
			sp1.graphics.lineStyle(sW*0.001, CustomUI.color1); sp1.graphics.beginFill(CustomUI.color2); 
			sp1.graphics.drawRect(0,0,sW * 0.05, nameTxt.height); sp1.graphics.endFill();
			var sp2:Sprite = new CheckIcon;
			sp2.scaleX = sp2.scaleY = (sH * 0.083 / 75);
			var cT:ColorTransform = new ColorTransform;
			cT.color = CustomUI.color1;
			sp2.transform.colorTransform = cT;
			sp2.x = sp1.width / 2;
			sp2.y = sp1.height / 2;
			sp1.addChild(sp2);
			sp1.x = width - sp1.width * 1.1;
			sp1.y = nameTxt.y;
			
			sp1.addEventListener(MouseEvent.CLICK, onTxtChange);
			
			
			rgb = ConvertColor.HexToRGB(newColor);
			hsb = ConvertColor.RGBToHSB(rgb.r,rgb.g,rgb.b);
			
			rCS = new CustomSlider("Red",rgb.r,0,255,null,sW*0.2,sH/5);
			rCS.y = c2Sprite.y + c2Sprite.height/2;
			rCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(rCS);
			
			gCS = new CustomSlider("Green",rgb.g,0,255,null,sW*0.2,sH/5);
			gCS.y = rCS.y + 2.5*rCS.height/4;
			gCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(gCS);
			
			bCS = new CustomSlider("Blue",rgb.b,0,255,null,sW*0.2,sH/5);
			bCS.y = gCS.y + 2.5*gCS.height/4;
			bCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(bCS);
			
			hCS = new CustomSlider("Hue",hsb.h,0,360,null,sW*0.2,sH/5);
			hCS.y = bCS.y + 2.5*bCS.height/4;
			hCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(hCS);
			
			sCS = new CustomSlider("Saturation",hsb.s,0,100,null,sW*0.2,sH/5);
			sCS.y = hCS.y + 2.5*hCS.height/4;
			sCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(sCS);
			
			brCS = new CustomSlider("Brightness",hsb.b,0,100,null,sW*0.2,sH/5);
			brCS.y = sCS.y + 2.5*sCS.height/4;
			brCS.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			addChild(brCS);
			
			addChild(c2Sprite);
			addChild(nameTxt);
			addChild(sp1);
		}
		
		private function terminateDrag(e:MouseEvent):void 
		{
			var cS:CustomSlider = e.currentTarget as CustomSlider;
			
			var rgb:Object = ConvertColor.HexToRGB(newColor);	
			var hsb:Object = ConvertColor.RGBToHSB(rgb.r,rgb.g,rgb.b);
			
			var onlyRGB:Boolean = false;
			
			switch(cS)
			{
				case rCS: 	rgb.r = cS.value;	onlyRGB=true;	break;
				case gCS: 	rgb.g = cS.value;	onlyRGB=true;	break;
				case bCS: 	rgb.b = cS.value;	onlyRGB=true;	break;
				case hCS: 	hsb.h = cS.value;	onlyRGB=false;	break;
				case sCS: 	hsb.s = cS.value;	onlyRGB=false;	break;
				case brCS: 	hsb.b = cS.value;	onlyRGB=false;	break;
			}
			
			if(!onlyRGB)
			{
				rgb = ConvertColor.HSBToRGB(hsb.h,hsb.s,hsb.b);
			}
			
			newColor = ConvertColor.RGBToHex(rgb.r,rgb.g,rgb.b);
			ToolManager.fillColor = newColor;
			
			createUI();
		}
		
		private function onTxtChange(e:MouseEvent):void
		{
			newColor = uint("0x" + nameTxt.text);
			ToolManager.fillColor = newColor;
			
			createUI();
		}
		
		public function update():void
		{
			oldColor = ToolManager.fillColor;
			
			createUI();
		}
	}
}