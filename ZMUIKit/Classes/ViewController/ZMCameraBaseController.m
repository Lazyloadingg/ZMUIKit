//
//  ZMCameraBaseController.m
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/19.
//

#import "ZMCameraBaseController.h"
#import <CoreMotion/CoreMotion.h>
//#import <DYFoundation/DYFoundation.h>
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>


//导出视频类型
typedef NS_ENUM(NSUInteger, ZLExportVideoType) {
    //default
    ZLExportVideoTypeMov,
    ZLExportVideoTypeMp4,
};

@interface ZMCameraBaseController ()
<
UIGestureRecognizerDelegate,
AVCaptureFileOutputRecordingDelegate
>

//输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *session;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
//照片输出流对象
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;
//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutPut;

//预览图层，显示相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) AVCaptureVideoOrientation orientation;

@property (nonatomic, strong) UIImageView *takedImageView;

//录制视频保存的url
@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) UIImage * takedImage;

@property (nonatomic, strong) CMMotionManager *motionManager;


@end

@implementation ZMCameraBaseController


- (instancetype)init{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.allowTakePhoto = YES;
        //暂不支持
        self.allowRecordVideo = NO;
        self.maxRecordDuration = 15;
        self.sessionPreset = DYCaptureSessionPreset1280x720;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCamera];
    [self loadCameraDefaultsSetting];
    [self initCameraSubViews];
    [self observeDeviceMotion];
}
- (void)dealloc{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.session startRunning];
    [self setFocusCursorWithPoint:self.view.center];
    if (!self.allowTakePhoto && !self.allowRecordVideo) {
        [ZMHud showTipHUD:@"allowTakePhoto与allowRecordVideo不能同时为NO"];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}
#pragma mark - 监控设备方向
- (void)observeDeviceMotion{
    self.motionManager = [[CMMotionManager alloc] init];
    
    // 提供设备运动数据到指定的时间间隔
    self.motionManager.deviceMotionUpdateInterval = .5;
    
    if (self.motionManager.deviceMotionAvailable) {  // 确定是否使用任何可用的态度参考帧来决定设备的运动是否可用
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        self.motionManager = nil;
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x)) {
        if (y >= 0){
            // UIDeviceOrientationPortraitUpsideDown;
            self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        } else {
            // UIDeviceOrientationPortrait;
            self.orientation = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0) {
            //视频拍照转向，左右和屏幕转向相反
            // UIDeviceOrientationLandscapeRight;
            self.orientation = AVCaptureVideoOrientationLandscapeLeft;
        } else {
            // UIDeviceOrientationLandscapeLeft;
            self.orientation = AVCaptureVideoOrientationLandscapeRight;
        }
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willResignActive
{
    if ([self.session isRunning]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark >_<! 👉🏻 🐷Gesture Delegate🐷
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark >_<! 👉🏻 🐷Event  Response🐷
//手势调整焦距
//- (void)adjustCameraFocus:(UIPanGestureRecognizer *)pan{
//    CGRect caremaViewRect = [self.toolView convertRect:self.toolView.bottomView.frame toView:self.view];
//    CGPoint point = [pan locationInView:self.view];
//
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        if (!CGRectContainsPoint(caremaViewRect, point)) {
//            return;
//        }
//        _dragStart = YES;
//        [self onStartRecord];
//    } else if (pan.state == UIGestureRecognizerStateChanged) {
//        if (!_dragStart) return;
//
//        CGFloat zoomFactor = (CGRectGetMidY(caremaViewRect)-point.y)/CGRectGetMidY(caremaViewRect) * 10;
//        [self setVideoZoomFactor:MIN(MAX(zoomFactor, 1), 10)];
//    } else if (pan.state == UIGestureRecognizerStateCancelled ||
//               pan.state == UIGestureRecognizerStateEnded) {
//        if (!_dragStart) return;
//
//        _dragStart = NO;
//        [self onFinishRecord];
//        //这里需要结束动画
//        [self.toolView stopAnimate];
//    }
//}
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
//拍照
- (void)onTakePicture{
    AVCaptureConnection * videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.videoOrientation = self.orientation;
    if (!videoConnection) {
        ZMLog(@"take photo failed!");
        return;
    }
    
    weakSelf(weakSelf);
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        UIImage * image;
        //判断当前设备，对照片做方向调整
        if (weakSelf.videoInput.device.position == AVCaptureDevicePositionBack) {
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            image = [UIImage imageWithData:imageData];
            
        }else{
            UIImageOrientation  imgOrientation = UIImageOrientationLeftMirrored;
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *t_image = [UIImage imageWithData:imageData];
            image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0f orientation:imgOrientation];
        }
        
        weakSelf.takedImageView.hidden = NO;
        weakSelf.takedImage = image;
        weakSelf.takedImageView.image = image;
        [weakSelf.session stopRunning];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cameraTakePicture:image:devicePosition:imageDataSampleBuffer:error:)]) {
            [weakSelf.delegate cameraTakePicture:weakSelf image:image devicePosition:weakSelf.videoInput.device.position imageDataSampleBuffer:imageDataSampleBuffer error:error];
        }
    }];
}
//重新拍照或录制
- (void)onRetake{
    [self.session startRunning];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setFocusCursorWithPoint:self.view.center];
        if (self.takedImage != nil) {
            [UIView animateWithDuration:0.25 animations:^{
                self.takedImageView.alpha = 0;
            } completion:^(BOOL finished) {
                self.takedImageView.hidden = YES;
                self.takedImageView.alpha = 1;
            }];
        }
    });
