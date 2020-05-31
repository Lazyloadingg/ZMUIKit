//
//  ZMIconBadgeLabel.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 标签背景色,默认值是红色

 - DYIconBadgeColorStyleRed: 红色
 - DYIconBadgeColorStyleBlue: 蓝色
 */
typedef NS_ENUM(NSInteger, DYIconBadgeColorStyle) {
    DYIconBadgeColorStyleRed,
    DYIconBadgeColorStyleBlue
};


/**
 标签内容类型

 - DYIconBadgeMaxType99: 两位数99为上限（超过99则显示99+）
 - DYIconBadgeMaxType999: 三位数999为上限（超过999则显示999+）
 - DYIconBadgeMaxTypeNew: new标签
 */
typedef NS_ENUM(NSInteger, DYIconBadgeMaxType) {
    DYIconBadgeMaxType99,
    DYIconBadgeMaxType999,
    DYIconBadgeMaxTypeNew
};

@interface ZMIconBadgeLabel : UILabel

@property (nonatomic, assign) DYIconBadgeColorStyle colorStyle;

@property (nonatomic, assign) DYIconBadgeMaxType maxType;

@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
