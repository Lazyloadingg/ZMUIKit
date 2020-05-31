//
//  UIView+Extension.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "UIView+ZMExtension.h"
#import "ZMUtilities.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "UIColor+ZMExtension.h"
#import "UIImage+ZMExtension.h"
static char *const kMaxBadgeNumberKey = "com.dyzhcs.www.maxBadgeNumber.key";
static char *const kCurrentBadgeNumberKey = "com.dyzhcs.www.currentBadgeNumber.key";
static char *const kBadgeOffsetPointKey = "com.dyzhcs.www.badgeOffsetPoint.key";
static char *const kFigureLabelKey = "com.dyzhcs.www.iconBadgeLabel.key";
static char *const kIndexPathKey = "com.dyzhcs.www.zm_indexPath.key";

@interface UIView ()

@property (nonatomic, copy) ZMIconBadgeLabel *iconBadgeLabel;

@end


@implementation UIView (ZMExtension)

- (void)setzm_indexPath:(NSIndexPath *)zm_indexPath {
    objc_setAssociatedObject(self, kIndexPathKey, zm_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)zm_indexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, kIndexPathKey);
    return indexPath;
}

- (void)setzm_centerX:(CGFloat)zm_centerX{
    CGPoint center = self.center;
    center.x = zm_centerX;
    self.center = center;
}

- (void)setzm_centerY:(CGFloat)zm_centerY{
    CGPoint center = self.center;
    center.y = zm_centerY;
    self.center = center;
}

- (CGFloat)zm_centerY{
    return self.center.y;
}

- (CGFloat)zm_centerX{
    return self.center.x;
}

- (void)setzm_x:(CGFloat)zm_x
{
    CGRect frame = self.frame;
    frame.origin.x = zm_x;
    self.frame = frame;
}

- (CGFloat)zm_x
{
    return self.frame.origin.x;
}

- (void)setzm_y:(CGFloat)zm_y
{
    CGRect frame = self.frame;
    frame.origin.y = zm_y;
    self.frame = frame;
}

- (CGFloat)zm_y
{
    return self.frame.origin.y;
}

- (void)setzm_w:(CGFloat)zm_w
{
    CGRect frame = self.frame;
    frame.size.width = zm_w;
    self.frame = frame;
}

- (CGFloat)zm_w
{
    return self.frame.size.width;
}

- (void)setzm_h:(CGFloat)zm_h
{
    CGRect frame = self.frame;
    frame.size.height = zm_h;
    self.frame = frame;
}

- (CGFloat)zm_h
{
    return self.frame.size.height;
}

- (void)setzm_size:(CGSize)zm_size
{
    CGRect frame = self.frame;
    frame.size = zm_size;
    self.frame = frame;
}

- (CGSize)zm_size
{
    return self.frame.size;
}

- (void)setzm_origin:(CGPoint)zm_origin
{
    CGRect frame = self.frame;
    frame.origin = zm_origin;
    self.frame = frame;
}

- (CGPoint)zm_origin
{
    return self.frame.origin;
}

- (CGFloat)zm_right{
    return self.zm_x + self.zm_w;
}

-(CGFloat)zm_bottom{
    return self.zm_y + self.zm_h;
}
//判断是否包含某个类的subview
- (BOOL)doHaveSubViewOfSubViewClassName:(NSString *)subViewClassName{
    BOOL doHave = NO;
    for (UIView *subView in self.subviews){
        if ([subView isKindOfClass:NSClassFromString(subViewClassName)]){
            doHave = YES;
            break;
        }
    }
    return doHave;
}

//删除某个类的subview
- (void)removeSomeSubViewOfSubViewClassName:(NSString *)subViewClassName{
    for (UIView *subView in self.subviews){
        if ([subView isKindOfClass:NSClassFromString(subViewClassName)]){
            [subView removeFromSuperview];
        }
    }
}

//得到某个类的subview
- (void)getTheSubViewOfSubViewClassName:(NSString *)subViewClassName block:(void(^)(UIView *subView))block{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews){
            if ([subView isKindOfClass:NSClassFromString(subViewClassName)]){
                block(subView);
            }
        }
        block(nil);
    });
}

