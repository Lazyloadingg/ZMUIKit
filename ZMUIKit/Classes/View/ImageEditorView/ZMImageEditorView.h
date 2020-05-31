//
//  ZMImageEditorView.h
//  ZMUIKit
//
//  Created by 王士昌 on 2020/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZMImageEditorViewProtocol;

@interface ZMImageEditorView : UIView

@property (nonatomic, weak) id <ZMImageEditorViewProtocol>delegate;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *preView;
@property (nonatomic, strong) UIView *lineWrap;

@property (nonatomic, strong) UIView *imageWrap;

@property (nonatomic, assign) CGSize previewSize;
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) BOOL maskViewAnimation;

- (instancetype)initWithMargin:(UIEdgeInsets)margin size:(CGSize)size;

- (void)maskViewShowWithDuration:(CGFloat)duration;
- (void)maskViewHideWithDuration:(CGFloat)duration;

@end

@protocol ZMImageEditorViewProtocol <NSObject>

@optional

- (void)editorView:(ZMImageEditorView *)editorView anchorPointIndex:(NSInteger)anchorPointIndex rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
