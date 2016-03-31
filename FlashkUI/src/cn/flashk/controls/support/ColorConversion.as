package cn.flashk.controls.support 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ColorConversion 类转换各种颜色值。
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.support.UIComponent
	 * @see UIComponent.setStyle()
	 * 
	 * @author flashk
	 */
	public class ColorConversion 
	{
		
		/**将一个十六进制的字符串（#FF3300)转换成为一个uint数字
		 * 
		 * @return 转换后的uint数字
		 */ 
		public static function transformWebColor(value:String):uint {
			if (value == "" || value == null) {
				return 0x000000;
			}
			var color:uint = uint(parseInt(value.slice(1), 16));
			return uint(parseInt(value.slice(1), 16));
		}
		
		/**将一个uint数字转换成为一个十六进制的字符串（#FF3300)
		 * 
		 * @return 转换后的带#的字符串文本
		 */ 
		public static function transUintToWeb(value:uint):String {
			return "#"+value.toString(16);
		}
		
		/**
		 * 提取从BitmapData.getPixel32()方法32位色彩中的透明度值
		 * 
		 * @return 32位色彩值中的Alpha透明度值，为0（全透明）-255（不透明）
		 */ 
		public static function getAlphaFromeARGB(value:uint):uint {
			var pixelValue:uint = value;
			var alphaValue:uint = pixelValue >> 24 & 0xFF;
			var red:uint = pixelValue >> 16 & 0xFF;
			var green:uint = pixelValue >> 8 & 0xFF;
			var blue:uint = pixelValue & 0xFF;
			return alphaValue;
		}
		
		public static function mix2ColorsBit32(a:int,b:int):uint{
			var a:int = ((a >> 24 & 0xFF)+(b >> 24 & 0xFF))/2;
			var r:int=((a >> 16 & 0xFF)+(b >> 16 & 0xFF))/2;
			var g:int=((a >> 8 & 0xFF)+(b >> 8 & 0xFF))/2;
			var b:int=((a & 0xFF)+(b & 0xFF))/2;
			return a*0xFFFFFF+g*0xFFFF+b*0xFF+r;
		}
		
		public static function getRGBAFormBit32(value:uint):Array
		{
			var pixelValue:uint = value;
			var alphaValue:uint = pixelValue >> 24 & 0xFF;
			var red:uint = pixelValue >> 16 & 0xFF;
			var green:uint = pixelValue >> 8 & 0xFF;
			var blue:uint = pixelValue & 0xFF;
			return [red,green,blue,alphaValue];
		}
		
		public static function getRInBit24(value:int):uint{
			return value >> 16 & 0xFF;
		}
		
		public static function getGInBit24(value:int):uint{
			return value >> 8 & 0xFF;
		}
		
		public static function getBInBit24(value:int):uint{
			return value >> 0 & 0xFF;
		}
		
		public static function mix2Colors(a:int,b:int):uint{
			var ar:Array = retrieveRGBComponent(a);
			var br:Array = retrieveRGBComponent(b);
			var nr:uint = (ar[0]+br[0])/2;
			var ng:uint = (ar[1]+br[1])/2;
			var nb:uint = (ar[2]+br[2])/2;
			return generateFromRGBComponent([nr,ng,nb]);
		}
		public static function mix2ColorsPercent(a:int,b:int,c:Number,d:Number):uint{
			var ar:Array = retrieveRGBComponent(a);
			var br:Array = retrieveRGBComponent(b);
			var nr:uint = (ar[0]*c+br[0]*d)/2;
			var ng:uint = (ar[1]*c+br[1]*d)/2;
			var nb:uint = (ar[2]*c+br[2]*d)/2;
			return generateFromRGBComponent([nr,ng,nb]);
		}
		
		
		/* 输入一个颜色,将它拆成三个部分: 
		* 红色,绿色和蓝色 
		*/  
		public static function retrieveRGBComponent( color:uint ):Array  
		{  
			var r:Number = (color >> 16) & 0xff;  
			var g:Number = (color >> 8) & 0xff;  
			var b:Number = color & 0xff;  
			
			return [r, g, b];  
		}  
		
		/* 
		* 红色,绿色和蓝色三色组合 
		*/  
		public static function generateFromRGBComponent( rgb:Array ):uint  
		{  
			if( rgb == null || rgb.length != 3 ||   
				rgb[0] < 0 || rgb[0] > 255 ||  
				rgb[1] < 0 || rgb[1] > 255 ||  
				rgb[2] < 0 || rgb[2] > 255 )  
				return 0xFFFFFF;  
			return rgb[0] << 16 | rgb[1] << 8 | rgb[2];  
		}	
		
		/*
		*  双线性插值缩放
		*/
		public static function scale(srcBMP:Bitmap,destW:Number,destH:Number):Bitmap
		{
			var destBMP:Bitmap = null;
			var destData:BitmapData = new BitmapData(destW,destH);
			
			
			var srcData:BitmapData = srcBMP.bitmapData;
			var srcW:Number = srcBMP.width;
			var srcH:Number = srcBMP.height;
			
			var scaleX:Number = srcW/destW;
			var scaleY:Number = srcH/destH
			destData.lock();
			for(var j:int=0;j<=destH;j++){     //j为目标图像的纵坐标
				for(var i:int=0;i<=destW;i++){   //i为目标图像的横坐标
					//坐标进行反向变化
					var srcX:Number = i*scaleX;
					var srcY:Number = j*scaleY;
					
					var m:int = int(srcX); //m为源图像横坐标的整数部分
					var n:int = int(srcY); //n为源图像纵坐标的整数部分
					var u:Number = srcX-m; //p为源图像横坐标小数部分
					var v:Number = srcY-n; //r为源图像纵坐标的小数部分
					
					//公式  f(m+p,n+r) = (1-p)(1-r)*f(m,n) + (1-p)r*f(m,n+1) + p(1-r)f(m+1,n) + p*r*f(m+1,n+1)
					
					//将颜色分解成  r,g,b
					var ca:uint = srcData.getPixel(m,n);
					var cb:uint = srcData.getPixel(m,n+1);
					var cc:uint = srcData.getPixel(m+1,n);
					var cd:uint = srcData.getPixel(m+1,n+1);
					
					var aArray:Array = [(ca >> 16) & 0xff,(ca >> 8) & 0xff,ca & 0xff];
					var bArray:Array = [(cb >> 16) & 0xff,(cb >> 8) & 0xff,cb & 0xff];
					var cArray:Array = [(cc >> 16) & 0xff,(cc >> 8) & 0xff,cc & 0xff];
					var dArray:Array = [(cd >> 16) & 0xff,(cd >> 8) & 0xff,cd & 0xff];
					
					
					var r:Number =  (1-u)*(1-v)*aArray[0]+(1-u)*v*bArray[0]+u*(1-v)*cArray[0]+ u*v*dArray[0];
					var g:Number =  (1-u)*(1-v)*aArray[1]+(1-u)*v*bArray[1]+u*(1-v)*cArray[1]+ u*v*dArray[1];
					var b:Number =  (1-u)*(1-v)*aArray[2]+(1-u)*v*bArray[2]+u*(1-v)*cArray[2]+ u*v*dArray[2]; 
					// r,g,b合成颜色
					var color:uint = r << 16 | g << 8 | b;
					//设置目标图像某点的颜色                      
					destData.setPixel(i,j,color);
				}  
			}
			destData.unlock();
			destBMP = new Bitmap(destData);
			return destBMP;
		}


	}
}