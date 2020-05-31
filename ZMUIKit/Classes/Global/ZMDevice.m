//
//  DYDevice.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/8.
//

#import "ZMDevice.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/utsname.h>
//获取IP
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

@implementation ZMDevice

/**
 获取设备型号

 @return 设备型号
 */
+ (NSString *)deviceModel {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}



/**
 获取当前网络类型

 @return 网络类型
 */
+ (DYNetWorkType)currentNetworkType {
    
    /**
     * 如果有连接的wifi和运营商的网络状态就是有网状态，如果获取不到
     * 连接wifi的ssid 和手机当前的运营商网络状态就是无网状态
     *
     */
    
    if ([ZMDevice ssid]) {
        return DYNetWorkTypeWifi;
    }else{
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        
        if (!info.currentRadioAccessTechnology) {
            return DYNetWorkTypeNone;
        }
        
        NSString * connectType = [NSString stringWithFormat:@"%@",info.currentRadioAccessTechnology];
        if ([connectType isEqualToString:CTRadioAccessTechnologyGPRS] || [connectType isEqualToString:CTRadioAccessTechnologyEdge]) {
            return DYNetWorkTypeCelliar2G;
        }
        
        if ([connectType isEqualToString:CTRadioAccessTechnologyCDMA1x] || [connectType isEqualToString:CTRadioAccessTechnologyWCDMA] ||
            [connectType isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            return DYNetWorkTypeCelliar3G;
        }
        
        if ([connectType isEqualToString:CTRadioAccessTechnologyLTE]) {
            return DYNetWorkTypeCelliar4G;
        }
        
    }
    return DYNetWorkTypeNone;
}



/**
 获取无线局域网的服务集标识（WIFI名称）

 @return 服务集标识
 */
+ (NSString *)ssid {
    id info = nil;
    NSString * ssid;
    NSArray * ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString * ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        ssid = info[@"SSID"];
        
    }
    return ssid;
    
}

/**
 获取基础服务集标识（站点的MAC地址）

 @return 基础服务集标识
 */
+ (NSString *)bssid {
    id info = nil;
    NSString * bssid;
    NSArray * ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString * ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        bssid = info[@"BSSID"];
        
    }
    return bssid;
    
}


/**
 获取手机运营商代码

 @return 手机运营商代码
 */
+ (NSString *)carrier {
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier * carrier = [info subscriberCellularProvider];
    NSString * carrierCode = [NSString stringWithFormat:@"%@",[carrier mobileNetworkCode]];
    return carrierCode;
}

/**
 获取手机运营商名称

 @return 运营商名称
 */
+ (NSString *)carrierName {
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier * carrier = [info subscriberCellularProvider];
    NSString * carrierStr = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    NSString * carrierCode = [NSString stringWithFormat:@"%@",[carrier mobileNetworkCode]];
    NSLog(@"%@",carrierCode);
    return carrierStr;
    
}


/**
 获取设备唯一标识

 @return 标识码
 */
+ (NSString *)uuid {
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
}


/**
 获取屏幕真实尺寸

 @return 屏幕尺寸
 */
+ (CGSize)nativeScreenSize {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(rect.size.width * scale, rect.size.height * scale);
}


/**
 获取clentIP

 @return clentIP
 */
+ (NSString *)getClientIP {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    NSString *address=[ips lastObject];
    return address;
}


/**
 获取手机外网IP地址

 @return 外网IP地址
 */
+ (NSString *)deviceIPAddress{
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (data) {
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return (ipDic[@"data"][@"ip"] ? ipDic[@"data"][@"ip"] : @"");
    }else {
        return @"";
        
    }
    
}

@end
