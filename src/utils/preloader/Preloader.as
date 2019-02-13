package utils.preloader 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Preloader extends Sprite
	{
		private var w:int;
		private var h:int;
		
		private var bg:Sprite;
		private var loader:Sprite;
		
		public function Preloader(width:int,height:int) 
		{
			w = width;
			h = height;
			
			Theme.setTheme();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createLoader();
		}
		
		private function createLoader():void 
		{
			var matrix:Matrix = new Matrix();  
            matrix.createGradientBox(w,h,Math.PI/2,0,0);  
			
			bg = new Sprite;
			bg.graphics.beginGradientFill(Theme.bgType, Theme.bgColors, Theme.bgAlpha, Theme.bgRatio, matrix);
			bg.graphics.drawRect(0, 0, w, h);
			addChild(bg);
			
			loader = new Sprite;
			loader.graphics.beginGradientFill(Theme.loaderType, Theme.loaderColors, Theme.loaderAlpha, Theme.loaderRatio, matrix);
			loader.graphics.drawRect(0, 0, w, h);
			loader.width = 0;
			addChild(loader);
		}
		
		public function update(progress:Number):void
		{
			loader.width = progress*w;
		}
		
	}

}