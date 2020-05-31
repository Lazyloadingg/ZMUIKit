//
//  ZMNumberStepper.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/19.
//

#import "ZMNumberStepper.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

@interface ZMNumberStepperTextField : UITextField

@end

@interface ZMNumberStepper ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backgroundView;
/** 符号 */
@property (nonatomic, strong) UILabel *symbolLbl;
@property (nonatomic, strong) ZMNumberStepperTextField *countTextField;

@property (nonatomic, assign) ZMNumberStepperType type;
@property (nonatomic,assign) float numBtnWidth;//加减按钮宽度
@end

@implementation ZMNumberStepper

#pragma mark -
#pragma mark - 👉 View Life Cycle 👈

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithStepperType:ZMNumberStepperTypeNormal];
}

- (instancetype)initWithStepperType:(ZMNumberStepperType)type{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupInitWithType:type];
        self.type = type;
    }
    return self;
}

- (instancetype)init{
    return [self initWithStepperType:ZMNumberStepperTypeNormal];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithStepperType:ZMNumberStepperTypeNormal];
}

/**
 带有符号的初始化方法
 
 @param color 颜色
 @param symbol 符号名称
 @param numBtnWidth 加减按钮宽度
 */
-(instancetype) initWithSymoblWithTextBgColor:(UIColor *) color symbol:(NSString *) symbol numBtnWidth:(float) numBtnWidth{
    if (self = [self initWithFrame:CGRectZero]) {
        self.numBtnWidth = numBtnWidth;
        self.symbolLbl = [[UILabel alloc] init];
        self.symbolLbl.text = symbol;
        self.symbolLbl.font = [UIFont systemFontOfSize:12];
        self.symbolLbl.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
        self.backgroundView= [[UIView alloc] init];
        self.backgroundView.backgroundColor = color;
        self.backgroundView.layer.cornerRadius = 5.0;
        self.backgroundView.clipsToBounds = true;
        [self setupInitWithType:ZMNumberStepperTypeSymbol];
        

    }
    self.reduceButton.hidden = NO;
    self.countTextField.hidden = NO;
    return self;
}
- (void)setupInitWithType:(ZMNumberStepperType)type {
    self.value = 0;
    self.minValue = 0;
    self.maxValue = 10;
    self.stepValue = 1;
    self.enable = YES;
    self.keyBoardType = ZMNumberStepperKeyBoardTypeInt;
    self.type = type;
    [self setupSubviewsContraints];
    
}

#pragma mark -
#pragma mark - 👉 加 👈

- (void)increaseNumber:(id)sender{
    UIButton *btn = nil;
    if ([sender isKindOfClass:[UIButton class]]) {
        btn = sender;
    }else{
        btn = [sender userInfo];
    }
    if (!btn.highlighted) {
        
        return;
    }
    if (self.reduceButton.hidden && self.countTextField.hidden) {
        self.reduceButton.hidden = NO;
        self.countTextField.hidden = NO;
    }
    if ([self deptNumInputShouldNumber:[[NSNumber numberWithDouble:self.value] stringValue]]) {
        if (self.countTextField.text.integerValue < (NSInteger)self.maxValue) {
            self.countTextField.text = [[NSNumber numberWithInteger:self.countTextField.text.integerValue + (NSInteger)self.stepValue]stringValue];
            
        }
        if (self.countTextField.text.integerValue >= (NSInteger)self.maxValue) {
            self.countTextField.text = [[NSNumber numberWithDouble:self.maxValue] stringValue];
            
        }
        
    }else{
        if (self.countTextField.text.floatValue < self.maxValue) {
            self.countTextField.text = [[NSNumber numberWithFloat:(self.countTextField.text.floatValue + self.stepValue)] stringValue];
        }
        if (self.countTextField.text.floatValue > self.maxValue) {
            self.countTextField.text = [[NSNumber numberWithDouble:self.maxValue] stringValue];
            
        }
    }
    self.value = [self.countTextField.text doubleValue];

    [self isAddOrReduceButtonEnable:self.countTextField addButton:self.addButton reduceButton:self.reduceButton];
    
}

#pragma mark -
#pragma mark - 👉 减 👈

