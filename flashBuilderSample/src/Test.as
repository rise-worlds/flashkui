package
{
	import cn.flashk.controls.Button;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;

	public class Test extends Sprite
	{
		public function Test()
		{
			this.addChild(new Button());
			
			var arr:Array = [];
			var max:int = 600*10000;
			var i:int;
			for(i=0;i<max;i++){
				arr[i] = i;
			}
			var t:int;
			t = getTimer();
			for(i=0;i<max;i++){
				arr[i];
			}
			trace(getTimer()-t);
			t = getTimer();
			for(i=0;i<max;i++){
				arr[i*2/2];
			}
			trace(getTimer()-t);
			
			t = getTimer();
			for(i=0;i<max;i++){
				arr[int(i*2/2)];
			}
			trace(getTimer()-t);
			
			t = getTimer();
			for (var obj:Object in arr){
				arr[obj];
			}
			trace(getTimer()-t);
		}
	}
}