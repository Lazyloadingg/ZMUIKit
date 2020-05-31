//
//  CALayer+ZMExtension.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/8.
//

#import "CALayer+ZMExtension.h"

@implementation CALayer (ZMExtension)

+ (CAGradientLayer *)zm_colors:(NSArray <UIColor *>*)colors isVertical:(BOOL)vertical {
    __block NSMutableArray *colorsArr = [[NSMutableArray alloc]init];
    __block NSMutableArray *locations = [[NSMutableArray alloc]init];
    __block CGFloat value;
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colorsArr addObject:(__bridge id)obj.CGColor];
        value += 1.0f/colors.count;
        if (idx == colors.count-1) {
            value = 1.0f;
        }
        [locations addObject:@(value)];
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colorsArr;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (vertical) {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    }else {
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    
    return gradientLayer;
}

@end
