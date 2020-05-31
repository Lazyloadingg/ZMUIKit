//
//  ZMPopoverView.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/23.
//

#import "ZMPopoverView.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

/*! 边距 */
static CGFloat const kPopoverViewMargin = 8.f;

/*! 箭头高度 */
static CGFloat const kPopoverArrawHeight = 6.f;

/** 左侧图与标题间距 */
static CGFloat const kPopoverListIconSpace = 10.f;

/*! cell指定高度 */
static CGFloat const kPopoverViewCellHeight = 50.0;

/*! 水平边距 */
static CGFloat const kPopoverViewHorizontalMargin = 15.0;

/** 左侧图片最大size */
static CGFloat const kPopoverListIconMaxSize = 20.0;

static CGFloat const kPopoverViewListMaxWidth = 140.0;
static CGFloat const kPopoverViewLisWithChecktMaxWidth = 145.0;

/*! cell上图片的宽度 */
static CGFloat const kPopoverViewCellImageWidth = 18.0f;

/*! cell上图片和label的间距 */
static CGFloat const kPopoverViewCellSpace = 15.0f;

/*! 水平边距 */
static CGFloat const kPopoverViewSureBtnHeight = 34.0;

static NSString  *const kCellIdentifier = @"com.ZMUIKit.popover.cell.identifier";
static NSInteger const kTitleLabelTag = 1523;

// convert degrees to radians
float kDegreesToRadians(float angle) {
    return angle*M_PI/180;
}

@interface ZMPopoverView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *showOnView;
@property (nonatomic, strong) UIView *shadeView; // 遮罩层
@property (nonatomic, weak) CAShapeLayer *borderLayer;
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;

@property (nonatomic, copy) NSMutableArray<DYPopoverAction *> *actions;

@property (nonatomic, assign) BOOL isUpward; //< 箭头指向, YES为向上, 反之为向下, 默认为YES.
@property (nonatomic, assign) BOOL isLeft; //< 箭头指向, YES为向左, 反之为向右, 默认为YES.

@property (nonatomic, assign) CGSize customViewSize;

@property (nonatomic, assign) UIView *customView;

@end

@interface DYPopoverCell : DYTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *iconBadgeView;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, assign) BOOL isChoose;

/**
 重设ListIcon类型布局
 */
- (void)layoutListIconCell;
@end

@implementation ZMPopoverView {
    DYPopoverDirection _showDirection;
    BOOL _isAnimating;
    UIView *_snapView;
    BOOL _showAnimated;
}

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGSize labelSize = [self getTitleLabelSize];
    CGFloat x = kPopoverViewHorizontalMargin + (self.isLeft ? kPopoverArrawHeight : 0);
    CGFloat y = kPopoverViewHorizontalMargin + (self.isUpward ? kPopoverArrawHeight : 0);
    
    switch (self.type) {
        case ZMPopoverViewContentTypeListWithCheck:
        case ZMPopoverViewContentTypeListIcon:
        case ZMPopoverViewContentTypeList: {
            
            CGFloat tableViewWidth = width;
            CGFloat tableViewHeight = height - 5.0 * 2;
            if (_showDirection == DYPopoverDirectionLeft || _showDirection == DYPopoverDirectionRight) {
                tableViewWidth = width - kPopoverArrawHeight;
            }
            if (_showDirection == DYPopoverDirectionUp || _showDirection == DYPopoverDirectionDown) {
                tableViewHeight = height - 5.0*2 - kPopoverArrawHeight;
            }
            self.tableView.frame = CGRectMake((self.isLeft ? kPopoverArrawHeight : 0), 5.0 + (self.isUpward ? kPopoverArrawHeight : 0), width, tableViewHeight);
        }
            break;
        case ZMPopoverViewContentTypeAlert: {
            
            CGFloat alertX = _isLeft ? kPopoverArrawHeight : 0;
            CGFloat sureBtnWidth = width;
            if (_showDirection == DYPopoverDirectionLeft || _showDirection == DYPopoverDirectionRight) {
                
                sureBtnWidth = width - kPopoverArrawHeight;
            }
            CGFloat labelX = (sureBtnWidth-labelSize.width)/2.0 + (_isLeft ? kPopoverArrawHeight : 0);
            self.titleLabel.frame = CGRectMake(labelX, y, labelSize.width, labelSize.height);
            self.lineView.frame = CGRectMake(alertX, CGRectGetMaxY(self.titleLabel.frame) + kPopoverViewHorizontalMargin, width, 0.5);
            self.sureButton.frame = CGRectMake(alertX,CGRectGetMaxY(self.titleLabel.frame) + kPopoverViewHorizontalMargin, sureBtnWidth, kPopoverViewSureBtnHeight);
        }
            break;
        case ZMPopoverViewContentTypeCustom: {
            CGFloat maxCustomViewHeight = self.customViewSize.height;
            //            if (_showDirection == DYPopoverDirectionDown || _showDirection == DYPopoverDirectionUp) {
            //                maxCustomViewHeight = maxCustomViewHeight - kPopoverArrawHeight;
            //            }
            //            CGFloat height = self.customViewSize.height > maxCustomViewHeight ? maxCustomViewHeight : self.customViewSize.height;
            CGFloat height = maxCustomViewHeight;
            CGFloat width = self.customViewSize.width;
            
            self.customView.frame = CGRectMake(x, y, width, height);
        }
            break;
        default: {
            
            self.titleLabel.frame = CGRectMake(x, y, labelSize.width, labelSize.height);
        }
            break;
    }
}

