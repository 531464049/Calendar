//
//  MHTimePickerView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 时间选择器选择回调
 @param needRemind 是否需要提醒
 @param pickType 日期选择的格式
 @param selectedDate 选中的日期date
 */
typedef void(^pickerCallBack)(BOOL needRemind,DayPickerType pickType,NSDate * selectedDate);

/**
 时间选择器
 */
@interface MHTimePickerView : UIView

/**
 时间选择器 date-初始时间 needOption-是否需要提醒按钮 +回调
 */
+(void)showTimePickerWithCallBack:(pickerCallBack )callback;
+(void)showTimePickerWithDate:(NSDate *)date callBack:(pickerCallBack )callback;
+(void)showTimepickerWithDate:(NSDate *)date needRemindOption:(BOOL)needOption callback:(pickerCallBack )callback;
@end

