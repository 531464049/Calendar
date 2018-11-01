//
//  MHDayPicker.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHDayPicker : UIView

@property(nonatomic,strong,readonly)NSDate * curentSelectedDate;

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date;
/* 切换显示模式 n公历/y农历 */
-(void)updateDayPickType;
/* 回到当天 */
-(void)backToToday;


@end


