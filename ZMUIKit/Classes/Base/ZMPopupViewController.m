//
//  ZMPopupViewController.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import "ZMPopupViewController.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static CGFloat const kAnimationDuration = 0.25;

@interface ZMPopupViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIView *transitionView;
@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIView *bottomBackgroundView;
@property (nonatomic, strong) UIView *leftBackgroundView;
@property (nonatomic, strong) UIView *rightBackgroundView;

@property (nonatomic, strong) UIView *safeView;
@property (nonatomic, assign, readwrite) BOOL isShowed;
@property (nonatomic, assign) CGFloat contentViewWidth;
@property (nonatomic, assign) CGAffineTransform aniTransform;
@property (nonatomic, weak) UIViewController *showFromContrller;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation ZMPopupViewController {
    DYRectCorner _rectCorner;
    CGSize _cornerSize;
    BOOL _shouldMask;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldMask = NO;
        _cornerSize = CGSizeZero;
        _rectCorner = DYRectCornerAllCorners;
        _isShowed = NO;
        _isAnimating = NO;
        _contentViewSwipeGesEnable = YES;
        _topSafeAreaColor = [UIColor whiteColor];
        _bottomSafeAreaColor = [UIColor whiteColor];
        _leftSafeAreaColor = [UIColor whiteColor];
        _rightSafeAreaColor = [UIColor whiteColor];
        _transitionStyle = DYPopupTransitionStyleFromBottom;
        _layoutType = ZMPopupLayoutTypeLeftBottom;
        _swipeGesEnable = YES;
        _contentViewHeight = 0;
        _spaceRatio = 0;
        _tapGesEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.view.alpha = 0;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.safeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMaskAction)];
    tap.delegate = self;
    tap.enabled = _tapGesEnable;
    [self.view addGestureRecognizer:tap];
    _tap = tap;
    
    if (!_swipeGestureRecognizer) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeAction)];
        swipeGestureRecognizer.delegate = self;
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        _swipeGestureRecognizer = swipeGestureRecognizer;
    }
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear 消失");
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    if (_isAnimating) return;
    _contentViewHeight = _contentViewHeight <= 0 ? CGRectGetHeight(self.view.frame) : _contentViewHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat popupViewWidth = CGRectGetWidth(self.view.frame);
    CGFloat popupViewHeight = CGRectGetHeight(self.view.frame);
    
    CGFloat topSafeSpace = 0;
    CGFloat bottomSafeSpace = 0;
    CGFloat leftSafeSpace = 0;
    CGFloat rightSafeSpace = 0;
    if (@available(iOS 11.0, *)) {
        topSafeSpace= self.view.safeAreaInsets.top;
        topSafeSpace = topSafeSpace == 20 ? 0 : topSafeSpace;
        bottomSafeSpace = self.view.safeAreaInsets.bottom;
        leftSafeSpace = self.view.safeAreaInsets.left;
        rightSafeSpace = self.view.safeAreaInsets.right;
    }
    if (@available(iOS 11.0, *)) {
    }
    CGFloat safeViewHeight = popupViewHeight - topSafeSpace - bottomSafeSpace;
    CGFloat safeViewWidth = popupViewWidth - leftSafeSpace - rightSafeSpace;
    
    CGFloat height = _contentViewHeight > safeViewHeight ? safeViewHeight : _contentViewHeight;
    _contentViewWidth = safeViewWidth * (1-_spaceRatio);
    switch (self.layoutType) {
            case ZMPopupLayoutTypeRightBottom:{
                x = safeViewWidth * _spaceRatio + 0;
                y = safeViewHeight - _contentViewHeight;
                break;
            }
            case ZMPopupLayoutTypeLeftTop:{
                x = 0;
                y = 0;
                break;
            }
            case ZMPopupLayoutTypeLeftBottom:{
                x = 0;
                y = safeViewHeight - _contentViewHeight;
                break;
            }
            case ZMPopupLayoutTypeCenter:{
                x = safeViewWidth * _spaceRatio / 2.0 + 0;
                y = (safeViewHeight - _contentViewHeight) / 2.0;
                break;
            }
        default: {
            x = safeViewWidth * _spaceRatio + 0;
            y = 0;
            break;
        }
    }
    
    self.safeView.frame = CGRectMake(leftSafeSpace, topSafeSpace, safeViewWidth, safeViewHeight);
    self.transitionView.frame = CGRectMake(x, y, _contentViewWidth, height);
    
    self.topBackgroundView.frame = CGRectMake(0, -topSafeSpace, _contentViewWidth, safeViewHeight);
    self.bottomBackgroundView.frame = CGRectMake(0, 0, _contentViewWidth, safeViewHeight + bottomSafeSpace);
    self.leftBackgroundView.frame = CGRectMake(-leftSafeSpace, 0, _contentViewWidth+leftSafeSpace, safeViewHeight);
    self.rightBackgroundView.frame = CGRectMake(0, 0, _contentViewWidth+rightSafeSpace, safeViewHeight+bottomSafeSpace);
    
    self.contentView.frame = CGRectMake(0, 0, _contentViewWidth, height);
    
    [self addTargetView:self.topBackgroundView RoundingCorenrs:_rectCorner cornerRadii:_cornerSize];
    [self addTargetView:self.bottomBackgroundView RoundingCorenrs:_rectCorner cornerRadii:_cornerSize];
    [self addTargetView:self.leftBackgroundView RoundingCorenrs:_rectCorner cornerRadii:_cornerSize];
    [self addTargetView:self.rightBackgroundView RoundingCorenrs:_rectCorner cornerRadii:_cornerSize];
    [self addTargetView:self.contentView RoundingCorenrs:_rectCorner cornerRadii:_cornerSize];
    
}

