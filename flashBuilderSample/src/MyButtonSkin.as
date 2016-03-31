package 
{
	import cn.flashk.controls.Button;
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinThemeColor;
	import cn.flashk.controls.modeStyles.ButtonStyle;
	import cn.flashk.controls.skin.ActionDrawSkin;
	import cn.flashk.controls.skin.MotionSkinControl;
	import cn.flashk.controls.support.RoundRectAdvancedDraw;
	import cn.flashk.controls.support.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author flashk
	 */
	public class MyButtonSkin extends ActionDrawSkin
	{
		private var tar:Button;
		private var mot:MotionSkinControl;
		private var shape:Shape;
		private var styleSet:Object;
		
		public function MyButtonSkin() 
		{
			shape = new Shape();
		}
		
		override public function init(target:UIComponent,styleSet:Object):void {
			this.styleSet = styleSet;
			tar = target as Button;
			target.addChildAt(shape, 0);
			mot = new MotionSkinControl(tar, shape);
		}
		
		public function get skinDisplayObject():DisplayObject {
			return shape;
		}
		
		override public function hideOutState():void {
			super.hideOutState();
			shape.alpha = 0;
			mot.setOutViewHide(true);
		}
		
		override public function reDraw():void {
			shape.graphics.clear();
			var width:Number = tar.compoWidth - 0;
			var height:Number = tar.compoHeight -0;
//			SkinThemeColor.initFillStyle(shape.graphics,width,height);
			shape.graphics.beginFill(0x33AA00,0.5);
			var ew:Number = 8;
			var eh:Number = 8;
			var bw:Number = 0;
			var bh:Number = 0;
			RoundRectAdvancedDraw.drawAdvancedRoundRect(shape.graphics, 0+DefaultStyle.graphicsDrawOffset, 0+DefaultStyle.graphicsDrawOffset, width, height, ew, eh,ew,eh,ew,eh,bw,bh,bw,bh);
			shape.cacheAsBitmap = true;
			shape.filters = DefaultStyle.filters;
		}
		
	}
}