//
//  DYAuthCodeInputView.h
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/13.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DYAuthCodeInputStyle) {
    
    /**下划线*/
    DYAuthCodeInputStyleLine,
    
    /**方框*/
    DYAuthCodeInputStyleBox
};

typedef NS_ENUM(NSUInteger, DYAuthCodeInputType) {
    
    /**四个框*/
    DYAuthCodeInputTypeFour,
    
    /**六个框*/
    DYAuthCodeInputTypeSix
};
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectCodeBlock)(NSString *);
typedef void(^editChangeBlock)(NSString *);
typedef void(^editCompletionBlock)(NSString *);

/**
 验证码textView
 */
@interface DYAuthCodeTextView : UITextField

@end


/**
 自定义验证码输入框
 */
@interface DYAuthCodeInputView : UIView

@property(nonatomic,copy)editChangeBlock changeBlock;
@property(nonatomic,copy)editCompletionBlock completionBlock;
@property(nonatomic,strong,readonly)DYAuthCodeTextView * textView;
/** 每个输入框左右间距 */
@property (nonatomic, assign) CGFloat inputSpace;
/** 输入框字体 */
@property (nonatomic, strong) UIFont * font;
/** 编辑完成自动隐藏键盘 默认YES 隐藏 */
@property(nonatomic,assign)BOOL automaticHideKeyboard;
/**编辑状态样式颜色 */
@property(nonatomic,strong)UIColor * editingStyleColor;
/**默认状态样式颜色 */
@property(nonatomic,strong)UIColor * defaultStyleColor;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 初始化方式
 
 @param frame frame
 @param type 输入框类型
 @return view
 */
-(instancetype)initWithFrame:(CGRect)frame type:(DYAuthCodeInputType)type style:(DYAuthCodeInputStyle)style NS_DESIGNATED_INITIALIZER;

/**
 唤起键盘
 */
-(void)showKeyboard;

/// 清空输入内容
-(void)clearContent;

@end



NS_ASSUME_NONNULL_END

