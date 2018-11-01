//
//  MHDayPickerView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHDayPickerView.h"
#import "MHDayPicker.h"

@interface MHDayPickerView ()

@property(nonatomic,copy)void (^callBack)(NSDate * selectedDate);

@property(nonatomic,strong)UIControl * hidenControl;//灰色遮罩
@property(nonatomic,strong)UIView * contentView;//内容容器
@property(nonatomic,strong)UISegmentedControl * segMent;//分段选择器
@property(nonatomic,strong)MHDayPicker * picker;//时间选择器
@property(nonatomic,strong)UIButton * backTodayBtn;//回到今天
@property(nonatomic,strong)UIButton * sureBtn;//确定按钮

@property(nonatomic,strong)NSDate * beginDate;//初始选中日期

@end

@implementation MHDayPickerView

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date callBack:(void(^)(NSDate * selectedDate))callBack;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.callBack = callBack;
        self.beginDate = date;
        
        [self commit_ui];
    }
    return self;
}
-(void)commit_ui
{
    self.hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    self.hidenControl.backgroundColor = HexRGBAlpha(0x000000, 0.35);
    [self.hidenControl addTarget:self action:@selector(hiden_hiden_back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hidenControl];
    
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - Width(33)*2, Width(270))];
    self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.contentView.backgroundColor = HexRGBAlpha(0xffffff, 1);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    
    self.segMent = [[UISegmentedControl alloc] initWithItems:@[@"公历",@"农历"]];
    self.segMent.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)/2 - Width(65), Width(10), Width(65)*2, Width(30));
    self.segMent.layer.cornerRadius = 8;
    self.segMent.layer.masksToBounds = YES;
    self.segMent.layer.borderColor = HexRGBAlpha(0xde3d2e, 1).CGColor;
    self.segMent.layer.borderWidth = 1;
    self.segMent.tintColor = HexRGBAlpha(0xde3d2e, 1);
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:HexRGBAlpha(0xde3d2e, 1),NSForegroundColorAttributeName,FONT(15),NSFontAttributeName ,nil];
    [self.segMent setTitleTextAttributes:dic forState:UIControlStateNormal];
    // 设置初始选中项
    self.segMent.selectedSegmentIndex = 0;
    [self.segMent addTarget:self action:@selector(segment_selected:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    [self.contentView addSubview:self.segMent];
    
    self.picker = [[MHDayPicker alloc] initWithFrame:CGRectMake(0, Width(55), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - Width(55) - Width(50)) date:self.beginDate];
    [self.contentView addSubview:self.picker];
    
    self.backTodayBtn = [UIButton buttonWithType:0];
    [self.backTodayBtn setTitle:@"回到今天" forState:0];
    [self.backTodayBtn setTitleColor:HexRGBAlpha(0xbbbbbb, 1) forState:0];
    self.backTodayBtn.titleLabel.font = FONT(18);
    self.backTodayBtn.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - Width(50), CGRectGetWidth(self.contentView.frame)/2, Width(50));
    [self.backTodayBtn addTarget:self action:@selector(back_to_today) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.backTodayBtn];
    
    self.sureBtn = [UIButton buttonWithType:0];
    [self.sureBtn setTitle:@"确定" forState:0];
    [self.sureBtn setTitleColor:HexRGBAlpha(0xde3d2e, 1) forState:0];
    self.sureBtn.titleLabel.font = FONT(18);
    self.sureBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)/2, CGRectGetHeight(self.contentView.frame) - Width(50), CGRectGetWidth(self.contentView.frame)/2, Width(50));
    [self.sureBtn addTarget:self action:@selector(sure_sure) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, Width(25))];
    line.center = CGPointMake(CGRectGetWidth(self.contentView.frame)/2, CGRectGetHeight(self.contentView.frame) - Width(25));
    line.backgroundColor = HexRGBAlpha(0xdddddd, 1);
    [self.contentView addSubview:line];
    
    [self mh_alertShowAnimation];
}
-(void)mh_alertShowAnimation
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
}
#pragma mark - 分段选择器 改变
- (void)segment_selected:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        DLog(@"公历");
    } else {
        DLog(@"农历");
    }
    [self.picker updateDayPickType];
}
#pragma mark - 回到今天
-(void)back_to_today
{
    [self.picker backToToday];
}
#pragma mark - 确定
-(void)sure_sure
{
    NSDate * date = self.picker.curentSelectedDate;
    DLog(@"选中日期：%ld-%ld-%ld",[NSDate date_Year:date],[NSDate date_Month:date],[NSDate date_Day:date]);
    if (self.callBack) {
        self.callBack(date);
    }
    [self hiden_hiden_back];
}
-(void)hiden_hiden_back
{
    [self.contentView mh_alertHidenAnimation];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showDayPickerCallBack:(void (^)(NSDate *))callback
{
    [MHDayPickerView showDayPickerWidthDate:[NSDate date] callBack:callback];
}
+(void)showDayPickerWidthDate:(NSDate *)date callBack:(void (^)(NSDate *))callback
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    MHDayPickerView * picker = [[MHDayPickerView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) date:date callBack:callback];
    [keywindow addSubview:picker];
}


@end
