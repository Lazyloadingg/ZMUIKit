//
//  ZMTimerPicker.h
//  ZMTimerPicker
//
//  Created by 德一智慧城市 on 2019/7/26.
//  Copyright © 2019年 德一智慧城市. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnBlock)(NSString *selectedStr);

@interface ZMTimerPicker : UIView

/**
 初始化时间选择

 @param block 回调block 参数即是选择的日期
 @return 时间选择器实例
 */
- (instancetype)initWithResponse:(ReturnBlock)block;

/**
 初始化时间选择
 
 @param superView 时间选择器的父View，若为空，将时间选择器加载在window上面
 @param block 回调block 参数即是选择的日期
 @return 时间选择器实例
 */
- (instancetype)initWithSuperView:(UIView *)superView response:(ReturnBlock)block;

/**
 根据参数初始化选择器

 @param ary 参数数组集合 根据参数集合中数组的个数确定显示几列
 @param block 回调block 参数即是选择的日期
 @return 时间选择器实例
 */
- (instancetype)initWithDataArys:(NSArray<NSArray*>*)ary titleText:(NSString*)str response:(ReturnBlock)block;

/**
 pickerView 出现
 */
- (void)show ;

/**
 pickerView 消失
 */
- (void)dismiss;
@end
