//
//  UIColor+Extension.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "UIColor+ZMExtension.h"

@implementation UIColor (ZMExtension)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
        }
            break;
            
        case 4: // #ARGB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
        }
            break;
            
        case 6: // #RRGGBB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
        }
            break;
            
        case 8: // #AARRGGBB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
        }
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger) length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


+ (UIColor *)colorC0 {
    return [self colorWithHexString:@"#30BDFF"];
}

+ (UIColor *)colorC1 {
    return [self colorWithHexString:@"#28a1ff"];
}

+ (UIColor *)colorC2 {
    return [self colorWithHexString:@"#FFBD20"];
}

+ (UIColor *)colorC3 {
    return [self colorWithHexString:@"#FFFFFF"];
}

+ (UIColor *)colorC4 {
    return [self colorWithHexString:@"#181818"];
}

+ (UIColor *)colorC5 {
    return [self colorWithHexString:@"#282828"];
}

+ (UIColor *)colorC6 {
    return [self colorWithHexString:@"#9b9b9b"];
}

+ (UIColor *)colorC7 {
    return [self colorWithHexString:@"#E7E7E7"];
}

+ (UIColor *)plainTableViewBackgroundColor {
    return [self colorWithHexString:@"#F6F6F6"];
}

+ (UIColor *)colorC9 {
    return [self colorWithHexString:@"#F2F2F2"];
}

+ (UIColor *)colorC10 {
    return [self colorWithHexString:@"#FF0A0A"];
}

+ (UIColor *)colorC11 {
    return [self colorWithHexString:@"#FF5252"];
}

+ (UIColor *)color12 {
    return [self colorWithHexString:@"#686868"];
}
#pragma mark --> 🐷 白色--White 🐷
+ (UIColor *)colorWhite1 {
    return [self colorWithHexString:@"#F4F4F4"];
}
+ (UIColor *)colorWhite2 {
    return [self colorWithHexString:@"#F7F7F7"];
}
#pragma mark --> 🐷 黑色--Black 🐷
+ (UIColor *)colorBlack1 {
    return [self colorWithHexString:@"#000000"];
}
+ (UIColor *)colorBlack2 {
    return [self colorWithHexString:@"#484848"];
}
+ (UIColor *)colorBlack3 {
    return [self colorWithHexString:@"#373E48"];
}
+ (UIColor *)colorBlack4 {
    return [self colorWithHexString:@"#282828"];
}
+ (UIColor *)colorBlack5 {
    return [self colorWithHexString:@"#3c3c3c"];
}
#pragma mark --> 🐷 蓝色--Blue 🐷
+ (UIColor *)colorBlue1 {
    return [self colorWithHexString:@"#28a1ff"];
}

+ (UIColor *)colorBlue2 {
    return [self colorWithHexString:@"#2291F0"];
}

+ (UIColor *)colorBlue3 {
    return [self colorWithHexString:@"#248BFF"];
}

+ (UIColor *)colorBlue4 {
    return [self colorWithHexString:@"#B2E3F9"];
}
+ (UIColor *)colorBlue5{
    return [self colorWithHexString:@"#00A2EA"];
}
+ (UIColor *)colorBlue6{
    return [self colorWithHexString:@"#29def2"];
}
+ (UIColor *)colorBlue7{
    return [self colorWithHexString:@"#254dd7"];
}
+ (UIColor *) colorBlue8{
    return [UIColor colorWithHexString:@"#BEE2FF"];
}
#pragma mark --> 🐷 红色--Red 🐷
+ (UIColor *)colorRed1{
    return [self colorWithHexString:@"#F10215"];
}
+ (UIColor *)colorRed2 {
    return [self colorWithHexString:@"#F22424"];
}
+ (UIColor *)colorRed3 {
    return [self colorWithHexString:@"#F45945"];
}
+ (UIColor *)colorRed4 {
    return [self colorWithHexString:@"#FF3855"];
}
+ (UIColor *)colorRed5 {
    return [self colorWithHexString:@"#CC3535"];
}
+ (UIColor *) colorRed6{
    return [self colorWithHexString:@"#FE5030"];
}
+ (UIColor *) colorRed7{
    return [self colorWithHexString:@"#FF6442"];
}
+ (UIColor *) colorRed8{
    return [self colorWithHexString:@"#D0392A"];
}

