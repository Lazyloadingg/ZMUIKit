//
//  ZMHud.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/23.
//

#import "ZMHud.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZMUtilities.h"
#import "UIImage+ZMExtension.h"
#import "UIFont+ZMExtension.h"
#import "ZMHudCustomView.h"
#import <Masonry/Masonry.h>

/// 隐藏蒙版默认时间
static const NSTimeInterval kHideHUDTimeInterval = 1.5f;
static const NSTimeInterval kHideHUDMinTimeInterval = 0.0f;

/// 提示框文字大小
static CGFloat FONT_SIZE = 16.0f;



@interface ZMHudIconMessageView : UIView

@property (nonatomic) CGSize contentSize;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end



@implementation ZMHud
#pragma mark - 🐷 隐藏HUD 🐷

/// 隐藏蒙版(无论在view还是window)
+ (void)hide{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
        [MBProgressHUD hideHUDForView:[self getCurrentUIVC].view animated:YES];
        [MBProgressHUD hideHUDForView:winView animated:YES];
    });
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:view animated:animated];
}

/// 延时隐藏蒙版(无论在view还是window)
+ (void)hideDelay:(int)delaySeconds{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}
/// 隐藏当前View上的HUD
+ (void)hideInView{
    
    [MBProgressHUD hideHUDForView:[self getCurrentUIVC].view animated:YES];
}
/// 隐藏当前window上的HUD
+ (void)hideInWindow{
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [MBProgressHUD hideHUDForView:winView animated:YES];
}
#pragma mark - 🐷 业务 🐷

+ (void)showErrorImageMessage:(NSString *)message{
    [self showCustomImage:[UIImage zm_kitImageNamed:@"kit_hud_error"] message:message isWindow:YES];
}

+ (void)showSuccessImageMessage:(NSString *)message{
    [self showCustomImage:[UIImage zm_kitImageNamed:@"kit_hud_ok"] message:message isWindow:YES];
}
+ (void)showSignImageMessage:(NSString *)message{
    [self showCustomImage:[UIImage zm_kitImageNamed:@"kit_hud_sign"] message:message isWindow:YES];
}

#pragma mark -
#pragma mark - 自定义图文 默认宽高 120 * 120 pt

/// 加载成功图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showSuccessMessage:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:[UIImage zm_kitImageNamed:@"zmkit_hud_success"] message:msg superView:nil size:CGSizeMake(120, 120)];
    });
}

/// 加载警告图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showWarningMessage:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:[UIImage zm_kitImageNamed:@"zmkit_hud_sign"] message:msg superView:nil size:CGSizeMake(120, 120)];
    });
}

/// 加载错误图标+自定义msg（默认宽高120pt，父视图windows）
/// @param msg msg
+ (void)showErrorMessage:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:[UIImage zm_kitImageNamed:@"zmkit_hud_sign"] message:msg superView:nil size:CGSizeMake(120, 120)];
    });
}

/// 加载自定义图标&&msg（默认宽高120pt，父视图windows）
/// @param icon 图标
/// @param msg msg
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:icon message:msg superView:nil size:CGSizeMake(120, 120)];
    });
}

/// 加载自定义尺寸的图标&&msg（默认放windows上）
/// @param icon 图标
/// @param msg msg
/// @param size size
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg size:(CGSize)size {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:icon message:msg superView:nil size:size];
    });
}

/// 加载自定义图标&&msg（默认宽高120pt）
/// @param icon 图标
/// @param msg msg
/// @param superView 要添加的父视图（传nil则放在windows上）
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg superView:(UIView *)superView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIcom:icon message:msg superView:superView size:CGSizeMake(120, 120)];
    });
}

