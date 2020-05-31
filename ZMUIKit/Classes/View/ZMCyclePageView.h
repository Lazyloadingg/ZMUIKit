//
//  DYCyclePagerView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/27.
//

#import <UIKit/UIKit.h>
#import "ZMPageControl.h"

NS_ASSUME_NONNULL_BEGIN

/**
 滚动方式

 - ZMCyclePageViewScrollStyleNormal: normal
 - ZMCyclePageViewScrollStyleLinear: 中心变大
 - ZMCyclePageViewScrollStyleCoverflow: 略带翻转效果
 */
typedef NS_ENUM(NSUInteger, ZMCyclePageViewScrollStyle) {
    ZMCyclePageViewScrollStyleNormal,
    ZMCyclePageViewScrollStyleLinear,
    ZMCyclePageViewScrollStyleCoverflow,
};

@protocol DYCyclePagerViewDelegate,DYCyclePagerViewDataSource;
/**
 轮播图
 */
@interface ZMCyclePageView : UIView

@property (nonatomic, weak) id <DYCyclePagerViewDelegate> delegate;
@property (nonatomic, weak) id <DYCyclePagerViewDataSource> dataSource;

@property (nonatomic, strong) ZMPageControl *pageControl;

/*! 滚动方式  */
@property (nonatomic, assign) ZMCyclePageViewScrollStyle scrollStyle;

/*! 是否可滚动  */
@property (nonatomic) BOOL scrollEnable;

/*! 是否无限循环  */
@property (nonatomic) BOOL isInfiniteLoop;

/*! itemSize  */
@property (nonatomic) CGSize itemSize;

/*! 默认 15  */
@property (nonatomic) CGFloat itemSpacing;

/*! alpha  */
@property (nonatomic) CGFloat minimumAlpha;

/*! 滚动间隔 默认3s  */
@property (nonatomic) NSTimeInterval autoScrollInterval;

/*! 重新加载数据, 将清除布局并重新布局！！！  */
- (void)reloadData;

/*! 更新数据是重新加载数据，但不清除layuot  */
- (void)updateData;

/*! 如果您只想更新布局  */
- (void)setNeedUpdateLayout;

/*! 注册自定义cell  */
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;

/*! 从缓存池中重用cell  */
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end




@protocol DYCyclePagerViewDelegate <NSObject>

@optional

/// 点击某一个item、
/// @param pageView pageView
/// @param cell cell
/// @param index index
- (void)pageView:(ZMCyclePageView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell index:(NSInteger)index;

/// 从某一个index滚动到另一个index
/// @param pageView pageView
/// @param fromIndex 前一个index
/// @param toIndex 目的地index
- (void)pageView:(ZMCyclePageView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end





@protocol DYCyclePagerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPageView:(ZMCyclePageView *)pageView;

- (__kindof UICollectionViewCell *)pageView:(ZMCyclePageView *)pageView cellForItemAtIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
