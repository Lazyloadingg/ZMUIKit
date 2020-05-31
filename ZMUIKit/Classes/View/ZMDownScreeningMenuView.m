//
//  ZMDownScreeningMenuView.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/26.
//

#import "ZMDownScreeningMenuView.h"
#import <Masonry/Masonry.h>

static NSString *const kCellIdentifier = @"com.cell.identifier";

@interface ZMDownScreeningMenuView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger lines;

@property (nonatomic, assign) NSInteger columns;

@end

@implementation ZMDownScreeningMenuView

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor plainTableViewBackgroundColor];
        [self setupSubviewsContraints];
    }
    return self;
}

#pragma mark -
#pragma mark - 👉 UICollectionViewDelegate 👈

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.dataSource respondsToSelector:@selector(menuView:layout:sizeForItemAtIndexPath:)]) {
        return [self.dataSource menuView:self layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat viewWidth = collectionView.bounds.size.width;
    CGFloat viewHight = collectionView.bounds.size.height;
    
    CGFloat itemW = (viewWidth - self.contentInset.left - self.contentInset.right - (self.columns - 1) * layout.minimumInteritemSpacing)/self.columns;
    CGFloat itemH = (viewHight - self.contentInset.top - self.contentInset.bottom - (self.lines - 1) * layout.minimumLineSpacing)/self.lines;
    
    return CGSizeMake(itemW >=0 ? itemW : 0, itemH >= 0 ? itemH : 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(countOfItemInMenuView:)]) {
        return [self.dataSource countOfItemInMenuView:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    
    
    if ([self.dataSource respondsToSelector:@selector(menuView:deploymentCell:index:)]) {
        [self.dataSource menuView:self deploymentCell:cell index:indexPath.item];
    }
    
    if ([self.dataSource respondsToSelector:@selector(indexForDefaultSelectAtMenuView:)]) {
        NSInteger idx = [self.dataSource indexForDefaultSelectAtMenuView:self];
        if (indexPath.item == idx) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(menuView:didSelectIndex:)]) {
        [self.dataSource menuView:self didSelectIndex:indexPath.item];
    }
}

#pragma mark -
#pragma mark - 👉 Event response 👈

#pragma mark -
#pragma mark - 👉 Private Methods 👈

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (void)setDataSource:(id<ZMDownScreeningMenuViewDataSource>)dataSource {
    if (!(_dataSource == dataSource)) {
        _dataSource = dataSource;
        if (_dataSource && [self.dataSource respondsToSelector:@selector(classForItemMenuView:)] && [self.dataSource classForItemMenuView:self]) {
            Class cls = [self.dataSource classForItemMenuView:self];
            [self.collectionView registerClass:cls forCellWithReuseIdentifier:kCellIdentifier];
        }else {
            [self.collectionView registerClass:DYDownScreeningMenuCell.class forCellWithReuseIdentifier:kCellIdentifier];
        }
        if (_dataSource && [self.dataSource respondsToSelector:@selector(menuView:deploymentTitle:)]) {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.mas_equalTo(15);
                make.trailing.mas_equalTo(-15);
            }];
            
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
                make.leading.bottom.trailing.mas_equalTo(0);
            }];
            
            [self.dataSource menuView:self deploymentTitle:self.titleLabel];
        }
        [self.collectionView reloadData];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorC5];
        _titleLabel.font = [UIFont zm_font16pt:DYFontBoldTypeRegular];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 15.f;
        layout.minimumInteritemSpacing = 10.f;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.delaysContentTouches = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (NSInteger)lines {
    if (!_lines) {
        _lines = [self.dataSource lineForCountAtMenuView:self];
    }
    return _lines;
}

- (NSInteger)columns {
    if (!_columns) {
        _columns = [self.dataSource columnForCountAtMenuView:self];
    }
    return _columns;
}

#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end



@interface DYDownScreeningMenuCell ()

@property (nonatomic, strong) UIView *selectBackgroundView;

@end

@implementation DYDownScreeningMenuCell

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
//        self.selectedBackgroundView = self.selectBackgroundView;
        [self setupSubviewsContraints];
    }
    return self;
}

#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor colorC1];
    }else {
        self.backgroundColor = [UIColor colorC3];
    }
}

- (UIView *)selectBackgroundView {
    if (!_selectBackgroundView) {
        _selectBackgroundView = [UIView new];
        _selectBackgroundView.backgroundColor = [UIColor colorC1];
    }
    return _selectBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorC5];
        _titleLabel.highlightedTextColor = [UIColor colorC3];
        _titleLabel.font = [UIFont zm_font16pt:DYFontBoldTypeRegular];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
