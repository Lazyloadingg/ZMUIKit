//
//  DYDevice.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 当前处于的网络类型

 - DYNetWorkTypeNone: 无网络
 - DYNetWorkTypeWifi: wifi
 - DYNetWorkTypeCelliar2G: 2G
 - DYNetWorkTypeCelliar3G: 3G
 - DYNetWorkTypeCelliar4G: 4G
 */
typedef NS_ENUM(NSUInteger, DYNetWorkType) {
    DYNetWorkTypeNone,
    DYNetWorkTypeWifi,
    DYNetWorkTypeCelliar2G,
    DYNetWorkTypeCelliar3G,
    DYNetWorkTypeCelliar4G,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZMDevice : NSObject

/**
 获取设备型号

 @return 设备型号
 */
+ (NSString *)deviceModel;


/**
 获取当前网络类型

 @return 网络类型
 */
+ (DYNetWorkType)currentNetworkType;


/**
 获取无线局域网的服务集标识（WIFI名称）

 @return 服务集标识
 */
+ (NSString *)ssid;


/**
 获取基础服务集标识（站点的MAC地址）

 @return 基础服务集标识
 */
+ (NSString *)bssid;


/**
 获取手机运营商代码

 @return 手机运营商代码
 */
+ (NSString *)carrier;


/**
 获取手机运营商名称

 @return 运营商名称
 */
+ (NSString *)carrierName;


/**
 获取设备唯一标识

 @return 标识码
 */
+ (NSString *)uuid;


/**
 获取屏幕真实尺寸

 @return 屏幕尺寸
 */
+ (CGSize)nativeScreenSize;


/**
 获取clentIP

 @return clentIP
 */
+ (NSString *)getClientIP;


/**
 获取手机外网IP地址

 @return 外网IP地址
 */
+ (NSString *)deviceIPAddress;


@end

NS_ASSUME_NONNULL_END
