package cn.flashk.controls.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author flashk
	 */
	public class ColorPickEvent extends Event
	{
		public static const COLOR_SELECT:String = "colorSelect";
		public static const COLOR_CHANGE:String = "colorChange";
		
		private var _color:uint;
		
		public function ColorPickEvent(type:String,selectColor:uint) 
		{
			super(type);
			_color = selectColor;
		}
		
		public function get color():uint {
			return _color;
		}
		
	}
}