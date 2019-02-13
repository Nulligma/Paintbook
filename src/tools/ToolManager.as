package tools 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import settings.System;
	import tools.brushes.Preset;
	import tools.bucket.BucketTool;
	import tools.clip.ClipTool;
	import tools.copy_paste.CopyPasteTool;
	import tools.lasso.LassoTool;
	import tools.line.LineData;
	import tools.line.LineTool;
	import tools.mag.MagGlassTool;
	import tools.picker.PickerTool;
	import tools.scroll.ScrollTool;
	import tools.shape.ShapeData;
	import tools.shape.ShapeTool;
	import tools.smudge.SmudgeData;
	import tools.smudge.SmudgeTool;
	import tools.spray.SprayData;
	import tools.spray.SprayTool;
	import tools.text.TextData;
	import tools.text.TextTool;
	
	import tools.blur.BlurData;
	import tools.blur.BlurTool;
	import tools.brushes.BrushData;
	import tools.brushes.BrushTool;
	import tools.eraser.EraserData;
	import tools.eraser.EraserTool;
	import tools.transform.TransformTool;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class ToolManager
	{
		static public var initialized:Boolean = false;
		
		static private var _lineColor:uint = 0x000000;
		static private var _fillColor:uint = 0X000000;
		
		static private var _toolArray:Array;
		static private var _toolPropArray:Array;
		static private var _activeTools:Array;
		
		static private var _currentToolProp:*=null;
		static private var _currentSingleActive:int = -1;
		
		static private var _canvas:Sprite;
		static private var _bitdata:BitmapData;
		
		static private var _artBrushSprite:Array;
		static private var _calBrushSprite:Array;
		
		static private var _clipRect:Rectangle;
		static private var _lassoMask:Sprite;
		static private var _inverseMask:BitmapData;
		
		public function ToolManager() 
		{
			
		}
		
		static public function initTool():void
		{
			_toolArray = new Array;
			_toolPropArray = new Array;
			_activeTools = new Array;
			
			initBrushes();
			Preset.load();
			
			for (var i:int = 0; i < ToolType.TOTAL_TOOLS; i++)
			{
				switch(i)
				{
					case ToolType.BRUSH: 
						_toolArray[i] = BrushTool.instance;
						_toolPropArray[i] = BrushData.instance;
					break;
					
					case ToolType.ERASER:
						_toolArray[i] = EraserTool.instance;
						_toolPropArray[i] = EraserData.instance;
					break;
					
					case ToolType.SPRAY:
						_toolArray[i] = SprayTool.instance;
						_toolPropArray[i] = SprayData.instance;
					break;
					
					case ToolType.BLUR:
						_toolArray[i] = BlurTool.instance;
						_toolPropArray[i] = BlurData.instance;
					break;
					
					case ToolType.SMUDGE:
						_toolArray[i] = SmudgeTool.instance;
						_toolPropArray[i] = SmudgeData.instance;
					break;
					
					case ToolType.TRANSFORM:
						_toolArray[i] = TransformTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.BUCKET:
						_toolArray[i] = BucketTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.SHAPE:
						_toolArray[i] = ShapeTool.instance;
						_toolPropArray[i] = ShapeData.instance;
					break;
					
					case ToolType.SCROLL:
						_toolArray[i] = ScrollTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.CLIP:
						_toolArray[i] = ClipTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.MAG_GLASS:
						_toolArray[i] = MagGlassTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.PICKER:
						_toolArray[i] = PickerTool.instance;
						_toolPropArray[i] = null;
					break;
					
					case ToolType.LINE:
						_toolArray[i] = LineTool.instance;
						_toolPropArray[i] = LineData.instance;
					break;
					
					case ToolType.TEXT:
						_toolArray[i] = TextTool.instance;
						_toolPropArray[i] = TextData.instance;
					break;
					
					case ToolType.LASSO:
						_toolArray[i] = LassoTool.instance;
						_toolPropArray[i] = null;
					break;
				}
			}
			
			initialized = true;
		}
		
		static private function initBrushes():void 
		{
			_artBrushSprite = new Array(new RoundBrush, new SquareBrush, new AirBrush1, new AirBrush2, new AirBrush3, 
										new DryBrush, new DryBrush2, new RoundFancy, new SnowFlake, new StarBrush, 
										new CircleFrame,new StarFrame, new RoundStroke, new RoundStrokeHatched, new RoundStrokeRagged,
										new RoundStrokeDotted, new CestBrush, new SplatBrush1,new SplatBrush2, new RiggedBrush1,
										new RiggedBrush2, new DoubleRound, new SquareWater, new RoundWater, new ChalkDot, new ChalkLine,
										new Chalk1, new Chalk2,new Chalk3,new Chalk4);
			
			_calBrushSprite = new Array(new DiagBrush, new DiagBrush2, new DiagBrush3, new HoriBrush, new HoriBrush2,
										new HoriBrush3, new VerBrush, new VerBrush2, new VerBrush3, new RoundDiag,
										new RoundDiagOpp, new RoundHori, new RoundVert, new ThinDiag, new ThinDiagOpp,
										new ThinHori, new ThinVert, new ThinHoriRound, new SprayDiag, new SprayDiagOpp,
										new SprayHori, new SprayVert, new DoubleDiag, new DoubleDiagOpp, new DoubleHori,
										new DoubleVert,new SlantedHori,new SlantedVert,new SlantedDiag,new SlantedDiagOpp);
		}
		
		static public function workArea(canvas:Sprite, bitData:BitmapData):void
		{
			_canvas = canvas;
			_bitdata = bitData;
			
			var activeClone:Array = activeTools.slice();
			
			for each(var tool:int in activeClone)
			{
				if (tool == ToolType.MAG_GLASS) continue;
				toggle(tool);
				
				if (ToolType.multiActive.indexOf(tool) != -1) continue;
				toggle(tool);
			}
		}
		
		static public function toggle(toolType:int):void
		{
			if (ToolType.multiActive.indexOf(toolType) == -1)
				_currentToolProp = null;
			
			if(activeTools.indexOf(toolType) == -1)
			{
				if (ToolType.multiActive.indexOf(toolType) != -1 && currentSingleActive!=-1)
					_currentToolProp = _toolPropArray[currentSingleActive];
				else
					_currentToolProp = _toolPropArray[toolType];
				
				activeTools.push(toolType);
				_toolArray[toolType].activate(_canvas, _bitdata);
			}
			else
			{
				_toolArray[toolType].deactivate();
				activeTools.splice(activeTools.indexOf(toolType), 1);
			}
			
			if (ToolType.multiActive.indexOf(toolType) == -1)
			{
				if (_currentSingleActive != -1 && _currentSingleActive != toolType)
				{
					_toolArray[_currentSingleActive].deactivate();
					activeTools.splice(activeTools.indexOf(_currentSingleActive), 1);
					
					_currentSingleActive = toolType;
				}
				else
				{
					if (activeTools.indexOf(toolType) != -1) 
						_currentSingleActive = toolType;
					else
						_currentSingleActive = -1;
				}
			}
		}
		
		static public function getInstanceOf(toolType:int):*
		{
			return  _toolPropArray[toolType];
		}
		
		static public function get lineColor():uint 
		{
			return _lineColor;
		}
		
		static public function set lineColor(value:uint):void 
		{
			_lineColor = value;
		}
		
		static public function get fillColor():uint
		{
			return _fillColor;
		}
		
		static public function set fillColor(value:uint):void 
		{
			_fillColor = value;
		}
		
		static public function get currentToolProp():* 
		{
			return _currentToolProp;
		}
		
		static public function get activeTools():Array 
		{
			return _activeTools;
		}
		
		static public function get currentSingleActive():int 
		{
			return _currentSingleActive;
		}
		
		static public function get clipRect():Rectangle 
		{
			return _clipRect;
		}
		
		static public function set clipRect(value:Rectangle):void 
		{
			_clipRect = value;
		}
		
		static public function get artBrushSprite():Array 
		{
			return _artBrushSprite;
		}
		
		static public function get calBrushSprite():Array 
		{
			return _calBrushSprite;
		}
		
		static public function get workingCanvas():Sprite
		{
			return _canvas;
		}
		
		static public function get lassoMask():Sprite 
		{
			return _lassoMask;
		}
		
		static public function set lassoMask(value:Sprite):void 
		{
			_lassoMask = value;
			
			if (_inverseMask)
				_inverseMask.dispose();
			
			if (_lassoMask == null)
				return;
			
			/*_inverseMask = new BitmapData(System.canvasWidth, System.canvasHeight, true, 0xFFFFFFFF);
			_inverseMask.draw(_lassoMask);
			
			_inverseMask.threshold(_inverseMask,_inverseMask.rect,new Point(0,0),"<",0xFFFFFFFF,0x00FF0000); */
		}
		
		static public function get inverseMask():BitmapData 
		{
			return _inverseMask;
		}
		
		
	}

}