- (void)addTargetView:(UIView *)view RoundingCorenrs:(DYRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCorner)corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark -
#pragma mark - ZMPopupControllerProtocol

- (void)showFromController:(UIViewController *)fromController animated:(BOOL)animated {
    
    if (_isShowed || _isAnimating) return;
    if ([fromController isKindOfClass:[UITabBarController class]]) {
        
    }else if ([fromController isKindOfClass:[UINavigationController class]]){
        
    }else if ([fromController isKindOfClass:[UIViewController class]]) {
        if (fromController.navigationController) {
            fromController = fromController.navigationController;
        }
    }
    fromController.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.showFromContrller = fromController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [fromController presentViewController:self animated:NO completion:^{
            [self resetContentLayout];
            [self showAnimationWithController:fromController animated:animated];
        }];
    });
    
}

- (void)showFromController:(UIViewController *)fromController {
    
    [self showFromController:fromController animated:YES];
}

- (void)dismiss {
    
    [self dismiss:nil];
}

- (void)dismiss:(dispatch_block_t)compeletion {
    [self dismiss:YES compeletion:compeletion];
}

- (void)dismiss:(BOOL)animated compeletion:(nullable dispatch_block_t)compeletion {
    //    if (!_isShowed) return;
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    __weak __typeof(self)weakSelf = self;
    if (!animated) {
        _transitionView.transform = _aniTransform;
        self.view.alpha = 0;
        [self dismissViewControllerAnimated:NO completion:^{
            weakSelf.isShowed = NO;
            weakSelf.isAnimating = NO;
            weakSelf.transitionView.transform = CGAffineTransformIdentity;
            if (compeletion) {
                compeletion();
            }
        }];
    }else{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            weakSelf.transitionView.transform = weakSelf.aniTransform;
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                weakSelf.isShowed = NO;
                weakSelf.isAnimating = NO;
                weakSelf.transitionView.transform = CGAffineTransformIdentity;
                if (compeletion) {
                    compeletion();
                }
            }];
        }];
    }
}

