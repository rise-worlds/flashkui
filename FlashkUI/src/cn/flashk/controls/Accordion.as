package cn.flashk.controls
{
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SkinManager;
	import cn.flashk.controls.managers.SkinThemeColor;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.skin.ActionDrawSkin;
	import cn.flashk.controls.skin.ListSkin;
	import cn.flashk.controls.skin.sourceSkin.ListSourceSkin;
	import cn.flashk.controls.support.ColorConversion;
	import cn.flashk.controls.support.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 
	 * 创建和管理导航器按钮（Accordion 标题），您可以使用这些按钮在子代之间导航。
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.support.UIComponent
	 * 
	 * @author flashk
	 */
	public class Accordion extends UIComponent
	{
		public var defaultButtonHeight:Number = 27;
		
		protected var _btns:Array;
		protected var _contents:Array;
		protected var _nowIndex:uint;
		
		public function Accordion()
		{
			super();
			_btns = new Array();
			_contents = new Array();
			_compoWidth = 300;
			_compoHeight = 300;
			styleSet[ "ellipse" ] = 0;
			styleSet[ "borderColor" ] = ColorConversion.transUintToWeb( SkinThemeColor.border );
			styleSet[ "borderAlpha" ] = 0.5;
			styleSet[ "backgroundColor" ] = "#FDFDFD";
			styleSet[ "backgroundAlpha" ] = 1.0;
			setSize( _compoWidth, _compoHeight );
		}
		
		public function get nowIndex():uint
		{
			return _nowIndex;
		}

		public function get buttons():Array
		{
			return _btns;
		}
		
		override public function setDefaultSkin():void 
		{
			setSkin( ListSkin )
		}
		
		override public function setSourceSkin():void 
		{
			setSkin( SkinLoader.getClassFromSkinFile( SourceSkinLinkDefine.LIST ) );
		}
		
		override public function setSkin(Skin:Class):void 
		{
			if( SkinManager.isUseDefaultSkin == true ){
				skin = new Skin();
				ActionDrawSkin( skin ).init( this, styleSet );
			}else{
				var sous:ListSourceSkin = new ListSourceSkin();
				sous.init( this, styleSet, Skin );
				skin = sous;
			}
		}
		
		public function add(label:String,content:DisplayObject,icon:Object=null):void
		{
			var btn:Button;
			btn = new Button();
			btn.label = label;
			if( icon != null ){
				btn.icon = icon;
			}
			_btns.push( btn );
			_contents.push( content );
			btn.setSize( _compoWidth, defaultButtonHeight );
			btn.addEventListener( MouseEvent.CLICK, switchClick );
			this.addChild( btn );
			if( content.parent != null ) content.parent.removeChild( content );
			switchTo( 0 );
		}
		
		protected function switchClick(event:MouseEvent):void
		{
			var index:uint;
			var btn:Button = event.currentTarget as Button;
			var len:int = _btns.length;
			for( var i:int = 0; i < len ; i++ ){
				if( _btns[ i ] == btn ){
					index = i;
				}
			}
			switchTo( index );
		}
		
		public function switchTo(index:uint):void
		{
			var i:int;
			var btn:Button;
			var dis:DisplayObject;
			for( i = 0; i <= index; i++ ){
				btn = _btns[ i ] as Button;
				btn.y = i * defaultButtonHeight;
			}
			for( i = index + 1; i < _btns.length; i++ ){
				btn = _btns[ i ] as Button;
				btn.y = _compoHeight - ( _btns.length - i ) * defaultButtonHeight;
			}
			for( i = 0; i < _contents.length; i++ ){
				dis = _contents[ i ] as DisplayObject;
				if( dis.parent == this) this.removeChild( dis );
			}
			dis = _contents[ index ] as DisplayObject;
			this.addChild( dis );
			dis.x = 1;
			dis.y = ( index + 1 ) * defaultButtonHeight;
			dis.scrollRect = new Rectangle( 0, 0, _compoWidth - 2, _compoHeight - _btns.length * defaultButtonHeight );
			_nowIndex = index;
		}
		
		/**
		 * 获得内容的裁剪区域大小，当组件大小更改时可以根据此值相应调整内容的排版
		 */ 
		public function get contentScrollRect():Rectangle
		{
			return new Rectangle( 0, 0, _compoWidth - 2, _compoHeight - _btns.length * defaultButtonHeight );
		}
		
		override public function setSize(newWidth:Number, newHeight:Number):void
		{
			super.setSize( newWidth, newHeight );
			if( _btns.length ==0 ) return;
			var btn:Button;
			for( var i:int = 0; i< _btns.length; i++ ){
				btn = _btns[ i ] as Button;
				btn.setSize( _compoWidth, defaultButtonHeight );
			}
			switchTo( _nowIndex );
		}
		
	}
}