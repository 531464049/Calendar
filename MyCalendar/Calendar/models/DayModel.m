//
//  DayModel.m
//  HzCalendar
//
//  Created by 马浩 on 2018/8/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "DayModel.h"

@implementation MonthModel
// NSCoding Implementation


+ (MonthModel*)monthWithDate:(NSDate*)date
{
    MonthModel *model = [[MonthModel alloc]init];
    model.totalDays = [NSDate totalDaysOfMonth:date];
    model.firstWeekday = [NSDate firstWeekDayOfMonth:date];
    model.month = [NSDate date_Month:date];
    model.year = [NSDate date_Year:date];
    return model;
}

@end


@implementation DayModel
// NSCoding Implementation

+(NSString *)dayCellShowChinaText:(DayModel *)model
{
    NSString * returnStr = [NSString stringWithFormat:@"%@",model.chinaModel.chineseDay];
    
    if (model.chinaModel.otherHoliday.length > 0) {
        
        returnStr = [NSString stringWithFormat:@"%@",model.chinaModel.otherHoliday];
        
    }else if (model.chinaModel.chineseHoliday.length > 0) {
        
        returnStr = [NSString stringWithFormat:@"%@",model.chinaModel.chineseHoliday];
        
    }else if (model.chinaModel.solarTerms.length > 0) {
        
        returnStr = [NSString stringWithFormat:@"%@",model.chinaModel.solarTerms];
        
    }else if ([model.chinaModel.chineseDay isEqualToString:@"初一"]) {
        
        returnStr = [NSString stringWithFormat:@"%@",model.chinaModel.chineseMonth];
        
    }
    return returnStr;
}
+(UIColor *)dayCellShowChinaTextColor:(DayModel *)model
{
    if (model.chinaModel.otherHoliday.length > 0) {
        return HexRGBAlpha(0xde3d2e, 1);
    }else if (model.chinaModel.chineseHoliday.length > 0) {
        return HexRGBAlpha(0xde3d2e, 1);
    }else if (model.chinaModel.solarTerms.length > 0) {
        return HexRGBAlpha(0x60B4FC, 1);
    }else{
        return HexRGBAlpha(0x999999, 1);
    }
}
+(DayModel *)dayModelWith:(NSDate *)date
{
    DayModel * model = [[DayModel alloc] init];
    model.year = [NSDate date_Year:date];
    model.month = [NSDate date_Month:date];
    model.day = [NSDate date_Day:date];
    [MHCalendarManager calculationChinaCalendarWithDay:model callBack:^(ChinaDayModel *chinaModel) {
        model.chinaModel = chinaModel;
    }];
    return model;
}
+(BOOL)isSameDay:(DayModel *)aModel other:(DayModel *)bModel
{
    if (aModel.year != bModel.year) {
        return NO;
    }
    if (aModel.month != bModel.month) {
        return NO;
    }
    if (aModel.day != bModel.day) {
        return NO;
    }
    return YES;
}
@end


@implementation ChinaDayModel
// NSCoding Implementation

@end
