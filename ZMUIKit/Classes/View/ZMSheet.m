//
//  ZMSheet.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/27.
//

#import "ZMSheet.h"
#import <LEEAlert/LEEAlert.h>

@interface ZMSheet ()


@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, strong) LEEActionSheetConfig * actionSheet;

@end

@implementation ZMSheet





-(float) sheetVCHeight{
    return 0;
}

#pragma mark --> 🐷 New ZMSheet 方法🐷
+ (ZMSheet * )sheetAlertWithTitle:(nullable NSString *)title message:(nullable NSString *) message{
    ZMSheet * sheet = [[ZMSheet alloc]init];
    sheet.actionSheet.config
    .LeeTitle(title)
    .LeeContent(message);
    return sheet;
}

- (void)addTitle:(void(^)(UILabel *label))label{
    self.actionSheet.config
    .LeeAddTitle(label);

}

- (void)addContent:(void(^)(UILabel *label))label{
    self.actionSheet.config
    .LeeAddContent(label);
    
}
- (void)addCustomView:(UIView *)customView{
    
    self.actionSheet.config
    .LeeAddCustomView(^(LEECustomView * _Nonnull custom) {
        custom.view = customView;
    });
}
- (void)addAction:(ZMAlertSheetAction *)sheetAction{

    self.actionSheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = sheetAction.title;
        action.titleColor = sheetAction.titleColor;
        action.highlightColor = sheetAction.highlightColor;
        action.font = sheetAction.font;
        action.height = sheetAction.height;
        action.type = sheetAction.type ;
        action.borderPosition = sheetAction.borderPosition;
        action.clickBlock = sheetAction.clickBlock;
        action.image = sheetAction.image;
        action.highlightImage = sheetAction.highlightImage;
        action.backgroundImage = sheetAction.backgroundImage;
        action.backgroundColor = sheetAction.backgroundColor;
        action.backgroundHighlightColor = sheetAction.backgroundHighlightColor;
        action.insets = sheetAction.insets;
        action.imageEdgeInsets = sheetAction.imageEdgeInsets;
        action.titleEdgeInsets = sheetAction.titleEdgeInsets;
        action.attributedTitle = sheetAction.attributedTitle;
        action.attributedHighlight = sheetAction.attributedHighlight;
        action.borderColor = [UIColor colorC7];
    });

}

- (void)sheetShow{
    self.actionSheet.config.LeeShow();
}

- (LEEActionSheetConfig *)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[LEEActionSheetConfig alloc] init];
        _actionSheet.config.LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            return CGRectGetWidth([[UIScreen mainScreen] bounds]);
        })
        .LeeHeaderInsets(UIEdgeInsetsMake(14, 15, 14, 15))
        .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
        .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
        .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
        .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero())
        .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    
        .LeeActionSheetCancelActionSpaceColor(UIColor.plainTableViewBackgroundColor); // 设置取消按钮间隔的颜色

    }
    return _actionSheet;
}




@end
