//
//  ZMDownMenuView.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/25.
//

#import "ZMDownMenuView.h"
#import <Masonry/Masonry.h>

static NSTimeInterval const timeInterval = 0.25;

@interface ZMDownMenuView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, weak) UIViewController *controller;

@end

@implementation ZMDownMenuView

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFromView:(UIView *)view atController:(UIViewController *)controller {
    if (self = [super init]) {
        _fromView = view;
        _controller = controller;
        CGRect rect = [view convertRect:view.bounds toView:controller.view];
        
        CGFloat formY = rect.origin.y + rect.size.height;
        [self addSubview:self.maskView];
        [controller.view addSubview:self];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(formY);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self addTapToView:self.maskView withSEL:@selector(handleTap:)];
        [self layoutIfNeeded];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self.maskView) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - 👉 Event response 👈

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if (self.didTapEventMaskBlock) {
        self.didTapEventMaskBlock(self);
    }else if (self.didTapMaskBlock) {
        self.didTapMaskBlock();
    }else {
        [self dismiss];
    }
}

#pragma mark -
#pragma mark - 👉 Public Methods 👈

- (void)show {
    [self showFromView:self.fromView withController:self.controller];
}

- (void)showFromView:(UIView *)view withController:(UIViewController *)controller {
    self.alpha = 1;
    CGRect rect = [view convertRect:view.bounds toView:controller.view];
    CGFloat formY = rect.origin.y + rect.size.height;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(formY);
    }];
    [UIView animateWithDuration:timeInterval animations:^{
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentHight);
        }];
        [self.maskView layoutIfNeeded];
    } completion:NULL];
}

- (void)dismiss {

    [UIView animateWithDuration:timeInterval animations:^{
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.maskView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
}

#pragma mark -
#pragma mark - 👉 Private Methods 👈

- (void)addTapToView:(UIView *)view withSEL:(SEL)sel {
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:sel];
    tapRecognize.delegate = self;
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.numberOfTouchesRequired = 1;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapRecognize];
}

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor clearColor];
        [_maskView addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
    return _maskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}



@end
