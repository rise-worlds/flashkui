package cn.flashk.controls.data
{

	public dynamic class ListItem
	{
		public var label:String = "";
		public var icon:* = null;
		public var value:* = null;
		public var vo:* = null;
		
		public function ListItem(initLabel:String="",initValue:*=null,initIcon:*=null)
		{
			label = initLabel;
			value = initValue;
			icon = initIcon;
		}
	}
}