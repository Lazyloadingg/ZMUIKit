//
//  ZMHud.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/23.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DYProgressHUD.h"
//#import "ZMHud+ZMExtension.h"
//NS_ASSUME_NONNULL_BEGIN

//hud显示类型
typedef enum ZMHudTypeEnum{
    ZMHudType_None,
    ZMHudType_Clock,
    ZMHudType_Sign,
    ZMHudType_Success,
    ZMHudType_Failure,
    ZMHudType_Face,
    ZMHudType_Device
}ZMHudType;

@interface ZMHud : NSObject
@property(nonatomic,strong) UIViewController *vc;//当前视图控制器
@property(nonatomic,copy) dispatch_block_t completeHud;//hud加载完成
#pragma mark - 🐷 业务 🐷

/**
 展示带白色xx  HUD

 @param message 文本信息
 */
+ (void)showErrorImageMessage:(NSString *)message;

/**
 展示带白色√  HUD

 @param message 文本信息
 */
+ (void)showSuccessImageMessage:(NSString *)message;
/**
展示感叹号  HUD

@param message 文本信息
*/
+ (void)showSignImageMessage:(NSString *)message;
/**
正在加载图标及文本提示  HUD

@param message 文本信息*/
+ (void)showLoadingMessage:(NSString *) message;


#pragma mark -
#pragma mark - 自定义图文 默认宽高 120 * 120 pt

/// 加载成功图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showSuccessMessage:(NSString *)msg;

/// 加载警告图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showWarningMessage:(NSString *)msg;

/// 加载错误图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showErrorMessage:(NSString *)msg;

/// 加载自定义图标&&msg（默认宽高120pt，父视图windows）
/// @param icon 图标
/// @param msg msg
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg;

/// 加载自定义尺寸的图标&&msg（默认放windows上）
/// @param icon 图标
/// @param msg msg
/// @param size size
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg size:(CGSize)size;

/// 加载自定义图标&&msg（默认宽高120pt）
/// @param icon 图标
/// @param msg msg
/// @param superView 要添加的父视图（传nil则放在windows上）
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg superView:(UIView *)superView;

/// 加载自定义尺寸的图标&&msg
/// @param icon 图标
/// @param msg msg
/// @param size size
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg superView:(UIView *)superView size:(CGSize)size;

/// 显示文本消息和图标
/// @param message 文本
/// @param type 图标
+(void) showMessage:(NSString *) message type:(ZMHudType) type;
/// 显示文本消息和图标
/// @param message 文本
/// @param type 图标类型
/// @param isWindow YES在window打开 NO vc打开
+(void) showMessage:(NSString *) message type:(ZMHudType) type isWindow:(BOOL)isWindow;

/// 显示文本消息和图标
/// @param message 文本
/// @param iconImg 图标
/// @param isWindow YES在window打开 NO vc打开
+(void) showMessage:(NSString *) message icon:(UIImage *)iconImg isWindow:(BOOL)isWindow;
/// 小菊花
/// @param message 消息
/// @param isWindow 是否在window
/// @param aTimer 计时器
+ (DYProgressHUD *)showLoadingMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer;
/**
自定义图标  HUD

@param message 文本信息
 */
+ (void)showCustoIcon:(NSString *)iconName message:(NSString *)message;

/// 创建hud视图
/// @param message 消息
/// @param isWindow 是否window
+ (MBProgressHUD *)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow;
/**
 有转圈的文本提示

 @param msg 消息文本
 @param superView 父视图
 */
+ (void)showCycleTip:(NSString *)msg onView:(UIView *)superView;

/// 有转圈的文本提示
/// @param msg 消息文本
/// @param superView superView
/// @param minTime 最小停留时间
+ (void)showCycleTip:(NSString *)msg onView:(UIView *)superView minTime:(CGFloat)minTime;

/**
 转圈
 
 @param view 展示视图
 */
+ (void)showCycleOnView:(UIView *)view;

/// 转圈提示
/// @param view view
/// @param minTime 最小停留时间
+ (void)showCycleOnView:(UIView *)view minTimer:(CGFloat)minTime;

/// 显示模拟加载进度hud 默认5s
/// @param title 标题
/// @param vc 控制器
-(instancetype) initWithShowProgressHud:(NSString *) title vc:(UIViewController *) vc;
#pragma mark - 🐷 隐藏HUD 🐷

/**
  隐藏蒙版
 */
+ (void)hide;

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 隐藏当前View上的HUD
 */
+ (void)hideInView;

/**
 隐藏当前window上的HUD
 */
+ (void)hideInWindow;

/**
 延时隐藏蒙版(无论在view还是window)

 @param delaySeconds delay
 */
+ (void)hideDelay:(int)delaySeconds;

#pragma mark - 🐷 小菊花 🐷

/**
 在window展示一个小菊花
 */
+ (void)showHUD;

/**
 在当前View展示一个小菊花
 */
+ (void)showHUDInView;

/**
  在window展示一个 loading... 小菊花
 */
+ (void)showHUDLoadingEN;

/**
 在window展示一个 加载中... 小菊花
 */
+ (void)showHUDLoadingCH;

/**
 在window展示一个有文本小菊花

 @param message 文本信息
 */
+ (void)showHUDMessage:(NSString *)message;

/**
 限时隐藏在window展示一个 loading... 小菊花

 @param afterSecond after
 */
+ (void)showHUDLoadingAfterDelay:(int)afterSecond;

/**
 限时隐藏在window展示一个有文本小菊花

 @param message 文本信息
 @param afterSecond after
 */
+ (void)showHUDMessage:(NSString *)message afterDelay:(int)afterSecond;


/**
 限时隐藏在view展示一个有文本小菊花

 @param message 文本信息
 @param afterSecond after
 */
+ (void)showHUDMessageInView:(NSString *)message afterDelay:(int)afterSecond;

#pragma mark - 🐷 文本提示框 🐷

/**
 在window上显示文本提示框

 @param message 提示文本
 */
+ (void)showTipHUD:(NSString *)message;

/**
 在view上显示文本提示框

 @param message 提示文本
 */
+ (void)showTipHUDInView:(NSString *)message;

/**
 限时隐藏在window展示一个有文本提示框

 @param message 文本信息
 @param afterSecond after
 */
+ (void)showTipHUD:(NSString *)message afterDelay:(int)afterSecond;

/**
 限时隐藏在view展示一个有文本提示框

 @param message 文本信息
 @param afterSecond after
 */
+ (void)showTipHUDInView:(NSString *)message afterDelay:(int)afterSecond;

#pragma mark - 🐷 提示图片 🐷

@end



//NS_ASSUME_NONNULL_END