#pragma mark-
#pragma mark- 👉 UITableViewDataSource and UITableViewDelegate 👈
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYPopoverCell *cell = (DYPopoverCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[DYPopoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
    }
    
    DYPopoverAction *action = self.actions[indexPath.row];
    
    cell.iconBadgeView.hidden = !action.showIconBadge;
    if (cell.iconBadgeView.hidden) {
        cell.zm_separatorStyle = DYTableViewCellSeparatorStyleSingleLine;
    }
    if (indexPath.row == self.actions.count-1) {
        cell.zm_separatorStyle = DYTableViewCellSeparatorStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, kScreen_width, 0, 0);
    }else{
        
        if (self.type == ZMPopoverViewContentTypeListIcon) {
            cell.zm_separatorStyle = DYTableViewCellSeparatorStyleSingleIconLine43PX;
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    cell.titleLabel.text = [action title];
    if (action.disable) {
        cell.titleLabel.textColor = [UIColor colorC6];
    }else {
        cell.titleLabel.textColor = [UIColor colorC5];
    }
    
    if (_selectedIndex == indexPath.row && self.type == ZMPopoverViewContentTypeListWithCheck) {
        cell.isChoose = YES;
    }else{
        cell.isChoose = NO;
    }
    
    if (self.type == ZMPopoverViewContentTypeListIcon) {
        cell.iconImageView.image = action.icon;
        cell.iconImageView.currentBadgeCount = action.badgeNumber;
        [cell layoutListIconCell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopoverViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DYPopoverAction *action = self.actions[indexPath.row];
    if (action.disable) {
        return;
    }
    if (self.type == ZMPopoverViewContentTypeListWithCheck) {
        DYPopoverCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        lastCell.isChoose = NO;
        DYPopoverCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isChoose = YES;
        _selectedIndex = indexPath.row;
    }
    
    
    if (action.popoverActionBlock) {
        action.popoverActionBlock(action);
    }
    [self hide:_showAnimated];
}

#pragma mark-
#pragma mark- 👉 action response 👈
- (void)tapResponse:(UITapGestureRecognizer *)tap {
    if (self.shadeTapBlock) {
        self.shadeTapBlock(self);
    }else{
        [self hide];
    }
}

#pragma mark-
#pragma mark- 👉 private method 👈
- (void)setupInit {
    _maxHeight = kPopoverViewLisWithChecktMaxWidth;
    _maxWidth = kPopoverViewListMaxWidth;
    _showAnimated = YES;
    _selectedIndex = 0;
    _shouldMaskToView = YES;
    _arrowPositionRatio = 0.5;
    _listScrollEnable = NO;
    _isShowing = NO;
    _isAnimating = NO;
    _hideWhenTouchOutside = YES;
    _shadeViewEnable = YES;
    _shouldShowArrow = YES;
    _shadeBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    _actions = [NSMutableArray array];
    self.type = ZMPopoverViewContentTypeNormal;
    self.backgroundColor = [UIColor whiteColor];
}

/**
 箭头指向垂直方向
 */
- (void)showToPoint:(CGPoint)point isUpward:(BOOL)isUpward {
    
    CGFloat arrowWidth = 13.0;
    CGFloat cornerRadius = 3.0;
    CGFloat arrowCornerRadius = 0;
    CGFloat arrowBottonCornerRadius = 0;
    
    self.isUpward = isUpward;
    
    CGFloat viewWidth = CGRectGetWidth(self.showOnView.frame);
    CGFloat viewHeight = CGRectGetHeight(self.showOnView.frame);
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (point.x < minHorizontalEdge) {
        point.x = minHorizontalEdge;
    }
    if (viewWidth - point.x < minHorizontalEdge) {
        point.x = viewWidth - minHorizontalEdge;
    }
    
    
    [self.showOnView addSubview:self.shadeView];
    self.shadeView.frame = self.showOnView.bounds;
    _shadeView.alpha = 0;
    
    if (self.type == ZMPopoverViewContentTypeList || self.type == ZMPopoverViewContentTypeListWithCheck) {
        //  刷新数据以获取具体的ContentSize
        [self.tableView reloadData];
    }
    
    CGFloat currentW = [self getCurrentWidth];
    CGFloat currentH = [self getcurrentHeight];
    CGFloat maxWidth = viewWidth - kPopoverViewMargin * 2;
    currentW = currentW >= maxWidth ? maxWidth : currentW;
    if (_maxWidth != NSNotFound) {
        if (currentW > _maxWidth) {
            currentW = _maxWidth;
            _tableView.scrollEnabled = YES;
        }else{
            _tableView.scrollEnabled = NO;
        }
    }
    if (_maxHeight != NSNotFound) {
        if (currentH > _maxHeight) {
            currentH = _maxHeight;
            _tableView.scrollEnabled = YES;
        }else{
            _tableView.scrollEnabled = NO;
        }
    }
    if (self.type == ZMPopoverViewContentTypeList || self.type == ZMPopoverViewContentTypeListWithCheck) {
        // 限制最高高度, 免得选项太多时超出屏幕
        CGFloat maxHeight = isUpward ? (viewHeight - point.y - kPopoverViewMargin) : (point.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
            currentH = maxHeight;
            //            _tableView.scrollEnabled = YES;
            if (!isUpward) { // 箭头指向下则移动到最后一行
                //                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
    
    CGFloat currentX = point.x - currentW/2.0, currentY = point.y;
    //  x: 窗口靠左
    if (point.x <= currentW/2.0 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (viewWidth - point.x <= currentW/2 + kPopoverViewMargin) {
        currentX = viewWidth - kPopoverViewMargin - currentW;
    }
    
    if (!isUpward) {
        currentY = point.y - currentH;
    }
    CGFloat minArrowPositionRatio = (arrowWidth/2.0 + cornerRadius) / currentW;
    CGFloat maxArrowPositionRatio = 1-minArrowPositionRatio;
    CGFloat arrowPositionRatio = _arrowPositionRatio <= minArrowPositionRatio ? minArrowPositionRatio : (_arrowPositionRatio >= maxArrowPositionRatio ? maxArrowPositionRatio : _arrowPositionRatio);
    CGFloat autoOffsetRatio = (point.x - currentX - currentW/2.0)/currentW;
    CGFloat additionalW = currentW * (arrowPositionRatio - 0.5 - autoOffsetRatio);
    currentX = currentX - additionalW;
    
    
    
    if (currentX >= viewWidth-kPopoverViewMargin-currentW) {
        currentX = viewWidth-kPopoverViewMargin-currentW;
    }
    if (currentX <= kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头顶点在当前视图的坐标
    CGPoint arrowPoint = CGPointMake(point.x - CGRectGetMinX(self.frame), isUpward ? 0 : currentH);
    CGFloat maskTop = isUpward ? kPopoverArrawHeight : 0; // 顶部Y值
    CGFloat maskBottom = isUpward ? currentH : currentH - kPopoverArrawHeight; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(180)
                      endAngle:kDegreesToRadians(270)
                     clockwise:YES];
    // 箭头向上时的箭头位置
    if (isUpward && _shouldShowArrow) {
//        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverArrawHeight)];
//        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
//                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottonCornerRadius, kPopoverArrawHeight)];
//        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
//                         controlPoint:arrowPoint];
//        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverArrawHeight)
//                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottonCornerRadius, kPopoverArrawHeight)];
        
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x-arrowWidth/2.f , kPopoverArrawHeight)];
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x-2, arrowPoint.y+2)];
//        [maskPath addLineToPoint:CGPointMake(arrowPoint.x+3, arrowPoint.y+2)];
        
        CGPoint top = CGPointMake(arrowPoint.x, 0);
        CGPoint end = CGPointMake(arrowPoint.x+2, arrowPoint.y+2);
        [maskPath addQuadCurveToPoint:end controlPoint:top];
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x+arrowWidth/2.f , kPopoverArrawHeight)];
    }
    
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(270)
                      endAngle:kDegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(0)
                      endAngle:kDegreesToRadians(90)
                     clockwise:YES];
    // 箭头向下时的箭头位置
    if (!isUpward && _shouldShowArrow) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, currentH - kPopoverArrawHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottonCornerRadius, currentH - kPopoverArrawHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverArrawHeight)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottonCornerRadius, currentH - kPopoverArrawHeight)];
    }
    
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(90)
                      endAngle:kDegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    //    if (!_showShade) {
    //        CAShapeLayer *borderLayer = [CAShapeLayer layer];
    //        borderLayer.frame = self.bounds;
    //        borderLayer.path = maskPath.CGPath;
    //        borderLayer.lineWidth = 1;
    //        borderLayer.fillColor = [UIColor clearColor].CGColor;
    //        borderLayer.strokeColor = _tableView.separatorColor.CGColor;
    //        [self.layer addSublayer:borderLayer];
    //        _borderLayer = borderLayer;
    //    }
    
    [self.showOnView addSubview:self];
    if (!_shouldMaskToView) [self.showOnView addSubview:_snapView];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    
    [self showAnimation];
}


