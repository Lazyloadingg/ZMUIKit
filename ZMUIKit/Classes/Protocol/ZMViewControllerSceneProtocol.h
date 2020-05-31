//
//  ZMViewControllerSceneProtocol.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 控制器新版配置协议
 */
@protocol ZMViewControllerSceneProtocol <NSObject>

@optional

/**
 设置视图控制器的 view 是否延展到顶部（默认为 NO）.
 
 @return 是否延展到顶部
 */
- (BOOL)extendedToTop;

/**
 是否显示底部线条 默认不显示

 @return 导航底部线条显隐性
 */
- (BOOL)isShowBottomLine;

/**
 是否隐藏导航栏（默认不隐藏）

 @return YES 隐藏  NO  不隐藏
 */
- (BOOL)isHiddelNavigationBar;

/**
 设置导航条的颜色（默认白色）

 @return 导航条的颜色
 */
- (UIColor *)navigationBarTintColor;

/**
 通过设置背景图片方式修改背景颜色

 @return 导航栏颜色
 */
- (UIColor *)navigationBarBackgroundColor;

/** 
 设置是否从导航中移除其他的控制器，默认为 NO，不移除。
 
 @return 是否移除
 */
- (BOOL)removeOthersFromNavigationController;

/**
 设置是否是横屏显示，默认为 NO。横屏界面需要额外实现这个方法
 
 @return 是否是横屏
 */
- (BOOL)isInterfaceOrientationMaskLandscape;


/**
 点击titleView
 */
- (void)didTapTitleView;


@end

NS_ASSUME_NONNULL_END
