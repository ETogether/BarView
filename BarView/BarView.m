//
//  BarView.m
//  即时通讯
//
//  Created by huitouke on 2018/6/9.
//  Copyright © 2018年 huitouke. All rights reserved.
//

///选择条：左边提示文字 右边选择“按钮”

#import "BarView.h"

#ifdef DEBUG
#define BARLog(FORMAT, ...) fprintf(stderr,"<%s%s %s  %d>\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __func__, __TIME__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define BARLog(FORMAT, ...) nil
#endif

#define BARHEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define BARPXTOWIDTH(x) ([UIScreen mainScreen].bounds.size.height * x / 2 / 375.0)

@interface BarView()<UITextFieldDelegate>{
    NSString *logoName;
    NSString *leftText;
    NSString *rightText;
    BarViewStyle viewStyle;
    BOOL haveNextImage;
    ///重新布局的block
    LayoutBlock resetBlock;
    RightEventBlock rightBlock;//右文本block
}
//左部视图
///bar logo
@property (nonatomic,strong) UIImageView *logo;
///标题
@property (nonatomic,strong) UILabel *leftLbl;

//右部视图
///右lbl
@property (nonatomic,strong) UILabel *rightLbl;
///右按钮-图片
@property (nonatomic,strong) UIButton *rightBtn;
///右输入框
@property (nonatomic,strong) UITextField *rightTF;
///右图片
@property (nonatomic,strong) UIImageView *nextImg;

///分割线
@property (nonatomic,strong) UIView *separator;
///是否有分割线，在分割线style设置为None时 为true
@property (nonatomic,assign) BOOL noSeparator;



@end

@implementation BarView
#pragma mark - getter方法

//左部分
- (UIImageView *)logo{
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoName]];
//        _logo.image = ;
        [self addSubview:_logo];
    }
    return _logo;
}
///标题
-(UILabel *)leftLbl{
    if (!_leftLbl) {
        ///标题
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.text = leftText;
        _leftLbl.textColor = BARHEXCOLOR(0x606060);
        _leftLbl.font = [UIFont systemFontOfSize:16.0];
        [_leftLbl sizeToFit];
        //    _leftLbl.frame = CGRectMake(HPAD, 0, _leftLbl.lyW, 21);
        //    _leftLbl.lyCY = self.lyCY -  self.lyY;
        [self addSubview:_leftLbl];
    }
    return _leftLbl;
}

///右部分
//右Label
-(UILabel *)rightLbl{
    if (!_rightLbl) {
        
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.userInteractionEnabled = YES;
        
        _rightLbl.text = rightText;
        _rightLbl.textColor = BARHEXCOLOR(0xd0d0d0);
        _rightLbl.textAlignment = NSTextAlignmentRight;
        _rightLbl.font = [UIFont systemFontOfSize:16.0];
        _rightLbl.numberOfLines = 0;
        
        //右文本添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGREvent:)];
        [_rightLbl addGestureRecognizer:tap];
        
        [self addSubview:_rightLbl];
    }
    return _rightLbl;
}