/**
 箭头指向水平方向
 */
- (void)showToPoint:(CGPoint)point isLeft:(BOOL)isLeft {
    
    CGFloat arrowWidth = 10.0;
    CGFloat cornerRadius = 3.0;
    
    self.isLeft = isLeft;
    
    CGFloat viewHeight = CGRectGetHeight(self.showOnView.frame);
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + kPopoverArrawHeight/2 + 2;
    if (point.y < minHorizontalEdge) {
        point.y = minHorizontalEdge;
    }
    if (viewHeight - point.y < minHorizontalEdge) {
        point.y = viewHeight - minHorizontalEdge;
    }
    
    [self.showOnView addSubview:self.shadeView];
    self.shadeView.frame = self.showOnView.bounds;
    _shadeView.alpha = 0;
    
    //  刷新数据以获取具体的ContentSize
    [self.tableView reloadData];
    
    CGFloat currentW = [self getCurrentWidth];
    CGFloat currentH = [self getcurrentHeight];
    
    if (self.type == ZMPopoverViewContentTypeList || self.type == ZMPopoverViewContentTypeList || self.type == ZMPopoverViewContentTypeListWithCheck) {
        // 限制最高高度, 免得选项太多时超出屏幕
        CGFloat maxHeight = viewHeight - 2*kPopoverViewMargin;
        if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
            currentH = maxHeight;
            //            _tableView.scrollEnabled = YES;
        }
    }
    
    CGFloat currentY = point.y - currentH/2.0, currentX = point.x;
    //  y: 窗口靠上
    if (point.y <= currentH/2.0 + kPopoverViewMargin) {
        currentY = kPopoverViewMargin;
    }
    // y: 窗口靠下
    if (viewHeight - point.y <= currentH/2 + kPopoverViewMargin) {
        currentY = viewHeight - kPopoverViewMargin - currentH;
    }
    
    if (!isLeft) {
        currentX = point.x - currentW;
    }
    
    CGFloat minArrowPositionRatio = (arrowWidth/2.0 + cornerRadius) / currentH;
    CGFloat maxArrowPositionRatio = 1-minArrowPositionRatio;
    CGFloat arrowPositionRatio = _arrowPositionRatio <= minArrowPositionRatio ? minArrowPositionRatio : (_arrowPositionRatio >= maxArrowPositionRatio ? maxArrowPositionRatio : _arrowPositionRatio);
    CGFloat autoOffsetRatio = (point.y - currentY - currentH/2.0)/currentH;
    CGFloat additionalH = currentH * (arrowPositionRatio - 0.5 - autoOffsetRatio);
    currentY = currentY - additionalH;
    
    if (currentY <= kPopoverViewMargin) {
        currentY = kPopoverViewMargin;
    }
    if (currentY >= viewHeight-kPopoverViewMargin-currentH) {
        currentY = viewHeight-kPopoverViewMargin-currentH;
    }
    currentW += kPopoverArrawHeight;
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(isLeft ? 0 : currentW, point.y - CGRectGetMinY(self.frame)); // 箭头顶点在当前视图的坐标
    CGFloat maskLeft = isLeft ? kPopoverArrawHeight : 0; // 顶部Y值
    CGFloat maskRight = isLeft ? currentW : currentW - kPopoverArrawHeight; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(maskLeft, cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(maskLeft+cornerRadius, cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(180)
                      endAngle:kDegreesToRadians(270)
                     clockwise:YES];
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(maskRight - cornerRadius, 0)];
    [maskPath addArcWithCenter:CGPointMake(maskRight - cornerRadius, cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(270)
                      endAngle:kDegreesToRadians(0)
                     clockwise:YES];
    
    // 箭头向右时的箭头位置
    if (!isLeft && _shouldShowArrow) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - kPopoverArrawHeight, arrowPoint.y-arrowWidth/2.0)];
        [maskPath addLineToPoint:arrowPoint];
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - kPopoverArrawHeight, arrowPoint.y+arrowWidth/2.0)];
    }
    //
    
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(maskRight, maskRight - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(maskRight - cornerRadius, currentH - cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(0)
                      endAngle:kDegreesToRadians(90)
                     clockwise:YES];
    
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(maskLeft+cornerRadius, currentH)];
    [maskPath addArcWithCenter:CGPointMake(maskLeft+cornerRadius, currentH - cornerRadius)
                        radius:cornerRadius
                    startAngle:kDegreesToRadians(90)
                      endAngle:kDegreesToRadians(180)
                     clockwise:YES];
    // 箭头向左时的箭头位置
    if (isLeft && _shouldShowArrow) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + kPopoverArrawHeight, arrowPoint.y+arrowWidth/2.0)];
        [maskPath addLineToPoint:arrowPoint];
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + kPopoverArrawHeight, arrowPoint.y-arrowWidth/2.0)];
    }
    [maskPath closePath];
    
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    //    if (!_showShade) {
    //    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    //    borderLayer.frame = self.bounds;
    //    borderLayer.path = maskPath.CGPath;
    //    borderLayer.lineWidth = 1;
    //    borderLayer.fillColor = [UIColor clearColor].CGColor;
    //    borderLayer.strokeColor = _tableView.separatorColor.CGColor;
    //    [self.layer addSublayer:borderLayer];
    //    _borderLayer = borderLayer;
    //    }
    
    [self.showOnView addSubview:self];
    if (!_shouldMaskToView) [self.showOnView addSubview:_snapView];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(isLeft ? 0.f : 1.f, arrowPoint.y/currentH);
    self.frame = oldFrame;
    
    [self showAnimation];
}

