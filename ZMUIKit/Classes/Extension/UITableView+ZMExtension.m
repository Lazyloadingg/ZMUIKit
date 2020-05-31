//
//  UITableView+Extension.m
//  ZMUIKit
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#import "UITableView+ZMExtension.h"

@implementation UITableView (ZMExtension)

-(void)registerNib:(NSString *)nibName forCellIdentifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

-(NSInteger)lastSection{
    return self.numberOfSections > 0 ? self.numberOfSections - 1 : 0;
}

-(NSIndexPath * )lastCell{
    NSInteger lastSection = [self lastSection];
    return [NSIndexPath indexPathForRow:[self lastCellIndexPathWithSection:lastSection].row inSection:lastSection];
}

-(NSIndexPath *)lastCellIndexPathWithSection:(NSInteger)section{
    return [NSIndexPath indexPathForRow:[self numberOfRowsInSection:section]-1 inSection:section];
}
@end
