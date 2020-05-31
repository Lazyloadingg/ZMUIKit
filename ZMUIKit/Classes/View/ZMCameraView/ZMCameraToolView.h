//
//  ZMCameraToolView.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/11/18.
//

#import <UIKit/UIKit.h>

@protocol ZMCameraToolViewDelegate <NSObject>

/**
 单击事件，拍照
 */

- (void)onTakePictureAction;
/**
 开始录制
 */

- (void)onStartRecordAction;
/**
 结束录制
 */

- (void)onFinishRecordAction;
/**
 重新拍照或录制
 */

- (void)onRetakeAction;
/**
 点击确定
 */
- (void)onOkClickAction;

/// 退出拍摄界面
- (void)onDismissAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZMCameraToolView : UIView

@property (nonatomic, weak) id<ZMCameraToolViewDelegate> delegate;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) BOOL allowTakePhoto;
@property (nonatomic, assign) BOOL allowRecordVideo;
@property (nonatomic, strong) UIColor *circleProgressColor;
@property (nonatomic, assign) NSInteger maxRecordDuration;
@property (nonatomic, strong) UIView *bottomView;

/// 开始动画
- (void)startAnimate;

/// 停止动画
- (void)stopAnimate;
@end

NS_ASSUME_NONNULL_END
