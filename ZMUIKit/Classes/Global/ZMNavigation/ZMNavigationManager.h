//
//  DYNavigation.h
//  DYNavigation
//
//  Created by vincent on 2017/8/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DYNavigationBar.h"
#import <HBDNavigationBar/HBDNavigationBar.h>
#import "ZMNavigationController.h"
#import <HBDNavigationBar/UIViewController+HBD.h>

@interface ZMNavigationManager : NSObject

/// 设置整体导航条背景颜色 调用此方法必须在appDelegate才可以
/// @param color 颜色
- (void)zm_setNavBarBackgroundColor:(UIColor *)color;
@end

#pragma mark-
#pragma mark- >_<! 👉🏻 🐷UIViewController + DYNavigation🐷
@interface UIViewController (DYNavigation)


- (void)zm_setDefaultNavBarTitleColor:(UIColor *)color;
- (void)hbd_setNeedsUpdateNavigationBar;
/// 是否隐藏黑线
/// @param isFlag  false显示 true 隐藏
-(void) zm_setNavBarShadowImageHidden:(BOOL) isFlag;
/** 1.设置当前导航栏的背景View*/
- (void)zm_setNavBarBackgroundView:(UIView *)view;

/** 3.设置当前导航栏 barTintColor(导航栏背景颜色)*/
- (void)zm_setNavBarBackgroundColor:(UIColor *)color;

/**
 设置当前导航栏的透明度。需要 translucent = YES

 @param alpha 0-1
 */
- (void)zm_setNavBarBackgroundAlpha:(CGFloat)alpha;

/**
 设置导航条背景颜色

 @param alpha 0-1
 */
- (void)zm_setNavBarBackgroundColor:(UIColor *) color alpha:(CGFloat)alpha;
///// 更改状态栏样式
///// @param barStyle     UIBarStyleDefault   白色 UIBarStyleBlack  黑色
//-(void)zm_setNavStatusBarStyle:(UIBarStyle) barStyle;
/**
 设置当前导航栏 titleColor(标题颜色)

 @param color 颜色
 */
- (void)zm_setNavBarTitleColor:(UIColor *)color alpha:(CGFloat) alpha;
/**
 设置当前导航栏 titleColor(标题颜色)

 @param color 颜色
 */
- (void)zm_setNavBarTitleColor:(UIColor *)color;
/// 更改导航条箭头颜色
/// @param color 颜色
-(void)zm_setNavBarTintColor:(UIColor *) color;
/** 设置当前状态栏是否隐藏,默认为NO*/
- (void)zm_setStatusBarHidden:(BOOL)hidden;
@end
