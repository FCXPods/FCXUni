//
//  UIView+Frame.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/16.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property(nonatomic, unsafe_unretained) CGFloat left;
@property(nonatomic, unsafe_unretained) CGFloat top;
@property(nonatomic, unsafe_unretained) CGFloat right;
@property(nonatomic, unsafe_unretained) CGFloat bottom;

@property(nonatomic, unsafe_unretained) CGFloat width;
@property(nonatomic, unsafe_unretained) CGFloat height;

@property(nonatomic, unsafe_unretained) CGFloat centerX;
@property(nonatomic, unsafe_unretained) CGFloat centerY;

@property(nonatomic, unsafe_unretained) CGPoint origin;
@property(nonatomic, unsafe_unretained) CGSize size;

@end
