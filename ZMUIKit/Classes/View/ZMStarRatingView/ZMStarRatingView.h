//
//  DYStarRatingView.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^DYStarRatingViewShouldBeginGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer);


@interface ZMStarRatingView : UIControl

/** 最大值 */
@property (nonatomic) IBInspectable NSUInteger maximumValue;
/** 最小值 */
@property (nonatomic) IBInspectable CGFloat minimumValue;
/** 当前分值 */
@property (nonatomic) IBInspectable CGFloat value;
/** 最小间距 */
@property (nonatomic) IBInspectable CGFloat minSpacing;
/** 半星 */
@property (nonatomic) IBInspectable BOOL allowsHalfStars;
/** 任意星 */
@property (nonatomic) IBInspectable BOOL accurateHalfStars;
@property (nonatomic) IBInspectable BOOL continuous;

@property (nonatomic) BOOL shouldBecomeFirstResponder;

// Optional: if `nil` method will return `NO`.
@property (nonatomic, copy) DYStarRatingViewShouldBeginGestureRecognizerBlock shouldBeginGestureRecognizerBlock;

@property (nonatomic, strong) IBInspectable UIColor *starBorderColor;
@property (nonatomic) IBInspectable CGFloat starBorderWidth;

@property (nonatomic, strong) IBInspectable UIColor *emptyStarColor;

@property (nonatomic, strong) IBInspectable UIImage *emptyStarImage;
@property (nonatomic, strong) IBInspectable UIImage *halfStarImage;
@property (nonatomic, strong) IBInspectable UIImage *filledStarImage;

@end

NS_ASSUME_NONNULL_END
