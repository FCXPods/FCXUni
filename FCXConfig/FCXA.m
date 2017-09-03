//
//  FCXA.m
//  PrivacyPhoto
//
//  Created by fcx on 2017/9/3.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import "FCXA.h"

@implementation FCXA

+ (void)event:(NSString *)eventId {
    if (![eventId isKindOfClass:[NSString class]]) {
        return;
    }
    [self event:eventId label:eventId];
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    if (![eventId isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!label) {
        label = eventId;
    }
    
    Class MobClick = NSClassFromString(@"MobClick");
    if (MobClick) {
        [MobClick event:eventId label:label];
    } else {
        NSLog(@"请导入友盟统计库MobClick");
    }
    
    Class MTA = NSClassFromString(@"MTA");
    if (MTA) {
        [MTA trackCustomEvent:eventId args:@[label]];
    } else {
        NSLog(@"请导入腾讯统计库MTA");
    }
}

+ (void)beginLogPageView:(NSString *)pageName {
    Class MobClick = NSClassFromString(@"MobClick");
    if (MobClick) {
        [MobClick beginLogPageView:pageName];
    } else {
        NSLog(@"请导入友盟统计库MobClick");
    }
    
    Class MTA = NSClassFromString(@"MTA");
    if (MTA) {
        [MTA trackPageViewBegin:pageName];
    } else {
        NSLog(@"请导入腾讯统计库MTA");
    }
}

+ (void)endLogPageView:(NSString *)pageName {
    Class MobClick = NSClassFromString(@"MobClick");
    if (MobClick) {
        [MobClick endLogPageView:pageName];
    } else {
        NSLog(@"请导入友盟统计库MobClick");
    }
    
    Class MTA = NSClassFromString(@"MTA");
    if (MTA) {
        [MTA trackPageViewEnd:pageName];
    } else {
        NSLog(@"请导入腾讯统计库MTA");
    }
}

#pragma mark - MTA
+ (NSInteger)trackCustomEvent:(NSString *)event_id args:(NSArray *)array {return 0;}
+ (void)trackPageViewBegin:(NSString *)page {}
+ (void)trackPageViewEnd:(NSString *)page {}

@end
