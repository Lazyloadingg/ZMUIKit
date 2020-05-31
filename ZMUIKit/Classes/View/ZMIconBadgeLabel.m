//
//  ZMIconBadgeLabel.m
//  ZMUIKit
//
//  Created by 王士昌 on 2019/8/1.
//

#import "ZMIconBadgeLabel.h"
#import "UIColor+ZMExtension.h"
#import "UIFont+ZMExtension.h"

@interface ZMIconBadgeLabel ()

@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign) BOOL isFixedHeight;

@end

@implementation ZMIconBadgeLabel
{
    NSInteger _markValue;
}

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.colorStyle = DYIconBadgeColorStyleRed;
        self.maxType = DYIconBadgeMaxType99;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorRed1];
        self.font = [UIFont zm_font10pt:DYFontBoldTypeMedium];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.f;
        self.isFixedHeight = YES;
    }
    
    return self;
}



- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    NSInteger height = 12.0; // float类型的话,上方会一直存在一条黑色线,用int类型解决了这个问题
    UIEdgeInsets edge = [self edgeInsetsAction];
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, edge) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= edge.left;
    rect.origin.y -= edge.top;
    rect.size.width += edge.left + edge.right;
    rect.size.height = height;
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets edge = [self edgeInsetsAction];
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, edge)];
}


//- (CGSize)intrinsicContentSize {
//
//    CGSize size = [super intrinsicContentSize];
//    NSInteger height = 12;
//    CGFloat width = 0;
//
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont zm_font10pt:DYFontBoldTypeMedium]};
//    CGSize calculateSize = [ self.text boundingRectWithSize:CGSizeMake(size.width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil ].size ;
//
//    UIEdgeInsets edge = [self edgeInsetsAction];
//    width = edge.left + edge.right + calculateSize.width;
//    return CGSizeMake(width, height);
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    bounds.size = [self intrinsicContentSize];
    self.bounds = bounds;
}

#pragma mark-
#pragma mark- Public Method

- (void)setCount:(NSInteger)count {
    if (count < 1) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
    [self setupInitWithValue:count];
}


#pragma mark-
#pragma mark- Privte Method

- (void)setupInitWithValue:(NSInteger)value {
    _markValue = value;
    self.text = [NSString stringWithFormat:@"%ld",value];
    switch (self.maxType) {// 针对先设置type后赋值情况
        case DYIconBadgeMaxType99:
        {
            if (value > 99) {
                self.text = @"99+";
            }else{
                self.text = [NSString stringWithFormat:@"%ld",value];
            }
        }
            break;
            
        case DYIconBadgeMaxType999:
        {
            if (value > 999) {
                self.text = @"999+";
            }else{
                self.text = [NSString stringWithFormat:@"%ld",value];
            }
        }
            break;
            
        default:
            break;
    }
}


- (UIEdgeInsets)edgeInsetsAction{
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 5, 0, 5);
    return edge;
}


#pragma mark-
#pragma mark- Getters && Setters

- (void)setMaxType:(DYIconBadgeMaxType)maxType{// 先赋值后设置type的话
    
    _maxType = maxType;
    switch (maxType) {
        case DYIconBadgeMaxTypeNew:
            self.text = @"NEW";
            break;
            
        default:
            break;
    }
    if (_markValue < 1) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    if (_markValue < 100) {
        
        self.text = [NSString stringWithFormat:@"%ld",_markValue];
    }else if (_markValue >= 100 && _markValue < 1000){
        
        switch (maxType) {
            case DYIconBadgeMaxType99:
            {
                
                self.text = @"99+";
            }
                break;
            case DYIconBadgeMaxType999:
            {
                
                self.text = [NSString stringWithFormat:@"%ld",_markValue];
            }
                break;
            default:
                break;
        }
        
    }else{
        self.text = @"999+";
    }
}

- (void)setColorStyle:(DYIconBadgeColorStyle)colorStyle{
    
    _colorStyle = colorStyle;
    
    switch (_colorStyle) {
        case DYIconBadgeColorStyleRed:
        {
            self.backgroundColor = [UIColor colorRed1];
        }
            break;
            
        case DYIconBadgeColorStyleBlue:
        {
            self.backgroundColor = [UIColor colorC1];
        }
            break;
            
        default:
            break;
    }
}

- (void)setText:(NSString *)text {
    
    if (_markValue < 1) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    switch (_maxType) {
        case DYIconBadgeMaxType99:
        {
            if (_markValue >= 100) {
                
                text = @"99+";
            }else{
                
                text = [NSString stringWithFormat:@"%ld",_markValue];
            }
            
        }
            break;
            
        case DYIconBadgeMaxType999:
        {
            if (_markValue >= 1000) {
                
                text = @"999+";
            }else{
                
                text = [NSString stringWithFormat:@"%ld",_markValue];
            }
        }
            break;
            
        case DYIconBadgeMaxTypeNew:
        {
            text = @"NEW";
        }
            break;
        default:
            break;
    }
    
    [super setText:text];
    [self sizeToFit];
}

- (void)setTextColor:(UIColor *)textColor{
    
    textColor = [UIColor colorC3];
    [super setTextColor:textColor];
}

- (void)setFont:(UIFont *)font{
    
    font = [UIFont zm_font10pt:DYFontBoldTypeMedium];
    [super setFont:font];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    switch (_colorStyle) {
        case DYIconBadgeColorStyleRed:
        {
            backgroundColor = [UIColor colorRed1];
        }
            break;
            
        case DYIconBadgeColorStyleBlue:
        {
            backgroundColor = [UIColor colorC1];
        }
            break;
            
        default:
        {
            backgroundColor = [UIColor colorRed1];
        }
            break;
    }
    
    [super setBackgroundColor:backgroundColor];
}






@end
