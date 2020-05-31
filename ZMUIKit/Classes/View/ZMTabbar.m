//
//  ZMTabbar.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/10/18.
//

#import "ZMTabbar.h"

@implementation ZMTabbar

-(CGSize)sizeThatFits:(CGSize)size{

    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height= sizeThatFits.height + 7;
    return sizeThatFits;

}

@end
