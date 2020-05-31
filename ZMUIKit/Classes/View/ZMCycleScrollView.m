//
//  DYCycleScrollCell.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/5.
//

#import "ZMCycleScrollView.h"
#import <Masonry/Masonry.h>
#import "ZMUIKit.h"
@interface ZMCycleScrollView()
<
SDCycleScrollViewDelegate
>


@property(nonatomic,assign)NSInteger numberOfPages;
@end
@implementation ZMCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;
}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷SDCycleScrollView Delegate 🐷
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:index];
    }
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:index];
    }
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView currentPage:(NSInteger)currentPage{
    self.pageControl.currentPage = currentPage;
}
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setImages:(NSArray *)images{
    _images = images;
    
    if ([[_images firstObject] isKindOfClass:[UIImage class]]) {
        self.cycleScrollView.localizationImageNamesGroup = _images;
    }else{
        self.cycleScrollView.imageURLStringsGroup = _images;
    }
    
    self.numberOfPages = _images.count;
    self.pageControl.numberOfPages = self.numberOfPages;
    
}
-(void)setPageControlStyle:(ZMCycleScrollViewPageContolStyle)pageControlStyle{
    _pageControlStyle = pageControlStyle;
    
    switch (_pageControlStyle) {
        case ZMCycleScrollViewPageContolStyleIndicator:{
            [self.cycleScrollView addSubview:self.pageControl];
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
            self.pageControl.numberOfPages = self.numberOfPages;
            
            [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-15);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(10);
            }];
        }
            
            break;
            
        case ZMCycleScrollViewPageContolStyleClassic:
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            break;
            
        case ZMCycleScrollViewPageContolStyleAnimated:
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            break;
            
        case ZMCycleScrollViewPageContolStyleNone:
        default:
            _pageControl.hidden = YES;
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
            break;
    }
    
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.delegate = self;
        _cycleScrollView.backgroundColor =[UIColor whiteColor];
    }
    return _cycleScrollView;
}
-(ZMPageContolIndicatorView *)pageControl{
    if (!_pageControl) {
        _pageControl = [[ZMPageContolIndicatorView alloc]init];
    }
    return _pageControl;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    self.backgroundColor = [UIColor whiteColor];
}
-(void)initSubViews{
    
    [self addSubview:self.cycleScrollView];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.isCustomCycleScrollViewHei) {
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.top.equalTo(self);
        }];
    }
    
}

@end
