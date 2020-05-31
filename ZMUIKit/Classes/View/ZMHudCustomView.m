//
//  ZMHudCustomDemoView.m
//  ZMUIKit_Example
//
//  Created by 王士昌 on 2019/8/17.
//  Copyright © 2019 王士昌. All rights reserved.
//

#import "ZMHudCustomView.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

@implementation ZMHudCustomView

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self setupSubviewsContraints];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    CGSize newSize = CGSizeEqualToSize(self.contentSize, CGSizeZero) ? size : self.contentSize;
    return newSize;
}
#pragma mark -
#pragma mark - 👉 Request 👈

#pragma mark -
#pragma mark - 👉 DYNetworkResponseProtocol 👈

#pragma mark -
#pragma mark - 👉 <#Delegate#> 👈

#pragma mark -
#pragma mark - 👉 UIScrollViewDelegate 👈

#pragma mark -
#pragma mark - 👉 Event response 👈

#pragma mark -
#pragma mark - 👉 Private Methods 👈

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage zm_kitImageNamed:@"kit_hud_cycle"]];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 1.5;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [_imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"loading...";
        _titleLabel.textColor = [UIColor colorC3];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont zm_font16pt:DYFontBoldTypeRegular];
    }
    return _titleLabel;
}
#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(kScreenWidthRatio(-13));
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
    }];
}

@end
