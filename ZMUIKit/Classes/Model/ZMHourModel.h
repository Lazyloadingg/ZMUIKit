//
//  ZMHourModel.h
//  ZMTimerPicker
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019年 德一智慧城市. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMHourModel : NSObject

/// 实际小时
@property (nonatomic, copy) NSString *hourString;

/// 展示的小时
@property (nonatomic, copy) NSString *showHourString;
@end
