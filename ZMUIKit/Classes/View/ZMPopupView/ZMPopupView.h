//
//  ZMPopupView.h
//  ZMPopupView
//
//  Created by icochu on 2019/10/15.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>
//键盘高度
#define kPopupKeyboardHeightKey @"PopupKeyboardHeightKey"
//键盘弹出消失动画持续时间
#define kPopupKeyboardTimeKey   @"PopupKeyboardTimeKey"
typedef NS_ENUM(NSUInteger, DYPopupShowType) {
    DYPopupShowType_None,              //没有
    DYPopupShowType_FadeIn,            //淡入
    DYPopupShowType_GrowIn,            //成长
    DYPopupShowType_ShrinkIn,           //收缩
    DYPopupShowType_SlideInFromTop,     //从顶部，底部，左侧，右侧滑入
    DYPopupShowType_SlideInFromBottom,
    DYPopupShowType_SlideInFromLeft,
    DYPopupShowType_SlideInFromRight,
    DYPopupShowType_BounceIn,           //从顶部，底部，左侧，右侧，中心弹跳
    DYPopupShowType_BounceInFromTop,
    DYPopupShowType_BounceInFromBottom,
    DYPopupShowType_BounceInFromLeft,
    DYPopupShowType_BounceInFromRight
};

typedef NS_ENUM(NSUInteger, DYPopupDismissType) {
    DYPopupDismissType_None,
    DYPopupDismissType_FadeOut,
    DYPopupDismissType_GrowOut,
    DYPopupDismissType_ShrinkOut,
    DYPopupDismissType_SlideOutToTop,
    DYPopupDismissType_SlideOutToBottom,
    DYPopupDismissType_SlideOutToLeft,
    DYPopupDismissType_SlideOutToRight,
    DYPopupDismissType_BounceOut,
    DYPopupDismissType_BounceOutToTop,
    DYPopupDismissType_BounceOutToBottom,
    DYPopupDismissType_BounceOutToLeft,
    DYPopupDismissType_BounceOutToRight
};

//在水平方向上布置弹出窗口
typedef NS_ENUM(NSUInteger, DYPopupHorizontalLayout) {
    DYPopupHorizontalLayout_Custom,
    DYPopupHorizontalLayout_Left,
    DYPopupHorizontalLayout_LeftOfCenter,           //中心左侧
    DYPopupHorizontalLayout_Center,
    DYPopupHorizontalLayout_RightOfCenter,
    DYPopupHoricontalLayout_Right
};
//在垂直方向上布置弹出窗口
typedef NS_ENUM(NSUInteger, DYPopupVerticalLayout) {
    DYPopupVerticalLayout_Custom,
    DYPopupVerticalLayout_Top,
    DYPopupVerticalLayout_AboveCenter,              //中心偏上
    DYPopupVerticalLayout_Center,
    DYPopupVerticalLayout_BelowCenter,
    DYPopupVerticalLayout_Bottom
};

typedef NS_ENUM(NSUInteger, DYPopupMaskType) {
    //允许与底层视图交互
    DYPopupMaskType_None,
    //不允许与底层视图交互。
    DYPopupMaskType_Clear,
    //不允许与底层视图、背景进行交互。
    DYPopupMaskType_Dimmed
};

struct ZMPopupLayout {
    DYPopupHorizontalLayout horizontal;
    DYPopupVerticalLayout vertical;
};
typedef void(^popLayoutWithObjectBlock)(id);
typedef struct ZMPopupLayout ZMPopupLayout;

extern ZMPopupLayout ZMPopupLayoutMake(DYPopupHorizontalLayout horizontal, DYPopupVerticalLayout vertical);
//const ZMPopupLayout ZMPopupLayout_Bottom = { DYPopupHorizontalLayout_Center,DYPopupVerticalLayout_Bottom};
extern const ZMPopupLayout ZMPopupLayout_Center;
NS_ASSUME_NONNULL_BEGIN

@interface ZMPopupView : UIView

