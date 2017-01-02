//
//  FCXGuide.h
//  Universial
//
//  Created by 冯 传祥 on 15/8/23.
//  Copyright (c) 2015年 冯 传祥. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface FCXGuide : NSObject <UIAlertViewDelegate>

+ (void)startGuide;

@end




@interface MAlertViw : UIAlertView

typedef void(^HandleActionBlock)(MAlertViw *alertView, NSInteger buttonIndex);

@property(nonatomic, copy) HandleActionBlock handleAction;
@property(nonatomic, unsafe_unretained)BOOL dismiss;

@end


