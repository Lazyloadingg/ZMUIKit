//
//  ZMPopupView.m
//  ZMPopupView
//
//  Created by icochu on 2019/10/15.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "ZMPopupView.h"
#import "IQKeyboardManager.h"
static const CGFloat kDefaultSpringDamping = 0.8;
static const CGFloat kDefaultSpringVelocity = 10.0;
static const CGFloat kDefaultAnimateDuration = 0.15;
static const NSInteger kAnimationOptionCurve = (7 << 16);
static NSString *const kParametersViewName = @"parameters.view";
static NSString *const kParametersLayoutName = @"parameters.layout";
static NSString *const kParametersCenterName = @"parameters.center-point";
static NSString *const kParametersDurationName = @"parameters.duration";

ZMPopupLayout ZMPopupLayoutMake(DYPopupHorizontalLayout horizontal, DYPopupVerticalLayout vertical) {
    ZMPopupLayout layout;
    layout.horizontal = horizontal;
    layout.vertical = vertical;
    return layout;
}

const ZMPopupLayout ZMPopupLayout_Center = { DYPopupHorizontalLayout_Center,DYPopupVerticalLayout_Top}; //DYPopupVerticalLayout_Center };
//const ZMPopupLayout ZMPopupLayout_Bottom = { DYPopupHorizontalLayout_Center,DYPopupVerticalLayout_Bottom};
@interface NSValue (ZMPopupLayout)
+ (NSValue *)valueWithZMPopupLayout:(ZMPopupLayout)layout;
- (ZMPopupLayout)ZMPopupLayoutValue;
@end

@interface UIView (DYPopup)
- (void)containsPopupBlock:(void (^)(ZMPopupView *popup))block;
- (void)dismissShowingPopup:(BOOL)animated;
@end

@interface ZMPopupView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isBeingShown;
@property (nonatomic, assign) BOOL isBeingDismissed;
@property (nonatomic, assign) BOOL dismissAnimate;
@end

@implementation ZMPopupView

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = UIColor.clearColor;
        self.alpha = 0.0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        
        self.shouldDismissOnBackgroundTouch = YES;
        self.shouldDismissOnContentTouch = NO;
        
        self.showType = DYPopupShowType_BounceInFromTop;
        self.dismissType = DYPopupDismissType_BounceOutToBottom;
        self.maskType = DYPopupMaskType_Dimmed;
        self.dimmedMaskAlpha = 0.5;
        self.toastMaskAlpha = 0.6;
        _isBeingShown = NO;
        _isShowing = NO;
        _isBeingDismissed = NO;
        
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.containerView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusbarOrientation:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
//    NSLog(@"hitTest");
    if (hitView == self) {
        if (self.backgroundBlockClick) {
            self.backgroundBlockClick();
        }
          
        if (_shouldDismissOnBackgroundTouch) {
            [self dismissAnimated:YES];
        }
        return _maskType == DYPopupMaskType_None ? nil : hitView;
    } else {
        if (self.contentBlockClick) {
           self.contentBlockClick();
         }
        if ([hitView isDescendantOfView:_containerView] && _shouldDismissOnContentTouch) {
            [self dismissAnimated:YES];
        }
        return hitView;
    }
   
}

#pragma mark - Public Class Methods
+ (ZMPopupView *)popupWithContentView:(UIView *)contentView {
    ZMPopupView *popup = [[[self class] alloc] init];
    popup.contentView = contentView;
    return popup;
}

+ (void)showToastVieWiththContent:(NSString *)content {
    [self showToastVieWiththContent:content showType:DYPopupShowType_GrowIn dismissType:DYPopupDismissType_ShrinkOut stopTime:1.5];
}

+ (void)showToastVieWithAttributedContent:(NSAttributedString *)attributedString {
    [self showToastViewWithAttributedContent:attributedString showType:DYPopupShowType_GrowIn dismissType:DYPopupDismissType_None stopTime:1.5];
}

+ (void)showToastViewWithAttributedContent:(NSAttributedString *)attributedString
showType:(DYPopupShowType)showType
dismissType:(DYPopupDismissType)dismissType
stopTime:(NSInteger)time {
    ZMPopupView *popup = [[[self class] alloc] init];
    UIView *contentView = [popup toastViewWithContentString:@"" AttributedString:attributedString];
    popup.contentView = contentView;
    popup.showType = showType;
    popup.dismissType = dismissType;
    [popup showWithDuration:time];
}