- (void)showAnimation {
    
    if (_showAnimated) {
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        _isAnimating = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.transform = CGAffineTransformIdentity;
            self -> _shadeView.alpha = 1.f;
        }completion:^(BOOL finished) {
            self -> _isShowing = YES;
            self -> _isAnimating = NO;
        }];
    }else{
        self.alpha = 1;
        _isAnimating = YES;
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
        _isShowing = YES;
        _isAnimating = NO;
    }
    
}

- (void)hide {
    [self hide:_showAnimated];
}

- (CGFloat)getcurrentHeight {
    CGFloat tempHeight = 0;
    switch (self.type) {
        case ZMPopoverViewContentTypeAlert: {
            tempHeight = [self getTitleLabelSize].height + kPopoverViewHorizontalMargin*2 + kPopoverViewSureBtnHeight;
        }
            break;
        case ZMPopoverViewContentTypeList: {
//            tempHeight = _tableView.contentSize.height + 5.0*2;
            tempHeight = self.actions.count * kPopoverViewCellHeight + 10;
        }
            break;
        case ZMPopoverViewContentTypeListIcon: {
            //            tempHeight = _tableView.contentSize.height + 5.0*2;
            tempHeight = self.actions.count * kPopoverViewCellHeight + 10;
        }
            break;
        case ZMPopoverViewContentTypeListWithCheck: {
            tempHeight = _tableView.contentSize.height + 5.0*2;
        }
            break;
        case ZMPopoverViewContentTypeCustom: {
            tempHeight = self.customViewSize.height + kPopoverViewHorizontalMargin*2;
        }
            break;
        default: {
            tempHeight = [self getTitleLabelSize].height + kPopoverViewHorizontalMargin*2;
        }
            break;
    }
    if (_showDirection == DYPopoverDirectionUp || _showDirection == DYPopoverDirectionDown) {
        tempHeight += kPopoverArrawHeight;
    }
    //    if (self.type == ZMPopoverViewContentTypeCustom) {
    //        tempHeight = tempHeight > 230 ? 230 : tempHeight;
    //    }
    return tempHeight;
}

