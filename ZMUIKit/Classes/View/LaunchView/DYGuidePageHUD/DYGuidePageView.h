//
//  DHGuidePageHUD.h
//  DHGuidePageHUD
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 dingding3w. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOOLFORKEY @"dhGuidePage"

//引导页类型
typedef NS_ENUM(NSUInteger,DYGuidePageMode){
    DYGuidePageModeStaticImage, //只有静态图片
    DYGuidePageModeVideo, //只播放视频
    DYGuidePageModeVideoStaticImage//先视频后图片
};
@interface DYGuidePageView : UIView
/**
 *  是否支持滑动进入APP(默认为NO-不支持滑动进入APP | 只有在buttonIsHidden为YES-隐藏状态下可用; buttonIsHidden为NO-显示状态下直接点击按钮进入)
 *  新增视频引导页同样不支持滑动进入APP
 */
@property (nonatomic, assign) BOOL slideInto;
@property (nonatomic, assign) DYGuidePageMode mode;
@property (nonatomic, strong) NSArray *images;//图片列表
@property (nonatomic, copy) dispatch_block_t completeBlock;
@property (nonatomic, strong) UIPageControl  *imagePageControl;
/**
 *  DHGuidePageHUD(图片引导页 | 可自动识别动态图片和静态图片)
 *
 *  @param frame      位置大小
 *  @param imageNameArray 引导页图片数组(NSString)
 *  @param isHidden   开始体验按钮是否隐藏(YES:隐藏-引导页完成自动进入APP首页; NO:不隐藏-引导页完成点击开始体验按钮进入APP主页)
 *
 *  @return DHGuidePageHUD对象
 */
- (instancetype)zm_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden;
/**
 *  DHGuidePageHUD(视频引导页)
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return DHGuidePageHUD对象
 */
- (instancetype)zm_initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;

/**
 APP视频新特性页面(新增测试模块内容)

 @param frame 尺寸
 @param videoURL 视频地址
 @param list 图片列表
 */
- (instancetype)zm_initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL  Images:(NSArray *) list;
@end