/// 获取当前view 所属的viewController
- (UIViewController *)zm_viewController {
    UIView *next = self;
    while ((next = [next superview])) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)addRoundingCorenrs:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.mask = nil;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        maskLayer.shouldRasterize = YES;
        maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.mask = maskLayer;
    });
}

/// 给view添加阴影，支持圆角阴影
- (void)zm_addShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius {
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    
}
- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)sel {
    [self addNumberOfTouches:1 target:target action:sel];
}

- (void)addNumberOfTouches:(NSInteger)touches target:(id)target action:(SEL)sel {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    tap.numberOfTapsRequired = touches;
    tap.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)addDoubleTapGestureRecognizerWithTarget:(id)target action:(SEL)sel {
    [self addNumberOfTouches:2 target:target action:sel];
}

- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)sel {
    [self addLongPressGestureRecognizerWithTarget:target action:sel minimumPressDuration:0.2];
}

- (void)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)sel minimumPressDuration:(NSTimeInterval)minimumPressDuration {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:sel];
    longPress.minimumPressDuration = minimumPressDuration;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPress];
}

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
-(void) saveToAlbum:(UIViewController *) vc selector:(SEL) selector{
    // 设置绘制图片的大小
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // 绘制图片
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存图片到相册   如果需要获取保存成功的事件第二和第三个参数需要设置响应对象和方法，该方法为固定格式。
    UIImageWriteToSavedPhotosAlbum(image, vc, selector, nil);
}
/**
 UIView截图
 */
-(UIImage *) zm_captureImage{
    // 设置绘制图片的大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake((NSInteger)self.bounds.size.width, (NSInteger)self.bounds.size.height), NO, 0.0);
    // 绘制图片
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    //裁剪,避免白边
//    CGFloat fixelW = CGImageGetWidth(image.CGImage);
//    CGFloat fixelH = CGImageGetHeight(image.CGImage);
//    UIImage *interImage = [image zm_interceptImage:CGRectMake(1, 1, fixelW - 2, fixelH - 2)];
//    return interImage;
    return image;
}
- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection {
    [self zm_setDirectionBorder:borderDirection borderWidth:kPixelScale(1)];
}

- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection borderWidth:(CGFloat)width {
    [self zm_setDirectionBorder:borderDirection borderWidth:width borderColor:[UIColor colorC7]];
}

- (void)zm_setDirectionBorder:(DYDirectionBorder)borderDirection borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    
    if (borderDirection & DYDirectionBorderLeft) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CALayer *borderLayer = [CALayer layer];
            borderLayer.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds));
            borderLayer.backgroundColor = color.CGColor;
            [self.layer addSublayer:borderLayer];
        });
        
    }
    if (borderDirection & DYDirectionBorderRight) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CALayer *borderLayer = [CALayer layer];
            borderLayer.frame = CGRectMake(CGRectGetWidth(self.bounds)-width, 0, width, CGRectGetHeight(self.bounds));
            borderLayer.backgroundColor = color.CGColor;
            [self.layer addSublayer:borderLayer];
        });
        
    }
    
    if (borderDirection & DYDirectionBorderTop) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CALayer *borderLayer = [CALayer layer];
            borderLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), width);
            borderLayer.backgroundColor = color.CGColor;
            [self.layer addSublayer:borderLayer];
        });
        
    }
    
    if (borderDirection & DYDirectionBorderBottom) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CALayer *borderLayer = [CALayer layer];
            borderLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-width, CGRectGetWidth(self.bounds), width);
            borderLayer.backgroundColor = color.CGColor;
            [self.layer addSublayer:borderLayer];
        });
        
    }
    
    if (borderDirection & DYDirectionBorderAll) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = width;
    }
    
}

