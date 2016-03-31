package cn.flashk.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SkinManager;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.managers.StyleManager;
	import cn.flashk.controls.modeStyles.ButtonMode;
	import cn.flashk.controls.modeStyles.ButtonStyle;
	import cn.flashk.controls.skin.IconsSet;
	import cn.flashk.controls.skin.TitleSkin;
	import cn.flashk.controls.skin.sourceSkin.PanelSourceSkin;
	import cn.flashk.controls.support.BitmapDataText;
	import cn.flashk.controls.support.UserMouse;
	import cn.flashk.ui.UI;

	/**
	 * <p>Window 容器为其子项提供了标题栏、边框和内容区域。窗口默认允许用户拖动、更改大小和最大化/最小化。如果需要在窗口更改大小时实时排列窗口中的内容，请侦听resize事件。</p>
	 * <p>通常，使用 Window 容器封装独立的应用程序模块。并弹出窗口显示。</p>
	 * <p>例如，您可以在 Window 容器中包含一个背包窗口，你可以用代码关闭 Window 容器，或允许用户使用“关闭”按钮将其关闭。 </p>
	 */ 
	public class Window extends Panel
	{
		public static var titleButtonAlign:String = "right";
		public static var isResizePress:Boolean = false;
		
		public static var dragMax:int = 50;
		public static var dragMaxheight:int = 37;
		public static var defaultDragCatchAddX:int = 32;
		public static var defaultDragCatchAddY:int = 32;
		public static var defaultDragCatchAddWidth:int = 0;
		public static var defaultDragCatchAddHeight:int = 0;
		
		/**
		 * 窗口拖动时拖动窗口的透明度值
		 */ 
		public var draggingAlpha:Number;
		/**
		 *  窗口拖动时拖动原窗口和拖动窗口的透明度值总和，原窗口.alpha = 此值-draggingAlpha，如果希望窗口拖动半透明并且不显示原窗口，请将此值设为和draggingAlpha相同的值
		 */
		public var draggingTotalAlpha:Number;
		/**
		 * 当允许用户更改大小时窗口的最小宽度,setSize函数不受此限制
		 */ 
		public var minWidth:Number = 200;
		/**
		 * 当允许用户更改大小时窗口的最小高度,setSize函数不受此限制
		 */ 
		public var minHeight:Number = 120;
		/**
		 * 关闭、最大化、最小化按钮鼠标经过的显示滤镜，默认为DefaultStyle.windowButtonOverFilter
		 * 
		 * @see cn.flashk.controls.managers.DefaultStyle
		 */ 
		protected static var closeIconStr:String = "9,8,55f9f9f9x8e8e8ex8e8e8e,55f9f9f9,0,55f9f9f9x8e8e8ex8e8e8e,55f9f9f9,90fbfbfbxrrrxrrrx8e8e8e,55f9f9f9x8e8e8exrrrxrrr,90fbfbfb,55f9f9f9,90fbfbfbxrrrxrrrx8e8e8exrrrxrrr,90fbfbfb,55f9f9f9,0,55f9f9f9,90fbfbfbxrrrxrrrxrrr,90fbfbfb,55f9f9f9,0,0,55f9f9f9x8e8e8exrrrxrrrxrrrx8e8e8e,55f9f9f9,0,55f9f9f9x8e8e8exrrrxrrr,90fbfbfbxrrrxrrrx8e8e8e,55f9f9f9,90fbfbfbxrrrxrrr,90fbfbfb,55f9f9f9,90fbfbfbxrrrxrrr,90fbfbfb,55f9f9f9,90fbfbfb,90fbfbfb,55f9f9f9,0,55f9f9f9,90fbfbfb,90fbfbfb,55f9f9f9,";
		protected static var closeIconOverStr:String = "9,8,55c6c6c6xee3c3cxee3c3c,55c6c6c6,0,55c6c6c6xee3c3cxee3c3c,55c6c6c6,90c8c8c8xa1rrxa1rrxee3c3c,55c6c6c6xee3c3cxa1rrxa1rr,90c8c8c8,55c6c6c6,90c8c8c8xa1rrxa1rrxee3c3cxa1rrxa1rr,90c8c8c8,55c6c6c6,0,55c6c6c6,90c8c8c8xa1rrxa1rrxa1rr,90c8c8c8,55c6c6c6,0,0,55c6c6c6xee3c3cxa1rrxa1rrxa1rrxee3c3c,55c6c6c6,0,55c6c6c6xee3c3cxa1rrxa1rr,90c8c8c8xa1rrxa1rrxee3c3c,55c6c6c6,90c8c8c8xa1rrxa1rr,90c8c8c8,55c6c6c6,90c8c8c8xa1rrxa1rr,90c8c8c8,55c6c6c6,90c8c8c8,90c8c8c8,55c6c6c6,0,55c6c6c6,90c8c8c8,90c8c8c8,55c6c6c6,";
		protected static var miniIconStr1:String = "8,8,cdrrr,cdrrr,cdrrr,cdrrr,cdrrr,cdrrr,cdrrr,cdrrr,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,67fafafa,67fafafa,67fafafa,e1161616,e1161616,67fafafa,67fafafa,67fafafa,0,0,cdrrr,e1161616,e1161616,cdrr0z0,cdrrr,e1161616,e1161616,e1161616,e1161616,cdrr0z67fafafa,67fafafa,e1161616,e1161616,67fafafa,67fafafa,z0,e1161616,e1161616,zz67fafafa,67fafafa,z";
		protected static var miniIconStr2:String = "8,8,zcdrrr,cdrr0zz0,e1161616,e1161616,z0,cdrrr,cdrrr,e1161616,e1161616,cdrrr,cdrr0z67fafafa,e1161616,e1161616,e1161616,e1161616,67fafafa,z67fafafa,e1161616,e1161616,67fafafa,0,0,cdrrr,cdrrr,cdrrr,e1161616,e1161616,cdrrr,cdrrr,cdrrr,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,e1161616,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,";
		protected static var maxIconStr1:String = "9,8xrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrr,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafaxrrrxrr0zz0,0xrrrxrr0zz0,0xrrrxrr0zz0,0xrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrr,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,";
		protected static var maxIconStr2:String = "9,9,0,0xrrrxrrrxrrrxrrrxrrrxrrrxrr0zb4474747,b4474747,b4474747,b4474747,b4474747,b4474747xrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrr,34f5f5f5xrrrxrrrxrrrxrrrxrrrxrrrxrrrxrrr,0xrrrxrrr,67fafafa,67fafafa,67fafafa,67fafafa,67fafafaxrrr,0xrrrxrr0z0,0,0xrrrxrrrxrrrxrr0z0,0,0xrrr,67fafafa,67fafafaxrrrxrrrxrrrxrrrxrrrxrrrxrr0z67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,67fafafa,0,0,";
		
		public var buttonOverFilter:Array;
		
		protected var closeBtn:Button;
		protected var miniBtn:Button;
		protected var maxBtn:Button;
		protected var _ableUserResizeWindow:Boolean = true;
		protected var dragBtn:SimpleButton;
		protected var _ableUserDrag:Boolean = true;
		protected var bp:Bitmap;
		protected var bd:BitmapData;
		protected var pressX:Number;
		protected var pressY:Number;
		protected var bakData:Array;
		protected var isMaxWindow:Boolean = false;
		protected var isMinWindow:Boolean = false;
		protected var resizeR:Sprite;
		protected var resizeB:Sprite;
		protected var resizeRB:Sprite;
		protected var resizeLB:Sprite;
		protected var resizeTL:Sprite;
		protected var resizeTR:Sprite;
		protected var resizeL:Sprite;
		protected var resizeT:Sprite;
		protected var addX:Number = 2;
		protected var addY:Number = 2;
		protected var dragSX:Number;
		protected var dragSY:Number;
		protected var pressData:Array;
		protected var moveFollowDis:DisplayObject;
		protected var tmpBox:Sprite = new Sprite();
		protected var _useDragCatch:Boolean;
		protected var _bpSp:Sprite = new Sprite();
		protected var _lastW:int;
		protected var _lastH:int;
		protected var _isResizeResetXY:Boolean = true;
		protected var _dragCatchAddX:int;
		protected var _dragCatchAddY:int;
		protected var _dragCatchAddWidth:int;
		protected var _dragCatchAddHeight:int;
		
		public function Window()
		{
			_compoWidth = 400;
			_compoHeight = 300;
			_dragCatchAddX = defaultDragCatchAddX;
			_dragCatchAddY = defaultDragCatchAddY;
			_dragCatchAddWidth = defaultDragCatchAddWidth;
			_dragCatchAddHeight = defaultDragCatchAddHeight;
			_bpSp.mouseChildren = false;
            draggingAlpha = StyleManager.globalWindowDragAlpha;
			draggingTotalAlpha = StyleManager.globalWindowDragTotalAlpha;
			buttonOverFilter= DefaultStyle.windowButtonOverFilter;
			_useDragCatch = StyleManager.globalWindowuseDragCatch;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStageInitButton);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
			super();
		
			dragBtn = new SimpleButton();
			this.addChild(dragBtn);
			var dragArae:Shape = new Shape();
			dragArae.graphics.beginFill(0,0.5);
			dragArae.graphics.drawRect(styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH] ,0,_compoWidth-styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH] -10,tiHeight);
			dragBtn.hitTestState = dragArae;
			dragBtn.useHandCursor = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,moveWindowTop);
			dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,startDragWindow);
			bp = new Bitmap();
            _ableUserResizeWindow = StyleManager.globalAbleUserResizeWindow;
            autoClipContent = StyleManager.globalWindowAutoClip;
            //自动构建
            if(this.getChildByName("set_windowSize")!= null){
                setSize(this.getChildByName("set_windowSize").width,this.getChildByName("set_windowSize").height);
                this.removeChild(this.getChildByName("set_windowSize"));
            }
            if(this.getChildByName("content_sp") != null){
                content = this.getChildByName("content_sp") ;
            }
		}

		public function get dragCatchAddHeight():int
		{
			return _dragCatchAddHeight;
		}

		public function set dragCatchAddHeight(value:int):void
		{
			_dragCatchAddHeight = value;
		}

		public function get dragCatchAddWidth():int
		{
			return _dragCatchAddWidth;
		}

		public function set dragCatchAddWidth(value:int):void
		{
			_dragCatchAddWidth = value;
		}

		public function get dragCatchAddY():int
		{
			return _dragCatchAddY;
		}

		public function set dragCatchAddY(value:int):void
		{
			_dragCatchAddY = value;
		}

		public function get dragCatchAddX():int
		{
			return _dragCatchAddX;
		}

		public function set dragCatchAddX(value:int):void
		{
			_dragCatchAddX = value;
		}

		/**
		 * 使用一个自定义Shape作为窗口的拖动区域
		 * @param areaShape
		 * 
		 */
		public function useOwnDragArea(areaShape:Shape):void
		{
			dragBtn.hitTestState = areaShape;
			dragBtn.x = dragBtn.y = 0;
			dragBtn.scaleX = dragBtn.scaleY = 1;
		}
		
		public function get dragAreaInteractiveObject ():SimpleButton
		{
			
			return dragBtn;
		}
		
		/**
		 * 获取拖动区域设置的 Shape，可以操作此Shape的graphics属性自定义非矩形拖动区域。参见Graphics对象的操作方法画出矢量图形
		 * @return 
		 * 
		 */
		public function get dragArea():Shape
		{
			return dragBtn.hitTestState as Shape;
		}
		
		protected function onAddStageInitButton(event:Event):void
		{
			if(_isUseOwnSkin == true) return;
			closeBtn = new Button();
			if(SkinManager.isUseDefaultSkin == true)
			{
				closeBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH,0);
				closeBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_HEIGHT,0);
				closeBtn.icon = BitmapDataText.decodeTextToBitmapData(closeIconStr);
				closeBtn.setStyle(ButtonStyle.ICON_OVER,BitmapDataText.decodeTextToBitmapData(closeIconOverStr));
				closeBtn.addEventListener(MouseEvent.MOUSE_OVER,showButtonOverFilter);
				closeBtn.addEventListener(MouseEvent.MOUSE_OUT,showButtonOutFilter);
			}else
			{
				closeBtn.useSkinSize = true;
				closeBtn.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_CLOSE_BUTTON));
			}
			closeBtn.setSize(34,16);
			closeBtn.addEventListener(MouseEvent.MOUSE_OVER,setButtonTop);
			closeBtn.mode = ButtonMode.JUST_ICON;
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			closeBtn.toolTip = "关闭窗口";
			this.addChild(closeBtn);
			miniBtn = new Button();
			if(SkinManager.isUseDefaultSkin == true)
			{
				miniBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH,0);
				miniBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_HEIGHT,0);
				miniBtn.icon = BitmapDataText.decodeTextToBitmapData(miniIconStr1);
				miniBtn.addEventListener(MouseEvent.MOUSE_OVER,showButtonOverFilter);
				miniBtn.addEventListener(MouseEvent.MOUSE_OUT,showButtonOutFilter);
			}else
			{
				minButton.useSkinSize = true;
				minButton.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_MINI_BUTTON));
			}
			miniBtn.setSize(32,16);
			minButton.addEventListener(MouseEvent.MOUSE_OVER,setButtonTop);
			miniBtn.mode = ButtonMode.JUST_ICON;
			miniBtn.addEventListener(MouseEvent.CLICK,switchMin);
			miniBtn.toolTip = "最小化窗口";
			this.addChild(miniBtn);
			maxBtn = new Button();
			if(SkinManager.isUseDefaultSkin == true){
				maxBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH,0);
				maxBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_HEIGHT,0);
				maxBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_BOTTOM_WIDTH,0);
				maxBtn.setStyle(ButtonStyle.DEFAULT_SKIN_ELLIPSE_BOTTOM_HEIGHT,0);
				maxBtn.icon = BitmapDataText.decodeTextToBitmapData(maxIconStr1);
				maxBtn.addEventListener(MouseEvent.MOUSE_OVER,showButtonOverFilter);
				maxBtn.addEventListener(MouseEvent.MOUSE_OUT,showButtonOutFilter);
			}else{
				maxButton.useSkinSize = true;
				maxButton.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_MAX_BUTTON));
			}
			maxBtn.setSize(28,16);
			maxButton.addEventListener(MouseEvent.MOUSE_OVER,setButtonTop);
			maxBtn.mode = ButtonMode.JUST_ICON;
			maxBtn.addEventListener(MouseEvent.CLICK,switchMax);
			maxBtn.toolTip = "最大化窗口";
			this.addChild(maxBtn);
			maxBtn.y = miniBtn.y = closeBtn.y = StyleManager.globalWindowButtonsY;
			resizeR = new Sprite();
			resizeR.graphics.beginFill(0,0);
			resizeR.graphics.drawRect(0,0,7,7);
			resizeR.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeR.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeR.addEventListener(MouseEvent.MOUSE_DOWN,startResizeR);
			this.addChild(resizeR);
			resizeL = new Sprite();
			resizeL.graphics.beginFill(0,0);
			resizeL.graphics.drawRect(0,0,7,7);
			resizeL.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeL.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeL.addEventListener(MouseEvent.MOUSE_DOWN,startResizeL);
			this.addChild(resizeL);
			resizeB = new Sprite();
			resizeB.graphics.beginFill(0,0);
			resizeB.graphics.drawRect(0,0,7,7);
			resizeB.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeB.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeB.addEventListener(MouseEvent.MOUSE_DOWN,startResizeB);
			this.addChild(resizeB);
			resizeT = new Sprite();
			resizeT.graphics.beginFill(0,0);
			resizeT.graphics.drawRect(0,0,7,7);
			resizeT.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeT.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeT.addEventListener(MouseEvent.MOUSE_DOWN,startResizeT);
			this.addChild(resizeT);
			resizeRB = new Sprite();
			resizeRB.graphics.beginFill(0,0);
			resizeRB.graphics.drawRect(0,0,15,15);
			resizeRB.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeRB.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeRB.addEventListener(MouseEvent.MOUSE_DOWN,startResizeRB);
			this.addChild(resizeRB);
			resizeLB = new Sprite();
			resizeLB.graphics.beginFill(0,0);
			resizeLB.graphics.drawRect(0,0,15,15);
			resizeLB.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeLB.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeLB.addEventListener(MouseEvent.MOUSE_DOWN,startResizeLB);
			this.addChild(resizeLB);
			resizeTL = new Sprite();
			resizeTL.graphics.beginFill(0,0);
			resizeTL.graphics.drawRect(0,0,15,15);
			resizeTL.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeTL.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeTL.addEventListener(MouseEvent.MOUSE_DOWN,startResizeTL);
			this.addChild(resizeTL);
			resizeTR = new Sprite();
			resizeTR.graphics.beginFill(0,0);
			resizeTR.graphics.drawRect(0,0,15,15);
			resizeTR.addEventListener(MouseEvent.MOUSE_OVER,showResizeMouse);
			resizeTR.addEventListener(MouseEvent.MOUSE_OUT,hideResizeMouse);
			resizeTR.addEventListener(MouseEvent.MOUSE_DOWN,startResizeTR);
			this.addChild(resizeTR);
			
			ableUserResizeWindow = _ableUserResizeWindow;
			showMiniButton = StyleManager.globalShowWindowMiniButton;
			setAllIndex();
			setSize(_compoWidth,_compoHeight);
		}
		
		public function get useDragCatch():Boolean
		{
			return _useDragCatch;
		}

		public function set useDragCatch(value:Boolean):void
		{
			_useDragCatch = value;
		}

		/** 使用自定义皮肤，默认窗口拖动时会使用位图缓存，如果皮肤拖动时被裁剪，请将useDragCatch设定为false。在sp.addChild(window)之前调用此方法可以提高Window自定义皮肤初始化的性能
		 * 
		 * @param closeButton 对关闭按钮的引用，点击此按钮将关闭窗口，使用之后关闭将被从原来显示列表移除到窗口的子级（最上层）
		 * @param dragWidthLess 要修改的拖动范围的值，默认是窗口宽度，如果是负值，则为窗口宽度减去多少
		 * @param dragHeight 拖动的高度（直接设置值>=0）
		 * @param dragPosX 拖动区域x位置
		 * @param dragPoxY 拖动区域y位置
		 * 
		 */
        public function useOwnSkin(closeButton:InteractiveObject=null,dragWidthLess:Number=0,dragHeight:Number=-1,dragPosX:Number=0,dragPoxY:Number=0):void
        {
			_isUseOwnSkin = true;
            if(SkinManager.isUseDefaultSkin)
            {
                TitleSkin(skin).skinDisplayObject.visible = false;
            }else
            {
                PanelSourceSkin(skin).sc9Bitmap.visible = false;
            }
			this.setChildIndex(dragBtn,this.numChildren-1);
			if(closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK,close);
				this.addChild(closeButton);
			}
            this.graphics.clear();
            filterBG.graphics.clear();
            filterBG.visible = false;
            bg.graphics.clear();
            bg.visible = false;
			content.y = 0;
			content.x = 0;
			dragBtn.hitTestState.width = _compoWidth-dragWidthLess;
			if(dragHeight >=0 )
			{
				dragBtn.hitTestState.height = dragHeight;
			}
			dragBtn.x = dragPosX;
			dragBtn.y = dragPoxY;
        }
       
		protected function setButtonTop(event:MouseEvent):void
		{
			this.setChildIndex(event.currentTarget as DisplayObject,this.numChildren-1);
		}
		
		protected function showButtonOverFilter(event:MouseEvent):void
		{
			var dis:DisplayObject = event.currentTarget as DisplayObject;
			dis.filters = buttonOverFilter;
		}
		
		protected function showButtonOutFilter(event:MouseEvent):void
		{
			var dis:DisplayObject = event.currentTarget as DisplayObject;
			dis.filters = [];
		}
		
		/**
		 * 是否允许用户更改窗口大小以及显示最大化窗口按钮
		 */ 
		public function set ableUserResizeWindow(value:Boolean):void{
			_ableUserResizeWindow = value;
			if(_ableUserResizeWindow == false){
				tmpBox.addChild(maxBtn);
				tmpBox.addChild(resizeR);
				tmpBox.addChild(resizeB);
				tmpBox.addChild(resizeRB);
				tmpBox.addChild(resizeLB);
				tmpBox.addChild(resizeL);
				tmpBox.addChild(resizeT);
				tmpBox.addChild(resizeTL);
				tmpBox.addChild(resizeTR);
				miniBtn.x = closeBtn.x-closeBtn.compoWidth+2;
                this.setChildIndex(miniBtn,this.numChildren-1);
                this.setChildIndex(closeBtn,this.numChildren-1);
			}else{
				this.addChild(maxBtn);
				this.addChild(resizeR);
				this.addChild(resizeB);
				this.addChild(resizeRB);
				this.addChild(resizeLB);
				this.addChild(resizeL);
				this.addChild(resizeT);
				this.addChild(resizeTL);
				this.addChild(resizeTR);
				miniBtn.x = maxBtn.x-miniBtn.compoWidth+2;
				setAllIndex();
			}
		}
		/**
		 * 关闭此窗口
		 */ 
		public function close(event:Event = null):void{
			if(this.parent != null){
				this.parent.removeChild(this);
				this.dispatchEvent(new Event("close"));
			}
			
		}
		/**
		 * 是否显示窗口的关闭按钮，允许用户关闭窗口。如果不显示，可以调用close方法关闭
		 * 
		 * @see #close()
		 */ 
		public function set showCloseButton(value:Boolean):void{
			closeBtn.visible = value;
			if(closeBtn.visible == false){
				if(maxBtn.parent == this){
					maxBtn.x = _compoWidth-maxBtn.compoWidth-10;
					miniBtn.x = maxBtn.x-miniBtn.compoWidth+2;
				}
			}else{
				if(maxBtn.parent == this){
					maxBtn.x = closeBtn.x - maxBtn.compoWidth+2;
					miniBtn.x = maxBtn.x-miniBtn.compoWidth+2;
				}
			}
			if(titleButtonAlign == "left"){
				closeBtn.x = styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH]+4;
				if(closeBtn.visible == true){
					maxBtn.x = closeBtn.x + closeBtn.width +7;
				}else{
					maxBtn.x = closeBtn.x;
				}
				miniBtn.x = maxBtn.x + maxBtn.width + 7;
			}
		}
		
		public function get showCloseButton():Boolean{
			return closeBtn.visible;
		}
		
		public function set showMaxButton(value:Boolean):void{
			maxButton.visible = value;
		}
		
		public function set showMiniButton(value:Boolean):void{
			minButton.visible = value;
		}
		/**
		 * 获取关闭按钮的实例
		 */ 
		public function get closeButton():Button{
			return closeBtn;
		}
		/**
		 * 获取最大化按钮的实例
		 */
		public function get maxButton():Button{
			return maxBtn;
		}
		/**
		 * 获取最小化按钮的实例
		 */
		public function get minButton():Button{
			return miniBtn;
		}
		/**
		 * 是否允许用户拖动此窗口，默认为允许
		 */ 
		public function set ableUserDragWindow(value:Boolean):void{
			_ableUserDrag = value;
		}
		/**
		 * 将窗口移动到显示列表的最顶层
		 */ 
		public function moveWindowTop(event:MouseEvent=null):void{
			if(event !=null){
				if(this.mouseX<0 || this.mouseY <0 || this.mouseX>_compoWidth || this.mouseY >_compoHeight){
					return;
				}
			}
			if(this.parent is Loader) return;
			this.parent.setChildIndex(this,this.parent.numChildren-1);
		}
		/**
		 * 将窗口移动到显示列表的最底层
		 */ 
		public function moveWindowBottom(event:MouseEvent=null):void{
			this.parent.setChildIndex(this,0);
		}
		/**
		 * 将窗口在显示列表中上移一层
		 */ 
		public function moveWindowUp():void{
			if(this.parent.getChildIndex(this)== this.parent.numChildren-1){
				return;
			}
			this.parent.setChildIndex(this,this.parent.getChildIndex(this)+1);
		}
		/**
		 * 将窗口在显示列表中下移一层
		 */ 
		public function moveWindowDown():void{
			if(this.parent.getChildIndex(this)== 0){
				return;
			}
			this.parent.setChildIndex(this,this.parent.getChildIndex(this)+1);
		}
		override public function set content(value:DisplayObject):void{
			super.content = value;
			
			setAllIndex();
		}
		
		private function setAllIndex():void{
			if(_ableUserResizeWindow == false) return;
			this.setChildIndex(resizeR,this.numChildren-1);
			this.setChildIndex(resizeB,this.numChildren-1);
			this.setChildIndex(resizeL,this.numChildren-1);
			this.setChildIndex(resizeT,this.numChildren-1);
			this.setChildIndex(resizeTL,this.numChildren-1);
			this.setChildIndex(resizeTR,this.numChildren-1);
			this.setChildIndex(resizeRB,this.numChildren-1);
			this.setChildIndex(resizeLB,this.numChildren-1);
			this.setChildIndex(maxBtn,this.numChildren-1);
            this.setChildIndex(miniBtn,this.numChildren-1);
            this.setChildIndex(closeBtn,this.numChildren-1);
		}
		
		protected function startResizeR(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [_compoWidth-this.mouseX];
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowR);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeR);
		}
		
		protected function stopResizeR(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeR.mouseX<=0 || resizeR.mouseY<=0 || this.mouseY>_compoHeight) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowR);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeR);
		}
		
		protected function resezeWindowR(event:MouseEvent):void
		{
			var mx:Number = this.mouseX+pressData[0];
			if(mx<minWidth) mx = minWidth;
			this.setSize(mx,_compoHeight);
		}
		
		protected function startResizeL(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [this.parent.mouseX,_compoWidth,x+_compoWidth-minWidth,this.mouseX];
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowL);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeL);
		}
		
		protected function stopResizeL(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeL.mouseX<=0 || resizeL.mouseY<=0 || this.mouseY>_compoHeight || resizeL.mouseX>resizeL.width) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowL);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeL);
		}
		
		protected function resezeWindowL(event:MouseEvent):void
		{
			var mx:Number =pressData[1]- this.parent.mouseX+pressData[0];
			if(mx<minWidth) {
				mx = minWidth;
			}
			this.setSize(mx,_compoHeight);
			if(mx == minWidth){
				this.x = pressData[2];
			}else{
				this.x = this.parent.mouseX-pressData[3];
			}
		}
		
		protected function startResizeT(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [this.parent.mouseY,_compoHeight,y+_compoHeight-minHeight,this.mouseY];
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowT);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeT);
		}
		
		protected function stopResizeT(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeT.mouseX<=0 || resizeT.mouseY<=0 || this.mouseX>_compoWidth || resizeT.mouseY > resizeT.height) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowT);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeT);
		}
		
		protected function resezeWindowT(event:MouseEvent):void
		{
			var my:Number =pressData[1]- this.parent.mouseY+pressData[0];
			if(my<minHeight) {
				my = minHeight;
			}
			this.setSize(_compoWidth,my);
			if(my == minHeight){
				this.y = pressData[2];
			}else{
				this.y = this.parent.mouseY-pressData[3];
			}
		}
		
		protected function startResizeB(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [_compoHeight-this.mouseY]
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowB);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeB);
		}
		
		protected function stopResizeB(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeB.mouseX<=0 || resizeB.mouseY<=0 || this.mouseX>_compoWidth) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowB);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeB);
		}
		
		protected function resezeWindowB(event:MouseEvent):void
		{
			var my:Number = this.mouseY+pressData[0];
			if(my<minHeight) my = minHeight;
			this.setSize(_compoWidth,my);
		}
		
		protected function startResizeRB(event:MouseEvent):void
		{
			isResizePress = true;
			dragSX = this.mouseX - _compoWidth;
			dragSY = this.mouseY - _compoHeight;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowRB);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeRB);
		}
		
		protected function stopResizeRB(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeRB.mouseX<=0 || resizeRB.mouseY<=0 || this.mouseX>_compoWidth) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowRB);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeRB);
		}
		
		protected function resezeWindowRB(event:MouseEvent):void
		{
			var my:Number = this.mouseY-dragSY;
			if(my<minHeight) my = minHeight;
			var mx:Number = this.mouseX - dragSX;
			if(mx<minWidth) mx = minWidth;
			this.setSize(mx,my);
		}
		
		protected function startResizeLB(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [this.parent.mouseX,_compoWidth,this.mouseY - _compoHeight,this.mouseX,x+_compoWidth-minWidth]
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowLB);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeLB);
		}
		
		protected function stopResizeLB(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeLB.mouseX<=0 || resizeLB.mouseY<=0 || resizeLB.mouseX>resizeLB.width || resizeLB.mouseY > resizeLB.height) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowLB);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeLB);
		}
		
		protected function resezeWindowLB(event:MouseEvent):void
		{
			var my:Number = this.mouseY - pressData[2];
			if(my<minHeight) my = minHeight;
			var mx:Number =pressData[1]- this.parent.mouseX+pressData[0];
			if(mx<minWidth) {
				mx = minWidth;
			}
			this.setSize(mx,my);
			
			if(mx == minWidth){
				this.x = pressData[4];
			}else{
				this.x = this.parent.mouseX-pressData[3];
			}
		}
		
		protected function startResizeTR(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [this.parent.mouseY,_compoHeight,this.mouseX - _compoWidth,this.mouseY,y+_compoHeight-minHeight]
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowTR);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeTR);
		}
		
		protected function stopResizeTR(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeTR.mouseX<=0 || resizeTR.mouseY<=0 || resizeTR.mouseX>resizeTR.width || resizeTR.mouseY>resizeTR.height) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowTR);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeTR);
		}
		
		protected function resezeWindowTR(event:MouseEvent):void
		{
			var my:Number = pressData[1]- this.parent.mouseY+pressData[0];
			if(my<minHeight) my = minHeight;
			var mx:Number =this.mouseX - pressData[2];
			if(mx<minWidth) {
				mx = minWidth;
			}
			this.setSize(mx,my);
			if(my == minHeight){
				this.y = pressData[4];
			}else{
				this.y = this.parent.mouseY-pressData[3];
			}
		}
		
		protected function startResizeTL(event:MouseEvent):void
		{
			isResizePress = true;
			pressData = [this.parent.mouseX,_compoWidth,this.mouseY - _compoHeight,this.mouseX,this.mouseY,this.parent.mouseY,_compoHeight,x+_compoWidth-minWidth,y+_compoHeight-minHeight]
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,resezeWindowTL);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopResizeTL);
		}
		
		protected function stopResizeTL(event:MouseEvent):void
		{
			isResizePress = false;
			if(resizeTL.mouseX<=0 || resizeTL.mouseY<=0 || resizeTL.mouseX>resizeTL.width || resizeTL.mouseY > resizeTL.height) hideResizeMouse();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,resezeWindowTL);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopResizeTL);
		}
		
		protected function resezeWindowTL(event:MouseEvent):void
		{
			var my:Number = pressData[6]- this.parent.mouseY+pressData[5];
			var mx:Number =pressData[1]- this.parent.mouseX+pressData[0];
			if(my<minHeight) {
				my = minHeight;
			}
			if(mx<minWidth) {
				mx = minWidth;
			}
			this.setSize(mx,my);
			if(mx == minWidth ){
				this.x = pressData[7];
			}else{
				this.x = this.parent.mouseX-pressData[3];
			}
			if(my == minHeight) {
				this.y = pressData[8];
			}else{
				this.y = this.parent.mouseY-pressData[4];
			}
		}
		
		protected function hideResizeMouse(event:MouseEvent = null):void
		{
			if(isResizePress == true) return;
			UserMouse.hideCustomMouse();
		}
		
		protected function showResizeMouse(event:MouseEvent):void
		{
			if(isResizePress == true) return;
			if(event.currentTarget == resizeR || event.currentTarget == resizeL){
				UserMouse.mouseDisplayObjectContainer = this.stage;
				UserMouse.showCustomMouse(BitmapDataText.decodeTextToBitmapData(IconsSet.resizeHorizontalStr),-9,-4,true);
			}
			if(event.currentTarget == resizeB || event.currentTarget == resizeT){
				UserMouse.mouseDisplayObjectContainer = this.stage;
				UserMouse.showCustomMouse(BitmapDataText.decodeTextToBitmapData(IconsSet.resizeVerticalStr),-4,-10,true);
			}
			if(event.currentTarget == resizeRB || event.currentTarget == resizeTL){
				UserMouse.mouseDisplayObjectContainer = this.stage;
				UserMouse.showCustomMouse(BitmapDataText.decodeTextToBitmapData(IconsSet.resizeRightBStr),-8,-8,true);
			}
			if(event.currentTarget == resizeLB || event.currentTarget == resizeTR){
				UserMouse.mouseDisplayObjectContainer = this.stage;
				UserMouse.showCustomMouse(BitmapDataText.decodeTextToBitmapData(IconsSet.resizeLeftBStr),-8,-8,true);
			}
		}				
		
		override public function setSize(newWidth:Number, newHeight:Number):void {
			super.setSize(newWidth, newHeight);
			if(_isUseOwnSkin == true) return;
			if(closeBtn == null) return;
			closeBtn.x = _compoWidth-closeBtn.compoWidth-StyleManager.globalWindowButtonsXLess;
			if(closeBtn.visible == true){
				maxBtn.x = closeBtn.x - maxBtn.compoWidth+2;
			}else{
				maxBtn.x = _compoWidth-maxBtn.compoWidth-10;
			}
			if(_ableUserResizeWindow == true){
				miniBtn.x = maxBtn.x-miniBtn.compoWidth+2;
			}else{
				miniBtn.x = closeBtn.x-closeBtn.compoWidth+2;
			}
			if(titleButtonAlign == "left"){
				closeBtn.x = styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH]+4;
				if(closeBtn.visible == true){
					maxBtn.x = closeBtn.x + closeBtn.width +7;
				}else{
					maxBtn.x = closeBtn.x;
				}
				miniBtn.x = maxBtn.x + maxBtn.width + 7;
			}
			if(Panel.titleTextAlign != "center"){
				
				txt.width = miniBtn.x-txt.x-10-4;
			}
			resizeR.x = _compoWidth-resizeR.width+1;
			resizeR.height = _compoHeight-resizeR.y-_paddingBottom+4;
			resizeL.height = _compoHeight-resizeL.y-_paddingBottom+4;
			resizeT.width = _compoWidth;
			resizeB.width = _compoWidth;
			resizeB.y = _compoHeight-resizeB.height+1-_paddingBottom+4;
			resizeRB.x = _compoWidth-resizeRB.width+1;
			resizeRB.y = _compoHeight-resizeRB.height+1-_paddingBottom+4;
			resizeLB.y = _compoHeight-resizeLB.height+1-_paddingBottom+4;
			resizeTR.x = _compoWidth-resizeTR.width+1;
			autoClipContent = autoClipContent;
			if(dragBtn != null){
				dragBtn.hitTestState.width = _compoWidth-styleSet[ButtonStyle.DEFAULT_SKIN_ELLIPSE_WIDTH] -10;
			}
		}
		
		protected function startDragWindow(event:MouseEvent):void
		{
			if(_ableUserDrag == false){
				return;
			}
			if(backgroundFilter && backgroundFilter[0] is DropShadowFilter){
				addX = DropShadowFilter(backgroundFilter[0]).blurX;
				addY = DropShadowFilter(backgroundFilter[0]).blurY;
			}
			addX = _dragCatchAddX;
			addY = _dragCatchAddY;
			if(_useDragCatch == true)
			{
				bd = new BitmapData(_compoWidth+addX*2+_dragCatchAddWidth,_compoHeight+addY*2+_dragCatchAddHeight,true,0);
				try
				{
					bd.draw(this,new Matrix(1,0,0,1,addX,addY));
				} 
				catch(error:Error) 
				{
					moveFollowDis = this;
					bd.dispose();
				}
				bp.bitmapData = bd;
				bp.x= this.x-addX;
				bp.y = this.y-addY;
				bp.alpha = 1;
				_bpSp.addChild(bp);
				this.parent.addChild(_bpSp);
				if(this.alpha != draggingTotalAlpha-draggingAlpha){
					var faAl:Number = draggingTotalAlpha-draggingAlpha;
					if(faAl <=0 ) faAl = 0;
					this.alpha = faAl;
					if(this.alpha == 0) this.visible = false;
				}
			}else
			{
				moveFollowDis = this;
			}
			this.removeEventListener(Event.ENTER_FRAME,alphaMoreMe);
			this.addEventListener(Event.ENTER_FRAME,alphaLessMe);
			pressX = this.mouseX;
			pressY = this.mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveDragView);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragWindow);
		}
		
		protected function stopDragWindow(event:MouseEvent):void
		{
			if(moveFollowDis == null){
				this.x = bp.x+addX;
				this.y = bp.y+addY;
			}
			this.visible = true;
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveDragView);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragWindow);
			this.removeEventListener(Event.ENTER_FRAME,alphaLessMe);
			this.addEventListener(Event.ENTER_FRAME,alphaMoreMe);
		}
		
		protected function alphaLessMe(event:Event):void
		{
			var tar:DisplayObject;
			if(_useDragCatch == true){
				tar = bp;
			}else{
				tar = this;
			}
			tar.alpha -= 0.075;
			if(tar.alpha < draggingAlpha){
				tar.alpha = draggingAlpha;
				this.removeEventListener(Event.ENTER_FRAME,alphaLessMe);
			}
		}
		
		protected function alphaMoreMe(event:Event):void
		{
			var tar:DisplayObject;
			if(_useDragCatch == true){
				tar = bp;
			}else{
				tar = this;
			}
			tar.alpha += 0.1;
			if(tar.alpha > 1){
				tar.alpha = 1;
				this.alpha = 1;
				this.removeEventListener(Event.ENTER_FRAME,alphaMoreMe);
				if(bd)
				{
					bd.dispose();
					bd = null;
				}
				if(bp && bp.parent)
				{
					bp.parent.removeChild(bp);
				}
			}
		}
		
		protected function moveDragView(event:MouseEvent):void
		{
			bp.x = this.parent.mouseX-pressX-addX;
			bp.y = this.parent.mouseY - pressY-addY;
			if(bp.x <-_compoWidth+40) bp.x = -_compoWidth+40;
			if(bp.x > this.stage.stageWidth-90) bp.x = this.stage.stageWidth-90;
			if(bp.y < -32) bp.y = -32;
			if(bp.y > this.stage.stageHeight-60) bp.y = this.stage.stageHeight-60;
			event.updateAfterEvent();
			bp.x = int(bp.x);
			bp.y = int(bp.y);
			if(moveFollowDis != null)
			{
				moveFollowDis.x = bp.x+addX;
				moveFollowDis.y = bp.y+addY;
				moveFollowDis.visible = true;
			}
		}
		
		
		protected function onAddToStage(event:Event):void
		{
			UI.stage.addEventListener(Event.RESIZE,onStageResize);
			checkOutside();
		}
		
		protected function onRemoveFromStage(event:Event=null):void
		{
			UI.stage.removeEventListener(Event.RESIZE,onStageResize);
		}
		
		protected function onStageResize(event:Event):void
		{
			if(_isResizeResetXY == false) return;
			if(this.parent == null) return;
			var gxy:Point = this.localToGlobal(new Point(0,0));
			var midx:int = int(gxy.x+_compoWidth/2);
			var midy:int = int(gxy.y + _compoHeight/2);
			var nx:int = int(UI.stage.stageWidth/_lastW*midx-_compoWidth/2);
			var ny:int = int(UI.stage.stageHeight/_lastH*midy-_compoHeight/2);
			var nxy:Point = this.parent.globalToLocal(new Point(nx,ny));
			this.x = nxy.x;
			this.y = nxy.y;
			checkOutside();
		}
		
		override protected function checkOutView(event:Event):void
		{
			
		}
		
		protected function checkOutside():void
		{
			if(this.parent == null) return;
			_lastW = UI.stage.stageWidth;
			_lastH = UI.stage.stageHeight;
			var gxy:Point = this.parent.localToGlobal(new Point(this.x,this.y));
			if(gxy.x > UI.stage.stageWidth - dragMax) {
				gxy.x = UI.stage.stageWidth - dragMax;
			}
			if(gxy.x < -_compoWidth + dragMax) {
				gxy.x = -_compoWidth + dragMax;
			}
			if(gxy.y > UI.stage.stageHeight - dragMaxheight) {
				gxy.y = UI.stage.stageHeight - dragMaxheight;
			}
			if(gxy.y < 0) {
				gxy.y = 0;
			}
			var nxy:Point = this.parent.globalToLocal(new Point(gxy.x,gxy.y));
			this.x = nxy.x;
			this.y = nxy.y; 
		}
		
		protected function switchMax(event:MouseEvent):void
		{
			isMaxWindow = !isMaxWindow;
			if(isMaxWindow == true){
				bakData = [this.x,this.y,this._compoWidth,this._compoHeight];
				this.x = 0;
				this.y = 0;
				this.setSize(this.stage.stageWidth,this.stage.stageHeight);
				if(SkinManager.isUseDefaultSkin == true){
					maxBtn.icon = BitmapDataText.decodeTextToBitmapData(maxIconStr2);
				}else{
					maxBtn.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_MAXRE_BUTTON));
				}
				maxBtn.toolTip = "还原窗口";
				dragBtn.visible = false;
				resizeB.visible = false;
				resizeR.visible = false;
				resizeT.visible = false;
				resizeL.visible = false;
				resizeRB.visible =false;
				resizeLB.visible =false;
				resizeTL.visible =false;
				resizeTR.visible =false;
				moveWindowTop();
			}else{
				this.x = bakData[0];
				this.y = bakData[1];
				this.setSize(bakData[2],bakData[3]);
				if(SkinManager.isUseDefaultSkin == true){
					maxBtn.icon = BitmapDataText.decodeTextToBitmapData(maxIconStr1);
				}else{
					maxBtn.setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.WINDOW_MAX_BUTTON));
				}
				maxBtn.toolTip = "最大化窗口";
				dragBtn.visible = _ableUserDrag;
				resizeB.visible = _ableUserResizeWindow;
				resizeR.visible = _ableUserResizeWindow;
				resizeT.visible = _ableUserResizeWindow;
				resizeL.visible = _ableUserResizeWindow;
				resizeRB.visible =_ableUserResizeWindow;
				resizeLB.visible =_ableUserResizeWindow;
				resizeTL.visible =_ableUserResizeWindow;
				resizeTR.visible =_ableUserResizeWindow;
			}
			if(isMinWindow == true){
				switchMin(event);
			}
		}	
		
		protected function switchMin(event:MouseEvent):void
		{
			isMinWindow = !isMinWindow;
			if(isMinWindow == true){
				this.scrollRect = new Rectangle(0,0,_compoWidth,tiHeight-1);
				filterBG.visible = false;
				if(SkinManager.isUseDefaultSkin == true){
					miniBtn.icon = BitmapDataText.decodeTextToBitmapData(miniIconStr2);
				}
			}else{
				this.scrollRect = null;
				filterBG.visible = true;
				if(SkinManager.isUseDefaultSkin == true){
					miniBtn.icon = BitmapDataText.decodeTextToBitmapData(miniIconStr1);
				}
			}
		}	
		
	}
}