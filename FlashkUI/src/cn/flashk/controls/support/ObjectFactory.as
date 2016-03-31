package cn.flashk.controls.support
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	public class ObjectFactory
	{
		
		public static function getNewSprite(linkName:String):Sprite
		{
			var classRef:Class = getDefinitionByName(linkName) as Class;
			return new classRef() as Sprite;
		}
		
	}
}