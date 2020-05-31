//
//  ZMImageEditorViewController.h
//  ZMUIKit
//
//  Created by 王士昌 on 2020/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZMImageEditorViewControllerProtocol;
/// 编辑图片 Controller
@interface ZMImageEditorViewController : UIViewController

/*! 图片处理回调  */
@property (nonatomic, weak) id <ZMImageEditorViewControllerProtocol>delegate;

/*! 截取原图  */
@property (nonatomic, strong) UIImage *originImage;

/*! 选取框size  */
@property (nonatomic, assign) CGSize editViewSize;

/*! 蒙层动画 默认YES  */
@property (nonatomic, assign) BOOL maskViewAnimation;


@end

@protocol ZMImageEditorViewControllerProtocol <NSObject>

@optional

/// 选取完成
/// @param controller controller
/// @param image 截取View获得图片
/// @param originSizeImage 截取框对应原图片
- (void)imageEditorViewController:(ZMImageEditorViewController *)controller finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage;


/// 取消
/// @param controller controller
- (void)imageEditorViewController:(ZMImageEditorViewController *)controller;

@end

NS_ASSUME_NONNULL_END
