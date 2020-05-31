//
//  DYBrightness.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 屏幕亮度调节
 */
@interface ZMBrightness : NSObject

/**
 保存当前的亮度
 */
+ (void)saveDefaultBrightness;


/**
 逐步设置亮度

 @param value 0 ~ 1
 */
+ (void)graduallySetBrightness:(CGFloat)value;


/**
 逐步恢复亮度
 */
+ (void)graduallyResumeBrightness;


/**
 使亮度快速恢复到之前的值
 */
+ (void)fastResumeBrightness;

@end

NS_ASSUME_NONNULL_END