+ (UIImage*)zm_createImageWithView:(UIView*) view{

    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

@end










static CGFloat const kAnimationDuration = 0.25;
static CGFloat const kAnimationOffsetX = 80.f;
static CGFloat const kAnimationOffsetY = 50.f;

static char *const kAssociatedEndViewKey = "associatedEndViewKey";
static char *const kAssociatedCompeletionKey = "associatedCompeletionKey";
static char *const kAssociatedStartPointKey = "associatedStartPointKey";
static char *const kisFromLeftAnimationKey = "com.ZMUIKit.views.fromLeftAnimation.key";
static char *const kTempObjectKey = "com.ZMUIKit.views.tempDelegate.key";


@interface DYViewDelegateObject : NSObject <CAAnimationDelegate>

@property (nonatomic, copy) Compeletion compeletion;

@property (nonatomic, weak) UIView *endView;

@end

@interface UIView ()

@property (nonatomic, strong) UIView *endView;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic, assign) BOOL isFromLeftAnimation;
@property (nonatomic, strong) DYViewDelegateObject *zm_objectDelegate;

@end

@implementation UIView (DYAnimation)

- (void)zm_parabolaAnimateWithEndView:(UIView *)endView before: (Before)before compeletion:(Compeletion)compeletion {
    [self zm_parabolaAnimateWithSuperView:nil endView:endView before:before compeletion:compeletion];
}

- (void)zm_parabolaAnimateWithSuperView:(UIView *)superView endView:(UIView *)endView before:(Before)before compeletion:(Compeletion)compeletion {
    [self zm_parabolaAnimateWithSuperView:superView endView:endView before:before compeletion:compeletion fromLeft:YES];
}

- (void)zm_parabolaAnimateWithSuperView:(UIView *)superView endView:(UIView *)endView before:(Before)before compeletion:(Compeletion)compeletion fromLeft:(BOOL)fromLeft {
    if (!superView) {
        superView = [[UIApplication sharedApplication].delegate window];
    }
    self.endView = endView;
    self.zm_objectDelegate.endView = endView;
    self.zm_objectDelegate.compeletion = compeletion;
    self.isFromLeftAnimation = fromLeft;
    CGPoint startPoint = [self.superview convertPoint:self.center toView:superView];
    self.startPoint = startPoint;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    if (self.isFromLeftAnimation) {
        [path addQuadCurveToPoint:CGPointMake(startPoint.x-kAnimationOffsetX, startPoint.y-kAnimationOffsetY) controlPoint:CGPointMake(startPoint.x, startPoint.y)];
    }else {
        [path addQuadCurveToPoint:CGPointMake(startPoint.x+kAnimationOffsetX, startPoint.y-kAnimationOffsetY) controlPoint:CGPointMake(startPoint.x, startPoint.y)];
    }
    
    [self groupAnimationWithPath:path before:before];
}

#pragma mark -
#pragma mark - 第一阶段组合动画

- (void)groupAnimationWithPath:(UIBezierPath *)path before:(Before)before {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CALayer *dotLayer = nil;
    if (before) {
        dotLayer = before();
        if (dotLayer) {
            [window.layer addSublayer:dotLayer];
        }else{
            dotLayer = [self getDefaultLayer];
            [window.layer addSublayer:dotLayer];
        }
    }else{
        dotLayer = [self getDefaultLayer];
        [window.layer addSublayer:dotLayer];
    }
    
    
    //路线
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
//    animation.rotationMode = kCAAnimationDiscrete;
    
    //大小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,scaleAnimation];
    groups.duration = kAnimationDuration;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
//    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [dotLayer addAnimation:groups forKey:nil];
    
//    [NSRunLoop currentRunLoop]
    /// 第一阶段动画颤抖
    [self performSelector:@selector(shakeAnimationFromLayer:) withObject:dotLayer afterDelay:kAnimationDuration inModes:@[NSRunLoopCommonModes]];
}

/// 第一阶段组合动画 layer 颤抖两下
/// @param layerAnimation 第一阶段组合动画 layer
- (void)shakeAnimationFromLayer:(CALayer *)layerAnimation {
    CAKeyframeAnimation *transformanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    transformanimation.values = values;
    transformanimation.duration = 0.3;
    transformanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layerAnimation addAnimation:transformanimation forKey:nil];
    
    /// 第一阶段动画完毕 执行第二段动画吧
    [self performSelector:@selector(nextGroupAnimationFromLayer:) withObject:layerAnimation afterDelay:0.5 inModes:@[NSRunLoopCommonModes]];
}

