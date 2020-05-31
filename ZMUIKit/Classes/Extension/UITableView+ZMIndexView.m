
#import "UITableView+ZMIndexView.h"
#import <objc/runtime.h>
#import "ZMIndexView.h"

@interface UITableView () <ZMIndexViewDelegate>

@property (nonatomic, strong) ZMIndexView *sc_indexView;

@end

@implementation UITableView (ZMIndexView)

#pragma mark - Swizzle Method

+ (void)load
{
    [self swizzledSelector:@selector(ZMIndexView_layoutSubviews) originalSelector:@selector(layoutSubviews)];
}

+ (void)swizzledSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ZMIndexView_layoutSubviews {
    [self ZMIndexView_layoutSubviews];
    
    if (!self.sc_indexView) {
        return;
    }
    if (self.superview && !self.sc_indexView.superview) {
        [self.superview addSubview:self.sc_indexView];
    }
    else if (!self.superview && self.sc_indexView.superview) {
        [self.sc_indexView removeFromSuperview];
    }
    if (!CGRectEqualToRect(self.sc_indexView.frame, self.frame)) {
        self.sc_indexView.frame = self.frame;
    }
    [self.sc_indexView refreshCurrentSection];
}

#pragma mark - ZMIndexViewDelegate

- (void)indexView:(ZMIndexView *)indexView didSelectAtSection:(NSUInteger)section
{
    if (self.zm_indexViewDelegate && [self.delegate respondsToSelector:@selector(tableView:didSelectIndexViewAtSection:)]) {
        [self.zm_indexViewDelegate tableView:self didSelectIndexViewAtSection:section];
    }
}

- (NSUInteger)sectionOfIndexView:(ZMIndexView *)indexView tableViewDidScroll:(UITableView *)tableView
{
    if (self.zm_indexViewDelegate && [self.delegate respondsToSelector:@selector(sectionOfTableViewDidScroll:)]) {
        return [self.zm_indexViewDelegate sectionOfTableViewDidScroll:self];
    } else {
        return ZMIndexViewInvalidSection;
    }
}

#pragma mark - Public Methods

- (void)zm_refreshCurrentSectionOfIndexView {
    [self.sc_indexView refreshCurrentSection];
}

#pragma mark - Private Methods

- (ZMIndexView *)createIndexView {
    ZMIndexView *indexView = [[ZMIndexView alloc] initWithTableView:self configuration:self.zm_indexViewConfiguration];
    indexView.translucentForTableViewInNavigationBar = self.zm_translucentForTableViewInNavigationBar;
    indexView.startSection = self.zm_startSection;
    indexView.delegate = self;
    return indexView;
}

#pragma mark - Getter and Setter

- (ZMIndexView *)sc_indexView
{
    return objc_getAssociatedObject(self, @selector(sc_indexView));
}

- (void)setSc_indexView:(ZMIndexView *)sc_indexView
{
    if (self.sc_indexView == sc_indexView) return;
    
    objc_setAssociatedObject(self, @selector(sc_indexView), sc_indexView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZMIndexViewConfiguration *)zm_indexViewConfiguration
{
    ZMIndexViewConfiguration *zm_indexViewConfiguration = objc_getAssociatedObject(self, @selector(zm_indexViewConfiguration));
    if (!zm_indexViewConfiguration) {
        zm_indexViewConfiguration = [ZMIndexViewConfiguration configuration];
    }
    return zm_indexViewConfiguration;
}

- (void)setzm_indexViewConfiguration:(ZMIndexViewConfiguration *)zm_indexViewConfiguration
{
    if (self.zm_indexViewConfiguration == zm_indexViewConfiguration) return;
    
    objc_setAssociatedObject(self, @selector(zm_indexViewConfiguration), zm_indexViewConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<DYTableViewSectionIndexDelegate>)zm_indexViewDelegate
{
    return objc_getAssociatedObject(self, @selector(zm_indexViewDelegate));
}

- (void)setzm_indexViewDelegate:(id<DYTableViewSectionIndexDelegate>)zm_indexViewDelegate
{
    if (self.zm_indexViewDelegate == zm_indexViewDelegate) return;
    
    objc_setAssociatedObject(self, @selector(zm_indexViewDelegate), zm_indexViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zm_translucentForTableViewInNavigationBar
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(zm_translucentForTableViewInNavigationBar));
    return number.boolValue;
}

- (void)setzm_translucentForTableViewInNavigationBar:(BOOL)zm_translucentForTableViewInNavigationBar
{
    if (self.zm_translucentForTableViewInNavigationBar == zm_translucentForTableViewInNavigationBar) return;
    
    objc_setAssociatedObject(self, @selector(zm_translucentForTableViewInNavigationBar), @(zm_translucentForTableViewInNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.sc_indexView.translucentForTableViewInNavigationBar = zm_translucentForTableViewInNavigationBar;
}

- (NSArray<NSString *> *)zm_indexViewDataSource
{
    return objc_getAssociatedObject(self, @selector(zm_indexViewDataSource));
}

- (void)setzm_indexViewDataSource:(NSArray<NSString *> *)zm_indexViewDataSource
{
    if (self.zm_indexViewDataSource == zm_indexViewDataSource) return;
    objc_setAssociatedObject(self, @selector(zm_indexViewDataSource), zm_indexViewDataSource.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (zm_indexViewDataSource.count > 0) {
        if (!self.sc_indexView) {
            self.sc_indexView = [self createIndexView];
            [self.superview addSubview:self.sc_indexView];
        }
        self.sc_indexView.dataSource = zm_indexViewDataSource.copy;
    }
    else {
        [self.sc_indexView removeFromSuperview];
        self.sc_indexView = nil;
    }
}

- (NSUInteger)zm_startSection {
    NSNumber *number = objc_getAssociatedObject(self, @selector(zm_startSection));
    return number.unsignedIntegerValue;
}

- (void)setzm_startSection:(NSUInteger)zm_startSection {
    if (self.zm_startSection == zm_startSection) return;
    
    objc_setAssociatedObject(self, @selector(zm_startSection), @(zm_startSection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.sc_indexView.startSection = zm_startSection;
}

@end
