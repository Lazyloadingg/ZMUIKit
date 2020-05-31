//
//  ZMCameraIDCardToolView.m
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/28.
//

#import "ZMCameraIDCardToolView.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

#define kCameraIDCardBoxWidth kScreenWidthRatio(255)
#define kCameraIDCardBoxHeight kScreenWidthRatio(406)

@interface ZMCameraIDCardToolView()


@property (nonatomic, strong) CAShapeLayer * maskLayer;

@end

@implementation ZMCameraIDCardToolView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
-(void)dismissAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDismissAction)]) {
        [self.delegate onDismissAction];
    }
}
-(void)takePhotoAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTakePictureAction)]) {
        [self.delegate onTakePictureAction];
    }
}
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
- (UIImageView *)boxImg{
    if (!_boxImg) {
        _boxImg = [[UIImageView alloc]init];
        [_boxImg setImage:[UIImage zm_kitImageNamed:@"zm_camera_idcard_front"]];
    }
    return _boxImg;
}
-(UIImageView *)preImg{
    if (!_preImg) {
        _preImg = [[UIImageView alloc]init];
    }
    return _preImg;
}
- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc]init];
        [_dismissBtn setImage:[UIImage zm_kitImageNamed:@"zm_camera_dismiss_btn"]  forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}
-(UIButton *)takePhotoBtn{
    if (!_takePhotoBtn) {
        _takePhotoBtn = [[UIButton alloc]init];
        [_takePhotoBtn setImage:[UIImage zm_kitImageNamed:@"zm_camera_takeimage_btn"]  forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoBtn;
}
-(CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreen_width, kScreen_height)];
        CGFloat x = (kScreen_width / 2.0) - (kCameraIDCardBoxWidth / 2.0);
        [bpath appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(x, kNavigationHeight() + 46 , kCameraIDCardBoxWidth, kCameraIDCardBoxHeight)] bezierPathByReversingPath]];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bpath.CGPath;
        shapeLayer.fillColor = [[UIColor colorBlack1] colorWithAlphaComponent:0.6].CGColor;
        _maskLayer = shapeLayer;
    }
    return _maskLayer;
}

#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    
}
-(void)initSubViews{
    [self addSubview:self.preImg];
    [self addSubview:self.boxImg];
    [self addSubview:self.dismissBtn];
    [self addSubview:self.takePhotoBtn];
    
    [self.layer addSublayer:self.maskLayer];
    
    self.boxImg.layer.zPosition = 10;
    self.dismissBtn.layer.zPosition = 10;
    self.takePhotoBtn.layer.zPosition = 10;
    self.preImg.layer.zPosition = 10;
    
    [self layout];
}
-(void)layout{
    
    //裁剪框
    [self.boxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kNavigationHeight() + 46);
        make.width.mas_equalTo(kCameraIDCardBoxWidth);
        make.height.mas_equalTo(kCameraIDCardBoxHeight);
    }];
    
    //预览
    [self.preImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.boxImg);
    }];
    
    //拍照
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(75);
        make.bottom.equalTo(self).offset(-35);
    }];
    
    //消失
    [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.trailing.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(40);
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
