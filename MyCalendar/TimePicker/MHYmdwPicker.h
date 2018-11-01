//
//  MHYmdwPicker.h
//  HzCalendar
//
//  Created by 马浩 on 2018/10/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MHYmdwPicker : UIView

@property(nonatomic,strong,readonly)NSDate * curentSelectedDate;

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date;
/* 切换显示模式 n公历/y农历 */
-(void)updateDayPickType;

@end

