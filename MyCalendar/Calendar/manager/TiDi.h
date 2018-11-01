//
//  TiDi.h
//  HzCalendar
//
//  Created by 马浩 on 2018/10/19.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiDi : NSObject

+(TiDi *)sharedInstance;
//获取日期的天干地支
-(NSArray *)getTiDi:(NSDate *)date;
//获取生肖
- (NSString *)getShengxiao:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
