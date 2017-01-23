//
//  FCXRating.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/23.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import "FCXRating.h"
#import "FCXGuide.h"
#import "UMFeedback.h"
#import "FCXOnlineConfig.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>

#define HASRATING @"HasRating"

@implementation FCXRating
{
   YWFeedbackKit *_feedbackKit;
}

+ (BOOL)startRating:(NSString *)appID bcKey:(NSString *)bcKey {
    return [[FCXRating sharedRating] fcx_startRating:appID bcKey:bcKey];
}

+ (FCXRating *)sharedRating {
    static FCXRating *rating;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rating = [[FCXRating alloc] init];
    });
    return rating;
}

- (BOOL)fcx_startRating:(NSString *)appID bcKey:(NSString *)bcKey {
    
    BOOL showRating = [[FCXOnlineConfig fcxGetConfigParams:@"showRating" defaultValue:@"0"] boolValue];
    if (!showRating) {
        return NO;
    }
    [self checkAppVersion];
    
    if (self.hasRating) {
        return NO;
    }
    
    NSDictionary *paramsDict = [FCXOnlineConfig fcxGetJSONConfigParams:@"ratingContent"];
    if (![paramsDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    //    NSLog(@"==%@", paramsDict);
    NSString *title = [paramsDict objectForKey:@"标题"];
    NSString *content = [paramsDict objectForKey:@"内容"];
    NSString *btn1 = [paramsDict objectForKey:@"按钮1"];
    NSString *btn2 = [paramsDict objectForKey:@"按钮2"];
    //    NSString *btn3 = [paramsDict objectForKey:@"按钮3"];
    NSInteger alertTimes = [[paramsDict objectForKey:@"总提醒次数"] integerValue];
    
    if (!title || !content || !btn1 || !btn2) {
        return NO;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentDateString = [self getCurrentDateString];
    NSString *alertDateString = [userDefaults objectForKey:@"alertDate"];
    if (alertDateString && [alertDateString isEqualToString:currentDateString]) {//当天弹出过
        return NO;
    }
    
    if ([userDefaults integerForKey:@"alertTimes"] >= alertTimes) {//超过弹出次数
        return NO;
    }
    
    MAlertViw *alertView = [[MAlertViw alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:btn1, btn2, nil];
    alertView.dismiss = YES;
    [alertView show];
    
    alertView.handleAction = ^(MAlertViw *alertView, NSInteger buttonIndex){
        
        if (buttonIndex == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self goFeedbcak:bcKey];
            });
            
        }else if(buttonIndex == 1) {
            
            [FCXRating goRating:appID];
            [FCXRating saveRating];
        }else {
            //            [FCXRating saveRating];
        }
    };
    
    [self saveAlert];
    return YES;
}

- (void)goFeedbcak:(NSString *)bcKey {
    _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:bcKey];
    
    // 设置App自定义扩展反馈数据
    _feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"好评->反馈"};
    
    __weak typeof(self) weakSelf = self;

    [_feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if ( viewController != nil ) {
            viewController.title = @"意见反馈";
            
            UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            UINavigationController *nav;
            if ([vc isKindOfClass:[UINavigationController class]]) {
                nav = [[[vc class] alloc] initWithRootViewController:viewController];
            } else if ([vc isKindOfClass:[UITabBarController class]]) {
                UIViewController *controller = [(UITabBarController *)vc viewControllers][0];
                if ([controller isKindOfClass:[UINavigationController class]]) {
                    nav = [[[controller class] alloc] initWithRootViewController:viewController];
                } else {
                    nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                }
            } else {
                nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            }

            [vc presentViewController:nav animated:YES completion:nil];
            
            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(actionQuitFeedback)];
            
            
            __weak typeof(nav) weakNav = nav;
            
            [viewController setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
                UIViewController *webVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:webVC.view.bounds];
                webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                
                [webVC.view addSubview:webView];
                [weakNav pushViewController:webVC animated:YES];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aURLString]]];
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
    NSString *currentDateString = [self getCurrentDateString];
    NSInteger alertTimes = [userDefaults integerForKey:@"alertTimes"];
    alertTimes++;
    
    [userDefaults setObject:currentDateString forKey:@"alertDate"];
    [userDefaults setObject:[NSNumber numberWithInteger:alertTimes] forKey:@"alertTimes"];
    [userDefaults synchronize];
}

//获取当前时间的字符串
- (NSString *)getCurrentDateString {
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey: @"RatingDateFormatter"] ;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat: @"YYYY-MM-dd"] ;
        [threadDictionary setObject: dateFormatter forKey: @"RatingDateFormatter"] ;
    }
    return [dateFormatter stringFromDate:[NSDate date]];
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
        [userDefaults removeObjectForKey:HASRATING];
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
    
    NSString *strUrl =[NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }else{
        strUrl =[NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    }
}

@end
