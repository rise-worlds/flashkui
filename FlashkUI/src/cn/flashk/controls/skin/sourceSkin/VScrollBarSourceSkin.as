package cn.flashk.controls.skin.sourceSkin
{
	import cn.flashk.controls.VScrollBar;
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.modeStyles.ScrollBarSkinSet;
	import cn.flashk.controls.support.Scale9GridBitmap;
	import cn.flashk.controls.support.UIComponent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	public class VScrollBarSourceSkin extends SourceSkin
	{
		private  var bd:BitmapData;
		private  var skin:DisplayObject;
		private  var skinT:DisplayObject;
		private  var skinB:DisplayObject;
		private  var skinBG:DisplayObject;
		private  var skinMid:DisplayObject;
		private  var bds:Array;
		private  var bdsT:Array;
		private  var bdsB:Array;
		private  var bdsBG:Array;
		private  var bdsMid:Array;
		
		public var arrowUp:Sprite;
		public var arrowDown:Sprite;
		public var bar:Sprite;
		public var scroller:Sprite;
		
		protected var barLink:String;
		protected var middle:String;
		protected var topArrow:String;
		protected var bottomArrow:String;
		protected var background:String;
		protected var backgroundMask:String;
		
		protected var tar:VScrollBar;
		protected var bpT:Scale9GridBitmap;
		protected var bpB:Scale9GridBitmap;
		protected var bpBG:Scale9GridBitmap;
		protected var bpMid:Scale9GridBitmap;
		protected var lastY:Number=-50;
		protected var bpMask:Shape;
		protected var shMask:Shape;
		protected var bdMask:BitmapData;
		protected var needChange:Boolean = false;
		protected var count:uint=0
		protected var _skinSet:ScrollBarSkinSet;
		
		public function VScrollBarSourceSkin(skinSet:ScrollBarSkinSet)
		{
			super();
			_skinSet = skinSet;
			if(skinSet != null){
				barLink = _skinSet.bar;
				middle = _skinSet.middle;
				topArrow = _skinSet.topArrow;
				bottomArrow = _skinSet.bottomArrow;
				background = _skinSet.background;
				backgroundMask = _skinSet.backgroundMask;
			}else{
				barLink = SourceSkinLinkDefine.SCROLL_BAR;
				middle = SourceSkinLinkDefine.SCROLL_BAR_MIDDLE;
				topArrow = SourceSkinLinkDefine.SCROLL_BAR_TOP_ARR;
				bottomArrow = SourceSkinLinkDefine.SCROLL_BAR_BOTTOM_ARR;
				background = SourceSkinLinkDefine.SCROLL_BAR_BACKGROUND;
				backgroundMask = SourceSkinLinkDefine.SCROLL_BAR_BACKGROUND_MASK;
			}
			bpT = new Scale9GridBitmap();
			bpB = new Scale9GridBitmap();
			bpBG = new Scale9GridBitmap();
			bpMid = new Scale9GridBitmap();
			arrowUp = new Sprite();
			arrowDown = new Sprite();
			bar = new Sprite();
			scroller = new Sprite();
			arrowUp.addChild(bpT);
			arrowDown.addChild(bpB);
			scroller.addChild(bp);
			scroller.addChild(bpMid);
			bar.addChild(bpBG);
			bpT.x = 1;
			bpB.x = 1;
		}
		
		override public function init(target:UIComponent,styleSet:Object,Skin:Class):void {
			super.init(target,styleSet,Skin);
			if(skin == null){
				skin = new Skin() as DisplayObject;
			}
			initBp(skin);
			tar = target as VScrollBar;
			
			if(bds == null){
				bds = new Array();
				drawMovieClipToArray(skin as MovieClip,bds);
			}
			bp.sourceBitmapData = bds[1] as BitmapData;
			tar.addChildAt(scroller,0);
			tar.addChildAt(arrowUp,0);
			tar.addChildAt(arrowDown,0);
			tar.addChildAt(bar,0);
			scroller.addEventListener(MouseEvent.MOUSE_OVER,showOver);
			scroller.addEventListener(MouseEvent.MOUSE_OUT,showOut);
			scroller.addEventListener(MouseEvent.MOUSE_DOWN,showDown);
			initTop();
			initBottom();
			initBG();
			initMid();
			var maskClass:Class = SkinLoader.getClassFromSkinFile(backgroundMask);
			if(maskClass != null){
				shMask = new Shape();
				var ma:DisplayObject = new maskClass() as DisplayObject;
				bdMask = new BitmapData(ma.width,ma.height,true,0);
				bdMask.draw(ma);
				shMask.graphics.beginBitmapFill(bdMask,null,true,false);
				shMask.graphics.drawRect(0,0,tar.compoWidth,tar.compoHeight);
				tar.addChild(shMask);
				bpMask = new Shape();
				bpMask.cacheAsBitmap = false;
				shMask.mask = bpMask;
				tar.addChild(bpMask);
				scroller.addEventListener(Event.ENTER_FRAME,checkYChange);
				setTimeout(showLater,500);
			}
		}
		
		protected function updateToPos(event:MouseEvent):void
		{
			checkYChange();
		}
		
		private function showLater():void{
			lastY = -70;
		}
		
		public function checkYChange(event:Event=null):void{
			if(bpMask == null) return;
			if(scroller.y != lastY || count<200){
				bpMask.y = scroller.y;
				bpMask.graphics.clear();
				bpMask.graphics.beginFill(0);
				bpMask.graphics.drawRect(0,bp.width/2+1,bp.width,bp.height-bp.width-2);
				if(bpMask.width >0 && bpMask.height>0){
					lastY = scroller.y;
				}
			}
		}
		
		private function initBG():void{
			var Skin:Class = SkinLoader.getClassFromSkinFile(background);
			if(skinBG == null){
				skinBG = new Skin() as DisplayObject;
			}
			if(bdsBG == null){
				bdsBG = new Array();
				bd=new BitmapData(skinBG.width,skinBG.height,true,0);
				bd.draw(skinBG,new Matrix(1,0,0,1));
				bdsBG[1] = bd;
			}
			bpBG.sourceBitmapData = bdsBG[1] as BitmapData;
			bpBG.leftLineSpace = 1;
			bpB.rightLineSpace = 1;
		}
		
		private function initMid():void{
			var Skin:Class = SkinLoader.getClassFromSkinFile(middle);
			if(skinMid == null){
				skinMid = new Skin() as DisplayObject;
			}
			if(bdsMid == null){
				bdsMid = new Array();
				drawMovieClipToArray(skinMid as MovieClip,bdsMid);
			}
			bpMid.sourceBitmapData = bdsMid[1] as BitmapData;
		}
		
		private function initTop():void{
			var Skin:Class = SkinLoader.getClassFromSkinFile(topArrow);
			if(skinT == null){
				skinT = new Skin() as DisplayObject;
			}
			if(bdsT == null){
				bdsT = new Array();
				drawMovieClipToArray(skinT as MovieClip,bdsT);
			}
			bpT.bitmapData = bdsT[1] as BitmapData;
			arrowUp.addEventListener(MouseEvent.MOUSE_OVER,showOverT);
			arrowUp.addEventListener(MouseEvent.MOUSE_OUT,showOutT);
			arrowUp.addEventListener(MouseEvent.MOUSE_DOWN,showDownT);
		}
		
		private function initBottom():void{
			var Skin:Class = SkinLoader.getClassFromSkinFile(bottomArrow);
			if(skinB == null){
				skinB = new Skin() as DisplayObject;
			}
			if(bdsB == null){
				bdsB = new Array();
				drawMovieClipToArray(skinB as MovieClip,bdsB);
			}
			bpB.bitmapData = bdsB[1] as BitmapData;
			arrowDown.addEventListener(MouseEvent.MOUSE_OVER,showOverB);
			arrowDown.addEventListener(MouseEvent.MOUSE_OUT,showOutB);
			arrowDown.addEventListener(MouseEvent.MOUSE_DOWN,showDownB);
		}
		
		protected function showDownT(event:MouseEvent):void
		{
			bpT.sourceBitmapData = bdsT[3] as BitmapData;
		}
		
		protected function showOutT(event:MouseEvent=null):void
		{
			bpT.sourceBitmapData = bdsT[1] as BitmapData;
		}
		
		protected function showOverT(event:MouseEvent):void
		{
			bpT.sourceBitmapData = bdsT[2] as BitmapData;
		}
		
		protected function showDownB(event:MouseEvent):void
		{
			bpB.sourceBitmapData = bdsB[3] as BitmapData;
		}
		
		protected function showOutB(event:MouseEvent=null):void
		{
			bpB.sourceBitmapData = bdsB[1] as BitmapData;
		}
		
		protected function showOverB(event:MouseEvent):void
		{
			bpB.sourceBitmapData = bdsB[2] as BitmapData;
		}
		
		protected function showDown(event:MouseEvent):void
		{
			bp.sourceBitmapData = bds[3] as BitmapData;
			bp.update();
			bpMid.sourceBitmapData = bdsMid[3] as BitmapData;
		}
		
		protected function showOut(event:MouseEvent=null):void
		{
			bp.sourceBitmapData = bds[1] as BitmapData;
			bp.update();
			bpMid.sourceBitmapData = bdsMid[1] as BitmapData;
		}
		
		protected function showOver(event:MouseEvent):void
		{
			bp.sourceBitmapData = bds[2] as BitmapData;
			bp.update();
			bpMid.sourceBitmapData = bdsMid[2] as BitmapData;
		}
		
		override public function reDraw():void {
			var width:Number;
			var height:Number;
			width= tar.compoWidth;
			height= width;
			arrowDown.y = int(tar.compoHeight - tar.compoWidth+height)-arrowDown.height;
			if(scroller.y == 0 && arrowUp.visible == true){
				scroller.y = tar.compoWidth;
			}
			bpBG.height = tar.compoHeight;
			bpBG.width = tar.compoWidth;
			width = tar.compoWidth - 3;
			var lessNum:Number;
			if (arrowUp.visible  == true) {
				lessNum =  tar.compoWidth;
			}else {
				lessNum = 0;
			}
			var clipH:Number = (1+tar.maxScrollPosition / tar.clipSize);
			if(clipH==0) clipH = 1;
			height = (tar.compoHeight - lessNum * 2) /clipH ;
			if (height < 20) {
				height = 20;
			}
			if(isNaN(tar.maxScrollPosition) || tar.maxScrollPosition <=0){
				scroller.visible = false;
				return;
			}else{
				scroller.visible = true;
			}
			bp.height = height;
			bp.width = tar.compoWidth-2;
			bp.x = 1;
			bpMid.x = bp.x+(bp.width-bpMid.width)/2;
			bpMid.y = (bp.height-bpMid.height)/2;
			if(bp.width<10){
				bpMid.visible = false;
			}else{
				bpMid.visible = true;
			}
			if(shMask != null){
				shMask.graphics.clear();
				shMask.graphics.beginBitmapFill(bdMask,null,true,false);
				shMask.graphics.drawRect(0,0,tar.compoWidth,bpBG.height);
			}
			lastY = -50;
			setTimeout(showLater,100);
		}
		
	}
}