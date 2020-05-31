//
//  ZMApplication.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/8/20.
//

#import "ZMApplication.h"

@implementation ZMApplication


+(void)zm_resetRootViewController:(UIViewController *)controller{
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    //        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
    Animation animation = ^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = controller;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.45f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

+(NSString *)zm_appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

+(NSString *)zm_appVersion{
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return version;
}

+(NSString *)zm_appBulid{
   NSString * bulid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return bulid;
}
@end
