//
//  ZMHud+ZMExtension.h
//  AFNetworking
//
//  Created by qingyun on 2019/10/29.
//

//#import <ZMUIKit/ZMUIKit.h>
#import "ZMHud.h"
NS_ASSUME_NONNULL_BEGIN
/// 相关HUD文本提示等处理

@interface ZMHud (ZMExtension)
/// 网络失败提示
+(NSString *) netFailureTip;
/// 开启权限成功提示
+(NSString *) openPermissionSuccessTip;
/// 开启权限失败提示
+(NSString *) openPermissionFailTip;
/// 网络加载提示1
+(NSString *) pleaseWaitTip;
/// 网络加载提示2
+(NSString *) loadingTip;
@end

NS_ASSUME_NONNULL_END
