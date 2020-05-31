//
//  ZMCameraController.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/11/12.
//

#import "ZMCameraController.h"
#import <Aspects/Aspects.h>
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>
#import "ZMUtilities.h"
//#import <DYFoundation/DYFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "UIView+ZMExtension.h"
#import "UIImage+ZMExtension.h"
#import "ZMHud.h"
#import "TZImagePickerController.h"
#import "ZMCameraToolView.h"

#define kTopViewScale .5
#define kBottomViewScale .7

#define kAnimateDuration .1



#pragma mark -
#pragma mark - -> 🐷 ZMCameraController 🐷
@interface ZMCameraController ()
<
ZMCameraToolViewDelegate,
DYCustomCameraDelegate
>
{
    //拖拽手势开始的录制
    BOOL _dragStart;
    BOOL _layoutOK;
}
@property (nonatomic, strong) ZMCameraToolView *toolView;
////拍照录视频相关
////AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
//@property (nonatomic, strong) AVCaptureSession *session;
////AVCaptureDeviceInput对象是输入流
//@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
////照片输出流对象
//@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;
////视频输出流
//@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutPut;
//
////预览图层，显示相机拍摄到的画面
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//切换摄像头按钮
@property (nonatomic, strong) UIButton *toggleCameraBtn;
//聚焦图
@property (nonatomic, strong) UIImageView *focusCursorImageView;

//拍照照片显示
//@property (nonatomic, strong) UIImageView *takedImageView;
////拍照的照片
//@property (nonatomic, strong) UIImage *takedImage;

#warning MARK TEST
//播放视频
//@property (nonatomic, strong) ZLPlayer *playerView;

//@property (nonatomic, strong) CMMotionManager *motionManager;
//
//@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

@property (nonatomic, strong) UIImage * capImage;

@end

@implementation ZMCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circleProgressColor = [UIColor colorBlue1];
    self.delegate = self;
    [self setupUI];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (_layoutOK) return;
    _layoutOK = YES;
    
    self.toolView.frame = CGRectMake(0, kScreen_height-150-kSafeAreaBottomHeight(), kScreen_width, 100);
    self.toggleCameraBtn.frame = CGRectMake(kScreen_width-50, UIApplication.sharedApplication.statusBarFrame.size.height, 30, 30);
    self.unableFocusRect = self.toolView.frame;
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    self.toolView = [[ZMCameraToolView alloc] init];
    self.toolView.delegate = self;
    self.toolView.allowTakePhoto = self.allowTakePhoto;
    self.toolView.allowRecordVideo = self.allowRecordVideo;
    self.toolView.circleProgressColor = self.circleProgressColor;
    self.toolView.maxRecordDuration = self.maxRecordDuration;
    self.toolView.allowCrop = self.allowCrop;
    [self.view addSubview:self.toolView];
    
    self.focusCursorImageView = [[UIImageView alloc] initWithImage:[UIImage zm_kitImageNamed:@"zl_focus"]];
    self.focusCursorImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.focusCursorImageView.clipsToBounds = YES;
    self.focusCursorImageView.frame = CGRectMake(0, 0, 70, 70);
    self.focusCursorImageView.alpha = 0;
    [self.view addSubview:self.focusCursorImageView];
    
    self.toggleCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toggleCameraBtn setImage:[UIImage zm_kitImageNamed:@"zl_toggle_camera"] forState:UIControlStateNormal];
    [self.toggleCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleCameraBtn];

}
#pragma mark --> 🐷 对角 🐷
//设置聚焦光标图片位置
- (void)setFocusCursorViewWithPoint:(CGPoint)point{
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.alpha = 1;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha=0;
    }];
}
#pragma mark --> 🐷 private method 🐷
//裁剪图片
-(void)cropImage:(UIImage *)image asset:(PHAsset *)asset{
    weakSelf(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        TZImagePickerController * crop = [[TZImagePickerController alloc]initCropTypeWithAsset:asset photo:image completion:^(UIImage *cropImage, PHAsset *asset) {
            
            weakSelf.capImage = cropImage;
            if(weakSelf.completionBlock){
                weakSelf.completionBlock(weakSelf.capImage,@"");
            }
        }];
        
        if (CGRectEqualToRect(self.cropRect, CGRectZero)) {
            NSInteger left = 20;
            NSInteger widthHeight = crop.view.zm_w - 2 * left;
            NSInteger top = (crop.view.zm_h - widthHeight) / 2;
            crop.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
        }else {
            crop.cropRect = self.cropRect;
        }
        
        
        crop.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf showDetailViewController:crop sender:nil];
        
        [crop aspect_hookSelector:@selector(dismissViewControllerAnimated:completion:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo) {
            [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        } error:nil];
        
    });
}
//未授权相册权限弹窗
-(void)authorizationStatusAlert{
    weakSelf(weakSelf);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尚未开启相册写入权限，将影响拍照后保存功能的使用，是否去开启？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //重新预览
        [weakSelf onRetake];
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

#pragma mark --> 🐷 DYCustomCameraDelegate 🐷
-(void)cameraTapActionFocus:(UIViewController *)controller point:(CGPoint)point capturePoint:(CGPoint)capturePoint{
    [self setFocusCursorViewWithPoint:point];
}
-(void)cameraTakePicture:(UIViewController *)controller image:(UIImage *)image devicePosition:(AVCaptureDevicePosition)posion imageDataSampleBuffer:(CMSampleBufferRef)imageDataSampleBuffer error:(NSError *)error{
    if (imageDataSampleBuffer == NULL) {
        return;
    }

    //如果裁剪
    if (self.allowCrop) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusDenied) {
            //用户禁止访问相册
            [self authorizationStatusAlert];
            
        }else if(status == PHAuthorizationStatusNotDetermined){
            //用户尚未选择是否授权
            [self saveImageToLibrary:image];
            
            //监听权限变化
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized){
                    //允许
                    [self saveImageToLibrary:image];
                }else{
                    //拒绝
                    [self onRetake];
                }
            }];
            
        }else{
            [self saveImageToLibrary:image];
        }
    }
}
-(void)saveImageToLibrary:(UIImage *)image{
    [UIImage zm_saveImage:image completion:^(BOOL result, PHAsset * _Nonnull asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                //裁剪
                [self cropImage:image asset:asset];
            }else{
                //重新预览
//                [self onRetake];
            }
        });
    }];
}
#pragma mark --> 🐷 ZMCameraToolViewDelegate 🐷
-(void)onTakePictureAction{
    [self onTakePicture];
}
-(void)onRetakeAction{
    [self onRetake];
}
//开始录制
-(void)onStartRecordAction{
//    [self onStartRecord];
}
//结束录制
- (void)onFinishRecordAction{
    [self onFinishRecord];
}
//确定选择
- (void)onOkClickAction{
//    [self.playerView reset];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock(self.capImage, @"");
        }
    }];
}

//dismiss
- (void)onDismissAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


@end
