//
//  ZMPageControl.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMPageControl : UIControl

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

/*! 如果只有一个页面，隐藏指示器。默认是没有  */
@property (nonatomic, assign) BOOL hidesForSinglePage;

/*! 间距  */
@property (nonatomic, assign) CGFloat pageIndicatorSpaing;

/*! center will ignore this  */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/*! contentSize  */
@property (nonatomic, assign ,readonly) CGSize contentSize;

/*! indicatorTint color  */
@property (nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

/*! 默认C1  */
@property (nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

// indicator image
@property (nullable, nonatomic,strong) UIImage *pageIndicatorImage;
@property (nullable, nonatomic,strong) UIImage *currentPageIndicatorImage;

/*! default is UIViewContentModeCenter  */
@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode;

@property (nonatomic, assign) CGSize pageIndicatorSize;
@property (nonatomic, assign) CGSize currentPageIndicatorSize;

/*! default 0.25  */
@property (nonatomic, assign) CGFloat animateDuring;

- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;



@end

NS_ASSUME_NONNULL_END
