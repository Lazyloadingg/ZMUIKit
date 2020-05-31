//
//  ZMHud+ZMExtension.m
//  AFNetworking
//
//  Created by qingyun on 2019/10/29.
//

#import "ZMHud+ZMExtension.h"
#import "ZMUIKit.h"
#import "DYProgressHUD.h"
#import "ZMHud.h"


@implementation ZMHud (ZMExtension)

/// 网络失败提示
+(NSString *) netFailureTip{
    return @"网络失败";
}

/// 开启权限成功提示
+(NSString *) openPermissionSuccessTip{
    return @"开启成功";
}
/// 开启权限失败提示
+(NSString *) openPermissionFailTip{
    return @"开启失败";
}

/// 网络加载提示1
+(NSString *) pleaseWaitTip{
    return @"请稍候...";
}
/// 网络加载提示2
+(NSString *) loadingTip{
    return @"正在加载中...";
}
@end
