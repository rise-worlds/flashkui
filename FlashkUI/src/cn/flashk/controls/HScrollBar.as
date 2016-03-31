package cn.flashk.controls 
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * HScrollBar 提供了横向滚动控制，与VScrollBar类似。
	 *  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.VScrollBar
	 * 
	 * @author flashk
	 */
	public class HScrollBar extends VScrollBar
	{
		
		public function HScrollBar() 
		{
			super();
			this.rotation = -90;
		}
		
		override protected function getMousePos():Number
		{
			return this.mouseY;
		}
		
		override protected function updateMaxPos():void 
		{
			maxPos = (targetHeight - clipWidth);
			if(maxPos<0){
				maxPos = 0;
			}
		}
		
		override protected function getRectPos():Number 
		{
			if(_target != null)
			{
				return _target.scrollRect.x;
			}
			return toY;
		}
		
		override protected function setRectPos(value:Number):void 
		{
			if(_target != null)
			{
				_target.scrollRect = new Rectangle(value, _target.scrollRect.y, clipWidth, clipHeight);
			}
		}
		
		override public function get clipSize():Number 
		{
			return clipWidth;
		}
		
		override public function set clipSize(value:Number):void
		{
			clipWidth = value;
		}
		
		public function set maxScrollPosition(value:Number):void
		{
			targetWidth = value+clipWidth;
		}
		
		override protected function handDrag(event:MouseEvent):void 
		{
			super.handDrag(event);
			toY = _target.scrollRect.x;
		}
		
	}
}