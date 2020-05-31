//
//  ZMNavigationController.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "ZMNavigationController.h"
#import "ZMUIKit.h"
#import "ZMViewControllerSceneProtocol.h"

@interface ZMNavigationController ()
<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>

@end

@interface ZMNavigationController()
@property (nonatomic,strong) id popDelegate;
@end

@implementation ZMNavigationController

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Life cycle🐷

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    id target = self.interactivePopGestureRecognizer.delegate;
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;

    
    self.interactivePopGestureRecognizer.enabled = NO;
    [self loadDefaultSetting];
    [self shadowImageHiden];

}

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Public Methods🐷
-(void) shadowImageHiden{
    if (!self.isShowShadowImage) {
         [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
         [self.navigationBar setShadowImage:[UIImage new]];
    }
}

-(UIView *)zm_navigationItemLeftCustomView{
    return self.navigationItem.leftBarButtonItem.customView;
}
#pragma mark -
#pragma mark - >_<! 👉🏻 🐷UIGestureRecognizerDelegate🐷
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:
            UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Event  Response🐷
-(void)popAction:(UIButton *)button{
    if (self.topViewController.interceptBackBlock) {
        self.topViewController.interceptBackBlock();
    }else{
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Private Methods🐷
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UINavigationItem *item= [viewController navigationItem];
        
        
        UIImage * image = [kIconNamed(@"navi_back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * hightedImage = [kIconNamed(@"navi_back_white") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:hightedImage forState:UIControlStateSelected];
        [button setTitleEdgeInsets:UIEdgeInsetsZero];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        button.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [button addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:image style:0 target:self action:@selector(popAction:)];
        item.leftBarButtonItem = backItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷 UINavigationControllerDelegate 🐷
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    BOOL isHideNav = NO;
    if ([viewController conformsToProtocol:@protocol(ZMViewControllerSceneProtocol)]) {
        if ([(id<ZMViewControllerSceneProtocol>)viewController respondsToSelector:@selector(isHiddelNavigationBar)] && [(id<ZMViewControllerSceneProtocol>)viewController isHiddelNavigationBar]) {
            isHideNav = YES;
        }
    }
    
    [self willappearViewController:viewController];
    
    if (self.willTransitionBlock) {
        self.willTransitionBlock(viewController);
    }
    [self setNavigationBarHidden:isHideNav animated:YES];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.delegate =  viewController == self.viewControllers[0]? self.popDelegate : nil;

    if (viewController.interceptBackBlock) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    if (self.didTransitionBlock) {
        self.didTransitionBlock(viewController);
    }
}

- (void)willappearViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ZMViewControllerSceneProtocol)]) {
        
        if ([viewController respondsToSelector:@selector(navigationBarBackgroundColor)] && [(id<ZMViewControllerSceneProtocol>)viewController navigationBarBackgroundColor]) {
            [viewController.navigationController zm_setNavigationBarBackgroundColor:[(id<ZMViewControllerSceneProtocol>)viewController navigationBarBackgroundColor]];
        }
        
        if ([viewController respondsToSelector:@selector(navigationBarTintColor)]) {
            
            viewController.navigationController.navigationBar.barTintColor = [(id<ZMViewControllerSceneProtocol>)viewController navigationBarTintColor];
        }
        
        if ([viewController respondsToSelector:@selector(isShowBottomLine)] && [(id<ZMViewControllerSceneProtocol>)viewController isShowBottomLine]) {
            [viewController.navigationController.navigationBar setShadowImage:nil];
        }else {
            [viewController.navigationController.navigationBar setShadowImage:[UIImage new]];
        }
        
        
    }else {
//        [viewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [viewController.navigationController.navigationBar setShadowImage:nil];
//        viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
}

#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Setter / Getter🐷



#pragma mark -
#pragma mark - >_<! 👉🏻 🐷Default Setting / UI🐷
-(void)loadDefaultSetting{
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark -
#pragma mark - >_<! 👉🏻 栈顶的控制器 一般就是当前可见的控制器🐷
- (UIViewController *)childViewControllerForStatusBarStyle {
    
    //    return self.topViewController;//栈顶的控制器 一般就是当前可见的控制器
    return self.visibleViewController;//当前可见的控制器
}



@end
