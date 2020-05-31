//
//  ZMCameraCardController.h
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/28.
//

#import <UIKit/UIKit.h>

#import "ZMCameraBaseController.h"


typedef NS_ENUM(NSUInteger, DYCameraCardType) {
    ///身份证人脸
    DYCameraCardTypeIDFace,
    ///身份证国徽
    DYCameraCardTypeNational,
    ///银行卡
    DYCameraCardTypeBank,
    ///通用
    DYCameraCardTypeGeneral
};

NS_ASSUME_NONNULL_BEGIN

/// 各种证件相机
@interface ZMCameraCardController : ZMCameraBaseController

/*! 裁剪框类型  */
@property (nonatomic, assign) DYCameraCardType cameraType;

/*! 图片旋转类型（通用类型可设置）  */
@property (nonatomic, assign) UIImageOrientation imageOrientation;

/*! 裁剪回调  */
@property (nonatomic, copy)  void(^takePictureBlock)(ZMCameraCardController *cameraController, UIView *clipView, UIImage *originImage, UIImage *clipImage);

@end

NS_ASSUME_NONNULL_END
