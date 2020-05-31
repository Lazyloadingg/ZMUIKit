//
//  ZMCameraCardController.m
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/28.
//

#import "ZMCameraCardController.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>
//#import <DYFoundation/DYFoundation.h>

//view
#import "ZMCameraIDCardToolView.h"

@interface ZMCameraCardController ()
<
ZMCameraToolViewDelegate,
DYCustomCameraDelegate
>
@property (nonatomic, strong) ZMCameraIDCardToolView * IDCardToolView;
@end

@implementation ZMCameraCardController

#pragma mark >_<! 👉🏻 🐷Life cycle🐷

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 判断授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        // 用户拒绝当前应用访问相机
        [self cameraAuthorizationAlert];
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // 用户还没有做出选择
        // 弹框请求用户授权
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                //拒绝
                [self onDismissAction];
            }
        }];
    }
}
//未授权相机权限弹窗
-(void)cameraAuthorizationAlert{

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尚未开启相机权限,将影响拍照,是否去开启？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消授权
        [self onDismissAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]  options:@{} completionHandler:^(BOOL success) {
                
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark >_<! 👉🏻 🐷ZMCameraToolViewDelegate 🐷
-(void)onTakePictureAction{
    
    self.IDCardToolView.takePhotoBtn.selected = !self.IDCardToolView.takePhotoBtn.selected;
    if (self.IDCardToolView.takePhotoBtn.selected) {
        [self onTakePicture];
    }else{
        self.IDCardToolView.preImg.image = nil;
    }
    
}
- (void)onDismissAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark >_<! 👉🏻 🐷 DYCustomCameraDelegate 🐷
-(void)cameraTakePicture:(UIViewController *)controller image:(UIImage *)image devicePosition:(AVCaptureDevicePosition)posion imageDataSampleBuffer:(CMSampleBufferRef)imageDataSampleBuffer error:(NSError *)error{
    UIImage * temp = image.copy;
    if (self.cameraType == DYCameraCardTypeGeneral) {
        /// 通用类型可设置图片旋转方向
        if (self.imageOrientation) {
            temp = [UIImage imageWithCGImage:temp.CGImage scale:temp.scale orientation:self.imageOrientation];
        }
    }else {
        /// 剩余的这几种都是向右旋转
        temp = [UIImage imageWithCGImage:temp.CGImage scale:temp.scale orientation:UIImageOrientationRight];
    }

    temp = [UIImage zm_fixOrientation:temp];
    CGFloat widthScale = temp.size.width / kScreen_width;
    CGFloat heightScale = temp.size.height / kScreen_height;
    
    CGFloat y = self.IDCardToolView.boxImg.zm_y * heightScale;
    CGFloat x  = self.IDCardToolView.boxImg.zm_x * widthScale;
    CGFloat height = self.IDCardToolView.boxImg.zm_h * heightScale ;
    CGFloat width  = self.IDCardToolView.boxImg.zm_w * widthScale ;
    
    CGImageRef cgRef = temp.CGImage;
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, rect);
    
    temp = [UIImage imageWithCGImage:imageRef];
    temp = [self harfWithImage:temp toSize:CGSizeMake(temp.size.width / 2, temp.size.height / 2)];
    
    self.IDCardToolView.preImg.image = temp;
    [self onRetake];
    if (self.takePictureBlock) {
        self.takePictureBlock(self, self.IDCardToolView.boxImg, image, temp);
    }
    
}
#pragma mark >_<! 👉🏻 🐷Event  Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷

- (UIImage *)harfWithImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(ZMCameraIDCardToolView *)IDCardToolView{
    if (!_IDCardToolView) {
        _IDCardToolView = [[ZMCameraIDCardToolView alloc]init];
        _IDCardToolView.delegate = self;
    }
    return _IDCardToolView;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI🐷
-(void)loadDefaultsSetting{
    self.view.backgroundColor = [UIColor colorBlack1];
    self.delegate = self;
    self.videoGravity = AVLayerVideoGravityResizeAspectFill;

}
-(void)initSubViews{
    [self.view addSubview:self.IDCardToolView];
    switch (self.cameraType) {
        case DYCameraCardTypeIDFace:{
            self.IDCardToolView.boxImg.image = [UIImage zm_kitImageNamed:@"zm_camera_idcard_front"];
        }
            
            break;
            
        case DYCameraCardTypeNational:{
            self.IDCardToolView.boxImg.image = [UIImage zm_kitImageNamed:@"zm_camera_idcard_back"];
        }
            break;
            
        case DYCameraCardTypeBank:{
            self.IDCardToolView.boxImg.image = [UIImage zm_kitImageNamed:@"zm_camera_idcard_bank"];
        }
            break;
            
        case DYCameraCardTypeGeneral:{
            self.IDCardToolView.boxImg.image = [UIImage zm_kitImageNamed:@"zm_camera_general"];
        }
            break;
            
        default:
            break;
    }
    
    [self layout];
}
-(void)layout{
    [self.IDCardToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
@end