#pragma mark -
#pragma mark - 第二阶段组合动画

- (void)nextGroupAnimationFromLayer:(CALayer *)layerAnimation {
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGPoint startPoint;
    if (self.isFromLeftAnimation) {
        startPoint = CGPointMake(self.startPoint.x-kAnimationOffsetX, self.startPoint.y-kAnimationOffsetY);
    }else {
        startPoint = CGPointMake(self.startPoint.x+kAnimationOffsetX, self.startPoint.y-kAnimationOffsetY);
    }
    
    CGPoint endPoint = [self.endView.superview convertPoint:self.endView.center toView:window];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    if (self.isFromLeftAnimation) {
        [path addCurveToPoint:CGPointMake(endPoint.x, endPoint.y)
        controlPoint1:CGPointMake(startPoint.x, startPoint.y) controlPoint2:CGPointMake(startPoint.x-100, startPoint.y-200)];
    }else {
        [path addCurveToPoint:CGPointMake(endPoint.x, endPoint.y)
        controlPoint1:CGPointMake(startPoint.x, startPoint.y) controlPoint2:CGPointMake(startPoint.x, startPoint.y-200)];
    }
    
//    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(endPoint.x, startPoint.y)];
    
    
    //路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
//    animation.rotationMode = kCAAnimationRotateAuto;
    
    //透明度
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //大小
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue=[NSNumber numberWithFloat:0.3];
    scaleAnimation.duration=0.5;
    scaleAnimation.autoreverses=NO;
    scaleAnimation.repeatCount=0;
    scaleAnimation.removedOnCompletion=NO;
    scaleAnimation.fillMode=kCAFillModeForwards;
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation,scaleAnimation];
    groups.duration = 0.5;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self.zm_objectDelegate;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [layerAnimation addAnimation:groups forKey:nil];
    
    /// 动画完毕 移除 layer 层
    [self performSelector:@selector(removeFromLayer:) withObject:layerAnimation afterDelay:0.5 inModes:@[NSRunLoopCommonModes]];
}

- (void)removeFromLayer:(CALayer *)layerAnimation {
    [layerAnimation removeFromSuperlayer];
}

#pragma mark -
#pragma mark - CAAnimationDelegate

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
//        if (self.compeletion) {
//            BOOL compFlag = self.compeletion();
//            if (compFlag) {
//                [self parabolaAnimateDidStop];
//            }
//        }else{
//            [self parabolaAnimateDidStop];
//        }
//    }
//}
#pragma mark -
#pragma mark - private method

- (CALayer *)getDefaultLayer {
    CALayer *dotLayer = [CALayer layer];
    dotLayer.backgroundColor = self.backgroundColor.CGColor;
    dotLayer.frame = CGRectMake(0, 0, 20, 20);
    dotLayer.cornerRadius = 10;
    return dotLayer;
}

/// endView 颤抖两下
- (void)parabolaAnimateDidStop {
    
    CAKeyframeAnimation* transformanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    transformanimation.values = values;
    transformanimation.duration = 0.35;
    transformanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.endView.layer addAnimation:transformanimation forKey:nil];
    
}

#pragma mark -
#pragma mark - setters and getters

