//
//  MHCalendarView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHCalendarView.h"
#import "WeeksView.h"
#import "CalendarMonthView.h"
@interface MHCalendarView()<UIScrollViewDelegate,CalendarMonthViewDelegate>

@property(nonatomic,assign)NSInteger pageOffSet;//页面切换偏移量
@property(nonatomic,strong)WeeksView * weeksView;
@property(nonatomic,strong)UIScrollView * contentScrollView;
@property(nonatomic,strong)NSArray<CalendarMonthView *> * monthViewArr;

@end
@implementation MHCalendarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.pageOffSet = 0;
        [self creatSubviews];
    }
    return self;
}
-(void)creatSubviews
{
    [self addSubview:self.weeksView];
    [self addSubview:self.contentScrollView];

    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        CalendarMonthView * monthView = [[CalendarMonthView alloc] initWithFrame:CGRectMake(self.contentScrollView.frame.size.width*i, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
        monthView.delegate = self;
        [self.contentScrollView addSubview:monthView];
        
        [arr addObject:monthView];
    }
    self.monthViewArr = [NSArray arrayWithArray:arr];
    
    [self update_calendarData];
}
-(void)backToToday
{
    [self jumpToDate:[NSDate date]];
}
-(void)jumpToDate:(NSDate *)date
{
    //根据要跳转的日期 初始化一个DayModel
    DayModel * day = [DayModel dayModelWith:date];
    if (day.year == [NSDate date_Year:[NSDate date]] && day.month == [NSDate date_Month:[NSDate date]]) {
        day.isCurentMonth = YES;
        if (day.day == [NSDate date_Day:[NSDate date]]) {
            day.isCurentDay = YES;
        }
    }
    self.curentSelectedDay = day;
    //计算页面偏移量
    /*
     当前 2018-9
     跳转 2020-3
     （2020*12 + 3） - （2018*12 + 9）
     */
    NSInteger offSet = (day.year * 12 + day.month) - (MHCalendarManager.defaultManager.currentYear * 12 + MHCalendarManager.defaultManager.currentMonth);
    self.pageOffSet = offSet;
    
    [self update_calendarData];
    
    [self callBackSelectedDay];
}
#pragma mark - 回调选中d日期
-(void)callBackSelectedDay
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(calenderView:daySelected:)]) {
        [self.delegate calenderView:self daySelected:self.curentSelectedDay];
    }
}
#pragma mark - 读取-更新日历信息
-(void)update_calendarData
{

    [MHCalendarManager getMonthsDataFromPageOffSet:self.pageOffSet callBack:^(NSArray<MonthModel *> *months) {
        
        for (int i = 0; i < months.count; i ++) {
            CalendarMonthView * monthView = (CalendarMonthView *)self.monthViewArr[i];
            MonthModel * monthModel = (MonthModel *)months[i];
            monthView.curentSelectedDay = self.curentSelectedDay;
            monthView.monthModel = monthModel;
            
            if (i == 1) {
                //当前显示的month
                if (self.delegate && [self.delegate respondsToSelector:@selector(calenderView:pageOfYear:month:)]) {
                    [self.delegate calenderView:self pageOfYear:monthModel.year month:monthModel.month];
                }
            }
        }

    }];
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width, 0) animated:NO];

    CalendarMonthView * curentMonthView = (CalendarMonthView *)self.monthViewArr[1];
    NSInteger numOfWeek = curentMonthView.monthModel.dayModelArr.count / 7;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calenderView:curentMonthWeekNum:)]) {
        [self.delegate calenderView:self curentMonthWeekNum:numOfWeek];
    }
    
    //frame 需要根据当前月份高度重新赋值
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width*3, self.contentScrollView.frame.size.height);
}
- (NSInteger)curentMonthWeekNum
{
    CalendarMonthView * curentMonthView = (CalendarMonthView *)self.monthViewArr[1];
    NSInteger numOfWeek = curentMonthView.monthModel.dayModelArr.count / 7;
    return numOfWeek;
}
#pragma mark - 滚动结束 更新数据
-(void)scroll_end
{
    NSInteger tag = (NSInteger)self.contentScrollView.contentOffset.x/self.contentScrollView.frame.size.width;
    if (tag == 0) {
        self.pageOffSet -= 1;
    }else if (tag == 2) {
        self.pageOffSet += 1;
    }
    [self update_calendarData];
}
#pragma mark - scrollview代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scroll_end];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scroll_end];
}
#pragma mark - monthView 选中日期回调
- (void)calendarMonthView:(CalendarMonthView *)monthView selectedDay:(DayModel *)day
{
    self.curentSelectedDay = day;
    [self callBackSelectedDay];
    
    for (int i = 0; i < self.monthViewArr.count; i ++) {
        CalendarMonthView * monthView = (CalendarMonthView *)self.monthViewArr[i];
        monthView.curentSelectedDay = self.curentSelectedDay;
    }
}
#pragma mark - monthView 点击上月/下月日期回调 isLastMonth-是否点击的上月日期
-(void)calendarMonthView:(CalendarMonthView *)monthView selectedLastOrNextMonth:(BOOL)isLastMonth
{
    if (isLastMonth) {
        [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width*2, 0) animated:YES];
    }
}
- (DayModel *)curentSelectedDay
{
    if (!_curentSelectedDay) {
        DayModel * model = [[DayModel alloc] init];
        model.year = [NSDate date_Year:[NSDate date]];
        model.month = [NSDate date_Month:[NSDate date]];
        model.day = [NSDate date_Day:[NSDate date]];
        [MHCalendarManager calculationChinaCalendarWithDay:model callBack:^(ChinaDayModel *chinaModel) {
            model.chinaModel = chinaModel;
        }];
        _curentSelectedDay = model;
    }
    return _curentSelectedDay;
}
#pragma mark - get
- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(35), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-Width(35))];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.pagingEnabled = YES;
    }
    return _contentScrollView;
}
- (WeeksView *)weeksView
{
    if (!_weeksView) {
        _weeksView = [[WeeksView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), Width(35))];
    }
    return _weeksView;
}
@end
