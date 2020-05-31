//
//  UIStackView+ZMExtension.h
//  Aspects
//
//  Created by qingyun on 2019/8/10.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIStackView (ZMExtension)

/**
 根据标签获取subView

 @param tag 标签
 @return UIView
 */
-(UIView *) viewWithTag:(NSInteger) tag;

@end

NS_ASSUME_NONNULL_END
