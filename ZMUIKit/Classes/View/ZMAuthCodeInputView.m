//
//  DYAuthCodeInputView.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/13.
//

#import "ZMAuthCodeInputView.h"
#import "ZMUtilities.h"

#define K_W ((self.bounds.size.width - ((K_Input_Count-1) * K_Pad)) / K_Input_Count)
#define K_Pad 8
#define K_Screen_Width               [UIScreen mainScreen].bounds.size.width
#define K_Screen_Height              [UIScreen mainScreen].bounds.size.height
//指示器高度
#define K_Indicator_Height 1
//光标宽度
#define K_Cursor_Width 1.5
#define K_Input_Count 4
#define K_DefaultColor kColorByHex(@"#00A2EA")
@interface DYAuthCodeInputView()
<
UITextFieldDelegate
>

@property(nonatomic,strong)DYAuthCodeTextView * textView;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * lines;
@property(nonatomic,strong)NSMutableArray <CALayer *> * bottomLines;
@property(nonatomic,strong)NSMutableArray <UILabel *> * labels;
@property(nonatomic,strong)NSMutableArray <UIView *>* boxs;
@property(nonatomic,assign)NSInteger inputNum;
/**
 输入框样式
 */
@property(nonatomic,assign)DYAuthCodeInputStyle inputStyle;


@property (nonatomic, assign) BOOL completed;
@end

@implementation DYAuthCodeInputView