/// 加载自定义尺寸的图标&&msg
/// @param icon 图标
/// @param msg msg
/// @param size size
+ (void)showIcom:(UIImage *)icon message:(NSString *)msg superView:(UIView *)superView size:(CGSize)size {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *spv = superView ?: [UIApplication sharedApplication].delegate.window;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:spv animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        ZMHudIconMessageView * imageView =  [[ZMHudIconMessageView alloc] init];
        imageView.iconImageView.image = icon;
        imageView.titleLabel.text = msg;
        imageView.contentSize = size;
        hud.contentColor = [UIColor clearColor];
        hud.customView = imageView;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
    });
}
#pragma mark

#pragma mark - 🐷 小菊花 🐷
/// 在window展示一个小菊花
+ (void)showHUD{
    
    [self showActivityMessage:@"" isWindow:YES timer:0];
}

/// 在当前View展示一个小菊花
+ (void)showHUDInView{
    
    [self showActivityMessage:@"" isWindow:NO timer:0];
}

/// 在window展示一个 loading... 小菊花
+ (void)showHUDLoadingEN {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:@"loading..." isWindow:YES timer:0];
    });
}

/// 在window展示一个 加载中... 小菊花
+ (void)showHUDLoadingCH {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:NSLocalizedString(@"加载中...", nil) isWindow:YES timer:0];
    });
}

/// 在window展示一个有文本小菊花
+ (void)showHUDMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:message isWindow:YES timer:0];
    });
}

/// 限时隐藏在window展示一个 loading... 小菊花
+ (void)showHUDLoadingAfterDelay:(int)afterSecond{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:@"loading..." isWindow:YES timer:afterSecond];
    });
}

/// 限时隐藏在window展示一个有文本小菊花
+ (void)showHUDMessage:(NSString *)message afterDelay:(int)afterSecond{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:message isWindow:YES timer:afterSecond];
    });
}

/// 限时隐藏在view展示一个有文本小菊花
+ (void)showHUDMessageInView:(NSString *)message afterDelay:(int)afterSecond{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityMessage:message isWindow:NO timer:afterSecond];
    });
}

#pragma mark - 🐷 文本提示框 🐷
/// 在window上显示文本提示框
+ (void)showTipHUD:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTipMessage:message isWindow:YES timer:kHideHUDTimeInterval];
    });
}

/// 在window上显示文本提示框
+ (void)showTipHUDInView:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTipMessage:message isWindow:NO timer:kHideHUDTimeInterval];
    });
}

/// 限时隐藏在window展示一个有文本提示框
+ (void)showTipHUD:(NSString *)message afterDelay:(int)afterSecond{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTipMessage:message isWindow:YES timer:afterSecond];
    });
}

/// 限时隐藏在view展示一个有文本提示框
+ (void)showTipHUDInView:(NSString *)message afterDelay:(int)afterSecond{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTipMessage:message isWindow:NO timer:afterSecond];
    });
}

#pragma mark - 🐷 提示图片 🐷
/// 正确提示
//+ (void)showSuccessHUD {
//
//    [self showSSCustomIcon:@"msg_icon_ok_default" message:@"" isWindow:YES textColor:COLOR(@"38CDDE")];
//}
//
///// 有文本正确提示
//+ (void)showSuccessTipHUD:(NSString *)message {
//
//    [self showSSCustomIcon:@"msg_icon_ok_default" message:message  isWindow:YES textColor:COLOR(@"38CDDE")];
//}
//
///// 有文本正确提示
//+ (void)showSuccessTipHUD:(NSString *)message afterDelay:(int)afterSecond{
//
//    [self showCustomIcon:@"msg_icon_ok_default" message:message  isWindow:YES textColor:COLOR(@"38CDDE") timer:afterSecond];
//}
//
///// 在view展示有文本正确提示
//+ (void)showSuccessTipHUDInView:(NSString *)message {
//
//    [self showSSCustomIcon:@"msg_icon_ok_default" message:message isWindow:NO textColor:COLOR(@"38CDDE")];
//}

