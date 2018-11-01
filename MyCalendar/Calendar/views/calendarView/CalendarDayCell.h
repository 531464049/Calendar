//
//  CalendarDayCell.h
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarDayCell : UICollectionViewCell

@property(nonatomic,strong)DayModel * model;
@property(nonatomic,assign)BOOL isSelectedDay;

@end

NS_ASSUME_NONNULL_END
