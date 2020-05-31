//
//  ZMImageEditorActionView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2020/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZMImageEditorActionViewProtocol;

@interface ZMImageEditorActionView : UIView

@property (nonatomic, weak) id <ZMImageEditorActionViewProtocol> delegate;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *originButton;
@property (nonatomic, strong) UIButton *finishButton;

- (void)maskViewShowWithDuration:(CGFloat)duration;
- (void)maskViewHideWithDuration:(CGFloat)duration;

@end

@protocol ZMImageEditorActionViewProtocol <NSObject>

@optional

- (void)actionView:(ZMImageEditorActionView *)actionView didClickButton:(UIButton *)button atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
