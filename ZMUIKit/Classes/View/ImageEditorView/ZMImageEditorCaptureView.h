//
//  ZMImageEditorCaptureView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2020/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMImageEditorCaptureView : UIView

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *captureView;

@property (nonatomic, assign) NSInteger rotateTimes;

/// 截取View获取图片
- (UIImage *)captureImage;

/// 截取框对应原图片
- (UIImage *)captureOriginalImage;

@end

NS_ASSUME_NONNULL_END
