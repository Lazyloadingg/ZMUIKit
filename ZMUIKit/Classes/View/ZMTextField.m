//
//  ZMTextField.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/11.
//

#import "ZMTextField.h"
#import <ZMUIKit/ZMUIKit.h>


//字母+数字
#define kLetterNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kEmail      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"
#define kPassword   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_./<>()',|!@#¥$%&*~[]{}^+=\\?!€£•:;-“ \""
#define kIDNumberFilter  @"1234567890Xx"

@interface ZMTextField () <UITextFieldDelegate>

//筛选条件
@property (nonatomic,copy) NSString *filter;
@property (nonatomic,assign) BOOL isHaveDian;
@property (nonatomic,strong) CALayer * bottomLineLayer;

@end

@implementation ZMTextField


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialize];
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if ((self.zm_menuItemType & DYMenuItemTypeCut) && action==@selector(cut:) ) {
        return YES;
    }
    
    if ((self.zm_menuItemType & DYMenuItemTypeCopy) && action==@selector(copy:) ) {
        return YES;
    }
    
    if ((self.zm_menuItemType & DYMenuItemTypePaste) && action==@selector(paste:) ) {
        return YES;
    }
    
    if ((self.zm_menuItemType & DYMenuItemTypeSelectAll) && action==@selector(selectAll:) ) {
        return YES;
    }
    
    if ((self.zm_menuItemType & DYMenuItemTypeSelect) && action==@selector(select:) ) {
        return YES;
    }
    
    if ((self.zm_menuItemType & DYMenuItemTypeDelete) && action==@selector(delete:) ) {
        return YES;
    }
    
    if (
        (self.zm_menuItemType & DYMenuItemTypeAll) &&
        (action==@selector(delete:) ||
         action==@selector(select:) ||
         action==@selector(selectAll:) ||
         action==@selector(paste:) ||
         action==@selector(copy:) ||
         action==@selector(cut:))
        )
    {
        return YES;
    }
    
    return NO;
}
-(void)initialize{
    
    //设置默认值
    self.rightPadding = 10;
    self.leftPadding = 10;
    self.limitedType = ZMTextFieldTypeNomal;
    self.textAlignment = NSTextAlignmentLeft;
    self.decimalPoint = 4;
    
    //设置边框和颜色
    self.layer.cornerRadius = 5;
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.font = [UIFont systemFontOfSize:14];
    
    //设置代理 这里delegate = self 外面就不可以在使用textField的delegate 否则这个代理将会失效
    self.delegate = self;
    
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
#pragma mark --> 🐷 Private Method 🐷
//重写方法 设置placeholder位置
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(5, 0 , self.bounds.size.width-5, self.bounds.size.height)];
}
- (BOOL)isChinese:(NSString *)string{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}
#pragma mark --> 🐷 TextField Delegate 🐷

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldReturn:)]) {
        return [_realDelegate limitedTextFieldShouldReturn:textField];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidBeginEditing:)]) {
        [_realDelegate limitedTextFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidEndEditing:)]) {
        [_realDelegate limitedTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_limitedType == ZMTextFieldTypeNumber) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            _isHaveDian = NO;
        }
        if ([string length] > 0)
        {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length] == 0)
                {
                    if(single == '.')
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.')
                {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= self.decimalPoint) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    
    //解决系统输入法高亮文字造成的问题
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //有高亮文字
    if (!position) {
        if ((textField.text.length + string.length > self.maxLength) && ![string isEqualToString:@""] && self.maxLength) {
            return NO;
        }
    }else{
        //无高亮文字
        if ((textField.text.length >= self.maxLength) && ![string isEqualToString:@""] && self.maxLength) {
            NSString * selectedString = [self textInRange:selectedRange];
            if ([self isChinese:string]) {
                if (((textField.text.length - selectedString.length + string.length) < self.maxLength)) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    
    if ((textField.text.length  >= self.maxLength) && ![string isEqualToString:@""] && self.maxLength) {
        return NO;
    }
    
    if (!self.filter) {
        return YES;
    }
    
    //限制条件
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:self.filter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    return  [string isEqualToString:filtered];
}
//textField内容有变化会调用这个方法
-(void)textFieldEditChanged:(ZMTextField *)textField{
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    
    //设置了最大长度限制
    if (_maxLength > 0) {
        //当前为中文
        if ([lang isEqualToString:@"zh-Hans"]){
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文/emoj被截断
            if (!position){
                //文本内容长度大于最大限制
                if (textField.text.length > _maxLength){
                    NSRange rangeIndex = [textField.text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
                    if (rangeIndex.length == 1){
                        textField.text = [textField.text substringToIndex:_maxLength];
                    }else{
                        if(_maxLength == 1){
                            textField.text = @"";
                        }else{
                            NSRange rangeRange = [textField.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength - 1 )];
                            textField.text = [textField.text substringWithRange:rangeRange];
                        }
                    }
                }
            }else{
                //有高亮选择的字
                if (textField.text.length >= _maxLength) {
                    
                    textField.text = [textField.text substringToIndex:_maxLength];
                    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidChange:)]) {
                        [_realDelegate limitedTextFieldDidChange:self];
                    }
                    if(self.textFieldDidChange){
                        self.textFieldDidChange(textField.text);
                    }
                    
                    return;
                }
            }
        }else{
            if (textField.text.length > _maxLength) {
                textField.text = [textField.text substringToIndex:_maxLength];
            }
        }
    }
    
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidChange:)]) {
        [_realDelegate limitedTextFieldDidChange:self];
    }
    if(self.textFieldDidChange){
        self.textFieldDidChange(textField.text);
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitTextFieldShouldBeginEditing:)]) {
        return [_realDelegate limitTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

#pragma mark --> 🐷  Setter/Getter 🐷

-(void)setLimitedType:(ZMTextFieldType)limitedType{
    _limitedType = limitedType;
    
    //根据Type选择键盘
    if (limitedType == ZMTextFieldTypeNomal) {
        self.keyboardType = UIKeyboardTypeDefault;
        self.filter = nil;
    }else{  //限制输入这里使用自定义键盘
        self.keyboardType = UIKeyboardTypeASCIICapable;
        if (limitedType == ZMTextFieldTypeNumber) {  //数字
            self.keyboardType = UIKeyboardTypeDecimalPad;
            self.filter = nil;
        }else if(limitedType == ZMTextFieldTypeNumberOrLetter){  //数字和字母
            self.filter = kLetterNum;
        }else if(limitedType == ZMTextFieldTypeEmail){  //email
            self.keyboardType = UIKeyboardTypeEmailAddress;
            self.filter = kEmail;
        }else if(limitedType == ZMTextFieldTypePassword){ //密码 数字 字母 下划线组成
            self.filter = kPassword;
        }else if (limitedType == ZMTextFieldTypeNum){
            self.keyboardType =  UIKeyboardTypeNumberPad;
        }else if (limitedType == ZMTextFieldTypeIDNumber){
            self.filter = kIDNumberFilter;
        }
    }
}

-(void)setLeftPadding:(CGFloat)leftPadding{
    _leftPadding = leftPadding;
    [self setValue:@(leftPadding) forKey:@"paddingLeft"];
}

-(void)setRightPadding:(CGFloat)rightPadding{
    _rightPadding = rightPadding;
    [self setValue:@(rightPadding) forKey:@"paddingRight"];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self configPlaceholder];
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    [self configPlaceholder];
}
-(void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    if (!placeholder) {
        return;
    }
    [self configPlaceholder];
}
-(void)configPlaceholder{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder?:@"" attributes:@{NSFontAttributeName:_placeholderFont?:self.font,NSForegroundColorAttributeName:_placeholderColor?:[UIColor colorGray3]}];
}
- (void)setMaxLength:(NSInteger)maxLength{
    _maxLength = maxLength;
}