#pragma mark-
#pragma mark-   UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        if (gestureRecognizer == _swipeGestureRecognizer) {
            return _contentViewSwipeGesEnable;
        }
        return NO;
    }else if ([touch.view isDescendantOfView:self.safeView]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark-
#pragma mark-   response action
- (void)didTapMaskAction {
    if (self.didClickMaskBlock) {
        self.didClickMaskBlock();
    }
    [self dismiss];
}

- (void)didSwipeAction {
    if (self.didSwipeBlock) {
        self.didSwipeBlock();
    }
    [self dismiss];
}

#pragma mark-
#pragma mark-   public method
- (void)setBorderCorners:(DYRectCorner)corners {
    [self setBorderCorners:corners cornerRadii:CGSizeMake(3, 3)];
}


- (void)setBorderCorners:(DYRectCorner)corners cornerRadii:(CGSize)cornerRadii {
//        [self.contentView addRoundingCorenrs:corners cornerRadii:CGSizeMake(10, 10)];
//        [_topBackgroundView addRoundingCorenrs:corners cornerRadii:CGSizeMake(10, 10)];
//        [_bottomBackgroundView addRoundingCorenrs:corners cornerRadii:CGSizeMake(10, 10)];
    _shouldMask = YES;
    _rectCorner = corners;
    _cornerSize = cornerRadii;
}

#pragma mark-
#pragma mark-   private method
- (void)resetContentLayout {
    
    switch (self.transitionStyle) {
            case DYPopupTransitionStyleFromRight:{
                _aniTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, _contentViewWidth, 0);
                break;
            }
            case DYPopupTransitionStyleFromLeft:{
                _aniTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, -_contentViewWidth, 0);
                break;
            }
            case DYPopupTransitionStyleFromTop:{
                _aniTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -_contentViewHeight);
                break;
            }
            case DYPopupTransitionStyleCover:{
                _aniTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                break;
            }
        default:{
            _aniTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, _contentViewHeight);
            break;
        }
    }
    _transitionView.transform = _aniTransform;
    
}

- (void)showAnimationWithController:(UIViewController *)vc animated:(BOOL)animated {
    
    _isAnimating = YES;
    if (animated) {
        
        __weak __typeof(self)weakSelf = self;
        if (self.transitionStyle == DYPopupTransitionStyleCover) {
            [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.transitionView.transform = CGAffineTransformIdentity;
                self.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isShowed = YES;
                }
                weakSelf.isAnimating = NO;
            }];
        }else{
            [UIView animateWithDuration:kAnimationDuration animations:^{
                weakSelf.transitionView.transform = CGAffineTransformIdentity;
                self.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isShowed = YES;
                }
                weakSelf.isAnimating = NO;
            }];
        }
    }else{
        _transitionView.transform = CGAffineTransformIdentity;
        self.view.alpha = 1.0;
        _isShowed = YES;
        _isAnimating = NO;
    }
}

#pragma mark-
#pragma mark-   setters and getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UIView *)transitionView {
    if (!_transitionView) {
        _transitionView = [[UIView alloc] init];
    }
    return _transitionView;
}

- (UIView *)safeView {
    if (!_safeView) {
        _safeView = [UIView new];
        [_safeView addSubview:self.transitionView];
        [self.transitionView addSubview:self.topBackgroundView];
        [self.transitionView addSubview:self.bottomBackgroundView];
        [self.transitionView addSubview:self.leftBackgroundView];
        [self.transitionView addSubview:self.rightBackgroundView];
        [self.transitionView addSubview:self.contentView];
    }
    return _safeView;
}

- (UIView *)topBackgroundView {
    if (!_topBackgroundView) {
        _topBackgroundView = [UIView new];
        _topBackgroundView.hidden = YES;
        _topBackgroundView.backgroundColor = self.topSafeAreaColor;
    }
    return _topBackgroundView;
}

- (UIView *)bottomBackgroundView {
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [UIView new];
        _bottomBackgroundView.backgroundColor = self.bottomSafeAreaColor;
    }
    return _bottomBackgroundView;
}

- (UIView *)leftBackgroundView {
    if (!_leftBackgroundView) {
        _leftBackgroundView = [UIView new];
        _leftBackgroundView.backgroundColor = self.leftSafeAreaColor;
    }
    return _leftBackgroundView;
}

- (UIView *)rightBackgroundView {
    if (!_rightBackgroundView) {
        _rightBackgroundView = [UIView new];
        _rightBackgroundView.backgroundColor = self.rightSafeAreaColor;
    }
    return _rightBackgroundView;
}

