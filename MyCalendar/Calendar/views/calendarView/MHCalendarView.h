//
//  MHCalendarView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHCalendarViewDelegate;
@interface MHCalendarView : UIView

@property(nonatomic,weak)id <MHCalendarViewDelegate> delegate;
@property(nonatomic,strong)DayModel * curentSelectedDay;

@property(nonatomic,assign)NSInteger curentMonthWeekNum;

/**
 回到今天日期
 */
-(void)backToToday;
/**
 跳转到对应日期
 */
-(void)jumpToDate:(NSDate *)date;

@end

#pragma mark - 代理
@protocol MHCalendarViewDelegate <NSObject>

@optional

/**
 日历页面当前显示的年月
 @param calenderView MHCalendarView
 @param year 当前 年
 @param month 当前 月
 */
-(void)calenderView:(MHCalendarView *)calenderView pageOfYear:(NSInteger)year month:(NSInteger)month;

/**
 日历选中日期回调
 @param calenderView MHCalendarView
 @param dayModel 选中的日期模型（DayModel）
 */
-(void)calenderView:(MHCalendarView *)calenderView daySelected:(DayModel *)dayModel;

-(void)calenderView:(MHCalendarView *)calenderView curentMonthWeekNum:(NSInteger)weekNum;

@end
