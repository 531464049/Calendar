//
//  MHCalendarManager.h
//  HzCalendar
//
//  Created by 马浩 on 2018/8/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayModel.h"

@interface MHCalendarManager : NSObject

@property (nonatomic ,copy,readonly)NSDate * currentDate;//当前日期
@property (nonatomic ,assign,readonly)NSInteger currentDay;//当前 日
@property (nonatomic ,assign,readonly)NSInteger currentMonth;//当前 月
@property (nonatomic ,assign,readonly)NSInteger currentYear;//当前 年

@property(nonatomic,strong)NSArray * lunarYearArr;//本地读取的农历信息

+ (instancetype)defaultManager;

/**
 根据日期信息 获取农历+节假日+节气信息
 @param dayModel 日期model
 @param callBack callback-农历+节假日+节气model
 */
+(void)calculationChinaCalendarWithDay:(DayModel *)dayModel callBack:(void(^)(ChinaDayModel * chinaModel))callBack;

/**
 根据date获取整个对应的monthModel
 @param date date
 @param callBack mmonthModel
 */
+(void)getMonthDateFromDate:(NSDate *)date callBack:(void(^)(MonthModel * monthModel))callBack;

/**
 根据日历页面滑动偏移量 获取当前需要展示的三个月数据
 @param pageOffSet 偏移量
 @param callBack months
 */
+(void)getMonthsDataFromPageOffSet:(NSInteger)pageOffSet callBack:(void(^)(NSArray<MonthModel *> * months))callBack;

/**
 读取本地农历信息
 */
+(NSArray *)readLunarYearJson;

/**
 根据年份读取农历月份数据
 */
+(NSArray *)lunarMonthsArrForYear:(NSInteger)year;

@end
