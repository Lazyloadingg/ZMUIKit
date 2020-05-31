//
//  ZMAnimation
//
//  Created by Mac2 on 2017/8/3.
//  Copyright © 2017年 圣光大人. All rights reserved.
//


/**
 * 使用时需在appdelegate中添加如下方法
     -(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
     return [[ZMScreenDirection shared]interfaceOrientationMask];
    }
 
 * 然后通过修改单例的 `screenDirection`属性改变屏幕方向
 * 注意，需要修改方向的界面在退出时一定要恢复进入时的方向，此方法修改的是全局的方向，如果不恢复，整个项目都会受到影响。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 切换屏幕方向类
 */
@interface ZMScreenDirection : NSObject

/** 屏幕方向 */
@property(nonatomic,assign)UIInterfaceOrientation screenDirection;

/**
 获取单例

 @return 实例
 */
+ (instancetype)shared;


/**
 获取当前方向

 @return 当前方向
 */
- (UIInterfaceOrientationMask)interfaceOrientationMask;

@end
