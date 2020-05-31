//
//  ZMRefreshGifHeader.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/16.
//

#import "ZMRefreshGifHeader.h"

@implementation ZMRefreshGifHeader

+ (instancetype)zm_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    return  [ZMRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];
}

+ (instancetype)zm_headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    return [ZMRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
}

-(void)prepare{
    [super prepare];
    
    //设置动画
    
    
    //设置状态
    [self setImages:@[] forState:MJRefreshStateIdle];
    [self setImages:@[] forState:MJRefreshStatePulling];
    [self setImages:@[] forState:MJRefreshStateRefreshing];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}
-(void)setImages:(NSArray *)images forState:(MJRefreshState)state{
    [self setImages:images duration:images.count * 0.05 forState:state];
}
@end
