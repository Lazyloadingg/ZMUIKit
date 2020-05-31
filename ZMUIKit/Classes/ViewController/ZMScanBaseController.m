//
//  ZMScanBaseController.m
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/29.
//

#import "ZMScanBaseController.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

@interface ZMScanBaseController ()
<
AVCaptureMetadataOutputObjectsDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate
>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@end

@implementation ZMScanBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDefaultSetting];
    [self configSubviews];
}

#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects && metadataObjects.count > 0) {
        NSMutableArray * results = [NSMutableArray arrayWithCapacity:metadataObjects.count];
        [metadataObjects enumerateObjectsUsingBlock:^(__kindof AVMetadataMachineReadableCodeObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [results addObject:obj.stringValue];
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(scanComplete:results:)]) {
            [self.delegate scanComplete:self results:results];
        }
    }
    [self stopScan];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 这个方法会时时调用，但内存很稳定
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanBrightness:brightnessValue:)]) {
        [self.delegate scanBrightness:self brightnessValue:brightnessValue];
    }
}
#pragma mark >_<! 👉🏻 🐷Event  Response🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷

//开始扫描
-(void)startScan{
    [self.session startRunning];
}

//开始扫描
-(void)stopScan{
    [self.session stopRunning];
}

-(void)openFlashlight:(BOOL)on{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        if (on) {
            [device setTorchMode:AVCaptureTorchModeOn];
        }else{
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setVideoGravity:(AVLayerVideoGravity)videoGravity{
    _videoGravity = videoGravity;
    [self.videoPreviewLayer setVideoGravity:_videoGravity];
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI🐷
-(void)configDefaultSetting{
    
}
-(void)configSubviews{
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建摄像设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    [deviceInput.device lockForConfiguration:nil];
    [deviceInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    [deviceInput.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    [deviceInput.device unlockForConfiguration];
    
    // 3、创建元数据输出流
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）;
    // 如需限制扫描框范围，打开下一句注释代码并进行相应调整
    //    metadataOutput.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 4、创建会话对象
    _session = [[AVCaptureSession alloc] init];
    
    // 并设置会话采集率
    _session.sessionPreset = self.sessionPreset ?: AVCaptureSessionPreset1920x1080;
    
    // 5、添加元数据输出流到会话对象
    [_session addOutput:metadataOutput];
    
    // 创建摄像数据输出流并将其添加到会话对象上,  --> 用于识别光线强弱
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_videoDataOutput];
    
    // 6、添加摄像设备输入流到会话对象
    [_session addInput:deviceInput];
    
    // 7、设置数据输出类型(如下设置为条形码和二维码兼容)，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 8、实例化预览图层, 用于显示会话对象
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    // 保持纵横比；填充层边界
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _videoPreviewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];

    [self startScan];
}

@end
