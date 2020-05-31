//
//  ZMDateModel.h
//  ZMTimerPicker
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019年 德一智慧城市. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDateModel : NSObject

/// 实际日期
@property (nonatomic, copy) NSString *dateString;

/// 展示的日期
@property (nonatomic, copy) NSString *showDateString;

@end

