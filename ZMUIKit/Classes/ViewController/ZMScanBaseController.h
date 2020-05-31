//
//  ZMScanBaseController.h
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/29.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DYQRCodeScanDelegate<NSObject>

/// 扫描结果
/// @param vc vc
/// @param results results
-(void)scanComplete:(UIViewController *)vc results:(NSArray<NSString *> *)results;

/// 光线强弱
/// @param vc vc
/// @param brightnessValue brightnessValue
-(void)scanBrightness:(UIViewController *)vc brightnessValue:(CGFloat)brightnessValue;

@end

/// 自定义扫一扫基类
@interface ZMScanBaseController : UIViewController

@property (nonatomic, weak)  id<DYQRCodeScanDelegate>  delegate;

///画面拉伸方式
@property(nonatomic, copy) AVLayerVideoGravity videoGravity;

/// 分辨率 默认 AVCaptureSessionPreset1920x1080
@property (nonatomic, assign) AVCaptureSessionPreset sessionPreset;


///开始扫描
-(void)startScan;

///开始扫描
-(void)stopScan;

/// 开关闪光灯
/// @param on on YES 开启，NO 关闭
-(void)openFlashlight:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
