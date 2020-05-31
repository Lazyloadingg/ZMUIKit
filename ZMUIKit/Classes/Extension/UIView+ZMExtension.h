//
//  UIView+Extension.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import <UIKit/UIKit.h>
#import "ZMIconBadgeLabel.h"

typedef NS_OPTIONS(NSUInteger, DYDirectionBorder) {
    DYDirectionBorderLeft   = 1 << 0,
    DYDirectionBorderRight  = 1 << 1,
    DYDirectionBorderTop    = 1 << 2,
    DYDirectionBorderBottom = 1 << 3,
    DYDirectionBorderAll    = 1 << 4,
};

@interface UIView (ZMExtension)

@property (assign, nonatomic) CGFloat zm_x;
@property (assign, nonatomic) CGFloat zm_y;
@property (assign, nonatomic) CGFloat zm_w;
@property (assign, nonatomic) CGFloat zm_h;
@property (assign, nonatomic) CGSize zm_size;
@property (assign, nonatomic) CGPoint zm_origin;

@property (nonatomic, assign) CGFloat zm_centerX;
@property (nonatomic, assign) CGFloat zm_centerY;
@property (nonatomic, assign) CGFloat zm_right;
@property (nonatomic, assign) CGFloat zm_bottom;

@property (nonatomic, strong) NSIndexPath *zm_indexPath;

//判断是否包含某个类的subview
- (BOOL)doHaveSubViewOfSubViewClassName:(NSString *)subViewClassName;

//删除某个类的subview
- (void)removeSomeSubViewOfSubViewClassName:(NSString *)subViewClassName;

//得到某个类的subview
- (void)getTheSubViewOfSubViewClassName:(NSString *)subViewClassName block:(void(^)(UIView *subView))block;

/// 获取当前view 所属的viewController
- (UIViewController *)zm_viewController;

/**
 给视图添加圆角

 @param corners corners
 @param cornerRadii cornerRadii
 */
- (void)addRoundingCorenrs:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;


/// add shadow to View
/// @param offset shadow's offset, width: positice value occur right offset.height: positice value occur bottom offset
/// @param radius The blur radius used to create the shadow. Defaults to 3. Animatable.
/// @param color The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
/// @param opacity The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
/// @param cornerRadius When positive, the background of the layer will be drawn with rounded corners. Also effects the mask generated by the `masksToBounds' property. Defaults to zero. Animatable.
- (void)zm_addShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius;


/// 给视图添加单击手势
/// @param target target
/// @param sel sel
- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)sel;

/// 给视图添加双击手势
/// @param target target
/// @param sel sel
- (void)addDoubleTapGestureRecognizerWithTarget:(id)target action:(SEL)sel;

/// 给视图添加长按手势 长按识别时间 0.2s
/// @param target target
/// @param sel sel
- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)sel;


/// 给视图添加长按手势
/// @param target target
/// @param sel sel
/// @param minimumPressDuration 长按识别时间
- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)sel minimumPressDuration:(NSTimeInterval)minimumPressDuration;

/**
 保存至相册
 
 @param vc 视图控制器
 @param selector 选择器
 选择器的方法名:
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 方法内容:
 if (!error) {
 // 保存成功
 [ZMHud showTipHUD:@"图片已保存至相册"];
 } else {
 // 保存失败
 [ZMHud showTipHUD:@"图片保存失败"];
 }
 */
-(void) saveToAlbum:(UIViewController *) vc selector:(SEL) selector;

/**
 UIView截图
 */
-(UIImage *) zm_captureImage;


- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection;

- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection borderWidth:(CGFloat)width;

- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection borderWidth:(CGFloat)width borderColor:(UIColor *)color;

/// 通过view 创建image
/// @param view view
+ (UIImage*)zm_createImageWithView:(UIView*) view;

@end




/**
 抛物线动画已经结束的block
 
 @return 是否执行 抛物线动画结束之后的endView的 默认缩放动画。YES: 执行，NO: 不执行。
 */
typedef BOOL(^Compeletion)(void);

/**
 抛物线动画将要开始的block
 
 @return 将要执行抛物线动画的layer，不返回或者block为nil，则自动生成与本身视图背景颜色相同的layer。
 */
typedef CALayer *(^Before)(void);

@interface UIView (DYAnimation)


/// 抛物线动画，动画的起始位置的视图即为本身。动画结束之后会默认执行endView的缩放动画。参照windows坐标系
/// @param endView 抛物线动画结束位置的视图
/// @param before 抛物线动画将要开始的block
/// @param compeletion 抛物线动画已经结束的block
- (void)zm_parabolaAnimateWithEndView:(UIView *)endView before:(Before)before compeletion:(Compeletion)compeletion;

/// 抛物线动画，动画的起始位置的视图即为本身。动画结束之后会默认执行endView的缩放动画。参照传入视图坐标系
/// @param superView 动画参照视图坐标点
/// @param endView 抛物线动画结束位置的视图
/// @param before 抛物线动画将要开始的block
/// @param compeletion 抛物线动画已经结束的block
- (void)zm_parabolaAnimateWithSuperView:(UIView *)superView endView:(UIView *)endView before:(Before)before compeletion:(Compeletion)compeletion;

/// 抛物线动画，动画的起始位置的视图即为本身。动画结束之后会默认执行endView的缩放动画。参照传入视图坐标系
/// @param superView 动画参照视图坐标点
/// @param endView 抛物线动画结束位置的视图
/// @param before 抛物线动画将要开始的block
/// @param compeletion 抛物线动画已经结束的block
/// @param fromLeft 是否从左侧做弹出动画
- (void)zm_parabolaAnimateWithSuperView:(UIView *)superView endView:(UIView *)endView before:(Before)before compeletion:(Compeletion)compeletion fromLeft:(BOOL)fromLeft;

@end



@interface UIView (DYIconBadgeNumber)

/*! 最大角类型 */
@property (nonatomic, assign) DYIconBadgeMaxType maxBadgeType;

/*! 当前角标值 */
@property (nonatomic, assign) NSInteger currentBadgeCount;

/*! 在原有位置的偏移量  */
@property (nonatomic) CGPoint zm_badgeOffset;

@end