- (CGFloat)getCurrentWidth {
    switch (self.type) {
        case ZMPopoverViewContentTypeAlert: {
            CGSize btnSize = [self.sureButton.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 20.3) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont zm_font15pt:DYFontBoldTypeRegular]}context:nil].size;
            CGFloat width = [self getTitleLabelSize].width;
            if (width < btnSize.width) {
                width = btnSize.width;
            }
            return width + kPopoverViewHorizontalMargin*2;
        }
            break;
        case ZMPopoverViewContentTypeListWithCheck: {
            CGFloat width = 0;
            for (DYPopoverAction *action in _actions) {
                CGRect rect = [action.title boundingRectWithSize:CGSizeMake([self maxWidth], kPopoverViewCellHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont zm_font15pt:DYFontBoldTypeRegular]} context:nil];
                if (width < rect.size.width) {
                    width = rect.size.width;
                }
            }
            return width + kPopoverViewCellImageWidth + kPopoverViewCellSpace + kPopoverViewHorizontalMargin*2;
        }
            break;
        case ZMPopoverViewContentTypeList: {
            CGFloat width = 0;
            for (DYPopoverAction *action in _actions) {
                CGRect rect = [action.title boundingRectWithSize:CGSizeMake([self maxWidth], kPopoverViewCellHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont zm_font15pt:DYFontBoldTypeRegular]} context:nil];
                if (width < rect.size.width) {
                    width = rect.size.width;
                }
            }

            return self.defaultWidth > 0 ? self.defaultWidth : (width + kPopoverListIconMaxSize + kPopoverViewHorizontalMargin*3);
        }
            break;
            
        case ZMPopoverViewContentTypeListIcon: {
            CGFloat width = 0;
            for (DYPopoverAction *action in _actions) {
                CGRect rect = [action.title boundingRectWithSize:CGSizeMake([self maxWidth], kPopoverViewCellHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont zm_font15pt:DYFontBoldTypeRegular]} context:nil];
                if (width < rect.size.width) {
                    width = rect.size.width;
                }
            }

            return self.defaultWidth > 0 ? self.defaultWidth : (width + kPopoverListIconMaxSize + kPopoverViewHorizontalMargin*3);
        }
            break;
        case ZMPopoverViewContentTypeCustom: {
            CGFloat tempWidth = self.customViewSize.width + kPopoverViewHorizontalMargin*2;
            
            return tempWidth;
        }
            break;
        default: {
            
            return [self getTitleLabelSize].width + kPopoverViewHorizontalMargin*2;
        }
            break;
    }
}

