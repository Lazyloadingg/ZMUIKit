//
//  ZMUIKitTools.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/9/11.
//

#import "ZMUIKitTools.h"
#import <SDWebImage/SDWebImage.h>
#import <SDWebImage/SDImageCache.h>

@implementation ZMUIKitTools

+(void)zm_clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
}
+(CGFloat)zm_getFileSize:(NSString * )path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
+(CGFloat)zm_getFolderSize:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self zm_getFileSize:absolutePath];
        }
        // SDWebImage框架自身计算缓存的实现
        folderSize +=[[SDImageCache sharedImageCache] totalDiskSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

@end
