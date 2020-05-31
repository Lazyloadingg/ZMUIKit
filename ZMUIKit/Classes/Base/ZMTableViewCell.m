//
//  DYTableViewCell.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/7/17.
//

#import "ZMTableViewCell.h"
#import <Masonry/Masonry.h>
#import "ZMUIKit.h"

@interface DYTableViewCell ()

@property (nonatomic, strong) UIView *zm_backgroundView;

@property (nonatomic, strong) UIView *zm_separatorView;

@property (nonatomic, strong) UIImageView *zm_selectionImageView;

@property (nonatomic, strong) UIImageView *zm_accessoryImageView;

@end

@implementation DYTableViewCell

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _zm_separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.zm_selectionStyle = DYTableViewCellSelectionStyleNone;
        self.zm_separatorStyle = DYTableViewCellSeparatorStyleSingleLine;
        UIView *selectedView = [[UIView alloc] initWithFrame:self.frame];
        selectedView.backgroundColor = [[UIColor colorGray11] colorWithAlphaComponent:0.85];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}


#pragma mark-
#pragma mark- Public Methods
- (void)setSelectionStyle:(UITableViewCellSelectionStyle)selectionStyle {
    [super setSelectionStyle:selectionStyle];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)setzm_separatorColor:(UIColor *)zm_separatorColor {
    _zm_separatorColor = zm_separatorColor;
    self.zm_separatorView.backgroundColor = zm_separatorColor;
}

- (void)setzm_selectionStyle:(DYTableViewCellSelectionStyle)zm_selectionStyle {
    _zm_selectionStyle = zm_selectionStyle;
    switch (zm_selectionStyle) {
        case DYTableViewCellSelectionStyleNone:{
            [_zm_selectionImageView removeFromSuperview];
            _zm_selectionImageView = nil;
        }
            break;
        case DYTableViewCellSelectionStyleSingleSelection:{
            if(self.zm_selectionImageView.superview == nil){
                [self addSubview:self.zm_selectionImageView];
                [self insertSubview:self.zm_selectionImageView atIndex:0];
            }
            [self.zm_selectionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.trailing.mas_equalTo(-15);
                make.size.mas_equalTo(self.zm_selectionImageView.image.size);
            }];
            self.zm_selectionImageView.image = kImageNamed(@"");
            self.zm_selectionImageView.hidden = !self.isSelected;
        }
            break;
        case DYTableViewCellSelectionStyleMultipleSelection:{
            if(self.zm_selectionImageView.superview == nil) {
                [self addSubview:self.zm_selectionImageView];
                [self insertSubview:self.zm_selectionImageView atIndex:0];
            }
            [self.zm_selectionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.leading.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            self.zm_selectionImageView.image = self.isSelected ? kImageNamed(@"") : kImageNamed(@"");
        }
            break;
        default:
            break;
    }
    [self setupSeparatorViewContraint];
}

- (void)setzm_highlightStyle:(DYTableViewCellHighlightStyle)zm_highlightStyle {
    _zm_highlightStyle = zm_highlightStyle;
    switch (zm_highlightStyle) {
        case DYTableViewCellHighlightStyleNone:
            [_zm_backgroundView removeFromSuperview];
            _zm_backgroundView = nil;
            break;
        case DYTableViewCellHighlightStyleLightgray:{
            if(self.zm_backgroundView.superview == nil) {
                [self addSubview:self.zm_backgroundView];
                [self insertSubview:self.zm_backgroundView atIndex:0];
            }
            [self setupBackgroundViewContraint];
            self.zm_backgroundView.hidden = !self.isHighlighted;
        }
            break;
        default:
            break;
    }
}
- (void)setzm_separatorStyle:(DYTableViewCellSeparatorStyle)zm_separatorStyle {
    _zm_separatorStyle = zm_separatorStyle;
    switch (zm_separatorStyle) {
        case DYTableViewCellSeparatorStyleNone:{
            [_zm_separatorView removeFromSuperview];
            _zm_separatorView = nil;
        }
            
            break;
        case DYTableViewCellSeparatorStyleCustom:
        case DYTableViewCellSeparatorStyleSingleLine:
        case DYTableViewCellSeparatorStyleSingleAllLine:
        case DYTableViewCellSeparatorStyleSingleLineEqule:
        case DYTableViewCellSeparatorStyleSingleIconLine:
        case DYTableViewCellSeparatorStyleSingleIconLine43PX:
        case DYTableViewCellSeparatorStyleSingleIconLine64PX:
        case DYTableViewCellSeparatorStyleSingleIconLine155PX:{
            if (self.zm_separatorView.superview == nil) {
                [self addSubview:self.zm_separatorView];
            }
            [self setupSeparatorViewContraint];
        }
            
            break;
        default:
            break;
    }
    [self setupBackgroundViewContraint];
}

