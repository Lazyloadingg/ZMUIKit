//
//  DYCyclePagerView.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/27.
//

#import "ZMCyclePageView.h"
#import "UIImageView+ZMExtension.h"
#import "UIColor+ZMExtension.h"
#import <Masonry/Masonry.h>
#import "ZMCyclePageCell.h"
#import <TYCyclePagerView/TYCyclePagerView.h>

static NSString *const kTYCyclePagerViewIdentifier = @"com.ZMUIKit.TYCyclePagerView.cell.identifier";

@interface ZMCyclePageView ()
<
TYCyclePagerViewDelegate,
TYCyclePagerViewDataSource
>

@property (nonatomic, strong) TYCyclePagerView *cyclePageView;

@property (nonatomic, strong) TYCyclePagerViewLayout *layout;

@end

@implementation ZMCyclePageView

@synthesize minimumAlpha = _minimumAlpha, itemSpacing = _itemSpacing, itemSize = _itemSize, autoScrollInterval = _autoScrollInterval, scrollStyle = _scrollStyle;

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
#pragma mark - 👉 TYCyclePagerViewDelegate && data source 👈

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    NSInteger count = [self.dataSource numberOfItemsInPageView:self];
    return count;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    return [self.dataSource pageView:self cellForItemAtIndex:index];
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    self.layout.itemSize = !CGSizeEqualToSize(self.itemSize, CGSizeZero) ? self.itemSize : CGSizeMake(CGRectGetWidth(pageView.frame)-30, CGRectGetHeight(pageView.frame)*0.8);
    return self.layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectedItemCell:index:)]) {
        [self.delegate pageView:self didSelectedItemCell:cell index:index];
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if ([self.delegate respondsToSelector:@selector(pageView:didScrollFromIndex:toIndex:)]) {
        [self.delegate pageView:self didScrollFromIndex:fromIndex toIndex:toIndex];
    }
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark -
#pragma mark - 👉 UIScrollViewDelegate 👈

#pragma mark -
#pragma mark - 👉 Event response 👈

#pragma mark -
#pragma mark - 👉 Public Methods 👈

- (void)reloadData {
    [self.cyclePageView reloadData];
}

- (void)updateData {
    [self.cyclePageView updateData];
}

- (void)setNeedUpdateLayout {
    [self.cyclePageView setNeedUpdateLayout];
}

- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier {
    [self.cyclePageView registerClass:Class forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.cyclePageView dequeueReusableCellWithReuseIdentifier:identifier forIndex:index];
}

#pragma mark -
#pragma mark - 👉 Private Methods 👈

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (void)setScrollStyle:(ZMCyclePageViewScrollStyle)scrollStyle {
    if (_scrollStyle != scrollStyle) {
        _scrollStyle = scrollStyle;
        self.layout.layoutType = (NSInteger)scrollStyle;
    }
}

- (ZMCyclePageViewScrollStyle)scrollStyle {
    if (!_scrollStyle) {
        _scrollStyle = ZMCyclePageViewScrollStyleNormal;
    }
    return _scrollStyle;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    self.layout.itemSize = itemSize;
}

- (CGSize)itemSize {
    if (CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        _itemSize = CGSizeMake(CGRectGetWidth(self.cyclePageView.frame)-30, CGRectGetHeight(self.cyclePageView.frame)*0.8);
    }
    return _itemSize;
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        self.layout.itemSpacing = itemSpacing;
    }
}

- (CGFloat)itemSpacing {
    if (!_itemSpacing) {
        _itemSpacing = 30.f;
    }
    return _itemSpacing;
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval {
    if (_autoScrollInterval != autoScrollInterval) {
        _autoScrollInterval = autoScrollInterval;
        self.cyclePageView.autoScrollInterval = autoScrollInterval;
    }
}

- (NSTimeInterval)autoScrollInterval {
    if (!_autoScrollInterval) {
        _autoScrollInterval = 3;
    }
    return _autoScrollInterval;
}

- (void)setMinimumAlpha:(CGFloat)minimumAlpha {
    if (_minimumAlpha != minimumAlpha) {
        _minimumAlpha = minimumAlpha;
        self.layout.minimumAlpha = minimumAlpha;
    }
}
- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.cyclePageView.collectionView.scrollEnabled = scrollEnable;
}

- (void)setIsInfiniteLoop:(BOOL)isInfiniteLoop {
    _isInfiniteLoop = isInfiniteLoop;
    self.layout.isInfiniteLoop = isInfiniteLoop;
    self.cyclePageView.isInfiniteLoop = isInfiniteLoop;
}

- (CGFloat)minimumAlpha {
    if (!_minimumAlpha) {
        _minimumAlpha = 1;
    }
    return _minimumAlpha;
}

- (TYCyclePagerViewLayout *)layout {
    if (!_layout) {
        _layout = [[TYCyclePagerViewLayout alloc]init];
        _layout.itemSpacing = self.itemSpacing;
        _layout.minimumAlpha = self.minimumAlpha;
        _layout.itemHorizontalCenter = YES;
        _layout.layoutType = (NSInteger)self.scrollStyle;
    }
    return _layout;
}

- (TYCyclePagerView *)cyclePageView {
    if (!_cyclePageView) {
        _cyclePageView = [[TYCyclePagerView alloc]init];
        _cyclePageView.isInfiniteLoop = YES;
        _cyclePageView.autoScrollInterval = self.autoScrollInterval;
        _cyclePageView.delegate = self;
        _cyclePageView.dataSource = self;
        [_cyclePageView registerClass:ZMCyclePageCell.class forCellWithReuseIdentifier:kTYCyclePagerViewIdentifier];
    }
    return _cyclePageView;
}

- (ZMPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ZMPageControl alloc]init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(13, 3);
        _pageControl.pageIndicatorSize = CGSizeMake(8, 3);
        _pageControl.currentPageIndicatorTintColor = [UIColor colorC3];
        _pageControl.pageIndicatorTintColor = [[UIColor colorC3] colorWithAlphaComponent:.6];
        _pageControl.pageIndicatorSpaing = 3;
    }
    return _pageControl;
}

#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self addSubview:self.cyclePageView];
    [self addSubview:self.pageControl];
    
    [self.cyclePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(300, 10));
    }];
}

@end
