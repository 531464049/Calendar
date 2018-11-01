//
//  LunarSolarModel.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/27.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lunar;
@class Solar;

@interface LunarSolarModel : NSObject
/**
 *农历转公历
 */
+ (Solar *)lunarToSolar:(Lunar *)lunar;

/**
 *公历转农历
 */
+ (Lunar *)solarToLunar:(Solar *)solar;
@end

#pragma mark - 农历信息
@interface Lunar : NSObject
/**
 *是否闰月
 */
@property(assign) BOOL isleap;
/**
 *农历 日
 */
@property(assign) int lunarDay;
/**
 *农历 月
 */
@property(assign) int lunarMonth;
/**
 *农历 年
 */
@property(assign) int lunarYear;

@end

#pragma mark - 公历信息
@interface Solar : NSObject
/**
 *公历 日
 */
@property(assign) int solarDay;
/**
 *公历 月
 */
@property(assign) int solarMonth;
/**
 *公历 年
 */
@property(assign) int solarYear;

@end

