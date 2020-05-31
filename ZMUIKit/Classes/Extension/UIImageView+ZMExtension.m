//
//  UIImageView+ZMExtension.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/21.
//

#import "UIImageView+ZMExtension.h"


static NSString *const kAnimationKey = @"gradualChangeAni";
static CGFloat const kAnimationDuration = 0.25;

@interface UIImageView () <CAAnimationDelegate>

@end

@implementation UIImageView (ZMExtension)

- (void)zm_setImageWithURL:(NSURL *)url {
    [self zm_setImageWithURL:url placeholderImage:nil options:SDWebImageLowPriority completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self zm_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageLowPriority completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)option {
    [self zm_setImageWithURL:url placeholderImage:placeholderImage options:option completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(dispatch_block_t)completed {
    [self zm_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageLowPriority completed:completed];
}

- (void)zm_setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)option completed:(dispatch_block_t)completed {
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:imageURL placeholderImage:placeholder options:option completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = kAnimationDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [weakSelf.layer addAnimation:transition forKey:kAnimationKey];
        }
        if (completed) {
            completed();
        }
    }];
}

- (void)zm_setImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock {
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = kAnimationDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [weakSelf.layer addAnimation:transition forKey:kAnimationKey];
        }
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.layer removeAnimationForKey:kAnimationKey];
}

@end
