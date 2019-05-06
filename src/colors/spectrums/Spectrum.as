package colors.spectrums 
{
	import colors.colorGradient.ColorSpectrumChart;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class Spectrum 
	{
		static private var _gradLinearSpectrum:ColorSpectrumChart;
		static private var _smallGradientLinear:ColorSpectrumChart;
		static private var _radialSpectrum:ColorSpectrumChart;
		static private var _linearSpectrum:Bitmap;
		
		public function Spectrum() 
		{
			
		}
		
		static public function createSpectrum(sW:int, sH:int):void
		{
			_gradLinearSpectrum = new ColorSpectrumChart;
			_gradLinearSpectrum.gradientLinear(sW * 0.49, sH * 0.67, true);
			
			_smallGradientLinear = new ColorSpectrumChart;
			_smallGradientLinear.gradientLinear(sW * 0.24, sH * 0.4, true);
			
			_radialSpectrum = new ColorSpectrumChart;
			_radialSpectrum.polar(sW * 0.068, sW * 0.068);
			
			var bm:ColorSpectrumChart = new ColorSpectrumChart;
			bm.linear(sW * 0.3, sH * 0.207, true);
			
			_linearSpectrum = new Bitmap;
			_linearSpectrum.bitmapData = new BitmapData(sW * 0.4, sH * 0.207, false);
			_linearSpectrum.bitmapData.copyPixels(bm.bitmapData, bm.bitmapData.rect, new Point(0, 0));
			
			_linearSpectrum.bitmapData.fillRect(new Rectangle(sW * 0.3, 0, sW * 0.05, sH * 0.207), 0x000000);
			_linearSpectrum.bitmapData.fillRect(new Rectangle(sW * 0.35, 0, sW * 0.05, sH * 0.207), 0xFFFFFF);
		}
		
		static public function get radialSpectrum():ColorSpectrumChart 
		{
			return _radialSpectrum;
		}
		
		static public function get linearSpectrum():Bitmap 
		{
			return _linearSpectrum;
		}
		
		static public function get smallGradientLinear():ColorSpectrumChart 
		{
			return _smallGradientLinear;
		}
		
		static public function get gradLinearSpectrum():ColorSpectrumChart 
		{
			return _gradLinearSpectrum;
		}
		
	}

}