//
//  UIViewController+Extension.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import "UIViewController+ZMExtension.h"
#import <objc/runtime.h>
#import "UIColor+ZMExtension.h"

static char *kStatusBarStyle = "kStatusBarStyle";
static char *kStatusBarHidden = "kStatusBarHidden";
static char *kInterceptBackBlock = "kInterceptBackBlock";

static char *kTopButtonKey = "com.ZMUIKit.topButton.key";
static char *kShopCartButtonKey = "com.ZMUIKit.shopCartButton.key";

@implementation UIViewController (ZMExtension)

-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    NSNumber * value = [NSNumber numberWithInteger:statusBarStyle];
    objc_setAssociatedObject(self, &kStatusBarStyle, value, OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsStatusBarAppearanceUpdate];
}
-(UIStatusBarStyle)statusBarStyle{
    NSNumber * value = objc_getAssociatedObject(self, &kStatusBarStyle);
    return value.integerValue;
}
-(void)setzm_statusBarHidden:(BOOL)zm_statusBarHidden{
    NSNumber * value = [NSNumber numberWithBool:zm_statusBarHidden];
    objc_setAssociatedObject(self, &kStatusBarHidden, value, OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsStatusBarAppearanceUpdate];
}
-(BOOL)zm_statusBarHidden{
    NSNumber * value = objc_getAssociatedObject(self, &kStatusBarHidden);
    return value.integerValue;
}

-(BOOL)prefersStatusBarHidden{
    return self.zm_statusBarHidden;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}


- (void)setInterceptBackBlock:(dispatch_block_t)interceptBackBlock{
    objc_setAssociatedObject(self, &kInterceptBackBlock, interceptBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)interceptBackBlock{
    return objc_getAssociatedObject(self, &kInterceptBackBlock);
}




- (ZMNavigationController *)zm_navigationController {
    if (self.navigationController && [self.navigationController isKindOfClass:[ZMNavigationController class]]) {
        return (ZMNavigationController *)self.navigationController;
    }
    return nil;
}

- (ZMTabbarController *)zm_tabBarController {
    if (self.tabBarController && [self.tabBarController isKindOfClass:[ZMTabbarController class]]) {
        return (ZMTabbarController *)self.tabBarController;
    }
    return nil;
}

- (void)zm_popWithEntryControllerClass:(Class)entryControllerClass {
    [self zm_partPopWithEntryControllerClass:entryControllerClass animated:YES beforePage:NO];
}

- (void)zm_popWithEntryControllerClass:(Class)entryControllerClass beforePage:(BOOL)before {
    [self zm_partPopWithEntryControllerClass:entryControllerClass animated:YES beforePage:before];
}

- (void)zm_popWithPartControllerCount:(NSUInteger)partControllerCount {
    [self zm_partPopWithPartControllerCount:partControllerCount animated:YES];
}


- (void)zm_partPopWithEntryControllerClass:(Class)entryControllerClass animated:(BOOL)animated beforePage:(BOOL)before {
    if(self.navigationController) {
        __block NSInteger index = 0;
        [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:entryControllerClass]) {
                *stop = YES;
                if (before) {
                    index = idx - 1;
                }else {
                    index = idx;
                }
            }
        }];
        [self zm_partPopToIndex:index animated:animated];
    }else if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:NULL];
    }
}


- (void)zm_partPopWithPartControllerCount:(NSUInteger)partControllerCount animated:(BOOL)animated {
    if(self.navigationController) {
        NSUInteger index = self.navigationController.viewControllers.count - partControllerCount - 1;
        [self zm_partPopToIndex:index animated:animated];
    }else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:NULL];
    }
}

- (void)zm_partPopToIndex:(NSInteger)index animated:(BOOL)animated {
    if(index < 0) {
        UIViewController *presentingController = self.navigationController.presentingViewController ?: self.presentingViewController;
        if (presentingController){
            [presentingController dismissViewControllerAnimated:animated completion:NULL];
        }else if(self.navigationController) {
            [self.navigationController popToRootViewControllerAnimated:animated];
        }
    } else if (self.navigationController.viewControllers.count > index){
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:animated];
    }
}

+ (UIViewController *)zm_getCurrentController{

    UIViewController* currentViewController = [self zm_getCurrentWindowRootController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {

            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {

          UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];

        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {

          UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {

            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {

                currentViewController = currentViewController.childViewControllers.lastObject;

                return currentViewController;
            } else {

                return currentViewController;
            }
        }

    }
    return currentViewController;
}
//// 获取当前屏幕显示的viewController
//+ (UIViewController *)zm_getCurrentController {
//
//    UIViewController  *superVC = [[self class]  getCurrentWindowViewController];
//    if ([superVC isKindOfClass:[UITabBarController class]]) {
//        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
//        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
//            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
//        }
//        return tabSelectVC;
//    }
//    return superVC;
//}

/// 获取当前窗口根控制器
+ (UIViewController *)zm_getCurrentWindowRootController {
    
    UIViewController *currentWindowVC = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        currentWindowVC = nextResponder;
    }else{
        currentWindowVC = window.rootViewController;
    }
    return currentWindowVC;
}
@end










@implementation UIViewController (DYShopGoods)

- (void)setzm_topButton:(UIButton *)zm_topButton {
    objc_setAssociatedObject(self, kTopButtonKey, zm_topButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)zm_topButton {
    UIButton *topBtn = objc_getAssociatedObject(self, kTopButtonKey);
    if (!topBtn) {
        topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.backgroundColor = [UIColor whiteColor];
        topBtn.layer.borderColor = [UIColor colorGray1].CGColor;
        topBtn.layer.borderWidth = 2.f;
        topBtn.layer.cornerRadius = 20.f;
        topBtn.alpha = 0;
        [topBtn setImage:[UIImage imageNamed:@"dyshop_trolley_top"] forState:UIControlStateNormal];
        [topBtn setImage:[UIImage imageNamed:@"dyshop_trolley_top"] forState:UIControlStateSelected];
        [topBtn setImage:[UIImage imageNamed:@"dyshop_trolley_top"] forState:UIControlStateHighlighted];
        objc_setAssociatedObject(self, kTopButtonKey, topBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return topBtn;
}

- (void)setzm_shopCartButton:(UIButton *)zm_shopCartButton {
    objc_setAssociatedObject(self, kShopCartButtonKey, zm_shopCartButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)zm_shopCartButton {
    UIButton *shopCartButton = objc_getAssociatedObject(self, kShopCartButtonKey);
    if (!shopCartButton) {
        shopCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shopCartButton.backgroundColor = [UIColor whiteColor];
        shopCartButton.layer.borderColor = [UIColor colorGray1].CGColor;
        shopCartButton.layer.borderWidth = 2.f;
        shopCartButton.layer.cornerRadius = 20.f;
        shopCartButton.alpha = 0;
        [shopCartButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [shopCartButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [shopCartButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        objc_setAssociatedObject(self, kShopCartButtonKey, shopCartButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return shopCartButton;
}


@end
