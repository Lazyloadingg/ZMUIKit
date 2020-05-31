//
//  ZMProtocolWebViewController.m
//  Aspects
//
//  Created by 德一智慧城市 on 2019/7/10.
//

#import "ZMProtocolWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import "ZMUtilities.h"
@interface ZMProtocolWebViewController ()
<
WKUIDelegate,
WKNavigationDelegate
>
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,strong)UIProgressView * progressView;
@end

static NSString * const kLoadProgress = @"estimatedProgress";
static NSString * const kWebTitle = @"title";
@implementation ZMProtocolWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
    
    self.edgesForExtendedLayout =  UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark >_<! 👉🏻 🐷Life cycle🐷
#pragma mark >_<! 👉🏻 🐷System Delegate🐷
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    ZMLog(@"加载失败%@",error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    ZMLog(@"加载成功");
}
#pragma mark >_<! 👉🏻 🐷Event  Response🐷
#pragma mark >_<! 👉🏻 🐷Private Methods🐷
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        ZMLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:kWebTitle]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
-(void)clearCache{
    NSArray * types = @[
        WKWebsiteDataTypeDiskCache,
        WKWebsiteDataTypeMemoryCache,
        WKWebsiteDataTypeCookies,
        WKWebsiteDataTypeWebSQLDatabases,
        WKWebsiteDataTypeIndexedDBDatabases,
        WKWebsiteDataTypeOfflineWebApplicationCache
    ];
    
    NSSet * set = [NSSet setWithArray:types];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:set modifiedSince:date completionHandler:^{
        
    }];
    
}
-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:kLoadProgress options:0 context:nil];
        [_webView addObserver:self forKeyPath:kWebTitle options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.trackTintColor = kColorByHex(@"#f7f7f7");
        _progressView.progressTintColor = [UIColor colorBlue1];
    }
    return _progressView;
}
#pragma mark >_<! 👉🏻 🐷Setter / Getter🐷
-(void)setProgressTintColor:(UIColor *)progressTintColor{
    _progressTintColor = progressTintColor;
    self.progressView.progressTintColor = _progressTintColor;
}

-(void)setTrackTintColor:(UIColor *)trackTintColor{
    _trackTintColor = trackTintColor;
    self.progressView.trackTintColor = _trackTintColor;
}
#pragma mark >_<! 👉🏻 🐷Default Setting / UI🐷

-(void)loadDefaultsSetting{
    self.view.backgroundColor = [UIColor whiteColor];
    [self clearCache];
}

-(void)initSubViews{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self layout];
}

-(void)layout{

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.view);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
}

-(void)dealloc{
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}
@end