- (CGSize)getTitleLabelSize {
    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20.3) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font}context:nil].size;
    if (textSize.width > [self maxWidth] - kPopoverViewHorizontalMargin*2) {
        textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake([self maxWidth] - kPopoverViewHorizontalMargin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font}context:nil].size;
    }
    return textSize;
    
}

- (UIView *)createLineView {
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [[UIColor colorC4] colorWithAlphaComponent:0.2];
    return lineView;
}

- (void)handleCustomViewSize {
    if (!_customView) return;
    _customViewSize = _customViewSize.width > [self maxWidth] ? CGSizeMake([self maxWidth], _customViewSize.height) : _customViewSize;
    if (_customViewSize.width < 0 || _customViewSize.height < 0) {
        _customViewSize = CGSizeZero;
    }
}

#pragma mark -
#pragma mark - 👉 public method 👈
- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction {
    
    [self showToView:pointView popoverDirection:direction onView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView {
    
    [self showToView:pointView popoverDirection:direction onView:onView animated:YES];
}

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction animated:(BOOL)animated {
    [self showToView:pointView popoverDirection:direction onView:[UIApplication sharedApplication].keyWindow animated:animated];
}

- (void)showToView:(UIView *)pointView popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView animated:(BOOL)animated {
    
    _showAnimated = animated;
    _showDirection = direction;
    _showOnView = onView;
    [self handleCustomViewSize];
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:onView];
    //  箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    
    if (!_shouldMaskToView) {
        UIView *snapView = [pointView snapshotViewAfterScreenUpdates:YES];
        snapView.frame = pointViewRect;
        _snapView = snapView;
    }
    
    if (direction == DYPopoverDirectionLeft || direction == DYPopoverDirectionRight) {
        toPoint = CGPointMake(0, CGRectGetMidY(pointViewRect));
    }
    switch (direction) {
        case DYPopoverDirectionDown: {
            toPoint.y = CGRectGetMinY(pointViewRect) - 5.0;
            [self showToPoint:toPoint isUpward:NO];
        }
            break;
        case DYPopoverDirectionLeft: {
            toPoint.x = CGRectGetMaxX(pointViewRect) + 5.0;
            [self showToPoint:toPoint isLeft:YES];
        }
            break;
        case DYPopoverDirectionRight: {
            toPoint.x = CGRectGetMinX(pointViewRect) - 5.0;
            [self showToPoint:toPoint isLeft:NO];
        }
            break;
        default: {
            toPoint.y = CGRectGetMaxY(pointViewRect) + 5.0;
            [self showToPoint:toPoint isUpward:YES];
        }
            break;
    }
}

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction {
    
    [self showToPoint:point popoverDirection:direction onView:[UIApplication sharedApplication].keyWindow   animated:YES];
}

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView {
    [self showToPoint:point popoverDirection:direction onView:onView   animated:YES];
}

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction animated:(BOOL)animated {
    [self showToPoint:point popoverDirection:direction onView:[UIApplication sharedApplication].keyWindow   animated:animated];
}

- (void)showToPoint:(CGPoint)point popoverDirection:(DYPopoverDirection)direction onView:(UIView *)onView  animated:(BOOL)animated {
    
    _showAnimated = animated;
    _showDirection = direction;
    _showOnView = onView;
    [self handleCustomViewSize];
    switch (direction) {
        case DYPopoverDirectionDown: {
            [self showToPoint:point isUpward:NO];
        }
            break;
        case DYPopoverDirectionLeft: {
            [self showToPoint:point isLeft:YES];
        }
            break;
        case DYPopoverDirectionRight: {
            [self showToPoint:point isLeft:NO];
        }
            break;
        default: {
            [self showToPoint:point isUpward:YES];
        }
            break;
    }
}

- (void)hide:(BOOL)animated {
    
    _isAnimating = YES;
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 0.f;
            self -> _shadeView.alpha = 0.f;
            self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        } completion:^(BOOL finished) {
            self -> _isShowing = NO;
            self -> _isAnimating = NO;
            [self -> _snapView removeFromSuperview];
            self -> _snapView = nil;
            [self -> _shadeView removeFromSuperview];
            [self removeFromSuperview];
            self.transform = CGAffineTransformIdentity;
        }];
        
    }else{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
        self.transform = CGAffineTransformIdentity;
        _isShowing = NO;
        _isAnimating = NO;
        [_snapView removeFromSuperview];
        _snapView = nil;
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
        
    }
}

