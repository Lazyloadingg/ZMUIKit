//
//  ZMRefreshNormalHeader.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/16.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

/**
 下拉刷新(不要直接使用mj的初始化方法，防止后边出现样式等变动到处修改)
 */
@interface ZMRefreshNormalHeader : MJRefreshNormalHeader


/**
 创建head

 @param refreshingBlock refreshingBlock
 @return head
 */
+ (instancetype)zm_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/**
  创建head

 @param target target
 @param action action
 @return head
 */
+ (instancetype)zm_headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action ;
@end

NS_ASSUME_NONNULL_END
