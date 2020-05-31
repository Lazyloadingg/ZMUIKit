//
//  DYTableViewCell.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 tableViewCell选择样式
 
 - DYTableViewCellSelectionStyleNone: 非选择列表
 - DYTableViewCellSelectionStyleSingleSelection: 单选cell样式
 - DYTableViewCellSelectionStyleMultipleSelection: 多选cell样式
 */
typedef NS_ENUM(NSInteger, DYTableViewCellSelectionStyle) {
    DYTableViewCellSelectionStyleNone,
    DYTableViewCellSelectionStyleSingleSelection,
    DYTableViewCellSelectionStyleMultipleSelection,
};


/**
 tableViewCell高亮样式
 
 - DYTableViewCellHighlightStyleNone: 不高亮
 - DYTableViewCellHighlightStyleLightgray: 浅灰色的高亮
 */
typedef NS_ENUM(NSInteger, DYTableViewCellHighlightStyle) {
    DYTableViewCellHighlightStyleNone,
    DYTableViewCellHighlightStyleLightgray,
};



/**
 tableViewCell分割线样式
 
 - DYTableViewCellSeparatorStyleNone: 无分割线
 - DYTableViewCellSeparatorStyleSingleLine: 细线(左侧缩进15，右侧不缩进)
 - DYTableViewCellSeparatorStyleSingleAllLine: 左右都不缩进
 - DYTableViewCellSeparatorStyleSingleLineEqule: 左右各缩进15
 - DYTableViewCellSeparatorStyleSingleIconLine :左侧缩进48，右侧0
 - DYTableViewCellSeparatorStyleSingleIconLine43PX :左侧缩进43， 右侧0
 - DYTableViewCellSeparatorStyleSingleIconLine64PX :左侧缩进64， 右侧0
 - DYTableViewCellSeparatorStyleSingleIconLine155PX :左侧缩进145 右侧0
 - DYTableViewCellSeparatorStyleCustom :自定义类型 可设置zm_separatorInset
 */
typedef NS_ENUM(NSInteger, DYTableViewCellSeparatorStyle) {
    DYTableViewCellSeparatorStyleNone,
    DYTableViewCellSeparatorStyleSingleLine,
    DYTableViewCellSeparatorStyleSingleAllLine,
    DYTableViewCellSeparatorStyleSingleLineEqule,
    DYTableViewCellSeparatorStyleSingleIconLine,
    DYTableViewCellSeparatorStyleSingleIconLine43PX,
    DYTableViewCellSeparatorStyleSingleIconLine64PX,
    DYTableViewCellSeparatorStyleSingleIconLine155PX,
    DYTableViewCellSeparatorStyleCustom,
};


/**
 tableViewCell右侧辅助样式
 
 - DYTableViewCellAccessoryTypeNone: 无
 - DYTableViewCellAccessoryTypeDisclosureIndicator: 箭头
 */
typedef NS_ENUM(NSInteger, DYTableViewCellAccessoryType) {
    DYTableViewCellAccessoryTypeNone,
    DYTableViewCellAccessoryTypeDisclosureIndicator,
};



@interface DYTableViewCell : UITableViewCell

/**
 选择样式。默认无选择样式：DYTableViewCellSelectionStyleNone
 */
@property (nonatomic, assign) DYTableViewCellSelectionStyle zm_selectionStyle;

@property (nonatomic, assign) DYTableViewCellHighlightStyle zm_highlightStyle;

/**
 分割线样式。默认0.7像素的线条。
 @warning  注意section的最后一行cell的样式应该是DYTableViewCellSeparatorStyleNone
 */
@property (nonatomic, assign) DYTableViewCellSeparatorStyle zm_separatorStyle;

/*! dy分割线缩进设置,若设置则会把 zm_separatorStyle 更新为 DYTableViewCellSeparatorStyleCustom  */
@property (nonatomic) UIEdgeInsets zm_separatorInset;

/*! 分割线颜色  */
@property (nonatomic, strong) UIColor *zm_separatorColor;

@property (nonatomic, assign) DYTableViewCellAccessoryType zm_accessoryType;


/**
 建议在zm_accessoryType==DYTableViewCellAccessoryTypeNone时，设置此属性。
 若设置此zm_accessoryView之后，zm_accessoryType会强制变更为DYTableViewCellAccessoryTypeNone。
 需要设置zm_accessoryView的size（通过frame或bounds）。
 */
@property (nonatomic, strong) UIView *zm_accessoryView;




@end

NS_ASSUME_NONNULL_END