+ (void)showToastVieWiththContent:(NSString *)content
showType:(DYPopupShowType)showType
dismissType:(DYPopupDismissType)dismissType
stopTime:(NSInteger)time {
    ZMPopupView *popup = [[[self class] alloc] init];
    UIView *contentView = [popup toastViewWithContentString:content AttributedString:nil];
    popup.contentView = contentView;
    popup.showType = showType;
    popup.dismissType = dismissType;
    popup.maskType = DYPopupMaskType_None;
    [popup showWithDuration:time];
    
}
+ (ZMPopupView *)popupWithContentView:(UIView *)contentView
showType:(DYPopupShowType)showType
dismissType:(DYPopupDismissType)dismissType
maskType:(DYPopupMaskType)maskType
dismissOnBackgroundTouch:(BOOL)shouldDismissOnBackgroundTouch
dismissOnContentTouch:(BOOL)shouldDismissOnContentTouch {
    ZMPopupView *popup = [[[self class] alloc] init];
    popup.contentView = contentView;
    popup.showType = showType;
    popup.dismissType = dismissType;
    popup.maskType = maskType;
    popup.shouldDismissOnBackgroundTouch = shouldDismissOnBackgroundTouch;
    popup.shouldDismissOnContentTouch = shouldDismissOnContentTouch;
    return popup;
}


+ (void)dismissAllPopups {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        [window containsPopupBlock:^(ZMPopupView * _Nonnull popup) {
            [popup dismissAnimated:NO];
        }];
    }
}

+ (void)dismissPopupForView:(UIView *)view animated:(BOOL)animated {
    [view dismissShowingPopup:animated];
}

+ (void)dismissSuperPopupIn:(UIView *)view animated:(BOOL)animated {
    [view dismissShowingPopup:animated];
}

#pragma mark - Public Instance Methods
- (void)show {
    //[self showWithLayout:ZMPopupLayout_Center];
    [self showWithLayout:self.layout];
}

- (void)showWithLayout:(ZMPopupLayout)layout {
    [self showWithLayout:layout duration:0.0];
    [self addNotiKeyboard];
}

- (void)showWithDuration:(NSTimeInterval)duration {
    [self showWithLayout:ZMPopupLayout_Center duration:duration];
}

- (void)showWithLayout:(ZMPopupLayout)layout duration:(NSTimeInterval)duration {
    NSDictionary *parameters = @{kParametersLayoutName: [NSValue valueWithZMPopupLayout:layout],
                                 kParametersDurationName: @(duration)};
    [self showWithParameters:parameters];
}

- (void)showAtCenterPoint:(CGPoint)point inView:(UIView *)view {
    [self showAtCenterPoint:point inView:view duration:0.0];
}

- (void)showAtCenterPoint:(CGPoint)point inView:(UIView *)view duration:(NSTimeInterval)duration {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSValue valueWithCGPoint:point] forKey:kParametersCenterName];
    [parameters setValue:@(duration) forKey:kParametersDurationName];
    [parameters setValue:view forKey:kParametersViewName];
    [self showWithParameters:parameters.mutableCopy];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismiss:animated];
    [self removeNotiKeyboard];
}
#pragma mark - 监听键盘事件
//添加监听事件
-(void) addNotiKeyboard{
    //键盘将要显示时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    //键盘将要结束时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    self.isShowKeyBoarding = false;
}
//删除监听事件
-(void) removeNotiKeyboard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘相关操作
//键盘将要显示
-(void)boardWillShow:(NSNotification *)notification{
    NSLog(@"键盘显示");
    if (self.isShowKeyBoarding) {
        return;
    }
    self.isShowKeyBoarding = true;
    if (self.keyboardShowBlock) {
        self.keyboardShowBlock(notification);
    }
//    //获取键盘高度，
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//
//    //键盘弹出的时间
//    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//      //改变输入框的y值和view的高度
//        self.contentView.frame = CGRectMake(0, self.contentView.frame.origin.y - kbHeight, self.contentView.frame.size.width, self.contentView.frame.size.height);
////        self.mainTableView.height = kHeight - 50 - kbHeight;
////
//    }];
    
}

