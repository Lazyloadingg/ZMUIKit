//
//  ZMCameraController.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/11/12.
//

#import <UIKit/UIKit.h>
#import "ZMCameraBaseController.h"


NS_ASSUME_NONNULL_BEGIN

/// 自定义相机
@interface ZMCameraController : ZMCameraBaseController

/// 是否裁剪图片（默认1：1）
@property (nonatomic, assign) BOOL allowCrop;

@property (nonatomic, assign) CGRect cropRect;

/// 录制视频时候进度条颜色 默认 rgb(80, 169, 56)
@property (nonatomic, strong) UIColor *circleProgressColor;

/// 确定回调，如果拍照则videoUrl为nil，如果视频则image为nil
@property (nonatomic, copy) void (^completionBlock)(UIImage *image, NSURL *videoUrl);


@end

NS_ASSUME_NONNULL_END
