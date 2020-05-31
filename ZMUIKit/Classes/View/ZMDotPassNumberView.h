//
//  ZMDotPassNumberView.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/16.
//

#import <UIKit/UIKit.h>
//#import <ZMUIKit/ZMUIKit.h>
#import <ZMUIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZMDotPassNumberView : UIView

/**
 编辑结束
 */
@property(nonatomic,copy)void(^editCompletion)(NSString * text);

/**
 编辑
 */
@property(nonatomic,copy)void(^editDidChange)(NSString * text);

/**
 分割线颜色
 */
@property(nonatomic,strong)UIColor * lineColor;

@property(nonatomic,assign)ZMTextFieldType keyboardType;

/**输入框*/
@property (nonatomic, strong) ZMTextField * textField;
/**
 清空内容
 */
- (void)clearContent;

/**
 收起键盘
 */
-(void)hideKeyboard;

/**
 唤起键盘
 */
-(void)showKeyboard;

@end

NS_ASSUME_NONNULL_END
