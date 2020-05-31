//
//  ZMNavigationController.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import <UIKit/UIKit.h>
#import <HBDNavigationBar/HBDNavigationController.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^DYNavigationTransitionBlock)(UIViewController *showViewController);

@interface ZMNavigationController : HBDNavigationController

@property (nonatomic, strong) UINavigationBar *zm_navigationBar;

/** 设置导航转场将要完成的block */
@property (nonatomic, copy) DYNavigationTransitionBlock willTransitionBlock;

/** 设置导航转场已经完成的block */
@property (nonatomic, copy) DYNavigationTransitionBlock didTransitionBlock;

/** 隐藏导航条黑线 */
@property (nonatomic, assign) BOOL isShowShadowImage;

/// 获取导航栏左侧自定义view
- (UIView *)zm_navigationItemLeftCustomView;

@end

NS_ASSUME_NONNULL_END