- (void)reduceNumber:(id)sender{
    UIButton *btn = nil;
    if ([sender isKindOfClass:[UIButton class]]) {
        btn = sender;
    }else{
        btn = [sender userInfo];
    }
    if (!btn.highlighted) {
        
        return;
    }
    if ([self deptNumInputShouldNumber:[[NSNumber numberWithDouble:self.value] stringValue]]) {
        if (self.countTextField.text.integerValue > (NSInteger)self.minValue) {
            self.countTextField.text = [[NSNumber numberWithInteger:self.countTextField.text.integerValue - (NSInteger)self.stepValue]stringValue];
            
        }
        if (self.countTextField.text.integerValue <= (NSInteger)self.minValue) {
            self.countTextField.text = [[NSNumber numberWithDouble:self.minValue] stringValue];
            
        }
        
        
    }else{
        if (self.countTextField.text.floatValue > self.minValue) {
            self.countTextField.text = [[NSNumber numberWithFloat:self.countTextField.text.floatValue - self.stepValue]stringValue];
            
        }
        if (self.countTextField.text.floatValue <= self.minValue) {
            self.countTextField.text = [[NSNumber numberWithDouble:self.minValue] stringValue];
            
        }
    }
    self.value = [self.countTextField.text doubleValue];

    [self isAddOrReduceButtonEnable:self.countTextField addButton:self.addButton reduceButton:self.reduceButton];
}


#pragma mark -
#pragma mark - 👉 UITextFieldDelegate 👈

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self deptNumInputShouldNumber:textField.text]) {
        if (self.countTextField.text.integerValue <= (NSInteger)self.minValue) {
            
            textField.text = [[NSNumber numberWithDouble:self.minValue] stringValue];
        }
        if (self.countTextField.text.integerValue >= (NSInteger)self.maxValue) {
            
            textField.text = [[NSNumber numberWithDouble:self.maxValue] stringValue];
        }
        
    }else{
        if (textField.text.floatValue <= self.minValue) {
            
            
            textField.text = [[NSNumber numberWithDouble:self.minValue] stringValue];
        }
        if(self.countTextField.text.floatValue >= self.maxValue){
            
            textField.text = [[NSNumber numberWithDouble:self.maxValue] stringValue];
        }
    }
    [self isAddOrReduceButtonEnable:self.countTextField addButton:self.addButton reduceButton:self.reduceButton];
    [self theRuleOfTextField:textField];
//    if (self.steperBlock) {
//        self.steperBlock(self.value,frontValue);
//    }
    if ([self.delegate respondsToSelector:@selector(numberStepperDidEndEditing:)]) {
        [self.delegate numberStepperDidEndEditing:self];
    }
}
- (void)textFieldTextChanged:(UITextField *)textField{
    if (textField.text.length > 1) {
        NSUInteger countPoint = 0;
        if (textField.text.length >= 1) {
            NSUInteger start = 0;
            
            BOOL existUIntegerChar = NO;
            const char *tempChar = [textField.text UTF8String];
            for (int i = 0; i < textField.text.length; i++) {
                if (tempChar[i] == '0') {
                    if (countPoint == 0 && !existUIntegerChar) start ++;
                }else if (tempChar[i] == '.'){
                    countPoint ++;
                }else{
                    existUIntegerChar = YES;
                }
            }
            NSRange range = {start,textField.text.length - start};
            textField.text = [textField.text substringWithRange:range];
        }
        if ([textField.text hasPrefix:@"."]) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
            
        }
    }
    
}


#pragma mark -
#pragma mark - 👉 Event response 👈

- (void)beginAction:(UIButton *)button{
    
    if (button == self.addButton ) {
        [self increaseNumber:button];
    }else if(button == self.reduceButton){
        [self reduceNumber:button];
        
    }
    if ([self.delegate respondsToSelector:@selector(numberStepperDidEndEditing:)]) {
        [self.delegate numberStepperDidEndEditing:self];
    }
}

- (void)isAddOrReduceButtonEnable:(UITextField *)textField addButton:(UIButton *)addBtn reduceButton:(UIButton *)reduceBtn{
    if (self.enable) {
        if (self.type == ZMNumberStepperTypeNormal ||
            self.type == ZMNumberStepperTypeSymbol
            ) {
            if ([self deptNumInputShouldNumber:[[NSNumber numberWithDouble:self.value] stringValue]]) {
                if (textField.text.integerValue >= (NSInteger)self.maxValue ) {
                    addBtn.enabled = NO;
                }else if (textField.text.integerValue <= (NSInteger)self.minValue){
                    
                    reduceBtn.enabled = NO;
                }else{
                    addBtn.enabled = YES;
                    reduceBtn.enabled = YES;
                }
            }else{
                if (textField.text.doubleValue <= self.minValue){
                    reduceBtn.enabled = NO;
                }else if (textField.text.doubleValue >= self.maxValue){
                    addBtn.enabled = NO;
                }else{
                    addBtn.enabled = YES;
                    reduceBtn.enabled = YES;
                }
            }
        }else{
            if ([self deptNumInputShouldNumber:[[NSNumber numberWithDouble:self.value] stringValue]]) {
                if (textField.text.integerValue >= (NSInteger)self.maxValue ) {
                    addBtn.enabled = NO;
                }else if (textField.text.integerValue < (NSInteger)self.minValue){
                    
                    reduceBtn.hidden = YES;
                    textField.hidden = YES;
                }else{
                    addBtn.enabled = YES;
                    reduceBtn.enabled = YES;
                }
            }else{
                if (textField.text.doubleValue < self.minValue){
                    reduceBtn.hidden = YES;
                    textField.hidden = YES;
                }else if (textField.text.doubleValue >= self.maxValue){
                    addBtn.enabled = NO;
                }else{
                    addBtn.enabled = YES;
                    reduceBtn.enabled = YES;
                }
            }
        }
    }else{
        addBtn.enabled = NO;
        reduceBtn.enabled = NO;
    }
    
    
}

