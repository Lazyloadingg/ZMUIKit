//
//  DYViewControllerIntercepter.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import "ZMViewControllerIntercepter.h"
#import <Aspects/Aspects.h>
#import <UIKit/UIKit.h>
#import "ZMViewControllerSceneProtocol.h"
#import "UINavigationController+ZMExtension.h"
@implementation DYViewControllerIntercepter

+ (void)load {
    [self setupIntercepter];
}

+ (void)setupIntercepter {
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
        
        id obj = [aspectInfo instance];
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self zm_beforeViewDidLoad:obj];
        }
    }error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo) {
        id obj = [aspectInfo instance];
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self zm_viewWillAppear:obj];
        }
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
        id obj = [aspectInfo instance];
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self zm_viewDidAppear:obj];
        }
    }error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
        id obj = [aspectInfo instance];
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self zm_beforeViewDidDisappear:obj];
        }
    }error:NULL];
    
    
    
}

#pragma mark -
#pragma mark - 👉 视图 加载 之前 👈

+ (void)zm_beforeViewDidLoad:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ZMViewControllerSceneProtocol)]) {
        //  控制器场景配置
        [self configSceneController:viewController];
    }
}

#pragma mark -
#pragma mark - 👉 视图 将要 显示 👈

+ (void)zm_viewWillAppear:(UIViewController *)viewController {
    
//    if ([viewController conformsToProtocol:@protocol(ZMViewControllerSceneProtocol)]) {
//
//        if ([viewController respondsToSelector:@selector(navigationBarBackgroundColor)] && [(id<ZMViewControllerSceneProtocol>)viewController navigationBarBackgroundColor]) {
//            [viewController.navigationController zm_setNavigationBarBackgroundColor:[(id<ZMViewControllerSceneProtocol>)viewController navigationBarBackgroundColor]];
//        }else {
//            [viewController.navigationController zm_setNavigationBarBackgroundColor:[UIColor whiteColor]];
//        }
//
//        if ([viewController respondsToSelector:@selector(navigationBarTintColor)]) {
//
//            viewController.navigationController.navigationBar.barTintColor = [(id<ZMViewControllerSceneProtocol>)viewController navigationBarTintColor];
//        }else {
//            viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        }
//
//        if ([viewController respondsToSelector:@selector(isShowBottomLine)] && [(id<ZMViewControllerSceneProtocol>)viewController isShowBottomLine]) {
//            [viewController.navigationController.navigationBar setShadowImage:nil];
//        }else {
//            [viewController.navigationController.navigationBar setShadowImage:[UIImage new]];
//        }
//
//
//    }else {
//        [viewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [viewController.navigationController.navigationBar setShadowImage:nil];
//        viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    }
}

#pragma mark -
#pragma mark - 👉 视图 已经 显示 👈

+ (void)zm_viewDidAppear:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ZMViewControllerSceneProtocol)]) {
        
        if ([viewController respondsToSelector:@selector(removeOthersFromNavigationController)]) {
            
            BOOL shouldRemove = [(id<ZMViewControllerSceneProtocol>)viewController removeOthersFromNavigationController];
            if (shouldRemove) {
                
                if (viewController.navigationController.viewControllers.count > 1) {
                    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:viewController.navigationController.viewControllers];
                    UIViewController *lastViewController = viewControllers.lastObject;
                    [viewControllers removeAllObjects];
                    [viewControllers addObject:lastViewController];
                    [viewController.navigationController setViewControllers:viewControllers];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark - 👉 视图 已经 消失 👈

+ (void)zm_beforeViewDidDisappear:(UIViewController *)viewController {
    
}

#pragma mark -
#pragma mark - 👉 设置是否打印日志 👈

- (void)setEnableVCDeallocLog:(BOOL)enableVCDeallocLog {
    if (_enableVCDeallocLog != enableVCDeallocLog) {
        _enableVCDeallocLog = enableVCDeallocLog;
        if (enableVCDeallocLog) {
            [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
                
                id obj = [aspectInfo instance];
                if ([obj isKindOfClass:[UIViewController class]]) {
                    [self zm_dealloc:obj];
                }
            }error:NULL];
        }
    }
}

- (void)zm_dealloc:(UIViewController *)viewController {
    
    NSLog(@"\n\n===================================== dealloc =====================================\n\n          🐷%@🐷 dealloc \n\n====================================== dealloc ======================================\n\n", viewController);
}


#pragma mark -
#pragma mark - 👉 配置控制器场景 👈

+ (void)configSceneController:(UIViewController *)viewController {
    
    BOOL isLandscape = NO;
    
    if ([viewController respondsToSelector:@selector(extendedToTop)]) {
        UIViewController <ZMViewControllerSceneProtocol>*vc = (UIViewController <ZMViewControllerSceneProtocol>*)viewController;
        if ([vc extendedToTop]) {
            viewController.edgesForExtendedLayout = UIRectEdgeAll;
        }else{
            viewController.edgesForExtendedLayout = UIRectEdgeBottom|UIRectEdgeLeft|UIRectEdgeRight;
        }
    }else{
        viewController.edgesForExtendedLayout = UIRectEdgeBottom|UIRectEdgeLeft|UIRectEdgeRight;
    }
    
    //  是否是横屏
    if ([viewController respondsToSelector:@selector(isInterfaceOrientationMaskLandscape)]) {
        isLandscape = [(id<ZMViewControllerSceneProtocol>)viewController isInterfaceOrientationMaskLandscape];
    }
    
    if (isLandscape) {//横屏配置
        
    }
    
    viewController.extendedLayoutIncludesOpaqueBars = YES;
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    viewController.modalPresentationCapturesStatusBarAppearance = NO;
    viewController.navigationController.navigationBar.translucent = YES;
}

@end
