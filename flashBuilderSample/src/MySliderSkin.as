package 
{
	import cn.flashk.controls.Slider;
	import cn.flashk.controls.skin.SliderSkin;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	public class MySliderSkin extends SliderSkin
	{
		public function MySliderSkin()
		{
		}
		override public function drawSliver(sp:Sprite):void{
			sp.graphics.clear();
			var height:Number = 8;
			sp.graphics.beginFill(0x9BD681,1);
			sp.graphics.moveTo(0,-height);
			sp.graphics.lineTo(-height,height);
			sp.graphics.lineTo(height,height);
			sp.graphics.endFill();
			sp.filters = [new GlowFilter(0x333333,1,4,4,0.5,1,true)];
		}
	}
}