/// 错误提示
//+ (void)showErrorHUD {
//
//    [self showCustomIcon:@"msg_icon_loser_default" message:@"" isWindow:YES textColor:[UIColor colorWithRed:230/255.0 green:135/255.0 blue:61/255.0 alpha:1]];
//}

///// 有文本错误提示
+ (void)showErrorTipHUD:(NSString *)message {
    
    [self showCustomIcon:@"kit_hud_error" message:message isWindow:YES textColor:[UIColor whiteColor]];
}
///// 有正在加载图标及文本提示
+ (void)showLoadingHUD:(NSString *) message{
    
    [self showCustomIcon:@"ZMUIKit_hud_loading" message:message isWindow:YES textColor:[UIColor whiteColor]];
}
+ (void)showCustoIcon:(NSString *)iconName message:(NSString *)message{
    
     [self showCustomIcon:iconName message:message isWindow:YES textColor:[UIColor whiteColor]];
}
//有文本的转圈提示
+ (void)showCycleTip:(NSString *)msg onView:(UIView *)superView {
    [ZMHud showCycleTip:msg onView:superView minTime:kHideHUDMinTimeInterval];
}
//有文本的转圈提示
+ (void)showCycleTip:(NSString *)msg onView:(UIView *)superView minTime:(CGFloat)minTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *spv = superView ?: [UIApplication sharedApplication].delegate.window;
        ZMHudCustomView *customView = [ZMHudCustomView new];
        customView.titleLabel.text = msg;
        customView.contentSize = CGSizeMake(120, 120);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:spv animated:YES];
        
        hud.contentColor = [UIColor clearColor];
        hud.customView = customView;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
        
//        hud.margin = 10;
//        hud.backgroundView.backgroundColor = [UIColor clearColor];
        hud.mode = MBProgressHUDModeCustomView;
        hud.minShowTime = minTime;
    });
    
}
//转圈提示
+ (void)showCycleOnView:(UIView *)view  {
    [ZMHud showCycleOnView:view minTimer:kHideHUDMinTimeInterval];
}
//转圈提示
+ (void)showCycleOnView:(UIView *)view minTimer:(CGFloat)minTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * target = view ?: [UIApplication sharedApplication].delegate.window;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:target animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        hud.margin = 8;
        hud.bezelView.alpha = 0.8;
        hud.minShowTime = minTime;
        hud.minSize = CGSizeMake(70, 70);
        hud.backgroundView.backgroundColor = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        UIImageView * cycleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        cycleImg.contentMode = UIViewContentModeScaleAspectFill;
        cycleImg.image = [UIImage zm_kitImageNamed:@"kit_hud_cycle"];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 1.0;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [cycleImg.layer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
        
        hud.customView = cycleImg;
    });
}
// 在view有文本错误提示
//+ (void)showErrorTipHUDInView:(NSString *)message {
//
//    [self showCustomIcon:@"msg_icon_loser_default" message:message isWindow:NO textColor:[UIColor colorWithRed:230/255.0 green:135/255.0 blue:61/255.0 alpha:1]];
//}
/// 在view有文本错误提示
//+ (void)showErrorTipHUDInView:(NSString *)message {
//
//    [self showCustomIcon:@"msg_icon_loser_default" message:message isWindow:NO textColor:[UIColor colorWithRed:230/255.0 green:135/255.0 blue:61/255.0 alpha:1]];
//}

/// 信息提示
//+ (void)showInfoTipHUD:(NSString *)message {
//
//    [self showCustomIcon:@"info" message:message isWindow:YES];
//}

/// 在view信息提示
//+ (void)showInfoTipHUDInView:(NSString *)message {
//
//    [self showCustomIcon:@"info" message:message isWindow:NO];
//}

/// 警告提示
//+ (void)showWarningTipHUD:(NSString *)message {
//    [self showCustomIcon:@"msg_icon_wrong_default" message:message isWindow:YES textColor:[UIColor colorWithRed:183/255.0 green:189/255.0 blue:189/255.0 alpha:1]];
//}

