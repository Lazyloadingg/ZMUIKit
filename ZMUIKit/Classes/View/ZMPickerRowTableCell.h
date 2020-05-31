//
//  ZMPickerRowTableCell.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMPickerRowTableCell : UITableViewCell

@property (nonatomic, assign) BOOL zm_selected;

@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
