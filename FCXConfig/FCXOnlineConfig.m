//
//  FCXOnlineConfig.m
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import "FCXOnlineConfig.h"

BOOL UseUMengConfig = YES;

@implementation FCXOnlineConfig

+ (void)initialize {
    NSString *res = [self getUMConfigParams:@"um" defaultValue:nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (res) {
        UseUMengConfig = res.boolValue;
        [userDefault setObject:res forKey:@"UseUMengConfig"];
        return;
    }
    
    res = [self getMTAConfigParams:@"um" defaultValue:nil];
    if (res) {
        UseUMengConfig = res.boolValue;
        [userDefault setObject:res forKey:@"UseUMengConfig"];
        return;
    }
    
    res = [userDefault stringForKey:@"UseUMengConfig"];
    if (res) {
        UseUMengConfig = res.boolValue;
        return;
    }
}

+ (NSString *)stringParams:(NSString *)key {
    NSLog(@"\n\n\n请导入UMOnlineConfig库！\n\n\n");
    return @"";
}

+ (NSString *)fcxGetConfigParams:(NSString *)key defaultValue:(NSString *)defaultValue {
    if (UseUMengConfig) {//友盟
        return [self getUMConfigParams:key defaultValue:defaultValue];
    }
    
    return [self getMTAConfigParams:key defaultValue:defaultValue];
}

+ (NSString *)getUMConfigParams:(NSString *)key defaultValue:(NSString *)defaultValue {
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

+ (NSString *)getMTAConfigParams:(NSString *)key defaultValue:(NSString *)defaultValue {
    Class MTAConfig = NSClassFromString(@"MTAConfig");
    if (!MTAConfig) {
        NSLog(@"请导入腾讯统计库MTA");
        return nil;
    }
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *versionParam = [NSString stringWithFormat:@"%@_%@", key, appVersion];
    NSString *result = [[MTAConfig getInstance] getCustomProperty:versionParam default:nil];
    if (result == nil) {
        result = [[MTAConfig getInstance] getCustomProperty:key default:defaultValue];
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
    return [[self fcxGetConfigParams:key defaultValue:defaultValue] boolValue];
}

#pragma mark - MTA
+ (NSString *)MTAGetConfigParameters:(NSString *)key defaultValue:(NSString *)defaultValue {
    Class MTAConfig = NSClassFromString(@"MTAConfig");
    if (!MTAConfig) {
        NSLog(@"请导入腾讯统计库MTA");
        return nil;
    }
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *versionParam = [NSString stringWithFormat:@"%@_%@", key, appVersion];
    NSString *result = [[MTAConfig getInstance] getCustomProperty:versionParam default:nil];
    if (result == nil) {
        result = [[MTAConfig getInstance] getCustomProperty:key default:defaultValue];
    }
    return result;
}

+ (instancetype)getInstance {return nil;}
- (NSString *)getCustomProperty:(NSString *)key default:(NSString *)v {return @"";}
@end
