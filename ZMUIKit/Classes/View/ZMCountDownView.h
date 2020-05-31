//
//  ZMCountDownView.h
//  AFNetworking
//
//  Created by 德一智慧城市 on 2019/11/27.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DYCountDownType) {
    DYCountDownTypeText = 0,
    DYCountDownTypeNumber
};

typedef void(^countDownBlock)(void);

NS_ASSUME_NONNULL_BEGIN


/// 秒杀倒计时
@interface ZMCountDownView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     WithType:(DYCountDownType)type;
- (instancetype)initWithFrame:(CGRect)frame labelWidth:(CGFloat)width
                     WithType:(DYCountDownType)type;

//设置背景色，文字颜色，圆角
- (void)setBackgroundColor:(UIColor *)backgroundColor
                 TextColor:(UIColor *)color
                    radiuo:(CGFloat)rad;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, retain) UILabel *textTimerLabel;
@property (nonatomic, copy) countDownBlock timeOverBlock;


/// 设置结束时间
/// @param endTime 结束时间Unix时间戳
- (void)setEndTime:(NSString *)endTime;

/// 开始
/// @param timeout 开始
- (void)startDown:(int)timeout;


/// 结束
- (void)stopDown;
@end

NS_ASSUME_NONNULL_END
