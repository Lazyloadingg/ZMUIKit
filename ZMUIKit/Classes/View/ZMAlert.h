//
//  DYAlert.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import "ZMTextField.h"
#import "ZMAlertSheetAction.h"
#import "ZMAlertController.h"

typedef enum DYAlertStyleEnum{
    DYAlertStyle_Default, //默认样式 取消按钮为黑色 确认按钮为蓝色
    DYAlertStyle_DefaultConfirm, //默认确认样式，取消按钮为蓝色，默认按钮一般为空，如有则蓝色
    DYAlertStyle_Content, //只有内容,而且取消，确认按钮全为默认蓝色
    DYAlertStyle_ContentDestructive,//有内容，确认按钮为红色
}DYAlertStyle;

@class DYAlertAction;
@interface DYAlert : NSObject

/**
 消息弹框

 @param title 标题
 @param message 消息内容
 @param cancelTitle 取消按钮文字
 @param cancelBlock 取消按钮Action
 @param otherTitle 其他按钮文字
 @param otherBlock 其他按钮Action
 @param viewController 要弹得目标控制器
 @return alert
 */
+ (instancetype)alertWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                  cancelBlock:(dispatch_block_t)cancelBlock
                   otherTitle:(NSString *)otherTitle
                   otherBlock:(dispatch_block_t)otherBlock
           fromViewController:(UIViewController *)viewController;

/**
 消息弹框-自定义弹框

 @param customAlertView 自定义弹框
 @param tapBackgroundViewDismiss 点击蒙版部分是否dismiss
 @param viewController 目标控制器
 @return alert
 */
+ (instancetype)alertWithCustomAlertView:(UIView *)customAlertView
                tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                      fromViewController:(UIViewController *)viewController;

/**
 消息弹框-自定义头部视图

 @param customHeaderView 自定义头部视图
 @param cancelTitle 取消按钮文字
 @param cancelBlock 取消按钮Action
 @param otherTitle 其他按钮文字
 @param otherBlock 其他按钮Action
 @param viewController 目标控制器
 @return alert
 */
+ (instancetype)alertWithCustomHeaderView:(UIView *)customHeaderView
                              cancelTitle:(NSString *)cancelTitle
                              cancelBlock:(dispatch_block_t)cancelBlock
                               otherTitle:(NSString *)otherTitle
                               otherBlock:(dispatch_block_t)otherBlock
                       fromViewController:(UIViewController *)viewController;

/// 消息弹窗-自定义action View
/// @param customActionView 自定义的action视图
/// @param title title
/// @param message msg
/// @param tapBackgroundViewDismiss 点击弹框区域外是否隐藏弹窗
/// @param viewController 目标控制器
+ (instancetype)alertControllerWithCustomActionSequenceView:(UIView *)customActionView
                                                      title:(nullable NSString *)title
                                                    message:(nullable NSString *)message
                                   tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                                         fromViewController:(UIViewController *)viewController;

/**
 消息弹框-自定义actions

 @param actions actions
 @param axis 视图排布方向
 @param tapBackgroundViewDismiss 点击弹框区域外是否隐藏弹窗
 @param viewController 目标控制器
 @return alert
 */
+ (instancetype)alertWithCustomActions:(NSArray <DYAlertAction *>*)actions
                            actionAxis:(UILayoutConstraintAxis)axis
              tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                    fromViewController:(UIViewController *)viewController;
/// 弹框
/// @param title 标题
/// @param message 消息
/// @param cancelTitle 取消按钮
/// @param cancelBlock 取消block
/// @param otherTitle 其他按钮
/// @param otherBlock 其他block
/// @param viewController vc
/// @param style 样式
+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                   cancelBlock:(dispatch_block_t)cancelBlock
                    otherTitle:(nullable NSString *)otherTitle
                    otherBlock:(nullable dispatch_block_t)otherBlock
            fromViewController:(UIViewController *)viewController style:(DYAlertStyle) style;
/*! 状态栏样式  */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

/*! 自定义视图和actions状态下 is nil  */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/*! 自定义视图和actions状态下 is nil  */
@property (nonatomic, strong, readonly) UILabel *messageLabel;

/*! 自定义视图和actions状态下 is nil  */
@property (nonatomic, strong, readonly) DYAlertAction *cancelAction;

/*! 自定义视图和actions状态下 is nil  */
@property (nonatomic, strong, readonly) DYAlertAction *confirmAction;

/*! 只在action构建函数创建的alert下才有值  */
@property (nonatomic, readonly) NSArray <DYAlertAction *>*actions;
/*! 弹框控制器   */
@property (nullable, nonatomic, strong) DYAlertController  *alertController; 

/*! 距左右屏幕距离  */
@property (nonatomic, assign) CGFloat minDistanceToEdges;

/*! action 布局方向  */
@property (nonatomic, assign) UILayoutConstraintAxis actionAxis;

/** 是否单击背景退出对话框,默认为NO */
@property(nonatomic, assign) BOOL tapBackgroundViewDismiss;

/*! 添加action  */
- (void)addAction:(DYAlertAction *)action;

/** 添加输入框 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(ZMTextField *textField))configurationHandler;

- (void)show;

- (void)showAlertWithCompletion:(dispatch_block_t)completion;

- (void)dismiss;

- (void)dismissAlertWithCompletion:(dispatch_block_t)completion;

#pragma mark --> 🐷 New Alert  以下方法和此行上边方法不共存🐷

/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets headerInsets;

/// 添加标题
/// @param label label
- (void)addTitle:(void(^)(UILabel *label))label;

/// 添加action
/// @param sheetAction sheetAction
- (void)addNewAction:(ZMAlertSheetAction *)sheetAction;

/// 添加自定义view
/// @param customView customView
- (void)addCustomView:(UIView *)customView;

/// 添加每一项间距 （需设置间距的item后跟随设置）
/// @param insets insets
- (void)addtemInsets:(UIEdgeInsets )insets;

/// 展示
- (void)newShow;

@end