//键盘将要结束
-(void)boardDidHide:(NSNotification *)notification{
    NSLog(@"键盘消失");
    if (self.isShowKeyBoarding) {
        self.isShowKeyBoarding = false;
    }
    if (self.keyboardHideBlock) {
         self.keyboardHideBlock(notification);
     }
    //    //获取键盘高度，
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//     //恢复输入框的y值和view的高度
////    self.bottomView.y = kHeight - 50 ;
////    self.mainTableView.height = kHeight - 50;
////    self.messageView.placeholder = @"请输入留言信息";
//      [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//          //改变输入框的y值和view的高度
//            self.contentView.frame = CGRectMake(0, self.contentView.frame.origin.y - kbHeight, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    //        self.mainTableView.height = kHeight - 50 - kbHeight;
//    //
//        }];
    
}
#pragma mark - 初始化
//顶部视图初始化
+ (ZMPopupView *) popupWithTopView:(UIView *) view{
    ZMPopupView *popView = [ZMPopupView popupWithContentView:view showType:DYPopupShowType_SlideInFromTop dismissType:DYPopupDismissType_SlideOutToTop maskType:DYPopupMaskType_Clear dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    popView.layout = ZMPopupLayout_Center;
    return popView;
}
//底部视图初始化
+ (ZMPopupView *) popupWithBottomView:(UIView *) view{
    ZMPopupView *popView = [ZMPopupView popupWithContentView:view showType:DYPopupShowType_SlideInFromBottom dismissType:DYPopupDismissType_SlideOutToBottom maskType:DYPopupMaskType_Clear dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    ZMPopupLayout layout;
    layout.horizontal = DYPopupHorizontalLayout_Center;
    layout.vertical = DYPopupVerticalLayout_Bottom;
    popView.layout = layout;
    return popView;
}

#pragma mark - Private Methods
- (UIView *)toastViewWithContentString:(NSString *)content AttributedString:(NSAttributedString *)attributedString {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    bgView.alpha = self.toastMaskAlpha;
    bgView.layer.cornerRadius = 6;
    
    UILabel *toastLable = [UILabel new];
    toastLable.font = [UIFont systemFontOfSize:17];
    toastLable.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];;
    if (content.length > 0) {
        toastLable.text = content;
    }else {
        toastLable.attributedText = attributedString;
    }
    toastLable.numberOfLines = 0;
    [bgView addSubview:toastLable];
    [self setupTextToastWithLable:toastLable View:bgView];
    return bgView;
}

- (void)setupTextToastWithLable:(UILabel *)messageLabel View:(UIView *)bgView {
    
    bgView.frame = [self toastFrameWithLable:messageLabel];
    messageLabel.frame = [self  toastLabelFrameWithbgViewFrame:bgView.frame];
}

- (CGRect)toastFrameWithLable:(UILabel *)msgLable {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize constrantSize = CGSizeMake(frame.size.width - 40, frame.size.height - 40);
    NSDictionary *attr = @{NSFontAttributeName:msgLable.font};
    NSString *msg = [NSString stringWithFormat:@"%@",msgLable.text];
    CGSize size = [msg boundingRectWithSize:constrantSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attr
                                    context:nil].size;
    size = CGSizeMake(size.width + 46, size.height + 30);
    CGFloat x = 20 + (constrantSize.width - 46 - size.width) * 0.5;
    CGFloat y = 15 + (constrantSize.height - 30 - size.height) * 0.5;
    CGRect fr = CGRectMake(x ,y ,size.width ,size.height);
    return fr;
}

- (CGRect)toastLabelFrameWithbgViewFrame:(CGRect)bgFrame{
    CGRect fr = CGRectMake(23, 15,bgFrame.size.width - 23 * 2,bgFrame.size.height - 15 * 2);
    return fr;
}


- (void)showWithParameters:(NSDictionary *)parameters {
    //
    if (!_isBeingShown && !_isShowing && !_isBeingDismissed) {
        _isBeingShown = YES;
        _isShowing = NO;
        _isBeingDismissed = NO;
        
        if (self.willStartShowingBlock != nil) {
            self.willStartShowingBlock();
        }
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //准备弹出
            if (!strongSelf.superview) {
//                NSEnumerator *reverseWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
//                for (UIWindow *window in reverseWindows) {
//                    if (window.windowLevel == UIWindowLevelNormal) {
//                        [window addSubview:self];
                        //[[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
//                        [[[[UIApplication sharedApplication] windows] lastObject] sendSubviewToBack:self];
                        [[UIApplication sharedApplication].delegate.window addSubview:self];
//                          [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//                         [[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
//                        break;
//                    }
//                }
            }
            
            [strongSelf updateInterfaceOrientation];
            
            strongSelf.hidden = NO;
            strongSelf.alpha = 1.0;
            
            //设置背景视图
            strongSelf.backgroundView.alpha = 0.0;
//            if (strongSelf.maskType == DYPopupMaskType_Dimmed) {
                strongSelf.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:strongSelf.dimmedMaskAlpha]; //[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:strongSelf.dimmedMaskAlpha];
//            } else {
//                strongSelf.backgroundView.backgroundColor = UIColor.clearColor;
//            }
            
            //判断是否需要动画
            void (^backgroundAnimationBlock)(void) = ^(void) {
                strongSelf.backgroundView.alpha = 1.0;
            };
            
            //展示动画
            if (strongSelf.showType != DYPopupShowType_None) {
                CGFloat showInDuration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                [UIView animateWithDuration:showInDuration
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:backgroundAnimationBlock
                                 completion:NULL];
            } else {
                backgroundAnimationBlock();
            }
            
            //设置自动消失事件
            NSNumber *durationNumber = parameters[kParametersDurationName];
            NSTimeInterval duration = durationNumber != nil ? durationNumber.doubleValue : 0.0;
            
            void (^completionBlock)(BOOL) = ^(BOOL finished) {
                strongSelf.isBeingShown = NO;
                strongSelf.isShowing = YES;
                strongSelf.isBeingDismissed = NO;
                if (strongSelf.didFinishShowingBlock) {
                    strongSelf.didFinishShowingBlock();
                }
                
                if (duration > 0.0) {
                    [strongSelf performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
                }
            };
            
            if (strongSelf.contentView.superview != strongSelf.containerView) {
                [strongSelf.containerView addSubview:strongSelf.contentView];
            }
            
            [strongSelf.contentView layoutIfNeeded];
            
            CGRect containerFrame = strongSelf.containerView.frame;
            containerFrame.size = strongSelf.contentView.frame.size;
            strongSelf.containerView.frame = containerFrame;
            
            CGRect contentFrame = strongSelf.contentView.frame;
            contentFrame.origin = CGPointZero;
            strongSelf.contentView.frame = contentFrame;
            
            UIView *contentView = strongSelf.contentView;
            NSDictionary *viewsDict = NSDictionaryOfVariableBindings(contentView);
            [strongSelf.containerView removeConstraints:strongSelf.containerView.constraints];
            [strongSelf.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:viewsDict]];
            [strongSelf.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:viewsDict]];
            
            CGRect finalContainerFrame = containerFrame;
            UIViewAutoresizing containerAutoresizingMask = UIViewAutoresizingNone;
            
            NSValue *centerValue = parameters[kParametersCenterName];
            if (centerValue) {
                CGPoint centerInView = centerValue.CGPointValue;
                CGPoint centerInSelf;
                /// Convert coordinates from provided view to self.
                UIView *fromView = parameters[kParametersViewName];
                centerInSelf = fromView != nil ? [self convertPoint:centerInView toView:fromView] : centerInView;
                finalContainerFrame.origin.x = centerInSelf.x - CGRectGetWidth(finalContainerFrame)*0.5;
                finalContainerFrame.origin.y = centerInSelf.y - CGRectGetHeight(finalContainerFrame)*0.5;
                containerAutoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            } else {
                
                NSValue *layoutValue = parameters[kParametersLayoutName];
                ZMPopupLayout layout = layoutValue ? [layoutValue ZMPopupLayoutValue] : ZMPopupLayout_Center;
                switch (layout.horizontal) {
                    case DYPopupHorizontalLayout_Left:
                        finalContainerFrame.origin.x = 0.0;
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleRightMargin;
                        break;
                    case DYPopupHoricontalLayout_Right:
                        finalContainerFrame.origin.x = CGRectGetWidth(strongSelf.bounds) - CGRectGetWidth(containerFrame);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin;
                        break;
                    case DYPopupHorizontalLayout_LeftOfCenter:
                        finalContainerFrame.origin.x = floorf(CGRectGetWidth(strongSelf.bounds) / 3.0 - CGRectGetWidth(containerFrame) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                        break;
                    case DYPopupHorizontalLayout_RightOfCenter:
                        finalContainerFrame.origin.x = floorf(CGRectGetWidth(strongSelf.bounds) * 2.0 / 3.0 - CGRectGetWidth(containerFrame) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                        break;
                    case DYPopupHorizontalLayout_Center:
                        finalContainerFrame.origin.x = floorf((CGRectGetWidth(strongSelf.bounds) - CGRectGetWidth(containerFrame)) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                        break;
                    default:
                        break;
                }
                
                switch (layout.vertical) {
                    case DYPopupVerticalLayout_Top:
                        finalContainerFrame.origin.y = 0.0;
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleBottomMargin;
                        break;
                    case DYPopupVerticalLayout_AboveCenter:
                        finalContainerFrame.origin.y = floorf(CGRectGetHeight(self.bounds) / 3.0 - CGRectGetHeight(containerFrame) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                        break;
                    case DYPopupVerticalLayout_Center:{
                        finalContainerFrame.origin.y = 0.0;

                       // finalContainerFrame.origin.y = floorf((CGRectGetHeight(self.bounds) - CGRectGetHeight(containerFrame)) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                    }
                        break;
                    case DYPopupVerticalLayout_BelowCenter:
                        finalContainerFrame.origin.y = floorf(CGRectGetHeight(self.bounds) * 2.0 / 3.0 - CGRectGetHeight(containerFrame) * 0.5);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                        break;
                    case DYPopupVerticalLayout_Bottom:
                        finalContainerFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(containerFrame);
                        containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin;
                        break;
                    default:
                        break;
                }
            }
            
            strongSelf.containerView.autoresizingMask = containerAutoresizingMask;
            
            switch (strongSelf.showType) {
                case DYPopupShowType_FadeIn: {
                    strongSelf.containerView.alpha = 0.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    strongSelf.containerView.frame = finalContainerFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        strongSelf.containerView.alpha = 1.0;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_GrowIn: {
                    strongSelf.containerView.alpha = 0.0;
                    strongSelf.containerView.frame = finalContainerFrame;
                    strongSelf.containerView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.alpha = 1.0;
                        strongSelf.containerView.transform = CGAffineTransformIdentity;
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_ShrinkIn: {
                    strongSelf.containerView.alpha = 0.0;
                    strongSelf.containerView.frame = finalContainerFrame;
                    strongSelf.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.alpha = 1.0;
                        strongSelf.containerView.frame = finalContainerFrame;
                        strongSelf.containerView.transform = CGAffineTransformIdentity;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_SlideInFromTop: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.y = - CGRectGetHeight(finalContainerFrame);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_SlideInFromBottom: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.y = CGRectGetHeight(self.bounds);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_SlideInFromLeft: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.x = - CGRectGetWidth(finalContainerFrame);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_SlideInFromRight: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.x = CGRectGetWidth(self.bounds);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 options:kDefaultAnimateDuration animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_BounceIn: {
                    strongSelf.containerView.alpha = 0.0;
                    strongSelf.containerView.frame = finalContainerFrame;
                    strongSelf.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:kDefaultSpringDamping initialSpringVelocity:kDefaultSpringVelocity options:0 animations:^{
                        strongSelf.containerView.alpha = 1.0;
                        strongSelf.containerView.transform = CGAffineTransformIdentity;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_BounceInFromTop: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.y = - CGRectGetHeight(finalContainerFrame);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:kDefaultSpringDamping initialSpringVelocity:kDefaultSpringVelocity options:0 animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_BounceInFromBottom: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.y = CGRectGetHeight(self.bounds);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:kDefaultSpringDamping initialSpringVelocity:kDefaultSpringVelocity options:0 animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_BounceInFromLeft: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.x = - CGRectGetWidth(finalContainerFrame);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:kDefaultSpringDamping initialSpringVelocity:kDefaultSpringVelocity options:0 animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupShowType_BounceInFromRight: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    CGRect startFrame = finalContainerFrame;
                    startFrame.origin.x = CGRectGetWidth(self.bounds);
                    strongSelf.containerView.frame = startFrame;
                    CGFloat duration = strongSelf.showInDuration ?: kDefaultAnimateDuration;
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:kDefaultSpringDamping initialSpringVelocity:kDefaultSpringVelocity options:0 animations:^{
                        strongSelf.containerView.frame = finalContainerFrame;
                    } completion:completionBlock];
                }   break;
                default: {
                    strongSelf.containerView.alpha = 1.0;
                    strongSelf.containerView.frame = finalContainerFrame;
                    strongSelf.containerView.transform = CGAffineTransformIdentity;
                    completionBlock(YES);
                }   break;
            }
        });
    }
}

- (void)dismiss:(BOOL)animated {
    if (_isShowing && !_isBeingDismissed) {
        _isShowing = NO;
        _isBeingShown = NO;
        _isBeingDismissed = YES;
        _dismissAnimate = animated;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        
        if (self.willStartDismissingBlock) {
            self.willStartDismissingBlock();
        }
        float delelaySec = 0.2;
        if ([UIDevice currentDevice].systemVersion.doubleValue < 13.0) {
            delelaySec = 0.1;
        }
        [self performSelector:@selector(dismissPopView) withObject:nil afterDelay:delelaySec];
    }
}
-(void) dismissPopView{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = self;
        void (^backgroundAnimationBlock)(void) = ^(void) {
            strongSelf.backgroundView.alpha = 0.0;
        };
        
        if (self.dismissAnimate && strongSelf.showType != DYPopupShowType_None) {
            CGFloat duration = strongSelf.dismissOutDuration ?: kDefaultAnimateDuration;
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:backgroundAnimationBlock completion:NULL];
        } else {
            backgroundAnimationBlock();
        }
        
        void (^completionBlock)(BOOL) = ^(BOOL finished) {
            [strongSelf.backgroundView removeFromSuperview];
            [strongSelf.contentView removeFromSuperview];
            [strongSelf removeFromSuperview];
            strongSelf.isBeingShown = NO;
            strongSelf.isShowing = NO;
            strongSelf.isBeingDismissed = NO;
            if (strongSelf.didFinishDismissingBlock) {
                strongSelf.didFinishDismissingBlock();
            }
        };
        
        NSTimeInterval duration = strongSelf.dismissOutDuration ?: kDefaultAnimateDuration;
        NSTimeInterval bounceDurationA = duration * 1.0 / 3.0;
        NSTimeInterval bounceDurationB = duration * 2.0 / 3.0;
        
        /// Animate contentView if needed.
        if (self.dismissAnimate) {
            NSTimeInterval dismissOutDuration = strongSelf.dismissOutDuration ?: kDefaultAnimateDuration;
            switch (strongSelf.dismissType) {
                case DYPopupDismissType_FadeOut: {
                    [UIView animateWithDuration:dismissOutDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                        strongSelf.containerView.alpha = 0.0;
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_GrowOut: {
                    [UIView animateKeyframesWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.alpha = 0.0;
                        strongSelf.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_ShrinkOut: {
                    [UIView animateWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.alpha = 0.0;
                        strongSelf.containerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_SlideOutToTop: {
                    CGRect finalFrame = strongSelf.containerView.frame;
                    finalFrame.origin.y = - CGRectGetHeight(finalFrame);
                    [UIView animateWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_SlideOutToBottom: {
                    CGRect finalFrame = strongSelf.containerView.frame;
                    finalFrame.origin.y = CGRectGetHeight(strongSelf.bounds);
    //                        [UIView animateWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
    //                            strongSelf.containerView.frame = finalFrame;
    //                        } completion:completionBlock];
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [UIView animateWithDuration:0.4 animations:^(){
                             self.containerView.frame = finalFrame;
                         } completion:completionBlock];
                     });
                }   break;
                case DYPopupDismissType_SlideOutToLeft: {
                    CGRect finalFrame = strongSelf.containerView.frame;
                    finalFrame.origin.x = - CGRectGetWidth(finalFrame);
                    [UIView animateWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_SlideOutToRight: {
                    CGRect finalFrame = strongSelf.containerView.frame;
                    finalFrame.origin.x = CGRectGetWidth(strongSelf.bounds);
                    [UIView animateWithDuration:dismissOutDuration delay:0.0 options:kAnimationOptionCurve animations:^{
                        strongSelf.containerView.frame = finalFrame;
                    } completion:completionBlock];
                }   break;
                case DYPopupDismissType_BounceOut: {
                    [UIView animateWithDuration:bounceDurationA delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        strongSelf.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:bounceDurationB delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            strongSelf.containerView.alpha = 0.0;
                            strongSelf.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                        } completion:completionBlock];
                    }];
                }   break;
                case DYPopupDismissType_BounceOutToTop: {
                    CGRect finalFrameA = strongSelf.containerView.frame;
                    finalFrameA.origin.y += 20.0;
                    CGRect finalFrameB = strongSelf.containerView.frame;
                    finalFrameB.origin.y = - CGRectGetHeight(finalFrameB);
                    [UIView animateWithDuration:bounceDurationA delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        strongSelf.containerView.frame = finalFrameA;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:bounceDurationB delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            strongSelf.containerView.frame = finalFrameB;
                        } completion:completionBlock];
                    }];
                }   break;
                case DYPopupDismissType_BounceOutToBottom: {
                    CGRect finalFrameA = strongSelf.containerView.frame;
                    finalFrameA.origin.y -= 20;
                    CGRect finalFrameB = strongSelf.containerView.frame;
                    finalFrameB.origin.y = CGRectGetHeight(self.bounds);
                    [UIView animateWithDuration:bounceDurationA delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        strongSelf.containerView.frame = finalFrameA;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:bounceDurationB delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            strongSelf.containerView.frame = finalFrameB;
                        } completion:completionBlock];
                    }];
                }   break;
                case DYPopupDismissType_BounceOutToLeft: {
                    CGRect finalFrameA = strongSelf.containerView.frame;
                    finalFrameA.origin.x += 20.0;
                    CGRect finalFrameB = strongSelf.containerView.frame;
                    finalFrameB.origin.x = - CGRectGetWidth(finalFrameB);
                    [UIView animateWithDuration:bounceDurationA delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        strongSelf.containerView.frame = finalFrameA;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:bounceDurationB delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            strongSelf.containerView.frame = finalFrameB;
                        } completion:completionBlock];
                    }];
                }   break;
                case DYPopupDismissType_BounceOutToRight: {
                    CGRect finalFrameA = strongSelf.containerView.frame;
                    finalFrameA.origin.x -= 20.0;
                    CGRect finalFrameB = strongSelf.containerView.frame;
                    finalFrameB.origin.x = CGRectGetWidth(strongSelf.bounds);
                    [UIView animateWithDuration:bounceDurationA delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        strongSelf.containerView.frame = finalFrameA;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:bounceDurationB delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            strongSelf.containerView.frame = finalFrameB;
                        } completion:completionBlock];
                    }];
                }   break;
                default: {
                    strongSelf.containerView.alpha = 0.0;
                    completionBlock(YES);
                }   break;
            }
        } else {
            strongSelf.containerView.alpha = 0.0;
            completionBlock(YES);
        }
    });
}

