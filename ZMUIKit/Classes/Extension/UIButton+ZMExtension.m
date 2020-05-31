//
//  UIButton+ZMExtension.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/15.
//

#import "UIButton+ZMExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIButton()

@property (nonatomic, strong) dispatch_source_t timer;

@end

static const char * kZMTimer = "kZMTimer";
static NSString *const kAnimationKey = @"gradualChangeAni";
static CGFloat const kAnimationDuration = 0.25;

//热区
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;


@implementation UIButton (ZMExtension)

#pragma mark --> 🐷 Public Method 🐷

-(void)zm_countDown:(NSInteger)count change:(void(^)(UIButton * button ,NSInteger current))change finish:(void(^)(UIButton * button))finish{
    
    if (self.timer) {
        [self zm_cancelCountDown];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行一次
    
    __block NSInteger time = count;
    NSTimeInterval seconds = count;
    CFTimeInterval endTime = CACurrentMediaTime() + seconds; // 最后期限
    
    dispatch_source_set_event_handler(self.timer, ^{
        CFTimeInterval interval = endTime - CACurrentMediaTime();
        if (time > 0) {
            // 更新倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                if (change) {
                    change(self,interval);
                }
                self.enabled = NO;
            });
        } else {
            // 倒计时结束
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finish) {
                    finish(self);
                }
                self.enabled = YES;
            });
        }
        time --;
    });
    
    dispatch_resume(self.timer);
    
}
-(void)zm_cancelCountDown{
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.enabled = YES;
        });
    }
}
#pragma mark --> 🐷 Setter/Getter 🐷
-(dispatch_source_t)timer{
    return  objc_getAssociatedObject(self, kZMTimer);
}
-(void)setTimer:(dispatch_source_t)timer{
    objc_setAssociatedObject(self, kZMTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zm_setImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing {
    
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize texth_wXQ = CGSizeMake(MAXFLOAT,MAXFLOAT);
    
    NSDictionary *dicText = @{NSFontAttributeName :self.titleLabel.font};
    
    CGFloat titleWidth = [self.titleLabel.text boundingRectWithSize:texth_wXQ options:NSStringDrawingUsesLineFragmentOrigin attributes:dicText context:nil].size.width;
    
    CGFloat titleHeight = [self.titleLabel.text boundingRectWithSize:texth_wXQ options:NSStringDrawingUsesLineFragmentOrigin attributes:dicText context:nil].size.height;
    
    //image中心移动的x距离
    
    CGFloat imageOffsetX = (imageWith + titleWidth) / 2 - imageWith / 2;
    //image中心移动的y距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;
    //title中心移动的x距离
    CGFloat titleOffsetX = (imageWith + titleWidth / 2) - (imageWith + titleWidth) / 2;
    //title中心移动的y距离
    CGFloat labelOffsetY = titleHeight / 2 + spacing / 2;
    switch (location) {
        case DYImageLocationLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
        case DYImageLocationRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + spacing/2, 0, -(titleWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
        case DYImageLocationTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -titleOffsetX, -labelOffsetY, titleOffsetX);
            break;
        case DYImageLocationBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -titleOffsetX, labelOffsetY, titleOffsetX);
            break;
        default:
            break;
    }
    
}

- (void)zm_setAlreaZMButtonImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing {
    
    self.titleEdgeInsets = self.imageEdgeInsets = UIEdgeInsetsZero;

    CGFloat imgW = self.imageView.image.size.width;
    CGFloat imgH = self.imageView.image.size.height;
    CGSize showLabSize = self.titleLabel.bounds.size;
    CGFloat showLabW = showLabSize.width;
    CGFloat showLabH = showLabSize.height;

    CGSize trueSize = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat trueLabW = trueSize.width;

    //image中心移动的x距离
    CGFloat imageOffsetX = showLabW/2 ;
    //image中心移动的y距离
    CGFloat imageOffsetY = showLabH/2 + spacing/2;
    //label左边缘移动的x距离
    CGFloat labelOffsetX1 = imgW/2 - showLabW/2 + trueLabW/2;
    //label右边缘移动的x距离
    CGFloat labelOffsetX2 = fabs(imgW/2 + showLabW/2 - trueLabW/2);
    //label中心移动的y距离
    CGFloat labelOffsetY = imgH/2 + spacing/2;

    switch (location) {
        case DYImageLocationLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;

        case DYImageLocationRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, showLabW + spacing/2, 0, -(showLabW + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imgW + spacing/2), 0, imgW + spacing/2);
            break;

        case DYImageLocationTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX1, -labelOffsetY, labelOffsetX2);
            break;

        case DYImageLocationBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX1, labelOffsetY, labelOffsetX2);
            break;

        default:
            break;
    }
}


/**根据图文距边框的距离调整图文间距*/
- (void)zm_setImageLocation:(DYImageLocation)location WithMargin:(CGFloat )margin {
    if (location == DYImageLocationLeft || location == DYImageLocationRight) {
        CGFloat imageWith = self.imageView.image.size.width;
        CGFloat labelWidth = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat spacing = self.bounds.size.width - imageWith - labelWidth - 2*margin;
        
        [self zm_setImageLocation:location spacing:spacing];
    }else {
        CGFloat imageHeight = self.imageView.image.size.height;
        CGFloat labelHeight = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        CGFloat spacing = self.bounds.size.height - imageHeight - labelHeight - 2*margin;
        
        [self zm_setImageLocation:location spacing:spacing];
    }
}



