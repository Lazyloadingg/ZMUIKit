//
//  UIImageView+ZMExtension.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/21.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

@interface UIImageView (ZMExtension)


- (void)zm_setImageWithURL:(NSURL *)url;

- (void)zm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

- (void)zm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)option;

- (void)zm_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock;

@end

