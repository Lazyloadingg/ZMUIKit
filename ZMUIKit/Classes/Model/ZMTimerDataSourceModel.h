//
//  ZMTimerDataSourceModel.h
//  ZMDatePickerView
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019 德一智慧城市. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - pickerView的数据源
@interface ZMTimerDataSourceModel : NSObject

/// 日期数据源
@property (nonatomic, strong) NSMutableArray *dateArray;

/// 小时数据源
@property (nonatomic, strong) NSMutableArray *hourArray;

/// 分钟数据源
@property (nonatomic, strong) NSMutableArray *minuteArray;

/// 当天的分钟数据源
@property (nonatomic, strong) NSMutableArray *todayMinuteArray;

/// 当天的小时数据源
@property (nonatomic, strong) NSMutableArray *todayHourArray;

@end