- (void)didChangeStatusbarOrientation:(NSNotification *)notification {
    [self updateInterfaceOrientation];
}

- (void)updateInterfaceOrientation {
    self.frame = self.window.bounds;
}

- (void)dismiss {
    [self dismiss:YES];
}

#pragma mark - Properties
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColor.clearColor;
        _backgroundView.userInteractionEnabled = NO;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.frame = self.bounds;
    }
    return _backgroundView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.autoresizesSubviews = NO;
        _containerView.userInteractionEnabled = YES;
        _containerView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

@end

@implementation NSValue (ZMPopupLayout)
+ (NSValue *)valueWithZMPopupLayout:(ZMPopupLayout)layout {
    return [NSValue valueWithBytes:&layout objCType:@encode(ZMPopupLayout)];
}

- (ZMPopupLayout)ZMPopupLayoutValue {
    ZMPopupLayout layout;
    [self getValue:&layout];
    return layout;
}

@end

@implementation UIView (DYPopup)
- (void)containsPopupBlock:(void (^)(ZMPopupView *popup))block {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[ZMPopupView class]]) {
            block((ZMPopupView *)subview);
        } else {
            [subview containsPopupBlock:block];
        }
    }
}

- (void)dismissShowingPopup:(BOOL)animated {
    UIView *view = self;
    while (view) {
        if ([view isKindOfClass:[ZMPopupView class]]) {
            [(ZMPopupView *)view dismissAnimated:animated];
            break;
        }
        view = view.superview;
    }
}
@end
