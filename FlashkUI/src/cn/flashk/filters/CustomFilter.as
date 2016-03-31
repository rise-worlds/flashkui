package cn.flashk.filters
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	
	import cn.flashk.controls.support.ColorMatrix;

	public class CustomFilter
	{
		
		/**
		 * 浮雕效果 
		 * 
		 */
		public static function getReliefFilter(type:int=1):ConvolutionFilter
		{
			if(type==1){
				var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[-2,-1,0,-1,1,1,0,1,2]);
			}else{
				filter = new ConvolutionFilter(3,3,[-1,1,1,-1,1,1,-1,-1,1]);
			}
			return filter;
		}
		
		/**
		 * 锐化效果
		 * @return 
		 * 
		 */
		public static function getSharpenFilter():ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,5,-1,0,-1,0]);
			return filter;
		}
		
		public static function getSharpenValueFilter(a:Number=5,b:Number=1):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,-1,a,-1,0,-1,0],b);
			return filter;
		}
		
		public static function getGlowLevelFilter(level:int=3):ConvolutionFilter
		{
			var filter:ConvolutionFilter
			filter = new ConvolutionFilter(3,3,[0,-1,0,-1,-6-level+5,-1,0,-1,0],-6-level+1);
			return filter;
		}
		
		public static function getSharpenLevelFilter(level:int=0):ConvolutionFilter
		{
			var filter:ConvolutionFilter
			filter = new ConvolutionFilter(3,3,[0,-1,0,-1,level+5,-1,0,-1,0],level+1);
			return filter;
		}
		
		/**
		 * 锐化效果
		 * @return 
		 * 
		 */
		public static function getSharpenValueFilterH(value:Number=1):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-1,0,0,3,0,0,-1,0]);
			return filter;
		}
		
		/**
		 * 锐化效果
		 * @return 
		 * 
		 */
		public static function getSharpenValueFilterV(value:Number=1):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,0,0,-1,3,-1,0,0,0]);
			return filter;
		}
		
		/**
		 * 黑白边缘效果
		 * @return 
		 * 
		 */
		public static function getBlackWhiteFilter(value:Number=1.2):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,-value,0,-value,4*value,-value,0,-value,0]);
			return filter;
		}
		
		/**
		 * 黑白边缘效果
		 * @return 
		 * 
		 */
		public static function getBlackWhiteFiltersArray(value:Number=1.2):Array
		{
			var filter:ConvolutionFilter = getBlackWhiteFilter(value);
			return [filter,getSaturationFilter()];
		}
		
		/**
		 * 颜色变灰滤镜 
		 * @param value
		 * @return 
		 * 
		 */
		public static function getSaturationFilter(value:Number=-100):ColorMatrixFilter
		{
			var mat:ColorMatrix = new ColorMatrix();
			mat.adjustSaturation(value);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(mat);
			return filter;
		}
		
		/**
		 * 颜色调整滤镜 
		 * @param brightness
		 * @param contrast
		 * @param saturation
		 * @param hue
		 * @return 
		 * 
		 */
		public static function getColorAdjustFilter(brightness:Number,contrast:Number,saturation:Number,hue:Number):ColorMatrixFilter
		{
			var mat:ColorMatrix = new ColorMatrix();
			mat.adjustColor(brightness,contrast,saturation,hue);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(mat);
			return filter;
		}
		
		/**
		 * HDR变亮/暗效果 
		 * @param brightValue
		 * @return 
		 * 
		 */
		public static function getHDRBrightFilter(brightValue:Number = 3):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(1,1,[brightValue]);
			return filter;
		}
		
		/**
		 * 变亮/暗效果 
		 * @param brightValue
		 * @return 
		 * 
		 */
		public static function getBrightFilter(brightValue:Number = 100,percent:Object=null):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(1,1,[1]);
			if(percent == null){
				filter.bias = brightValue;
			}else{
				filter.bias = 255*Number(percent);
			}
			return filter;
		}
		
		public static function changeHDRBrightFilterValue(newBrightValue:Number,filter:ConvolutionFilter):void
		{
			var arr:Array = filter.matrix.slice();
			arr[0] = newBrightValue;
			filter.matrix = arr;
		}
		
		/**
		 * 边缘检测效果
		 * @return 
		 * 
		 */
		public static function getEdgeDetectionFilter():ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,[0,1,0,1,-3,1,0,1,0]);
			return filter;
		}
		
		public static function getFreezeFilter():ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter(3,3,new Array(18,-19,15,-14,5,-6,8,-17,7),-1);
			return filter;
		}
		
		public static function getFreezeFiltersArray(matrixFilterArra:Array=null):Array
		{
			if(matrixFilterArra != null){
				return [new ConvolutionFilter(3,3,new Array(18,-19,15,-14,5,-6,8,-17,7),-1),new ColorMatrixFilter(matrixFilterArra)];
			}
			return [new ConvolutionFilter(3,3,new Array(18,-19,15,-14,5,-6,8,-17,7),-1),
				new ColorMatrixFilter(new Array(0,1,0,0,0,1,1,0,0,0,1,0,25,0,255,0,0,0,1,0))];
		}

	}
}