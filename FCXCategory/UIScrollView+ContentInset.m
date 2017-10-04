//
//  UIScrollView+ContentInset.m
//  PrivacyPhoto
//
//  Created by fcx on 2017/9/30.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import "UIScrollView+ContentInset.h"

@implementation UIScrollView (ContentInset)

- (void)fcx_adjustXContentInset {
    if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
        self.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
        self.scrollIndicatorInsets = self.contentInset;
    }
}

@end