- (void)setTransitionStyle:(DYPopupTransitionStyle)transitionStyle {
    if (_transitionStyle == transitionStyle) return;
    
    _transitionStyle = transitionStyle;
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeAction)];
    swipeGestureRecognizer.enabled = _swipeGesEnable;
    switch (transitionStyle) {
            case DYPopupTransitionStyleFromLeft:
            self.topBackgroundView.hidden = NO;
            self.bottomBackgroundView.hidden = NO;
            self.rightBackgroundView.hidden = YES;
            self.leftBackgroundView.hidden = NO;
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            break;
            case DYPopupTransitionStyleFromTop:
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
            self.topBackgroundView.hidden = NO;
            self.bottomBackgroundView.hidden = YES;
            self.rightBackgroundView.hidden = NO;
            self.leftBackgroundView.hidden = NO;
            break;
            case DYPopupTransitionStyleFromRight:
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
            self.topBackgroundView.hidden = NO;
            self.bottomBackgroundView.hidden = NO;
            self.rightBackgroundView.hidden = NO;
            self.leftBackgroundView.hidden = YES;
            break;
            case DYPopupTransitionStyleCover: {
                swipeGestureRecognizer.enabled = YES;
                self.topBackgroundView.hidden = YES;
                self.bottomBackgroundView.hidden = YES;
                self.rightBackgroundView.hidden = YES;
                self.leftBackgroundView.hidden = YES;
            }
            break;
        default:
            self.topBackgroundView.hidden = YES;
            self.bottomBackgroundView.hidden = NO;
            self.rightBackgroundView.hidden = NO;
            self.leftBackgroundView.hidden = NO;
            swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
            break;
    }
    swipeGestureRecognizer.delegate = self;
    
    if (_swipeGestureRecognizer) {
        [self.view removeGestureRecognizer:_swipeGestureRecognizer];
        [self.view addGestureRecognizer:swipeGestureRecognizer];
        _swipeGestureRecognizer = nil;
    }
    _swipeGestureRecognizer = swipeGestureRecognizer;
}

- (void)setSwipeGesEnable:(BOOL)swipeGesEnable {
    if (swipeGesEnable == _swipeGesEnable) return;
    _swipeGesEnable = swipeGesEnable;
    _swipeGestureRecognizer.enabled = swipeGesEnable;
}

- (void)setTapGesEnable:(BOOL)tapGesEnable {
    _tapGesEnable = tapGesEnable;
    _tap.enabled = tapGesEnable;
}

- (void)setTopSafeAreaColor:(UIColor *)topSafeAreaColor {
    _topSafeAreaColor = topSafeAreaColor;
    self.topBackgroundView.backgroundColor = topSafeAreaColor;
}

- (void)setBottomSafeAreaColor:(UIColor *)bottomSafeAreaColor {
    _bottomSafeAreaColor = bottomSafeAreaColor;
    self.bottomBackgroundView.backgroundColor = bottomSafeAreaColor;
}

- (void)setLeftSafeAreaColor:(UIColor *)leftSafeAreaColor {
    _leftSafeAreaColor = leftSafeAreaColor;
    self.leftBackgroundView.backgroundColor = leftSafeAreaColor;
}

- (void)setRightSafeAreaColor:(UIColor *)rightSafeAreaColor {
    _rightSafeAreaColor = rightSafeAreaColor;
    self.rightBackgroundView.backgroundColor = rightSafeAreaColor;
}


@end




static char *const kViewControllerEdgeArrayKey = "com.dy.viewControllerEdgeArray.Key";
static char *const kViewControllerPopupArrayKey = "com.dy.viewControllerPopupArray.Key";

@interface UIViewController ()

@property (nonatomic, strong) NSMutableArray *edgeArray;
@property (nonatomic, strong) NSMutableArray *popupArray;

@end

@implementation UIViewController (DYEdgePanGestrueRecognizer)

- (void)addEdgeGestrueRecognizer:(ZMPopupViewController *)popupVC {
    [self addEdgeGestrueRecognizer:popupVC showFormController:self];
}

