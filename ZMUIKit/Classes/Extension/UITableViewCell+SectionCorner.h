//
//  UITableViewCell+SectionCorner.h
//  cornerBac
//
//  Created by xuliying on 2017/8/2.
//  Copyright © 2017年 xly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SectionCorner)

@property(nonatomic,strong) UIView *cornerV;
/**上左  上右*/
@property(nonatomic,strong) CAShapeLayer *topLay;
/**下左  下右*/
@property(nonatomic,strong) CAShapeLayer *bottomLay;
/**四角*/
@property(nonatomic,strong) CAShapeLayer *fullLay;


/**
 section添加圆角
 
 @param tableView tableView
 @param indexPath 当前indexPath
 @param frame 圆角范围
 @param cornerRadius 半径
 */
-(void)addSectionCornerWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cornerViewframe:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;
@end
