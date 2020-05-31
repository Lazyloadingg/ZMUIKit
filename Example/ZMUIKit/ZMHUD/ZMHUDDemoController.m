//
//  ZMHUDDemoController.m
//  ZMUIKit_Example
//
//  Created by Lazyloading on 2020/5/31.
//  Copyright © 2020 lazyloading@163.com. All rights reserved.
//

#import "ZMHUDDemoController.h"
#import <ZMUIKit.h>

@interface ZMHUDDemoController ()

@end

@implementation ZMHUDDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}

#pragma mark >_<! 👉🏻 🐷 Life cycle 🐷
#pragma mark >_<! 👉🏻 🐷 Delegate 🐷
#pragma mark >_<! 👉🏻 🐷 Event  Response 🐷
-(void)btn1Action:(UIButton *)btn{
    [ZMHud showTipHUD:@"白日依山尽,黄河入海流"];
    self.statusBarStyle = 0;
}
-(void)btn2Action:(UIButton *)btn{
    [ZMHud showErrorImageMessage:@"错误信息"];
    self.statusBarStyle = 1;
}
-(void)btn3Action:(UIButton *)btn{
    [ZMHud showCycleTip:@"白日依山尽,黄河入海流........." onView:self.navigationController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZMHud hideHUDForView:self.navigationController.view animated:YES];
    });
}
-(void)btn4Action:(UIButton *)btn{
    [ZMHud showCycleOnView:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZMHud hide];
    });
}
-(void)btn5Action:(UIButton *)btn{
    [ZMHud showCycleTip:@"等两秒" onView:self.view minTime:2.0];
    //设置最小停留时间后即使立马调用显示方法仍旧显示
    [ZMHud hide];
}
-(void)btn6Action:(UIButton *)btn{
    [ZMHud showCycleOnView:self.view minTimer:2.0];
    [ZMHud hide];
}
-(void)btn7Action:(UIButton *)btn{
    [ZMHud showSuccessMessage:@"成功"];
}
-(void)btn8Action:(UIButton *)btn{
    [ZMHud showErrorMessage:@"错误"];
}
#pragma mark >_<! 👉🏻 🐷 Private Methods 🐷
#pragma mark >_<! 👉🏻 🐷 Setter && Getter 🐷
#pragma mark >_<! 👉🏻 🐷 Default Config🐷

-(void)loadDefaultsSetting{
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)initSubViews{
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(80, 100, 80, 35)];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"文本" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn1.zm_bottom + 20, 80, 35)];
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"错误图片" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn2.zm_bottom + 20, 100, 35)];
    btn3.backgroundColor = [UIColor grayColor];
    [btn3 setTitle:@"转圈+文字" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton * btn4 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn3.zm_bottom + 20, 80, 35)];
    btn4.backgroundColor = [UIColor grayColor];
    [btn4 setTitle:@"转圈" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton * btn5 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn4.zm_bottom + 20, 130, 35)];
    btn5.backgroundColor = [UIColor grayColor];
    [btn5 setTitle:@"指定时间" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(btn5Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton * btn6 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn5.zm_bottom + 20, 180, 35)];
    btn6.backgroundColor = [UIColor grayColor];
    [btn6 setTitle:@"指定时间不带文字" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(btn6Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    
    //
    UIButton * btn7 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn6.zm_bottom + 20, 180, 35)];
    btn7.backgroundColor = [UIColor grayColor];
    [btn7 setTitle:@"新-成功" forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(btn7Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn7];
    
    UIButton * btn8 = [[UIButton alloc]initWithFrame:CGRectMake(80, btn7.zm_bottom + 20, 180, 35)];
    btn8.backgroundColor = [UIColor grayColor];
    [btn8 setTitle:@"新-错误" forState:UIControlStateNormal];
    [btn8 addTarget:self action:@selector(btn8Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn8];
}
-(void)layout{
    
}

@end
