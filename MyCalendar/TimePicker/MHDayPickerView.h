//
//  MHDayPickerView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 日期选择器
 */
@interface MHDayPickerView : UIView

+(void)showDayPickerCallBack:(void(^)(NSDate * selectedDate))callback;
+(void)showDayPickerWidthDate:(NSDate *)date callBack:(void(^)(NSDate * selectedDate))callback;

@end


