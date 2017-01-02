//
//  FCXOnlineConfig.h
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCXOnlineConfig : NSObject

+ (NSString *)fcxGetConfigParams:(NSString *)key;
+ (NSString *)fcxGetConfigParams:(NSString *)key defaultValue:(NSString*)defaultValue;
+ (id)fcxGetJSONConfigParams:(NSString *)key;
+ (BOOL)fcxGetBoolConfigParams:(NSString *)key;
+ (BOOL)fcxGetBoolConfigParams:(NSString *)key defaultValue:(NSString*)defaultValue;

@end
