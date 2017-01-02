//
//  FCXWeakTimer.h
//  Timer
//
//  Created by 冯 传祥 on 15/10/22.
//  Copyright © 2015年 冯 传祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FCXTimerHandler)(id userInfo);

@interface FCXWeakTimer : NSTimer


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(FCXTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end
