//
//  ZMCameraToolView.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/11/18.
//

#import "ZMCameraToolView.h"
#import "UIView+ZMExtension.h"
#import "UIImage+ZMExtension.h"
#import "UIColor+ZMExtension.h"



@interface ZMCameraToolView()
<
CAAnimationDelegate,
UIGestureRecognizerDelegate
>

{
    struct {
        unsigned int takePic : 1;
        unsigned int startRecord : 1;
        unsigned int finishRecord : 1;
        unsigned int retake : 1;
        unsigned int okClick : 1;
        unsigned int dismiss : 1;
    } _delegateFlag;
    
    //避免动画及长按手势触发两次
    BOOL _stopRecord;
    BOOL _layoutOK;
}

//@property (nonatomic, assign) BOOL allowCrop;
//@property (nonatomic, assign) BOOL allowTakePhoto;
//@property (nonatomic, assign) BOOL allowRecordVideo;
//@property (nonatomic, strong) UIColor *circleProgressColor;
//@property (nonatomic, assign) NSInteger maxRecordDuration;

@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) CAShapeLayer *animateLayer;
@property (nonatomic, assign) CGFloat duration;

@end

static CGFloat const kBottomViewScale = 0.7;
static CGFloat const kTopViewScale = 0.5;
static CGFloat const kAnimateDuration = 0.1;

@implementation ZMCameraToolView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (!self.allowCrop) {
        [self stopAnimate];
    }
    
    if (_delegateFlag.takePic) [self.delegate performSelector:@selector(onTakePictureAction)];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longG
{
#warning MARK ,Test
    return;
    switch (longG.state) {
        case UIGestureRecognizerStateBegan:
        {
            //此处不启动动画，由vc界面开始录制之后启动
            _stopRecord = NO;
            if (_delegateFlag.startRecord) [self.delegate performSelector:@selector(onStartRecordAction)];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (_stopRecord) return;
            _stopRecord = YES;
            [self stopAnimate];
            if (_delegateFlag.finishRecord) [self.delegate performSelector:@selector(onFinishRecordAction)];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    if (([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])) {
        return YES;
    }
    return NO;
}

- (void)dismissVC{
    if (_delegateFlag.dismiss) [self.delegate performSelector:@selector(onDismissAction)];
}

- (void)retake{
    [self resetUI];
    if (_delegateFlag.retake) [self.delegate performSelector:@selector(onRetakeAction)];
}

- (void)doneClick{
    if (_delegateFlag.okClick) [self.delegate performSelector:@selector(onOkClickAction)];
}

#pragma mark >_<! 👉🏻 🐷Private Methods🐷
- (void)startAnimate{
    self.dismissBtn.hidden = YES;
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.bottomView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1 / kBottomViewScale, 1 / kBottomViewScale, 1);
        self.topView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.7, 0.7, 1);
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.duration = self.maxRecordDuration;
        animation.delegate = self;
        [self.animateLayer addAnimation:animation forKey:nil];
        
        [self.bottomView.layer addSublayer:self.animateLayer];
    }];
}

- (void)stopAnimate{
    if (_animateLayer) {
        [self.animateLayer removeFromSuperlayer];
        [self.animateLayer removeAllAnimations];
    }
    
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    self.dismissBtn.hidden = YES;
    
    self.bottomView.layer.transform = CATransform3DIdentity;
    self.topView.layer.transform = CATransform3DIdentity;
    
    [self showCancelDoneBtn];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_stopRecord) return;
    
    _stopRecord = YES;
    [self stopAnimate];
    if (_delegateFlag.finishRecord) [self.delegate performSelector:@selector(onFinishRecordAction)];
}

#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
- (void)setDelegate:(id<ZMCameraToolViewDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlag.takePic = [delegate respondsToSelector:@selector(onTakePictureAction)];
    _delegateFlag.startRecord = [delegate respondsToSelector:@selector(onStartRecordAction)];
    _delegateFlag.finishRecord = [delegate respondsToSelector:@selector(onFinishRecordAction)];
    _delegateFlag.retake = [delegate respondsToSelector:@selector(onRetakeAction)];
    _delegateFlag.okClick = [delegate respondsToSelector:@selector(onOkClickAction)];
    _delegateFlag.dismiss = [delegate respondsToSelector:@selector(onDismissAction)];
}
- (void)setAllowTakePhoto:(BOOL)allowTakePhoto
{
    _allowTakePhoto = allowTakePhoto;
    if (allowTakePhoto) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.bottomView addGestureRecognizer:tap];
    }
}

