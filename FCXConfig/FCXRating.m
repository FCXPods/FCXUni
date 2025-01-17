//
//  FCXRating.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/23.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import "FCXRating.h"
#import "FCXGuide.h"
#import "FCXOnlineConfig.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import <StoreKit/SKStoreReviewController.h>

#define HASRATING @"HasRating"

@implementation FCXRating
{
    YWFeedbackKit *_feedbackKit;
    UINavigationController *_navigationController;
    NSString *_county;
}

+ (void)setup {
    [[FCXRating sharedRating] requestIP:NULL];
}

+ (void)startRating:(NSString*)appID
              alKey:(NSString *)alKey
          alSecrect:(NSString *)alSecrect
         controller:(UINavigationController *)navigationController
             finish:(void(^)(BOOL success))finish {
    return [[FCXRating sharedRating] fcx_startRating:appID alKey:alKey alSecrect:alSecrect controller:navigationController finish:finish];
}

+ (FCXRating *)sharedRating {
    static FCXRating *rating;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rating = [[FCXRating alloc] init];
    });
    return rating;
}

- (void)fcx_startRating:(NSString *)appID
                  alKey:(NSString *)alKey
              alSecrect:(NSString *)alSecrect
             controller:(UINavigationController *)navigationController
                 finish:(void(^)(BOOL success))finish {
    
    BOOL showRating = [[FCXOnlineConfig fcxGetConfigParams:@"showRating" defaultValue:@"0"] boolValue];
    if (!showRating) {
        if (finish) {
            finish(NO);
        }
        return;
    }
    [self checkAppVersion];
    
    if (self.hasRating) {
        if (finish) {
            finish(NO);
        }
        return;
    }
    
    _navigationController = navigationController;

    BOOL judgeIP = [FCXOnlineConfig fcxGetConfigParams:@"judgeIP" defaultValue:@"1"].boolValue;
    BOOL foreignShow = [FCXOnlineConfig fcxGetBoolConfigParams:@"foreignShow" defaultValue:@"0"];
    if (judgeIP) {//判断IP
        NSDictionary *timeDict = [FCXOnlineConfig fcxGetJSONConfigParams:@"ratingTime"];
        NSInteger min = 10, max = 21;
        if (timeDict) {
            min = [timeDict[@"min"] integerValue];
            max = [timeDict[@"max"] integerValue];
        }
        NSInteger hour = [self getCurrentDate:@"HH" forKey:@"RatingDateFormatter_Hour"].integerValue;
        if (hour < min || hour > max) {//时间段不满足
            if (finish) {
                finish(NO);
            }
            return;
        }
        
        if (_county) {
            if ([_county isEqualToString:@"中国"]) {
                [self showRating:appID alKey:alKey alSecrect:alSecrect isForeign:NO finish:finish];
            } else {
                if (foreignShow) {
                    [self showRating:appID alKey:alKey alSecrect:alSecrect isForeign:YES finish:finish];
                } else {
                    if (finish) {
                        finish(NO);
                    }
                }
            }
        } else {
            [self requestIP:^(NSString *county) {
                if (county && [county isEqualToString:@"中国"]) {
                    [self showRating:appID alKey:alKey alSecrect:alSecrect isForeign:NO finish:finish];
                } else {
                    if (foreignShow) {
                        [self showRating:appID alKey:alKey alSecrect:alSecrect isForeign:YES finish:finish];
                    } else {
                        if (finish) {
                            finish(NO);
                        }
                    }
                }
            }];
        }
    } else {//不判断IP
        [self showRating:appID alKey:alKey alSecrect:alSecrect isForeign:NO finish:finish];
    }
}

