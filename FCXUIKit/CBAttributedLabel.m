//
//  CBAttributedLabel.m
//  CBWallet4iPhone
//
//  Created by fcx on 15/7/21.
//  Copyright (c) 2015年 chinabank payments. All rights reserved.
//

#import "CBAttributedLabel.h"

@interface CBAttributedLabel ()


@property (nonatomic, strong) NSMutableAttributedString *attributedString;


@end

@implementation CBAttributedLabel


- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return _paragraphStyle;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text) {
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

- (void)setTextColor:(UIColor *)color range:(NSRange)range {
    
    [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    
    [self.attributedString addAttribute:NSFontAttributeName value:font range:range];
}

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    [self.attributedString addAttribute:name value:value range:range];
}

- (void)finishAttributed {
    if (_paragraphStyle) {
        [self.attributedString addAttribute:NSParagraphStyleAttributeName value:_paragraphStyle range:NSMakeRange(0, self.text.length)];
    }

    self.attributedText = self.attributedString;
}

@end
