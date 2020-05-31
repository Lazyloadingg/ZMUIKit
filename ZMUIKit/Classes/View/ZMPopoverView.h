//
//  ZMPopoverView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 弹出气泡窗口视图
 */
/** 气泡弹出视图列表上的项目 */
@interface DYPopoverAction : NSObject

typedef void(^DYPopoverActionBlock)(DYPopoverAction *action);

/*! 是否显示红点 */
@property (nonatomic, assign) BOOL showIconBadge;

/*! 是否可点击 */
@property (nonatomic, assign) BOOL disable;

/*! 左侧图片角标（0就不显示） */
@property (nonatomic, assign) NSInteger badgeNumber;

/*! 项目标题 */
@property (nonatomic, copy, readonly) NSString *title;

/** 左侧icon */
@property (nonatomic, strong, readonly) UIImage * icon;

/*! 项目的点击事件回调 */
@property (nonatomic, copy, readonly) DYPopoverActionBlock popoverActionBlock;

/**
 创建项目
 
 @param title 标题
 @param handler 点击事件回调
 @return DYPopoverAction实例
 */
+ (instancetype)actionWithTitle:(NSString *)title handler:(DYPopoverActionBlock)handler;

+ (instancetype)actionWithTitle:(NSString *)title icon:(UIImage *)icon handler:(DYPopoverActionBlock)handler;

@end


/**
 内容类型

 - ZMPopoverViewContentTypeNormal: 内容类型 普通的提示
 - ZMPopoverViewContentTypeAlert: 内容类型 带按钮的提示
 - ZMPopoverViewContentTypeList: 内容类型 列表，默认宽度120
 - ZMPopoverViewContentTypeListWithCheck: 内容类型 列表,带点，默认宽度145
 - ZMPopoverViewContentTypeListIcon: 内容类型 左侧带图片列表，默认宽度140
 - ZMPopoverViewContentTypeCustom: 内容类型 自定义
 */
typedef NS_ENUM(NSUInteger, ZMPopoverViewContentType) {
    ZMPopoverViewContentTypeNormal,
    ZMPopoverViewContentTypeAlert,
    ZMPopoverViewContentTypeList,
    ZMPopoverViewContentTypeListWithCheck,
    ZMPopoverViewContentTypeListIcon,
    ZMPopoverViewContentTypeCustom
};

/**
 箭头的指向

 - DYPopoverDirectionUp: 箭头的指向  向上
 - DYPopoverDirectionDown: 箭头的指向  向下
 - DYPopoverDirectionLeft: 箭头的指向  向左
 - DYPopoverDirectionRight: 箭头的指向  向右
 */
typedef NS_ENUM(NSUInteger, DYPopoverDirection) {
    DYPopoverDirectionUp,
    DYPopoverDirectionDown,
    DYPopoverDirectionLeft,
    DYPopoverDirectionRight,
};

/**
 气泡弹出视图
 */
@interface ZMPopoverView : UIView

/** 是否已经弹出 */
@property (nonatomic, assign) BOOL isShowing;

/** 箭头所在位置的比例，默认为0.5.*/
@property (nonatomic, assign) CGFloat arrowPositionRatio;
/** 设置type为ZMPopoverViewContentTypeList和ZMPopoverViewContentTypeListWithCheck的宽度 */
/** PopoverView的内容类型 */
@property (nonatomic, assign) ZMPopoverViewContentType type;

/** 提示的标题。类型为 ZMPopoverViewContentTypeList 时无效。 */
@property (nonatomic, copy) NSString *title;

/** 是否开启点击外部隐藏弹窗，默认为YES。 */
@property (nonatomic, assign) BOOL hideWhenTouchOutside;

/** 背景阴影的背景颜色 */
@property (nonatomic, strong) UIColor *shadeBackgroundColor;

/** 背景阴影是否可以开启用户交互。默认为YES。当为YES时，点击事件无法透过阴影层。当为NO时，可以透过阴影响应阴影层下面的事件 */
@property (nonatomic, assign) BOOL shadeViewEnable;
/** 设置是否将遮盖起点视图，default to YES */
@property (nonatomic, assign) BOOL shouldMaskToView;
/** 是否显示箭头，default to YES */
@property (nonatomic, assign) BOOL shouldShowArrow;
/** 当前选择的索引，默认从0开始。注，只有在type为ZMPopoverViewContentTypeList和ZMPopoverViewContentTypeListWithCheck有效。 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 列表是否可以滑动，default to NO. */
@property (nonatomic, assign) BOOL listScrollEnable;
/** 设置背景阴影的点击事件。默认事件：隐藏气泡 */
@property (nonatomic, copy) void(^shadeTapBlock)(ZMPopoverView *sa_popoverView);

/** 气泡的最大宽度,可以不设置,目前只支持 DYPopoverDirectionUp 和 DYPopoverDirectionDown*/
@property (nonatomic, assign) CGFloat maxWidth;

/** 气泡的默认宽度 b，不设置的话会根据内容宽度计算*/
@property (nonatomic,assign) CGFloat defaultWidth;

/** 气泡的最大高度,可以不设置,目前只支持 DYPopoverDirectionUp 和 DYPopoverDirectionDown */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 设置 customView 并设置齐大小
 注：只有在 type 为 ZMPopoverViewContentTypeCustom 时才有效果。
 
 @param customView 自定义视图
 @param size 自定义视图的大小。注，气泡的大小会在此大小的基础上加15.0，四个方向都会加。
 */
- (void)setCustomView:(UIView *)customView size:(CGSize)size;

/**
 从某个视图弹出气泡弹框
 
 @param pointView 气泡弹框的弹出视图
 @param direction 箭头的指向
 @param onView 父视图
 */
- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView;

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction;

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView animated:(BOOL)animated;

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction animated:(BOOL)animated;

/**
 从某个坐标点弹出气泡弹框
 
 @param point 气泡弹框的弹出坐标点
 @param direction 箭头的指向
 @param onView 父视图
 */
- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView;

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction;

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView  animated:(BOOL)animated;

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction animated:(BOOL)animated;

/**
 隐藏气泡弹窗
 
 @param animated 是否有动画
 */
- (void)hide:(BOOL)animated;

/**
 添加气泡弹框列表上的项目
 注：在 ZMPopoverViewContentTypeList 类型时才有效
 
 @param action 单个项目
 */
- (void)addAction:(DYPopoverAction *)action;

/**
 添加气泡弹框列表上的项目
 注：在 ZMPopoverViewContentTypeList 类型时才有效
 
 @param actions 多个项目
 */
- (void)addActions:(NSArray <DYPopoverAction *>*)actions;

- (void)reloadListWithActions:(NSArray <DYPopoverAction *>*)actions;


@end

NS_ASSUME_NONNULL_END
