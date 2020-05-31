//
//  ZMUtilities.h
//  Pods
//
//  Created by 王士昌 on 2019/7/8.
//

#ifndef ZMUtilities_h
#define ZMUtilities_h

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷 Header 🐷

#import "ZMDevice.h"
//#import <ZMResources/ZMResources.h>
#import "UIColor+ZMExtension.h"

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷 Macro 🐷

#define kScreen_width [UIScreen mainScreen].bounds.size.width
#define kScreen_height [UIScreen mainScreen].bounds.size.height

#ifdef DEBUG

#define ZMLog(fmt, ...) NSLog((@"%s [Line %d] 👉 " fmt), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, ##__VA_ARGS__)
#else
#define ZMLog(fmt, ...)

#endif


/**
 弱引用
 */
#define weakSelf(weakSelf)  __weak typeof(self) weakSelf = self;
#define strongSelf(strongSelf) __strong typeof(weakSelf) strongSelf = weakSelf;

/**
 block传参
 */
typedef void(^ZMCompleteObjectBlock)(_Nullable id);

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷 Inline 🐷
#if TARGET_IPHONE_SIMULATOR//模拟器

static inline BOOL kDeviceIsiPhoneX() {
    
    
    
    BOOL isPhoneX = NO;
    
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    
    return isPhoneX;
    
}

#elif TARGET_OS_IPHONE//真机
static inline BOOL kDeviceIsiPhoneX() {
    return [[ZMDevice deviceModel] isEqualToString:@"iPhone X"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone XS"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone XS Max"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone XR"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone 11"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone 11 Pro"] || [[ZMDevice deviceModel] isEqualToString:@"iPhone 11 Pro Max"];
}

#endif


static inline UIColor *kColorByRGB(CGFloat r,CGFloat g,CGFloat b) {
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
}

static inline UIImage *kImageNamed(NSString *name) {
    return [UIImage imageNamed:name];
}

static inline UIImage *kIconNamed(NSString *name) {
    return [UIImage imageNamed:name];
}


static inline UIColor *kColorByHex(NSString *hexStr) {
    return [UIColor colorWithHexString:hexStr];
}


/**
 像素规模

 @param pixe 像素
 @return 规模
 */
static inline CGFloat kPixelScale(CGFloat pixe) {
    return pixe/[UIScreen mainScreen].scale;
}

/**
 导航栏高度

 @return 高度
 */
static inline CGFloat kNavigationHeight(){
    return kDeviceIsiPhoneX() ? 88 : 64;
}

/**
 状态栏高度

 @return 高度
 */
static inline CGFloat kStatusBarHeight(){
    return kDeviceIsiPhoneX() ? 44 : 20;
}

/**
 选项卡高度

 @return 高度
 */
static inline CGFloat kTabbarHeight(){
    return kDeviceIsiPhoneX() ? 83 : 49;
}

/**
 底部安全区域高度

 @return 高度
 */
static inline CGFloat kSafeAreaBottomHeight(){
    return kDeviceIsiPhoneX() ? 34 : 0;
}

/**
 比例转换宽度

 @param width 设计宽度
 @return 实际宽度
 */
static inline CGFloat kScreenWidthRatio(CGFloat width) {
//    UIEdgeInsets safeEdge = UIEdgeInsetsZero;
//    if (@available(iOS 11.0, *)) {
//        safeEdge = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
//    }
//    if (CGRectGetHeight([UIScreen mainScreen].bounds) > CGRectGetWidth([UIScreen mainScreen].bounds)) {
//        return (CGRectGetWidth([UIScreen mainScreen].bounds) - safeEdge.left - safeEdge.right) / 375.0f * width;
//    }else {
//        return (CGRectGetWidth([UIScreen mainScreen].bounds)  - safeEdge.top - safeEdge.bottom) / 667.0 * width;
//    }
    CGFloat scale = width / 375;
    CGFloat result = kScreen_width * scale;
    return result;
}

/**
  比例转换高度

 @param height 设计高度
 @return 实际高度
 */
static inline CGFloat kScreenHeightRatio(CGFloat height) {
//    UIEdgeInsets safeEdge = UIEdgeInsetsZero;
//    if (@available(iOS 11.0, *)) {
//        safeEdge = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
//    }
//    if (CGRectGetHeight([UIScreen mainScreen].bounds) > CGRectGetWidth([UIScreen mainScreen].bounds)) {
//
//        return (CGRectGetHeight([UIScreen mainScreen].bounds)  - safeEdge.top - safeEdge.bottom) / 667.0 * height;
//    }else {
//
//        return (CGRectGetHeight([UIScreen mainScreen].bounds) - safeEdge.left - safeEdge.right) / 375.0f * height;
//    }
    CGFloat scale = height / 667;
    CGFloat result = kScreen_height * scale;
    if (kDeviceIsiPhoneX()) {
        result = 667 * scale;
    }
    return result;
}

/**
 获取app keyWindow

 @return window
 */
static inline UIWindow * kGetKeywindow() {
    return [UIApplication sharedApplication].delegate.window;
}

#pragma mark -
#pragma mark - 系统版本号判断

static inline BOOL kVersionCompare (CGFloat systemVersion) {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare:@(systemVersion).stringValue options:NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        return YES;
    }
    return NO;
}





#endif /* ZMUtilities_h */
