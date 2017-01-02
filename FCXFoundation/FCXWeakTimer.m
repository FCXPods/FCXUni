//
//  FCXWeakTimer.m
//  Timer
//
//  Created by 冯 传祥 on 15/10/22.
//  Copyright © 2015年 冯 传祥. All rights reserved.
//

#import "FCXWeakTimer.h"
#import "SwizzleMethod.h"

@interface FCXWeakTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation FCXWeakTimerTarget

- (void)timerFire:(NSTimer *)timer {
    if(self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}

- (void)dealloc {
    
//        NSLog(@"%s", __func__);
}

@end

@implementation FCXWeakTimer

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzleClassMethod([self class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(fcx_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
        SwizzleClassMethod([self class], @selector(timerWithTimeInterval:target:selector:userInfo:repeats:), @selector(fcx_timerWithTimeInterval:target:selector:userInfo:repeats:));
    });
}

+ (NSTimer *)fcx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)aTarget
                                       selector:(SEL)aSelector
                                       userInfo:(nullable id)userInfo
                                        repeats:(BOOL)repeats {
    FCXWeakTimerTarget* timerTarget = [[FCXWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(timerFire:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    return timerTarget.timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(FCXTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    NSMutableArray *userInfoArray = [NSMutableArray arrayWithObject:[block copy]];
    if (userInfo != nil) {
        [userInfoArray addObject:userInfo];
    }
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(timerBlockInvoke:)
                                       userInfo:[userInfoArray copy]
                                        repeats:repeats];
}

+ (NSTimer *)fcx_timerWithTimeInterval:(NSTimeInterval)ti
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)yesOrNo {
    FCXWeakTimerTarget* timerTarget = [[FCXWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer timerWithTimeInterval:ti
                                                target:timerTarget
                                              selector:@selector(timerFire:)
                                              userInfo:userInfo
                                               repeats:yesOrNo];

    return timerTarget.timer;
}

+ (void)timerBlockInvoke:(NSArray*)userInfo {
    FCXTimerHandler block = userInfo[0];
    id info = nil;
    if (userInfo.count == 2) {
        info = userInfo[1];
    }
    
    if (block) {
        block(info);
    }
}

@end
