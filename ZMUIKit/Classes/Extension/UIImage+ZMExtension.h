//
//  UIImage+Extension.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/** 裁剪图片风格 */
typedef NS_ENUM(NSInteger,DYImageClipStyle) {
    DYImageClipStyleRect,
    DYImageClipStyleOval,
};
/** 渐变 颜色风格样式*/
typedef NS_ENUM(NSInteger, DYImageGradientType) {
     DYImageGradientType_FromTopToBottom = 1,            //从上到下
     DYImageGradientType_FromLeftToRight,                //从左到右
     DYImageGradientType_FromLeftTopToRightBottom,       //从左上到右下
     DYImageGradientType_FromLeftBottomToRightTop        //从右上到左下
};
@interface UIImage (ZMExtension)

#pragma mark -
#pragma mark --> 🐷 类方法 🐷
/**
 通过颜色生成图片
 
 @param color 颜色
 @return 新图片
 */
+(UIImage *)zm_createImageWithColor:(UIColor *)color;

/**
通过颜色生成图片

@param color 颜色
@param rect 图片大小
@return 新图片
*/
+(UIImage *)zm_imageWithColor:(UIColor *)color rect:(CGRect)rect;

/**
 获取ZMUIKit bundle内图片

 @param name 图片名
 @return 图片
 */
+(UIImage *)zm_kitImageNamed:(NSString *)name;

/**
  获取指定 bundle内图片

 @param image 图片名
 @param bundle bundle名
 @return 图片
 */
+(UIImage *)zm_bundleImageNamed:(NSString *)image bundle:(NSString *)bundle;

/**
 拉伸图片

 @param image 原图
 @return 拉伸后图片
 */
+(UIImage *)zm_stretchImage:(UIImage *)image;

/// 绘制占位图 并居中
/// @param name 名称
/// @param placeHolderSize 占位图尺寸
/// @param size UIImageView尺寸
/// @param color 颜色
+(UIImage *)zm_placeHolder:(NSString *) name placHoldereSize:(CGSize) placeHolderSize imageViewSize:(CGSize) size backgroundColor:(UIColor *) color;

/// 保存图片至相册
/// @param image 图片
/// @param completion 结果
+(void)zm_saveImage:(UIImage *)image completion:(void(^)(BOOL result,PHAsset * asset))completion;

/// 调整图片自动翻转
/// @param aImage 原图
+ (UIImage *)zm_fixOrientation:(UIImage *)aImage;


#pragma mark -
#pragma mark --> 🐷 实例方法 🐷
/// 绘制占位图 并居中 默认背景色 colorGray7
/// @param size imgViewsize
- (UIImage *)zm_placeHolderWithimageViewSize:(CGSize)size;

/// 绘制占位图 并居中
/// @param size imgView size
/// @param color 底色
- (UIImage *)zm_placeHolderWithimageViewSize:(CGSize)size backgroundColor:(UIColor *)color;

/// 图片添加圆角
/// @param radius radius 
- (UIImage*)imageWithCornerRadius:(CGFloat)radius;



#pragma mark -
#pragma mark - 👉 针对图片本身进行 物理压缩 体积压缩 尺寸裁剪 等API 👈

/// 改变图片透明度
/// @param alpha 透明度 0.0~1.0
/// @return 已改变透明度的图片
- (UIImage *)zm_imageWithAlpha:(CGFloat)alpha;


/// 任意改变图片尺寸
/// @param size 需要的图片尺寸
/// @return 已改变尺寸的图片
- (UIImage *)zm_imageWithSize:(CGSize)size;


/// 等比例改变图片至限制尺寸
/// @param limitSize 限制尺寸
/// @return 已改变尺寸的图片
- (UIImage *)zm_imageWithLimitSize:(CGSize)limitSize;


/// 等比例放缩图片
/// @param scale 放缩图片比例
/// @return 已放缩后的图片
- (UIImage *)zm_imageStretchWithScale:(CGFloat)scale;


/// 裁剪图片 用贝塞尔曲线画图根据实际操作 这里仅提供常用类型裁剪
/// @param rect 在原图片的基础上裁剪图片的rect
/// @param style 裁剪图片风格
/// @return 裁剪出来的图片
- (UIImage *)zm_imageClipWithRect:(CGRect)rect andStyle:(DYImageClipStyle)style;


