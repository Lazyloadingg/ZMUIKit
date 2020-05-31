//
//  ZMDownScreeningMenuView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/26.
//

#import <ZMUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZMDownScreeningMenuViewDataSource;

/// 向下弹出筛选菜单
@interface ZMDownScreeningMenuView : ZMDownMenuView

@property (nonatomic, weak) id <ZMDownScreeningMenuViewDataSource> dataSource;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end




/// 默认的下拉筛选 Cell
@interface DYDownScreeningMenuCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end



@protocol ZMDownScreeningMenuViewDataSource <NSObject>


/// 选项个数
/// @param menuView 菜单视图
- (NSInteger)countOfItemInMenuView:(ZMDownScreeningMenuView *)menuView;


/// 菜单总行数
/// @param menuView 菜单视图
- (NSInteger)lineForCountAtMenuView:(ZMDownScreeningMenuView *)menuView;


/// 菜单总列数
/// @param menuView 菜单视图
- (NSInteger)columnForCountAtMenuView:(ZMDownScreeningMenuView *)menuView;


/// 部署cell
/// @param menuView 菜单视图
/// @param displayCell cell
/// @param index 索引
- (void)menuView:(ZMDownScreeningMenuView *)menuView deploymentCell:(__kindof UICollectionViewCell *)displayCell index:(NSInteger)index;


@optional

/// itemSize(优先级大于根据列、行等计算出来的size)
/// @param menuView 菜单视图
/// @param collectionViewLayout layout
/// @param indexPath indexPath
- (CGSize)menuView:(ZMDownScreeningMenuView *)menuView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/// 配置title（不实现此代理则默认没有title）
/// @param menuView 菜单视图
/// @param titleLabel titleLabel
- (void)menuView:(ZMDownScreeningMenuView *)menuView deploymentTitle:(UILabel *)titleLabel;

/// 不实现此代理 则默认注册的是 DYDownScreeningMenuCell
/// @param menuView 菜单视图
- (Class)classForItemMenuView:(ZMDownScreeningMenuView *)menuView;


/// 默认选中第几个（不实现此代理则表示没有默认选中）
/// @param menuView 菜单视图
- (NSInteger)indexForDefaultSelectAtMenuView:(ZMDownScreeningMenuView *)menuView;


/// 点击index
/// @param menuView 菜单视图
/// @param index 索引
- (void)menuView:(ZMDownScreeningMenuView *)menuView didSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
