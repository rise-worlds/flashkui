package cn.flashk.controls.support 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author flashk
	 */
	public class RoundRectAdvancedDraw 
	{
		
		 public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                topLeftRadius:Number, topRightRadius:Number, 
                                                bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var minSize:Number = width < height ? width * 2 : height * 2;
			topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
			topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
			bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
			bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
			var a:Number = bottomRightRadius * 0.292893218813453;
			var s:Number = bottomRightRadius * 0.585786437626905; 
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
			a = bottomLeftRadius * 0.292893218813453;
			s = bottomLeftRadius * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
			a = topLeftRadius * 0.292893218813453;
			s = topLeftRadius * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);
			a = topRightRadius * 0.292893218813453;
			s = topRightRadius * 0.585786437626905;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
		 
		public static function drawAdvancedRoundRect(graphics:Graphics, x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                radiusX:Number, radiusY:Number,
                                                topLeftRadiusX:Number, topLeftRadiusY:Number,
                                                topRightRadiusX:Number, topRightRadiusY:Number,
                                                bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
                                                bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			var min:Number = Math.min(maxXRadius, maxYRadius);
			maxXRadius = min;
			maxYRadius = min;
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			var aX:Number = bottomRightRadiusX * 0.292893218813453;
			var aY:Number = bottomRightRadiusY * 0.292893218813453;
			var sX:Number = bottomRightRadiusX * 0.585786437626905;
			var sY:Number = bottomRightRadiusY * 0.585786437626905; 
			graphics.moveTo(xw, yh - bottomRightRadiusY);
			graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
			graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadiusX, yh);
			graphics.curveTo(x + sX, yh, x + aX, yh - aY);
			graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadiusY);
			graphics.curveTo(x, y + sY, x + aX, y + aY);
			graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			graphics.lineTo(xw - topRightRadiusX, y);
			graphics.curveTo(xw - sX, y, xw - aX, y + aY);
			graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
			graphics.lineTo(xw, yh - bottomRightRadiusY);
		}
		
		public static function drawAdvancedRoundRectNoMax(graphics:Graphics, x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                radiusX:Number, radiusY:Number,
                                                topLeftRadiusX:Number, topLeftRadiusY:Number,
                                                topRightRadiusX:Number, topRightRadiusY:Number,
                                                bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
                                                bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			var aX:Number = bottomRightRadiusX * 0.292893218813453;
			var aY:Number = bottomRightRadiusY * 0.292893218813453;
			var sX:Number = bottomRightRadiusX * 0.585786437626905;
			var sY:Number = bottomRightRadiusY * 0.585786437626905;
			graphics.moveTo(xw, yh - bottomRightRadiusY);
			graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
			graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadiusX, yh);
			graphics.curveTo(x + sX, yh, x + aX, yh - aY);
			graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadiusY);
			graphics.curveTo(x, y + sY, x + aX, y + aY);
			graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			graphics.lineTo(xw - topRightRadiusX, y);
			graphics.curveTo(xw - sX, y, xw - aX, y + aY);
			graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
			graphics.lineTo(xw, yh - bottomRightRadiusY);
		}
		
	}
}