-(void)setCustomLeftView:(UIView *)customLeftView{
    _customLeftView = customLeftView;
    self.leftView = customLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setCustomRightView:(UIView *)customRightView{
    _customRightView = customRightView;
    self.rightView = customRightView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setDecimalPoint:(NSInteger)decimalPoint{
    _decimalPoint = decimalPoint;
}
-(void)setIsBottomLine:(BOOL)isBottomLine{
    
    if (_isBottomLine == isBottomLine) {
        return;
    }
    _isBottomLine = isBottomLine;
    
    self.bottomLineLayer.hidden = !_isBottomLine;
    [self.bottomLineLayer removeAllAnimations];
    CABasicAnimation * ani = [CABasicAnimation animation];
    if (_isBottomLine) {
        ani.fromValue = @(0.0);
        ani.toValue = @(1.0);
    }else{
        ani.fromValue = @(1.0);
        ani.toValue = @(0.0);
    }
    ani.duration = 0.25;
    ani.repeatCount = NO;
    ani.keyPath = @"opacity";
    [self.bottomLineLayer addAnimation:ani forKey:@"kOpacity"];
    
}
-(void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    self.bottomLineLayer.backgroundColor = _bottomLineColor.CGColor;
}
-(CALayer *)bottomLineLayer{
    if (!_bottomLineLayer) {
        _bottomLineLayer = [CALayer layer];
        _bottomLineLayer.hidden = YES;
        [self.layer addSublayer:_bottomLineLayer];
    }
    return _bottomLineLayer;
}
//iOS11之后placeholder设置偏移后placeholder位置没有变化
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    if (@available(iOS 11.0, *)) {
        //如果是左对齐 则+leftPadding
        //右对齐      则-rightPadding
        //中间对其    则pading设置为0
        CGFloat padding = 0;
        if(self.textAlignment == NSTextAlignmentRight){
            padding = -_rightPadding;
        }else if(self.textAlignment == NSTextAlignmentLeft){
            padding = _leftPadding;
        }
        if(self.customLeftView){
            padding += self.customLeftView.bounds.size.width;
        }
        CGRect rect = {{bounds.origin.x+padding,bounds.origin.y},bounds.size};
        return rect;
    }
    return  [super placeholderRectForBounds:bounds];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_bottomLineLayer) {
        _bottomLineLayer.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
    }
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
  
    if (self.cleanRightPadding == 0 || !self.cleanRightPadding) {
        return   [super clearButtonRectForBounds:bounds];
    }else{
        CGRect originFrame = [super clearButtonRectForBounds:bounds];
        CGRect frame = CGRectMake(originFrame.origin.x+originFrame.size.width - self.cleanRightPadding, originFrame.origin.y, originFrame.size.width, originFrame.size.height);
        return frame;
    }
}
@end
