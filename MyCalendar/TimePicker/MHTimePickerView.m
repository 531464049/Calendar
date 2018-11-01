//
//  MHTimePickerView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHTimePickerView.h"
#import "MHTimePicker.h"
@interface MHTimePickerView ()<MHTimePickerDelegate>

@property(nonatomic,copy)pickerCallBack callBack;

@property(nonatomic,strong)UIControl * hidenControl;//灰色遮罩
@property(nonatomic,strong)UIView * contentView;//内容容器
@property(nonatomic,strong)UISegmentedControl * segMent;//分段选择器
@property(nonatomic,strong)UILabel * curentTimeLab;//当前选中时间lab
@property(nonatomic,strong)UIButton * remindBtn;//是否提醒按钮
@property(nonatomic,strong)MHTimePicker * picker;//时间选择器
@property(nonatomic,strong)UIButton * cancleBtn;//取消按钮
@property(nonatomic,strong)UIButton * sureBtn;//确定按钮

@property(nonatomic,strong)NSDate * curentSelectedDate;//当前选中日期
@property(nonatomic,assign)BOOL needRemoindOption;//是否需要提醒/不提醒按钮
@property(nonatomic,assign)BOOL needRemind;//是否需要提醒 - 默认需要
@property(nonatomic,assign)DayPickerType  pickType;//日期选择格式


@end

