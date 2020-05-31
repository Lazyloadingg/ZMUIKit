//
//  ZMViewController.m
//  ZMUIKit
//
//  Created by lazyloading@163.com on 05/23/2020.
//  Copyright (c) 2020 lazyloading@163.com. All rights reserved.
//

#import "ZMViewController.h"
#import <Masonry/Masonry.h>
#import <ZMUIKit.h>

@interface ZMViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UISearchResultsUpdating
>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}

#pragma mark >_<! 👉🏻 🐷 Life cycle 🐷
#pragma mark >_<! 👉🏻 🐷 Delegate 🐷
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"开发ing";
        case 1:
            return @"待审核";
        default:
            return @"可使用";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"titleName"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    NSString *str =  dict[@"className"];
    UIViewController *controller = nil;
    controller = [[NSClassFromString(str) alloc] init];
    controller.title = dict[@"titleName"];
    [controller setHidesBottomBarWhenPushed:YES];
    if (@available(iOS 11.0, *)) controller.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    [self reloadTableBySearchText:searchController.searchBar.text];
}
#pragma mark >_<! 👉🏻 🐷 Event  Response 🐷
#pragma mark >_<! 👉🏻 🐷 Private Methods 🐷

- (void)reloadTableBySearchText:(NSString *)searchText {
    ZMLog(@"%@",searchText);
    
}
#pragma mark >_<! 👉🏻 🐷 Setter && Getter 🐷
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
            @[
                @{
                    @"titleName" : @"自定义相机",
                    @"className" : @"ZMCameraDemoController",
                },
                @{
                    @"titleName" : @"toast",
                    @"className" : @"ZMHUDDemoController",
                },
            ]
        ];
    }
    return _dataArray;
}
- (UISearchController *)searchController {
    if (!_searchController) {
        ZMViewController *vc = [ZMViewController new];
        _searchController = [[UISearchController alloc]initWithSearchResultsController:vc];
        _searchController.searchResultsUpdater = vc;
    }
    return _searchController;
}
#pragma mark >_<! 👉🏻 🐷 Default Config🐷

-(void)loadDefaultsSetting{
    self.view.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
}
-(void)initSubViews{
       self.definesPresentationContext = YES;
        BOOL isPhoneX = kDeviceIsiPhoneX();

        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = YES;
            self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
            self.navigationItem.hidesSearchBarWhenScrolling = 1;
    #warning UI 组件多的时候记得把搜索功能加上去...
            self.navigationItem.searchController = self.searchController;
        }
    //    self.statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationItem.title = @"基础UI组件";
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
}


@end
