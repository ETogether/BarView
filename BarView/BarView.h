//
//BarView.h
//  即时通讯
//
//  Created by huitouke on 2018/6/9.
//  Copyright © 2018年 huitouke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarView;

///布局回调 - 可以重新设置ui
typedef void(^LayoutBlock)(UILabel *leftLbl,id rightView,BarView *selfBar);

///右事件回调
typedef void(^RightEventBlock)(id rightView);

//枚举两种写法

//typedef enum : NSUInteger {
//  BarViewStyleDefault = 0,  //默认右一个文本，有点击事件
//  BarViewStyleInput,
//  BarViewStyleImage,
////  BarViewStyleRight,
//} ChooseBarViewStyle;

/**
 视图样式 -- 主要设置右边添加什么样的视图
 - BarViewStyleDefault = 0,  //默认左一个Lbl bar有点击事件
 - BarViewStyleText: 右边一个文本，并有点击事件
 - BarViewStyleInput: 右边一个textView
 - BarViewStyleImage: 右边一个按钮
 */
typedef NS_ENUM(NSUInteger,BarViewStyle){
  BarViewStyleDefault = 0,  //默认左一个Lbl bar有点击事件
  BarViewStyleText,         //右一个文本，有点击事件
  BarViewStyleInput,        //rightText为默认文字
  BarViewStyleImage,        //rightText图片名称
//  BarViewStyle,
};

/**
 分割线样式 -- 位置

 - ChooseBarViewSeparatorStyleDefault:      底部
 — ChooseBarViewSeparatorStyleTop:          顶部
 - ChooseBarViewSeparatorStyleLeft:         左边
 - ChooseBarViewSeparatorStyleRight:        右边
 - ChooseBarViewSeparatorStyleNone:         无分割线
 */
typedef NS_ENUM(NSUInteger,BarViewSeparatorStyle){
  BarViewSeparatorStyleDefault = 0,//默认为底部
  BarViewSeparatorStyleTop,
  BarViewSeparatorStyleLeft,
  BarViewSeparatorStyleRight,
  BarViewSeparatorStyleNone,
};

@interface BarView : UIView




///分割线颜色
@property (nonatomic,strong,nonnull) UIColor *separatorColor;
///分割线位置
@property (nonatomic,assign) BarViewSeparatorStyle separatorStyle;
///分割线缩进
@property (nonatomic,assign) UIEdgeInsets separatorInsets;

///设置整个bar事件回调 默认为NO
@property (nonatomic,assign) BOOL isBarEvent;

#pragma mark - Public方法
/**
 初始化 - 实例方法

 @param frame           Bar的坐标 大小
 @param lName           Logo图标
 @param lText           标题内容
 @param rText           右边文字 为nil无值  style: input时(UITextField)，为提示文字 image(UIButton)，为图片名称，如果图片有两种状态，就直接传图片名称用and“&”拼接
 @param style           默认为lbl;图片 输入框
 @param have            是否有下一级的图片（箭头）
 @param layoutBlock     布局的回调，如不需要重新布局可为nil
 @param eventBlock      事件回调返回当前右视图(UILabel、UIButton、UITextField)
 @return 当前类的对象
 */
- (instancetype)initWithFrame:(CGRect)frame LogoName:(NSString *)lName LeftText:(NSString *)lText RightText:(NSString *)rText NextImage:(BOOL)have Style:(BarViewStyle)style LayoutBlock:(LayoutBlock)layoutBlock  EventBlock:(RightEventBlock)eventBlock;

/**
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

/**
 设置标题（leftLabel）

 @param tagColor 标记颜色
 @param tagText 标记的字符串(标题内容应包含该串)
 */
-(void)setTitleTagColor:(UIColor *)tagColor TagText:(NSString *)tagText;

@end