#pragma mark --> 🐷 灰色--Gray 🐷
+ (UIColor *)colorGray1 {
    return [self colorWithHexString:@"#EEEEEE"];
}
+ (UIColor *)colorGray2 {
    return [self colorWithHexString:@"#D3D3D3"];
}
+ (UIColor *)colorGray3 {
    return [self colorWithHexString:@"#CCCCCC"];
}
+ (UIColor *)colorGray4 {
    return [self colorWithHexString:@"#B1B1B1"];
}
+ (UIColor *)colorGray5 {
    return [self colorWithHexString:@"#F1F1F1"];
}
+ (UIColor *)colorGray6 {
    return [self colorWithHexString:@"#F2F2F2"];
}
+ (UIColor *)colorGray7 {
    return [self colorWithHexString:@"#F8F8F8"];
}
+ (UIColor *)colorGray8 {
    return [self colorWithHexString:@"#DDDDDD"];
}
+ (UIColor *)colorGray9 {
    return [self colorWithHexString:@"#848484"];
}
+ (UIColor *)colorGray10 {
    return [self colorWithHexString:@"#9b9b9b"];
}
+ (UIColor *)colorGray11 {
    return [self colorWithHexString:@"#e4e4e4"];
}
+ (UIColor *)colorGray12 {
    return [self colorWithHexString:@"#A3A3A3"];
}
+ (UIColor *)colorGray13 {
    return [self colorWithHexString:@"#c0c0c4"];
}
#pragma mark --> 🐷 褐色--Brownness 🐷
+ (UIColor *)colorBrownness1 {
    return [self colorWithHexString:@"#926B0F"];
}
+ (UIColor *)colorBrownness2 {
    return [self colorWithHexString:@"#A7886C"];
}

#pragma mark --> 🐷 橙色--Orange 🐷
+ (UIColor *)colorOrange1 {
    return [self colorWithHexString:@"#FF8608"];
}

+ (UIColor *)colorOrange2 {
    return [self colorWithHexString:@"#FF7E00"];
}

+ (UIColor *)colorOrange3 {
    return [self colorWithHexString:@"#FE9102"];
}

#pragma mark --> 🐷 黄色--Yellow 🐷
+ (UIColor *)colorYellow1 {
    return [self colorWithHexString:@"#FFDE00"];
}

+ (UIColor *)colorYellow2 {
    return [self colorWithHexString:@"#FEA629"];
}
+ (UIColor *)colorYellow3 {
    return [self colorWithHexString:@"#FAEC51"];
}
+ (UIColor *)colorYellow4 {
    return [self colorWithHexString:@"#FFDD02"];
}

+ (UIColor *)colorYellow5 {
    return [self colorWithHexString:@"#FFAF00"];
}
+ (UIColor *)colorYellow6 {
    return [self colorWithHexString:@"#FECF05"];
}
+ (UIColor *)colorYellow7 {
    return [self colorWithHexString:@"#FCA202"];
}

#pragma mark --> 🐷 绿色--Green 🐷
+ (UIColor *)colorGreen1 {
    return [self colorWithHexString:@"#21E397"];
}
+ (UIColor *)colorGreen2 {
    return [self colorWithHexString:@"#1DAB91"];
}
+ (UIColor *)colorGreen3 {
    return [self colorWithHexString:@"#02D7B4"];
}
+ (UIColor *)colorGreen4 {
    return [self colorWithHexString:@"#02E6B4"];
}
/// 绿色
+ (UIColor *)colorGreen5{
    return [self colorWithHexString:@"#07C160"];    
}
+ (UIColor *)colorGreen6{
    return [self colorWithHexString:@"#5FD0BF"];
}
+ (UIColor *)colorGreen7{
    return [self colorWithHexString:@"#70DBC9"];
}

#pragma mark --> 🐷 紫色--Purple 🐷
+ (UIColor *)colorPurple1 {
    return [self colorWithHexString:@"#5826E9"];
}

#pragma mark --> 🐷 咖啡色--Brown 🐷
+ (UIColor *)colorBrown1 {
    return [self colorWithHexString:@"#926B0F"];
}
#pragma mark --> 🐷 粉色--Pink 🐷
+ (UIColor *)colorPink1 {
    return [self colorWithHexString:@"#FFAEDF"];
}
+ (UIColor *)colorPink2{
    return [self colorWithHexString:@"#FFC7D4"];
}
+ (UIColor *)colorPink3 {
    return [self colorWithHexString:@"#FEF2F2"];
}

#pragma mark --> 🐷 随机色 无透明通道 🐷
+ (UIColor*)zm_randomColor{
    
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
//    NSInteger aAlphaValue = (arc4random() % 10) + 1;
    UIColor * randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0];
    return randColor;
    
}
@end
