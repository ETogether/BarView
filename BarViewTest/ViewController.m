//
//  ViewController.m
//  BarViewTest
//
//  Created by Sougu on 2018/11/7.
//  Copyright © 2018年 sg. All rights reserved.
//

#import "ViewController.h"

#import "BarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 60);
    btn.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2 - 120);
    [btn setTitle:@"BarViewTest" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    [<#btn#> setImage:[[UIImage imageNamed:<#@""#>] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    btn.tag = 100;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    const CGFloat *components = CGColorGetComponents([UIColor orangeColor].CGColor);
//    CGFloat sub = 0.1;
    CGFloat r = components[0] ;
    CGFloat g = components[1] ;
    CGFloat b = components[2] ;
    
//    r = r > 0 ? r : 1 + r;
//    g = g > 0 ? g : 1 + g;
//    b = b > 0 ? b : 1 + b;
    btn.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.65];
    
}

#pragma mark - 按钮事件
-(void)btnClick:(UIButton *)btn{
    //    SGLog(@"Title=%@,tag=%ld",btn.currentTitle,(long)btn.tag);
    NSInteger tag = btn.tag - 100;
    switch (tag) {
        case 0:{
            //下一页
            BarViewController *bar = [[BarViewController alloc] init];
            bar.title = @"Bar使用";
            [self.navigationController pushViewController:bar animated:YES];
        }break;
            //        case <#1#>:{
            //            //<#hnit#>
            //            <#code#>
            //        }break;
            //        case <#2#>:{
            //            //<#hnit#>
            //            <#code#>
            //        }break;
        default:
            break;
    }
}


@end
