//
//  ZMPickerRowTableCell.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/9.
//

#import "ZMPickerRowTableCell.h"
#import <ZMUIKit/ZMUIKit.h>
#import <Masonry/Masonry.h>

@interface ZMPickerRowTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZMPickerRowTableCell

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        [self setupSubviewsContraints];
    }
    return self;
}

#pragma mark-
#pragma mark- Getters && Setters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorC5];
        _titleLabel.font = [UIFont zm_font21pt:DYFontBoldTypeRegular];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setzm_selected:(BOOL)zm_selected {
    _zm_selected = zm_selected;
    _titleLabel.textColor = _zm_selected ? [UIColor colorC5] : [UIColor colorC6];
    _titleLabel.font = _zm_selected ? [UIFont zm_font21pt:DYFontBoldTypeBold] : [UIFont zm_font16pt:DYFontBoldTypeRegular];
}

- (void)setContent:(NSString *)content {
    _content = content;
    if (_content) _titleLabel.text = _content;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

#pragma mark-
#pragma mark- SetupConstraints

- (void)setupSubviewsContraints{
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}


@end