/// 在view警告提示
//+ (void)showWarningTipHUDInView:(NSString *)message {
//    [self showCustomIcon:@"msg_icon_wrong_default" message:message isWindow:NO textColor:[UIColor colorWithRed:183/255.0 green:189/255.0 blue:189/255.0 alpha:1]];
//}

+ (void)showCustomIconHUD:(NSString *)iconName message:(NSString *)message {

    [self showCustomIcon:iconName message:message isWindow:YES];
}

/// 在view上展示自定义图片 - 图片需要导入 'XWHUDImages.bundle' 包中
+ (void)showCustomIconHUDInView:(NSString *)iconName message:(NSString *)message {
    
    [self showCustomIcon:iconName message:message isWindow:NO];
}
///update by Donkey
+ (void)showCustomIconHUD:(NSString *)iconName message:(NSString *)message color:(UIColor *)color{
    [self showCustomIcon:iconName message:message isWindow:YES textColor:color];
}
///update by Donkey
+(void)showCustomIconHUDInView:(NSString *)iconName message:(NSString *)message color:(UIColor *)color{
    [self showCustomIcon:iconName message:message isWindow:NO textColor:color];
    
}

#pragma mark - 🐷 setter 🐷
/// 文本框
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        //    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        UIView *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.minSize = CGSizeMake(60, 40);
        hud.margin = 5;
        if (aTimer > 0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }else{
            [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
        }
        
        hud.bezelView.alpha = 0.8;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        hud.contentColor = [UIColor whiteColor];
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        UIButton * button = [[UIButton alloc]init];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [button setTitle:message forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor colorC3] forState:UIControlStateNormal];
        hud.customView = button;
    });

}

/// 小菊花
+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (aTimer > 0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }
    });
}

//自定义图片文字
+ (void)showCustomImage:(UIImage *)image message:(NSString *)message isWindow:(BOOL)isWindow{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.minSize = CGSizeMake(150, 40);
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    hud.bezelView.alpha = 0.8;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    UIButton * imageView =  [[UIButton alloc] init];
    
    [imageView setImage:image forState:UIControlStateNormal];
    imageView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    hud.customView = imageView;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.bezelView.alpha = 0.8;
    [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
}
/// 自定义图片
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.minSize = CGSizeMake(150, 110);
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImageView * imageView =  [[UIImageView alloc] initWithImage:[UIImage zm_kitImageNamed:iconName]];
    hud.customView = imageView;
    [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
}

///update by Donkey
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow textColor:(UIColor *)color timer:(int)aTimer{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImageView * imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.contentMode = UIViewContentModeTop;
    hud.contentColor = color;
    hud.customView = imageView;
    [hud hideAnimated:YES afterDelay:aTimer];
}

///update by Donkey
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow textColor:(UIColor *)color{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
        hud.mode = MBProgressHUDModeCustomView;
        
        UIImageView * imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        imageView.contentMode = UIViewContentModeTop;
        hud.contentColor = color;
        hud.customView = imageView;
        [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
    });
}


