# BarView
Bar条多种样式布局，也提供layoutBlock进制自定义布局。相关事件的回调。
具体可下载本demo查看事例。提供了一个 类方法和实例方法。

创建可以使用类方法或实例方法
/ **
 类方法
 
 @param frame           Bar的坐标 大小
 @param lName           Logo图标  nil或为@"" 不创建
 @param lText           标题内容
 @param rText           右边文字 为nil无值 style: input时(UITextField)，为提示文字 image(UIButton)，为图片名称，如果图片有两种状态，就直接传图片名称用and“&”拼接
 @param style           默认为lbl;图片 输入框
 @param have            是否有下一级的图片（箭头）
 @param layoutBlock     布局的回调，如不需要重新布局可为nil
 @param eventBlock      事件回调返回当前右视图(UILabel、UIButton、UITextField)
 @return 当前类的对象
 */
+ (instancetype)barWithFrame:(CGRect)frame LogoName:(NSString *)lName LeftText:(NSString *)lText RightText:(NSString *)rText NextImage:(BOOL)have Style:(BarViewStyle)style LayoutBlock:(LayoutBlock)layoutBlock  EventBlock:(RightEventBlock)eventBlock;

酒吧基本样式：
左标志+左标题+右含量（根据样式类型：右文本右图片右输入框）接着图片分割线


视图主要样式
typedef NS_ENUM（NSUInteger，BarViewStyle）{
  BarViewStyleDefault = 0,  //默认左一个Lbl bar有点击事件
  BarViewStyleText,         //右一个文本，有点击事件
  BarViewStyleInput,        //rightText为默认文字
  BarViewStyleImage,        //rightText图片名称
//  BarViewStyle,
};

设置分割线：
分割线位置上下左右无五种
typedef NS_ENUM（NSUInteger，BarViewSeparatorStyle）{
  BarViewSeparatorStyleDefault = 0,//默认为底部
  BarViewSeparatorStyleTop,
  BarViewSeparatorStyleLeft,
  BarViewSeparatorStyleRight,
  BarViewSeparatorStyleNone,
};

///分割线位置
@property (nonatomic,assign) BarViewSeparatorStyle separatorStyle;


///分割线缩进
@property (nonatomic,assign) UIEdgeInsets separatorInsets;

///分割线颜色;

@property（非原子，强，非空）UIColor * separatorColor;

///设置整个bar事件回调 默认为NO  但bar样式为默认样式时，此为yes
@property (nonatomic,assign) BOOL isBarEvent;
