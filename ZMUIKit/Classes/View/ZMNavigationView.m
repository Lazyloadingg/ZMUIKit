//
//  ZMNavigationView.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/9/21.
//

#import "ZMNavigationView.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>


@interface ZMNavigationView()
@property (nonatomic, strong,readwrite) UIView * navigationBar;
@end

@implementation ZMNavigationView

- (instancetype)initNavigationView{
     self = [super initWithFrame:CGRectMake(0, 0, kScreen_width, kNavigationHeight())];
    if (self) {
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;

}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷

-(UIView *)navigationBar{
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.zm_h - 44, self.zm_w, 44)];
    }
    return _navigationBar;
}

#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    self.backgroundColor = [UIColor whiteColor];
}
-(void)initSubViews{
    [self addSubview:self.navigationBar];
}
-(void)layout{
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