//右按钮
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *normalStr = rightText;
        if ([rightText containsString:@"&"]) {
            NSArray *imgs = [rightText componentsSeparatedByString:@"&"];
            normalStr = imgs[0];
            //选中
            [_rightBtn setImage:[[UIImage imageNamed:imgs[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        }
        //正常
        [_rightBtn setImage:[[UIImage imageNamed:normalStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _rightBtn.tag = 520;
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

-(UITextField *)rightTF{
    if (!_rightTF) {

        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:16.0];
        _rightTF.returnKeyType = UIReturnKeyDone;
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.placeholder = rightText;
        _rightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rightTF.delegate = self;
//        //键盘添加完成按钮
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, Screen_Width, 40);
//        btn.backgroundColor = UIColorFromRGB(0xe)
//        [btn setTitle:@"完成" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.tag = 521;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, btn.lyW, 1)];
//        lineView.backgroundColor = [PubilcClass colorWithHexString:@"f3f3f3"];
//        [btn addSubview:lineView];
//        _rightTF.inputAccessoryView = btn;
        
        [self addSubview:_rightTF];
    }
    return _rightTF;
}


///图片 〉
-(UIImageView *)nextImg{
    if (!_nextImg && haveNextImage) {
        _nextImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_gray_next"]]; //@2x 20 * 20
//        _nextImg.frame = CGRectMake(self.lyW-HPAD-15, 0, 15, 15);
//        _nextImg.lyX = self.lyW - HPAD - _nextImg.lyW;
//        _nextImg.lyCY = self.lyCY - self.lyY;
        [self addSubview:_nextImg];
    }
    return _nextImg;
}

///分割线
-(UIView *)separator{
    if (!_separator && !_noSeparator) {
        _separator = [[UIView alloc] init];//WithFrame:CGRectMake(0, self.lyH-1, self.lyW, 1)
        _separator.backgroundColor = BARHEXCOLOR(0xd0d0d0);
        [self addSubview:_separator];
    }
    return _separator;
}

#pragma mark - setter方法
///设置分割线颜色
-(void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    self.separator.backgroundColor = separatorColor;
}
///设置分割线的位置
-(void)setSeparatorStyle:(BarViewSeparatorStyle)separatorStyle{
    _separatorStyle = separatorStyle;
}

///分割线的缩进
-(void)setSeparatorInsets:(UIEdgeInsets)separatorInsets{
    _separatorInsets = separatorInsets;
//    CGFloat top = separatorInsets.top;
//    CGFloat left = separatorInsets.left;
//    CGFloat bottom = separatorInsets.bottom;
//    CGFloat right = separatorInsets.right;
//    //宽高
//    CGSize size = self.separator.frame.size;
//    CGFloat w = size.width - (left + right);
//    CGFloat h = size.height - top + bottom;
//    //x y坐标
//    CGPoint origin = self.separator.frame.origin;
//    CGFloat x = origin.x + left;
//    CGFloat y = origin.y + top;
//
//    self.separator.frame = CGRectMake(x, y, w, h);
    
}

-(void)setIsBarEvent:(BOOL)isBarEvent{
    _isBarEvent = isBarEvent;
    
    if (_rightLbl) {
        _rightLbl.userInteractionEnabled = !_isBarEvent;
    }
    
    if (_rightBtn) {
        _rightBtn.userInteractionEnabled = !_isBarEvent;
    }
    
//    if (_rightTF) {
//        _rightTF.userInteractionEnabled = !_isBarEvent;
//    }
    
    if (isBarEvent) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRBarEvent:)];
        [self addGestureRecognizer:tap];
    }
}

#pragma mark - Private方法
///添加子视图
-(void)settingView{
    __weak typeof(self) selfWeak = self;
    
    if (logoName && ![logoName isEqualToString:@""]) {
        [self logo];
    }
    
    if (leftText && ![leftText isEqualToString:@""]) {
        [self leftLbl];
    }
    
    //添加右样式
    switch (viewStyle) {
        case BarViewStyleText:{
            [self rightLbl];
            if (resetBlock) {
                resetBlock(_leftLbl,self.rightLbl,selfWeak);
            }
        }break;
        case BarViewStyleImage:{
            [self rightBtn];
            if (resetBlock) {
                resetBlock(_leftLbl,self.rightBtn,selfWeak);
            }
        }break;
        case BarViewStyleInput:{
            [self rightTF];
            if (resetBlock) {
                resetBlock(_leftLbl,self.rightTF,selfWeak);
            }
        }break;
        default:
            self.isBarEvent = YES;
            break;
    }
    
    //向右箭头图片
    [self nextImg];
    
    //添加分割线
    [self separator];
    
}

//UI布局方法
- (void)layoutSubviews{
    CGFloat hPad = BARPXTOWIDTH(24);
    CGFloat contentPad = BARPXTOWIDTH(12);
    
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    CGFloat x = hPad;
    CGFloat w =  0;
    CGFloat h = 0;
    
    if (_logo) {
        w = _logo.frame.size.width;
        h = _logo.frame.size.height;
        CGFloat scale = w / h;
        CGFloat y = [self getOriginYWithHeight:h];
        if (h > selfH) {
            _logo.frame = CGRectMake(hPad, y, selfH * scale, selfH);
        }else{
            _logo.frame = CGRectMake(hPad, y, w, h);
        }
        x = CGRectGetMaxX(_logo.frame);
    }
    
    if (_leftLbl) {
        [_leftLbl sizeToFit];
        CGFloat y = [self getOriginYWithHeight:CGRectGetHeight(_leftLbl.bounds)];
        _leftLbl.frame = CGRectMake(x + contentPad, y, CGRectGetWidth(_leftLbl.bounds), CGRectGetHeight(_leftLbl.bounds));
        x = CGRectGetMaxX(_leftLbl.frame);
    }
    
    
    if (_nextImg) {
        CGFloat iW = CGRectGetWidth(_nextImg.frame);
        CGFloat iH = CGRectGetHeight(_nextImg.frame);
        
        CGFloat y = [self getOriginYWithHeight:iH];
        _nextImg.frame = CGRectMake(selfW - iW - hPad, y, iW, iH);
    }
    //右间隔 高 下一步按钮
    CGFloat rPad = haveNextImage ?  CGRectGetWidth(_nextImg.frame) + hPad : hPad;
    
    if (_rightLbl) {
        
        _rightLbl.frame = CGRectMake(x + contentPad, 0, selfW - x - hPad - rPad, selfH);
    }
    
    if (_rightTF) {
        
        _rightTF.frame = CGRectMake(x + contentPad, 0, selfW - x - hPad - rPad, selfH);
//        _rightTF.lyCY = self.lyCY - self.lyY;
        
    }
    
    if (_rightBtn) {
        [_rightBtn sizeToFit];
        CGFloat bW = CGRectGetWidth(_rightBtn.frame);
        CGFloat bH = CGRectGetHeight(_rightBtn.frame);
        
        CGFloat y = [self getOriginYWithHeight:bH];
        _rightBtn.frame = CGRectMake(selfW - rPad - bW, y, bW, bH);
    }
    
    switch (_separatorStyle) {
        case BarViewSeparatorStyleTop:{
            self.separator.frame = CGRectMake(0, 0, selfW, 1);
        }break;
        case BarViewSeparatorStyleLeft:{
            self.separator.frame = CGRectMake(0, 0, 1, selfH);
        }break;
        case BarViewSeparatorStyleRight:{
            self.separator.frame = CGRectMake( selfW - 1, 0, 1, selfH);
        }break;
        case BarViewSeparatorStyleNone:{
            _noSeparator = YES;//是没有分割线
            if (_separator) {
                [_separator removeFromSuperview];
                _separator = nil;
            }
        }break;
        default:
            self.separator.frame = CGRectMake(0, selfH - 1, selfW, 1);
            break;
    }
    
    if (_separator) {
        CGFloat top = _separatorInsets.top;
        CGFloat left = _separatorInsets.left;
        CGFloat bottom = _separatorInsets.bottom;
        CGFloat right = _separatorInsets.right;
        //宽高
        CGSize size = self.separator.frame.size;
        CGFloat w = size.width - (left + right);
        CGFloat h = size.height - top + bottom;
        //x y坐标
        CGPoint origin = self.separator.frame.origin;
        CGFloat x = origin.x + left;
        CGFloat y = origin.y + top;
        
        self.separator.frame = CGRectMake(x, y, w, h);

    }
    
}


/**
 获取位于父视图垂直居中的Y坐标

 @param height 视图高度
 @return 返回y坐标
 */
-(CGFloat)getOriginYWithHeight:(CGFloat)height{
    CGFloat selfH = self.frame.size.height;
    CGFloat y = 0;
    if (selfH > height) {
        y = (selfH - height) / 2;
    }
    return y;
}

#pragma mark - 事件方法
-(void)tapGRBarEvent:(UITapGestureRecognizer *)tap{
    BARLog(@"Bar点击了");
    if (!_isBarEvent) {
        //当默认Style 外面设置isBarEvent=NO时，bar点击事件需要移除 不过会触发该
        [self removeGestureRecognizer:tap];
        return;
    }
    if (rightBlock) {
        if (_rightLbl) {
            rightBlock(_rightLbl);
        }else if (_rightBtn){
            rightBlock(_rightBtn);
        }else if (_rightBtn){
            rightBlock(_rightTF);
        }else{
            rightBlock(nil);
        }
    }
}

-(void)tapGREvent:(UITapGestureRecognizer*)tap{
    BARLog(@"右文本点击了");
    if (rightBlock) {
        rightBlock(_rightLbl);
    }
}
-(void)btnClick:(UIButton *)btn{
    BARLog(@"右按钮点击了Title:%@",btn.currentTitle);
    NSInteger tag = btn.tag;
    if (tag==521) {//键盘完成按钮
        [_rightTF resignFirstResponder];
        if (rightBlock) {
            rightBlock(_rightTF);
        }
    }else{
        if ([rightText containsString:@"&"]) {//表示按钮时 有正常 选中状态
            btn.selected = !btn.selected;
        }
        //图片样式按钮事件
        if (rightBlock) {
            rightBlock(btn);
        }
    }
    
}

#pragma mark - Public方法
-(instancetype)initWithFrame:(CGRect)frame LogoName:(NSString *)lName LeftText:(NSString *)lText RightText:(NSString *)rText NextImage:(BOOL)have Style:(BarViewStyle)style LayoutBlock:(LayoutBlock)layoutBlock EventBlock:(RightEventBlock)eventBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        logoName = lName;
        leftText = lText;
        haveNextImage = have;
        rightText = rText;
        viewStyle = style;
        resetBlock = layoutBlock;
        rightBlock = eventBlock;
        [self settingView];
    }
    return self;
}

