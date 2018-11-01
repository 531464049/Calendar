//
//  MHYmdwPickerView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/10/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 时间选择器选择回调
 @param pickType 日期选择的格式
 @param selectedDate 选中的日期date
 */
typedef void(^YmdwPickerCallBack)(DayPickerType pickType,NSDate * selectedDate);

/**
 时间选择器 年月日周
 */
@interface MHYmdwPickerView : UIView

+(void)showYmdwPickerWithDate:(NSDate *)date callBack:(YmdwPickerCallBack )callback;

@end

