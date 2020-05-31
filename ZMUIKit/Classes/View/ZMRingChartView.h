//
//  ZMRingChartView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 象限
 
 - DYRingDistributionQuadrantFirst: 第一象限
 - DYRingDistributionQuadrantSecond: 第二象限
 - DYRingDistributionQuadrantThird: 第三象限
 - DYRingDistributionQuadrantFourth: 第四象限
 */
typedef NS_ENUM(NSUInteger, DYRingDistributionQuadrant) {
    DYRingDistributionQuadrantFirst,
    DYRingDistributionQuadrantSecond,
    DYRingDistributionQuadrantThird,
    DYRingDistributionQuadrantFourth,
};

@protocol ZMRingChartViewDataSource,ZMRingChartViewDelegate;
@interface ZMRingChartView : UIView

@property (nonatomic, weak) id <ZMRingChartViewDataSource> dataSource;
@property (nonatomic, weak) id <ZMRingChartViewDelegate> delegate;

/*! 是否动画渲染. 默认YES  */
@property (nonatomic, assign) BOOL isAnimation;

/*! 默认20.f */
@property (nonatomic, assign) CGFloat lineWidth;

- (void)reloadData;

@end

@protocol ZMRingChartViewDataSource <NSObject>

@required

/**
 环形分布图总模块个数
 
 @param ringView self
 @return 几个模块
 */
- (NSInteger)numberOfItemInringView:(ZMRingChartView *)ringView;

/**
 每一个模块的规模（可以是比例，也可以是具体的数值，但不要混合）
 
 @param ringView self
 @param index index
 @return value
 */
- (NSNumber *)ringView:(ZMRingChartView *)ringView scaleForItemAtIndex:(NSInteger)index;

@optional

/**
 设置每一模块对应的 UIColor (不设置此代理 默认随机颜色)
 
 @param ringView self
 @param index index
 @return color
 */
- (UIColor *)ringView:(ZMRingChartView *)ringView colorForItemAtIndex:(NSInteger)index;

/**
 中心自定义view
 
 @param ringView self
 @return 自定义view
 */
- (UIView *)centerViewInRingView:(ZMRingChartView *)ringView;

@end


@protocol ZMRingChartViewDelegate <NSObject>

@optional

/**
 别用 还不完善！！！
 
 @param ringView self
 @param index index
 @param auadrant auadrant
 @param point point
 */
- (void)ringView:(ZMRingChartView *)ringView didSelectAtIndex:(NSInteger)index auadrant:(DYRingDistributionQuadrant)auadrant point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
