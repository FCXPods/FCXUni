//  UMOnlineConfig
//  Copyright © 2015-2016 Umeng. All rights reserved.


#import <Foundation/Foundation.h>

#define UMOnlineConfigDidFinishedNotification @"OnlineConfigDidFinishedNotification"

@interface UMOnlineConfig : NSObject
///---------------------------------------------------------------------------------------
/// @name  在线参数：可以动态设定应用中的参数值
///---------------------------------------------------------------------------------------

/** 此方法会检查并下载服务端设置的在线参数,例如可在线更改SDK端发送策略。
 */
+(void)fetchData;

/** 在线参数初始化 appkey为在umeng官方网站获取的appkey。
 @param (appkey)
 
 @return (void)
 */
+ (void)initWithAppkey:(NSString *)appkey;


/** 返回已缓存的在线参数值
 带参数的方法获取某个key的值，不带参数的获取所有的在线参数.
 需要先调用updateOnlineConfig才能使用,如果想知道在线参数是否完成完成，请监听UMOnlineConfigDidFinishedNotification
 @return (NSString *) .
 */
+ (NSDictionary *)configParams;

/*获取数值类型的参数值
 @param key
 @return (NSNumber *) .
 */
+(NSNumber*)numberParams:(NSString*)key;

/*获取开关类型的参数值,开发者使用时需要检查返回值是否为null，
 如果为null，说明没有对应key的开关类型的参数，不为null时的值才可以使用。
 @param key
 @return (id) .
 */
+(id)boolParams:(NSString*)key;

/*获取字符串类型的参数值
 @param key
 @return (NSString*) .
 */
+(NSString*)stringParams:(NSString*)key;

/*获取数组类型的参数值
 @param key
 @return (BOOL) .
 */
+(NSArray*)arrayParams:(NSString*)key;

/** 设置是否打印sdk的log信息, 默认NO(不打印log).
 @param value 设置为YES,umeng SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 @return void.
 */
+ (void)setLogEnabled:(BOOL)value;

@end
