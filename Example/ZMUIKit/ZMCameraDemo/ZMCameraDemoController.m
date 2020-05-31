//
//  ZMCameraDemoController.m
//  ZMUIKit_Example
//
//  Created by Lazyloading on 2020/5/31.
//  Copyright © 2020 lazyloading@163.com. All rights reserved.
//

#import "ZMCameraDemoController.h"
#import <ZMUIKit.h>
#import <Masonry/Masonry.h>

@interface ZMCameraDemoController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArray;
@end

@implementation ZMCameraDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}

#pragma mark >_<! 👉🏻 🐷 Life cycle 🐷
#pragma mark >_<! 👉🏻 🐷 Delegate 🐷
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataArray[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"23333"];
    cell.textLabel.text = dict[@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dict = self.dataArray[indexPath.row];
    NSString * type = dict[@"type"];
    switch (type.integerValue) {
        case 0:{
            [self bankCard];
        }
            
            break;
            
        case 1:{
            [self IDCardFace:YES];
        }

            break;
            
        default:
            break;
    }
}
#pragma mark >_<! 👉🏻 🐷 Event  Response 🐷
#pragma mark >_<! 👉🏻 🐷 Private Methods 🐷
-(void)bankCard{
    ZMCameraCardController * vc = [[ZMCameraCardController alloc]init];
    vc.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    vc.cameraType = DYCameraCardTypeBank;
    [self presentViewController:vc animated:YES completion:nil];
    
    [vc setTakePictureBlock:^(ZMCameraCardController * _Nonnull vc, UIView * _Nonnull clipView, UIImage * _Nonnull originImage, UIImage * _Nonnull clipImage) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        ZMLog(@"origin %@---clip %@",originImage,clipImage);
    }];
}
//自定义证件相机
-(void)IDCardFace:(BOOL)face{
    ZMCameraCardController * vc = [[ZMCameraCardController alloc]init];
    vc.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    if (face) {
        vc.cameraType = DYCameraCardTypeIDFace;
    }else{
        vc.cameraType = DYCameraCardTypeNational;
    }
    [self presentViewController:vc animated:YES completion:nil];
    
    [vc setTakePictureBlock:^(ZMCameraCardController * _Nonnull vc, UIView * _Nonnull clipView, UIImage * _Nonnull originImage, UIImage * _Nonnull clipImage) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        ZMLog(@"origin %@---clip %@",originImage,clipImage);
    }];
    
}
#pragma mark >_<! 👉🏻 🐷 Setter && Getter 🐷
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"23333"];
        _tableView = tableView;
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
        _dataArray = @[
            @{
                @"type" : @"0",
                @"title" : @"银行卡",
            },
            @{
                @"type" : @"1",
                @"title" : @"身份证人脸",
            }
        ];
    }
    return _dataArray;
}
#pragma mark >_<! 👉🏻 🐷 Default Config🐷

-(void)loadDefaultsSetting{
    self.view.backgroundColor = [UIColor orangeColor];
}
-(void)initSubViews{
    [self.view addSubview:self.tableView];
    
    [self layout];

}
-(void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