- (void)setAllowRecordVideo:(BOOL)allowRecordVideo
{
    _allowRecordVideo = allowRecordVideo;
    if (allowRecordVideo) {
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longG.minimumPressDuration = 0.3;
        longG.delegate = self;
        [self.bottomView addGestureRecognizer:longG];
    }
}
- (CAShapeLayer *)animateLayer{
    if (!_animateLayer) {
        _animateLayer = [CAShapeLayer layer];
        CGFloat width = CGRectGetHeight(self.bottomView.frame)*kBottomViewScale;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, width) cornerRadius:width/2];
        
        _animateLayer.strokeColor = self.circleProgressColor.CGColor;
        _animateLayer.fillColor = [UIColor clearColor].CGColor;
        _animateLayer.path = path.CGPath;
        _animateLayer.lineWidth = 8;
    }
    return _animateLayer;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    
}
-(void)initSubViews{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.backgroundColor = [[UIColor colorWhite1] colorWithAlphaComponent:.9];
    [self addSubview:self.bottomView];
    
    self.topView = [[UIView alloc] init];
    self.topView.layer.masksToBounds = YES;
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.userInteractionEnabled = NO;
    [self addSubview:self.topView];
    
    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(60, self.bounds.size.height/2-25/2, 25, 25);
    
    [self.dismissBtn setImage:[UIImage zm_kitImageNamed:@"zl_arrow_down"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dismissBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.backgroundColor = [[UIColor colorWhite1] colorWithAlphaComponent:.9];
    [self.cancelBtn setImage:[UIImage zm_kitImageNamed:@"zl_retake"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.hidden = YES;
    [self addSubview:self.cancelBtn];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.frame = self.bottomView.frame;
    self.doneBtn.backgroundColor = [UIColor whiteColor];
    [self.doneBtn setImage:[UIImage zm_kitImageNamed:@"zl_takeok"] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.hidden = YES;
    [self addSubview:self.doneBtn];
}

- (void)showCancelDoneBtn
{
    self.cancelBtn.hidden = NO;
    self.doneBtn.hidden = NO;
    
    CGRect cancelRect = self.cancelBtn.frame;
    cancelRect.origin.x = 40;
    
    CGRect doneRect = self.doneBtn.frame;
    doneRect.origin.x = self.zm_w -doneRect.size.width-40;
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.cancelBtn.frame = cancelRect;
        self.doneBtn.frame = doneRect;
    }];
}

- (void)resetUI
{
    if (_animateLayer.superlayer) {
        [self.animateLayer removeAllAnimations];
        [self.animateLayer removeFromSuperlayer];
    }
    self.dismissBtn.hidden = NO;
    self.bottomView.hidden = NO;
    self.topView.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.doneBtn.hidden = YES;
    
    self.cancelBtn.frame = self.bottomView.frame;
    self.doneBtn.frame = self.bottomView.frame;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_layoutOK) return;
    
    _layoutOK = YES;
    CGFloat height = self.zm_h;
    self.bottomView.frame = CGRectMake(0, 0, height*kBottomViewScale, height*kBottomViewScale);
    self.bottomView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.bottomView.layer.cornerRadius = height*kBottomViewScale/2;

    self.topView.frame = CGRectMake(0, 0, height*kTopViewScale, height*kTopViewScale);
    self.topView.center = self.bottomView.center;
    self.topView.layer.cornerRadius = height*kTopViewScale/2;
    
    self.dismissBtn.frame = CGRectMake(60, self.bounds.size.height/2-25/2, 25, 25);

    self.cancelBtn.frame = self.bottomView.frame;
    self.cancelBtn.layer.cornerRadius = height*kBottomViewScale/2;
    
    self.doneBtn.frame = self.bottomView.frame;
    self.doneBtn.layer.cornerRadius = height*kBottomViewScale/2;
}

@end
