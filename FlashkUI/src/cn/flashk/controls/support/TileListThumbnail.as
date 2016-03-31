package cn.flashk.controls.support
{
	import cn.flashk.controls.Image;
	import cn.flashk.controls.List;
	import cn.flashk.controls.events.ListEvent;
	import cn.flashk.controls.interfaces.ITileListItemRender;
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinThemeColor;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TileListThumbnail extends Sprite implements ITileListItemRender
	{
		public static var defauleHeight:Number =128;
		
		private var image:Image;
		private var _data:Object;
		private var txt:TextField;
		private var bg:Shape;
		private var _height:Number = 128;
		private var _width:Number = 107;
		private var _list:List;
		private var tf:TextFormat;
		private var _selected:Boolean = false;
		private var bp:Bitmap;
		
		public function TileListThumbnail()
		{
			image = new Image();
			image.x = 3;
			image.y = 3;
			this.addChild(image);
			txt = new TextField();
			txt.mouseEnabled = false;
			txt.y = 105;
			txt.x = 1;
			txt.width = _width - txt.x*2;
			txt.height = 20;
			tf = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.font = DefaultStyle.font;
			tf.color = ColorConversion.transformWebColor(DefaultStyle.textColor);
			txt.defaultTextFormat =tf ;
			this.addChild(txt);
			bg = new Shape();
			bg.alpha = 0;
			this.addChildAt(bg,0);
			this.addEventListener(MouseEvent.MOUSE_OVER,showOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,showOut);
		}
		
		public function set index(value:int):void
		{
			
		}
		
		protected function showOver(event:MouseEvent=null):void
		{
			if(_selected == false){
				bg.alpha = 0.3;
			}
		}
		
		public function showSelect(event:MouseEvent=null):void
		{
			bg.alpha = 1;
			tf.color = SkinThemeColor.itemOverTextColor;
			txt.setTextFormat(tf);
			txt.defaultTextFormat =tf ;
		}
		
		protected function showOut(event:MouseEvent =null):void
		{
			if(_selected == false){
				bg.alpha = 0;
				tf.color = ColorConversion.transformWebColor(DefaultStyle.textColor);
				txt.setTextFormat(tf);
				txt.defaultTextFormat =tf ;
			}
		}
		
		public function set list(value:List):void{
			_list = value;
			
			if(value.itemDoubleClickEnabled == true)
			{
				this.doubleClickEnabled = true;
				this.addEventListener(MouseEvent.DOUBLE_CLICK,onRenderDoubleClick);
			}
			this.addEventListener(MouseEvent.CLICK,onRenderClick);
		}
		
		protected function onRenderDoubleClick(event:MouseEvent):void
		{
			DisplayObject(_list).dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,this));
		}
		
		protected function onRenderClick(event:MouseEvent):void
		{
			DisplayObject(_list).dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,this));
		}
		
		public function set data(value:Object):void{
			_data = value;
			txt.text = _data.label;
			image.source = _data.source;
		}
		
		public function get data():Object{
			return _data;
		}
		
		public function get itemHeight():Number{
			return _height;
		}
		
		public function get itemWidth():Number{
			return _width;
		}
		
		public function setSize(newWidth:Number, newHeight:Number):void{
			bg.graphics.clear();
			bg.graphics.beginFill(SkinThemeColor.listBackgroundFillColors[0],1);
			var ew:Number = 3.5;
			var eh:Number = 3.5;
			var bw:Number = 3.5;
			var bh:Number = 3.5;
			RoundRectAdvancedDraw.drawAdvancedRoundRect(bg.graphics, 0, 0, _width, _height, ew, eh,ew,eh,ew,eh,bw,bh,bw,bh);
			if(_selected == true){
				showSelect();
			}
		}
		
		public function set selected(value:Boolean):void{
			_selected = value;
			if(_selected == true){
				showSelect();
			}else{
				showOut();
			}
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
	}
}