-(instancetype)initWithFrame:(CGRect)frame type:(DYAuthCodeInputType)type style:(DYAuthCodeInputStyle)style{
    self = [super initWithFrame:frame];
    
    if (self) {
        switch (type) {
            case DYAuthCodeInputTypeFour:
                self.inputNum = 4;
                break;
                
            case DYAuthCodeInputTypeSix:
                self.inputNum = 6;
                break;
                
            default:
                self.inputNum = 4;
                break;
        }
        _inputSpace = K_Pad;
        self.editingStyleColor = K_DefaultColor;
        self.inputStyle = style;
        self.automaticHideKeyboard = YES;
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;
}

#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
-(void)clearContent{
    self.textView.text = @"";
    [self setVisible:@""];
}
#pragma mark >_<! 👉🏻 🐷UITextField Delegate🐷
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length < self.inputNum) {
        self.completed = NO;
    }
    
    NSString *verStr = textField.text;
    if (verStr.length > _inputNum) {
        textField.text = [textField.text substringToIndex:_inputNum];
    }
    
    //大于等于最大值时, 结束编辑
    if (verStr.length >= _inputNum) {
  
        if (self.automaticHideKeyboard) {
            [self endEdit];
        }else{
            
            if (self.completionBlock && !self.completed) {
                self.completionBlock(textField.text);
                self.completed = YES;
            }
        }
    }
    
    if (self.changeBlock) {
        self.changeBlock(textField.text);
    }
    
    [self setVisible:verStr];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setVisible:textField.text];
    if (self.completionBlock && self.automaticHideKeyboard) {
        self.completionBlock(textField.text);
    }
}
#pragma mark >_<! 👉🏻 🐷Event Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
-(void)setVisible:(NSString *)verStr{
    for (int i = 0; i < _labels.count; i ++) {
        UILabel *bgLabel = _labels[i];
        
        if (i < verStr.length) {
            [self changeViewLayerIndex:i linesHidden:YES];
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            [self changeViewLayerIndex:i linesHidden:i == verStr.length ? NO : YES];
            //textView的text为空的时候
            if (!verStr && verStr.length == 0) {
                [self changeViewLayerIndex:0 linesHidden:NO];
            }
            bgLabel.text = @"";
        }
    }
}
//设置光标显示隐藏
- (void)changeViewLayerIndex:(NSInteger)index linesHidden:(BOOL)hidden {
    
    switch (self.inputStyle) {
        case DYAuthCodeInputStyleLine:{
            CAShapeLayer *line = self.lines[index];
            CALayer * bottomLine = self.bottomLines[index];
            
            if (hidden) {
                [line removeAnimationForKey:@"kOpacityAnimation"];
                bottomLine.backgroundColor = self.defaultStyleColor.CGColor?:[UIColor grayColor].CGColor;
            }else{
                bottomLine.backgroundColor = self.editingStyleColor.CGColor;
                line.fillColor = self.editingStyleColor.CGColor;
                [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            }
            
            line.hidden = hidden;
        }
            
            break;
            
        case DYAuthCodeInputStyleBox:{
            UIView * subView = self.boxs[index];
            if (hidden) {
                subView.layer.borderColor = self.defaultStyleColor.CGColor?:[UIColor grayColor].CGColor;
            }else{
                subView.layer.borderColor = self.editingStyleColor.CGColor;
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
}
//开始编辑
- (void)beginEdit{
    
    
    switch (self.inputStyle) {
        case DYAuthCodeInputStyleLine:{
            self.bottomLines.firstObject.backgroundColor = self.editingStyleColor.CGColor;
            self.lines.firstObject.fillColor = self.editingStyleColor.CGColor;
        }
            
            break;
            
        case DYAuthCodeInputStyleBox:{
            self.boxs.firstObject.layer.borderColor = self.editingStyleColor.CGColor;
        }
            break;
            
        default:{
            self.bottomLines.firstObject.backgroundColor = self.editingStyleColor.CGColor;
            self.lines.firstObject.fillColor = self.editingStyleColor.CGColor;
        }
            break;
    }
    
}
//结束编辑
- (void)endEdit{
    [self.textView resignFirstResponder];
}

//开始编辑
-(void)showKeyboard{
    [self.textView becomeFirstResponder];
}
//输入框线条样式
-(void)styleLines{

    CGFloat H = CGRectGetHeight(self.frame);
    
    CGFloat W = ((self.bounds.size.width - ((K_Input_Count-1) * self.inputSpace)) / K_Input_Count);
    
    [self.lines removeAllObjects];
    [self.bottomLines removeAllObjects];
    [self.bottomLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //Indicator
    [self.boxs enumerateObjectsUsingBlock:^(UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        

        
        CALayer * layer = [[CALayer alloc]init];
        layer.frame = CGRectMake(0, H-K_Indicator_Height, W, K_Indicator_Height);
        layer.backgroundColor = self.defaultStyleColor.CGColor?:[UIColor lightGrayColor].CGColor;
        [self.bottomLines addObject:layer];
        
        [subView.layer addSublayer:layer];
        
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(W / 2, 10, K_Cursor_Width, H - 20)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  [UIColor darkGrayColor].CGColor;
        [subView.layer addSublayer:line];
        [self.lines addObject:line];
        
        if (idx == 0) {
            line.fillColor = self.editingStyleColor.CGColor;
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
    }];
    
}
//输入框方块样式
-(void)bosxStyle{
    
    for (UIView * subView in self.boxs) {
        subView.layer.borderColor = self.defaultStyleColor.CGColor?:[UIColor darkGrayColor].CGColor;
        subView.layer.borderWidth = 0.5;
        subView.layer.cornerRadius = 2;
    }
    
}
-(void)setSubviewStyle{
    //加载样式
      switch (self.inputStyle) {
          case DYAuthCodeInputStyleLine:
              [self styleLines];
              
              break;
              
          case DYAuthCodeInputStyleBox:
              [self bosxStyle];
              break;
              
          default:
              [self styleLines];
              break;
      }
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setEditingStyleColor:(UIColor *)editingStyleColor{
    _editingStyleColor = editingStyleColor;
    [self beginEdit];
}
-(void)setDefaultStyleColor:(UIColor *)defaultStyleColor{
    _defaultStyleColor = defaultStyleColor;
//    [self setSubviewStyle];
    [self setVisible:@""];
}
-(void)setInputSpace:(CGFloat)inputSpace{
    _inputSpace = inputSpace;
//    [self styleLines];
}
-(void)setFont:(UIFont *)font{
    _font = font;
    if (self.labels && self.labels.count > 0) {
        [self.labels setValue:_font forKey:@"font"];
    }
}
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
-(NSMutableArray *)boxs{
    if (!_boxs) {
        _boxs = [NSMutableArray array];
    }
    return _boxs;
}
-(NSMutableArray*)bottomLines{
    if (!_bottomLines) {
        _bottomLines = [NSMutableArray array];
    }
    return _bottomLines;
}
- (DYAuthCodeTextView *)textView {
    if (!_textView) {
        _textView = [DYAuthCodeTextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        [_textView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if (@available(iOS 12.0, *)) {
            _textView.textContentType = UITextContentTypeOneTimeCode;
        }

    }
    return _textView;
}

#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    
}
- (void)initSubViews {
    
    for (int i = 0; i < _inputNum; i ++) {
        UIView *subView = [UIView new];
        subView.userInteractionEnabled = NO;
        [self addSubview:subView];
        [self.boxs addObject:subView];
        
        //Label
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:27];
        [subView addSubview:label];
        [self.labels addObject:label];
    }
    
    //加载样式
    [self setSubviewStyle];
    

    [self addSubview:self.textView];
    [self beginEdit];
    
}
-(void)layout{
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat w = ((self.bounds.size.width - ((K_Input_Count-1) * self.inputSpace)) / K_Input_Count);
    CGFloat space = self.inputSpace;

    for (NSInteger index = 0; index < self.labels.count; index++) {
        UILabel * label = self.labels[index];
        label.frame = CGRectMake(0, 0, w, H);
    }
    
    for (NSInteger index = 0; index < self.inputNum; index++) {
        UIView * subView = self.boxs[index];
        subView.frame = CGRectMake((w+space) * index, 0, w, H);
    }
    
    if (self.boxs.count == self.bottomLines.count && self.boxs.count == self.lines.count) {
        [self.boxs enumerateObjectsUsingBlock:^(UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
            CALayer * layer = self.bottomLines[idx];
            layer.frame = CGRectMake(0, H-K_Indicator_Height, w, K_Indicator_Height);
            
            //光标
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(w / 2, 10, K_Cursor_Width, H - 20)];
            CAShapeLayer *line = self.lines[idx];
            line.path = path.CGPath;
            line.fillColor =  self.editingStyleColor.CGColor;
            
            if (idx == 0) {
                [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
                //高亮颜色
                line.hidden = NO;
            }else {
                line.hidden = YES;
            }
        }];
    }
    
    
    self.textView.frame = CGRectMake(space, 0, W-space * 2, H);
}

@end


/***************************DYAuthCodeTextView*************************/
@implementation DYAuthCodeTextView

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    if(menuController) {
        [UIMenuController sharedMenuController].menuVisible=NO;
    }
    return NO;
}

@end
