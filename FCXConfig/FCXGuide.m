//
//  FCXGuide.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/23.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import "FCXGuide.h"
#import "FCXOnlineConfig.h"
#import <UMMobClick/MobClick.h>

@implementation MAlertViw

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (self.dismiss) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }

    if (self.handleAction) {
        self.handleAction(self, buttonIndex);
    }
}

@end

@implementation FCXGuide

+ (void)startGuide {
    if (![[FCXOnlineConfig fcxGetConfigParams:@"showGuide"] isEqualToString:@"1"]) {
        return;
    }
    FCXGuide *guide = [[FCXGuide alloc] init];
    [guide fcx_startGuide];
}

- (void)fcx_startGuide {
//    NSString *paramsString = @"{ \"导流形式\" : \"1\", \"标题\" : \"铃声\", \"内容\" : \"导流测试\", \"左按钮\" : \"以后再说\", \"右按钮\" : \"马上下载\", \"appid\" : \"2\"}";
    

    NSString *paramsString = [FCXOnlineConfig fcxGetConfigParams:@"guideContent" defaultValue:@""];
    NSDictionary *paramsDict = [NSJSONSerialization JSONObjectWithData:[paramsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];

//    NSLog(@"==%@", paramsDict);
    NSString *type = [paramsDict objectForKey:@"导流形式"];
    NSString *title = [paramsDict objectForKey:@"标题"];
    NSString *content = [paramsDict objectForKey:@"内容"];
    NSString *left = [paramsDict objectForKey:@"左按钮"];
    NSString *right = [paramsDict objectForKey:@"右按钮"];
    NSString *appid = [paramsDict objectForKey:@"appid"];
    __block NSString *url = [paramsDict objectForKey:@"url"];

    if (!type || !title || !content || !left) {
        return;
    }
    
    if ([type isEqualToString:@"1"]) {
        MAlertViw *alertView = [[MAlertViw alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:left, nil];
        [alertView show];
        alertView.handleAction = ^(MAlertViw *alertView, NSInteger buttonIndex){
            if (url && [url hasPrefix:@"http"]) {
                [MobClick event:@"导流" label:url];
                
            } else {
                [MobClick event:@"导流" label:appid];
                url = [NSString stringWithFormat: @"https://itunes.apple.com/us/app/id%@", appid];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        };
    }else {
        if (!right) {
            return;
        }
        
        //1每次 2每天
        NSString *rate = [paramsDict objectForKey:@"弹出机制"];
        if (![self shouldShowGuide:rate.integerValue]) {
            return;
        }

        MAlertViw *alertView = [[MAlertViw alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:left otherButtonTitles:right, nil];
        alertView.dismiss = YES;
        [alertView show];
        
        alertView.handleAction = ^(MAlertViw *alertView, NSInteger buttonIndex){

            if (buttonIndex == 1) {
                if (url && [url hasPrefix:@"http"]) {
                    [MobClick event:@"导流" label:url];
 
                } else {
                    [MobClick event:@"导流" label:appid];
                    url = [NSString stringWithFormat: @"https://itunes.apple.com/us/app/id%@", appid];
                }

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else {
                [MobClick event:@"导流" label:left];
            }

        };
    }
}


///获取当前时间的字符串
- (NSString *)getCurrentDateString {
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey: @"GuideDateFormatter"] ;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat: @"YYYY-MM-dd"] ;
        [threadDictionary setObject: dateFormatter forKey: @"GuideDateFormatter"] ;
    }
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (BOOL)shouldShowGuide:(NSInteger)rate {
    if (rate == 1) {
        return YES;
    }
    NSString *currentDateString = [self getCurrentDateString];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *guideDateString = [userDefaults objectForKey:@"guideDate"];
    
    if (guideDateString && [guideDateString isEqualToString:currentDateString]) {
        return NO;
    }
    
    [userDefaults setObject:currentDateString forKey:@"guideDate"];
    [userDefaults synchronize];
    
    return YES;
}

@end
