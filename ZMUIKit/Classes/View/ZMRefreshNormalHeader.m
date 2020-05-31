//
//  ZMRefreshNormalHeader.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/16.
//

#import "ZMRefreshNormalHeader.h"

@implementation ZMRefreshNormalHeader

+ (instancetype)zm_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    ZMRefreshNormalHeader * head = [ZMRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [head setTitle:@"正在刷新中..." forState:MJRefreshStateRefreshing];
    
    return head;
}

+ (instancetype)zm_headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    ZMRefreshNormalHeader * head = [ZMRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [head setTitle:@"正在刷新中..." forState:MJRefreshStateRefreshing];
    
    return head;
    
}

@end
