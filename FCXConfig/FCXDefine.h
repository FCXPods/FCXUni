//
//  FCXDefine.h
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#ifndef FCXDefine_h
#define FCXDefine_h


#pragma mark - 屏幕宽高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


#pragma mark -  颜色相关
#define UICOLOR_FROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGB(A,B,C) [UIColor colorWithRed:((float)A)/255.0 green:((float)B)/255.0 blue:((float)C)/255.0 alpha:1.0]
#define RGBA(A,B,C,D) [UIColor colorWithRed:((float)A)/255.0 green:((float)B)/255.0 blue:((float)C)/255.0 alpha:(float)D]


#pragma mark - 系统信息（版本、名字等）
#define APP_DISPLAYNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLEID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]


#pragma mark -  系统版本
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - 图片相关
//读取本地图片,无缓存
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//读取本地png图片,无缓存
#define LOADPNGIMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:@"png"]]
//读取本地图片,有缓存
#define IMAGENAMED(name) [UIImage imageNamed:name]


#pragma mark -  循环引用
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof (weakSelf) strongSelf = weakSelf;

#define WeakObj(type)  __weak typeof(type) type##Weak = type;
#define StrongObj(type)  __strong typeof(type##Weak) type##Strong = type##Weak;


//默认字体
#define DEFAULTFONT(fontSize) [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]


#pragma mark -  调试
#ifdef DEBUG
#define DBLOG(...) NSLog(__VA_ARGS__)
//    #define debugMethod() NSLog(@"%s", __func__)
#define DBFFUNCLOG(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else
#define DBLOG(...) /* */
#define DBFUNCLOG(xx, ...)
#endif


#endif /* FCXDefine_h */
