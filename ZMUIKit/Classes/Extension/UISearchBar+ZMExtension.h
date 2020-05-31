//
//  UISearchBar+Extension.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (ZMExtension)

@property (nonatomic, strong, readonly) UITextField *zm_searchTextField;

@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