+ (MBProgressHUD *)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow {
    
    UIView *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.minSize = CGSizeMake(90, 40);
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = message ? message : NSLocalizedString(@"加载中...", nil);
    hud.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    hud.label.numberOfLines = 0;
    hud.backgroundView.color =  [UIColor clearColor];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.label.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0, -32);
    hud.minShowTime = kHideHUDMinTimeInterval;
    return hud;
}
#pragma mark 自定义封装DYProgressHUD
/// 显示文本消息和图标
/// @param message 文本
/// @param type 图标
+(void) showMessage:(NSString *) message type:(ZMHudType) type{
    [ZMHud showMessage:message type:type isWindow:false];
}
/// 显示文本消息和图标
/// @param message 文本
/// @param type 图标
/// @param isWindow YES在window打开 NO vc打开
+(void) showMessage:(NSString *) message type:(ZMHudType) type isWindow:(BOOL)isWindow{
    switch (type) {
        case ZMHudType_Success:
        {
            [self showMessage:message icon:[UIImage zm_kitImageNamed:@"kit_hud_ok"] isWindow:isWindow];
        }
            break;
        case ZMHudType_Failure:{
             [self showMessage:message icon:[UIImage zm_kitImageNamed:@"kit_hud_error"] isWindow:isWindow];
        }
            break;
        case ZMHudType_Clock:{
            [self showMessage:message icon:[UIImage zm_kitImageNamed:(@"kit_hud_clock")]  isWindow:isWindow];
        }
            break;
        case ZMHudType_Face:{
            [self showMessage:message icon:[UIImage zm_kitImageNamed:(@"ZMHud_faceSad")]  isWindow:isWindow];
        }
            break;
        case ZMHudType_Sign:{
           [self showMessage:message icon:[UIImage zm_kitImageNamed:@"kit_hud_sign"]  isWindow:isWindow];
            break;
        }
        case ZMHudType_Device:{
            [self showMessage:message icon:[UIImage zm_kitImageNamed:(@"kit_hud_device")]  isWindow:isWindow];
        }
        break;
        case ZMHudType_None:{
            [self showMessage:message isWindow:true timer:kHideHUDMinTimeInterval];
        }
        default:
            break;
    }
}
/// 显示文本消息和图标
/// @param message 文本
/// @param iconImg 图标
/// @param isWindow YES在window打开 NO vc打开
+(void) showMessage:(NSString *) message icon:(UIImage *)iconImg isWindow:(BOOL)isWindow{
    [ZMHud showDYProgressHudWithCustomIcon:iconImg message:message isWindow:isWindow];
}

/// 小菊花
/// @param message 消息
/// @param isWindow 是否在window
/// @param aTimer 计时器
+ (DYProgressHUD *)showLoadingMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer{
    DYProgressHUD *hud = [ZMHud createDYProgressHUDviewWithMessage:message isWindiw:isWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.minSize = CGSizeMake(120, 120);
        hud.mode = DYProgressHUDModeCustomView;
        hud.bezelView.style = DYProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        hud.mode = MBProgressHUDModeIndeterminate;
        if (aTimer > 0) {
            [hud hideAnimated:YES afterDelay:aTimer];
        }
    });
    return hud;
}

