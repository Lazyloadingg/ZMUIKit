//
//  UIStackView+ZMExtension.m
//  Aspects
//
//  Created by qingyun on 2019/8/10.
//

#import "UIStackView+ZMExtension.h"

@implementation UIStackView (ZMExtension)
/**
 根据标签获取subView
 
 @param tag 标签
 @return UIView
 */
-(UIView *) viewWithTag:(NSInteger) tag{
    UIView *view =nil;
    for (UIView *subView in self.arrangedSubviews) {
        if (subView.tag == tag) {
            view = subView;
        }
    }
    return  view;
}
@end
