package cn.flashk.controls 
{
	import cn.flashk.controls.managers.DefaultStyle;
	import cn.flashk.controls.managers.SkinLoader;
	import cn.flashk.controls.managers.SkinManager;
	import cn.flashk.controls.managers.SourceSkinLinkDefine;
	import cn.flashk.controls.modeStyles.ButtonMode;
	import cn.flashk.controls.modeStyles.ButtonStyle;
	import cn.flashk.controls.skin.ActionDrawSkin;
	import cn.flashk.controls.skin.CheckBoxSkin;
	import cn.flashk.controls.skin.sourceSkin.CheckBoxSourceSkin;
	
	import flash.text.TextFormatAlign;
	
	/**
	 * CheckBox 组件显示一个小方框，该方框内可以有选中标记。 CheckBox 组件还可以显示可选的文本标。
	 * 
	 * <p>CheckBox 组件为响应鼠标单击将更改其状态，或者从选中状态变为取消选中状态，或者从取消选中状态变为选中状态。 CheckBox 组件包含一组非相互排斥的 true 或 false 值。</p>
	 *  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.support.UIComponent
	 * 
	 * @author flashk
	 */
	public class CheckBox extends ToggleButton
	{
		public static var allDefaultHeight:int = 19;
		
		public function CheckBox(skinLinkage:String="",asSkinClass:Class=null) 
		{
			_skinLinkage = skinLinkage;
			if(skinLinkage == ""){
				_skinLinkage = SourceSkinLinkDefine.CHECK_BOX;
			}
			_asSkinClass = asSkinClass;
			if(asSkinClass == null){
				_asSkinClass = CheckBoxSkin;
			}
			_isInitSkin = true;
			super();
			_compoHeight = allDefaultHeight;
			setSize(_compoWidth,_compoHeight);
			label = "多选";
			styleSet[ ButtonStyle.TEXT_COLOR ] = DefaultStyle.checkBoxTextColor;
			styleSet[ ButtonStyle.TEXT_OVER_COLOR ] = DefaultStyle.checkBoxTextOverColor;
			styleSet[ ButtonStyle.TEXT_DOWN_COLOR ] = DefaultStyle.checkBoxTextColor;
			initTextColor();
			tf.align = TextFormatAlign.LEFT;
			txt.setTextFormat(tf)
		}
		
		override public function setDefaultSkin():void 
		{
			setSkin(_asSkinClass);
		}
		
		override public function setSourceSkin():void 
		{
			setSkin(SkinLoader.getClassFromSkinFile(_skinLinkage));
		}
		
		override public function setSkin(Skin:Class):void 
		{
			if(SkinManager.isUseDefaultSkin == true)
			{
				skin = new Skin();
				ActionDrawSkin(skin).init(this,styleSet);
			}else
			{
				var sous:CheckBoxSourceSkin = new CheckBoxSourceSkin();
				sous.init(this,styleSet,Skin);
				skin = sous;
			}
		}
		
		override public function updateSkin():void 
		{
			super.updateSkin();
			styleSet[ ButtonStyle.TEXT_COLOR ] = DefaultStyle.checkBoxTextColor;
			styleSet[ ButtonStyle.TEXT_OVER_COLOR ] = DefaultStyle.checkBoxTextOverColor;
			styleSet[ ButtonStyle.TEXT_DOWN_COLOR ] = DefaultStyle.checkBoxTextColor;
			initTextColor();
		}
		
		override public function set label(value:String):void
		{
			super.label = value;
			txt.width = txt.textWidth + 10;
		}
		
		override public function setSize(newWidth:Number, newHeight:Number):void
		{
			super.setSize(newWidth, newHeight);
			if (_mode == ButtonMode.JUST_ICON) {
				iconBD.x = int((_compoWidth - iconBD.width) / 2)+1;
			}else{
				txt.width = _compoWidth -16;
				txt.x = 17;
				txt.y = int((_compoHeight - txt.height) / 2);
				txt.y = txt.y + DefaultStyle.fontExcursion;
			}
		}
		
	}
}