/// 图片压缩 (质量)
/// @param specifyKB 指定图片大小，单位KB
/// @return 质量压缩后的：图片
- (UIImage *)zm_imageCompressReturnImageWithSpecifyBytes:(CGFloat)specifyKB;


/// 图片压缩 (质量)
/// @param specifyKB specifyKB 指定图片大小，单位KB
/// @return 质量压缩后的：图片数据流
- (NSData *)zm_imageCompressReturnDataWithSpecifyBytes:(CGFloat)specifyKB;


/// 图片压缩（质量）
/// @param ratio 压缩比例0.0~1.0
/// @return 质量压缩后的：图片数据流
- (NSData *)zm_imageCompressReturnDataWithRatio:(CGFloat)ratio;


/// 图片压缩（质量）
/// @param ratio ratio 压缩比例0.0~1.0
/// @return 质量压缩后的：图片
- (UIImage *)zm_imageCompressReturnImageWithRatio:(CGFloat)ratio;


/// 图片模糊
/// @param level 模糊级别0.0~1.0
/// @return 模糊处理后的图片
- (UIImage *)zm_imageBlurWithLevel:(CGFloat)level;


/// 图片旋转
/// @param orientation 在原图片基础上旋转方向：左、右、下
/// @return 旋转后的图片
- (UIImage *)zm_imageRotateWithOrientation:(UIImageOrientation)orientation;


/// 将UIView转化成图片
/// @param theView 需要转化的UIView
/// @return UIView的图片
- (UIImage *)zm_getImageFromView:(UIView *)theView;

/// 两张图片叠加、合成
/// @param rect 本身图片对于合成图片的rect
/// @param anotherImage 图片2
/// @param anotherRect 图片2对于合成图片的rect
/// @param size 合成图片的size
- (UIImage *)zm_integrateImageWithRect:(CGRect)rect
                       andAnotherImage:(UIImage *)anotherImage
                      anotherImageRect:(CGRect)anotherRect
                   integratedImageSize:(CGSize)size;


/// 图片添加水印
/// @param markImage 水印图片
/// @param imgRect 水印图片对于原图片的rect
/// @param alpha 水印图片透明度
/// @param markStr 水印文字
/// @param strRect 水印文字对于原图片的rect
/// @param attribute 水印文字的设置颜色、字体大小
- (UIImage *)zm_imageWaterMark:(UIImage *)markImage
                     imageRect:(CGRect)imgRect
                markImageAlpha:(CGFloat)alpha
                    markString:(NSString *)markStr
                    stringRect:(CGRect)strRect
               stringAttribute:(NSDictionary *)attribute;


/**
  根据给定的颜色，生成渐变色的图片 自定义样式
  @param imageSize        要生成的图片的大小
  @param colors         渐变颜色的数组 数组元素UIColor类型
  @param percents          渐变颜色的占比数组 数组元素NSNumber类型
  @param gradientType     渐变色的类型
*/
- (UIImage *) zm_gradientImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(DYImageGradientType)gradientType;

/**
  根据给定的颜色，生成渐变色的图片 默认样式
  @param imageSize        要生成的图片的大小
  @param colors         渐变颜色的数组 数组元素UIColor类型
  @param gradientType     渐变色的类型
*/
- (UIImage *) zm_defaultGradientImageWithSize:(CGSize)imageSize colors:(NSArray *)colors gradientType:(DYImageGradientType)gradientType;
/// 截取图片
/// @param rect 位置
-(UIImage *) zm_interceptImage:(CGRect)rect;
/// 等比例缩放,size 是把图显示到 多大区域,处理图片变形问题
/// @param sourceImage 图片
/// @param size 尺寸
+ (UIImage *) zm_imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;
/// 从指定bundle获取图片
/// @param imgPath 路径
/// @param bundleName bundle名称
/// @param currentClass    class类
+(UIImage *) imageName:(NSString *) imgPath bundleName:(NSString *) bundleName class:(id) currentClass;
@end

NS_ASSUME_NONNULL_END
