//
//  CALayer+ZMExtension.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/8.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZMExtension)

/**
 梯度layer

 @param colors 颜色数组
 @param vertical 是否竖向渲染
 @return 梯度layer
 */
+ (CAGradientLayer *)zm_colors:(NSArray <UIColor *>*)colors isVertical:(BOOL)vertical;

@end

NS_ASSUME_NONNULL_END
