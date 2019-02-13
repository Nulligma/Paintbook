package colors.setups 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Swatches 
	{
		static private var swatchArray:Array;
		
		public function Swatches() 
		{
			
		}
		
		public static function get SwatchNames():Array
		{
			return swatchArray[0];
		}
		
		public static function getSwatchColors(swatchName:String):Array
		{
			for (var i:int = 0; i < swatchArray[0].length; i++)
			{
				if (swatchName == swatchArray[0][i])
				{
					return swatchArray[i + 1];
				}
			}
			return new Array;
		}
		
		private static function setCustomName(oldName:String, newName:String):void
		{
			var index:int;
			
			for (var i:int = 0; i < swatchArray[0].length; i++)
			{
				if (swatchArray[0][i] == oldName)
				{
					index = i;
				}
				if (swatchArray[0][i] == newName || newName=="Spectrum")
				{
					return;
				}
			}
			swatchArray[0][index] = newName;
		}
		
		public static function setCustomColors(swatchName:String, index:int,color:uint):void
		{
			for (var i:int = 12; i < swatchArray[0].length; i++)
			{
				if (swatchName == swatchArray[0][i])
				{
					swatchArray[i + 1][index] = color;
					save();
					return;
				}
			}
		}
		
		public static function save()
		{
			var so:SharedObject = SharedObject.getLocal("Swatches", "/");
			
			so.data.custom1 = swatchArray[13];
			so.data.custom2 = swatchArray[14];
			so.data.custom3 = swatchArray[15];
			so.data.custom4 = swatchArray[16];
		}
		
		public static function load()
		{
			swatchArray = new Array( 
									new Array("Snow", "LightSkin", "DarkSkin", "Sky", "Fire", "Tree", "Soil", "Water", "Wood", "Sand", "Rose","Gold", "Custom1", "Custom2", "Custom3", "Custom4"),
									new Array(0xCDC9C9, 0xDAD7D7, 0xE6E4E4, 0xF3F2F2, 0xF4F1F1, 0xADACAC, 0xD0CFCF, 0x616160, 0x1A1A13, 0x93949A, 0xBDC0BD, 0xBEE1FA),
									new Array(0xE8C1B9, 0xFFB3AB, 0xFFCAB8, 0xE8B69C, 0xFFCEAB, 0xFFE2C5, 0xFFEEDD, 0xFFDDAA, 0xFFC484, 0xFFDD99, 0xFFE2C5, 0xFFEEDD),
									new Array(0xFFDD99, 0xFFC484, 0xFDC86A, 0xF1A875, 0xBF9F6C, 0xB49157, 0x9B7234, 0xA48A6F, 0x624830, 0x4B3524, 0x382217, 0x1E120C),
									new Array(0xADD5F7, 0x7FB2F0, 0x4E7AC7, 0x35478C, 0x16193B, 0x5CAACC, 0x60767F, 0xC0ECFF, 0x3A6A7F, 0x74D5FF, 0x1441F7, 0x1510F0),
									new Array(0xFFF080, 0xF7C245, 0xE58222, 0xBA4410, 0x8C1C03, 0x690C07, 0x590202, 0x400101, 0x0D0D0D, 0xFF2308, 0xF55C0A, 0xAD0B04),
									new Array(0x769D0C, 0x89B41C, 0x50972F, 0x356B13, 0x466100, 0xFBFFA3, 0xA7D63B, 0x508A45, 0x918F5D, 0x61603D, 0xE3F2AC, 0x8C765A),
									new Array(0xFFE2B0, 0xE5CB9E, 0xBFA984, 0x7F7158, 0x433B2E, 0x997024, 0xCCAD52, 0xBDA76B, 0xC28F52, 0x996245, 0xFFBA72, 0x402810),
									new Array(0xB0DAFF, 0x325B7F, 0x64B7FF, 0x586D7F, 0x5092CC, 0x4DDDFF, 0x009EFF, 0x2B4BFA, 0x11BAD9, 0x4678E8, 0x53BCB7, 0x6A9989),
									new Array(0x947854, 0x7A7748, 0x4F3C0E, 0x4D412F, 0x291202, 0xE5E5E3, 0xBFB493, 0x594B31, 0x403527, 0x261D15, 0x52452C, 0x401D14),
									new Array(0xE8BC67, 0xE8BC67, 0xFFC47E, 0xE89A67, 0xFF9571, 0xFFD57F, 0xE5BF72, 0xBF9F5F, 0x7F6A3F, 0x403520, 0xA3845D, 0x875C4E),
									new Array(0xFFFFFF, 0xFFE7E0, 0xF5D7C2, 0xEBB3A2, 0xE78091, 0xE66D7D, 0xA76262, 0xEFB0B6, 0xFF6F9B, 0x94294E, 0x7F2742, 0x630F2C),
									new Array(0xFFEF99, 0xFFEE93, 0xFFEC88, 0xFFE972, 0xFFE34D, 0xFFE141, 0xFFDE2B, 0xFED600, 0xFFD700, 0xEEC900, 0xCDAD00, 0x8B7500),
									new Array(0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000),
									new Array(0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000),
									new Array(0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000),
									new Array(0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000)
			);
			
			var so:SharedObject = SharedObject.getLocal("Swatches", "/");
			
			if (so.data.custom1 != undefined)
			{
				swatchArray[13] = so.data.custom1;
				swatchArray[14] = so.data.custom2;
				swatchArray[15] = so.data.custom3;
				swatchArray[16] = so.data.custom4;
			}
		}
		
	}

}