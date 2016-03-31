package cn.flashk.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *  BitmapText 是一个将文本自动转化为Bitmap和BitmapData的显示对象
	 * 
	 * 
	 * @author flashk
	 * 
	 */
	public class BitmapText extends Bitmap
	{
		private var _txt:TextField;
		private var _tf:TextFormat;
		private var _text:String;
		private var _isUseHTML:Boolean = false;
		
		public function BitmapText()
		{
			_tf = new TextFormat("_sans");
			_txt = new TextField();
		}
		
		public function get isUseHTML():Boolean
		{
			return _isUseHTML;
		}

		public function set isUseHTML(value:Boolean):void
		{
			_isUseHTML = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function get textFormat():TextFormat
		{
			return _tf;
		}

		public function set textFormat(value:TextFormat):void
		{
			_tf = value;
		}

		public function get textField():TextField
		{
			return _txt;
		}

		public function set textField(value:TextField):void
		{
			_txt = value;
		}

		public function set text(value:String):void
		{
			_text = value;
			if(_isUseHTML == false){
				_txt.text = _text;
			}else{
				_txt.htmlText = _text;
			}
			_txt.setTextFormat(_tf);
			if(bitmapData){
				bitmapData.dispose();
			}
			bitmapData = new BitmapData(_txt.textWidth+4,_txt.textHeight+2,true,0x0);
			bitmapData.draw(_txt);
		}
	}
}