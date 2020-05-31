//
//  DHGuidePageHUD.m
//  DHGuidePageHUD
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 dingding3w. All rights reserved.
//

#import "DYGuidePageView.h"
#import "DYGifImageOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define DDHidden_TIME   0.5
#define DDScreenW   [UIScreen mainScreen].bounds.size.width
#define DDScreenH   [UIScreen mainScreen].bounds.size.height
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface DYGuidePageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray                 *imageArray;
@property (nonatomic, assign) NSInteger               slideIntoNumber;
@property (nonatomic, strong) AVPlayerViewController *playerController;
@end

@implementation DYGuidePageView

- (instancetype)zm_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden {
    if ([super initWithFrame:frame]) {
        self.mode = DYGuidePageModeStaticImage;
        [self initStaticImageWithFrame:frame imageNameArray:imageNameArray buttonIsHidden:isHidden];
    }
    return self;
}
-(void) initStaticImageWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden{
    self.slideInto = NO;
    if (isHidden == YES) {
        self.imageArray = imageNameArray;
    }
    // 设置引导视图的scrollview
    UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
    [guidePageView setBackgroundColor:[UIColor lightGrayColor]];
    [guidePageView setContentSize:CGSizeMake(DDScreenW*imageNameArray.count, DDScreenH)];
    [guidePageView setBounces:NO];
    [guidePageView setPagingEnabled:YES];
    [guidePageView setShowsHorizontalScrollIndicator:NO];
    [guidePageView setDelegate:self];
    guidePageView.layer.zPosition = 10;
    [self addSubview:guidePageView];
    //        // 设置引导页上的跳过按钮
    //        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.8, DDScreenW*0.1, 50, 25)];
    //        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    //        [skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    //        [skipButton setBackgroundColor:[UIColor grayColor]];
    //        // [skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //        [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        // [skipButton.layer setCornerRadius:5.0];
    //        [skipButton.layer setCornerRadius:(skipButton.frame.size.height * 0.5)];
    //        [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [self addSubview:skipButton];
    
    // 添加在引导视图上的多张引导图片
    for (int i=0; i<imageNameArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DDScreenW*i, 0, DDScreenW, DDScreenH)];
        
        if ([[DYGifImageOperation dh_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]]] isEqualToString:@"gif"]) {
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
            imageView = (UIImageView *)[[DYGifImageOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
            [guidePageView addSubview:imageView];
        } else {
            
            imageView.image = [UIImage imageNamed:imageNameArray[i]];
            [guidePageView addSubview:imageView];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        // 设置在最后一张图片上显示进入体验按钮
        if (i == imageNameArray.count-1 && isHidden == NO) {
            [imageView setUserInteractionEnabled:YES];
            //                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.3, DDScreenH*0.8, DDScreenW*0.4, DDScreenH*0.08)];
            UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake((DDScreenW-385/2)/2, DDScreenH-35 - 40, 385/2, 35)];
            [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
            [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [startButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [startButton setBackgroundColor:HEXCOLOR(0x1EA2FA)];
            startButton.layer.cornerRadius = 15.0f;
            startButton.clipsToBounds = true;
            [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startButton];
        }
    }
    
    // 设置引导页上的页面控制器
    self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, DDScreenH - 10 - 20, DDScreenW, 10)];
    self.imagePageControl.backgroundColor = [UIColor clearColor];
    self.imagePageControl.currentPage = 0;
    self.imagePageControl.numberOfPages = imageNameArray.count;
    self.imagePageControl.pageIndicatorTintColor = HEXCOLOR(0xd6d6d6);
    self.imagePageControl.currentPageIndicatorTintColor = HEXCOLOR(0x45BFFF); //[UIColor whiteColor];
    self.imagePageControl.layer.zPosition = 11;
    [self addSubview:self.imagePageControl];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == NO) {
        [self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count-1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 四舍五入,保证pageControl状态跟随手指滑动及时刷新
    [self.imagePageControl setCurrentPage:(int)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5f)];
}

#pragma mark - EventClick
- (void)buttonClick:(UIButton *)button {
    NSLog(@"按钮响应");
    
    if (self.completeBlock) {
        self.completeBlock();
    }
    [UIView animateWithDuration:DDHidden_TIME animations:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeGuidePageHUD];
        });
    }];
}

- (void)removeGuidePageHUD {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeFromSuperview];
    
}

/**< APP视频新特性页面(新增测试模块内容) */
- (instancetype)zm_initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        self.mode = DYGuidePageModeVideo;
        [self initVideoPlayer:frame videoUrl:videoURL mode:MPMovieRepeatModeOne];
    }
    return self;
}
-(void) initVideoPlayer:(CGRect) frame videoUrl:(NSURL *)videoURL mode:(MPMovieRepeatMode) mode{
    //    self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    //    [self.playerController.view setFrame:frame];
    //    [self.playerController.view setAlpha:1.0];
    //    [self.playerController setControlStyle:MPMovieControlStyleNone];
    //    [self.playerController setRepeatMode:MPMovieRepeatModeNone];//不重复播放
    //    [self.playerController setShouldAutoplay:YES];
    //    [self.playerController prepareToPlay];
    //    [self addSubview:self.playerController.view];
    //    [self addNotification];
    // 设置资源路径
    
    AVPlayer *avPlayer= [AVPlayer playerWithURL:videoURL];
    // player的控制器对象
    self.playerController = [[AVPlayerViewController alloc] init];
    // 控制器的player播放器
    self.playerController.player = avPlayer;
    // 试图的填充模式
    self.playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    // 是否显示播放控制条
    self.playerController.showsPlaybackControls = NO;
    // 设置显示的Frame
    self.playerController.view.frame = frame;
    // 将播放器控制器添加到当前页面控制器中
    //    [self addChildViewController:_playerViewController];
    // view一定要添加，否则将不显示
    [self addSubview:self.playerController.view];
    // 播放
    [self.playerController.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd:)  name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //        // 视频引导页进入按钮
    //        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DDScreenH-30-40, DDScreenW-40, 40)];
    //        [movieStartButton.layer setBorderWidth:1.0];
    //        [movieStartButton.layer setCornerRadius:20.0];
    //        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    //        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
    //        [movieStartButton setAlpha:0.0];
    //        [self.playerController.view addSubview:movieStartButton];
    //        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [UIView animateWithDuration:DDHidden_TIME animations:^{
    //            [movieStartButton setAlpha:1.0];
    //        }];
}
// 视频循环播放
- (void)videoPlayEnd:(NSNotification*)notification{

    if (self.mode == DYGuidePageModeVideoStaticImage) {
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performSelector:@selector(removeVideoView) withObject:nil afterDelay:0.0];
            });
        }];
    }else{
        if (self.completeBlock) {
            self.completeBlock();
        }
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeGuidePageHUD];
            });
        }];
    }
}
-(void)removeVideoView{
    
    [self.playerController.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**< APP视频新特性页面(新增测试模块内容) */
- (instancetype)zm_initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL  Images:(NSArray *) list{
    if ([super initWithFrame:frame]) {
        self.images = list;
        self.mode = DYGuidePageModeVideoStaticImage;
        [self initVideoPlayer:frame videoUrl:videoURL mode:MPMovieRepeatModeNone];
    }
    return self;
}
@end
