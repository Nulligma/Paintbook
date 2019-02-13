package tools.shape
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Design extends Sprite
	{
		private var _size:int;
		
		private var container:Sprite;
		
		private var _lineThick:uint;
		private var _lineColor:uint;
		private var _fillColor:uint;
		private var _edges:uint;
		
		public function Design(type:String,size:int=50,lineThick:uint=0,lineColor:uint=0x000000,fillColor:uint=0x000000,edges:uint=5) 
		{
			_size = size;
			
			_lineThick = lineThick;
			_lineColor = lineColor;
			_fillColor = fillColor;
			
			_edges = edges<3?3:edges;
			_edges = edges>15?15:edges;
			
			container = new Sprite;
			
			if(type == "circle")
				drawCircle();
			else if(type == "star")
				drawMultiStar(edges);
			else if(type == "polygon")
				drawPolygon(edges);
			else if(type == "square")
				drawSquare();
		}
		
		private function drawSquare():void
		{
			container.graphics.lineStyle(_lineThick,_lineColor)
			container.graphics.beginFill(_fillColor);
			container.graphics.drawRect(0, 0, _size*2, _size*2);
			container.graphics.endFill();
			addChild(container);
		}
		
		private function drawCircle():void
		{
			container.graphics.lineStyle(_lineThick,_lineColor)
			container.graphics.beginFill(_fillColor);
			container.graphics.drawCircle(0,0,_size);
			container.graphics.endFill();
			container.x = container.width/2;
			container.y = container.height/2;
			addChild(container);
		}
		
		private function drawMultiStar(points:uint,angle : Number = 0) : void
		{
			var x:Number = 0 , y:Number = 0;
			points = _edges;
			
			var innerRadius:Number = _size - _size/2, outerRadius:Number = _size;
			
			if (points > 2) {
				var step : Number, halfStep : Number, start : Number, n : Number, dx : Number, dy : Number;
				step = (Math.PI * 2) / points;
				halfStep = step / 2;
				start = (angle / 180) * Math.PI;
				container.graphics.lineStyle(_lineThick,_lineColor);
				container.graphics.beginFill(_fillColor);
				container.graphics.moveTo( x + (Math.cos( start ) * outerRadius), y - (Math.sin( start ) * outerRadius) );
				for (n = 1; n <= points; ++n) {
					dx = x + Math.cos( start + (step * n) - halfStep ) * innerRadius;
					dy = y - Math.sin( start + (step * n) - halfStep ) * innerRadius;
					container.graphics.lineTo( dx, dy );
					dx = x + Math.cos( start + (step * n) ) * outerRadius;
					dy = y - Math.sin( start + (step * n) ) * outerRadius;
					container.graphics.lineTo( dx, dy );
				}
				container.graphics.endFill();
				container.x = container.width/2;
				container.y = container.height/2;
				addChild(container);
			}
		}
		
		private function drawPolygon(sides : uint,angle : Number = 0) : void 
		{
			var x:Number = 0 , y:Number = 0;
			sides = _edges;
			
			var step : Number, start : Number, n : Number, dx : Number, dy : Number;
			step = (Math.PI * 2) / sides;
			start = (angle / 180) * Math.PI;
			
			container.graphics.lineStyle(_lineThick,_lineColor);
			container.graphics.beginFill(_fillColor);
			container.graphics.moveTo( x + (Math.cos( start ) * _size), y - (Math.sin( start ) * _size) );
			for (n = 1; n <= sides; ++n) {
				dx = x + Math.cos( start + (step * n) ) * _size;
				dy = y - Math.sin( start + (step * n) ) * _size;
				container.graphics.lineTo( dx, dy );
			}
			container.graphics.endFill();
			container.x = container.width/2;
			container.y = container.height/2;
			addChild(container);
			
		}

	}
	
}
