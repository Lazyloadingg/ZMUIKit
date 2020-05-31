//
//  DYRefreshBackNormalFooter.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/16.
//

#import "ZMRefreshBackNormalFooter.h"
#import "ZMUtilities.h"

@implementation DYRefreshBackNormalFooter


+ (instancetype)zm_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    DYRefreshBackNormalFooter *footer = [DYRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    if (kDeviceIsiPhoneX()) {
        footer.ignoredScrollViewContentInsetBottom = 25;
        footer.automaticallyChangeAlpha = YES;
    }

    return footer;
}

+ (instancetype)zm_footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    return [DYRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

@end
