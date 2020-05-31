//
//  ZMMinuteModel.h
//  ZMTimerPicker
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019年 德一智慧城市. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMMinuteModel : NSObject

/// 实际分钟
@property (nonatomic, copy) NSString *minuteString;

/// 展示的分钟
@property (nonatomic, copy) NSString *showMinuteString;
@end
