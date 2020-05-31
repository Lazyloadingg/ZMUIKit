//
//  UINavigationController+ZMExtension.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 导航 content
 
 - DYNavigationBarStyleDefault: 深色内容，用于浅色背景
 - DYNavigationBarStyleLightContent: 浅色内容，用于深色背景
 */
typedef NS_ENUM(NSUInteger, DYNavigationBarStyle) {
    DYNavigationBarStyleDefault,
    DYNavigationBarStyleLightContent,
};

@interface UINavigationController (ZMExtension)

/** statusBarStyle  */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/*! 导航 content  */
@property (nonatomic, assign) DYNavigationBarStyle zm_navigationBarStyle;

/**
 修改导航栏背景颜色
 
 @param color 颜色
 */
-(void)zm_setNavigationBarBackgroundColor:(UIColor *)color;

/**
 修改导航栏颜色 字体
 
 @param color 颜色
 @param font 字体
 */
-(void)zm_setNavigationTextColor:(UIColor *)color font:(UIFont *)font;

/**
 修改导航栏文字颜色
 
 @param color 颜色
 */
-(void)zm_setNavigationTextColor:(UIColor *)color;

/**
 修改导航栏字体
 
 @param font 字体
 */
-(void)zm_setNavigationTextFont:(UIFont *)font;

/**
 隐藏导航栏底部线条

 @param hidden YES 隐藏，NO 不隐藏
 */
-(void)zm_setHiddenShadowImage:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
