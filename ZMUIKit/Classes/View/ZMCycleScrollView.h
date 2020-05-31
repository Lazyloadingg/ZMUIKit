//
//  DYCycleScrollCell.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/5.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ZMPageContolIndicatorView.h"

@class ZMCycleScrollView;

typedef enum {
    
    /**系统自带经典样式*/
    ZMCycleScrollViewPageContolStyleClassic,
    /** 动画效果pagecontrol*/
    ZMCycleScrollViewPageContolStyleAnimated,
    /**长条指示器pagecontrol*/
    ZMCycleScrollViewPageContolStyleIndicator,
    /**不显示pagecontrol*/
    ZMCycleScrollViewPageContolStyleNone
    
} ZMCycleScrollViewPageContolStyle;

NS_ASSUME_NONNULL_BEGIN
@protocol  ZMCycleScrollViewProtocol <NSObject>

/**
 * 图片点击回调
 */
- (void)cycleScrollView:(ZMCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@optional

/**
 * 图片滚动回调
 */
-(void)cycleScrollView:(ZMCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;



@end

@interface ZMCycleScrollView : UIView

/**
 轮播图控件
 */
@property(nonatomic,strong)SDCycleScrollView * cycleScrollView;
@property(nonatomic,strong)ZMPageContolIndicatorView * pageControl;

/**
 是否自定义cycleScrollView frame 1 自定义设置 2 使用默认 （设置效果是设置对应的pageControl位置）
 */
@property(nonatomic)BOOL isCustomCycleScrollViewHei;


/**
 轮播图片数组 支持image, urlstring
 */
@property(nonatomic,strong)NSArray * images;

/**
 分页控件样式
 */
@property(nonatomic,assign)ZMCycleScrollViewPageContolStyle pageControlStyle;

@property(nonatomic,weak)id<ZMCycleScrollViewProtocol>  delegate;
@end

NS_ASSUME_NONNULL_END
