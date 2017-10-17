//
//  UIView+Controller.m
//  Tally
//
//  Created by fcx on 2017/9/19.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (UIViewController *)controller {
    UIResponder *responder = self;
    while ((responder = responder.nextResponder)) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end
