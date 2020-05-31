//
//  ZMAlertSheetAction.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/12/2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DYActionStyle) {
    /** 默认 */
    DYActionStyleDefault,
    /** 取消 */
    DYActionStyleCancel,
    /** 销毁 */
    DYActionStyleDestructive
};
typedef NS_OPTIONS(NSInteger, DYActionBorderPosition) {
    /** Action边框位置 上 */
    DYActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    DYActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    DYActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    DYActionBorderPositionRight    = 1 << 3
};
NS_ASSUME_NONNULL_BEGIN

@interface ZMAlertSheetAction : NSObject

/** action类型 */
@property (nonatomic , assign ) DYActionStyle type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic , strong ) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) DYActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^ _Nullable clickBlock)(void);

/// 默认样式构造方法(提供默认颜色字体，如需自定义不建议用此方法)
/// @param title title
/// @param style style 
/// @param handler handler
+(ZMAlertSheetAction *)actionWithTitle:(NSString *)title style:(DYActionStyle)style handler:(void(^)(ZMAlertSheetAction * action))handler;

@end

NS_ASSUME_NONNULL_END
