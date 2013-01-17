package cn.flashk.controls.skin 
{
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.support.UIComponent;
	import cn.flashk.controls.ToggleButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import cn.flashk.controls.managers.ThemesSet;
	import cn.flashk.controls.modeStyles.ButtonStyle;
	import cn.flashk.controls.support.RoundRectAdvancedDraw;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	import cn.flashk.controls.managers.SkinThemeColor;

	/**
	 * ...
	 * @author flashk
	 */
	public class ToggleButtonSkin extends ToggleDrawSkin
	{
		private var tar:ToggleButton;
		private var mot:MotionSkinControl;
		private var shape:Shape;
		private var styleSet:Object;
		
		public function ToggleButtonSkin() 
		{
			shape = new Shape();
		}
		
		override public function init(target:UIComponent,styleSet:Object):void {
			this.styleSet = styleSet;
			tar = target as ToggleButton;
			DisplayObjectContainer(target).addChildAt(shape, 0);
			mot = new MotionSkinControl(tar, shape);
			shape.x = 0.5;
			shape.y = 1.5;
			reDraw();
		}
		
		override public function updateToggleView(isSelect:Boolean):void {
			super.updateToggleView(isSelect);
		}
		
		override public function hideOutState():void {
			super.hideOutState();
			shape.alpha = 0;
			mot.setOutViewHide(true);
		}
		
		override public function reDraw():void {
			shape.graphics.clear();
			var colors:Array = [SkinThemeColor.top, SkinThemeColor.upperMiddle, SkinThemeColor.lowerMiddle, SkinThemeColor.bottom];
			var alphas:Array = [1.0, 1.0, 1.0, 1.0];
			var ratios:Array;
			if (ThemesSet.GradientMode == 1) {
				ratios = [0, 127, 128, 255];
			}
			if (ThemesSet.GradientMode == 2) {
				ratios = [0, 50, 205, 255];
			}
			var mat:Matrix = new Matrix();
			var width:Number = tar.compoWidth - 0.35;
			var height:Number = tar.compoHeight -0.35;
			mat.createGradientBox(width, height, 90* Math.PI/180);
			if (tar.selected == true) {
				shape.graphics.lineStyle(1, SkinThemeColor.border, 1.0, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
			}else{
				shape.graphics.lineStyle(1, SkinThemeColor.border, 1.0, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
			}
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			var ew:Number = styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH];
			var eh:Number = styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_HEIGHT];
			RoundRectAdvancedDraw.drawAdvancedRoundRect(shape.graphics, 0, 0, width, height, ew, eh, ew, eh, ew, eh, ew,eh,ew,eh);
			if (tar.selected == true) {
				shape.graphics.beginFill(SkinThemeColor.border, 0.5);
				RoundRectAdvancedDraw.drawAdvancedRoundRect(shape.graphics, 0, 0, width, height, ew, eh, ew, eh, ew, eh, ew,eh,ew,eh);
			}
			shape.filters = DefaultStyle.filters;
			shape.cacheAsBitmap = true;
		}
		
	}
}