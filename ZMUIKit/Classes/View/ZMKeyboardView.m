//
//  ZMKeyboardView.m
//  CustomKeyboard
//
//  Created by 德一智慧城市 on 2019/7/19.
//  Copyright © 2019 德一智慧城市. All rights reserved.
//

#import "ZMKeyboardView.h"
#import "ZMUtilities.h"
#import "UIImage+ZMExtension.h"
#import <AudioToolbox/AudioToolbox.h>

//#import <Masonry/Masonry.h>

#define kLineWidth 0.5


CG_INLINE CGRect
kDYKeyboardDefaultFrame(){
    return CGRectMake(0, 0, kScreen_width, kScreenHeightRatio(250));;
}

@interface ZMKeyboardView()

@property(nonatomic,strong)NSMutableArray<UIButton *> * buttons;
@property(nonatomic,strong)NSArray<NSString *> * buttonTitles;
@property(nonatomic,assign)DYKeyboardType keyboardType;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)NSInteger list;
@end
@implementation ZMKeyboardView

-(instancetype)initWithFrame:(CGRect)frame keyboardType:(DYKeyboardType)type{
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = kDYKeyboardDefaultFrame();
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = type;
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    
    return self;
    
}

#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷Public Methods🐷
#pragma mark >_<! 👉🏻 🐷<#Name#> Delegate🐷
#pragma mark >_<! 👉🏻 🐷Event Response🐷
//编辑字符
-(void)buttonAction:(UIButton *)button{
    NSLog(@"输入%@",button.currentTitle);
    AudioServicesPlaySystemSound(1520);
    @try {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zm_keyboardView:replacementString:)]) {
            NSInteger index = [self.buttons indexOfObject:button];
            NSString * title = self.buttonTitles[index];
            [self.delegate zm_keyboardView:self replacementString:title];
        }
    } @catch (NSException *exception) {
        NSLog(@"error->%@",exception);
    } @finally {}
}

//删除
- (void)deleteButtonAction:(UIButton *) button {
    NSLog(@"删除");
    @try {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zm_shouldDelete:)]) {
            [self.delegate zm_shouldDelete:self];
        }
    } @catch (NSException *exception) {
        NSLog(@"keyboard delete error->%@",exception);
    } @finally {}
}

//清空
- (void)deleteBtnLongPress:(UILongPressGestureRecognizer *)longPress{
    @try {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zm_shouldClear:)]) {
            [self.delegate zm_shouldClear:self];
        }
    } @catch (NSException *exception) {
        NSLog(@"keyboard clear error->%@",exception);
    } @finally {}
}
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
//纯数字
-(NSArray <NSString *>*)kDYKeyboardTypeNumberTitles{
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"",];
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI / Layout🐷
-(void)loadDefaultsSetting{
    self.backgroundColor = kColorByHex(@"#E7E7E7");
    self.layer.borderColor = kColorByHex(@"#E7E7E7").CGColor;
    self.layer.borderWidth = kLineWidth;

}
-(void)initSubViews{

    switch (self.keyboardType) {
        case DYKeyboardTypeDefault:
            self.buttonTitles = [self kDYKeyboardTypeNumberTitles];
            self.row = 4;
            self.list = 3;
            break;
            
        case DYKeyboardTypeNumber:
            self.buttonTitles = [self kDYKeyboardTypeNumberTitles];
            self.row = 4;
            self.list = 3;
            break;
            
        case DYKeyboardTypeDecimal:
            
            break;
        case DYKeyboardTypeIDNumber:
            
            break;
            
        default:
            break;
    }
    
    //初始化按键
    for (NSInteger index = 0; index < self.buttonTitles.count; index++) {
        NSString * title = self.buttonTitles[index];
        
        UIButton * button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:26];
        [button setTitleColor:kColorByHex(@"#333333") forState:UIControlStateNormal];
        
        if (title && title.length > 0 ) {
            [button setBackgroundImage:[UIImage zm_kitImageNamed:@"kit_keyboard_delete"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.backgroundColor = kColorByHex(@"#F8F8F8");
        }
        
        [button setTitle:title forState:UIControlStateNormal];
        
        if (index == self.buttonTitles.count - 1) {
            [button setImage:[UIImage zm_kitImageNamed:@"kit_keyboard_delete"] forState:UIControlStateNormal];
            [button removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnLongPress:)];
            [button addGestureRecognizer:longPress];
        }
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = (self.bounds.size.width-((self.list-1) * kLineWidth)) / self.list;
    CGFloat h = (self.bounds.size.height-((self.row-1) * kLineWidth)) / self.row;
    
    for (NSInteger index = 0; index < self.buttons.count; index++) {
        NSInteger row = index / self.list;
        NSInteger list = index % self.list;
        UIButton * button = self.buttons[index];
        button.frame = CGRectMake(list * (w+kLineWidth), row * (h+kLineWidth), w, h);
    }
    
}

@end
