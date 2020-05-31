//
//  obj_UpdateDirection.m
//  ZMAnimation
//
//  Created by Mac2 on 2017/8/3.
//  Copyright © 2017年 圣光大人. All rights reserved.
//

#import "ZMScreenDirection.h"

@implementation ZMScreenDirection
+(instancetype)shared{
    static ZMScreenDirection * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZMScreenDirection alloc]init];
        instance -> _screenDirection = UIInterfaceOrientationPortrait;
    });
    return instance;
}
-(void)setScreenDirection:(UIInterfaceOrientation)screenDirection{
    _screenDirection = screenDirection;
    [[ZMScreenDirection shared]setScreenOrientationWithUIInterfaceOrientation:_screenDirection];
}
- (UIInterfaceOrientationMask)interfaceOrientationMask{
    switch (self.screenDirection) {
            
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
            break;
            
        default:
            return UIInterfaceOrientationMaskPortrait;
            break;
    }
}
-(void)setScreenOrientationWithUIInterfaceOrientation:(UIInterfaceOrientation )Orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = Orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