- (void)addAction:(DYPopoverAction *)action {
    [self addActions:@[action]];
}

- (void)addActions:(NSArray <DYPopoverAction *>*)actions {
    [self.actions addObjectsFromArray:actions];
}

- (void)reloadListWithActions:(NSArray <DYPopoverAction *>*)actions {
    [self.actions removeAllObjects];
    [self.actions addObjectsFromArray:actions];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - 👉 setters and getters 👈
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorC4];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont zm_font15pt:DYFontBoldTypeRegular];
    }
    return _titleLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.titleLabel.font = [UIFont zm_font15pt:DYFontBoldTypeRegular];
        [_sureButton setTitleColor:[[UIColor colorC4] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [_sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
            [_tableView  performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];
        }
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.separatorColor = [[UIColor colorC4] colorWithAlphaComponent:0.2];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = _listScrollEnable;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = view;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)setType:(ZMPopoverViewContentType)type {
    _type = type;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (type) {
        case ZMPopoverViewContentTypeAlert: {
            [self addSubview:self.titleLabel];
            [self addSubview:self.sureButton];
            UIView *line = [self createLineView];
            [self addSubview:line];
            _lineView = line;
        }
            break;
        case ZMPopoverViewContentTypeListWithCheck: {
            
            [self addSubview:self.tableView];
        }
            break;
        case ZMPopoverViewContentTypeList: {
            [self addSubview:self.tableView];
        }
            break;
        case ZMPopoverViewContentTypeListIcon: {
            [self addSubview:self.tableView];
        }
            break;
        case ZMPopoverViewContentTypeCustom:{
            if (self.customView && !self.customView.superview) [self addSubview:self.customView];
            break;
        }
        default: {
            [self addSubview:self.titleLabel];
        }
            break;
    }
}

- (UIView *)shadeView {
    if (!_shadeView) {
        _shadeView = [[UIView alloc] init];
        _shadeView.userInteractionEnabled = _shadeViewEnable;
        _shadeView.backgroundColor = _shadeBackgroundColor;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse:)];
        tapGesture.enabled = _hideWhenTouchOutside;
        [_shadeView addGestureRecognizer:tapGesture];
        _tapGesture = tapGesture;
    }
    return _shadeView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setCustomView:(UIView *)customView size:(CGSize)size {
    _customView = customView;
    _customViewSize = size;
    if (self.type == ZMPopoverViewContentTypeCustom) {
        [self addSubview:customView];
    }
}

