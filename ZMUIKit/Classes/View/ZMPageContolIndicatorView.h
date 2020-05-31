//
//  ZMPageContolIndicatorView.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMPageContolIndicatorView : UIView
@property(nonatomic,strong)UIColor * pageControlSelectedColor;

@property(nonatomic,strong)UIColor * pageControlNormalColor;

@property(nonatomic,strong)UIColor * pageControlNormalBorderColor;

@property(nonatomic,assign)CGFloat pageControlWidth;

@property(nonatomic,assign)CGFloat pageControlHeight;

@property(nonatomic,assign)CGFloat cornerRadius;
/**
 正常的pageControl 显示
 */
@property(nonatomic,assign)BOOL showNormalBorderColor;

@property(nonatomic,assign)NSInteger numberOfPages;

@property(nonatomic,assign)NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
