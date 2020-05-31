//
//  UINavigationController+ZMExtension.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/29.
//

#import "UINavigationController+ZMExtension.h"
#import <objc/runtime.h>
#import "UIColor+ZMExtension.h"
#import "UIImage+ZMExtension.h"

static char *kStatusBarStyle = "kStatusBarStyle";
static char *kNavigationBarStyle = "kNavigationBarStyle";

@implementation UINavigationController (ZMExtension)

-(void)zm_setNavigationBarBackgroundColor:(UIColor *)color{
    if (!color) {
        return;
    }
    CGFloat  r = 0 , g = 0 , b = 0 , a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }else{
        const CGFloat *component = CGColorGetComponents(color.CGColor);
        r = component[0];
        g = component[1];
        b = component[2];
        a = component[3];
    }
    [self.navigationBar setBackgroundImage:[UIImage zm_createImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    if (a <= 0.5 || CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor)) {
        [self.navigationBar setShadowImage:[UIImage new]];
    }else{
        [self.navigationBar setShadowImage:nil];
    }
}
-(void)zm_setNavigationTextColor:(UIColor *)color font:(UIFont *)font{
    if (!color && !font) {
        return;
    }
    if (color) {
        [self zm_setNavigationTextColor:color];
    }
    
    if (font) {
        [self zm_setNavigationTextFont:font];
    }
}
-(void)zm_setNavigationTextColor:(UIColor *)color{
    if (!color) {
        return;
    }
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
}
-(void)zm_setNavigationTextFont:(UIFont *)font{
    if (!font) {
        return;
    }
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : font}];
}
-(void)zm_setHiddenShadowImage:(BOOL)hidden{
    if (hidden) {
        [self.navigationBar setShadowImage:[UIImage new]];
    }else{
        [self.navigationBar setShadowImage:nil];
    }
}
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    NSNumber * value = [NSNumber numberWithInteger:statusBarStyle];
    objc_setAssociatedObject(self, &kStatusBarStyle, value, OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)statusBarStyle{
    NSNumber * value = objc_getAssociatedObject(self, &kStatusBarStyle);
    return value.integerValue;
}

- (void)setzm_navigationBarStyle:(DYNavigationBarStyle)zm_navigationBarStyle {
    NSNumber * value = [NSNumber numberWithInteger:zm_navigationBarStyle];
    [self.childViewControllers.lastObject setStatusBarStyle:(UIStatusBarStyle)zm_navigationBarStyle];
    switch (zm_navigationBarStyle) {
        case DYNavigationBarStyleLightContent:
        {
            [self zm_setNavigationTextColor:[UIColor whiteColor]];
        }
            break;
            
        default:
        {
            [self zm_setNavigationTextColor:[UIColor colorC5]];
        }
            break;
    }
    UIButton *btn = self.topViewController.navigationItem.leftBarButtonItem.customView;
    if([btn isKindOfClass:[UIButton class]]){
          if (btn) {
              btn.selected = (BOOL)zm_navigationBarStyle;
          }
      }
    
    objc_setAssociatedObject(self, &kNavigationBarStyle, value, OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (DYNavigationBarStyle)zm_navigationBarStyle {
    NSNumber * value = objc_getAssociatedObject(self, &kNavigationBarStyle);
    return value.integerValue;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
