//
//  ZMSheet.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZMPopupViewController.h"
#import "ZMPopupControllerProtocol.h"
#import "ZMUIKit.h"
//#import "ZMSheetAlertController.h"
#import "ZMAlertSheetAction.h"


//#import "ZMSheetAlertCustomerViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ZMSheetActionBlock)(id <ZMPopupControllerProtocol>obj,NSIndexPath *indexPath);

@interface ZMSheet : NSObject
@property(nonatomic,copy) dispatch_block_t dismissBlock;//ZMSheetAlertController 消失响应
@property(nonatomic,strong) dispatch_block_t disappear;
/*! 状态栏样式  */
@property (nonatomic) UIStatusBarStyle statusBarStyle;

#pragma mark -
#pragma mark --> 🐷  ZMSheet 方法🐷

/// 包含title message构造方法，标题，提示样式为默认 （如果需要添加自定义UI的标题和提示，不建议用此方法）
/// @param title 标题
/// @param message 提示内容
+ (ZMSheet * )sheetAlertWithTitle:(nullable NSString *)title message:(nullable NSString *) message;

/// 添加action
/// @param sheetAction sheetAction
- (void)addAction:(ZMAlertSheetAction *)sheetAction;

/// 添加标题
/// @param label label
- (void)addTitle:(void(^)(UILabel *label))label;

/// 添加提示
/// @param label label
- (void)addContent:(void(^)(UILabel *label))label;

- (void)addCustomView:(UIView *)customView;

/// 展示
- (void)sheetShow;

@end

@interface ZMSheetConfig : NSObject

@end

NS_ASSUME_NONNULL_END