#warning MARK TEST
//    [self deleteVideo];
}
//开始录制
- (void)onStartRecord{
    AVCaptureConnection *movieConnection = [self.movieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    movieConnection.videoOrientation = self.orientation;
    [movieConnection setVideoScaleAndCropFactor:1.0];
    if (![self.movieFileOutPut isRecording]) {
#warning MARK TEST
//        NSURL *url = [NSURL fileURLWithPath:[ZLPhotoManager getVideoExportFilePath:self.videoType]];
//        [self.movieFileOutPut startRecordingToOutputFileURL:url recordingDelegate:self];
    }
}
-(void)resetTakedImage{
    
    if (self.takedImageView.image) {
        self.takedImageView.image = nil;
    }
    
}
-(void)onFinishRecord{
    [self.movieFileOutPut stopRecording];
//    [self setVideoZoomFactor:1];
}
- (void)setVideoZoomFactor:(CGFloat)zoomFactor{
    AVCaptureDevice * captureDevice = [self.videoInput device];
    NSError *error = nil;
    [captureDevice lockForConfiguration:&error];
    if (error) return;
    captureDevice.videoZoomFactor = zoomFactor;
    [captureDevice unlockForConfiguration];
}
-(void)onDismiss{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//调整画质
- (NSString *)transformSessionPreset{
    switch (self.sessionPreset) {
        case DYCaptureSessionPreset352x288:
            return AVCaptureSessionPreset352x288;
            
        case DYCaptureSessionPreset640x480:
            return AVCaptureSessionPreset640x480;
            
        case DYCaptureSessionPreset1280x720:
            return AVCaptureSessionPreset1280x720;
        
        case DYCaptureSessionPreset1920x1080:
            return AVCaptureSessionPreset1920x1080;
            
        case DYCaptureSessionPreset3840x2160:
        {
            if (@available(iOS 9.0, *)) {
                return AVCaptureSessionPreset3840x2160;
            } else {
                return AVCaptureSessionPreset1920x1080;
            }
        }
        default:
            return AVCaptureSessionPreset1920x1080;
    }
}
#warning MARK TEST
//- (void)playVideo
//{
//    if (!_playerView) {
//        self.playerView = [[ZLPlayer alloc] initWithFrame:self.view.bounds];
//        [self.view insertSubview:self.playerView belowSubview:self.toolView];
//    }
//    self.playerView.hidden = NO;
//    self.playerView.videoUrl = self.videoUrl;
//    [self.playerView play];
//}
//
//- (void)deleteVideo
//{
//    if (self.videoUrl) {
//        [self.playerView reset];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.playerView.alpha = 0;
//        } completion:^(BOOL finished) {
//            self.playerView.hidden = YES;
//            self.playerView.alpha = 1;
//        }];
//        [[NSFileManager defaultManager] removeItemAtURL:self.videoUrl error:nil];
//    }
//}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections
{
//    [self.toolView startAnimate];
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error
{
    if (CMTimeGetSeconds(output.recordedDuration) < 0.3) {
        if (self.allowTakePhoto) {
            //视频长度小于0.3s 允许拍照则拍照，不允许拍照，则保存小于0.3s的视频
            ZMLog(@"视频长度小于0.3s，按拍照处理");
            [self onTakePicture];
            return;
        }
    }
    [self.session stopRunning];
    self.videoUrl = outputFileURL;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#warning MARK TEST
//        [self playVideo];
    });
}
#pragma mark >_<! 👉🏻 🐷 设置聚焦点 🐷
- (void)adjustFocusPoint:(UITapGestureRecognizer *)tap{
    if (!self.session.isRunning) return;
    
    CGPoint point = [tap locationInView:self.view];
    
    if (CGRectContainsPoint(self.unableFocusRect, point)) {
        return;
    }

    [self setFocusCursorWithPoint:point];
}

//设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point{
    
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraTapActionFocus:point:capturePoint:)]) {
        [self.delegate cameraTapActionFocus:self point:point capturePoint:cameraPoint];
    }
}

