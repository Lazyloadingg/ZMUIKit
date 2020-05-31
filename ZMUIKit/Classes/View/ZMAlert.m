//
//  DYAlert.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/25.
//

#import "ZMAlert.h"
#import "ZMAlertController.h"
#import "UIColor+ZMExtension.h"
#import "UIFont+ZMExtension.h"
#import "UIViewController+ZMExtension.h"
#import <LEEAlert/LEEAlert.h>


@interface DYAlert ()


@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) DYAlertAction *cancelAction;

@property (nonatomic, strong) DYAlertAction *confirmAction;

@property (nonatomic, strong) LEEAlertConfig * alert;
@end

@implementation DYAlert
@synthesize cancelAction = _cancelAction, confirmAction = _confirmAction;

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                   cancelBlock:(dispatch_block_t)cancelBlock
                    otherTitle:(NSString *)otherTitle
                    otherBlock:(dispatch_block_t)otherBlock
            fromViewController:(UIViewController *)viewController {
    return [[self alloc]initWithTitle:title message:message cancelTitle:cancelTitle cancelBlock:cancelBlock otherTitle:otherTitle otherBlock:otherBlock fromViewController:viewController];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                  cancelBlock:(dispatch_block_t)cancelBlock
                   otherTitle:(NSString *)otherTitle
                   otherBlock:(dispatch_block_t)otherBlock
           fromViewController:(UIViewController *)viewController {
    
    if (self = [super init]) {
        _viewController = viewController;
        [self setupTitle:title message:message cancelTitle:cancelTitle cancelBlock:cancelBlock otherTitle:otherTitle otherBlock:otherBlock];
    }
    return self;
}

+ (instancetype)alertWithCustomHeaderView:(UIView *)customHeaderView
                              cancelTitle:(NSString *)cancelTitle
                              cancelBlock:(dispatch_block_t)cancelBlock
                               otherTitle:(NSString *)otherTitle
                               otherBlock:(dispatch_block_t)otherBlock
                       fromViewController:(UIViewController *)viewController {
    return [[self alloc]initWithCustomHeaderView:customHeaderView cancelTitle:cancelTitle cancelBlock:cancelBlock otherTitle:otherTitle otherBlock:otherBlock fromViewController:viewController];
}

- (instancetype)initWithCustomHeaderView:(UIView *)customHeaderView
                             cancelTitle:(NSString *)cancelTitle
                             cancelBlock:(dispatch_block_t)cancelBlock
                              otherTitle:(NSString *)otherTitle
                              otherBlock:(dispatch_block_t)otherBlock
                      fromViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
        DYAlertController *alertController = [DYAlertController alertControllerWithCustomHeaderView:customHeaderView preferredStyle:DYAlertControllerStyleAlert animationType:DYAlertAnimationTypeShrink];
        self.alertController = alertController;
        
        if (cancelTitle.length) {
            self.cancelAction = [DYAlertAction actionWithTitle:cancelTitle style:DYAlertActionStyleCancel handler:^(DYAlertAction * _Nonnull action) {
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
            self.cancelAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeMedium];
            self.cancelAction.titleColor = [UIColor colorC6];
            [alertController addAction:self.cancelAction];
        }
        
        if (otherTitle.length) {
            self.confirmAction = [DYAlertAction actionWithTitle:otherTitle style:DYAlertActionStyleDestructive handler:^(DYAlertAction * _Nonnull action) {
                if (otherBlock) {
                    otherBlock();
                }
            }];
            self.confirmAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeMedium];
            self.confirmAction.titleColor = [UIColor colorC1];
            [alertController addAction:self.confirmAction];
        }
    }
    return self;
}

- (void)setupTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelBlock:(dispatch_block_t)cancelBlock otherTitle:(NSString *)otherTitle otherBlock:(dispatch_block_t)otherBlock {
    
    DYAlertController *alertController = [DYAlertController alertControllerWithTitle:title message:message preferredStyle:DYAlertControllerStyleAlert animationType:DYAlertAnimationTypeShrink];
    alertController.titleLabel.textColor = [UIColor colorC5];
    alertController.titleLabel.font = [UIFont zm_font17pt:DYFontBoldTypeMedium];
    alertController.messageLabel.textColor = [UIColor colorC5];
    alertController.messageLabel.font = [UIFont zm_font17pt:DYFontBoldTypeMedium];
    self.alertController = alertController;
    
    if (cancelTitle.length) {
        self.cancelAction = [DYAlertAction actionWithTitle:cancelTitle style:DYAlertActionStyleCancel handler:^(DYAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        self.cancelAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeMedium];
        self.cancelAction.titleColor = [UIColor colorC6];
        [alertController addAction:self.cancelAction];
    }
    
    if (otherTitle.length) {
        self.confirmAction = [DYAlertAction actionWithTitle:otherTitle style:DYAlertActionStyleDestructive handler:^(DYAlertAction * _Nonnull action) {
            if (otherBlock) {
                otherBlock();
            }
        }];
        self.confirmAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeMedium];
        self.confirmAction.titleColor = [UIColor colorC1];
        [alertController addAction:self.confirmAction];
    }
    
}


