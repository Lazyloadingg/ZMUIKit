//
//  ZMTabbarController.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "ZMTabBarController.h"
#import <ZMUIKit/ZMUIKit.h>
#import "ZMTabbar.h"

@interface ZMTabbarController ()

@end

@implementation ZMTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        object_setClass(self.tabBar, [ZMTabbar class]);
    }
    [self.tabBar zm_setDirectionBorder:DYDirectionBorderTop borderWidth:kPixelScale(1) borderColor:[[UIColor colorWithHexString:@"#DCDCDC"] colorWithAlphaComponent:0.8]];

}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event  Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
#pragma mark >_<! 👉🏻 🐷Default Setting / UI🐷
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //修改item文字/图标位置
    for (UITabBarItem * item in self.tabBar.items) {
        item.titlePositionAdjustment = UIOffsetMake(0, -3.5);
        //        item.imageInsets = UIEdgeInsetsMake(-4, 0, 1, 0);
    }
}

@end
