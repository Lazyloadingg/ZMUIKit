//
//  SASectionIndexItemView.m
//  SAKitDemo
//
//  Created by 王士昌 on 2017/6/15.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//


#import "ZMIndexItemView.h"
#import "ZMIndexItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+ZMExtension.h"
#import "UIColor+ZMExtension.h"

@interface ZMIndexItemView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZMIndexItemView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        _backgroundImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backgroundImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont zm_font13pt:DYFontBoldTypeB3];
        _titleLabel.textColor = [UIColor colorC1];
        _titleLabel.highlightedTextColor = [UIColor blackColor];
        _titleLabel.shadowColor = [UIColor whiteColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [_titleLabel setHighlighted:highlighted];
    [_backgroundImageView setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [self setHighlighted:selected animated:animated];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    _backgroundImageView.frame = self.contentView.bounds;
    _titleLabel.frame = self.contentView.bounds;
}






@end
