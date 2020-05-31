//
//  DYPickerRow.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/9.
//

#import "ZMPickerRow.h"
#import "ZMPickerRowTableCell.h"
#import <Masonry/Masonry.h>

static NSString *const kZJBottomTableViewCellIdentifier = @"com.ZMUIKit.RowPickerView.bottomTableView.cellIdentifier";
static NSString *const kZJTopTableViewCellIdentifier = @"com.ZMUIKit.RowPickerView.topTableView.cellIdentifier";

static NSInteger kSABlankCellNumber;


static CGFloat kDYPickerRowRowHeight = 37.0;

@interface DYPickerRow ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) UITableView *topTableView;

@property (nonatomic, assign) NSInteger displayRowNumber;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;

@end

@implementation DYPickerRow

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.displayRowNumber = 5;
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self setupData];
    [self setupSubviewsContraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.frame.size.height < _rowHeight*_displayRowNumber) {
        NSLog(@"warning: please check <DYPickerRow> size");
    }
}

#pragma mark-
#pragma mark- <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _bottomTableView) {
        return _numberOfRows+2*kSABlankCellNumber;
    } else {
        return _numberOfRows;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _topTableView) {
        
        ZMPickerRowTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kZJTopTableViewCellIdentifier];
        cell.content = [_delegate zm_rowPickerView:self contentForRowAtIndex:indexPath.row];
        cell.zm_selected = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _bottomTableView){
        
        ZMPickerRowTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kZJBottomTableViewCellIdentifier];
        
        if (indexPath.row>kSABlankCellNumber-1 && indexPath.row < _numberOfRows+kSABlankCellNumber) {
            cell.content = [_delegate zm_rowPickerView:self contentForRowAtIndex:indexPath.row-kSABlankCellNumber];
        }else{
            cell.content = @"";
        }
        cell.zm_selected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight == 0 ? kDYPickerRowRowHeight : _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row - 1;
    [self setSelectRowAtIndex:_selectedIndex animation:YES];
}


#pragma mark-
#pragma mark- <UITableViewDataSource,UITableViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bottomTableView) {
        _topTableView.contentOffset = scrollView.contentOffset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _bottomTableView&&!decelerate) {
        _selectedIndex = [self getIndexForScrollViewPosition:scrollView];
        _selectedIndex = _selectedIndex < _numberOfRows ? _selectedIndex : (_numberOfRows-1);
        _topTableView.contentOffset = scrollView.contentOffset;
        [self setSelectRowAtIndex:_selectedIndex animation:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _bottomTableView) {
        _selectedIndex = [self getIndexForScrollViewPosition:scrollView];
        _selectedIndex = _selectedIndex<_numberOfRows?_selectedIndex:(_numberOfRows-1);
        _topTableView.contentOffset = scrollView.contentOffset;
        [self setSelectRowAtIndex:_selectedIndex animation:YES];
    }
}

- (NSInteger)getIndexForScrollViewPosition:(UIScrollView *)scrollView {
    
    CGFloat offsetContentScrollView = (scrollView.frame.size.height - _rowHeight) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat exactIndex = (offetY + offsetContentScrollView) / _rowHeight;
    NSInteger intIndex = floorf((offetY + offsetContentScrollView) / _rowHeight);
    NSInteger index;
    if (intIndex+0.5>exactIndex) {
        index = intIndex;
    }else{
        index = intIndex+1;
    }
    index = index - kSABlankCellNumber;
    return index;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bottomTableView) {
        
        UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc]init];
        [generator selectionChanged];
    }
}

#pragma mark-
#pragma mark- Event response


#pragma mark-
#pragma mark- Private Methods

- (void)setupData {
    self.selectedIndex = 0;
    
    if ([_dataSource respondsToSelector:@selector(zm_numberOfDisplayRowsInRowPickerView:)]) {
        NSInteger count = [_dataSource zm_numberOfDisplayRowsInRowPickerView:self];
        if (count <= 3) {
            _displayRowNumber = 3;
        }
    }
    kSABlankCellNumber = _displayRowNumber / 2;
    _numberOfRows = [_dataSource zm_numberOfRowsInRowPickerView:self];
    
    if ([_delegate respondsToSelector:@selector(zm_heightForRowInRowPickerView:)]) {
        _rowHeight = [_delegate zm_heightForRowInRowPickerView:self];
    }
}


#pragma mark-
#pragma mark- Public Methods

- (void)reloadData {
    [self setupData];
#warning 这里注意布局问题

    [_bottomTableView reloadData];
    [_topTableView reloadData];
    [self setSelectRowAtIndex:0 animation:NO];
    
}

- (void)setSelectRowAtIndex:(NSInteger)index animation:(BOOL)animation {
    if (0<=index&&index<_numberOfRows) {
        self.selectedIndex = index;
    } else {
        if (index<0) {
            self.selectedIndex = 0;
        } else if (index >= _numberOfRows) {
            self.selectedIndex = _numberOfRows - 1;
        }
    }
    
    if (animation) {
        [_topTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_bottomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if ([self.delegate respondsToSelector:@selector(zm_rowPickerView:didSelectRowAtIndex:)]) {
            [self.delegate zm_rowPickerView:self didSelectRowAtIndex:self.selectedIndex];
        }
    }else {
        _bottomTableView.contentOffset = CGPointMake(_bottomTableView.contentOffset.x, _selectedIndex*_rowHeight);
        _topTableView.contentOffset = _bottomTableView.contentOffset;
    }
}


- (void)reloadDataWithSelectRowAtIndex:(NSInteger)index {
    [self setupData];
    [_bottomTableView reloadData];
    [_topTableView reloadData];
    [self setSelectRowAtIndex:index animation:NO];
}

#pragma mark-
#pragma mark- Getters && Setters

- (UITableView *)topTableView {
    if (!_topTableView) {
        _topTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            [_topTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        } else {
            // Fallback on earlier versions
        }
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.userInteractionEnabled = NO;
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topTableView.showsVerticalScrollIndicator = NO;
        _topTableView.bounces = NO;
        _topTableView.estimatedRowHeight = 0;
        [_topTableView registerClass:[ZMPickerRowTableCell class] forCellReuseIdentifier:kZJTopTableViewCellIdentifier];
        _topTableView.backgroundColor = [UIColor whiteColor];
    }
    return _topTableView;
}

- (UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        if (@available(iOS 11.0, *)) {
            [_bottomTableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        } else {
            // Fallback on earlier versions
        }
        //        _bottomTableView.allowsSelection = NO;
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bottomTableView.showsVerticalScrollIndicator = NO;
        _bottomTableView.bounces = NO;
        _bottomTableView.estimatedRowHeight = 0;
        [_bottomTableView registerClass:[ZMPickerRowTableCell class] forCellReuseIdentifier:kZJBottomTableViewCellIdentifier];
        _bottomTableView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomTableView;
    
}

- (UIImpactFeedbackGenerator *)impactFeedbackGenerator {
    if (!_impactFeedbackGenerator) {
        _impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    }
    return _impactFeedbackGenerator;
}

#pragma mark-
#pragma mark- SetupConstraints

- (void)setupSubviewsContraints{
    
    [self addSubview:self.bottomTableView];
    [self addSubview:self.topTableView];
    
    [self.bottomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(self.displayRowNumber*self.rowHeight);
    }];
    [self.topTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bottomTableView);
        make.width.mas_equalTo(self.bottomTableView);
        make.height.mas_equalTo(self.rowHeight);
    }];
    
}



@end
