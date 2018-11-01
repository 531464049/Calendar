//
//  CalendarMonthView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMonthViewDelegate;
@interface CalendarMonthView : UIView

@property(nonatomic,weak)id <CalendarMonthViewDelegate> delegate;
@property(nonatomic,strong)DayModel * curentSelectedDay;
@property(nonatomic,strong)MonthModel * monthModel;

@end


#pragma mark - 代理
@protocol CalendarMonthViewDelegate <NSObject>

@optional
/**
 日期选中回调
 */
-(void)calendarMonthView:(CalendarMonthView *)monthView selectedDay:(DayModel *)day;
/**
 点击上月/下月日期回调
 */
-(void)calendarMonthView:(CalendarMonthView *)monthView selectedLastOrNextMonth:(BOOL)isLastMonth;
@end