- (void)showRating:(NSString *)appID
             alKey:(NSString *)alKey
         alSecrect:(NSString *)alSecrect
         isForeign:(BOOL)isForeign
            finish:(void (^)(BOOL))finish {
    NSDictionary *paramsDict = [FCXOnlineConfig fcxGetJSONConfigParams:@"ratingContent"];
    if (![paramsDict isKindOfClass:[NSDictionary class]]) {
        if (finish) {
            finish(NO);
        }
        return;
    }
    //    NSLog(@"==%@", paramsDict);
    NSString *title = [paramsDict objectForKey:@"标题"];
    NSString *content = [paramsDict objectForKey:@"内容"];
    NSString *btn1 = [paramsDict objectForKey:@"按钮1"];
    NSInteger lAction = [[paramsDict objectForKey:@"lAction"] integerValue];
    NSString *btn2 = [paramsDict objectForKey:@"按钮2"];
    NSInteger rAction = [[paramsDict objectForKey:@"rAction"] integerValue];
    NSString *rURL = [paramsDict objectForKey:@"rURL"];

    //    NSString *btn3 = [paramsDict objectForKey:@"按钮3"];
    NSInteger alertTimes = [[paramsDict objectForKey:@"总提醒次数"] integerValue];
    
    if (!title || !content || !btn1 || !btn2) {
        if (finish) {
            finish(NO);
        }
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentDateString = [self getCurrentDate:@"YYYY-MM-dd" forKey:@"RatingDateFormatter"];
    NSString *alertDateString = [userDefaults objectForKey:@"alertDate"];
    if (alertDateString && [alertDateString isEqualToString:currentDateString]) {//当天弹出过
        if (finish) {
            finish(NO);
        }
        return;
    }
    
    if ([userDefaults integerForKey:@"alertTimes"] >= alertTimes) {//超过弹出次数
        if (finish) {
            finish(NO);
        }
        return;
    }
    
    if (rAction == 3 || isForeign) {//应用内好评
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            [SKStoreReviewController requestReview];
            if (finish) {
                finish(YES);
            }
            [FCXRating saveRating];
            return;
        }
    }
    if (isForeign) {
        if (finish) {
            finish(NO);
        }
        return;
    }

    MAlertViw *alertView = [[MAlertViw alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:btn1, btn2, nil];
    alertView.dismiss = YES;
    [alertView show];
    
    alertView.handleAction = ^(MAlertViw *alertView, NSInteger buttonIndex){
        
        if (buttonIndex == 0) {
            if (lAction == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self goFeedbcak:alKey alSecrect:alSecrect];
                });
            }

        }else if(buttonIndex == 1) {
            
            UIApplication *application = [UIApplication sharedApplication];
            if (rURL.length > 0 && [application canOpenURL:[NSURL URLWithString:rURL]]) {
                [application openURL:[NSURL URLWithString:rURL]];
            } else if (rAction == 1) {
                NSURL *url = [NSURL URLWithString:[NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID]];
                if ([application canOpenURL:url]) {
                    [application openURL:url];
                } else {
                    [FCXRating goRating:appID];
                }
                
            } else if (rAction == 2) {
                NSURL *url = [NSURL URLWithString:[NSString  stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID]];
                if ([application canOpenURL:url]) {
                    [application openURL:url];
                } else {
                    [FCXRating goRating:appID];
                }
                
            } else if (rAction == 3) {
                [FCXRating goRating:appID];
            } else {
                [FCXRating goRating:appID];
            }
            
            [FCXRating saveRating];
        }else {
            //            [FCXRating saveRating];
        }
    };
    
    [self saveAlert];
    if (finish) {
        finish(YES);
    }
}

