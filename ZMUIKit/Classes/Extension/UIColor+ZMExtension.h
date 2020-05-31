//
//  UIColor+Extension.h
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZMExtension)


/**
 16进制色值
 
 @param hexString 16进制色值字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;


/**
 浅主题色 #30BDFF

 @return #30BDFF
 */
+ (UIColor *)colorC0;

/**
 主题色 #00A2EA
 
 @return #00A2EA
 */
+ (UIColor *)colorC1;


/**
 黄色 #FFBD20
 
 @return #FFBD20
 */
+ (UIColor *)colorC2;

/**
 白色 FFFFFF
 
 @return #FFFFFF
 */
+ (UIColor *)colorC3;

/**
 字体颜色 181818
 
 @return #181818
 */
+ (UIColor *)colorC4;

/**
 字体颜色 282828
 
 @return #282828
 */
+ (UIColor *)colorC5;

/**
 字体颜色 9b9b9b
 
 @return #9b9b9b
 */
+ (UIColor *)colorC6;

/**
 线条 E7E7E7
 
 @return #E7E7E7
 */
+ (UIColor *)colorC7;

/**
 tableView plain background color F8F8F8
 
 @return #F8F8F8
 */
+ (UIColor *)plainTableViewBackgroundColor;

/**
 cell 线条颜色 F2F2F2
 
 @return 线条颜色
 */
+ (UIColor *)colorC9;

/**
 红色1 FF0A0A
 
 @return #FF0A0A
 */
+ (UIColor *)colorC10;

/**
 红色2 FF5252
 
 @return #FF5252
 */
+ (UIColor *)colorC11;

/**
 16进制色值 686868
 
 @return #686868
 */
+ (UIColor *)color12 ;

#pragma mark --> 🐷 蓝色--Blue 🐷

/**
 蓝色 28a1ff
 
 @return #28a1ff
 */
+ (UIColor *)colorBlue1;

/**
 蓝色 2291F0
 
 @return #2291F0
 */
+ (UIColor *)colorBlue2;

/**
 蓝色 248BFF
 
 @return #248BFF
 */
+ (UIColor *)colorBlue3;

/**
 蓝色 B2E3F9

 @return #B2E3F9
 */
+ (UIColor *)colorBlue4;

/// 蓝色 #00A2EA
+ (UIColor *)colorBlue5;

/// 蓝色 #29def2
+ (UIColor *)colorBlue6;

/// 蓝色 #254dd7
+ (UIColor *)colorBlue7;
///蓝色 #BEE2FF
+ (UIColor *)colorBlue8;
#pragma mark --> 🐷 红色--Red 🐷

/**
 红色 F10215
 
 @return #F10215
 */
+ (UIColor *)colorRed1;


/**
 红色 F22424
 
 @return #F22424
 */
+ (UIColor *)colorRed2;

/// 红色 #F45945
+ (UIColor *)colorRed3;

/// 红色 #FF3855
+ (UIColor *)colorRed4;

/// 红色 #CC3535
+ (UIColor *)colorRed5;

/// 红色 #FE5030
+ (UIColor *) colorRed6;

/// 红色 #FF6442
+ (UIColor *) colorRed7;

/// 红色 D0392A
+ (UIColor *) colorRed8;

#pragma mark --> 🐷 灰色--Gray 🐷

/**
 灰色 EEEEEE
 
 @return #EEEEEE
 */
+ (UIColor *)colorGray1;

/**
 灰色 D3D3D3
 
 @return #D3D3D3
 */
+ (UIColor *)colorGray2;

/**
 灰色 CCCCCC
 
 @return #CCCCCC
 */
+ (UIColor *)colorGray3;

/**
 灰色 B1B1B1
 
 @return #B1B1B1
 */
+ (UIColor *)colorGray4;

/**
 灰色 F1F1F1

 @return #F1F1F1
 */
+ (UIColor *)colorGray5;

/**
 灰色 F2F2F2

 @return #F2F2F2
 */
