//
//  ZMTextField.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/11.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZMTextFieldType) {
    
    ZMTextFieldTypeNomal = 0,
    ZMTextFieldTypeNumber,           //数字 带小数点
    ZMTextFieldTypeNumberOrLetter,   //数字和字母
    ZMTextFieldTypeEmail,            //数字 字母 和 特定字符( '.'  '@')
    ZMTextFieldTypePassword,         //数字 字母 下划线
    ZMTextFieldTypeNum,                //纯数字
    ZMTextFieldTypeIDNumber,                //身份证
};

typedef NS_OPTIONS(NSUInteger, DYMenuItemType) {
    /** 复制 */
    DYMenuItemTypeCopy   = 1 << 0,
    /** 剪切 */
    DYMenuItemTypeCut  = 1 << 1,
    /** 粘贴 */
    DYMenuItemTypePaste    = 1 << 2,
    /** 选中 */
    DYMenuItemTypeSelect = 1 << 3,
    /** 全选 */
    DYMenuItemTypeSelectAll = 1 << 4,
    /** 删除 */
    DYMenuItemTypeDelete = 1 << 5,
    /** 常用按钮全部展示 */
    DYMenuItemTypeAll    = 1 << 6,
};



@protocol ZMTextFieldDelegate <NSObject>

//为了防止 self.delegate = self 然后外部有重写了这个delegate方法导致代理失效的问题，这里重写一遍系统的代理方法
//在使用ZMTextField的使用请不要使用UITextField本身代理方法
//   ----这里只是拓展了textField的部分代理，如果有需要还可以自己实现在这里添加

@optional

/**
 键盘return键点击调用
 
 @param textField ZMTextField
 */
-(BOOL)limitedTextFieldShouldReturn:(UITextField *)textField;

/**
 输入开始

 @param textField ZMTextField
 */
-(void)limitedTextFieldDidBeginEditing:(UITextField *)textField;
/**
 输入结束调用
 
 @param textField ZMTextField
 */
-(void)limitedTextFieldDidEndEditing:(UITextField *)textField;

/**
 输入内容改变调用(实时变化)
 
 @param textField ZMTextField
 */
-(void)limitedTextFieldDidChange:(UITextField *)textField;

/**
 是否可编辑

 @param textField ZMTextField
 @return return NO to disallow editing
 */
- (BOOL)limitTextFieldShouldBeginEditing:(UITextField *)textField;

/**
  return NO to not change text
 */
- (BOOL)limitedTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
@interface ZMTextField : UITextField

/**
 代理方法 尽量使用这个代理而不是用textfield的代理
 */
@property(nonatomic,weak)id<ZMTextFieldDelegate>  realDelegate;

/**
 ZMTextFieldType 根据type值不同 给出不同limited 默认ZMTextFieldTypeNomal
 */
@property (nonatomic,assign) ZMTextFieldType limitedType;

/**
DYMenuItemType 长按菜单常用按钮控制 默认不展示
*/
@property(nonatomic,assign)DYMenuItemType zm_menuItemType;
/**
 TYTextField内容发生改变block回调
 */
@property (nonatomic, copy) void (^textFieldDidChange)(NSString *text);

/**
 textField允许输入的最大长度 默认 0不限制
 */
@property (nonatomic,assign) NSInteger maxLength;

/**
 距离左边的间距  默认10
 */
@property (nonatomic,assign) CGFloat leftPadding;

/// 清除按钮距右侧位置
@property (nonatomic, assign) CGFloat cleanRightPadding;


/**
 距离右边的间距 默认 10
 */
@property (nonatomic,assign) CGFloat rightPadding;

/**
 给placeHolder设置颜色 需在placeholder赋值后进行设置
 */
@property (nonatomic,strong) UIColor *placeholderColor;

/**
 给placeHolder设置字体
 */
@property (nonatomic,strong) UIFont *placeholderFont;

/**
 textField -> leftView
 */
@property (nonatomic,strong) UIView *customLeftView;

/**
 textField -> rightView
 */
@property (nonatomic,strong) UIView *customRightView;


/**
 小数点位数
 */
@property (nonatomic,assign) NSInteger decimalPoint;

/**
 是否显示底部线条
 */
@property(nonatomic,assign)BOOL isBottomLine;

/**
 底部线条颜色
 */
@property(nonatomic,strong)UIColor * bottomLineColor;
@end

