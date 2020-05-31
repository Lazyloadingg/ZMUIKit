//
//  BPTapticEngineTool.m
//  qinziyuan_b_ios
//
//  Created by zhudou on 2017/12/18.
//  Copyright © 2017年 ryb. All rights reserved.
//

#import "ZMImpactFeedBack.h"

@implementation ZMImpactFeedBack

+ (void)impactFeedback:(UIImpactFeedbackStyle)style
{
    if (@available(iOS 10, *)) {
        UIImpactFeedbackGenerator* impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
        [impactFeedback impactOccurred];
    }
}

+ (void)notificationFeedback:(UINotificationFeedbackType)type
{
    if (@available(iOS 10, *)) {
        UINotificationFeedbackGenerator* notificationFeedback = [[UINotificationFeedbackGenerator alloc] init];
        [notificationFeedback notificationOccurred:type];
    }
}
+(void) selectFeedBack{
    if (@available(iOS 10.0, *)) {
        UISelectionFeedbackGenerator *feedbackSelection = [[UISelectionFeedbackGenerator alloc] init];
          [feedbackSelection selectionChanged];
    } else {
        // Fallback on earlier versions
    }
       
}
@end
