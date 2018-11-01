//
//  CalendarMonthView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "CalendarMonthView.h"
#import "CalendarDayCell.h"
@interface CalendarMonthView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray * dataArr;

@end

@implementation CalendarMonthView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildCollectionView];
    }
    return self;
}
-(void)buildCollectionView
{
    self.dataArr = [NSArray array];
    
    CGFloat itemWidth = self.frame.size.width / 7;

    UICollectionViewFlowLayout *  flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(itemWidth, Screen_WIDTH / 7 + Width(12))];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //注册cell
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:@"CalendarDayCellCalendarDayCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}
- (void)setMonthModel:(MonthModel *)monthModel
{
    _monthModel = monthModel;
    self.dataArr = [NSArray arrayWithArray:monthModel.dayModelArr];
    
    [self.collectionView reloadData];
}
- (void)setCurentSelectedDay:(DayModel *)curentSelectedDay
{
    _curentSelectedDay = curentSelectedDay;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarDayCellCalendarDayCell" forIndexPath:indexPath];
    DayModel * model = (DayModel *)self.dataArr[indexPath.row];
    cell.model = model;
    cell.isSelectedDay = [DayModel isSameDay:model other:self.curentSelectedDay];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayModel * model = (DayModel *)self.dataArr[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthView:selectedDay:)]) {
        [self.delegate calendarMonthView:self selectedDay:model];
    }
    
    NSInteger monthJump = 0;//0 代表当前月 -1上月 1下月
    if (self.monthModel.year > model.year) {
        //上年
        monthJump = -1;
    }else if (self.monthModel.year < model.year) {
        //下年
        monthJump = 1;
    }else {
        //当年
        if (self.monthModel.month > model.month) {
            //上月
            monthJump = -1;
        }else if (self.monthModel.month < model.month) {
            //下月
            monthJump = 1;
        }
    }
    if (monthJump == -1) {
        //上月
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthView:selectedLastOrNextMonth:)]) {
            [self.delegate calendarMonthView:self selectedLastOrNextMonth:YES];
        }
    }else if (monthJump == 1) {
        //下月
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthView:selectedLastOrNextMonth:)]) {
            [self.delegate calendarMonthView:self selectedLastOrNextMonth:NO];
        }
    }

}
@end
