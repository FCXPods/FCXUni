//
//  CBAttributedLabel.h
//  CBWallet4iPhone
//
//  Created by fcx on 15/7/21.
//  Copyright (c) 2015年 chinabank payments. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBAttributedLabel : UILabel

/*
*******************************************************************************
 注：设置所有的这些属性前要先调用label的setText方法 给label赋值text，最后调用finishAttributed
*******************************************************************************
*/


@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;//!<段落格式设置


/**
 *  设置某段字的颜色

 *
 *  @param color 颜色
 *  @param range 位置
 */
- (void)setTextColor:(UIColor *)color range:(NSRange)range;


/**
 *  设置某段字的字体
 *
 *  @param font  字体
 *  @param range 位置
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;

/**
 *  所有的属性设置完成后，一定要调用这个方法，用来给label设置attributedText
 */
- (void)finishAttributed;

@end
