//
//  UIImage+Extension.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "UIImage+ZMExtension.h"
#import "UIColor+ZMExtension.h"
#import <Accelerate/Accelerate.h>
#import "ZMApplication.h"

//#import <ZMFoundation/ZMFoundation.h>

static NSString * const kDYSupeKitResourcesName = @"ZMUIKit";


@implementation UIImage (ZMExtension)
#pragma mark -
#pragma mark --> 🐷 类方法 🐷
+(UIImage *)zm_createImageWithColor:(UIColor *)color{
    
    return [UIImage zm_imageWithColor:color rect:CGRectMake(0, 0, 1.0f, 1.0f)];
}

+(UIImage *)zm_imageWithColor:(UIColor *)color rect:(CGRect)rect {
    
    if (CGRectEqualToRect(rect, CGRectZero)) {
        rect = CGRectMake(0, 0, 1.f, 1.f);
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

+(NSBundle *)zm_kitResourcesBundlePath{
    NSBundle * bundle = [UIImage bundleWithBundleName:kDYSupeKitResourcesName podName:kDYSupeKitResourcesName];
    return bundle;
}

+(UIImage *)zm_kitImageNamed:(NSString *)name{
    NSString * imagePath = [[self zm_kitResourcesBundlePath].bundlePath stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+(UIImage *)zm_bundleImageNamed:(NSString *)image bundle:(NSString *)bundle{
    NSBundle * bun = [UIImage bundleWithBundleName:bundle podName:bundle];
    NSString * imagePath = [bun.bundlePath stringByAppendingString:[NSString stringWithFormat:@"/%@",image]];
    UIImage * img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}

+(UIImage *)zm_stretchImage:(UIImage *)image{
    UIImage * new = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5) resizingMode:UIImageResizingModeStretch];
    return new;
}

/// 绘制占位图 并居中  默认占位图大小63*63
/// @param name 名称
/// @param placeHolderSize 占位图尺寸
/// @param size UIImageView尺寸
/// @param color 颜色
+(UIImage *) zm_placeHolder:(NSString *) name placHoldereSize:(CGSize) placeHolderSize imageViewSize:(CGSize) size backgroundColor:(UIColor *) color{
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGRect imageRect = CGRectMake((size.width-placeHolderSize.width)/2, (size.height - placeHolderSize.height)/2, placeHolderSize.width, placeHolderSize.height);
    CGContextTranslateCTM(ctx, imageRect.origin.x, imageRect.origin.y);
    CGContextTranslateCTM(ctx, 0, imageRect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, -imageRect.origin.x, -imageRect.origin.y);
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextDrawImage(ctx, imageRect, [UIImage imageNamed:name].CGImage);
    CGContextRestoreGState(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)zm_saveImage:(UIImage *)image completion:(void(^)(BOOL result,PHAsset * asset))completion{
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        if (completion) completion(NO, nil);
    } else if (status == PHAuthorizationStatusRestricted) {
        if (completion) completion(NO, nil);
    } else {
        __block PHObjectPlaceholder *placeholderAsset=nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *newAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                if (completion) completion(NO, nil);
                return;
            }
            PHAsset *asset = [self zm_getAssetFromlocalIdentifier:placeholderAsset.localIdentifier];
            PHAssetCollection *desCollection = [self zm_getDestinationCollection];
            if (!desCollection) completion(NO, nil);
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:desCollection] addAssets:@[asset]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (completion) completion(success, asset);
            }];
        }];
    }
}
+ (PHAsset *)zm_getAssetFromlocalIdentifier:(NSString *)localIdentifier{
    if(localIdentifier == nil){
        NSLog(@"Cannot get asset from localID because it is nil");
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if(result.count){
        return result[0];
    }
    return nil;
}
//获取自定义相册
+ (PHAssetCollection *)zm_getDestinationCollection
{
    //找是否已经创建自定义相册
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:[ZMApplication zm_appName]]) {
            return collection;
        }
    }
    //新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:[ZMApplication zm_appName]].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        NSLog(@"创建相册：%@失败", [ZMApplication zm_appName]);
        return nil;
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}
+ (UIImage *)zm_fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark -
#pragma mark --> 🐷 实例方法 🐷