+ (UIColor *)colorGray6;

/**
 灰色 F8F8F8

 @return #F8F8F8
 */
+ (UIColor *)colorGray7;

/// 灰色 #DDDDDD
+ (UIColor *)colorGray8;

/// 灰色 #848484
+ (UIColor *)colorGray9;

/// 灰色 #8c8c8c
+ (UIColor *)colorGray10;

/// 灰色 #e4e4e4
+ (UIColor *)colorGray11;

/// 灰色 #A3A3A3
+ (UIColor *)colorGray12;

/// 灰色 c0c0c4
+ (UIColor *)colorGray13;
#pragma mark --> 🐷 褐色--Broewnness 🐷

/**
 褐色 926B0F
 
 @return #926B0F
 */
+ (UIColor *)colorBrownness1;

///  褐色 926B0Fr
+ (UIColor *)colorBrownness2 ;

#pragma mark --> 🐷 橙色--Orange 🐷

/**
 橙色 FF8608
 
 @return #FF8608
 */
+ (UIColor *)colorOrange1;

/**
 橙色 FF7E00

 @return #FF7E00
 */
+ (UIColor *)colorOrange2;

/// FE9102
+ (UIColor *)colorOrange3;
#pragma mark --> 🐷 黄色--Yellow 🐷

/**
 黄色 FFDE00

 @return #FFDE00
 */
+ (UIColor *)colorYellow1;

/**
 黄色 FEA629

 @return #FEA629
 */
+ (UIColor *)colorYellow2;

/// 黄色 FAEC51
+ (UIColor *)colorYellow3;

/// 黄色FFAF00
+ (UIColor *)colorYellow5;

/// FECF05
+ (UIColor *)colorYellow6;

/// FCA202
+ (UIColor *)colorYellow7;
#pragma mark --> 🐷 绿色--Green 🐷

/// FFDD02
+ (UIColor *)colorYellow4;

/**
 绿色 21E397
 
 @return #21E397
 */
+ (UIColor *)colorGreen1;

/// 绿色 #1DAB91
+ (UIColor *)colorGreen2;

/// 绿色 #02D7B4
+ (UIColor *)colorGreen3;

/// 绿色 #02E6B4
+ (UIColor *)colorGreen4;

/// 绿色 #07C160
+ (UIColor *)colorGreen5;

/// 5FD0BF
+ (UIColor *)colorGreen6;

/// 70DBC9
+ (UIColor *)colorGreen7;

#pragma mark --> 🐷 紫色--purple 🐷

/**
 紫色 5826E9

 @return #5826E9
 */
+ (UIColor *)colorPurple1;

#pragma mark --> 🐷 咖啡色--Black 🐷

/**
 咖啡色

 @return #926B0F
 */
+ (UIColor *)colorBrown1;

#pragma mark --> 🐷 黑色--Black 🐷

/// 黑色 #000000
+ (UIColor *)colorBlack1;

/// 黑色 #484848
+ (UIColor *)colorBlack2;

/// 黑色 #373E48
+ (UIColor *)colorBlack3;

/// 黑色 #282828
+ (UIColor *)colorBlack4;

/// 黑色 #3c3c3c
+ (UIColor *)colorBlack5;

#pragma mark --> 🐷 白色--White 🐷

/// 白色 #F4F4F4
+ (UIColor *)colorWhite1;

/// 白色 #F7F7F7
+ (UIColor *)colorWhite2;
#pragma mark --> 🐷 粉色--Pink 🐷

/// 粉色 FFAEDF
+ (UIColor *)colorPink1;

/// 粉色 FFC7D4
+ (UIColor *)colorPink2;

/// 粉色 FEF2F2
+ (UIColor *)colorPink3;

#pragma mark --> 🐷 随机色 无透明通道 🐷

/**
 随机色 无透明通道

 @return 随机色
 */
+ (UIColor*)zm_randomColor;
@end

NS_ASSUME_NONNULL_END
