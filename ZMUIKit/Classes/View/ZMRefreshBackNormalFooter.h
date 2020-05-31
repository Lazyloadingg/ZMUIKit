//
//  DYRefreshBackNormalFooter.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/16.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

/**
 上拉加载(不要直接使用mj的初始化方法，防止后边出现样式等变动到处修改)
 */
@interface DYRefreshBackNormalFooter : MJRefreshBackNormalFooter

/**
 创建footer
 
 @param refreshingBlock refreshingBlock
 @return footer
 */
+ (instancetype)zm_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/**
 创建footer
 
 @param target target
 @param action action
 @return footer
 */
+ (instancetype)zm_footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