+(instancetype)barWithFrame:(CGRect)frame LogoName:(NSString *)lName LeftText:(NSString *)lText RightText:(NSString *)rText NextImage:(BOOL)have Style:(BarViewStyle)style LayoutBlock:(LayoutBlock)layoutBlock EventBlock:(RightEventBlock)eventBlock{
    BarView *bar = [[BarView alloc] initWithFrame:frame LogoName:lName LeftText:lText RightText:rText NextImage:have Style:style LayoutBlock:layoutBlock EventBlock:eventBlock];
    
    return bar;
}

-(void)setTitleTagColor:(UIColor *)tagColor TagText:(NSString *)tagText{
    NSMutableString *mutaStr = [NSMutableString stringWithString:_leftLbl.text];
    NSRange range = [mutaStr rangeOfString:tagText];
    NSMutableAttributedString *mutaAtt = [[NSMutableAttributedString alloc] initWithString:_leftLbl.text];
    [mutaAtt addAttributes:@{NSForegroundColorAttributeName:tagColor} range:range];
    _leftLbl.attributedText = mutaAtt;
}


//************>>>>>>>>>>>代理方法
#pragma mark - UITextField方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    BARLog(@"return");
//    textField.text = [NSString stringWithFormat:@"%@\n",textField.text];//拼接换行符
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    BARLog(@"ShouldClear");
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    BARLog(@"DidgeginEditing");
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BARLog(@"输入的内容：%@",string);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (rightBlock) {
        rightBlock(textField);
    }
}

@end