- (void)zm_setImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing offSet:(DYOffSetDirection)offSetDirection offSetVar:(CGFloat)offSetVar{
    
    CGFloat imageWith = self.imageView.image.size.width;
    
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize texth_wXQ = CGSizeMake(MAXFLOAT,MAXFLOAT);
    
    NSDictionary *dicText = @{NSFontAttributeName :self.titleLabel.font};
    
    CGFloat titleWidth = [self.titleLabel.text boundingRectWithSize:texth_wXQ options:NSStringDrawingUsesLineFragmentOrigin attributes:dicText context:nil].size.width;
    CGFloat titleHeight = [self.titleLabel.text boundingRectWithSize:texth_wXQ options:NSStringDrawingUsesLineFragmentOrigin attributes:dicText context:nil].size.height;
    
    //image中心移动的x距离
    CGFloat imageOffsetX = (imageWith + titleWidth) / 2 - imageWith / 2;
    //image中心移动的y距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;
    //title中心移动的x距离
    CGFloat titleOffsetX = (imageWith + titleWidth / 2) - (imageWith + titleWidth) / 2;
    //title中心移动的y距离
    CGFloat labelOffsetY = titleHeight / 2 + spacing / 2;
    switch (location) {
        case DYImageLocationLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
        case DYImageLocationRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + spacing/2, 0, -(titleWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
        case DYImageLocationTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -titleOffsetX, -labelOffsetY, titleOffsetX);
            break;
        case DYImageLocationBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -titleOffsetX, labelOffsetY, titleOffsetX);
            break;
        default:
            break;
    }
    
    CGFloat imageTop = self.imageEdgeInsets.top;
    CGFloat imageLeft = self.imageEdgeInsets.left;
    CGFloat imageBottom = self.imageEdgeInsets.bottom;
    CGFloat imageRight = self.imageEdgeInsets.right;
    CGFloat titleTop = self.titleEdgeInsets.top;
    CGFloat titleLeft = self.titleEdgeInsets.left;
    CGFloat titleBottom = self.titleEdgeInsets.bottom;
    CGFloat titleRight = self.titleEdgeInsets.right;
    switch (offSetDirection){
        case DYOffSetDirectionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft - offSetVar, imageBottom, imageRight + offSetVar);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft - offSetVar, titleBottom, titleRight + offSetVar);
            break;
        case DYOffSetDirectionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft + offSetVar, imageBottom, imageRight - offSetVar);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft + offSetVar, titleBottom, titleRight - offSetVar);
            break;
        case DYOffSetDirectionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageTop - offSetVar , imageLeft, imageBottom + offSetVar, imageRight);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleTop - offSetVar , titleLeft, titleBottom + offSetVar, titleRight);
            break;
        case DYOffSetDirectionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageTop + offSetVar, imageLeft, imageBottom - offSetVar, imageRight);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleTop + offSetVar, titleLeft, titleBottom - offSetVar, titleRight);
            break;
        default:
            break;
    }
    
}


- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state{
    [self zm_setImageWithURL:url forState:state placeholderImage:nil options:SDWebImageLowPriority completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage{
    [self zm_setImageWithURL:url forState:state placeholderImage:placeholderImage options:SDWebImageLowPriority completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)option {
    [self zm_setImageWithURL:url forState:state placeholderImage:placeholderImage options:option completed:NULL];
}

- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage completed:(dispatch_block_t)completed {
    [self zm_setImageWithURL:url forState:state placeholderImage:placeholderImage options:SDWebImageLowPriority completed:completed];
}

- (void)zm_setImageWithURL:(NSURL *)imageURL forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)option completed:(dispatch_block_t)completed {
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:placeholder options:option completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = kAnimationDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [weakSelf.layer addAnimation:transition forKey:kAnimationKey];
        }
        if (completed) {
            completed();
        }
    }];

}

- (void)zm_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable SDExternalCompletionBlock)completedBlock {
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = kAnimationDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [weakSelf.layer addAnimation:transition forKey:kAnimationKey];
        }
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}


- (void)zm_setInsetEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)zm_setInsetEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}
/**
  根据给定的颜色，设置按钮的颜色 自定义渐变效果
  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
  @param clrs     渐变颜色的数组  数组元素UIColor类型
  @param percent  渐变颜色的占比数组 数组元素 NSNumber类型
  @param type     渐变色的类型
*/
- (UIButton *)zm_gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(DYImageGradientType)type {
    UIImage *backImage = [[UIImage alloc] zm_gradientImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}
/**
  根据给定的颜色，设置按钮的颜色,默认的渐变效果
  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
  @param clrs     渐变颜色的数组  数组元素UIColor类型
  @param type     渐变色的类型
*/
- (UIButton *)zm_defaultGradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs gradientType:(DYImageGradientType)type {
    UIImage *backImage = [[UIImage alloc] zm_defaultGradientImageWithSize:btnSize colors:clrs gradientType:type];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self setBackgroundImage:backImage forState:UIControlStateHighlighted];
    return self;
}

@end
