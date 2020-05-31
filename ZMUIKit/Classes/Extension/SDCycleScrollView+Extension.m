//
//  SDCycleScrollView+Extension.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/10.
//

#import "SDCycleScrollView+Extension.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation SDCycleScrollView (ZMExtension)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    @try {

        NSArray * imagePathsGroup = [self valueForKey:@"imagePathsGroup"];
        if (!imagePathsGroup.count) return;
        
        SEL   currentIndex  = NSSelectorFromString(@"currentIndex");
        int itemIndex = ((int(*)(id,SEL))objc_msgSend)(self,currentIndex);
        
        SEL pageControlIndex = NSSelectorFromString(@"pageControlIndexWithCurrentCellIndex:");
        int indexOnPageControl = ((int(*)(id,SEL,int))objc_msgSend)(self,pageControlIndex,itemIndex);
        
        SEL currentPage = NSSelectorFromString(@"cycleScrollView:currentPage:");
        
        id pageControl = [self valueForKey:@"pageControl"];
        
        //如果是SDCycleScrollView自带的类型 直接赋值
        if ([pageControl isKindOfClass:NSClassFromString(@"TAPageControl")] || [pageControl isKindOfClass:NSClassFromString(@"UIPageControl")]) {
            [pageControl setValue:@(indexOnPageControl) forKey:@"currentPage"];
        }else{
        //否则 传出去自己处理
            if ([self.delegate respondsToSelector:currentPage]) {
                ((void(*)(id,SEL,id,int))objc_msgSend)(self.delegate,currentPage,self,indexOnPageControl);
            }
        }

        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {}
}
@end
