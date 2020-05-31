//
//  DYBrightness.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/20.
//

#import "ZMBrightness.h"

static CGFloat _currentBrightness;
static NSOperationQueue *_queue;

@implementation ZMBrightness

+ (void)saveDefaultBrightness {
    _currentBrightness = [UIScreen mainScreen].brightness;
}

+ (void)graduallySetBrightness:(CGFloat)value {
    
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    [_queue cancelAllOperations];
    CGFloat brightness = [UIScreen mainScreen].brightness;
    CGFloat step = 0.005 * ((value > brightness) ? 1 : -1);
    int times = fabs((value - brightness) / 0.005);
    for (CGFloat i = 1; i < times + 1; i++) {
        [_queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1 / 360.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIScreen mainScreen].brightness = brightness + i * step;
            });
        }];
    }
}

+ (void)graduallyResumeBrightness {
    [self graduallySetBrightness:_currentBrightness];
}

+ (void)fastResumeBrightness {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    [_queue cancelAllOperations];
    [_queue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIScreen mainScreen].brightness = _currentBrightness;
        });
    }];
}


@end
