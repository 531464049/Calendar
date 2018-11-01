//
//  MHTimePicker.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerlunarModel;
@class PickerSolorModel;
@protocol MHTimePickerDelegate;

@interface MHTimePicker : UIView

@property(nonatomic,weak)id <MHTimePickerDelegate> delegate;

@property(nonatomic,strong)NSDate * curentSelectedDate;

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date;
/* 切换显示模式 n公历/y农历 */
-(void)updateDayPickType;

@end

@protocol MHTimePickerDelegate <NSObject>

@optional
-(void)timePicker:(MHTimePicker *)picker selectedDate:(NSDate *)selectedDate;

@end



@interface PickerSolorModel : NSObject

@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger month;

+(NSArray *)get_allSolorMonthArr;

@end

@interface PickerlunarModel : NSObject

@property(nonatomic,assign)NSInteger year;
@property(nonatomic,copy)NSString * monthName;
@property(nonatomic,assign)NSInteger dayNum;
@property(nonatomic,assign)BOOL isLeep;

+(NSArray *)get_allLunarMonthArr;

+(NSInteger )get_monthIndex:(PickerlunarModel *)model;
@end
