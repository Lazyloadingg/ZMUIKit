//
//  ZMPickerProtocol.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZMPickerController;
@protocol DYPickerDataSource <NSObject>

// 返回要显示的“列”的数目。
- (NSInteger)numberOfComponentsInPickerViewController:(ZMPickerController *)pickerView;

// 返回每个组件中的行号..
- (NSInteger)pickerViewController:(ZMPickerController *)pickerController numberOfRowsInComponent:(NSInteger)component;

@end

@protocol DYPickerDelegate <NSObject>

@optional

// 返回每个组件的列宽和行高。
- (CGFloat)pickerViewController:(ZMPickerController *)pickerController widthForComponent:(NSInteger)component __TVOS_PROHIBITED;
- (CGFloat)pickerViewController:(ZMPickerController *)pickerController rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED;

// 这些方法返回一个普通的NSString、一个NSAttributedString或一个视图(e。g UILabel)来显示组件的行。
// 对于视图版本，我们缓存任何隐藏的、因此未使用的视图，并将它们传递回去以便重用。
// 如果返回一个不同的对象，旧的对象将被释放。视图将以行rect为中心
- (nullable NSString *)pickerViewController:(ZMPickerController *)pickerController titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED;

- (void)pickerViewController:(ZMPickerController *)pickerController didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED;

- (void)pickerViewController:(ZMPickerController *)pickerController valueChangedRow:(NSInteger)row inComponent:(NSInteger)component;

@end

NS_ASSUME_NONNULL_END
