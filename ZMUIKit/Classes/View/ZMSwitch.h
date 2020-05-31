//
//  UITextSwitch.h
//  TextSwitch
//
//  Created by Vasily Popov on 8/10/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface DYSwitch : UIControl

@property (nonatomic, readonly) IBInspectable BOOL isOn;
@property (nonatomic, strong) IBInspectable NSString *offText;
@property (nonatomic, strong) IBInspectable NSString *onText;
@property (nonatomic, strong) IBInspectable UIColor *offColor;
@property (nonatomic, strong) IBInspectable UIColor *onColor;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *backgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *off_borderColor;  //选中边框颜色
@property (nonatomic, strong) IBInspectable UIColor *off_backgroundColor; //选中背景颜色
@property (nonatomic, strong) IBInspectable UIColor *on_borderColor;  //选中边框颜色
@property (nonatomic, strong) IBInspectable UIColor *on_backgroundColor; //选中背景颜色
@property (nonatomic, assign) float textOffX;//开关 关 文字 居左距离
@property (nonatomic, assign) float textOnX;//开关 开 文字 居左距离
@property (nonatomic, assign) float fontSize;//字体大小
@property (nonatomic) IBInspectable NSInteger borderWidth; //边框宽度
/// 设置开关是否开与关
/// @param on 开yes与关no
/// @param animated 是否有动画效果和震动特效 YES 是 NO 否
- (void)setOn:(BOOL)on animated:(BOOL)animated;

/// 初始化方法
/// @param frame frame
/// @param fontSize 字体大小
-(instancetype)initWithFrame:(CGRect)frame  fontSize:(float) fontSize;

@end