//自定义视图
@property (nonatomic, strong) UIView *contentView;
//弹出动画
@property (nonatomic, assign) DYPopupShowType showType;
//消失动画
@property (nonatomic, assign) DYPopupDismissType dismissType;
//交互类型
@property (nonatomic, assign) DYPopupMaskType maskType;
@property (nonatomic, assign) ZMPopupLayout layout;
//默认透明的0.5，通过这个属性可以调节
@property (nonatomic, assign) CGFloat dimmedMaskAlpha;
//提示透明度
@property (nonatomic, assign) CGFloat toastMaskAlpha;
//动画出现时间默认0.15
@property (nonatomic, assign) CGFloat showInDuration;
//动画消失时间默认0.15
@property (nonatomic, assign) CGFloat dismissOutDuration;
//当背景被触摸时，弹出窗口会消失。
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch;
//当内容视图被触摸时，弹出窗口会消失默认no
@property (nonatomic, assign) BOOL shouldDismissOnContentTouch;
//显示动画启动时回调。
@property (nonatomic, copy, nullable) void(^willStartShowingBlock)(void);
//显示动画完成启动时回调。
@property (nonatomic, copy, nullable) void(^didFinishShowingBlock)(void);
//显示动画将消失时回调。
@property (nonatomic, copy, nullable) void(^willStartDismissingBlock)(void);
//显示动画已经消失时回调。
@property (nonatomic, copy, nullable) void(^didFinishDismissingBlock)(void);
@property (nonatomic, copy, nullable) dispatch_block_t contentBlockClick;//视图点击点击回调
@property (nonatomic, copy, nullable) dispatch_block_t backgroundBlockClick;//空白处点击回调
@property (nonatomic,copy,nullable) popLayoutWithObjectBlock keyboardShowBlock;//键盘弹出回调
@property (nonatomic,copy,nullable) popLayoutWithObjectBlock keyboardHideBlock;//键盘消失回调
@property (nonatomic,assign) BOOL isShowKeyBoarding;//是否正在显示键盘
//背景视图
@property (nonatomic, strong, readonly) UIView *backgroundView;
//展现内容视图
@property (nonatomic, strong, readonly) UIView *containerView;
//是否开始展现
@property (nonatomic, assign, readonly) BOOL isBeingShown;
//正在展现
@property (nonatomic, assign, readonly) BOOL isShowing;
//开始消失
@property (nonatomic, assign, readonly) BOOL isBeingDismissed;
/**
 弹出一个自定义视图
 */
+ (ZMPopupView *)popupWithContentView:(UIView *)contentView;

//弹出提示框
+ (void)showToastVieWiththContent:(NSString *)content;

//弹出自定义文字提示框
+ (void)showToastVieWithAttributedContent:(NSAttributedString *)attributedString;


/**
 弹出自定义文字提示框
 @param content 提示文字
 @param showType 出现动画
 @param dismissType 消失动画
 @param time 停留时间，默认2秒
 */
+ (void)showToastVieWiththContent:(NSString *)content
                         showType:(DYPopupShowType)showType
                      dismissType:(DYPopupDismissType)dismissType
                         stopTime:(NSInteger)time;

//弹出自定义文字提示框
+ (void)showToastViewWithAttributedContent:(NSAttributedString *)attributedString
                                  showType:(DYPopupShowType)showType
                               dismissType:(DYPopupDismissType)dismissType
                                  stopTime:(NSInteger)time;
/**
 弹出一个自定义视图
 @param contentView 自定义视图
 @param showType 弹出动画
 @param dismissType 消失动画
 @param maskType 交互类型
 @param shouldDismissOnBackgroundTouch 当背景被触摸时，弹出窗口会消失 默认yes
 @param shouldDismissOnContentTouch 当内容视图被触摸时，弹出窗口会消失默认no
 @return 返回视图
 */
+ (ZMPopupView *)popupWithContentView:(UIView *)contentView
                             showType:(DYPopupShowType)showType
                          dismissType:(DYPopupDismissType)dismissType
                             maskType:(DYPopupMaskType)maskType
             dismissOnBackgroundTouch:(BOOL)shouldDismissOnBackgroundTouch
                dismissOnContentTouch:(BOOL)shouldDismissOnContentTouch;

+ (void)dismissAllPopups;

+ (void)dismissPopupForView:(UIView *)view animated:(BOOL)animated;

+ (void)dismissSuperPopupIn:(UIView *)view animated:(BOOL)animated;

- (void)show;

- (void)showWithLayout:(ZMPopupLayout)layout;

- (void)showWithDuration:(NSTimeInterval)duration;

- (void)showWithLayout:(ZMPopupLayout)layout duration:(NSTimeInterval)duration;

- (void)showAtCenterPoint:(CGPoint)point inView:(UIView *)view;

- (void)showAtCenterPoint:(CGPoint)point inView:(UIView *)view duration:(NSTimeInterval)duration;
/**
 取消所有提示
 @param animated 是否需要动画
 */
- (void)dismissAnimated:(BOOL)animated;

#pragma mark - 初始化顶部 底部视图
//顶部视图初始化
+ (ZMPopupView *) popupWithTopView:(UIView *) view;
//底部视图初始化
+ (ZMPopupView *) popupWithBottomView:(UIView *) view;

@end

NS_ASSUME_NONNULL_END
