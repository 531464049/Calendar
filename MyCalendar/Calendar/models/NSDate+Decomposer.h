//
//  NSDate+Decomposer.h
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayModel.h"
@interface NSDate (Decomposer)

/**
 *  获得当前 NSDate 对象 几分   3点45 返回45
 */
+ (NSInteger)date_minute:(NSDate*)date;
/**
 *  获得当前 NSDate 对象几点   3点45 返回3
 */
+ (NSInteger)date_hour:(NSDate*)date;
/**
 *  获得当前 NSDate 对象对应的日子   8月31 返回31
 */
+ (NSInteger)date_Day:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应的月份  8月31 返回8
 */
+ (NSInteger)date_Month:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应的年份
 */
+ (NSInteger)date_Year:(NSDate*)date;

/**
 *  获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
 */
+ (NSDate *)lastMonthDate:(NSDate*)date;

/**
 获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
 @param date date
 @return 下个月的某一天（此处定为15号）的 NSDate 对象
 */
+ (NSDate *)nextMonthDate:(NSDate*)date;

/**
 获得当前 NSDate 对象对应的月份的总天数
 @param date date
 @return 对应的月份的总天数
 */
+ (NSInteger)totalDaysOfMonth:(NSDate*)date;

/**
 获得当前 NSDate 对象对应月份当月第一天的所属星期
 @param date date
 @return 当前date对应月份，当月第一天是周几（0：周日，1：周一....）
 */
+ (NSInteger)firstWeekDayOfMonth:(NSDate*)date;

/**
 获得当前 NSDate 对象对应周几
 @param date date
 @return 当前 NSDate 对象对应周几（0：周日，1：周一....）
 */
+(NSInteger)weekForDate:(NSDate *)date;
+(NSString *)weekStrForDate:(NSDate *)date;

/**
 该日期在一年中第几周
 */
+(NSInteger )numOfWeekInYear:(NSDate *)date;

/**
 根据月 日 计算星座
 */
+(NSString *)getXingZuoWithMonth:(NSInteger )m day:(NSInteger )d;

/**
 根据年月，返回对应的date
 @param year 年
 @param month 月
 @return date
 */
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month;

/**
 根据年月日，返回对应的date
 @param year 年
 @param month 月
 @param day 日
 @return date
 */
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minate:(NSInteger)minate;

/**
 根据年月日date 赶回一个该date对应的正点date
 @param ymdDate 年月日date
 @return 对应的正点date
 */
+(NSDate *)OnTimeWithYmdDate:(NSDate *)ymdDate;
/**
 根据年月日date 赶回一个该date对应的今年正点date
 @param ymdDate 年月日date
 @return 对应的正点date
 */
+(NSDate *)OnTimeForThisYear:(NSDate *)ymdDate;

/**
 根据月份偏移量，获取偏移后的月份日期
 @param offSet 偏移的月份    3：往后三个月    -3：往前三个月
 @return 偏移后的月份date
 */
+(NSDate *)dateFromMonthOffSet:(NSInteger)offSet;

/**
 当前date对应前后三个月的monthModel
 @param date 当前date
 @return 前后三个月的monthModel
 */
+(NSArray *)nearByMonthForDate:(NSDate *)date;

/**
 *  当前年对应月 天数
 */
+(NSInteger)daysNumOfMonth:(NSInteger)month andYear:(NSInteger)year;

/*日期 天干、地支 农历日月*/
+(NSString *)LunarForSolar:(NSDate *)solarDate;

/**
 将日期格式化成字符串
 @param dateFormat yyyy-MM-dd HH:mm:ss
 @return 格式化后的字符串
 */
-(NSString *)dateToStrFor:(NSString *)dateFormat;


/**
 当前时间 下一小时整点
 @return 下一小时整点
 */
+(NSDate *)dateForNextHour;

/**
 获取当前时间戳字符串
 @return 时间戳字符串
 */
+(NSString *)getCurentTimestamp;

/**
 r日期对比

 @param date1 date1
 @param date2 date2
 @return 0=相等     1 = date1大于date2  -1 = date1小于date2
 */
+(int)compareOneDay:(NSDate *)date1 withAnotherDay:(NSDate *)date2;

/**
 格式化时间date 2018年8月23日 周三 23:34
 @param date date
 @return 格式化时间
 */
+(NSString *)dateFomt_Y_M_D_Week_hour_minate:(NSDate *)date;
#pragma mark - 两个日期之间相隔天数

/**
 两个日期之间相隔天数

 @param fromDate fromDate
 @param toDate toDate
 @return fromDate 到 toDate 之间的天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 当前日期 num 年后的日期
 */
+(NSDate *)dateForYearRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num;
/**
 当前日期 num 月后的日期
 */
+(NSDate *)dateForMonthRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num;
/**
 当前日期 num 天后的日期
 */
+(NSDate *)dateForDayRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num;

/**
 当前日期 3个月后的日期
 */
+(NSDate *)dateForNextThreeMonth;

@end
