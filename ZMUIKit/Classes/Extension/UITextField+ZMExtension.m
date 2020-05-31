//
//  UITextField+ZMExtension.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/17.
//

#import "UITextField+ZMExtension.h"
#import <objc/runtime.h>

static const char * kTextfieldMenu = "kTextfieldMenu";
static char *const kPlaceholderFontKey = "com.dyzhcs.www.ZMTextField.placeholderFont.key";
static char *const kPlaceholderColorKey = "com.dyzhcs.www.ZMTextField.placeholderColor.key";

@implementation UITextField (ZMExtension)

-(BOOL)isMenu{
    NSNumber * value = objc_getAssociatedObject(self, kTextfieldMenu);
    if (!value) {
        return YES;
    }
    return value.boolValue;
}
-(void)setIsMenu:(BOOL)isMenu{
    NSNumber * value = [NSNumber numberWithBool:isMenu];
    objc_setAssociatedObject(self, kTextfieldMenu, value, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return self.isMenu;
}


- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    objc_setAssociatedObject(self, kPlaceholderFontKey, placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:self.placeholder attributes:@{NSFontAttributeName:placeholderFont}];
    self.attributedPlaceholder = arrStr;
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, kPlaceholderFontKey);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, kPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : placeholderColor}];
    self.attributedPlaceholder = arrStr;
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, kPlaceholderColorKey);
}


#pragma mark --> 🐷 ZMKeyboardView Delegate 🐷
//编辑内容
-(void)zm_keyboardView:(ZMKeyboardView * )board replacementString:(NSString *)string{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        canEditor = [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:string];
    }
    
    if (canEditor) {
        [self replaceRange:self.selectedTextRange withText:string];
    }
}
//是否删除
-(BOOL)zm_shouldDelete:(ZMKeyboardView *)numberKeyboard{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        canEditor = [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
    }
    if (canEditor) {
        [self deleteBackward];
    }
    return canEditor;
}
//清除
-(BOOL)zm_shouldClear:(ZMKeyboardView *)board{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        canEditor = [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
    }
    if (canEditor) {
        [self setText:@""];
    }
    return canEditor;
}
@end
