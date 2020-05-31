//
//  ZMPopupViewController.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import <UIKit/UIKit.h>
#import "ZMPopupControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 布局类型

 - ZMPopupLayoutTypeRightTop: 右上
 - ZMPopupLayoutTypeRightBottom: 右下
 - ZMPopupLayoutTypeLeftTop: 左上
 - ZMPopupLayoutTypeLeftBottom: 左下
 - ZMPopupLayoutTypeCenter: 中
 */
typedef NS_ENUM(NSInteger, ZMPopupLayoutType) {
    ZMPopupLayoutTypeRightTop = 0,
    ZMPopupLayoutTypeRightBottom,
    ZMPopupLayoutTypeLeftTop,
    ZMPopupLayoutTypeLeftBottom,
    ZMPopupLayoutTypeCenter
};

/**
 Transition 方向类型

 - DYPopupTransitionStyleFromRight: 右
 - DYPopupTransitionStyleFromLeft: 左
 - DYPopupTransitionStyleFromTop: 上
 - DYPopupTransitionStyleFromBottom: 下
 - DYPopupTransitionStyleCover: Cover
 */
typedef NS_ENUM(NSInteger, DYPopupTransitionStyle) {
    DYPopupTransitionStyleFromRight = 0,
    DYPopupTransitionStyleFromLeft,
    DYPopupTransitionStyleFromTop,
    DYPopupTransitionStyleFromBottom,
    DYPopupTransitionStyleCover
};

/**
 圆角方向

 - DYRectCornerTopLeft: 左上
 - DYRectCornerTopRight: 右上
 - DYRectCornerBottomLeft: 左下
 - DYRectCornerBottomRight: 右下
 - DYRectCornerAllCorners: all
 */
typedef NS_OPTIONS(NSUInteger, DYRectCorner) {
    DYRectCornerTopLeft     = 1 << 0,
    DYRectCornerTopRight    = 1 << 1,
    DYRectCornerBottomLeft  = 1 << 2,
    DYRectCornerBottomRight = 1 << 3,
    DYRectCornerAllCorners  = ~0UL
};

/**
 弹出视图控制器的基类
 */
@interface ZMPopupViewController : UIViewController <ZMPopupControllerProtocol>

/*! 是否已经展示 */
@property (nonatomic, assign, readonly) BOOL isShowed;

/*! 横向空白区域的比例，空白区域能够点击隐藏.默认为 0 */
@property (nonatomic, assign) CGFloat spaceRatio;

/** 弹出视图控制器的内容视图，宽度比为（1-spaceRatio）。 */
@property (nonatomic, strong, readonly) UIView *contentView;

/** 滑动隐藏手势事件回调 */
@property (nonatomic, copy) dispatch_block_t didSwipeBlock;

/** 蒙版点击事件回调 */
@property (nonatomic, copy) dispatch_block_t didClickMaskBlock;

/*! 弹出视图的弹出动画，默认 DYPopupTransitionStyleFromBottom。注：子类最好在初始化方法中设定 */
@property (nonatomic, assign) DYPopupTransitionStyle transitionStyle;

/*! 弹出视图 contentView 的对齐方式，默认 ZMPopupLayoutTypeLeft Bottom。注：子类最好在初始化方法中设定 */
@property (nonatomic, assign) ZMPopupLayoutType layoutType;

/** 轻扫隐藏手势是否可用。默认YES。注：轻扫方向与视图弹出方向相反。DYPopupTransitionStyleCover时，手势无效 */
@property (nonatomic, assign) BOOL swipeGesEnable;

/** 轻扫隐藏手势在内容视图上是否有效。默认YES。注：必须在 swipeGesEnable 为 yes 时设置才有效 */
@property (nonatomic, assign) BOOL contentViewSwipeGesEnable;

/** 点击空白区域隐藏手势是否可用。默认YES。 */
@property (nonatomic, assign) BOOL tapGesEnable;

/** 设置 contentView 的高度，当值小于等于0时，其高度等于self.view的高度。默认0。 */
@property (nonatomic, assign) CGFloat contentViewHeight;

/** 顶部安全区域颜色，默认白色，左侧、右侧或者顶部滑出时才有效 */
@property (nonatomic, strong) UIColor *topSafeAreaColor;

/** 底部安全区域颜色，默认白色，左侧、右侧或者底部部滑出时才有效 */
@property (nonatomic, strong) UIColor *bottomSafeAreaColor;

/** 左侧安全区域颜色，默认白色，主要用于横屏的适配 */
@property (nonatomic, strong) UIColor *leftSafeAreaColor;

/** 右侧安全区域颜色，默认白色，主要用于横屏的适配 */
@property (nonatomic, strong) UIColor *rightSafeAreaColor;

/**
 设置弹出视图的圆角，大小(3, 3)
 
 @param corners 圆角的位置
 */
- (void)setBorderCorners:(DYRectCorner)corners;

/**
 设置弹出视图的圆角
 
 @param corners 圆角的位置
 @param cornerRadii 圆角的大小
 */
- (void)setBorderCorners:(DYRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end



@interface UIViewController (DYEdgePanGestrueRecognizer)

/**
 添加边缘滑动手势。默认左滑，并且从当前控制器中滑出。
 注：添加边缘手势之前，请先确定弹出视图的弹出动画类型，只有动画类型为 DYPopupTransitionStyleFromRight 和 DYPopupTransitionStyleFromLeft 才能够添加上。添加之前请先确定动画类型。
 @param popupVC 弹出视图实例对象
 */
- (void)addEdgeGestrueRecognizer:(ZMPopupViewController *)popupVC;

/**
 添加边缘滑动手势。默认左滑。
 
 @param popupVC 弹出视图实例对象
 @param showFormController popupVC 实例对象的父控制器
 */
- (void)addEdgeGestrueRecognizer:(ZMPopupViewController *)popupVC showFormController:(UIViewController *)showFormController;

@end

NS_ASSUME_NONNULL_END