+ (instancetype)alertControllerWithCustomActionSequenceView:(UIView *)customActionView
                                                       title:(nullable NSString *)title
                                                     message:(nullable NSString *)message
                                    tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                                         fromViewController:(UIViewController *)viewController {
    return [[self alloc] initWithCustomActionSequenceView:customActionView title:title message:message tapBackgroundViewDismiss:tapBackgroundViewDismiss fromViewController:viewController];
}

- (instancetype)initWithCustomActionSequenceView:(UIView *)customActionView
                   title:(nullable NSString *)title
                 message:(nullable NSString *)message
tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                                         fromViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        self.alertController = [DYAlertController alertControllerWithCustomActionSequenceView:customActionView title:title message:message preferredStyle:DYAlertControllerStyleAlert animationType:DYAlertAnimationTypeShrink];
        self.alertController.messageLabel.textColor = [UIColor colorC5];
        self.alertController.messageLabel.font = [UIFont zm_font17pt:DYFontBoldTypeMedium];
        self.alertController.tapBackgroundViewDismiss = tapBackgroundViewDismiss;
    }
    return self;
}


+ (instancetype)alertWithCustomAlertView:(UIView *)customAlertView
                tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                      fromViewController:(UIViewController *)viewController {
    return [[self alloc]initWithCustomAlertView:customAlertView tapBackgroundViewDismiss:tapBackgroundViewDismiss fromViewController:viewController];
}

- (instancetype)initWithCustomAlertView:(UIView *)customAlertView
               tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                     fromViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        self.alertController = [DYAlertController alertControllerWithCustomAlertView:customAlertView preferredStyle:DYAlertControllerStyleAlert animationType:DYAlertAnimationTypeShrink];
        self.alertController.tapBackgroundViewDismiss = tapBackgroundViewDismiss;
        self.alertController.messageLabel.textColor = [UIColor colorC5];
        self.alertController.messageLabel.font = [UIFont zm_font17pt:DYFontBoldTypeMedium];
    }
    return self;
}

+ (instancetype)alertWithCustomActions:(NSArray <DYAlertAction *>*)actions
                            actionAxis:(UILayoutConstraintAxis)axis
              tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                    fromViewController:(UIViewController *)viewController {
    return [[self alloc]initWithCustomActions:actions actionAxis:axis tapBackgroundViewDismiss:tapBackgroundViewDismiss fromViewController:viewController];
}

- (instancetype)initWithCustomActions:(NSArray <DYAlertAction *>*)actions
                           actionAxis:(UILayoutConstraintAxis)axis
             tapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss
                   fromViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        self.alertController = [DYAlertController alertControllerWithTitle:nil message:nil preferredStyle:DYAlertControllerStyleAlert animationType:DYAlertAnimationTypeShrink];
        self.alertController.actionAxis = axis;
        self.alertController.tapBackgroundViewDismiss = tapBackgroundViewDismiss;
        self.alertController.messageLabel.textColor = [UIColor colorC5];
        self.alertController.messageLabel.font = [UIFont zm_font17pt:DYFontBoldTypeMedium];
        [actions enumerateObjectsUsingBlock:^(DYAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.alertController addAction:obj];
        }];
    }
    return self;
}
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
            fromViewController:(UIViewController *)viewController style:(DYAlertStyle) style{
    DYAlert *alert =  [DYAlert alertWithTitle:title message:message cancelTitle:cancelTitle cancelBlock:cancelBlock otherTitle:otherTitle otherBlock:otherBlock fromViewController:viewController];
    alert.messageLabel.textColor = [UIColor colorC5];
    alert.messageLabel.font = [UIFont zm_font17pt:DYFontBoldTypeBold];
    alert.cancelAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeRegular];
    alert.confirmAction.titleFont = [UIFont zm_font17pt:DYFontBoldTypeRegular];
    alert.alertController.view.layer.cornerRadius = 5.0f;
    alert.alertController.view.clipsToBounds = true;
    if (style == DYAlertStyle_Default) {
        alert.cancelAction.titleColor = [UIColor colorC5];
        alert.confirmAction.titleColor = [UIColor colorBlue1];
        
    }else if (style == DYAlertStyle_DefaultConfirm){
        alert.cancelAction.titleColor = [UIColor colorBlue1];
        alert.confirmAction.titleColor = [UIColor colorBlue1];
    }else if (style == DYAlertStyle_Content){
        alert.cancelAction.titleColor = [UIColor colorBlue1];
        alert.confirmAction.titleColor = [UIColor colorBlue1];
        
//        alert.alertController.view.layer.cornerRadius = 12.0f;
        alert.alertController.view.clipsToBounds = true;
    }else if (style == DYAlertStyle_ContentDestructive){
        alert.cancelAction.titleColor = [UIColor colorBlue1];
        alert.confirmAction.titleColor = [UIColor colorRed2];
        
//        alert.alertController.view.layer.cornerRadius = 24.0f;
        alert.alertController.view.clipsToBounds = true;
    }
    return alert;
}


