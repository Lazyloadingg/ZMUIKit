//
//  ZMUIKitTools.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMUIKitTools : NSObject


/**
 清除指定文件夹缓存
 
 @param path 路径
 */
+(void)zm_clearCache:(NSString *)path;

/**
 获取文件大小
 
 @param path 文件路径
 @return 大小 单位M
 */
+(CGFloat)zm_getFileSize:(NSString * )path;

/**
 获取文件夹大小
 
 @param path 文件夹路径
 @return 大小  单位M
 */
+(CGFloat)zm_getFolderSize:(NSString *)path;




@end

NS_ASSUME_NONNULL_END
