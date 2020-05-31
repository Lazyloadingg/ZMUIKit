//
//  ZMNumberStepper.h
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 加减器加减类型

 - ZMNumberStepperKeyBoardTypeInt: int
 - ZMNumberStepperKeyBoardTypeFloat: float
 */
typedef NS_ENUM(NSUInteger, ZMNumberStepperKeyBoardType) {
    ZMNumberStepperKeyBoardTypeInt,
    ZMNumberStepperKeyBoardTypeFloat,
};

/**
 加减器外观

 - SANumberStepperTypeNormal: normal
 */
typedef NS_ENUM(NSInteger, ZMNumberStepperType) {
    ZMNumberStepperTypeNormal,
    ZMNumberStepperTypeSymbol //金额前面带有符号
};

/**
 数字加减器
 */
@protocol ZMNumberStepperDelegate;
@interface ZMNumberStepper : UIView

@property (nonatomic, strong, readonly) UITextField *countTextField;

/*! 数字加减器的当前值 */
@property (nonatomic, assign) double value;

/*! 可设置的最大数值 默认10 */
@property (nonatomic, assign) double maxValue;

/*! 可设置最小数值 默认0 */
@property (nonatomic, assign) double minValue;

/*! 每次加减的幅度 默认1 */
@property (nonatomic, assign) double stepValue;

/*! 键盘类型 */
@property(nonatomic) UIKeyboardType keyboardType;

/*! 代理 */
@property (nonatomic, assign) id <ZMNumberStepperDelegate>delegate;

/*! 默认整数类型 */
@property (nonatomic, assign) ZMNumberStepperKeyBoardType keyBoardType;

/*! 数字加减器是否可用，默认yes */
@property (nonatomic, assign) BOOL enable;
/** 加 */
@property (nonatomic, strong) UIButton *addButton;
/** 减 */
@property (nonatomic, strong) UIButton *reduceButton;

- (instancetype)initWithStepperType:(ZMNumberStepperType)type NS_DESIGNATED_INITIALIZER;

/**
 带有符号的初始化方法
 
 @param color 颜色
 @param symbol 符号名称
 @param numBtnWidth 加减按钮宽度
 */
-(instancetype) initWithSymoblWithTextBgColor:(UIColor *) color symbol:(NSString *) symbol numBtnWidth:(float) numBtnWidth;

/**
 更改背景颜色
 
 @param addColor 加号按钮颜色
 @param addFont 加号按钮字体
 @param reduceColor 减号按钮颜色
 @param reduceFont 减号按钮字体
 */
-(void) setAddBtnTitleColor:(UIColor *) addColor addBtnFont:(UIFont *) addFont reduceTitleColor:(UIColor *) reduceColor reduceBtnFont:(UIFont *) reduceFont;

/**
 更改数字文本样式

 @param numColor 颜色
 @param font 字体
 */
-(void) setNumColor:(UIColor *) numColor font:(UIFont *) font;

/**
 修改背景颜色

 @param color 背景颜色
 */
-(void) setNumBackgroundColor:(UIColor *) color;
@end






@protocol ZMNumberStepperDelegate <NSObject>

- (void)numberStepperDidEndEditing:(ZMNumberStepper *)stepper;

@end

NS_ASSUME_NONNULL_END
