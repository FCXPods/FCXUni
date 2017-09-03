//
//  FCXA.h
//  PrivacyPhoto
//
//  Created by fcx on 2017/9/3.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FCXA : NSObject

+ (void)event:(NSString *)eventId; //等同于 event:eventId label:eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

@end
