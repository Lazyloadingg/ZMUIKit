//
//  DYPickerRow.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DYPickerRow;
@protocol DYPickerRowDataSource <NSObject>
@required

- (NSInteger)zm_numberOfRowsInRowPickerView:(DYPickerRow *)rowPickerView;

// 所需的显示数量- > 2 n + 1 (int n > 1)
- (NSInteger)zm_numberOfDisplayRowsInRowPickerView:(DYPickerRow *)rowPickerView;

@end


@protocol DYPickerRowDelegate <NSObject>

@optional

/*! 内容  */
- (NSString *)zm_rowPickerView:(DYPickerRow *)rowPickerView contentForRowAtIndex:(NSInteger)index;

/*! 行高度  */
- (CGFloat)zm_heightForRowInRowPickerView:(DYPickerRow *)rowPickerView;

/*! 选中行的响应  */
- (void)zm_rowPickerView:(DYPickerRow *)rowPickerView didSelectRowAtIndex:(NSInteger)index;

@end


@interface DYPickerRow : UIView

@property(nonatomic, weak) id <DYPickerRowDataSource>dataSource;
@property(nonatomic, weak) id <DYPickerRowDelegate>delegate;

- (void)setSelectRowAtIndex:(NSInteger)index animation:(BOOL)animation;

- (void)reloadData;
- (void)reloadDataWithSelectRowAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