- (void)setzm_accessoryType:(DYTableViewCellAccessoryType)zm_accessoryType {
    _zm_accessoryType = zm_accessoryType;
    if (_zm_accessoryView.superview) {
        _zm_accessoryType = DYTableViewCellAccessoryTypeNone;
    }
    switch (_zm_accessoryType) {
        case DYTableViewCellAccessoryTypeNone:{
            [_zm_accessoryImageView removeFromSuperview];
            _zm_accessoryImageView = nil;
        }
            
            break;
        case DYTableViewCellAccessoryTypeDisclosureIndicator:{
            if (self.zm_accessoryImageView.superview == nil) {
                [self addSubview:self.zm_accessoryImageView];
                [self.zm_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.trailing.mas_equalTo(-15);
                    make.size.mas_equalTo(self.zm_accessoryImageView.image.size);
                }];
            }
        }
            
            break;
        default:
            break;
    }
}

- (void)setzm_accessoryView:(UIView *)zm_accessoryView {
    _zm_accessoryView = zm_accessoryView;
    if (zm_accessoryView && [zm_accessoryView isKindOfClass:[UIView class]]) {
        self.zm_accessoryType = DYTableViewCellAccessoryTypeNone;
        if (self.zm_accessoryView.superview == nil) {
            [self addSubview:self.zm_accessoryView];
            [self.zm_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.trailing.mas_equalTo(-15);
                make.size.mas_equalTo(self.zm_accessoryView.bounds.size);
            }];
        }
    }
}

- (void)setzm_separatorInset:(UIEdgeInsets)zm_separatorInset {
    _zm_separatorInset = zm_separatorInset;
    self.zm_separatorStyle = DYTableViewCellSeparatorStyleCustom;
}

#pragma mark-
#pragma mark- Event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    switch (self.zm_selectionStyle) {
        case DYTableViewCellSelectionStyleSingleSelection:{
            self.zm_selectionImageView.hidden = !selected;
            _zm_accessoryImageView.hidden = selected;
            _zm_accessoryView.hidden = selected;
        }
            break;
            
        case DYTableViewCellSelectionStyleMultipleSelection:
            self.zm_selectionImageView.image = selected ? kImageNamed(@"") : kImageNamed(@"");
            break;
            
        default:
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    switch (self.zm_highlightStyle) {
        case DYTableViewCellHighlightStyleLightgray:
            self.zm_backgroundView.hidden = !highlighted;
            break;
        default:
            break;
    }
}

#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters

- (UIView *)zm_separatorView {
    if (!_zm_separatorView) {
        _zm_separatorView = [[UIView alloc] init];
        _zm_separatorView.backgroundColor = [UIColor colorC7];
    }
    return _zm_separatorView;
}

- (UIImageView *)zm_selectionImageView {
    if(!_zm_selectionImageView) {
        _zm_selectionImageView = [[UIImageView alloc] initWithImage:kImageNamed(@"")];
        _zm_selectionImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zm_selectionImageView;
}

- (UIView *)zm_backgroundView {
    if(!_zm_backgroundView) {
        _zm_backgroundView = [[UIView alloc] init];
        _zm_backgroundView.backgroundColor = [[UIColor colorC9] colorWithAlphaComponent:0.4];
    }
    return _zm_backgroundView;
}

- (UIImageView *)zm_accessoryImageView {
    if (!_zm_accessoryImageView) {
        _zm_accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_bag_icon_more"]];
        _zm_accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zm_accessoryImageView;
}

#pragma mark-
#pragma mark- SetupConstraints

- (void)setupBackgroundViewContraint {
    if (_zm_backgroundView.superview == nil)  return;
    
    switch (self.zm_separatorStyle) {
        case DYTableViewCellSeparatorStyleCustom:
        case DYTableViewCellSeparatorStyleSingleLine:
        case DYTableViewCellSeparatorStyleSingleAllLine:
        case DYTableViewCellSeparatorStyleSingleLineEqule:
        case DYTableViewCellSeparatorStyleSingleIconLine43PX:
        case DYTableViewCellSeparatorStyleSingleIconLine64PX:
        case DYTableViewCellSeparatorStyleSingleIconLine155PX:
        {
            [self.zm_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.equalTo(self);
                make.bottom.mas_equalTo(-0.5f);
            }];
        }
            break;
            
        default:
        {
            [self.zm_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
            break;
    }
}

- (void)setupSeparatorViewContraint {
    if (_zm_separatorView.superview == nil)  return;
    
    CGFloat separatorViewH = kPixelScale(1);
    
    if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleLine && self.zm_selectionStyle == DYTableViewCellSelectionStyleMultipleSelection) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.zm_selectionImageView.mas_trailing).mas_offset(15.0f);
            make.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleLine) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0f);
            make.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleAllLine) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleLineEqule) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.f);
            make.trailing.mas_equalTo(-15.f);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleIconLine){
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(48);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleIconLine43PX) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(43);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleIconLine64PX) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(64);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleSingleIconLine155PX) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(155);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(separatorViewH);
        }];
    }else if (self.zm_separatorStyle == DYTableViewCellSeparatorStyleCustom) {
        [self.zm_separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.zm_separatorInset.left);
            make.trailing.mas_equalTo(-self.zm_separatorInset.right);
            make.bottom.mas_equalTo(-self.zm_separatorInset.bottom);
            make.height.mas_equalTo(separatorViewH);
        }];
    }
    
}


@end
