//
//  DYNavigation.m
//  DYNavigation
//
//  Created by vincent on 2017/8/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "ZMNavigationManager.h"
#import <objc/runtime.h>
#import "sys/utsname.h"
#import "UIViewController+ZMExtension.h"
static char kdyStatusBarHiddenKey;                 // 当前状态栏是否隐藏
@implementation ZMNavigationManager
/// 设置整体导航条背景颜色 调用此方法必须在appDelegate才可以
/// @param color 颜色
- (void)zm_setNavBarBackgroundColor:(UIColor *)color {
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
}
@end
@interface UIViewController ()

@end

@implementation UIViewController (DYNavigation)
// runtime
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -> 交换方法
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:),
            @selector(viewDidAppear:),
            @selector(viewDidDisappear:)
        };
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"zm_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
// 交换方法 - 将要出现
- (void)zm_viewWillAppear:(BOOL)animated {

}
// 交换方法 - 已经出现
- (void)zm_viewDidAppear:(BOOL)animated {
}
// 交换方法 - 将要消失
- (void)zm_viewWillDisappear:(BOOL)animated {
}
// 交换方法 - 已经消失
- (void)zm_viewDidDisappear:(BOOL)animated {
}



/// 是否隐藏黑线
/// @param isFlag  false显示 true 隐藏
-(void) zm_setNavBarShadowImageHidden:(BOOL) isFlag{
    self.hbd_barShadowHidden = isFlag;
    [self hbd_setNeedsUpdateNavigationBar];
}
/** 1.设置当前导航栏的背景View*/
- (void)zm_setNavBarBackgroundView:(UIView *)view {
   
}
/** 3.设置当前导航栏 barTintColor(导航栏背景颜色)*/
- (void)zm_setNavBarBackgroundColor:(UIColor *)color {
    self.hbd_barTintColor = color;
    [self hbd_setNeedsUpdateNavigationBar];
}

/**
 设置当前导航栏的透明度。需要 translucent = YES

 @param alpha 0-1
 */
- (void)zm_setNavBarBackgroundAlpha:(CGFloat)alpha{
    self.hbd_barAlpha = alpha;
    [self hbd_setNeedsUpdateNavigationBar];

}
/**
  设置导航条背景颜色

 @param alpha 0-1
 */
- (void)zm_setNavBarBackgroundColor:(UIColor *) color alpha:(CGFloat)alpha{
     self.hbd_barTintColor = color;
     self.hbd_barAlpha = alpha;
    [self hbd_setNeedsUpdateNavigationBar];

}
/**
 设置当前导航栏 titleColor(标题颜色)

 @param color 颜色
 */
- (void)zm_setNavBarTitleColor:(UIColor *)color{
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [color colorWithAlphaComponent:1] };
    [self hbd_setNeedsUpdateNavigationBar];
}
/**
设置当前导航栏 titleColor(标题颜色)

@param color 颜色
*/
- (void)zm_setDefaultNavBarTitleColor:(UIColor *)color{
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [color colorWithAlphaComponent:1] };
      [self hbd_setNeedsUpdateNavigationBar];
}
/**
 设置当前导航栏 titleColor(标题颜色)

 @param color 颜色
 */
- (void)zm_setNavBarTitleColor:(UIColor *)color alpha:(CGFloat) alpha{
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [color  colorWithAlphaComponent:alpha] };
    [self hbd_setNeedsUpdateNavigationBar];
}


/// 更改导航条箭头颜色
/// @param color 颜色
-(void)zm_setNavBarTintColor:(UIColor *) color{
    self.hbd_tintColor = color;
}

- (void)hbd_setNeedsUpdateNavigationBar {
    if (self.navigationController && [self.navigationController isKindOfClass:[ZMNavigationController class]]) {
        ZMNavigationController *nav = (ZMNavigationController *)self.navigationController;
        [nav updateNavigationBarForViewController:self];
    }
}

/** 设置当前状态栏是否隐藏,默认为NO*/
- (void)zm_setStatusBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kdyStatusBarHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate]; // 刷新状态栏
}
@end