@implementation MHTimePickerView
-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date needOption:(BOOL)need callBack:(pickerCallBack)callBack;
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!date) {
            date = [NSDate date];
        }
        self.callBack = callBack;
        self.curentSelectedDate = date;
        self.needRemind = YES;
        self.needRemoindOption = need;
        self.pickType = DayPickerTypeSolar;
        [self commit_ui];
    }
    return self;
}
-(void)commit_ui
{
    self.hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    self.hidenControl.backgroundColor = HexRGBAlpha(0x000000, 0.35);
    [self addSubview:self.hidenControl];
    
    //picker上边的高度
    CGFloat topHeight = Width(10) + Width(30) + Width(44) + Width(5);
    if (self.needRemoindOption) {
        topHeight = topHeight + Width(42) + Width(15);
    }
    //picker的高度
    CGFloat pickHeight = Width(164);
    CGFloat contentHeight = topHeight + pickHeight + Width(50);

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - Width(33)*2, contentHeight)];
    self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.contentView.backgroundColor = HexRGBAlpha(0xffffff, 1);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    
    //农历-公历
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
    
    //当前选中时间
    self.curentTimeLab = [UILabel labTextColor:HexRGBAlpha(0x666666, 1) font:FONT(15) aligent:NSTextAlignmentCenter];
    self.curentTimeLab.frame = CGRectMake(Width(15), CGRectGetMaxY(self.segMent.frame), CGRectGetWidth(self.contentView.frame) - Width(30), Width(44));
    [self.contentView addSubview:self.curentTimeLab];
    //更新当前选中时间
    [self updateCurentSelectedTime];
    
    if (self.needRemoindOption) {
        //需要提醒/不提醒按钮
        CGFloat itemWidth = Width(248);
        CGFloat margin = (CGRectGetWidth(self.contentView.frame) - itemWidth) / 2;
        self.remindBtn = [UIButton buttonWithType:0];
        [self.remindBtn setTitle:@"不提醒" forState:0];
        self.remindBtn.titleLabel.font = FONT(17);
        self.remindBtn.frame = CGRectMake(margin, CGRectGetMaxY(self.curentTimeLab.frame), itemWidth, Width(42));
        [self.remindBtn addTarget:self action:@selector(remingItemSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.remindBtn];
        [self updateRemindItemState];
    }
    
    //picker
    self.picker = [[MHTimePicker alloc] initWithFrame:CGRectMake(0, topHeight, CGRectGetWidth(self.contentView.frame), pickHeight) date:self.curentSelectedDate];
    self.picker.delegate = self;
    [self.contentView addSubview:self.picker];
    
    self.cancleBtn = [UIButton buttonWithType:0];
    [self.cancleBtn setTitle:@"取消" forState:0];
    [self.cancleBtn setTitleColor:HexRGBAlpha(0xbbbbbb, 1) forState:0];
    self.cancleBtn.titleLabel.font = FONT(18);
    self.cancleBtn.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - Width(50), CGRectGetWidth(self.contentView.frame)/2, Width(50));
    [self.cancleBtn addTarget:self action:@selector(cancle_item_selected) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancleBtn];
    
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
    
    [self.contentView mh_alertShowAnimation];
}
#pragma mark - 分段选择器 改变
- (void)segment_selected:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        DLog(@"公历");
        self.pickType = DayPickerTypeSolar;
    } else {
        DLog(@"农历");
        self.pickType = DayPickerTypeLunar;
    }
    [self.picker updateDayPickType];
}
#pragma mark - 更新当前选中时间
-(void)updateCurentSelectedTime
{
    NSInteger year = [NSDate date_Year:self.curentSelectedDate];
    NSInteger month = [NSDate date_Month:self.curentSelectedDate];
    NSInteger day = [NSDate date_Day:self.curentSelectedDate];
    NSInteger our = [NSDate date_hour:self.curentSelectedDate];
    NSInteger minate = [NSDate date_minute:self.curentSelectedDate];
    self.curentTimeLab.text = [NSString stringWithFormat:@"%ld年%ld月%ld日  %ld:%ld",year,month,day,our,minate];
}
#pragma mark - 选择器选中日期回调
-(void)timePicker:(MHTimePicker *)picker selectedDate:(NSDate *)selectedDate
{
    self.curentSelectedDate = selectedDate;
    [self updateCurentSelectedTime];
}
#pragma mark - 提醒按钮点击
-(void)remingItemSelected
{
    self.needRemind = !self.needRemind;
    [self updateRemindItemState];
}
#pragma mark - 更新提醒按钮状态
-(void)updateRemindItemState
{
    if (self.needRemind) {
        [self.remindBtn setTitleColor:HexRGBAlpha(0x999999, 1) forState:0];
        self.remindBtn.layer.cornerRadius = 3;
        self.remindBtn.layer.masksToBounds = YES;
        self.remindBtn.layer.borderColor = HexRGBAlpha(0xcccccc, 1).CGColor;
        self.remindBtn.layer.borderWidth = 1;
    }else{
        [self.remindBtn setTitleColor:HexRGBAlpha(0xde3d2e, 1) forState:0];
        self.remindBtn.layer.cornerRadius = 3;
        self.remindBtn.layer.masksToBounds = YES;
        self.remindBtn.layer.borderColor = HexRGBAlpha(0xde3d2e, 1).CGColor;
        self.remindBtn.layer.borderWidth = 1;
    }
}
#pragma mark - 确定按钮点击
-(void)sure_sure
{
    if (self.callBack) {
        self.callBack(self.needRemind, self.pickType, self.curentSelectedDate);
    }
    [self cancle_item_selected];
}
#pragma mark - 取消按钮点击
-(void)cancle_item_selected
{
    [self.contentView mh_alertHidenAnimation];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showTimePickerWithCallBack:(pickerCallBack)callback
{
    [MHTimePickerView showTimepickerWithDate:[NSDate date] needRemindOption:NO callback:callback];
}
+(void)showTimePickerWithDate:(NSDate *)date callBack:(pickerCallBack)callback
{
    [MHTimePickerView showTimepickerWithDate:date needRemindOption:NO callback:callback];
}
+(void)showTimepickerWithDate:(NSDate *)date needRemindOption:(BOOL)needOption callback:(pickerCallBack)callback
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    MHTimePickerView * picker = [[MHTimePickerView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) date:date needOption:needOption callBack:callback];
    [keywindow addSubview:picker];
}

@end