//设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    AVCaptureDevice * captureDevice = [self.videoInput device];
    NSError * error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if (![captureDevice lockForConfiguration:&error]) {
        return;
    }
    //聚焦模式
    if ([captureDevice isFocusModeSupported:focusMode]) {
        [captureDevice setFocusMode:focusMode];
    }
    //聚焦点
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    //曝光模式
    if ([captureDevice isExposureModeSupported:exposureMode]) {
        [captureDevice setExposureMode:exposureMode];
    }
    //曝光点
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    [captureDevice unlockForConfiguration];
}
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
//切换摄像头
- (void)switchCamera{
    NSUInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = self.videoInput.device.position;
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        } else {
            return;
        }
        
        if (newVideoInput) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            ZMLog(@"切换前后摄像头失败");
        }
    }
}
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setVideoGravity:(AVLayerVideoGravity)videoGravity{
    _videoGravity = videoGravity;
    
    [self.previewLayer setVideoGravity:_videoGravity];
}
-(UIImageView *)takedImageView{
    if (!_takedImageView) {
        _takedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _takedImageView.backgroundColor = [UIColor blackColor];
        _takedImageView.hidden = YES;
        _takedImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _takedImageView;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI🐷
-(void)loadCameraDefaultsSetting{
    
//    if (self.allowRecordVideo) {
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(adjustCameraFocus:)];
//        pan.maximumNumberOfTouches = 1;
//        [self.view addGestureRecognizer:pan];
//    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adjustFocusPoint:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            if (self.allowRecordVideo) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (!granted) {
                        [self onDismiss];
                    } else {
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
                    }
                }];
            } else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
            }
        } else {
            [self onDismiss];
        }
    }];
    
    if (self.allowRecordVideo) {
        //暂停其他音乐
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
}
-(void)initCameraSubViews{
    [self.view addSubview:self.takedImageView];
}

-(void)configCamera{
    
    self.session = [[AVCaptureSession alloc] init];
    
    //相机画面输入流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:self.devicePosition == AVCaptureDevicePositionUnspecified ? AVCaptureDevicePositionBack : self.devicePosition] error:nil];
    
    //照片输出流
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.imageOutPut setOutputSettings:dicOutputSetting];
    
    //音频输入流
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
    AVCaptureDeviceInput *audioInput = nil;
    if (self.allowRecordVideo) {
        audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:nil];
    }
    
    
    //视频输出流
    //设置视频格式
    NSString *preset = [self transformSessionPreset];
    if ([self.session canSetSessionPreset:preset]) {
        self.session.sessionPreset = preset;
    } else {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    self.movieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    // 解决视频录制超过10s没有声音的bug
    self.movieFileOutPut.movieFragmentInterval = kCMTimeInvalid;
    
    //将视频及音频输入流添加到session
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if (audioInput && [self.session canAddInput:audioInput]) {
        [self.session addInput:audioInput];
    }
    
    //将输出流添加到session
    if ([self.session canAddOutput:self.imageOutPut]) {
        [self.session addOutput:self.imageOutPut];
    }
    
    if ([self.session canAddOutput:self.movieFileOutPut]) {
        [self.session addOutput:self.movieFileOutPut];
    }
    //预览层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.view.layer setMasksToBounds:YES];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.view.layer.bounds;

}
@end
