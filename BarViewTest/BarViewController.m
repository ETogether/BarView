//
//  BarViewController.m
//  BarViewTest
//
//  Created by Sougu on 2018/11/7.
//  Copyright © 2018年 sg. All rights reserved.
//

#import "BarViewController.h"

#import "BarView.h"

#define RamdomRGB [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface BarViewController ()

@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds))];
    content.backgroundColor = RamdomRGB;
    [self.view addSubview:content];
    NSArray *imgs = @[@"govcar_apply", @"govcar_order", @"govcar_cost", @"govcar_comp_info"];
    NSArray *titles = @[@"标题1", @"标题2", @"标题3", @"标题3"];
    int i = 0;
    CGFloat h = 60;
    CGFloat pad = 20;
    CGFloat contentW = CGRectGetWidth(content.frame);
    for (; i < imgs.count; i++) {
        CGRect rect = CGRectMake(0, 20 + (i * (h + pad)), contentW, h);
        BarViewStyle style;
        if (i==0) {
            style = BarViewStyleDefault;
        }else{
            style = BarViewStyleText;
        }
        BarView *bar = [BarView barWithFrame:rect LogoName:imgs[i] LeftText:titles[i] RightText:nil NextImage:YES Style:style LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
            
        } EventBlock:^(id rightView) {
            
        }];
        bar.separatorInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        bar.isBarEvent = NO;
        [content addSubview:bar];
        
    }
    
    
    BarView *imgBar = [BarView barWithFrame:CGRectMake(0, (i + 1) * (h + pad), contentW, h) LogoName:nil LeftText:@"右图" RightText:imgs[0] NextImage:YES Style:BarViewStyleImage LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    
    [content addSubview:imgBar];
    
    BarView *imgBar1 = [BarView barWithFrame:CGRectMake(0, CGRectGetMaxY(imgBar.frame), contentW, h) LogoName:nil LeftText:@"右图" RightText:imgs[1] NextImage:YES Style:BarViewStyleImage LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    imgBar1.isBarEvent = YES;
    [content addSubview:imgBar1];
    
    BarView *inputBar = [BarView barWithFrame:CGRectMake(0, CGRectGetMaxY(imgBar1.frame), contentW, h) LogoName:nil LeftText:@"右输入框" RightText:@"请输入内容" NextImage:YES Style:BarViewStyleInput LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    
    [content addSubview:inputBar];
    
    BarView *inputBar1 = [BarView barWithFrame:CGRectMake(0, CGRectGetMaxY(inputBar.frame), contentW, h) LogoName:nil LeftText:@"右输入框" RightText:@"要输入内容" NextImage:YES Style:BarViewStyleInput LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    inputBar1.isBarEvent = YES;
    [content addSubview:inputBar1];
    
    BarView *defBar = [BarView barWithFrame:CGRectMake(0, CGRectGetMaxY(inputBar1.frame) + 20, contentW, h) LogoName:nil LeftText:@"右文本" RightText:@"" NextImage:YES Style:BarViewStyleDefault LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    //    inputBar1.isBarEvent = YES;
    [content addSubview:defBar];
    
    BarView *defBar1 = [BarView barWithFrame:CGRectMake(0, CGRectGetMaxY(defBar.frame) + 20, contentW, h) LogoName:nil LeftText:@"右文本" RightText:@"" NextImage:YES Style:BarViewStyleDefault LayoutBlock:^(UILabel *leftLbl, id rightView, BarView *selfBar) {
        
    } EventBlock:^(id rightView) {
        
    }];
    defBar1.isBarEvent = YES;
    [content addSubview:defBar1];
    
    
    
    content.contentSize = CGSizeMake(CGRectGetWidth(content.frame), CGRectGetMaxY(defBar1.frame) + 20);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