- (void)setCompeletion:(Compeletion)compeletion {
    objc_setAssociatedObject(self, kAssociatedCompeletionKey, compeletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (Compeletion)compeletion {
    return objc_getAssociatedObject(self, kAssociatedCompeletionKey);
}

- (void)setEndView:(UIView *)endView {
    objc_setAssociatedObject(self, kAssociatedEndViewKey, endView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)endView {
    return objc_getAssociatedObject(self, kAssociatedEndViewKey);
}

- (void)setStartPoint:(CGPoint)startPoint {
    NSString *startStr = NSStringFromCGPoint(startPoint);
    objc_setAssociatedObject(self, kAssociatedStartPointKey, startStr, OBJC_ASSOCIATION_COPY);
}

- (CGPoint)startPoint {
    NSString *startStr =  objc_getAssociatedObject(self, kAssociatedStartPointKey);
    return CGPointFromString(startStr);
}

- (void)setIsFromLeftAnimation:(BOOL)isFromLeftAnimation {
    objc_setAssociatedObject(self, kisFromLeftAnimationKey, @(isFromLeftAnimation), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isFromLeftAnimation {
    NSNumber *nb = objc_getAssociatedObject(self, kisFromLeftAnimationKey);
    if (!nb) {
        nb = @0;
    }
    return nb.boolValue;
}

- (void)setzm_objectDelegate:(DYViewDelegateObject *)zm_objectDelegate {
    objc_setAssociatedObject(self, kTempObjectKey, zm_objectDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DYViewDelegateObject *)zm_objectDelegate {
    DYViewDelegateObject *object = objc_getAssociatedObject(self, kTempObjectKey);
    if (!object) {
        object = [[DYViewDelegateObject alloc]init];
        objc_setAssociatedObject(self, kTempObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

@end




@implementation UIView (DYIconBadgeNumber)

- (void)setMaxBadgeType:(DYIconBadgeMaxType)maxBadgeType {
    objc_setAssociatedObject(self, kMaxBadgeNumberKey, @(maxBadgeType), OBJC_ASSOCIATION_ASSIGN);
    self.iconBadgeLabel.maxType = maxBadgeType;
}

- (DYIconBadgeMaxType)maxBadgeType {
    NSNumber *type = objc_getAssociatedObject(self, kMaxBadgeNumberKey);
    return [type isEqualToNumber:@0] ? DYIconBadgeMaxType99 : DYIconBadgeMaxType999;
}

- (void)setCurrentBadgeCount:(NSInteger)currentBadgeCount {
    objc_setAssociatedObject(self, kCurrentBadgeNumberKey, @(currentBadgeCount), OBJC_ASSOCIATION_ASSIGN);
    self.iconBadgeLabel.count = currentBadgeCount;
}

- (NSInteger)currentBadgeCount {
    NSNumber *currentNumber = objc_getAssociatedObject(self, kCurrentBadgeNumberKey);
    return currentNumber.integerValue;
}

- (void)setzm_badgeOffset:(CGPoint)zm_badgeOffset {
    objc_setAssociatedObject(self, kBadgeOffsetPointKey, NSStringFromCGPoint(zm_badgeOffset), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.iconBadgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(zm_badgeOffset.x);
        make.centerY.equalTo(self.mas_top).offset(1 + zm_badgeOffset.y);
    }];
}

- (CGPoint)zm_badgeOffset {
    NSString *str = objc_getAssociatedObject(self, kBadgeOffsetPointKey);
    CGPoint point = CGPointFromString(str);
    return point;
}

- (ZMIconBadgeLabel *)iconBadgeLabel {
    ZMIconBadgeLabel *iconBadgeLabel = objc_getAssociatedObject(self, kFigureLabelKey);
    if (!iconBadgeLabel) {
        iconBadgeLabel = [[ZMIconBadgeLabel alloc]init];
        iconBadgeLabel.maxType = DYIconBadgeMaxType99;
        iconBadgeLabel.layer.zPosition = NSIntegerMax;
        objc_setAssociatedObject(self, kFigureLabelKey, iconBadgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (iconBadgeLabel.superview == nil) {
            [self addSubview:iconBadgeLabel];
            [iconBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_right).offset(0);
                make.centerY.equalTo(self.mas_top).offset(1);
            }];
        }
    }
    return iconBadgeLabel;
}

@end


@implementation DYViewDelegateObject

#pragma mark -
#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        if (self.compeletion) {
            BOOL compFlag = self.compeletion();
            if (compFlag) {
                [self parabolaAnimateDidStop];
            }
        }else{
            [self parabolaAnimateDidStop];
        }
    }
}

/// endView 颤抖两下
- (void)parabolaAnimateDidStop {
    
    CAKeyframeAnimation* transformanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    transformanimation.values = values;
    transformanimation.duration = 0.35;
    transformanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.endView.layer addAnimation:transformanimation forKey:nil];
    
}

@end
