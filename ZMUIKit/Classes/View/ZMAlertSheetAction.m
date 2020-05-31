//
//  ZMAlertSheetAction.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/12/2.
//

#import "ZMAlertSheetAction.h"
#import <ZMUIKit/UIFont+ZMExtension.h>
#import <ZMUIKit/UIColor+ZMExtension.h>

@implementation ZMAlertSheetAction

-(instancetype)init{
    self = [super init];
    if (self) {
        self.height = 55;
        self.font = [UIFont zm_font17pt:DYFontBoldTypeRegular];
    }
    return self;
}

+(ZMAlertSheetAction *)actionWithTitle:(NSString *)title style:(DYActionStyle)style handler:(void(^)(ZMAlertSheetAction * action))handler{
    ZMAlertSheetAction * action = [[ZMAlertSheetAction alloc]init];
    action.title = title;
    action.type = style;
    
    switch (style) {
        case DYActionStyleCancel:{
            action.titleColor = [UIColor colorC5];
        }
            
            break;
            
        case DYActionStyleDefault:{
            action.titleColor = [UIColor colorC5];
        }
            
            break;
            
        case DYActionStyleDestructive:{
            action.titleColor = [UIColor colorRed2];
        }
            
            break;
            
        default:
            break;
    }
    
    
    __weak typeof(action) weakAction = action;
    [action setClickBlock:^{
        if (handler) {
            handler(weakAction);
        }
    }];
    
    return action;
}
@end