- (void)addEdgeGestrueRecognizer:(ZMPopupViewController *)popupVC showFormController:(UIViewController *)showFormController {
    if (!popupVC) return;
    if (popupVC.transitionStyle == DYPopupTransitionStyleFromLeft || popupVC.transitionStyle == DYPopupTransitionStyleFromRight) {
        UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panToShowPopup:)];
        edgePanGestureRecognizer.edges = popupVC.transitionStyle == DYPopupTransitionStyleFromRight ? UIRectEdgeRight : UIRectEdgeLeft;
        [self.view addGestureRecognizer:edgePanGestureRecognizer];
        [self addPopup:popupVC gestureRec:edgePanGestureRecognizer];
    }
    popupVC.showFromContrller = showFormController;
}

- (void)panToShowPopup:(UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer {
    ZMPopupViewController *popupVC = [self getPopupWithGestureRec:edgePanGestureRecognizer];
    if (popupVC.isShowed) return;
    
    switch (edgePanGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:{
                
                popupVC.showFromContrller.definesPresentationContext = YES;
                popupVC.providesPresentationContextTransitionStyle = YES;
                popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                popupVC.view.hidden = YES;
                
                [popupVC.showFromContrller presentViewController:popupVC animated:NO completion:^{
                    [popupVC viewWillLayoutSubviews];
                    popupVC.isAnimating = YES;
                    [popupVC resetContentLayout];
                }];
                break;
            }
            case UIGestureRecognizerStateChanged:{
                // 让view跟着手指去移动
                // 取到手势在当前控制器视图中识别的位置
                popupVC.view.hidden = NO;
                CGPoint p = [edgePanGestureRecognizer locationInView:self.view];
                popupVC.view.alpha = 1;
                switch (popupVC.transitionStyle) {
                        case DYPopupTransitionStyleFromRight:{
                            
                            CGFloat tx = p.x - popupVC.spaceRatio * CGRectGetWidth(popupVC.showFromContrller.view.frame);
                            popupVC.transitionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, tx, 0);
                            break;
                        }
                    default:{
                        CGFloat tx = p.x - popupVC.contentViewWidth;
                        popupVC.transitionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, tx, 0);
                        break;
                    }
                }
                
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                // 判断当前广告视图在屏幕上显示是否超过一半
                CGPoint p = [edgePanGestureRecognizer locationInView:self.view];
                BOOL shouldShow = YES;
                popupVC.isAnimating = NO;
                switch (popupVC.transitionStyle) {
                        case DYPopupTransitionStyleFromRight:{
                            if (p.x > CGRectGetWidth(popupVC.showFromContrller.view.frame)/4.0*3.0) {
                                shouldShow = NO;
                            }
                            break;
                        }
                    default:{
                        if (p.x < CGRectGetWidth(popupVC.showFromContrller.view.frame)/4.0) {
                            shouldShow = NO;
                        }
                        break;
                    }
                }
                if (!shouldShow) {
                    // 如果没有,隐藏
                    popupVC.isShowed = YES;
                    [popupVC dismiss:nil];
                }else{
                    [popupVC showAnimationWithController:popupVC.showFromContrller animated:YES];
                }
                break;
            }
        default:
            break;
    }
}

- (void)addPopup:(ZMPopupViewController *)popupVC gestureRec:(UIGestureRecognizer *)gestureRec {
    if (![self.popupArray containsObject:popupVC]) {
        [self.popupArray addObject:popupVC];
        [self.edgeArray addObject:gestureRec];
    }
}

- (ZMPopupViewController *)getPopupWithGestureRec:(UIGestureRecognizer *)gestureRec {
    NSInteger index = [self.edgeArray indexOfObject:gestureRec];
    if (index != NSNotFound && index < self.popupArray.count) {
        return [self.popupArray objectAtIndex:index];
    }
    return nil;
}

- (NSMutableArray *)edgeArray {
    NSMutableArray *edgeArray = objc_getAssociatedObject(self, kViewControllerEdgeArrayKey);
    if (!edgeArray){
        edgeArray = [NSMutableArray array];
        objc_setAssociatedObject(self, kViewControllerEdgeArrayKey, edgeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return edgeArray;
    
}

- (NSMutableArray *)popupArray {
    NSMutableArray *popupArray = objc_getAssociatedObject(self, kViewControllerPopupArrayKey);
    if (!popupArray){
        popupArray = [NSMutableArray array];
        objc_setAssociatedObject(self, kViewControllerPopupArrayKey, popupArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return popupArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
