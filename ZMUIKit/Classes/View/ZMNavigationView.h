//
//  ZMNavigationView.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义导航栏view
@interface ZMNavigationView : UIView

@property (nonatomic, strong,readonly) UIView * navigationBar;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/// 指定构造方法
- (instancetype)initNavigationView NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
