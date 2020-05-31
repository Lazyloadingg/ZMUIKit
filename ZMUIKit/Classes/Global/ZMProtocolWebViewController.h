//
//  ZMProtocolWebViewController.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 协议加载控制器（考虑到协议的准确性及时性和重要性，每次进去默认清空缓存加载最新数据）
@interface ZMProtocolWebViewController : UIViewController

/**
 协议路径
 */
@property(nonatomic,copy)NSString * url;

@property(nonatomic,strong)UIColor * trackTintColor;

@property(nonatomic,strong)UIColor * progressTintColor;
@end

NS_ASSUME_NONNULL_END
