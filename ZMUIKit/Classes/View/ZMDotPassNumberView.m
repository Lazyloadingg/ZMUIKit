//
//  ZMDotPassNumberView.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/16.
//

#import "ZMDotPassNumberView.h"
#import "ZMUtilities.h"
#import "ZMUIKit.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
#define kLineColor kColorByHex(@"#DDDDDD")

@interface ZMDotPassNumberView ()
<
ZMTextFieldDelegate
>

/**圆点*/
@property (nonatomic, strong) NSMutableArray <UIView *>*dotArray;
/**分割线*/
@property(nonatomic,strong) NSMutableArray <UIView *>* sepLineArray;
/**输入长度*/
@property(nonatomic,assign) NSInteger inputCount;

@end

@implementation ZMDotPassNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.inputCount = kDotCount;
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;
    
}
#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
-(void)hideKeyboard{
    [self.textField resignFirstResponder];
}
-(void)showKeyboard{
    [self.textField becomeFirstResponder];
}
- (void)clearContent{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}
#pragma mark >_<! 👉🏻 🐷Event Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > self.inputCount) {
        return;
    }
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    
    if (self.editDidChange) {
        self.editDidChange(textField.text);
    }
    
    if (textField.text.length == self.inputCount) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.editCompletion) {
                self.editCompletion(textField.text);
            }
        });
        ZMLog(@"输入完毕");
    }
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint point1 = [self convertPoint:point toView:self.textField];
    if (CGRectContainsPoint(self.textField.bounds, point1)) {
        return self.textField;
    }
    return [super hitTest:point withEvent:event];
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    
    self.textField.layer.borderColor = _lineColor.CGColor;
    [self.sepLineArray setValue:_lineColor forKey:@"backgroundColor"];
}
-(void)setKeyboardType:(ZMTextFieldType)keyboardType{
    _keyboardType = keyboardType;
     self.textField.limitedType = _keyboardType;
}
- (ZMTextField *)textField{
    if (!_textField) {
        _textField = [[ZMTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.realDelegate = self;
        _textField.isMenu = NO;
        
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = kLineColor.CGColor;
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(NSMutableArray *)dotArray{
    if (!_dotArray) {
        _dotArray = [NSMutableArray array];
    }
    return _dotArray;
}
-(NSMutableArray *)sepLineArray{
    if (!_sepLineArray) {
        _sepLineArray = [NSMutableArray array];
    }
    return _sepLineArray;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    
}
-(void)initSubViews{
    
    [self addSubview:self.textField];
    self.textField.maxLength = self.inputCount;
    
    //生成分割线
    for (int i = 0; i < self.inputCount - 1; i++) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        [self.sepLineArray addObject:lineView];
    }
    
    //生成占位的点
    for (int i = 0; i < self.inputCount; i++) {
     
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES;
        
        [self addSubview:dotView];
        [self.dotArray addObject:dotView];
    }
    
}
-(void)layout{
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / self.inputCount;
    //生成分割线
    for (int i = 0; i < self.sepLineArray.count; i++) {
        UIView *lineView = self.sepLineArray[i];
        lineView.frame  = CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 1, K_Field_Height);
        lineView.backgroundColor = kLineColor;
    }
    
    //生成占位的点
    for (int i = 0; i < self.dotArray.count; i++) {
        UIView *dotView  = self.dotArray[i];
        dotView.frame = CGRectMake(CGRectGetMinX(self.textField.frame) + (width - self.inputCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height);
    }
    
}

@end