- (void)goFeedbcak:(NSString *)alKey alSecrect:alSecrect {
    _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:alKey appSecret:alSecrect];
    
    // 设置App自定义扩展反馈数据
    _feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"好评->反馈"};
    
    __weak UINavigationController *weakNavigationController = _navigationController;
    [_feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if ( viewController != nil ) {
            viewController.title = @"意见反馈";
            
            UINavigationController *nav;
            if ([weakNavigationController isKindOfClass:[UINavigationController class]]) {
                nav = [[[weakNavigationController class] alloc] initWithRootViewController:viewController];
            } else {
                nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            }

            [weakNavigationController presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

- (void)actionQuitFeedback
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

//保存提醒的日期和次数
- (void)saveAlert {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentDateString = [self getCurrentDate:@"YYYY-MM-dd" forKey:@"RatingDateFormatter"];
    NSInteger alertTimes = [userDefaults integerForKey:@"alertTimes"];
    alertTimes++;
    
    [userDefaults setObject:currentDateString forKey:@"alertDate"];
    [userDefaults setObject:[NSNumber numberWithInteger:alertTimes] forKey:@"alertTimes"];
    [userDefaults synchronize];
}

//获取当前时间的字符串
- (NSString *)getCurrentDate:(NSString *)dateFormatter forKey:(NSString *)key {
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSDateFormatter *_dateFormatter = [threadDictionary objectForKey:key] ;
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init] ;
        [_dateFormatter setDateFormat:dateFormatter];
        [threadDictionary setObject:_dateFormatter forKey:key] ;
    }
    return [_dateFormatter stringFromDate:[NSDate date]];
}

//检查版本，如果版本不一致，清除之前版本的缓存
- (void)checkAppVersion {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ratingVersion = [userDefaults objectForKey:@"RatingAppVersion"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (!ratingVersion) {//之前没有存过版本，第一次存
        
        ratingVersion = appVersion;
        [userDefaults setObject:ratingVersion forKey:@"RatingAppVersion"];
    }else if(![ratingVersion isEqualToString:appVersion]) {//版本升级，清空之前缓存
        
        ratingVersion = appVersion;
        [userDefaults setObject:ratingVersion forKey:@"RatingAppVersion"];
        
        //清楚之前版本的缓存
//        [userDefaults removeObjectForKey:HASRATING];
        [userDefaults removeObjectForKey:@"alertTimes"];
    }
    [userDefaults synchronize];
}

- (BOOL)hasRating {
    return  [[NSUserDefaults standardUserDefaults] boolForKey:HASRATING];
}

+ (void)saveRating {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HASRATING];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)goAppStore:(NSString*)appID {
    if (![appID isKindOfClass:[NSString class]]) {
        return;
    }
    // 打开应用内购买
    SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
    
    vc.delegate = [FCXRating sharedRating];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appID forKey:SKStoreProductParameterITunesItemIdentifier];
    [vc loadProductWithParameters:dict completionBlock:nil];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)goRating:(NSString *)appID {
    if (![appID isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString  * strUrl = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:strUrl];
    if ([application canOpenURL:url]) {
        [application openURL:url];
        return;
    }
    
    strUrl =[NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    url = [NSURL URLWithString:strUrl];
    if ([application canOpenURL:url]) {
        [application openURL:url];
        return;
    }
    
    strUrl =[NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", appID];
    url = [NSURL URLWithString:strUrl];
    if ([application canOpenURL:url]) {
        [application openURL:url];
        return;
    }
}

- (void)requestIP:(void (^)(NSString *county))finish {
    NSString *urlString = @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
//    NSLog(@"requestIP=======    ");
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"finish");
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //            NSLog(@"json ==%@ ==%@", dict, dict[@"country"]);
            if ([dict isKindOfClass:[NSDictionary class]]) {
                _county = dict[@"country"];
                if (finish) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        finish(_county);
                    });
                }
            } else if (finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish(nil);
                });
            }
        } else if (finish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(nil);
            });
        }
        /*
         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
         
         NSLog(@"respod %@  header  %@", response,[(NSHTTPURLResponse *)response allHeaderFields]);
         
         NSString *dateString = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Date"];
         dateString = [dateString substringWithRange:NSMakeRange(5, 20)];
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
         
         dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
         dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
         
         NSDate *date = [dateFormatter dateFromString:dateString];
         
         [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+0800"]];
         dateString = [dateFormatter stringFromDate:date];
         NSInteger house = [[dateString substringWithRange:NSMakeRange(12, 2)] integerValue];
         if (house >= 11 && house <= 20) {//符合时间
         
         }
         }
         */
    }];
    [task resume];
}

@end
