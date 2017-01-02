//
//  UIButton+Block.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/16.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)

- (void)actionWithControlEvents:(UIControlEvents)controlEvent handler:(void (^)(UIButton *button))handler;

- (void)defaultControlEventsWithHandler:(void (^)(UIButton *button))handler;

@end
