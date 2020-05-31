//
//  ZMKeyboardView.h
//  CustomKeyboard
//
//  Created by 德一智慧城市 on 2019/7/19.
//  Copyright © 2019 德一智慧城市. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZMKeyboardView;


typedef NS_ENUM(NSUInteger, DYKeyboardType) {
    /** 默认 */
    DYKeyboardTypeDefault,
    /** 纯数字 */
    DYKeyboardTypeNumber,
    /** 带小数点 */
    DYKeyboardTypeDecimal,
    /** 身份证号 */
    DYKeyboardTypeIDNumber,
};
NS_ASSUME_NONNULL_BEGIN



@protocol ZMKeyboardViewDelegate <NSObject>
@required

/**
 编辑

 @param board 自定义键盘
 @param string 编辑字符
 */
-(void)zm_keyboardView:(ZMKeyboardView * )board replacementString:(NSString *)string;

/**
 是否删除

 @param board 自定义键盘
 @return YES 删除 ，NO不删除
 */
- (BOOL)zm_shouldDelete:(ZMKeyboardView *)board;

/**
 清除

 @param board 自定义键盘
 @return YES 清除 ，NO不清除
 */
- (BOOL)zm_shouldClear:(ZMKeyboardView *)board;

@end

@interface ZMKeyboardView : UIView

/** 自定义键盘代理需设置为当前编辑控件 如UITextField 或UITextView ，方法无需主动实现，已经添加相应分类实现*/
@property(nonatomic,weak)id<ZMKeyboardViewDelegate>  delegate;

-(instancetype)initWithFrame:(CGRect)frame keyboardType:(DYKeyboardType)type;
@end

NS_ASSUME_NONNULL_END
