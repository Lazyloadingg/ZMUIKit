//
//  UITextField+ZMExtension.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/17.
//

#import <UIKit/UIKit.h>
#import "ZMKeyboardView.h"
NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZMExtension)<ZMKeyboardViewDelegate>

/**是否显示长按菜单 YES 显示，NO 不显示 ，默认YES*/
@property(nonatomic,assign)BOOL isMenu;

@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
