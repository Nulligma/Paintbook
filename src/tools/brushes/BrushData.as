package tools.brushes 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import layers.filters.FiltersManager;
	import tools.ToolType;
	
	import tools.ToolManager;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class BrushData
	{
		static private var _instance:BrushData;
		
		private var _size:uint;
		private var _bluredSize:uint;
		private var _flow:Number;
		private var _smoothness:uint;
		private var _alpha:Number;
		private var _spacing:Number;
		private var _pressureSensivity:Number;
		private var _type:String;
		private var _brushIndex:int;
		
		private var _xSymmetry:Boolean;
		private var _ySymmetry:Boolean;
		private var _randomColor:Boolean;
		private var _randomRotate:Boolean;
		private var _scattering:Boolean;
		
		private var _pattern:Sprite;
		
		private var _blur:BlurFilter;
		private var _filterManager:FiltersManager;
		
		private var _scaleVector:Vector.<BitmapData>;
		private var _rotationVector:Vector.<BitmapData>;
		private var _brushBitData:BitmapData;
		private var _scalingFactor:Number;
		
		private var colorTrans:ColorTransform;
		
		public function BrushData() 
		{
			if (_instance)
				throw new Error("BrushData singleTon Error");
		}
		
		public function setDefault():void
		{
			_size = 35; _flow = 0.3; _smoothness = 0; _alpha = 1; _spacing = 1;
			_randomRotate = false; _scattering = false; _randomColor = false; _xSymmetry = false; _ySymmetry = false;
			
			_type = "Art"; _brushIndex = 0;
			
			_pressureSensivity = 0;
			
			colorTrans = new ColorTransform;
			colorTrans.color = ToolManager.fillColor;
			
			_pattern = ToolManager.artBrushSprite[_brushIndex];
			
			_blur = new BlurFilter;
			_blur.quality = 2;
			
			_filterManager = FiltersManager.getInstance();
			
			adjustBrush();
		}
		
		public function adjustBrush(checkColor:Boolean = false):void
		{
			if (checkColor && colorTrans.color == ToolManager.fillColor) return;
			
			_scalingFactor = _size * 0.02;
			_pattern.scaleX = _pattern.scaleY = scalingFactor;
			
			_blur.blurX = _smoothness;
			_blur.blurY = _smoothness;
			
			var tempSize:uint = _size;
			if (_smoothness > 0)
			{
				_pattern.x = _pattern.y = _size * 0.5;
				var tempBd:BitmapData = new BitmapData(_size, _size, true, 0x000000);
				tempBd.draw(_pattern, _pattern.transform.matrix, _pattern.transform.colorTransform, null, null, true);
				
				var rect:Rectangle = tempBd.generateFilterRect(tempBd.rect, _blur);
				_bluredSize = rect.width - rect.x;
				_size = _bluredSize;
				
				tempBd.dispose();
				tempBd = null;
			}
			
			if (ToolManager.activeTools.indexOf(ToolType.BRUSH)!=-1)
			{
				_filterManager.remove(_pattern, _blur);
				_filterManager.add(_pattern, _blur);
			}
			
			colorTrans = new ColorTransform;
			colorTrans.color = ToolManager.fillColor;
			colorTrans.alphaMultiplier = _flow;
			_pattern.transform.colorTransform = colorTrans;
			
			_pattern.x = _pattern.y = _size * 0.5;
			_brushBitData = new BitmapData(_size, _size, true, 0x000000);
			_brushBitData.draw(_pattern, _pattern.transform.matrix, _pattern.transform.colorTransform,null,null,true);
			
			_pattern.x = _pattern.y = 0;
			
			if (_scattering && !_randomRotate)
			{
				if (_scaleVector)
				{
					for each(var bd:BitmapData in _scaleVector)
					{
						bd.dispose();
					}
				}
				_scaleVector = new Vector.<BitmapData>;
				var bdS:BitmapData;
				for (var i:int = 2; i <= tempSize; i++)
				{
					bdS = new BitmapData(i, i, true, 0x000000);
					_pattern.x = _pattern.y = 0;
					_pattern.scaleX = _pattern.scaleY = i * 0.02;
					_pattern.x = _pattern.y = i * 0.5;
					bdS.draw(_pattern,_pattern.transform.matrix,_pattern.transform.colorTransform);
					
					_scaleVector.push(bdS);
				}
				_pattern.scaleX = _pattern.scaleY = tempSize * 0.02;
			}
			
			if (_randomRotate && !_scattering)
			{
				if (_rotationVector)
				{
					for each(var bd2:BitmapData in _rotationVector)
					{
						bd2.dispose();
					}
				}
				_rotationVector = new Vector.<BitmapData>;
				var bdR:BitmapData;
				for (var j:int = 0; j <= 180; j+=4)
				{
					bdR = new BitmapData(_size*1.5, _size*1.5, true, 0x000000);
					_pattern.x = _pattern.y = 0;
					pattern.rotation = j;
					_pattern.x = _pattern.y = tempSize * 0.75;
					bdR.draw(_pattern, _pattern.transform.matrix, _pattern.transform.colorTransform);
					
					_rotationVector.push(bdR);
				}
			}
			
			_pattern.x = _pattern.y = 0;
			_size = tempSize;
		}
		
		public function changePattern(type:String, brushIndex:int):void
		{
			if (type == "Art")
			{
				_type = "Art"; _brushIndex = brushIndex;
				
				_pattern = ToolManager.artBrushSprite[brushIndex];
				adjustBrush();
			}
			else if (type == "Calligraphy")
			{
				_type = "Calligraphy"; _brushIndex = brushIndex;
				
				_pattern = ToolManager.calBrushSprite[brushIndex];
				adjustBrush();
			}
		}
		
		public function getSprites(type:String):Array
		{
			if (type == "Art")
				return ToolManager.artBrushSprite;
			else if (type == "Calligraphy")
				return ToolManager.calBrushSprite;
			
			return new Array;
		}
		
		public static function get instance():BrushData
		{
			if (!_instance)
			{
				_instance = new BrushData();
				_instance.setDefault();
			}
			
			return _instance;
		}
		
		public function get pattern():Sprite
		{
			return _pattern;
		}
		
		public function get size():uint 
		{
			return _size;
		}
		
		public function set size(value:uint):void 
		{
			_size = value;
			adjustBrush();
		}
		
		public function get flow():Number 
		{
			return _flow;
		}
		
		public function set flow(value:Number):void 
		{
			_flow = value;
			adjustBrush();
		}
		
		public function get smoothness():uint 
		{
			return _smoothness;
		}
		
		public function set smoothness(value:uint):void 
		{
			_smoothness = value;
			adjustBrush();
		}
		
		public function get fillColor():uint 
		{
			return ToolManager.fillColor;
		}
		
		public function set fillColor(value:uint):void 
		{
			ToolManager.fillColor = value;
			adjustBrush();
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
		
		public function get randomRotate():Boolean 
		{
			return _randomRotate;
		}
		
		public function set randomRotate(value:Boolean):void 
		{
			_randomRotate = value;
			_pattern.rotation = 0;
			adjustBrush();
		}
		
		public function get scattering():Boolean 
		{
			return _scattering;
		}
		
		public function set scattering(value:Boolean):void 
		{
			_scattering = value;
			adjustBrush();
		}
		
		public function get xSymmetry():Boolean 
		{
			return _xSymmetry;
		}
		
		public function set xSymmetry(value:Boolean):void 
		{
			_xSymmetry = value;
		}
		
		public function get ySymmetry():Boolean 
		{
			return _ySymmetry;
		}
		
		public function set ySymmetry(value:Boolean):void 
		{
			_ySymmetry = value;
		}
		
		public function get randomColor():Boolean 
		{
			return _randomColor;
		}
		
		public function set randomColor(value:Boolean):void 
		{
			_randomColor = value;
			adjustBrush();
		}
		
		public function get spacing():Number 
		{
			return _spacing;
		}
		
		public function set spacing(value:Number):void 
		{
			_spacing = value;
		}
		
		public function get brushBitData():BitmapData 
		{
			return _brushBitData;
		}
		
		public function get scalingFactor():Number 
		{
			return _scalingFactor;
		}
		
		public function get scaleVector():Vector.<BitmapData> 
		{
			return _scaleVector;
		}
		
		public function get rotationVector():Vector.<BitmapData> 
		{
			return _rotationVector;
		}
		
		public function get pressureSensivity():Number 
		{
			//return _pressureSensivity;
			return 0;
		}
		
		public function set pressureSensivity(value:Number):void 
		{
			//_pressureSensivity = value;
			_pressureSensivity = 0;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get brushIndex():int 
		{
			return _brushIndex;
		}
		
		public function get bluredSize():uint 
		{
			return _bluredSize;
		}
		
	}

}