package cn.flashk.controls
{
    import cn.flashk.controls.events.AlertCloseEvent;
    import cn.flashk.controls.managers.DefaultStyle;
    import cn.flashk.controls.support.ColorConversion;
    import cn.flashk.controls.support.UIComponent;
    
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    /**
     * Alert 用来创建弹出的提示窗口，窗口显示一段HTML文字和定义的多个(1-8)按钮用户可以关闭窗口。也可以设置在用户处理这个窗口前不允许做其他的界面操作。
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     *
     * @see cn.flashk.controls.support.UIComponent
     *
     * @author flashk
     */

    public class Alert extends Window
    {
		/**
		 * 如果对Alert.show默认不传递父级显示对象，使用此值 
		 */
		public static var defaultAlertParent:DisplayObjectContainer;
        /**
         * 需要模糊化的显示对象，默认为文档类的实例
         */
        public static var blurDisplayObject:DisplayObject;
		/**
		 * 文本文字的显示滤镜 
		 */
		public static var textFilter:Array = null;
        /**
         * 模糊的滤镜数组
         */
        public static var blurFilters:Array = [new BlurFilter (4 , 4 , 2)];
        /**
         * 当不允许其他操作时遮盖的颜色
         */
        public static var maskColor:uint = 0x999999;
        /**
         * 当不允许其他操作时遮盖颜色的透明度
         */
        public static var maskAlpha:Number = 0.3;
        /**
         * Alert的最大宽度，请注意此属性和Window实例属性的区别
         */
        public static var maxWidth:Number = 800;
        /**
         * Alert的最小宽度，请注意此属性和Window实例属性的区别
         */
        public static var minWidth:Number = 210;
        public static var paddingBottom:Number = 40;
        public static var sureLabels:Array = ["确定"];
        public static var customLabels2:Array = ["确定" , "取消"];
        public static var customLabelsModify:Array = ["修改" , "取消"];
        public static var customLabelsDel:Array = ["删除" , "取消"];
        public static var customLabelsYesNo:Array = ["是" , "否"];
		public static var mark:Sprite = new Sprite ();
		
		private static var _blurArray:Array = [];

        protected var _info:TextField;
        protected var _tf2:TextFormat;
        protected var _btns:Array;
        protected var _callBackFun:Function;
        protected var _textStr:String;
		
        /**
         * 创建一个Alert，如果希望自己控制Alert弹出，可以自行创建。
         *
         * @param text 要显示的消息，可以使用flash支持的HTML文本。
         * @param closeFunction 监听此窗口关闭的函数，函数应该只有一个参数，类型为AlertCloseEvent，如果不提供此函数，同样可以监听close事件，但close事件没有任何反应用户操作哪个按钮的属性
         * @param title 消息窗口的标题
         * @param icon 消息窗口的小图标
         * @param buttonLabels 消息窗口要显示按钮的标签，不限个数，之后你可以通过Alert实例的buttons属性来访问这些按钮，比如添加图标和重新排列等等，如["删除","放弃","重新来过"]
         */
        public function Alert(text:String , title:String , icon:Object , buttonLabels:Array , closeFunction:Function , alertWidth:Number = 0)
        {
            super ();
            _tf2 = new TextFormat ();
            _tf2.font = DefaultStyle.font;
            _tf2.size = DefaultStyle.fontSize;
            _tf2.color = ColorConversion.transformWebColor( DefaultStyle.textColor );
			_tf2.leading = 7;
            _callBackFun = closeFunction;
            _textStr = text;
            _info = new TextField ();
            _info.multiline = true;
            _info.wordWrap = true;
            _info.y = tiHeight + 10;
            _info.x = _paddingLeft + 10;
            if (alertWidth > 0)
            {
                _info.width = alertWidth - _info.x * 2;
            }
            else
            {
                _info.width = maxWidth - 50;
            }
            _info.selectable = false;
            _info.htmlText = text;
			_info.setTextFormat( _tf2 );
            _info.width = _info.textWidth + 15;
            _info.height = 600;
            _info.height = _info.textHeight + 20;
            _info.blendMode = BlendMode.LAYER;
			_info.filters = textFilter;
            this.title = title;
            this.addChild ( _info );
            if ( icon != null )
            {
                this.icon = icon;
            }
            var wi:Number = _info.width + _info.x * 2;
            if ( wi < Alert.minWidth ) wi = Alert.minWidth;
            if ( wi > Alert.maxWidth ) wi = Alert.maxWidth;
            setSize( wi, _info.height + tiHeight + 51 + Button.defaultHeihgt );
            _btns = new Array ();
            var btn:Button;
            for ( var i:int = 0 ; i < buttonLabels.length ; i++ )
            {
                btn = new Button ();
                btn.label = String ( buttonLabels[ i ] );
                _btns.push ( btn );
                this.addChild ( btn );
                btn.y = _compoHeight - Alert.paddingBottom - btn.height + 19;
                btn.addEventListener ( MouseEvent.CLICK , close );
            }
            var space:Number = 10;
            if ( _btns.length == 2 )
                space = 20;
            if ( _btns.length == 3 )
                space = 15;
            if ( _btns.length == 4 )
                space = 10;
            if ( _btns.length > 4 )
                space = 5;
            var allw:Number = 0;
            for ( i = 0 ; i < _btns.length ; i++ )
            {
                allw += Button ( _btns[ i ] ).compoWidth + space;
            }
            allw -= space;
            var stx:Number = int ( ( _compoWidth - allw ) / 2 );
            if (stx < 20)
                stx = 20;
            Button ( _btns[ 0 ] ).x = stx;
            var btnWidth:Number = 0;
            if ( _btns.length > 1 )
            {
                for ( i = 1 ; i < _btns.length ; i++ )
                {
                    Button ( _btns[ i ]).x = Button ( _btns[ i - 1 ]).x + Button ( _btns[ i - 1 ]).compoWidth + space;
                }
            }
            btnWidth = Button ( _btns[ _btns.length - 1 ]).x + Button ( _btns[ _btns.length - 1 ]).width + stx;
            if ( btnWidth > wi )
            {
                wi = btnWidth;
                setSize ( wi , _info.height + tiHeight + 51 + Button.defaultHeihgt );
            }
        }
		
		override protected function onAddStageInitButton(event:Event):void
		{
			super.onAddStageInitButton( event );
			showMaxButton = false;
			showMiniButton = false;
			ableUserResizeWindow = false;
//			closeBtn.toolTip = "关闭消息";
		}

        /**
         * 此Alert里面一排按钮实例的数组，按钮为Button，可以对这些按钮使用Button的方法，如设置图标，更改高度，宽度，位置
         */
        public function get buttons():Array
        {
            return _btns;
        }

        /**
         * 消息提示文本实例
         */
        public function get infoTextField():TextField
        {
            return _info;
        }

        /**
         * 设置文本的StyleSheet样式表
         * @param style
         *
         */
        public function set textStyleSheet(style:StyleSheet):void
        {
            _info.styleSheet = style;
            _info.htmlText = _textStr;
        }
		
		public function set htmlText(value:String):void
		{
			
			_info.htmlText = value;
			_info.setTextFormat(_tf2);
		}

        /**
         * 使用一个Sprite或者显示对象替换Text
         * @param displayObject
         *
         */
        public function replaceTextByDisplay(displayObject:DisplayObject):void
        {
            _info.visible = false;
            this.addChild (displayObject);
        }

        /**
         * 以编程方式关闭此消息弹出窗口
         */
        override public function close(event:Event = null):void
        {
            var index:uint;
            var lab:String;
			
            if (event != null)
            {
                if (event is AlertCloseEvent)
                {
                    index = AlertCloseEvent (event).clickButtonIndex;
                    if (index == 0)
                    {
                        lab = "alertClose";
                    }
                    else
                    {
                        lab = Button (_btns[index - 1]).label;
                    }
                }
                else
                {
                    if (event.currentTarget == closeBtn)
                    {
                        index = 0;
                        lab = "alertClose";
                    }
                    else
                    {
                        for (var i:int = 0 ; i < _btns.length ; i++)
                        {
                            if (_btns[i] == event.currentTarget)
                            {
                                index = i + 1;
                                lab = Button (_btns[i]).label;
                            }
                        }
                    }
                }
                if (_callBackFun != null)
                {
                    _callBackFun (new AlertCloseEvent ("close" , index , lab));
                }
            }
            super.close (event);
        }

        /**
         * 弹出一个提示框，以通知用户或者让用户处理完此消息前不得进行其他操作，如果不希望显示关闭按钮，可以对返回的Alert实例设置showCloseButton属性
         *
         * @param text 要显示的消息，可以使用flash支持的HTML文本。
         * @param parentContainer 弹出消息要添加进的父容器，大部分情况下应该是Stage
         * @param closeFunction 监听此窗口关闭的函数，函数应该只有一个参数，类型为AlertCloseEvent，如果不提供此函数，同样可以监听close事件，但close事件没有任何反应用户操作哪个按钮的属性
         * @param title 消息窗口的标题
         * @param icon 消息窗口的小图标
         * @param buttonLabels 消息窗口要显示按钮的标签，不限个数，之后你可以通过Alert实例的buttons属性来访问这些按钮，比如添加图标和重新排列等等，如["删除","放弃","重新来过"]
         * @param isUnableMouse 弹出消息后是否允许用户操作下面的界面。如果为true，可以设置Alert.maskColor和Alert.maskAlpha来更改颜色和透明度
         *
         * @see cn.flashk.controls.events.AlertCloseEvent
         */
        public static function show(text:String , parentContainer:DisplayObjectContainer =null, closeFunction:Function = null , title:String = "消息" , icon:Object = null , buttonLabels:Array = null , isUnableMouse:Boolean = true , alertWidth:Number = 0):Alert
        {
            if (buttonLabels == null)
                buttonLabels = sureLabels;
			if(parentContainer==null) parentContainer = UIComponent.stage;
            var alert:Alert = new Alert (text , title , icon , buttonLabels , closeFunction , alertWidth);
            alert.x = int ((parentContainer.stage.stageWidth - alert.compoWidth) / 2);
            alert.y = int ((parentContainer.stage.stageHeight - alert.compoHeight) / 2);
            if (alert.x < 0)
                alert.x = 0;
            if (alert.y < 0)
                alert.y = 0;
            if (isUnableMouse == true)
            {
				if(blurFilters != null && blurFilters.length>0)
				{
					_blurArray = [];
	                if (blurDisplayObject == null)
	                {
						for(var i:int;i<parentContainer.numChildren;i++)
						{
	                   	 	blurDisplayObject = parentContainer.getChildAt(i);
							blurDisplayObject.filters = blurFilters;
							_blurArray.push(blurDisplayObject);
						}
						blurDisplayObject = null;
	                }else
					{
						blurDisplayObject.filters = blurFilters;
						_blurArray.push(blurDisplayObject);
					}
				}
                mark.graphics.clear ();
                mark.graphics.beginFill (maskColor , maskAlpha);
                mark.graphics.drawRect (0 , 0 , 3500 , 2880);
				mark.addEventListener(MouseEvent.CLICK,onMarkClick);
                parentContainer.addChild (mark);
            }
            parentContainer.addChild (alert);
            alert.addEventListener ("close" , checkRemoveMark);
            return alert;
        }
		
		protected static function onMarkClick(event:MouseEvent):void
		{
			nowAlert = mark.parent.getChildAt(mark.parent.numChildren-1) as Alert;
			if(nowAlert){
				index = -1;
				nowAlert.addEventListener(Event.ENTER_FRAME,showFocus);
			}
			
		}
		
		protected static function showFocus(event:Event):void
		{
			index++;
			if(index < maskClickAlphas.length){
				nowAlert.alpha = maskClickAlphas[index];
			}else{
				nowAlert.removeEventListener(Event.ENTER_FRAME,showFocus);
			}
		}
		
		private static var nowAlert:Alert;
		private static var index:int=0;
		
		public static var maskClickAlphas:Array = [0.8,1,0.8,1,0.8,1,0.8,1];
		
        override public function setSize(newWidth:Number , newHeight:Number):void
        {
            super.setSize (newWidth , newHeight);
            if (_info)
            {
                _info.width = newWidth - _info.x * 2;
            }
        }

        private static function checkRemoveMark(event:Event):void
        {
            DisplayObject (event.currentTarget).removeEventListener ("close" , checkRemoveMark);
            if (mark.parent != null)
            {
				if(_blurArray && _blurArray.length>0)
				{
						for(var i:int;i<_blurArray.length;i++)
						{
							_blurArray[i].filters = null;
						}
				}
				_blurArray = null;
				mark.parent.removeChild (mark);
            }
        }
		
    }
}
