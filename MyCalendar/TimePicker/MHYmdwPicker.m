//
//  MHYmdwPicker.m
//  HzCalendar
//
//  Created by 马浩 on 2018/10/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHYmdwPicker.h"
#import "LunarSolarModel.h"

@interface MHYmdwPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,assign)DayPickerType  pickType;

@property(nonatomic,assign)NSInteger selectedYearIndex;//选择的年份下标
@property(nonatomic,assign)NSInteger selectedMonthIndex;//选择的月份下标
@property(nonatomic,assign)NSInteger selectedDayIndex;//选择的日期下标

@property (strong ,nonatomic)UIPickerView * pickerView;

@property(nonatomic,strong)UILabel * weekLab;//周几lab


@end

@implementation MHYmdwPicker

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexRGBAlpha(0xf8f8f8, 1);

        //默认公历显示
        self.pickType = DayPickerTypeSolar;
        self.selectedYearIndex = 0;
        self.selectedMonthIndex = 0;
        self.selectedDayIndex = 0;
        
        _pickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - Width(64) - Width(10), self.frame.size.height)];
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
        
        _weekLab = [UILabel labTextColor:HexRGBAlpha(0x333333, 1) font:FONT(15) aligent:NSTextAlignmentCenter];
        _weekLab.frame = CGRectMake(self.frame.size.width - Width(64) - Width(10), self.frame.size.height/2 - Width(10), Width(64), Width(20));
        [self addSubview:_weekLab];
        _weekLab.text = @"";
        
        [self commit_date:date];
    }
    return self;
}
- (NSDate *)curentSelectedDate
{
    return [self get_curentSelectedDate];
}
-(void)updateDayPickType
{
    NSDate * curentDate = [self get_curentSelectedDate];
    if (self.pickType == DayPickerTypeLunar) {
        self.pickType = DayPickerTypeSolar;
    }else{
        self.pickType = DayPickerTypeLunar;
    }
    [self commit_date:curentDate];
}
#pragma mark - 获取当前选中的日期
-(NSDate *)get_curentSelectedDate
{
    NSDate * curentDate = [NSDate date];
    if (self.pickType == DayPickerTypeSolar) {
        //当前是公历
        NSInteger year = minYear + self.selectedYearIndex;
        NSInteger month = self.selectedMonthIndex + 1;
        NSInteger day = self.selectedDayIndex + 1;
        curentDate = [NSDate dateWithYear:year month:month day:day];
    }else{
        //当前是农历
        //年份 最小年份+选中的下标
        NSInteger year = minYear + self.selectedYearIndex;
        //月份 选中下标+1
        NSInteger month = self.selectedMonthIndex + 1;
        //是否是闰月 先默认no
        BOOL isLeepMonth = NO;
        
        NSArray * monthsArr = [MHCalendarManager lunarMonthsArrForYear:self.selectedYearIndex + minYear];
        NSDictionary * curentMonth = (NSDictionary *)monthsArr[self.selectedMonthIndex];
        NSString * monthNameStr = curentMonth[@"month"];
        if ([monthNameStr hasPrefix:@"闰"]) {
            //以 闰 开头的 说明当前选择的是闰月
            isLeepMonth = YES;
            //闰5月 实际需要的月份是5月
            month = month - 1;
        }
        //日期 选中日期下标+1
        NSInteger day = self.selectedDayIndex + 1;
        
        Lunar * lunar = [[Lunar alloc] init];
        lunar.lunarYear = (int)year;
        lunar.lunarMonth = (int)month;
        lunar.lunarDay = (int)day;
        lunar.isleap = isLeepMonth;
        //转换成公历
        Solar * solor = [LunarSolarModel lunarToSolar:lunar];
        //将公历转换成date
        curentDate = [NSDate dateWithYear:solor.solarYear month:solor.solarMonth day:solor.solarDay];
    }
    return curentDate;
}
#pragma mark - 指定初始时间
-(void)commit_date:(NSDate *)date
{
    NSInteger year = [NSDate date_Year:date];
    NSInteger month = [NSDate date_Month:date];
    NSInteger day = [NSDate date_Day:date];
    
    if (self.pickType == DayPickerTypeSolar) {
        //公历
        self.selectedYearIndex = year - minYear;
        if (self.selectedYearIndex > maxYearCount || self.selectedYearIndex < 0) {
            self.selectedYearIndex = 0;
        }
        self.selectedMonthIndex = month - 1;
        self.selectedDayIndex = day - 1;
    }else{
        //农历
        DLog(@"农历");
        Solar * solor = [[Solar alloc] init];
        solor.solarYear = (int)year;
        solor.solarMonth = (int)month;
        solor.solarDay = (int)day;
        
        Lunar * lunar = [LunarSolarModel solarToLunar:solor];
        //确定年份下标
        self.selectedYearIndex = lunar.lunarYear - minYear;
        //确定月份下标
        self.selectedMonthIndex = lunar.isleap ? lunar.lunarMonth + 1 - 1 : lunar.lunarMonth - 1;
        //确定日期下标
        self.selectedDayIndex = lunar.lunarDay - 1;
        
    }
    //确认一下下标
    [self updateSelectedIndex];
    
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:self.selectedYearIndex inComponent:0 animated:NO];
    [_pickerView selectRow:self.selectedMonthIndex inComponent:1 animated:NO];
    [_pickerView selectRow:self.selectedDayIndex inComponent:2 animated:NO];
}
-(void)updateSelectedIndex
{
    if (self.pickType == DayPickerTypeSolar) {
        [self updateSolorSelectedIndex];
    }else{
        [self updateLunarSelectedIndex];
    }
    //更新周几
    [self updateSelectedDayWeek];
}
#pragma mark - 确认农历日期选中下标
-(void)updateLunarSelectedIndex
{
    if (self.selectedYearIndex > maxYearCount-1 || self.selectedYearIndex < 0) {
        self.selectedYearIndex = 0;
    }
    
    NSArray * monthsArr = [MHCalendarManager lunarMonthsArrForYear:self.selectedYearIndex + minYear];
    if (self.selectedMonthIndex < 0) {
        self.selectedMonthIndex = 0;
    }else if (self.selectedMonthIndex > monthsArr.count - 1) {
        self.selectedMonthIndex = monthsArr.count - 1;
    }
    
    NSDictionary * curentMonth = (NSDictionary *)monthsArr[self.selectedMonthIndex];
    NSInteger dayNum = [curentMonth[@"dayNum"] integerValue];
    if (self.selectedDayIndex < 0) {
        self.selectedDayIndex = 0;
    }else if (self.selectedDayIndex > dayNum - 1) {
        self.selectedDayIndex = dayNum - 1;
    }
}
#pragma mark - 确认公历日期选中下标
-(void)updateSolorSelectedIndex
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
#pragma mark - 更新选中日期周几
-(void)updateSelectedDayWeek
{
    NSDate * selectedDate = self.curentSelectedDate;
    NSString * weekStr = [NSDate weekStrForDate:selectedDate];
    _weekLab.text = weekStr;
}
#pragma mark - UIPickerViewDataSoure
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            //年
            if (self.pickType == DayPickerTypeSolar) {
                //阳历
                return maxYearCount;
            }else{
                //农历
                return MHCalendarManager.defaultManager.lunarYearArr.count;
            }
        }
            break;
        case 1:
        {
            //月
            if (self.pickType == DayPickerTypeSolar) {
                //阳历 肯定12个月啊
                return 12;
            }else{
                //农历 需要判断是否闰年
                return [MHCalendarManager lunarMonthsArrForYear:self.selectedYearIndex + minYear].count;
            }
        }
            break;
        case 2:
        {
            //日
            if (self.pickType == DayPickerTypeSolar) {
                //阳历  根据年月 计算天数
                return [NSDate daysNumOfMonth:self.selectedMonthIndex+1 andYear:minYear + self.selectedYearIndex];;
            }else{
                //农历 需要判断是大月还是平月
                NSArray * monthsArr = [MHCalendarManager lunarMonthsArrForYear:self.selectedYearIndex + minYear];
                NSDictionary * curentMonth = (NSDictionary *)monthsArr[self.selectedMonthIndex];
                NSInteger dayNum = [curentMonth[@"dayNum"] integerValue];
                return dayNum;
            }
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
            return [NSString stringWithFormat:@"%ld年",minYear + row];
        }
            break;
        case 1:
        {
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                return [NSString stringWithFormat:@"%ld月",row + 1];
            }else{
                //农历
                NSArray * monthsArr = [MHCalendarManager lunarMonthsArrForYear:self.selectedYearIndex + minYear];
                NSDictionary * curentMonth = (NSDictionary *)monthsArr[row];
                return curentMonth[@"month"];
            }
        }
            break;
        case 2:
        {
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                return [NSString stringWithFormat:@"%ld日",row+1];
            }else{
                return lunarDaysArr()[row];
            }
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
    return 50;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            self.selectedYearIndex = row;
            [self updateSelectedIndex];
            [pickerView reloadComponent:0];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            self.selectedMonthIndex = row;
            [self updateSelectedIndex];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            self.selectedDayIndex = row;
            [self updateSelectedIndex];
            [pickerView reloadComponent:2];
        }
            break;
        default:
            break;
    }
}
@end
