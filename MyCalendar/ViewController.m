//
//  ViewController.m
//  MyCalendar
//
//  Created by 马浩 on 2018/10/25.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "ViewController.h"
#import "MHCalendarView.h"//日历
#import "MHDayPickerView.h"//日期选择器


@interface ViewController ()<MHCalendarViewDelegate>
{
    CGFloat _calendarWeekHeight;//日历顶部 周列表高度
    CGFloat _calendarItemHeight;//日历item高度
    NSInteger _calendarWeekNum;//日历周数 用来更新日历高度
}
@property(nonatomic,strong)MHCalendarView * calendarView;//日历部分
@property(nonatomic,strong)UIButton * showPickBtn;//弹出日期选择器按钮

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _calendarWeekHeight = Width(35);
    _calendarItemHeight = (Screen_WIDTH / 7 + Width(12));
    
    self.calendarView = [[MHCalendarView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, _calendarWeekHeight + _calendarItemHeight*6)];
    self.calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
    
    _calendarWeekNum = self.calendarView.curentMonthWeekNum;
    CGFloat calendarHeight = _calendarWeekHeight + _calendarItemHeight * _calendarWeekNum;
    self.calendarView.frame = CGRectMake(0, NavHeight, Screen_WIDTH, calendarHeight);
    
    self.showPickBtn = [UIButton buttonWithType:0];
    self.showPickBtn.backgroundColor = [UIColor blackColor];
    self.showPickBtn.frame = CGRectMake(30, Screen_HEIGTH - 50 - 50 - 30, Screen_WIDTH - 60, 50);
    self.showPickBtn.titleLabel.font = FONT(14);
    [self.showPickBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.showPickBtn addTarget:self action:@selector(show_timePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showPickBtn];
}
-(void)fix_frames
{
    CGFloat calendarHeight = _calendarWeekHeight + _calendarItemHeight * _calendarWeekNum;
    CGRect calenderFrmae = CGRectMake(0, NavHeight, Screen_WIDTH, calendarHeight);
    self.calendarView.frame = calenderFrmae;

}
#pragma mark - 日历代理
#pragma mark - 当前显示月份 周数 更新frame
-(void)calenderView:(MHCalendarView *)calenderView curentMonthWeekNum:(NSInteger)weekNum
{
    _calendarWeekNum = weekNum;
    [self fix_frames];
}
#pragma mark - 当前显示的年月
- (void)calenderView:(MHCalendarView *)calenderView pageOfYear:(NSInteger)year month:(NSInteger)month
{
    DLog(@"当前年月：%ld年 %ld月",year,month);
}
#pragma mark - 选中日期回调
- (void)calenderView:(MHCalendarView *)calenderView daySelected:(DayModel *)dayModel
{
    DLog(@"选中日期回调：%ld-%ld-%ld",dayModel.year,dayModel.month,dayModel.day);

}
#pragma mark - 日期选择器
-(void)show_timePicker
{
    [MHDayPickerView showDayPickerWidthDate:[NSDate date] callBack:^(NSDate *selectedDate) {
        [self.calendarView jumpToDate:selectedDate];
    }];
}
@end
