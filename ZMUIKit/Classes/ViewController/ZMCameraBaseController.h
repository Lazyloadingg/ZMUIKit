//
//  ZMCameraBaseController.h
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/19.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZMUIKitDefine.h"


@protocol DYCustomCameraDelegate <NSObject>

/// 拍照事件
/// @param controller controller
/// @param image image
/// @param posion posion
/// @param imageDataSampleBuffer imageDataSampleBuffer
/// @param error error
-(void)cameraTakePicture:(UIViewController *)controller image:(UIImage *)image devicePosition:(AVCaptureDevicePosition)posion imageDataSampleBuffer:(CMSampleBufferRef )imageDataSampleBuffer error:(NSError *)error;

@optional

/// 点击聚焦
/// @param controller controller
/// @param point 聚焦点视图坐标
/// @param capturePoint 聚焦点摄像头坐标
-(void)cameraTapActionFocus:(UIViewController *)controller point:(CGPoint )point capturePoint:(CGPoint)capturePoint;

@end

NS_ASSUME_NONNULL_BEGIN

/// 自定义相机基类
@interface ZMCameraBaseController : UIViewController

@property (nonatomic, weak)  id<DYCustomCameraDelegate>  delegate;

/** 摄像头方向默认后置摄像头 */
@property(nonatomic,assign)AVCaptureDevicePosition devicePosition;

/// 是否允许拍照 默认YES
@property (nonatomic, assign) BOOL allowTakePhoto;

/// 是否允许录制视频 默认YES
@property (nonatomic, assign) BOOL allowRecordVideo;

/// 最大录制时长 默认15s
@property (nonatomic, assign) NSInteger maxRecordDuration;

/// 禁止点击聚焦区域
@property (nonatomic, assign) CGRect unableFocusRect;

/// 分辨率 默认 DYCaptureSessionPreset1280x720
@property (nonatomic, assign) DYCaptureSessionPreset sessionPreset;

///画面拉伸方式
@property(nonatomic, copy) AVLayerVideoGravity videoGravity;

/// 拍照
- (void)onTakePicture;

/// 重拍
- (void)onRetake;

/// 切换摄像头
- (void)switchCamera;

/// 开始录制（暂不支持）
-(void)onStartRecord;

/// 开始录制（录制完成）
-(void)onFinishRecord;

/// 清空拍摄后展示图片
-(void)resetTakedImage;
@end

NS_ASSUME_NONNULL_END
