package 
{
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinThemeColor;
	import cn.flashk.controls.skin.CheckBoxSkin;
	import cn.flashk.controls.support.ColorConversion;
	import cn.flashk.controls.support.RoundRectAdvancedDraw;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	public class MyCheckBoxSkin extends CheckBoxSkin
	{
		public function MyCheckBoxSkin()
		{
		}
		
		override public function reDraw():void {
			shape.graphics.clear();
			var width:Number = 14;
			var height:Number = 14;
			SkinThemeColor.initFillStyle(shape.graphics,width,height);
			shape.graphics.lineStyle(1, SkinThemeColor.border,0.5,DefaultStyle.pixelHinting,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND,3);
			var ew:Number = 0;
			var eh:Number = 0;
			RoundRectAdvancedDraw.drawAdvancedRoundRect(shape.graphics, 1+DefaultStyle.graphicsDrawOffset, 3+DefaultStyle.graphicsDrawOffset, width, height, ew, eh, ew, eh, ew, eh, ew,eh,ew,eh);
			if (tar.selected == true) {
				shape.graphics.beginFill(ColorConversion.transformWebColor(DefaultStyle.checkBoxLineColor), 1);
				shape.graphics.drawRect(6,8,5,5);
			}
			shape.filters = DefaultStyle.filters;
			shape.cacheAsBitmap = true;
		}
	}
}