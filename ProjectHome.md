Flex已经不作为Adobe官方支持了，CS的组件又太少。而aswing，过于复杂难用了些，而且对于我等非java程序员转过来的看着头大。所以放出这个造福广大苦逼游戏程序员。

纯粹个人作品，与公司无关。所以可以放心的在任何个人/非商业/商业项目中使用。不会引起版权问题/纠纷。但本人不对因代码bug引起的任何问题负责（组件没有经过全面测试，可能会有bug）。


此组件当初设计是为了和aswing走不同路线，希望能找到最贴合于flash独有的方式。java swing那套我实在是不感冒。也认为swing不适合作为轻客户端UI。过于麻烦和不灵活，性能也同样不够。所以此组件设计之初就以高性能和构建灵活UI（如特殊2D UI）为目标。既然aswing是照swing的，我这套基本参照CS和Flex的API，尽量接近。也尽量不使用AS代码来布局界面和创建界面。对于不是java程序员比较习惯些。组件当初设计是为了达到两个目的：高性能和很好的用户体验，希望我做到了。当然也会有不完善的地方。


此组件可以很方便的和原生Flash DiaplayObject贴合以构建不同类型的特殊/非特殊UI。也很容易被扩展和二次开发。


可以使用纯AS和FlashCS皮肤。皮肤单独一个fla文件。代码我尽量简洁。swf文件总共会增加94kb。布局使用cn.flashk.controls.layout.Align。不是标准MVC模式，但组件的显示和皮肤控制我全部抽离放在cn.flashk.controls.skin包中方便修改或者全部替换以整成自己独特的样式。

可以方便的对Button,Checkbox,Slider,Radiobutton,List,Combobox,TileList,DataGrid使用同个皮肤文件的不同皮肤。并且可以方便的定义List,TileList,DataGrid的单元格渲染器。

此组件框架使用FlashCS作为界面布局和编辑器以创建更为直观和灵活的界面，并使用一个UI AutoBuild自动完成界面的构建。

整个UI库编译后文件<100K


包含下列组件：
Accordion、Alert、Button、CheckBox、ClickAbleAlphaBitmap、ColorPickerPanel、ComboBox、DataGrid、EmptyUISprite、GraphicSkinButton、HScrollBar、Image、Label、LinkText、List、Menu、MenuBar、NumericStepper、Panel、ProgressBar、RadioButton、ScrollPane、Slider、TabBar、Text、TextArea、TextInput、TileList、ToggleButton、ToolRadioButton、ToolTip、DoubleDeckTree、Tree、VScrollBar、PopMenu、Window、BitmapText、GraphicSkinButton

并包含一些常用的UI界面辅助类。

使用此组件开发的项目可以参见酷狗派对： http://ktv.kugou.com


此UI可以与starling/away3d等stage3D技术一起协作作为2D UI界面。


FlashK2DBlit\_1.0\_beta是一个2D的简易地图blit引擎，可与UI框架一同配合完成高性能的2D多人同屏游戏开发。


附：由于本人小孩出生的关系，需要更多的时间照顾和陪伴小孩，已没有精力再维护此项目。FlashkUI\_v1.3.3\_for\_mobile\_beta/flashk\_ui\_v1.3.2\_mini\_final\_release是最后一个版本（推荐使用此版本）此组件将不再更新和维护，请自行在此版本上修改或扩展代码。