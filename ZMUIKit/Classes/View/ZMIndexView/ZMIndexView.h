
#import <UIKit/UIKit.h>
#import "ZMIndexViewConfiguration.h"

@class ZMIndexView;

@protocol ZMIndexViewDelegate <NSObject>

@optional

/**
 当点击或者滑动索引视图时，回调这个方法

 @param indexView 索引视图
 @param section   索引位置
 */
- (void)indexView:(ZMIndexView *)indexView didSelectAtSection:(NSUInteger)section;

/**
 当滑动tableView时，索引位置改变，你需要自己返回索引位置时，实现此方法。
 不实现此方法，或者方法的返回值为 ZMIndexViewInvalidSection 时，索引位置将由控件内部自己计算。

 @param indexView 索引视图
 @param tableView 列表视图
 @return          索引位置
 */
- (NSUInteger)sectionOfIndexView:(ZMIndexView *)indexView tableViewDidScroll:(UITableView *)tableView;

@end

@interface ZMIndexView : UIControl

@property (nonatomic, weak) id<ZMIndexViewDelegate> delegate;

// 索引视图数据源
@property (nonatomic, copy) NSArray<NSString *> *dataSource;

// 当前索引位置
@property (nonatomic, assign) NSInteger currentSection;

// tableView在NavigationBar上是否半透明
@property (nonatomic, assign) BOOL translucentForTableViewInNavigationBar;

// tableView从第几个section开始使用索引 Default = 0
@property (nonatomic, assign) NSUInteger startSection;

// 索引视图的配置
@property (nonatomic, strong, readonly) ZMIndexViewConfiguration *configuration;

// ZMIndexView 对 tableView 进行 weak 引用
- (instancetype)initWithTableView:(UITableView *)tableView configuration:(ZMIndexViewConfiguration *)configuration;

// 手动更新IndexView的CurrentSection
- (void)refreshCurrentSection;

@end