- (UIImage*)imageWithCornerRadius:(CGFloat)radius{
    
    CGRect rect = (CGRect){0.f,0.f,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [self drawInRect:rect];
    //图片缩放，是非线程安全的
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
   
    return newImage;
}

/// 绘制占位图 并居中 默认背景色xxx
/// @param size imgViewsize
- (UIImage *)zm_placeHolderWithimageViewSize:(CGSize)size {
    return [self zm_placeHolderWithimageViewSize:size backgroundColor:[UIColor colorGray7]];
}

/// 绘制占位图 并居中
/// @param size imgViewsize
/// @param color 底色
- (UIImage *)zm_placeHolderWithimageViewSize:(CGSize)size backgroundColor:(UIColor *)color {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize placeHolderSize = CGSizeMake(self.size.width / scale, self.size.height / scale);
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGRect imageRect = CGRectMake((size.width-placeHolderSize.width)/2, (size.height - placeHolderSize.height)/2, placeHolderSize.width, placeHolderSize.height);
    CGContextTranslateCTM(ctx, imageRect.origin.x, imageRect.origin.y);
    CGContextTranslateCTM(ctx, 0, imageRect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, -imageRect.origin.x, -imageRect.origin.y);
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextDrawImage(ctx, imageRect, self.CGImage);
    CGContextRestoreGState(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



















- (UIImage *)zm_imageWithAlpha:(CGFloat)alpha {
    if (alpha>1.0) {
        alpha = 1.0;
    }
    if (alpha<=0.0) {
        alpha = 0.0;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)zm_imageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)zm_imageStretchWithScale:(CGFloat)scale {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)zm_imageWithLimitSize:(CGSize)limitSize {
    CGFloat scale = ((limitSize.width/self.size.width) < (limitSize.height/self.size.height)) ? (limitSize.width/self.size.width) : (limitSize.height/self.size.height);
    return [self zm_imageStretchWithScale:scale];
}

//截取部分图像
-(UIImage*)zm_clipImage:(CGRect)rect style:(DYImageClipStyle)style
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    UIBezierPath *path;
    switch (style) {
        case DYImageClipStyleRect:
            path = [UIBezierPath bezierPathWithRect:rect];
            break;
        case DYImageClipStyleOval:
            path = [UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        default:
            break;
    }
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

- (UIImage *)zm_imageClipWithRect:(CGRect)rect andStyle:(DYImageClipStyle)style {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return [smallImage zm_clipImage:CGRectMake(0, 0, rect.size.width, rect.size.height) style:style];
}

- (NSData *)zm_imageCompressReturnDataWithSpecifyBytes:(CGFloat)specifyKB {
    CGFloat ratio = specifyKB/(UIImageJPEGRepresentation(self, 1.0).length/1024.0);
    return [self zm_imageCompressReturnDataWithRatio:ratio];
}

- (UIImage *)zm_imageCompressReturnImageWithSpecifyBytes:(CGFloat)specifyKB {
    CGFloat ratio = specifyKB/(UIImageJPEGRepresentation(self, 1.0).length/1024.0);
    return [self zm_imageCompressReturnImageWithRatio:ratio];
}

- (NSData *)zm_imageCompressReturnDataWithRatio:(CGFloat)ratio {
    //UIImageJPEGRepresentation和UIImagePNGRepresentation
    if (ratio>1.0) {
        ratio = 1.0;
    }
    if (ratio<=0) {
        ratio = 0.0;
    }
    NSData *compressedData =  UIImageJPEGRepresentation(self, ratio);
    return compressedData;
}

- (UIImage *)zm_imageCompressReturnImageWithRatio:(CGFloat)ratio {
    //UIImageJPEGRepresentation和UIImagePNGRepresentation
    if (ratio>1.0) {
        ratio = 1.0;
    }
    if (ratio<=0) {
        ratio = 0.0;
    }
    NSData *compressedData =  UIImageJPEGRepresentation(self, ratio);
    UIImage *compressedImage = [UIImage imageWithData:compressedData];
    return compressedImage;
}

- (UIImage *)zm_imageBlurWithLevel:(CGFloat)level {
    if (level>1.0) {
        level = 1.0;
    }
    if (level<=0) {
        level = 0.0;
    }
    int boxSize = (int)(level * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        
        outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


- (UIImage *)zm_imageRotateWithOrientation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}

- (UIImage *)zm_getImageFromView:(UIView *)theView {
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)zm_integrateImageWithRect:(CGRect)rect
                       andAnotherImage:(UIImage *)anotherImage
                      anotherImageRect:(CGRect)anotherRect
                   integratedImageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:rect];
    [anotherImage drawInRect:anotherRect];
    UIImage *integratedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return integratedImage;
}

- (UIImage *)zm_imageWaterMark:(UIImage *)markImage
                     imageRect:(CGRect)imgRect
                markImageAlpha:(CGFloat)alpha
                    markString:(NSString *)markStr
                    stringRect:(CGRect)strRect
               stringAttribute:(NSDictionary *)attribute{
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (markImage) {
        [markImage drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (markStr) {
        //UILabel convert  to UIImage
        UILabel *markStrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, strRect.size.width, strRect.size.height)];
        markStrLabel.textAlignment = NSTextAlignmentCenter;
        markStrLabel.numberOfLines = 0;
        markStrLabel.attributedText = [[NSAttributedString alloc] initWithString:markStr attributes:attribute];
        UIImage *image = [self zm_getImageFromView:markStrLabel];
        [image drawInRect:strRect blendMode:kCGBlendModeNormal alpha:1.0];;
    }
    UIImage *waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return waterMarkedImage;
}

#pragma mark 根据文本生成UIImage图片



// 根据nikeName绘制图片
+ (UIImage *)zm_createStringImage:(NSString *)name imgColor:(UIColor *) imgColor imageSize:(CGSize)size stringColor:(UIColor *) stringColor font:(UIFont *) font{
  
    UIImage *image = [UIImage zm_imageColor:imgColor size:size cornerRadius:0];
    //[UIImage zm_imageColor:[UIImage JW_colorWithHexString:colorArr[ABS(name.hash % colorArr.count)] alpha:1.0] size:size cornerRadius:size.width / 2];
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画名字
    
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName : font}];
    
    [name drawAtPoint : CGPointMake ( (size.width  - nameSize.width) / 2 , (size.height  - nameSize.height) / 2 ) withAttributes : @{ NSFontAttributeName :font, NSForegroundColorAttributeName :stringColor} ];
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

+ (UIImage *)zm_imageColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [colorImage drawInRect:rect];
    
    colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}
+ (id)zm_colorWithHexString:(NSString*)hexColor alpha:(CGFloat)alpha {
    
    unsigned int red,green,blue;
    NSRange range;
    
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor* retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
    return retColor;
}
/**
  根据给定的颜色，生成渐变色的图片 自定义样式
  @param imageSize        要生成的图片的大小
  @param colors         渐变颜色的数组 数组元素UIColor类型
  @param percents          渐变颜色的占比数组 数组元素NSNumber类型
  @param gradientType     渐变色的类型
*/
- (UIImage *) zm_gradientImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(DYImageGradientType)gradientType {
    
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
//    NSUInteger capacity = percents.count;
//    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case DYImageGradientType_FromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case DYImageGradientType_FromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case DYImageGradientType_FromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case DYImageGradientType_FromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
/**
  根据给定的颜色，生成渐变色的图片 默认样式
  @param imageSize        要生成的图片的大小
  @param colors         渐变颜色的数组 数组元素UIColor类型
  @param percents          渐变颜色的占比数组 数组元素NSNumber类型
  @param gradientType     渐变色的类型
*/
- (UIImage *) zm_defaultGradientImageWithSize:(CGSize)imageSize colors:(NSArray *)colors gradientType:(DYImageGradientType)gradientType {
    NSArray *percent = @[@(0.2),@(0.8)];
    return  [self zm_gradientImageWithSize:imageSize gradientColors:colors percentage:percent gradientType:gradientType];
}
/// 截取图片
/// @param rect 位置
-(UIImage *) zm_interceptImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
 
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
/// 等比例缩放,size 是把图显示到 多大区域,处理图片变形问题
/// @param sourceImage 图片
/// @param size 尺寸
+ (UIImage *) zm_imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(size,NO, [UIScreen mainScreen].scale);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
/// 从指定bundle获取图片
/// @param imgPath 路径
/// @param bundleName bundle名称
/// @param currentClass    class类
+(UIImage *) imageName:(NSString *) imgPath bundleName:(NSString *) bundleName class:(id) currentClass{
    
    NSString *bundlePath = [[NSBundle bundleForClass:currentClass].resourcePath
                                  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", bundleName]];
      NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
      UIImage *image = [UIImage imageNamed:imgPath
                                      inBundle:resource_bundle
                 compatibleWithTraitCollection:nil];
    return image;
}


@end
