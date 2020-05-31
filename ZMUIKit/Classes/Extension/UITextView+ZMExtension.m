//
//  UITextView+ZMExtension.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/19.
//

#import "UITextView+ZMExtension.h"

@implementation UITextView (ZMExtension)
#pragma mark --> 🐷 ZMKeyboardView Delegate 🐷
//编辑内容
-(void)zm_keyboardView:(ZMKeyboardView * )board replacementString:(NSString *)string{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        canEditor = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:string];
    }
    
    if (canEditor) {
        [self replaceRange:self.selectedTextRange withText:string];
    }
}
//是否删除
-(BOOL)zm_shouldDelete:(ZMKeyboardView *)numberKeyboard{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        canEditor = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
    }
    if (canEditor) {
        [self deleteBackward];
    }
    return canEditor;
}

//清除
-(BOOL)zm_shouldClear:(ZMKeyboardView *)board{
    BOOL canEditor = YES;
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        canEditor = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
    }
    if (canEditor) {
        [self setText:@""];
    }
    return canEditor;
}
@end
