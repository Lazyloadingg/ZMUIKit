//
//  ZMPopupControllerProtocol.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZMPopupControllerProtocol <NSObject>

/**
 弹出底部弹出视图
 
 @param fromController 弹出视图控制器的父控制器。当fromController有导航控制器时，将会被加到导航控制器上。
 */
- (void)showFromController:(UIViewController *)fromController;

/**
 弹出底部弹出视图
 
 @param fromController 弹出视图控制器的父控制器。当fromController有导航控制器时，将会被加到导航控制器上.
 @param animated 是否有弹出动画
 */
- (void)showFromController:(UIViewController *)fromController animated:(BOOL)animated;

/**
 隐藏弹出视图
 */
- (void)dismiss:(dispatch_block_t __nullable)compeletion;

/**
 隐藏弹出视图
 
 @param animated 是否有动画
 @param compeletion 隐藏成功的回调
 */
- (void)dismiss:(BOOL)animated compeletion:(dispatch_block_t __nullable)compeletion;

@end

NS_ASSUME_NONNULL_END
