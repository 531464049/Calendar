//
//  DayModel.h
//  HzCalendar
//
//  Created by 马浩 on 2018/8/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DayModel;
@class ChinaDayModel;

@interface MonthModel : NSObject

@property (nonatomic, assign) NSInteger totalDays; //当月的天数
@property (nonatomic, assign) NSInteger firstWeekday; //当月第一天是周几（0：周日，1：周一....）
@property (nonatomic, assign) NSInteger year; //年
@property (nonatomic, assign) NSInteger month; //月
@property (nonatomic, strong) NSArray<DayModel *> * dayModelArr;

/**
 初始化一个monthModel（无dayModelArr）
 @param date date
 @return MonthModel
 */
+ (MonthModel*)monthWithDate:(NSDate*)date;

@end


@interface DayModel : NSObject

@property (nonatomic, assign) NSInteger year; //年
@property (nonatomic, assign) NSInteger month; //月
@property (nonatomic, assign) NSInteger day; //日
@property (nonatomic, assign) BOOL isCurentMonth; //是否是当前月
@property (nonatomic, assign) BOOL isCurentDay; //是否是当天
@property(nonatomic,strong)ChinaDayModel * chinaModel;//该q日期对应的节日信息

/**
 cell上要显示的农历信息
 @param model model
 @return 农历位置显示的字符
 */
+(NSString *)dayCellShowChinaText:(DayModel *)model;

/**
 cell上农历信息显示颜色（非选中状态）
 @param model model
 @return 颜色类型
 */
+(UIColor *)dayCellShowChinaTextColor:(DayModel *)model;

/**
 根据date初始化一个DayModel
 */
+(DayModel *)dayModelWith:(NSDate *)date;

/**
 比较两个DayModel 是否是同一天
 */
+(BOOL)isSameDay:(DayModel *)aModel other:(DayModel *)bModel;

@end

#pragma mark - 农历信息  甲子 正月 初一
@interface ChinaDayModel : NSObject

@property(nonatomic,copy)NSString * chineseYear;//甲子
@property(nonatomic,copy)NSString * chineseMonth;//正月 腊月
@property(nonatomic,copy)NSString * chineseDay;//初三/初四/廿十
@property(nonatomic,copy)NSString * chineseHoliday;//春节/元宵节
@property(nonatomic,copy)NSString * otherHoliday;//情人节/平安夜之类的
@property(nonatomic,copy)NSString * solarTerms;//24节气


@end
