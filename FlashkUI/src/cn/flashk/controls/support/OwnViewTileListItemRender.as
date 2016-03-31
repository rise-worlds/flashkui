 package cn.flashk.controls.support
{
        import cn.flashk.controls.List;
        import cn.flashk.controls.events.ListEvent;
        import cn.flashk.controls.interfaces.ITileListItemRender;
        
        import flash.display.DisplayObject;
        import flash.display.Sprite;
        import flash.events.MouseEvent;
        
		/**
		 * 使用此渲染器，可以在addItem(item)中添加.view和.render属性以简单使用自定义显示 
		 * @author flashk
		 * 
		 */
        public class OwnViewTileListItemRender extends Sprite implements ITileListItemRender
        {
            private var _data:Object;
            private var _height:Number = 128;
            private var _width:Number = 107;
            private var _list:List;
            private var _selected:Boolean = false;
            private var _view:DisplayObject;
            
            public function OwnViewTileListItemRender()
            {
                this.addEventListener(MouseEvent.MOUSE_OVER,showOver);
                this.addEventListener(MouseEvent.MOUSE_OUT,showOut);
            }
            
			public function set index(value:int):void
			{
				
			}
			
			public function get view():DisplayObject
			{
				return _view;
			}

            protected function showOver(event:MouseEvent=null):void
            {
                if(_selected == false){
                    
                }
            }
            
            public function showSelect(event:MouseEvent=null):void
            {
                
            }
            
            protected function showOut(event:MouseEvent =null):void
            {
                if(_selected == false){
                    
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
			
			protected function onRenderClick(event:MouseEvent):void
			{
				DisplayObject(_list).dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,this));
			}
			
			protected function onRenderDoubleClick(event:MouseEvent):void
			{
				DisplayObject(_list).dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,this));
			}
			
            public function set data(value:Object):void{
                _data = value;
				var classRef:Class = value.classRef as Class;
				if(classRef!=null)
				{
					_view = new classRef() as DisplayObject;
				}
				//.render 属性接受一个显示对象的类，此对象类实现 public function set data(value:Object) 函数
				var classRefRender:Class = value.render as Class;
				if(classRefRender !=null)
				{
					_view = new classRefRender() as DisplayObject;
					Object(_view).data = value;
				}
				if(value.view != null)
				{
					_view = value.view;
					Object(_view).data = value;
				}
				this.addChild(_view);
				
				_width = _view.width;
				_height = _view.height;
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
				Object(_view).selected = value;
            }
			
            public function get selected():Boolean{
                return _selected;
            }
			
    }
}