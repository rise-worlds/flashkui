﻿package cn.flashk.controls
{
	import cn.flashk.controls.events.CustomEvent;
	import cn.flashk.controls.interfaces.IListItemRender;
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SkinManager;
	import cn.flashk.controls.managers.SkinThemeColor;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.managers.StyleManager;
	import cn.flashk.controls.modeStyles.ScrollBarSkinSet;
	import cn.flashk.controls.proxy.DataProvider;
	import cn.flashk.controls.skin.ActionDrawSkin;
	import cn.flashk.controls.skin.ListSkin;
	import cn.flashk.controls.skin.sourceSkin.ListSourceSkin;
	import cn.flashk.controls.skin.sourceSkin.SourceSkin;
	import cn.flashk.controls.support.ColorConversion;
	import cn.flashk.controls.support.ItemsSelectControl;
	import cn.flashk.controls.support.ListItemRender;
	import cn.flashk.controls.support.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * 当List的selectIndex值改变时触发
	 * @eventType flash.events.Event.CHANGE
	 **/
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 *  鼠标在子项中划过时调度
	 * @eventType cn.flashk.controls.events.CustomEvent.ITEM_MOUSE_OVER
	 **/
	[Event(name="itemMouseOver",type="cn.flashk.controls.events.CustomEvent")]
	
	
	/**
	 *  用户单击渲染器
	 * @eventType cn.flashk.controls.events.ListEvent.ITEM_CLICK
	 **/
	[Event(name="itemClick",type="cn.flashk.controls.events.ListEvent")]
	
	
	/**
	 *   用户双击击渲染器，需要使用此事件，需要在addItem之前设置itemDoubleClickEnabled=true
	 * @eventType cn.flashk.controls.events.ListEvent.ITEM_DOUBLE_CLICK
	 **/
	[Event(name="itemDoubleClick",type="cn.flashk.controls.events.ListEvent")]
	
	/**
	 * List 组件将显示基于列表的信息，并且是适合显示信息数组的理想选择。默认显示一列文字、图标（如果有）。
	 *  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.support.UIComponent
	 * 
	 * @see cn.flashk.controls.proxy.DataProvider
	 * 
	 * @author flashk
	 */

	public class List extends UIComponent
	{
		/**
		 * 默认单个渲染器的高度，此属性仅提供给设置ComboBox.rowCount属性时使用
		 */ 
		public static var defaultItemHeight:Number=23;
		/**
		 * 获取或设置显示文本的字段名称，显示为 TextInput 字段和下拉列表的标签。
		 */ 
		public var labelField:String = "label";
		/**
		 * 获取或设置用于提供项的图标的项字段。
		 */ 
		public var iconField:String = "icon";
		
		protected var items:Sprite;
		protected var scrollBar:VScrollBar;
		protected var _itemRender:Class;
		protected var _allowMultipleSelection:Boolean = false;
		protected var _selectedIndex:int = -1;
		protected var isFouceInMe:Boolean = false;
		protected var _dataProvider:Object;
		protected var scrollBarLastVisible:Boolean = false;
		protected var isDpAdd:Boolean = false;
		protected var _nowOverData:Object;
		protected var _nowOverIndex:int;
		protected var _useIconWidth:Boolean = true;
		protected var _isNeedUpdate:Boolean;
		protected var _snapNum:Number;
		protected var _isNeedAddUpdate:Boolean = false;
		protected var _isNeedAlign:Boolean = true;
		protected var _isRemoveDestory:Boolean = true;
		protected var _itemDoubleClickEnabled:Boolean = false;
		protected var boxSelectControler:ItemsSelectControl;
		
		/**
		 * 
		 * @param skinSet 在swf皮肤模式下要使用的滚动条皮肤的库链接名设定
		 * 
		 */
		public function List(skinSet:ScrollBarSkinSet=null)
		{
			super();
            
			_compoWidth = 300;
			_compoHeight = 300;
			_snapNum = StyleManager.defaultListSnapNum;
			_itemRender = ListItemRender;
			_dataProvider = new DataProvider();
			styleSet["ellipse"] = 0;
			styleSet["borderColor"] = ColorConversion.transUintToWeb(SkinThemeColor.border);
			styleSet["borderAlpha"] = 0.5;
			styleSet["backgroundColor"] = "#FDFDFD";
			styleSet["backgroundAlpha"] = 1.0;
			styleSet["textPadding"] = 5;
			styleSet["iconPadding"] = 5;
			items = new Sprite();
			items.y= 1;
			this.addChild(items);
			scrollBar = new VScrollBar(skinSet);
			scrollBar.setTarget(items,false,_compoWidth,_compoHeight-2);
			scrollBar.smoothNum = StyleManager.listScrollBarSmoothNum;
			scrollBar.updateSize(100);
			scrollBar.smoothScroll = true;
			scrollBar.mousemouseWheelDelta = 1;
			scrollBar.visible = false;
			this.addChild(scrollBar);
			setSize(_compoWidth, _compoHeight);
			boxSelectControler = new ItemsSelectControl();
			boxSelectControler.initViewPanel(this,items);
			this.addEventListener(MouseEvent.CLICK,checkSelectNone);
			this.addEventListener(Event.ADDED_TO_STAGE,addKeyLis);
			this.addEventListener(Event.REMOVED_FROM_STAGE,clearLis);
		}

		public function get itemDoubleClickEnabled():Boolean
		{
			return _itemDoubleClickEnabled;
		}

		/**
		 * 是否开启Item的双击事件 
		 * @param value
		 * 
		 */
		public function set itemDoubleClickEnabled(value:Boolean):void
		{
			_itemDoubleClickEnabled = value;
		}

		/**
		 * 渲染器的容器 
		 * @return 
		 * 
		 */
		public function get rendersContainer():Sprite
		{
			return items;
		}
        
		public function get snapNum():Number
		{
			return _snapNum;
		}

		/**
		 * 滚动的间隔，默认为2px，可以设定为默认渲染器的行高以对其，默认渲染器的行高为23 
		 * @param value
		 * 
		 */
		public function set snapNum(value:Number):void
		{
			_snapNum = value;
		}

		/**
		 * 返回渲染器的实例 
		 * @param index
		 * @return 
		 * 
		 */
        public function getRenderAt(index:uint):DisplayObject
		{
			return items.getChildAt(index);
		}

		public function get useIconWidth():Boolean
		{
			return _useIconWidth;
		}

		public function set useIconWidth(value:Boolean):void
		{
			_useIconWidth = value;
		}

		public function get nowOverIndex():int
		{
			return _nowOverIndex;
		}

		public function get nowOverData():Object
		{
			return _nowOverData;
		}

        override public function hideSkin(isHide:Boolean=true):void
        {
            if(SkinManager.isUseDefaultSkin)
            {
                styleSet["borderAlpha"] = 0;
                styleSet["backgroundAlpha"] = 0;
                updateSkin();
            }else
            {
                SourceSkin(skin).sc9Bitmap.visible = !isHide;
            }
        }
        
		/**
		 * 设置List的数据源，对于List、DataGrid, TileList它应该是个DataProvider对象（可以直接将二维数组转为DataProvider，请参见DataProvider构造函数）,对于 Tree 它应该是个XML
		 * 
		 * @see cn.flashk.controls.proxy.DataProvider
		 */ 
		public function set dataProvider(value:Object):void
		{
			removeAll();
			_dataProvider = value;
			isDpAdd = true;
			for(var i:int=0;i<_dataProvider.length;i++)
			{
				addItem(_dataProvider.getItemAt(i));
			}
			isDpAdd = false;
            try
			{
                scrollBar.scrollToPosition(0);
            }catch(e:Error)
            {
                
            }
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function get selectItemValue():*
		{
			return selectedItem.value;
		}
		
		public function get selectedIndices():Array
		{
			var arr:Array = [];
			var render:DisplayObject;
			for(var i:int = 0;i<items.numChildren;i++)
			{
				render = items.getChildAt(i);
				if(IListItemRender(render).selected == true)
				{
					arr.push(i);
				}
			}
			return arr;
		}
		
		/**
		 * 获取或设置一个数组，其中包含从多选列表中选定的项目。
		 */ 
		public function set selectedIndices(value:Array):void
		{
			var render:DisplayObject;
			for(var i:int = 0;i<items.numChildren;i++)
			{
				render = items.getChildAt(i);
				IListItemRender(render).selected = false;
			}
			for(var j:int=0;j<value.length;j++)
			{
				render = items.getChildAt(value[j]);
				IListItemRender(render).selected = true;
			}
		}
		
		/**
		 * 获取包含多选列表中的已选定项目数据的数组。
		 */ 
		public function get selectedItems():Array
		{
			var arr:Array = [];
			var render:DisplayObject;
			for(var i:int = 0;i<items.numChildren;i++)
			{
				render = items.getChildAt(i);
				if(IListItemRender(render).selected == true)
				{
					arr.push(IListItemRender(render).data);
				}
			}
			return arr;
		}
		
		/**
		 * 获得索引位置的列表渲染器的实例，你可以对获得的实例访问其公开方法，比如设置图标
		 * 
		 * @see cn.flashk.controls.support.ListItemRender
		 * @see cn.flashk.controls.support.TreeItemRender
		 * @see cn.flashk.controls.support.TileListThumbnail
		 */ 
		public function getItemRenderAt(index:uint):IListItemRender{
			var render:IListItemRender;
			render = items.getChildAt(index) as IListItemRender;
			return render;
		}
		
		protected function clearLis(event:Event):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,checkSelectAll);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,checkFocus);
			isFouceInMe = false;
		}
		
		protected function addKeyLis(event:Event):void{
			this.stage.addEventListener(KeyboardEvent.KEY_UP,checkSelectAll);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,checkFocus);
		}
		
		protected function checkFocus(event:MouseEvent):void{
			if(this.mouseX < -5 || this.mouseY<-5 || this.mouseX>_compoWidth || this.mouseY>_compoHeight){
				isFouceInMe = false;
			}
		}
		
		protected function checkSelectNone(event:MouseEvent):void
		{
			isFouceInMe = true;
			if(event.target == this) boxSelectControler.selectNone();
			
		}
		
		protected function checkSelectAll(event:KeyboardEvent):void
		{
			if(isFouceInMe == false) return;
			if(event.ctrlKey == true)
			{
				if(event.keyCode == 65)
				{
					boxSelectControler.selectAll();
				}
				if(event.keyCode == 68)
				{
					boxSelectControler.selectNone();
				}
			}
		}
		
		override protected function updateSkinBefore():void
		{
			var len:int = items.numChildren;
			for(var i:int=0;i<len;i++)
			{
				Object(items.getChildAt(i)).index = i;
			}
		}
		
		override public function setDefaultSkin():void 
		{
			setSkin(ListSkin)
		}
		
		override public function setSourceSkin():void 
		{
			setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.LIST));
		}
		
		override public function setSkin(Skin:Class):void 
		{
			if(SkinManager.isUseDefaultSkin == true){
				skin = new Skin();
				ActionDrawSkin(skin).init(this,styleSet);
			}else{
				var sous:ListSourceSkin = new ListSourceSkin();
				sous.init(this,styleSet,Skin);
				skin = sous;
			}
		}
		
		public function get selectedIndex():uint
		{
			return _selectedIndex;
		}
		
		/**
		 * 获取或设置单选列表中的选定项目的索引。
		 */ 
		public function set selectedIndex(value:uint):void
		{
			_selectedIndex = value;
			if(value < items.numChildren)
			{
				itemClick({currentTarget:items.getChildAt(value)});
			}
		}
		
		/**
		 * 获取或设置从单选列表中选择的项目。
		 */ 
		public function get selectedItem():Object
		{
			return IListItemRender(items.getChildAt(_selectedIndex)).data;
		}
		
		public function set selectedItem(value:Object):void
		{
			for(var i:int = 0;i<items.numChildren;i++)
			{
				if(IListItemRender(items.getChildAt(i)).data == value)
				{
					itemClick({currentTarget:items.getChildAt(i)});
				}
			}
		}
		
		/**
		 * 指定List要使用哪个类作为单元格渲染器，默认为ListItemRender，你可以使用自己的单元格渲染器以实现更多的功能，如果需要自定义渲染，请在向List添加数据（addItem或设置dataProvider）前设置。
		 * 
		 * <p>自定义的渲染器类必须实现IListItemRender接口，以便接受/访问data，并提供渲染器的高度，详细请参阅IListItemRender。</p>
		 * 
		 * @see cn.flashk.controls.support.ListItemRender
		 * @see cn.flashk.controls.interfaces.IListItemRender
		 */ 
		public function set itemRender(value:Class):void
		{
			_itemRender = value;
		}
		
		public function get itemRender():Class
		{
			return _itemRender;
		}
		
		/**
		 * 获得对List组件的竖向滚动条实例的引用
		 */ 
		public function get scrollBarRef():VScrollBar
		{
			return scrollBar;
		}
		
		public function get allowMultipleSelection():Boolean{
			return _allowMultipleSelection;
		}
		/**
		 * 是否允许用户对List进行多选，当允许多选时用户可以使用按下Ctrl键连续选择多个项，也可以使用按下鼠标+移动鼠标进行框选，同时也支持快捷键的选择：Ctrl + A 全选，Ctrl + D 全部取消选择
		 */ 
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}
		
		/**
		 * 获取数据提供者中的项目数（List的总长度）。
		 */ 
		public function get length():uint
		{
			return uint(items.numChildren);
		}
		/**
		 * <p>向项目列表的末尾追加项目。 </p>
		 * 使用默认渲染器的情况下，项目应包含 label 和 data 属性，但包含其它属性的项目也可以添加到列表。 项目的 label 属性用于显示行的标签；data 属性用于存储行的数据。 
		 * 
		 * item.icon 指定使用图标，支持三种类型的值：BitmapData/Class引用 /库链接名的String 
		 * 对于useIconWidth=true的设定，使用iocn本身的宽度来排列文本，对于false设定，使用styleSet["textPadding"] = 5; styleSet["iconPadding"] = 5;两个值
		 * 
		 * @param item 要添加到数据提供者的项目。 
		 */ 
		public function addItem(item:Object):void
		{
			addItemAt(item,items.numChildren);
		}
		/**
		 * 在指定索引位置处将项目插入列表。 位于指定索引位置处或之后的项目的索引将增加 1。
		 * @param item 要添加到列表的项目。
		 * @param index 要添加项目处的索引。
		 * 
		 * @see #addItem()
		 */ 
		public function addItemAt(item:Object,index:uint):void
		{
			var render:InteractiveObject = new _itemRender() as InteractiveObject;
			if(isDpAdd == false)
			{
				_dataProvider.addItemAt(item,index);
			}
			IListItemRender(render).list = this;
			IListItemRender(render).data = item;
			var itemWidth:Number = _compoWidth;
			if(scrollBar.visible == true)
			{
				itemWidth =scrollBar.x;
			}
			IListItemRender(render).setSize(itemWidth,0);
			render.addEventListener(MouseEvent.CLICK,itemClick);
			render.addEventListener(MouseEvent.ROLL_OVER,itemMouseOver);
			render.addEventListener(MouseEvent.ROLL_OUT,itemMouseOut);
			items.addChildAt(render,index);
			if(index == _selectedIndex)
			{
				this.dispatchEvent(new Event("getSelectIndexData"));
			}
			_isNeedUpdate = true;
			if(UIComponent.stage)
			{
				UIComponent.stage.addEventListener(Event.RENDER,reAlign);
				UIComponent.stage.invalidate();
			}else
			{
				throw new Error(UIComponent.errorMsg);
			}
		}
		
		public function addItemRenderAt(render:IListItemRender,index:uint):void
		{
			var dis:DisplayObject = DisplayObject(render);
			if(dis.parent == null)
			{
				dis.addEventListener(MouseEvent.CLICK,itemClick);
				dis.addEventListener(MouseEvent.ROLL_OVER,itemMouseOver);
				dis.addEventListener(MouseEvent.ROLL_OUT,itemMouseOut);
			}
			items.addChildAt(dis,index);
		}
		
		protected function reAlign(event:Event):void
		{
			if(_isNeedUpdate == true)
			{
				_isNeedUpdate = false;
				resetScrollBar();
				UIComponent.stage.removeEventListener(Event.RENDER,reAlign);
				
				var render:DisplayObject;
				var itemWidth:Number = _compoWidth;
				if(scrollBar.visible == true)
				{
					itemWidth =scrollBar.x;
				}
				for(var i:int = 0;i<items.numChildren;i++)
				{
					render = items.getChildAt(i);
					if(render.width != itemWidth){
						IListItemRender(render).setSize(itemWidth,0);
					}
				}
			}
		}
		
		protected function resetScrollBar():void
		{
			if(items.numChildren>0)
			{
				var render:DisplayObject = items.getChildAt(0);
				var ix:int = 0;
				var dis:DisplayObject;
				for(var i:int=0;i<items.numChildren;i++){
					dis = items.getChildAt(i);
					dis.y = ix;
					IListItemRender(dis).index = i;
					ix += IListItemRender(dis).itemHeight;
				}
				if(ix > _compoHeight)
				{
					scrollBar.setTarget(items,false,_compoWidth-17,_compoHeight-items.y-1);
					scrollBar.updateSize(IListItemRender(render).itemHeight*items.numChildren);
					scrollBar.visible = true;
					scrollBar.snapNum = _snapNum;
					scrollBar.arrowClickStep = IListItemRender(render).itemHeight;
					scrollBar.updateSize(IListItemRender(render).itemHeight*items.numChildren-3 );
				}else
				{
					scrollBar.scrollToPosition(0);
					scrollBar.setTarget(items,false,_compoWidth,_compoHeight-items.y-1);
					scrollBar.updateSize(1);
					scrollBar.visible = false;
				}
				if(scrollBar.visible != scrollBarLastVisible)
				{
					updateSkin();
				}
			}else
			{
				scrollBar.visible = false;
			}
			scrollBarLastVisible = scrollBar.visible;
		}
		
		/**
		 * 用其它项目替换指定索引位置处的项目。 此方法会修改 List 组件的数据提供者。 如果与其它组件共享数据提供者，则向这些组件提供的数据也会更新。 
		 * 
		 * @param item 要替换指定索引位置处的项目的项目。
		 * @param index 要替换的项目的索引位置。 
		 * @return 被替换的项目。
		 */ 
		public function replaceItemAt(item:Object, index:uint):Object
		{
			addItemAt(item,index);
			return removeItemAt(index+1);
		}
		
		/**
		 * 删除指定索引位置处的项目。 位于指定索引位置之后的项目的索引将减少 1。 
		 * 
		 * @param index 数据提供者中要删除的项目的索引。
		 * @return 被删除的项目。 
		 */ 	
		public function removeItemAt(index:uint):Object
		{
			var render:DisplayObject;
			render = items.getChildAt(index);
			items.removeChild(render);
			if(Object(render).hasOwnProperty("destory")) Object(render).destory();
			if(isDpAdd == false)
			{
				_dataProvider.removeItemAt(index);
			}
			resetScrollBar();
			return IListItemRender(render).data;
		}
		
		public override function destroy():void
		{
			super.destroy();
			try
			{
				var len:int = items.numChildren;
				for(var i:int=0;i<len;i++)
				{
					Object(items.getChildAt(i)).destory();
				}
			} 
			catch(error:Error) 
			{
				
			}
			items = null;
			boxSelectControler.destory();
			scrollBar.destroy();
			scrollBar = null;
		}
		
		/**
		 * 删除列表中的所有项目。 
		 */ 
		public function removeAll():void
		{
			scrollBar.scrollToPosition(0);
			scrollBar.updateSize(0);
			try
			{
				if(_isRemoveDestory)
				{
					var len:int = items.numChildren;
					for(var i:int=0;i<len;i++)
					{
						Object(items.getChildAt(i)).destory();
					}
				}
			} 
			catch(error:Error) 
			{
				
			}
			items.parent.removeChild(items);
			items = new Sprite();
			items.y= 1;
			this.addChild(items);
			setSize(_compoWidth, _compoHeight);
			boxSelectControler.destory();
			boxSelectControler = new ItemsSelectControl();
			boxSelectControler.initViewPanel(this,items);
			if(_dataProvider is DataProvider )
			{
				_dataProvider.removeAll();
			}
		}
		
		/**
		 * 检索指定索引处的项目。 
		 * 
		 * @param index 要检索的项目的索引。
		 * @return 位于指定索引位置处的对象。
		 */ 
		public function getItemAt(index:uint):Object
		{
			return IListItemRender(items.getChildAt(index)).data;
		}
		
		/**
		 * 将列表滚动至位于指定索引处的项目。 如果索引超出范围，则滚动到最底部（大于总数）或者最顶部（负数）。 
		 */ 
		public function scrollToIndex(newCaretIndex:int):void
		{
			scrollBar.scrollToPosition(newCaretIndex*IListItemRender(items.getChildAt(0)).itemHeight);
		}
			
		override public function updateSkin():void 
		{
			super.updateSkin();
			var render:DisplayObject;
			var itemWidth:Number = _compoWidth;
			if(scrollBar.visible == true)
			{
				itemWidth =scrollBar.x;
			}
			for(var i:int = 0;i<items.numChildren;i++)
			{
				render = items.getChildAt(i);
				IListItemRender(render).setSize(itemWidth,0);
			}
		}
		
		override public function setSize(newWidth:Number, newHeight:Number):void 
		{
			super.setSize(newWidth, newHeight);
			scrollBar.setTarget(items,false,_compoWidth,_compoHeight-2);
			scrollBar.y = 1;
			scrollBar.x = int(_compoWidth - VScrollBar.defaultWidth-1);
			scrollBar.setSize(VScrollBar.defaultWidth,_compoHeight-2);
			if(items.numChildren >0)
			{
				var render:DisplayObject = items.getChildAt(0);
				scrollBar.updateSize(IListItemRender(render).itemHeight*items.numChildren -3 );
			}
			var itemWidth:Number = _compoWidth;
			if(scrollBar.visible == true)
			{
				itemWidth =scrollBar.x;
			}
			for(var i:int=0;i<items.numChildren;i++)
			{
				IListItemRender(items.getChildAt(i)).setSize(itemWidth,0);
			}
		}
		
		protected function itemMouseOver(event:Event):void
		{
			_nowOverData = IListItemRender(event.currentTarget).data;
			_nowOverIndex = items.getChildIndex(event.currentTarget as DisplayObject);
			this.dispatchEvent(new Event(CustomEvent.ITEM_MOUSE_OVER));
		}
		
		protected function itemMouseOut(event:Event):void
		{
			this.dispatchEvent(new Event(CustomEvent.ITEM_MOUSE_OUT));
		}
		
		protected function itemClick(event:Object):void
		{
			var render:DisplayObject;
			if(_allowMultipleSelection == false || UIComponent.isCtrlKeyDown == false)
			{
				for(var i:int = 0;i<items.numChildren;i++)
				{
					render = items.getChildAt(i);
					IListItemRender(render).selected = false;
				}
			}
			IListItemRender(event.currentTarget).selected = !IListItemRender(event.currentTarget).selected;
			try
			{
				_selectedIndex = items.getChildIndex(event.currentTarget as DisplayObject);
			} 
			catch(error:Error) 
			{
				_selectedIndex = 0;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}