- (void)setListScrollEnable:(BOOL)listScrollEnable {
    _listScrollEnable = listScrollEnable;
    _tableView.scrollEnabled = listScrollEnable;
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)setHideWhenTouchOutside:(BOOL)hideWhenTouchOutside {
    _hideWhenTouchOutside = hideWhenTouchOutside;
    _tapGesture.enabled = hideWhenTouchOutside;
}

- (void)setShadeBackgroundColor:(UIColor *)shadeBackgroundColor {
    _shadeBackgroundColor = shadeBackgroundColor;
    _shadeView.backgroundColor = shadeBackgroundColor;
}

- (void)setShadeViewEnable:(BOOL)shadeViewEnable {
    _shadeViewEnable = shadeViewEnable;
    _shadeView.userInteractionEnabled = shadeViewEnable;
}

- (void)setArrowPositionRatio:(CGFloat)arrowPositionRatio {
    _arrowPositionRatio = arrowPositionRatio <= 0 ? 0 : arrowPositionRatio;
    _arrowPositionRatio = arrowPositionRatio >= 1 ? 1 : arrowPositionRatio;
}

- (CGFloat)maxWidth {
    CGFloat maxWidth = CGRectGetWidth(self.showOnView.frame) * 0.64 + kPopoverViewHorizontalMargin * 2 * 0.36 + 60.0;
    return maxWidth;
}

@end

@interface DYPopoverAction ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, strong) UIImage * icon;
@property (nonatomic, copy, readwrite) DYPopoverActionBlock popoverActionBlock;

@end

@implementation DYPopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(DYPopoverActionBlock)handler {
    DYPopoverAction *action = [self new];
    action.title = title ? : @"";
    action.popoverActionBlock = handler ? : NULL;
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title icon:(UIImage *)icon handler:(DYPopoverActionBlock)handler{
    DYPopoverAction *action = [self new];
    action.title = title ? : @"";
    action.popoverActionBlock = handler ? : NULL;
    action.icon = icon;
    return action;
}
@end


@implementation DYPopoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isChoose = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.zm_separatorStyle = DYTableViewCellSeparatorStyleSingleIconLine43PX;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.checkImageView];
        [self.contentView addSubview:self.iconBadgeView];
        [self.contentView addSubview:self.iconImageView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(kPopoverViewHorizontalMargin);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.iconBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(kScreenWidthRatio(4));
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return self;
}
//重设ListIcon 类型布局
-(void)layoutListIconCell{
    
    //左侧图片
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(kPopoverViewHorizontalMargin);
        make.width.height.mas_lessThanOrEqualTo(kScreenWidthRatio(kPopoverListIconMaxSize));
    }];
    
    //标题
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(kPopoverListIconSpace);
        make.centerY.mas_equalTo(0);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.frame.size;
//    self.titleLabel.frame = CGRectMake(kPopoverViewHorizontalMargin, 0, size.width-2*kPopoverViewHorizontalMargin-(_isChoose?(kPopoverViewCellSpace+kPopoverViewCellImageWidth):0), size.height);
    self.checkImageView.frame = CGRectMake(size.width-kPopoverViewCellSpace-kPopoverViewCellImageWidth, (size.height-13.0)/2.0, kPopoverViewCellImageWidth, 13.0);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorC5];
        _titleLabel.font = [UIFont zm_font15pt:DYFontBoldTypeRegular];
        _titleLabel.tag = kTitleLabelTag;
    }
    return _titleLabel;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] init];
        _checkImageView.hidden = YES;
    }
    return _checkImageView;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UIView *)iconBadgeView {
    if (!_iconBadgeView) {
        _iconBadgeView = [[UIView alloc]init];
        _iconBadgeView.backgroundColor = [UIColor colorRed1];
        _iconBadgeView.layer.cornerRadius = 4.f;
        _iconBadgeView.layer.masksToBounds = YES;
    }
    return _iconBadgeView;
}

- (void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    if (isChoose) {
        self.checkImageView.hidden = NO;
    }else{
        self.checkImageView.hidden = YES;
    }
    [self setNeedsLayout];
}


@end
