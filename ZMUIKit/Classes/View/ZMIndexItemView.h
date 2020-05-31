//
//  SASectionIndexItemView.h
//  SAKitDemo
//
//  Created by 王士昌 on 2017/6/15.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMIndexItemView : UIView

/**
 记录table中所对应的区索引
 */
@property (nonatomic, assign) NSInteger section;

/**
 titleLabel的默认属性：具体需求在itemViewForComponent代理方法里设置
 backgroundColor：clearColor
 textColor：color1
 highlightedTextColor：blackColor
 textAlignment：center
 font：s9,b3
 shadowColor：whiteColor
 shadowOffset：CGSizeMake(0, 1)
 */
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;


@end