- (void)addAction:(DYAlertAction *)action {
    [self.alertController addAction:action];
}
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(ZMTextField *textField))configurationHandler{
    [self.alertController addTextFieldWithConfigurationHandler:configurationHandler];
}
- (void)show {
    [self showAlertWithCompletion:^{}];
}

- (void)showAlertWithCompletion:(dispatch_block_t)completion {
    self.alertController.statusBarStyle = self.viewController.preferredStatusBarStyle;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController presentViewController:self.alertController animated:YES completion:completion];
    });
}

- (void)dismiss {
    [self dismissAlertWithCompletion:^{}];
}

- (void)dismissAlertWithCompletion:(dispatch_block_t)completion {
    [self.viewController dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark -
#pragma mark - Setters && Getters

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    self.alertController.statusBarStyle = statusBarStyle;
}

- (void)setTapBackgroundViewDismiss:(BOOL)tapBackgroundViewDismiss {
    _tapBackgroundViewDismiss = tapBackgroundViewDismiss;
    self.alertController.tapBackgroundViewDismiss = tapBackgroundViewDismiss;
    self.alert.config.LeeClickBackgroundClose(tapBackgroundViewDismiss);
}

- (void)setActionAxis:(UILayoutConstraintAxis)actionAxis {
    _actionAxis = actionAxis;
    self.alertController.actionAxis = actionAxis;
}

- (void)setMinDistanceToEdges:(CGFloat)minDistanceToEdges {
    _minDistanceToEdges = minDistanceToEdges;
    self.alertController.minDistanceToEdges = minDistanceToEdges;
    
    CGFloat maxW = [UIApplication sharedApplication].delegate.window.bounds.size.width - (minDistanceToEdges * 2);
    self.alert.config.LeeMaxWidth(maxW);
}

- (NSArray <DYAlertAction *>*)actions {
    return self.alertController.actions;
}

- (DYAlertController *)alertController {
    if (!_alertController) {
        _alertController = [[DYAlertController alloc]init];
    }
    return _alertController;
}

- (UILabel *)titleLabel {
    return self.alertController.titleLabel;
}

- (UILabel *)messageLabel {
    return self.alertController.messageLabel;
}

- (DYAlertAction *)cancelAction {
    return _cancelAction;
}

- (DYAlertAction *)confirmAction {
    return _confirmAction;
}


#pragma mark --> 🐷 New Alert 🐷

-(LEEAlertConfig *)alert{
    if (!_alert) {
        _alert = [LEEAlert alert];
        _alert.config.LeeHeaderInsets(UIEdgeInsetsMake(15, 15, 15, 15));
        
    }
    return _alert;
}
-(void)setHeaderInsets:(UIEdgeInsets)headerInsets{
    _headerInsets = headerInsets;
    self.alert.config.LeeHeaderInsets(headerInsets);
}
- (void)addTitle:(void(^)(UILabel *label))label{
    self.alert.config
    .LeeAddTitle(label);
}

- (void)addNewAction:(ZMAlertSheetAction *)sheetAction{

    self.alert.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.borderWidth = sheetAction.borderWidth;
        action.borderColor = sheetAction.borderColor;
        action.title = sheetAction.title;
        action.titleColor = sheetAction.titleColor;
        action.highlightColor = sheetAction.highlightColor;
        action.font = sheetAction.font;
        action.height = sheetAction.height;
        action.type = sheetAction.type ;
        action.borderPosition = sheetAction.borderPosition;
        action.clickBlock = sheetAction.clickBlock;
        action.image = sheetAction.image;
        action.highlightImage = sheetAction.highlightImage;
        action.backgroundImage = sheetAction.backgroundImage;
        action.backgroundColor = sheetAction.backgroundColor;
        action.backgroundHighlightColor = sheetAction.backgroundHighlightColor;
        action.insets = sheetAction.insets;
        action.imageEdgeInsets = sheetAction.imageEdgeInsets;
        action.titleEdgeInsets = sheetAction.titleEdgeInsets;
        action.attributedTitle = sheetAction.attributedTitle;
        action.attributedHighlight = sheetAction.attributedHighlight;
    });

}

- (void)addCustomView:(UIView *)customView{
    
    self.alert.config
    .LeeAddCustomView(^(LEECustomView * _Nonnull custom) {
        custom.view = customView;
    });
}
- (void)addtemInsets:(UIEdgeInsets )insets{
    self.alert.config.LeeItemInsets(insets);
}
-(void)newShow{
    self.alert.config.LeeShow();
}
@end
