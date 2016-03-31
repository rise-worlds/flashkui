package cn.flashk.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class UDisplay
	{
		public static function checkIsType(target:DisplayObject,type:Class,maxLevel:int=50000):Boolean
		{
			var parentObject:DisplayObjectContainer;
			for(var i:int=0;i<maxLevel;i++){
				if(target is type){
					return true;
				}
				parentObject = target.parent;
				if(parentObject == null) return false;
				target = parentObject;
			}
			return false;
		}
	}
}