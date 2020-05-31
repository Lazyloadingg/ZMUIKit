//
//  UIViewController+Extension.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import <UIKit/UIKit.h>
#import "ZMNavigationController.h"
#import "ZMTabBarController.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (ZMExtension)

@property (nonatomic, strong, readonly) ZMNavigationController *zm_navigationController;

@property (nonatomic, strong, readonly) ZMTabbarController *zm_tabBarController;

/** statusBarStyle  */
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;
/** 隐藏 statusBar*/
@property(nonatomic,assign)BOOL zm_statusBarHidden;
/** 拦截自定义back btn事件*/
@property (nonatomic,copy)dispatch_block_t interceptBackBlock;

- (void)zm_popWithEntryControllerClass:(Class)entryControllerClass;

- (void)zm_popWithEntryControllerClass:(Class)entryControllerClass beforePage:(BOOL)before;

- (void)zm_popWithPartControllerCount:(NSUInteger)partControllerCount;

/// 获取当前显示的视图的控制器
+ (UIViewController *)zm_getCurrentController;

@end





/// 电商模块控制器统一化定制
@interface UIViewController (DYShopGoods)

/*! 回到顶部按钮  */
@property (nonatomic, strong) UIButton *zm_topButton;

/*! 购物车按钮  */
@property (nonatomic, strong) UIButton *zm_shopCartButton;


@end


NS_ASSUME_NONNULL_END
