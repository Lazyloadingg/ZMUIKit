//
//  UIFont+ZMExtension.h
//  Aspects
//
//  Created by 王士昌 on 2019/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 字体类型

 - DYFontBoldTypeB3: 比加粗更粗
 - DYFontBoldTypeThin: 钎细体
 - DYFontBoldTypeRegular: 常规字体
 - DYFontBoldTypeBold: 常规加粗
 - DYFontBoldTypeLight: 细体
 - DYFontBoldTypeMedium: 中等
 - DYFontBoldTypeNumberBold: 数字字体
 */
typedef NS_ENUM(NSInteger, DYFontBoldType){
    DYFontBoldTypeB3,
    DYFontBoldTypeThin,
    DYFontBoldTypeRegular,
    DYFontBoldTypeBold,
    DYFontBoldTypeLight,
    DYFontBoldTypeMedium,
    DYFontBoldTypeNumberBold
};

@interface UIFont (ZMExtension)

+ (UIFont *)zm_font60pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font59pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font58pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font57pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font56pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font55pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font54pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font53pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font52pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font51pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font50pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font49pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font48pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font47pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font46pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font45pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font44pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font43pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font42pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font41pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font40pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font39pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font38pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font37pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font36pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font35pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font34pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font33pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font32pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font31pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font30pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font29pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font28pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font27pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font26pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font25pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font24pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font23pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font22pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font21pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font20pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font19pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font18pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font17pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font16pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font15pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font14pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font13pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font12pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font11pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font10pt:(DYFontBoldType)fontType;

+ (UIFont *)zm_font9pt:(DYFontBoldType)fontType;

+ (UIFont *)fontWithBoldType:(DYFontBoldType)boldType size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
