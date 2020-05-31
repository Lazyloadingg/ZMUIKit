//
//  DYUtil.h
//  ZMTimerPicker
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019年 德一智慧城市. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZMTimerDataSourceModel;

@interface ZMTimerUtil : NSObject

/**
 获取pickerView数据源

 @return pickerView数据源
 */
+ (ZMTimerDataSourceModel *)configDataSource;

@end
