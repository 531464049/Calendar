//
//  CalendarDayCell.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "CalendarDayCell.h"

@interface CalendarDayCell ()

@property(nonatomic,strong)UIView * bgView;//背景view 选中时显示，当天显示
@property(nonatomic,strong)UILabel * dayLab;//日期 lab 25
@property(nonatomic,strong)UILabel * nongliLab;//农历 节气 节日 lab 初一
@property(nonatomic,strong)UILabel * ban_xiu_lab;//班 休 lab

@end

@implementation CalendarDayCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        self.bgView.center = CGPointMake(width/2, height/2);
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.hidden = YES;
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        self.dayLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(24) aligent:NSTextAlignmentCenter];
        self.dayLab.numberOfLines = 1;
        self.dayLab.frame = CGRectMake(0, 0, width, Width(7) + Width(18));
        self.dayLab.center = CGPointMake(width/2, Width(16) + Width(18)/2);
        [self addSubview:self.dayLab];
        
        self.nongliLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(10) aligent:NSTextAlignmentCenter];
        self.nongliLab.numberOfLines = 1;
        self.nongliLab.frame = CGRectMake(0, CGRectGetMaxY(self.dayLab.frame), width, Width(7) + Width(10));
        [self addSubview:self.nongliLab];
        
        self.ban_xiu_lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(9) aligent:NSTextAlignmentCenter];
        self.ban_xiu_lab.numberOfLines = 1;
        self.ban_xiu_lab.hidden = YES;
        self.ban_xiu_lab.frame = CGRectMake(width-Width(14), 0, Width(14), Width(9) + Width(10));
        [self addSubview:self.ban_xiu_lab];
    }
    return self;
}
-(void)setModel:(DayModel *)model
{
    _model = model;
    
    self.bgView.hidden = YES;
    self.bgView.backgroundColor = [UIColor clearColor];
    
    self.dayLab.text = [NSString stringWithFormat:@"%ld",model.day];
    self.nongliLab.text = [DayModel dayCellShowChinaText:model];
    self.ban_xiu_lab.text = @"休";
    self.ban_xiu_lab.hidden = YES;
    
    if (model.isCurentMonth) {
        //当前月
        self.dayLab.textColor = HexRGBAlpha(0x333333, 1);
        self.nongliLab.textColor = [DayModel dayCellShowChinaTextColor:model];
        self.ban_xiu_lab.textColor = HexRGBAlpha(0x1db736, 1);
    }else{
        //非当前月份
        self.dayLab.textColor = HexRGBAlpha(0xbbbbbb, 1);
        self.nongliLab.textColor = HexRGBAlpha(0xbbbbbb, 1);
        self.ban_xiu_lab.textColor = HexRGBAlpha(0xbbbbbb, 1);
    }
    if (model.isCurentDay) {
        //当前日期
        self.bgView.hidden = NO;
        self.bgView.backgroundColor = HexRGBAlpha(0xf2f2f2, 1);
    }
}
- (void)setIsSelectedDay:(BOOL)isSelectedDay
{
    _isSelectedDay = isSelectedDay;
    if (_model.isCurentMonth && isSelectedDay) {
        self.bgView.hidden = NO;
        self.bgView.backgroundColor = HexRGBAlpha(0xde3d2e, 1);
        self.dayLab.textColor = HexRGBAlpha(0xffffff, 1);
        self.nongliLab.textColor = HexRGBAlpha(0xffffff, 1);
        self.ban_xiu_lab.textColor = HexRGBAlpha(0xffffff, 1);
    }
//    if (isSelectedDay) {
//        self.bgView.hidden = NO;
//        self.bgView.backgroundColor = HexRGBAlpha(0xde3d2e, 1);
//        self.dayLab.textColor = HexRGBAlpha(0xffffff, 1);
//        self.nongliLab.textColor = HexRGBAlpha(0xffffff, 1);
//        self.ban_xiu_lab.textColor = HexRGBAlpha(0xffffff, 1);
//    }
}
@end
