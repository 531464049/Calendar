//
//  TestPickerView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/10/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "TestPickerView.h"
#import "LunarSolarModel.h"

@interface TestPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,copy)TestCallBack callBack;
@property(nonatomic,strong)UIView * contentView;//内容容器


@property(nonatomic,strong)UIButton * cancleBtn;//取消按钮
@property(nonatomic,strong)UIButton * sureBtn;//确定按钮

@property(nonatomic,assign)NSInteger selectedYearIndex;//选择的年份下标
@property(nonatomic,assign)NSInteger selectedMonthIndex;//选择的月份下标
@property(nonatomic,assign)NSInteger selectedDayIndex;//选择的日期下标

@property(nonatomic,assign)NSInteger pickerYearIndex;//picker实际选中下标
@property(nonatomic,assign)NSInteger pickerMonthIndex;//picker实际选中下标
@property(nonatomic,assign)NSInteger pickerDayIndex;//picker实际选中下标

@property (strong ,nonatomic)UIPickerView * pickerView;

@end

@implementation TestPickerView

-(instancetype)initWithFrame:(CGRect)frame callBack:(TestCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.callBack = callBack;
        [self buildUIS];
    }
    return self;
}
-(void)buildUIS
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - Width(33)*2, Width(250))];
    self.contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.contentView.backgroundColor = HexRGBAlpha(0xffffff, 1);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    
    
    
    _pickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, Width(200))];
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = HexRGBAlpha(0xf8f8f8, 1);
    [self.contentView addSubview:_pickerView];
    
    [self commit_date:[NSDate date]];
    
    
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
}
-(void)commit_date:(NSDate *)date
{
    NSInteger year = [NSDate date_Year:date];
    NSInteger month = [NSDate date_Month:date];
    NSInteger day = [NSDate date_Day:date];
 
    
    self.selectedYearIndex = year - minYear;
    if (self.selectedYearIndex > maxYearCount || self.selectedYearIndex < 0) {
        self.selectedYearIndex = 0;
    }
    self.selectedMonthIndex = month - 1;
    self.selectedDayIndex = day - 1;

    
    NSInteger dayNums = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
    
    self.pickerYearIndex = self.selectedYearIndex + maxYearCount * 100;
    self.pickerMonthIndex = self.selectedMonthIndex + 12 * 100;
    self.pickerDayIndex = self.selectedDayIndex + dayNums * 100;

    [_pickerView reloadAllComponents];
    [_pickerView selectRow:self.pickerYearIndex inComponent:0 animated:NO];
    [_pickerView selectRow:self.pickerMonthIndex inComponent:1 animated:NO];
    [_pickerView selectRow:self.pickerDayIndex inComponent:2 animated:NO];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return maxYearCount * 201;
        }
            break;
        case 1:
        {
            return 12 * 201;
        }
            break;
        case 2:
        {
            //日
            //阳历  根据年月 计算天数
            return [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex] * 201;

        }
            break;
        default:
            return 0;
            break;
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSInteger yearIndex = row % maxYearCount;
            return [NSString stringWithFormat:@"%ld年",minYear + yearIndex];
        }
            break;
        case 1:
        {
            //公历
            NSInteger monthIndex = row % 12;
            return [NSString stringWithFormat:@"%ld月",monthIndex + 1];
        }
            break;
        case 2:
        {
            //公历
            NSInteger dayNums = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
            
            NSInteger year = minYear + self.selectedYearIndex;
            NSInteger month = self.selectedMonthIndex + 1;
            NSInteger day = row % dayNums + 1;
            NSString * weekStr = [NSDate weekStrForDate:[NSDate dateWithYear:year month:month day:day]];
            return [NSString stringWithFormat:@"%ld日%@",day,weekStr];

        }
            break;
        default:
            return @"";
            break;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * pickLab = (UILabel *)view;
    if (!pickLab) {
        pickLab = [[UILabel alloc] init];
        pickLab.adjustsFontSizeToFitWidth = YES;
        pickLab.textAlignment = NSTextAlignmentCenter;
        pickLab.backgroundColor = [UIColor clearColor];
        pickLab.textColor = HexRGBAlpha(0x333333, 1);
        pickLab.font = FONT(17);
    }
    NSString * titleString = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickLab.text = titleString;
    
    for(UIView *speartorView in pickerView.subviews)    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor clearColor];//隐藏分割线
        }
    }
    
    return pickLab;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return Width(200)/3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            self.selectedYearIndex = row % maxYearCount;
            [self updateSelectedIndex];
            
            NSInteger dayNum = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
            self.pickerYearIndex = self.selectedYearIndex + maxYearCount * 100;
            self.pickerMonthIndex = self.selectedMonthIndex + 12 * 100;
            self.pickerDayIndex = self.selectedDayIndex + dayNum * 100;
            
            [_pickerView reloadAllComponents];
            [_pickerView selectRow:self.pickerYearIndex inComponent:0 animated:NO];
            [_pickerView selectRow:self.pickerMonthIndex inComponent:1 animated:NO];
            [_pickerView selectRow:self.pickerDayIndex inComponent:2 animated:NO];
            
        }
            break;
        case 1:
        {
            self.selectedMonthIndex = row % 12;
            [self updateSelectedIndex];
            
            
            NSInteger dayNum = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
            self.pickerMonthIndex = self.selectedMonthIndex + 12 * 100;
            self.pickerDayIndex = self.selectedDayIndex + dayNum * 100;
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [_pickerView selectRow:self.pickerMonthIndex inComponent:1 animated:NO];
            [_pickerView selectRow:self.pickerDayIndex inComponent:2 animated:NO];
        }
            break;
        case 2:
        {
            NSInteger dayNums = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
            self.selectedDayIndex = row % dayNums;

            self.pickerDayIndex = self.selectedDayIndex + dayNums * 100;

            [pickerView reloadComponent:2];
            [_pickerView selectRow:self.pickerDayIndex inComponent:2 animated:NO];

        }
            break;
        default:
            break;
    }
}
-(void)updateSelectedIndex
{
    if (self.selectedYearIndex > maxYearCount-1 || self.selectedYearIndex < 0) {
        self.selectedYearIndex = 0;
    }
    
    if (self.selectedMonthIndex < 0) {
        self.selectedMonthIndex = 0;
    }else if (self.selectedMonthIndex > 12 - 1) {
        self.selectedMonthIndex = 12 - 1;
    }
    
    NSInteger dayNum = [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];
    if (self.selectedDayIndex < 0) {
        self.selectedDayIndex = 0;
    }else if (self.selectedDayIndex > dayNum - 1) {
        self.selectedDayIndex = dayNum - 1;
    }
}
-(void)sure_sure
{
    
    [self cancle_item_selected];
}
-(void)cancle_item_selected
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)show:(TestCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    TestPickerView * picker = [[TestPickerView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) callBack:callBack];
    [keywindow addSubview:picker];
}

@end
