//
//  UISearchBar+Extension.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/10/8.
//

#import "UISearchBar+ZMExtension.h"
#import <objc/runtime.h>
#import "UITextField+ZMExtension.h"

static char *const kPlaceholderFontKey = "com.dyzhcs.www.placeholderFont.key";
static char *const kPlaceholderColorKey = "com.dyzhcs.www.placeholderColor.key";

@implementation UISearchBar (ZMExtension)

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    objc_setAssociatedObject(self, kPlaceholderFontKey, placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.zm_searchTextField.placeholderFont = placeholderFont;
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, kPlaceholderFontKey);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, kPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.zm_searchTextField.placeholderColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, kPlaceholderColorKey);
}

- (UITextField *)zm_searchTextField {
    if(@available(iOS 13.0, *)) {
        return self.searchTextField;
    }else {
        UITextField *searchTextField = [self valueForKey:@"_searchField"];
        return searchTextField;
    }
}

@end
