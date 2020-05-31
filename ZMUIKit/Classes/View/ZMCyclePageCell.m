//
//  DYCyclePagerCell.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/27.
//

#import "ZMCyclePageCell.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

@implementation ZMCyclePageCell

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviewsContraints];
    }
    return self;
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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
