//
//  TestPickerView.h
//  HzCalendar
//
//  Created by 马浩 on 2018/10/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TestCallBack)(NSDate * date);

@interface TestPickerView : UIView

+(void)show:(TestCallBack )callBack;

@end

