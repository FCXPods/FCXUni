//
//  UIButton+Block.h
//  Common
//
//  Created by 冯 传祥 on 14-12-5.
//  Copyright (c) 2014年 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Block)


- (void)actionWithControlEvents:(UIControlEvents)controlEvent handler:(void (^)(UIButton *button))handler;

- (void)defaultControlEventsWithHandler:(void (^)(UIButton *button))handler;

@end
