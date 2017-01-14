//
//  FCXOnlineConfig.m
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import "FCXOnlineConfig.h"

@implementation FCXOnlineConfig

+ (NSString *)stringParams:(NSString *)key {
    NSLog(@"\n\n\n请导入UMOnlineConfig库！\n\n\n");
    return @"";
}

+ (NSString *)fcxGetConfigParams:(NSString *)key defaultValue:(NSString *)defaultValue {
    Class class = NSClassFromString(@"UMOnlineConfig");
    if (!class) {
        class = self;
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionParam = [NSString stringWithFormat:@"%@_%@", key, appVersion];
    NSString *result = [class stringParams:versionParam];
    
    if (result == nil) {
        result = [class stringParams:key];
        
        if (result == nil && defaultValue != nil) {
            result = defaultValue;
        }
    }
    return result;
}

+ (NSString *)fcxGetConfigParams:(NSString *)key {
    
    return [self fcxGetConfigParams:key defaultValue:nil];
}

+ (id)fcxGetJSONConfigParams:(NSString *)key {
    
    NSString *paramsString = [self fcxGetConfigParams:key defaultValue:@""];
    if (![paramsString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:[paramsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

+ (BOOL)fcxGetBoolConfigParams:(NSString *)key {
    return [[self fcxGetConfigParams:key defaultValue:nil] boolValue];
}

+ (BOOL)fcxGetBoolConfigParams:(NSString *)key defaultValue:(NSString*)defaultValue {
    return [[self fcxGetConfigParams:key defaultValue:nil] boolValue];
}


@end
