package colors.convertor
{
	public class ConvertColor
	{
		public static function UintToHexString(value:uint):String
		{
			var str:String = value.toString(16);
			
			while (str.length < 6)
			{
				str = "0" + str;
			}
			
			return str;
		}
		
		public static function RGBToHex(r:int,g:int,b:int):uint
		{
			var hex:uint = r<<16 | g<<8 | b;
			return hex;
		}
		
		public static function HexToRGB(value:uint):Object
		{
			var rgb:Object = new Object();
			rgb.r = (value >> 16) & 0xFF
			rgb.g = (value >> 8) & 0xFF
			rgb.b = value & 0xFF			
			return rgb;
		}
 
		public static function RGBToHSB(r:int, g:int, b:int):Object
		{
			var hsb:Object = new Object;
			var _max:Number = Math.max(r,g,b);
			var _min:Number = Math.min(r,g,b);
 
			hsb.s = (_max != 0) ? (_max - _min) / _max * 100: 0;
 
			hsb.b = _max / 255 * 100;
 
			if(hsb.s == 0){
				hsb.h = 0;
			}else{
				switch(_max)
				{
					case r:
						hsb.h = (g - b)/(_max - _min)*60 + 0;
						break;
					case g:
						hsb.h = (b - r)/(_max - _min)*60 + 120;
						break;
					case b:
						hsb.h = (r - g)/(_max - _min)*60 + 240;
						break;
				}
			}
 
			hsb.h = Math.min(360, Math.max(0, Math.round(hsb.h)))
			hsb.s = Math.min(100, Math.max(0, Math.round(hsb.s)))
			hsb.b = Math.min(100, Math.max(0, Math.round(hsb.b)))
 
			return hsb;
		}
 
		public static function HSBToRGB(h:int, s:int, b:int):Object
		{
			var rgb:Object = new Object();
 
			var max:Number = (b*0.01)*255;
			var min:Number = max*(1-(s*0.01));
 
			if(h == 360){
				h = 0;
			}
 
			if(s == 0){
				rgb.r = rgb.g = rgb.b = b*(255*0.01) ;
			}else{
				var _h:Number = Math.floor(h / 60);
 
				switch(_h){
					case 0:
						rgb.r = max	;
						rgb.g = min+h * (max-min)/ 60;
						rgb.b = min;
						break;
					case 1:
						rgb.r = max-(h-60) * (max-min)/60;
						rgb.g = max;
						rgb.b = min;
						break;
					case 2:
						rgb.r = min ;
						rgb.g = max;
						rgb.b = min+(h-120) * (max-min)/60;
						break;
					case 3:
						rgb.r = min;
						rgb.g = max-(h-180) * (max-min)/60;
						rgb.b =max;
						break;
					case 4:
						rgb.r = min+(h-240) * (max-min)/60;
						rgb.g = min;
						rgb.b = max;
						break;
					case 5:
						rgb.r = max;
						rgb.g = min;
						rgb.b = max-(h-300) * (max-min)/60;
						break;
					case 6:
						rgb.r = max;
						rgb.g = min+h  * (max-min)/ 60;
						rgb.b = min;
						break;
				}
 
				rgb.r = Math.min(255, Math.max(0, Math.round(rgb.r)))
				rgb.g = Math.min(255, Math.max(0, Math.round(rgb.g)))
				rgb.b = Math.min(255, Math.max(0, Math.round(rgb.b)))
			}
			return rgb;
		}
		
		public static function RGBtoHSL(r:Number, g:Number, b:Number):Object
		{
			var hsl:Object = new Object();
			
			r /= 255, g /= 255, b /= 255;
			var max = Math.max(r, g, b), min = Math.min(r, g, b);
			var h, s, l = (max + min) / 2;

			if(max == min){
				h = s = 0; // achromatic
			}else{
				var d = max - min;
				s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
				switch(max){
					case r: h = (g - b) / d + (g < b ? 6 : 0); break;
					case g: h = (b - r) / d + 2; break;
					case b: h = (r - g) / d + 4; break;
				}
				h /= 6;
			}
			
			hsl.h = h; hsl.s = s; hsl.l = l;
			
			return hsl;
		}

		/**
		 * Converts an HSL color value to RGB. Conversion formula
		 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
		 * Assumes h, s, and l are contained in the set [0, 1] and
		 * returns r, g, and b in the set [0, 255].
		 *
		 * @param   Number  h       The hue
		 * @param   Number  s       The saturation
		 * @param   Number  l       The lightness
		 * @return  Array           The RGB representation
		 */
		public static function HSLtoColor(h:Number, s:Number, l:Number):uint
		{
			var r:Number, g:Number, b:Number;
			
			if (s == 0)
			{
				r = g = b = l; // achromatic
			}else
			{
				function hue2rgb(p:Number, q:Number, t:Number)
				{
					if(t < 0) t += 1;
					if(t > 1) t -= 1;
					if(t < 1/6) return p + (q - p) * 6 * t;
					if(t < 1/2) return q;
					if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
					return p;
				}
				
				var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
				var p = 2 * l - q;
				r = hue2rgb(p, q, h + 1/3);
				g = hue2rgb(p, q, h);
				b = hue2rgb(p, q, h - 1/3);
			}
			
			return RGBToHex(r * 255, g * 255, b * 255);
		}
		
		/*
		public static function RGBtoHSL(r:Number, g:Number, b:Number):Object
		{
			var hsl:Object = new Object;
			r /= 255, g /= 255, b /= 255;
			var max:Number = Math.max(Math.max(r, g), b); var min:Number = Math.min(Math.min(r, g), b);
			hsl.l = (max + min) / 2;

			if (max == min)
			{
				hsl.h = hsl.s = 0;
			}else
			{
				var d = max - min;
				hsl.s = (max - min) / max;
				switch(max)
				{
					case r: hsl.h = (60 * (g - b) / d + 360) % 360; break;
					case g: hsl.h = 60 * (b - r) / d + 120 ; break;
					case b: hsl.h = 60 * (r - g) / d+ 240 ; break;
				}
			}

			return hsl;
		}
		
		public static function HSLtoColor(a:Number = 1, hue:Number = 0, saturation:Number = 0.5, lightness:Number = 1):uint
		{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-0.5*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		*/
		public static function changeColorComponent(color:uint, component:String, value:Number = -1.00, percent:Number = 1.00, decrement:Number = -1.00, increment:Number = -1.00):uint
		{
			var rgb:Object;
			var hsl:Object;
			var hsb:Object;
			var newColor:uint;
			
			switch(component)
			{
				case ColorComponent.LUMINANCE:
					
					rgb = HexToRGB(color);
					hsl = RGBtoHSL(rgb.r, rgb.g, rgb.b);
					
					if(value != -1)
						hsl.l = value;
					else if (decrement != -1)
					{
						hsl.l = hsl.l - decrement < 0?0:hsl.l - decrement;
					}
					else if(increment != -1)
						hsl.l = hsl.l + increment > 100?100:hsl.l + increment;
					else
						hsl.l *= percent;
					
					newColor = HSLtoColor(hsl.h, hsl.s, hsl.l);
				break;
			}
			
			return newColor;
		}
	}
}