//
//  UIButton+ZMExtension.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/15.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>
#import "UIImage+ZMExtension.h"
NS_ASSUME_NONNULL_BEGIN

/**
 图片在按钮上的位置
 
 - DYImageLocationLeft: 图片在文字的左边，默认
 - DYImageLocationRight: 图片在文字的右边
 - DYImageLocationTop: 图片在文字的上边
 - DYImageLocationBottom: 图片在文字的下边
 */
typedef NS_ENUM(NSInteger, DYImageLocation) {
    DYImageLocationLeft = 0,
    DYImageLocationRight,
    DYImageLocationTop,
    DYImageLocationBottom,
};



/**
 图文在按钮整体偏移方向
 
 - DYOffSetDirectionLeft: 图片文字整体向左边偏移，默认
 - DYOffSetDirectionRight: 图片文字整体向右边偏移
 - DYOffSetDirectionTop: 图片文字整体向上边偏移
 - DYOffSetDirectionBottom: 图片文字整体向下边偏移
 */
typedef NS_ENUM(NSInteger, DYOffSetDirection) {
    DYOffSetDirectionLeft = 0,
    DYOffSetDirectionRight,
    DYOffSetDirectionTop,
    DYOffSetDirectionBottom,
};

@interface UIButton (ZMExtension)

/**
 开启倒计时
 
 @param count 时间
 @param change 变化
 @param finish 结束
 */
-(void)zm_countDown:(NSInteger)count change:(void(^)(UIButton * button ,NSInteger current))change finish:(void(^)(UIButton * button))finish;

/**
 取消倒计时
 */
-(void)zm_cancelCountDown;


/**
 根据图片的位置和图片文字的间距来重新设置button的image和title的排列 如果图片和文字大于button的大小，文字和图片显示的地方就会超出按钮

 @param location 图片位于文字的哪个方位
 @param spacing 图片和文字的间距离
 */
- (void)zm_setImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing;


/**
*  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
*  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
*
*  @param margin 图片、文字离button边框的距离
*/
- (void)zm_setImageLocation:(DYImageLocation)location WithMargin:(CGFloat )margin;

/**
根据图片的位置和图片文字的间距来重新设置button的image和title的排列
适配了 图片和文字 大于button的大小情况，，但调用的时候，button内部要布局完毕，推荐 layoutSubview 中调用
https://www.jianshu.com/p/f521505beed9
@param location 图片位于文字的哪个方位
@param spacing 图片和文字的间距离
*/
- (void)zm_setAlreaZMButtonImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing;

/**
 根据图片的位置和图片文字的间距来重新设置button的image和title的排列，根据offset来确定整体要偏移的方向以及偏移的数值 如果图片和文字大于button的大小，文字和图片显示的地方就会超出按钮

 @param location 图片在文字的哪个方向
 @param spacing 图片和文字的间隔
 @param offSetDirection 哪个方向偏移
 @param offSetVar 偏移多少
 */
- (void)zm_setImageLocation:(DYImageLocation)location spacing:(CGFloat)spacing offSet:(DYOffSetDirection)offSetDirection offSetVar:(CGFloat)offSetVar;

/**
 设置button网络图

 @param url url
 @param state state
 */
- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

/**
  设置button网络图

 @param url url
 @param state state
 @param placeholderImage placeholderImage
 */
- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage;

/**
   设置button网络图

 @param url url
 @param state state
 @param placeholderImage placeholderImage
 @param option SDWebImageOptions
 */
- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)option ;

/**
    设置button网络图

 @param url url
 @param state state
 @param placeholderImage placeholderImage
 @param completed completed
 */
- (void)zm_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage completed:(dispatch_block_t)completed;

/// 设置热区要扩的尺寸
/// @param size 热点尺寸
- (void)zm_setInsetEdge:(CGFloat) size;

/// 设置热区要扩的尺寸
/// @param top 顶部
/// @param right 左边
/// @param bottom 下边
/// @param left 右边
- (void)zm_setInsetEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
/**
  根据给定的颜色，设置按钮的颜色 自定义渐变效果
  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
  @param clrs     渐变颜色的数组  数组元素UIColor类型
  @param percent  渐变颜色的占比数组 数组元素 NSNumber类型
  @param type     渐变色的类型
*/
- (UIButton *)zm_gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(DYImageGradientType)type;
/**
  根据给定的颜色，设置按钮的颜色,默认的渐变效果
  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
  @param clrs     渐变颜色的数组  数组元素UIColor类型
  @param type     渐变色的类型
*/
- (UIButton *)zm_defaultGradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs gradientType:(DYImageGradientType)type;
@end

NS_ASSUME_NONNULL_END