#pragma mark -
#pragma mark - 👉 Private Methods 👈

//数据的输入规则
- (void)theRuleOfTextField:(UITextField *)textField {
    NSUInteger countPoint = 0;
    if (countPoint >= 2) {
        if (self.minValue) {
            textField.text  = [@(self.minValue) stringValue] ;
            
        }else{
            textField.text = [@(self.minValue) stringValue];
        }
    }
    self.value = [textField.text doubleValue];
    
}
//整数
- (BOOL)deptNumInputShouldNumber:(NSString *)textFieldValue{
    NSString *regex = @"^-?\\d+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:textFieldValue]) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - 👉 Getters && Setters 👈

- (void)setEnable:(BOOL)enable{
    _enable = enable;
    if (!enable) {
        self.reduceButton.enabled = NO;
        self.addButton.enabled = NO;
        self.countTextField.userInteractionEnabled = NO;
        self.countTextField.textColor = [UIColor
                                         colorC9];
    }else{
        self.countTextField.userInteractionEnabled = YES;
        self.countTextField.textColor = [UIColor colorC5];
        if (self.minValue && self.value <= self.minValue) {
            self.reduceButton.enabled = NO;
        }else{
            self.reduceButton.enabled = YES;
        }
        
        if (self.maxValue && self.value >= self.maxValue) {
            self.addButton.enabled = NO;
        }else{
            self.addButton.enabled = YES;
        }
    }
}

- (void)setType:(ZMNumberStepperType)type{
    _type = type;
    if (type == ZMNumberStepperTypeNormal) {
        self.reduceButton.hidden = NO;
        self.countTextField.hidden = NO;
    }else{
        self.reduceButton.hidden = YES;
        self.countTextField.hidden = YES;
    }
}
-(void)setValue:(double)value{
    
    _value = value;
    self.countTextField.text = [[NSNumber numberWithDouble:value] stringValue];
    if (self.enable) {
        if (self.minValue && self.value <= self.minValue) {
            self.reduceButton.enabled = NO;
        }else{
            self.reduceButton.enabled = YES;
        }
        
        if (self.maxValue && self.value >= self.maxValue) {
            self.addButton.enabled = NO;
        }else{
            self.addButton.enabled = YES;
        }
    }else{
        self.reduceButton.enabled = NO;
        self.addButton.enabled = NO;
    }
    
    if (self.countTextField.text.floatValue <= self.minValue) {
        
        self.countTextField.text = [[NSNumber numberWithDouble:self.minValue] stringValue];
    }
    if(self.countTextField.text.floatValue >= self.maxValue){
        
        self.countTextField.text = [[NSNumber numberWithDouble:self.maxValue] stringValue];
    }
    
}
- (void)setMinValue:(double)minValue{
    _minValue = minValue;
    if (self.enable) {
        if (self.value <= self.minValue) {
            self.reduceButton.enabled = NO;
        }else{
            self.reduceButton.enabled = YES;
        }
    }else{
        self.reduceButton.enabled = NO;
        self.addButton.enabled = NO;
    }
    
}
- (void)setMaxValue:(double)maxValue{
    _maxValue = maxValue;
    if (self.enable) {
        if (self.value >= self.maxValue) {
            self.addButton.enabled = NO;
        }else{
            self.addButton.enabled = YES;
        }
    }else{
        self.reduceButton.enabled = NO;
        self.addButton.enabled = NO;
    }
    
}

/**
 更改背景颜色
 @param addColor 加号按钮颜色
 @param addFont 加号按钮字体
 @param reduceColor 减号按钮颜色
 @param reduceFont 减号按钮字体
 */
-(void) setAddBtnTitleColor:(UIColor *) addColor addBtnFont:(UIFont *) addFont reduceTitleColor:(UIColor *) reduceColor reduceBtnFont:(UIFont *) reduceFont{
   
    [self setAddBtnTitle];
    [self setReduceBtnTitle];
    
    [self.addButton setTitleColor:addColor forState:UIControlStateNormal];
    self.addButton.titleLabel.font = addFont;
    [_reduceButton setTitleColor:reduceColor forState:UIControlStateNormal];
    _reduceButton.titleLabel.font = reduceFont;
}
-(void) setNumColor:(UIColor *) numColor font:(UIFont *) font{
    _countTextField.textColor = numColor;
    _countTextField.font = font;
    _countTextField.backgroundColor = [UIColor clearColor];
    _countTextField.adjustsFontSizeToFitWidth=YES;
}
/**
 设置加号文本
 */
-(void) setAddBtnTitle{
     [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    [self.addButton setTitle:@"+" forState: UIControlStateHighlighted];
    [self.addButton setTitle:@"+" forState: UIControlStateDisabled];
    [self.addButton setImage:nil forState: UIControlStateNormal];
    [self.addButton setImage:nil forState: UIControlStateHighlighted];
    [self.addButton setImage:nil forState: UIControlStateDisabled];
}

/**
 设置减号文本
 */
-(void) setReduceBtnTitle{
    [self.reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [self.reduceButton setTitle:@"-" forState: UIControlStateHighlighted];
    [self.reduceButton setTitle:@"-" forState: UIControlStateDisabled];
    [self.reduceButton setImage:nil forState: UIControlStateNormal];
    [self.reduceButton setImage:nil forState: UIControlStateHighlighted];
    [self.reduceButton setImage:nil forState: UIControlStateDisabled];
}
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitleColor:[UIColor colorC5] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont zm_font15pt:DYFontBoldTypeB3];
        [_addButton setImage:kIconNamed(@"card_bag_details_icon_ellipse_add") forState: UIControlStateNormal];
        [_addButton setImage:kIconNamed(@"card_bag_details_icon_ellipse_add") forState: UIControlStateHighlighted];
        [_addButton setImage:kIconNamed(@"ic_add_gray") forState: UIControlStateDisabled];
        [_addButton addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UIButton *)reduceButton{
    if (!_reduceButton) {
        _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceButton setTitleColor:[UIColor colorC5] forState:UIControlStateNormal];
        _reduceButton.titleLabel.font = [UIFont zm_font15pt:DYFontBoldTypeB3];
        [_reduceButton setImage:kIconNamed(@"card_bag_details_icon_ellipse_reduction") forState:UIControlStateNormal];
        [_reduceButton setImage:kIconNamed(@"card_bag_details_icon_ellipse_reduction") forState:UIControlStateHighlighted];
        [_reduceButton setImage:kIconNamed(@"ic_reduce_gray") forState:UIControlStateDisabled];
        [_reduceButton addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceButton;
}
- (ZMNumberStepperTextField *)countTextField {
    if (!_countTextField) {
        _countTextField = [[ZMNumberStepperTextField alloc]init];
        _countTextField.delegate = self;
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.layer.borderColor = [UIColor clearColor].CGColor;
        _countTextField.font = [UIFont zm_font15pt:DYFontBoldTypeB3];
        _countTextField.backgroundColor = kColorByHex(@"#F5F5F5");
        _countTextField.borderStyle = UITextBorderStyleNone;
        _countTextField.textColor = [UIColor colorC5];
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_countTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _countTextField;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.countTextField.keyboardType = keyboardType;
}

#pragma mark -
#pragma mark - 👉 SetupConstraints 👈

- (void)setupSubviewsContraints {
   
    if(self.type == ZMNumberStepperTypeSymbol){
        [self symbolContraints];
    }else{
        [self normalContraints];
    }
 
}
-(void) normalContraints{
    [self addSubview:self.addButton];
    [self addSubview:self.reduceButton];
    [self addSubview:self.countTextField];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width).multipliedBy(0.33);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width).multipliedBy(0.33);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reduceButton.mas_right);
        make.right.mas_equalTo(self.addButton.mas_left);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.addButton);
    }];
}
-(void) symbolContraints{
    [self addSubview:self.backgroundView];
    [self addSubview:self.symbolLbl];
    [self addSubview:self.countTextField];
    self.countTextField.backgroundColor = [UIColor orangeColor];
    __weak typeof(self) weakSelf = self;
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(weakSelf.numBtnWidth);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.reduceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(weakSelf.numBtnWidth);
        make.centerY.mas_equalTo(0);
    }];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reduceButton.mas_right);
        make.right.mas_equalTo(self.addButton.mas_left);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.addButton);
    }];
    
    [self.symbolLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reduceButton.mas_right);
        make.width.mas_equalTo(17);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.addButton);
    }];
    [self.countTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.symbolLbl.mas_right);
        make.right.mas_equalTo(self.addButton.mas_left);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.addButton);
    }];
}

/**
 修改背景颜色
 
 @param color 背景颜色
 */
-(void) setNumBackgroundColor:(UIColor *) color{
    self.countTextField.backgroundColor = color;
}
@end




@implementation ZMNumberStepperTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return NO;
}


@end
