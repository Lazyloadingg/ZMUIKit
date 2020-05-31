//
//  ZMDownMenuView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 弹出下拉菜单
 */
@interface ZMDownMenuView : UIView

- (instancetype)initWithFromView:(UIView *)view atController:(UIViewController *)controller;

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, assign) CGFloat contentHight;

@property (nonatomic, copy) dispatch_block_t didTapMaskBlock;

@property (nonatomic, copy) void(^didTapEventMaskBlock)(UIView * view);
- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
