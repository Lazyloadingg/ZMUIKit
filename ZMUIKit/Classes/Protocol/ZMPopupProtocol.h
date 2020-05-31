//
//  DYPopupProtocol.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 弹出 alert sheet 等协议
 */
@protocol DYPopupProtocol <NSObject>

- (void)show;

- (void)showAlertWithCompletion:(dispatch_block_t)completion;

- (void)dismiss;

- (void)dismissAlertWithCompletion:(dispatch_block_t)completion;


@end

NS_ASSUME_NONNULL_END