/// 自定义图片
+ (void)showDYProgressHudWithCustomIcon:(UIImage *)iconImg message:(NSString *)message isWindow:(BOOL)isWindow
{
    DYProgressHUD *hud  =  [self createDYProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.minSize = CGSizeMake(120, 120);
    hud.mode = DYProgressHUDModeCustomView;
    hud.bezelView.style = DYProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImageView * imageView =  [[UIImageView alloc] initWithImage:iconImg];
    imageView.backgroundColor = [UIColor clearColor];
    hud.customView = imageView;
    hud.square = true;
    [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
}

+ (DYProgressHUD *)createDYProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow {
    
    UIView *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    DYProgressHUD *hud = [DYProgressHUD showHUDAddedTo:view animated:YES];
//    hud.minSize = CGSizeMake(90, 40);
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = message ? message : NSLocalizedString(@"加载中...", nil);
    hud.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    hud.label.numberOfLines = 0;
    
    hud.backgroundView.color =  [UIColor clearColor];
    hud.backgroundView.style = DYProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0, -32);
    hud.minShowTime = kHideHUDMinTimeInterval;
    return hud;
}
/// 显示提示文本
+ (void)showMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    
//    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    UIView *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.minSize = CGSizeMake(60, 40);
    hud.margin = 5;
    if (aTimer > 0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }else{
        [hud hideAnimated:YES afterDelay:kHideHUDTimeInterval];
    }
    
    hud.bezelView.alpha = 0.5;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];

    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    UIButton * button = [[UIButton alloc]init];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [button setTitle:message forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorC3] forState:UIControlStateNormal];
    hud.customView = button;

}
/// 显示模拟加载进度hud 默认5s
/// @param title 标题
/// @param vc 控制器
-(instancetype) initWithShowProgressHud:(NSString *) title vc:(UIViewController *) vc{
    if(self = [super init]){
        self.vc = vc;
        DYProgressHUD *hud = [DYProgressHUD showHUDAddedTo:vc.view
                                                  animated:YES];
        // Set the determinate mode to show task progress.
        hud.mode = DYProgressHUDModeAnnularDeterminate;
       // [HUD showWhileExecuting:@selector(progressHud)onTarget:self withObject:nil animated:YES];
        hud.label.textColor =[UIColor whiteColor];
        hud.label.font = [UIFont zm_font14pt:DYFontBoldTypeRegular];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = title;
//        hud.margin = 10;

         hud.minSize = CGSizeMake(120, 120);
//         hud.mode = DYProgressHUDModeCustomView;
         hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
         hud.backgroundView.backgroundColor = [UIColor clearColor];
         hud.bezelView.alpha = 0.8;
         hud.bezelView.style = DYProgressHUDBackgroundStyleSolidColor;
         hud.offset = CGPointMake(0, -32);
        //测试
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            // Do something useful in the background and update the HUD periodically.
            [self doSomeWorkWithProgress:5];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                 if(self.completeHud){
                     self.completeHud();
                 }
            });
        });
    }
    return self;
}
/// 加载延迟
/// @param sec 秒
- (void) doSomeWorkWithProgress:(int) sec{
   // This just increases the progress indicator in a loop.
   float progress = 0.0f;
   while (progress < 1.0f) {
       ZMLog(@"加载%f",progress);
       progress += 0.01f;
       dispatch_async(dispatch_get_main_queue(), ^{
           // Instead we could have also passed a reference to the HUD
           // to the HUD to myProgressTask as a method parameter.
           [DYProgressHUD HUDForView:self.vc.view].progress = progress;
       });
       usleep(sec*10000);
   }
}
#pragma mark - 🐷 private 🐷
/// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentUIVC {
    
    UIViewController  *superVC = [[self class]  getCurrentWindowViewController];
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }
    return superVC;
}

/// 获取当前窗口跟控制器
+ (UIViewController *)getCurrentWindowViewController {
    
    UIViewController *currentWindowVC = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        currentWindowVC = nextResponder;
    }else{
        currentWindowVC = window.rootViewController;
    }
    return currentWindowVC;
}
+ (NSArray <MBProgressHUD *>*)getHUDForm:(UIView *)view{
    NSMutableArray * huds = [NSMutableArray array];
      NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
      for (UIView *subview in subviewsEnum) {
          if ([subview isKindOfClass:MBProgressHUD.class]) {
              [huds addObject:subview];
          }
      }
    return huds;
}
#pragma mark-
#pragma mark- -> 🐷 HUD Test 🐷

@end







@implementation ZMHudIconMessageView

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self setupSubviewsContraints];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    CGSize newSize = CGSizeEqualToSize(self.contentSize, CGSizeZero) ? size : self.contentSize;
    return newSize;
}

#pragma mark -
#pragma mark - 👉 Request 👈

#pragma mark -
#pragma mark - 👉 DYNetworkResponseProtocol 👈

#pragma mark -
#pragma mark - 👉 <#Delegate#> 👈

#pragma mark -
#pragma mark - 👉 UIScrollViewDelegate 👈

#pragma mark -
#pragma mark - 👉 Event response 👈

#pragma mark -
#pragma mark - 👉 Private Methods 👈

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorC3];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont zm_font17pt:DYFontBoldTypeRegular];
    }
    return _titleLabel;
}


#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(kScreenWidthRatio(-18));
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(kScreenWidthRatio(27));
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

@end
