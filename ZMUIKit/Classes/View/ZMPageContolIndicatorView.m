//
//  ZMPageContolIndicatorView.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/8.
//

#import "ZMPageContolIndicatorView.h"
#import <Masonry/Masonry.h>

#define kPageControlSelectedColor [UIColor colorWithRed:0/255.0 green:162/255.0 blue:234/255.0 alpha:1]
#define kPageControlNormalColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]
#define kHSpace 3
#define kPageControlWidth 12
#define kPageControlHeight 2
@interface ZMPageContolIndicatorView()
@property(nonatomic,strong)NSMutableArray<UIButton *> * dotViews;
@property(nonatomic,strong)UIButton * selectedBtn;
@end
@implementation ZMPageContolIndicatorView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    return self;
    
}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷Collection Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
- (void)resetDotViews{
    for (UIView *dotView in self.dotViews) {
        [dotView removeFromSuperview];
    }
    
    [self.dotViews removeAllObjects];
    [self updateDots];
}
-(void)updateDots{
    if (self.numberOfPages == 0) {
        return;
    }
    
    for (NSInteger index = 0; index < self.numberOfPages; index++) {
        UIButton * button;
        if (index < self.dotViews.count) {
            button = [self.dotViews objectAtIndex:index];
        }else{
            button = [[UIButton alloc]init];
            button.backgroundColor =  self.pageControlNormalColor ? self.pageControlNormalColor: kPageControlNormalColor;
            if (self.showNormalBorderColor) {
                button.layer.borderWidth = 0.5;
                button.layer.borderColor = self.pageControlNormalBorderColor.CGColor;
            }
            button.layer.cornerRadius = self.cornerRadius;
            [self addSubview:button];
            [self.dotViews addObject:button];
        }
    }
    
    self.selectedBtn = self.dotViews.firstObject;
    self.currentPage = 0;
    
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    
    _numberOfPages = numberOfPages;
    [self resetDotViews];
}
-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    if (_currentPage < self.dotViews.count) {
        self.selectedBtn.backgroundColor = self.pageControlNormalColor ? self.pageControlNormalColor: kPageControlNormalColor;
        
        UIButton * button = self.dotViews[_currentPage];
        button.backgroundColor = self.pageControlSelectedColor ? self.pageControlSelectedColor: kPageControlSelectedColor;
        self.selectedBtn = button;
    }
}
-(NSMutableArray *)dotViews{
    if (!_dotViews) {
        _dotViews = [NSMutableArray array];
    }
    return _dotViews;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    
}
-(void)initSubViews{
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.dotViews.count > 1) {
        [self.dotViews mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(self.pageControlHeight>0 ? self.pageControlHeight :kPageControlHeight);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(self.pageControlWidth>0? self.pageControlWidth:kPageControlWidth);
        }];
        
        [self.dotViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kHSpace leadSpacing:0 tailSpacing:0];
    }
    
}

@end
