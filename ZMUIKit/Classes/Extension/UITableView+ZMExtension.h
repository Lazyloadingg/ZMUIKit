//
//  UITableView+Extension.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZMExtension)


/**
 注册xib cell

 @param nibName xib name
 @param identifier cell identifier
 */
-(void)registerNib:(NSString *)nibName forCellIdentifier:(NSString *)identifier;

/**
 最后一个section
 
 @return 下标
 */
-(NSInteger)lastSection;

/**
 最后cell下标
 
 @return 下标
 */
-(NSIndexPath * )lastCell;

/**
 指定section最后一个cell下标
 
 @param section section
 @return 下标
 */
-(NSIndexPath *)lastCellIndexPathWithSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
