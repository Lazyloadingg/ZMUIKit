//
//  ZMApplication.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMApplication : NSObject

/**
 切换app根视图控制器

 @param controller controller
 */
+(void)zm_resetRootViewController:(UIViewController *)controller;


/// 获取app名称
+(NSString *)zm_appName;


/**
 获取app version版本

 @return 版本
 */
+(NSString *)zm_appVersion;

/**
 获取app bulid版本

 @return 版本
 */
+(NSString *)zm_appBulid;

@end

NS_ASSUME_NONNULL_END
