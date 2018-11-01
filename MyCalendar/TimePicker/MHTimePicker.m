//
//  MHTimePicker.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHTimePicker.h"
#import "LunarSolarModel.h"

@interface MHTimePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,assign)DayPickerType  pickType;

@property(nonatomic,assign)NSInteger selMonthIndex;//选择的月份下标
@property(nonatomic,assign)NSInteger selDayIndex;//选择的日期下标
@property(nonatomic,assign)NSInteger selHourIndex;//选择的小时下标
@property(nonatomic,assign)NSInteger selMinuteIndex;//选择的分钟下标

@property(nonatomic,strong)NSArray * solorMonthArr;//公历月份数组
@property(nonatomic,strong)NSArray * lunarMonthArr;//农历月份数组

@property (strong ,nonatomic)UIPickerView * dayPickerView;// 月-日 选择器
@property (strong ,nonatomic)UIPickerView * timePickerView;// 时-分 选择器
@property(nonatomic,strong)UILabel * weekLab;//周几lab

@end

@implementation MHTimePicker

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!date) {
            date = [NSDate date];
        }
        self.curentSelectedDate = date;
        //默认公历显示
        self.pickType = DayPickerTypeSolar;
        self.selMonthIndex = 0;
        self.selDayIndex = 0;
        self.selHourIndex = 0;
        self.selMinuteIndex = 0;
        
        self.backgroundColor = HexRGBAlpha(0xf8f8f8, 1);
        
        _dayPickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2 - Width(20), self.frame.size.height)];
        _dayPickerView.delegate=self;
        _dayPickerView.dataSource=self;
        _dayPickerView.showsSelectionIndicator = NO;
        [self addSubview:_dayPickerView];
        
        _timePickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + Width(20), 0, self.frame.size.width/2 - Width(20), self.frame.size.height)];
        _timePickerView.delegate=self;
        _timePickerView.dataSource=self;
        _timePickerView.showsSelectionIndicator = NO;
        [self addSubview:_timePickerView];
        
        _weekLab = [UILabel labTextColor:HexRGBAlpha(0x333333, 1) font:FONT(15) aligent:NSTextAlignmentCenter];
        _weekLab.frame = CGRectMake(0, 0, Width(40), Width(20));
        _weekLab.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:_weekLab];
        _weekLab.text = @"";
        
        UILabel * lab = [UILabel labTextColor:HexRGBAlpha(0x333333, 1) font:FONT(15) aligent:NSTextAlignmentCenter];
        lab.text = @":";
        lab.frame = CGRectMake(0, 0, Width(3), Width(18));
        lab.center = CGPointMake(CGRectGetWidth(_timePickerView.frame)/2, CGRectGetHeight(_timePickerView.frame)/2);
        [_timePickerView addSubview:lab];
        
        
        [self commit_date:date];
    }
    return self;
}
#pragma mark - 获取当前选中的日期
- (NSDate *)curentSelectedDate
{
    NSDate * curentDate = [NSDate date];
    if (self.pickType == DayPickerTypeSolar) {
        //当前是公历
        PickerSolorModel * model = (PickerSolorModel *)self.solorMonthArr[self.selMonthIndex];
        NSInteger day = self.selDayIndex + 1;
        NSInteger hour = self.selHourIndex;
        NSInteger minate = self.selMinuteIndex;
        
        curentDate = [NSDate dateWithYear:model.year month:model.month day:day hour:hour minate:minate];
    }else{
        //当前是农历
        PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[self.selMonthIndex];
        NSInteger day = self.selDayIndex + 1;
        
        Lunar * lunar = [[Lunar alloc] init];
        lunar.lunarYear = (int)model.year;
        lunar.lunarMonth = (int)[PickerlunarModel get_monthIndex:model];
        lunar.lunarDay = (int)day;
        lunar.isleap = model.isLeep;
        //转换成公历
        Solar * solor = [LunarSolarModel lunarToSolar:lunar];
        
        NSInteger hour = self.selHourIndex;
        NSInteger minate = self.selMinuteIndex;
        
        curentDate = [NSDate dateWithYear:solor.solarYear month:solor.solarMonth day:solor.solarDay hour:hour minate:minate];
    }
    _curentSelectedDate = curentDate;
    return _curentSelectedDate;
}
-(void)updateDayPickType
{
    NSDate * curentDate = self.curentSelectedDate;
    if (self.pickType == DayPickerTypeLunar) {
        self.pickType = DayPickerTypeSolar;
    }else{
        self.pickType = DayPickerTypeLunar;
    }
    [self commit_date:curentDate];
}
#pragma mark - 指定时间
-(void)commit_date:(NSDate *)date
{
    NSInteger year = [NSDate date_Year:date];
    NSInteger month = [NSDate date_Month:date];
    NSInteger day = [NSDate date_Day:date];
    NSInteger hour = [NSDate date_hour:date];
    NSInteger minute = [NSDate date_minute:date];
    
    if (self.pickType == DayPickerTypeSolar) {
        //公历
        NSInteger yearindex = year - minYear;
        NSInteger monthIndex = yearindex * 12 + month - 1;
        self.selMonthIndex = monthIndex;
        self.selDayIndex = day - 1;
    }else{
        //农历
        DLog(@"农历");
        Solar * solor = [[Solar alloc] init];
        solor.solarYear = (int)year;
        solor.solarMonth = (int)month;
        solor.solarDay = (int)day;
        Lunar * lunar = [LunarSolarModel solarToLunar:solor];
        
        //先找一个大致位置
        NSInteger yearindex = lunar.lunarYear - minYear;
        NSInteger monthIndex = yearindex * 12 + lunar.lunarMonth - 1;
        //最终定位到的月份位置（在总农历月份数组中的位置）
        NSInteger theMonthIndex = 0;
        if (monthIndex > self.lunarMonthArr.count - 1) {
            //定位的位置比最大值还大，往后找
            theMonthIndex = [self get_lunarMonthIndex_commonIndex:monthIndex selecType:-1 findLunar:lunar];
        }else if (monthIndex <= 0) {
            //往前找
            theMonthIndex = [self get_lunarMonthIndex_commonIndex:monthIndex selecType:1 findLunar:lunar];
        }else{
            //定位位置在中间，判断定位的位置年份/月份
            PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[monthIndex];
            if (model.year > lunar.lunarYear) {
                //定位的年份比实际要找的年份大，从当前位置向后找
                theMonthIndex = [self get_lunarMonthIndex_commonIndex:monthIndex selecType:-1 findLunar:lunar];
            }else if (model.year < lunar.lunarYear) {
                //定位的年份比实际要找的年份小，从当前位置向前找
                theMonthIndex = [self get_lunarMonthIndex_commonIndex:monthIndex selecType:1 findLunar:lunar];
            }else{
                //定位的年份=实际要找的年份，从当前位置向两边扩散13个月找
                theMonthIndex = [self get_lunarMonthIndex_commonIndex:monthIndex selecType:0 findLunar:lunar];
            }
        }
        
        self.selMonthIndex = theMonthIndex;
        self.selDayIndex = lunar.lunarDay - 1;
    }
    //时分不需要判断
    self.selHourIndex = hour;
    self.selMinuteIndex = minute;
    
    //确认一下下标
    [self updateSelectedIndex];
    
    //刷新 更新位置
    [_dayPickerView reloadAllComponents];
    [_timePickerView reloadAllComponents];
    [_dayPickerView selectRow:self.selMonthIndex inComponent:0 animated:NO];
    [_dayPickerView selectRow:self.selDayIndex inComponent:1 animated:NO];
    [_timePickerView selectRow:self.selHourIndex inComponent:0 animated:NO];
    [_timePickerView selectRow:self.selMinuteIndex inComponent:1 animated:NO];
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
    if (self.selMonthIndex < 0) {
        self.selMonthIndex = 0;
    }
    if (self.selMonthIndex > self.lunarMonthArr.count - 1) {
        self.selMonthIndex = self.lunarMonthArr.count - 1;
    }
    
    PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[self.selMonthIndex];
    if (self.selDayIndex < 0) {
        self.selDayIndex = 0;
    }
    if (self.selDayIndex > model.dayNum - 1) {
        self.selDayIndex = model.dayNum - 1;
    }
}
#pragma mark - 确认公历日期选中下标
-(void)updateSolorSelectedIndex
{
    if (self.selMonthIndex < 0) {
        self.selMonthIndex = 0;
    }
    if (self.selMonthIndex > self.solorMonthArr.count - 1) {
        self.selMonthIndex = self.solorMonthArr.count - 1;
    }
    
    PickerSolorModel * model = (PickerSolorModel *)self.solorMonthArr[self.selMonthIndex];
    NSInteger dauNum = [NSDate daysNumOfMonth:model.month andYear:model.year];
    
    if (self.selDayIndex < 0) {
        self.selDayIndex = 0;
    }
    if (self.selDayIndex > dauNum - 1) {
        self.selDayIndex = dauNum - 1;
    }
}
#pragma mark - 定位农历月份在数组中的位置，comIndex-查找起始位置  type- [0：两边找] [1：向后找]  [-1：向前找]
-(NSInteger)get_lunarMonthIndex_commonIndex:(NSInteger)comIndex selecType:(NSInteger)type findLunar:(Lunar *)lunar
{
    NSInteger resultIndex = comIndex;
    NSString * lunarMonthName = lunarMonthsArr()[lunar.lunarMonth - 1];
    if (lunar.isleap) {
        lunarMonthName = [NSString stringWithFormat:@"闰%@",lunarMonthName];
    }
    if (type == 0) {
        //从当前位置 向两边扩散14 保险起见 稍微多一点
        NSInteger beginIndex = comIndex + 14;
        NSInteger endIndex = comIndex + 14;
        for (NSInteger i = beginIndex; i < endIndex; i ++) {
            PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[i];
            if (model.year == lunar.lunarYear && [model.monthName isEqualToString:lunarMonthName]) {
                resultIndex = i;
                break;
            }
        }
        
    }else if (type == 1) {
        //当前位置5 向后找5，6，7，8，9
        for (NSInteger i = comIndex; i < self.lunarMonthArr.count; i ++) {
            PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[i];
            if (model.year == lunar.lunarYear && [model.monthName isEqualToString:lunarMonthName]) {
                resultIndex = i;
                break;
            }
        }
    }else{
        //当前位置8 向前找8，7，6，5，4
        for (NSInteger i = comIndex; i >= 0; i --) {
            PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[i];
            if (model.year == lunar.lunarYear && [model.monthName isEqualToString:lunarMonthName]) {
                resultIndex = i;
                break;
            }
        }
    }
    return resultIndex;
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
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _dayPickerView) {
        //月-日
        if (component == 0) {
            //月
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                return self.solorMonthArr.count;
            }else{
                //农历
                return self.lunarMonthArr.count;
            }
        }else{
            //日
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                PickerSolorModel * model = (PickerSolorModel *)self.solorMonthArr[self.selMonthIndex];
                return [NSDate daysNumOfMonth:model.month andYear:model.year];
            }else{
                //农历
                PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[self.selMonthIndex];
                return model.dayNum;
            }
        }
    }else{
        //时-分
        if (component == 0) {
            //时
            return 24;
        }else{
            //分
            return 60;
        }
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _dayPickerView) {
        //月-日
        if (component == 0) {
            //月
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                PickerSolorModel * model = (PickerSolorModel *)self.solorMonthArr[row];
                return [NSString stringWithFormat:@"%ld月",model.month];
            }else{
                //农历
                PickerlunarModel * model = (PickerlunarModel *)self.lunarMonthArr[row];
                return model.monthName;
            }
        }else{
            //日
            if (self.pickType == DayPickerTypeSolar) {
                //公历
                return [NSString stringWithFormat:@"%ld日",row + 1];
            }else{
                //农历
                return lunarDaysArr()[row];
            }
        }
    }else{
        //时-分
        if (component == 0) {
            return [NSString stringWithFormat:@"%02ld",row];
        }else{
            return [NSString stringWithFormat:@"%02ld",row];
        }
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _dayPickerView) {
        if (component == 0) {
            //月
            self.selMonthIndex = row;
            [self updateSelectedIndex];
            [pickerView reloadComponent:0];
            [pickerView reloadComponent:1];
        }else{
            //日
            self.selDayIndex = row;
            [self updateSelectedIndex];
            [pickerView reloadComponent:0];
            [pickerView reloadComponent:1];
            
        }
    }else{
        if (component == 0) {
            //时
            self.selHourIndex = row;
        }else{
            //分
            self.selMinuteIndex = row;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timePicker:selectedDate:)]) {
        [self.delegate timePicker:self selectedDate:self.curentSelectedDate];
    }
}
- (NSArray *)solorMonthArr
{
    if (!_solorMonthArr) {
        _solorMonthArr = [PickerSolorModel get_allSolorMonthArr];
    }
    return _solorMonthArr;
}
- (NSArray *)lunarMonthArr
{
    if (!_lunarMonthArr) {
        _lunarMonthArr = [PickerlunarModel get_allLunarMonthArr];
    }
    return _lunarMonthArr;
}
@end

@implementation PickerSolorModel

+(NSArray *)get_allSolorMonthArr
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < maxYearCount; i ++) {
        NSInteger year = minYear + i;
        for (int j = 0; j < 12; j ++) {
            PickerSolorModel * model = [[PickerSolorModel alloc] init];
            model.year = year;
            model.month = j + 1;
            [arr addObject:model];
        }
    }
    return [NSArray arrayWithArray:arr];;
}

@end

@implementation PickerlunarModel

+(NSArray *)get_allLunarMonthArr
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in MHCalendarManager.defaultManager.lunarYearArr) {
        NSInteger year = [dic[@"year"] integerValue];
        NSArray * monthArr = (NSArray *)dic[@"month"];
        for (NSDictionary * monthDic in monthArr) {
            PickerlunarModel * model = [[PickerlunarModel alloc] init];
            model.year = year;
            model.monthName = monthDic[@"month"];
            model.dayNum = [monthDic[@"dayNum"] integerValue];
            model.isLeep = [monthDic[@"isLeep"] boolValue];
            [arr addObject:model];
        }
    }
    return [NSArray arrayWithArray:arr];
}
+(NSInteger )get_monthIndex:(PickerlunarModel *)model
{
    NSString * monthName = model.monthName;
    if ([model.monthName hasPrefix:@"闰"]) {
        monthName = [monthName stringByReplacingOccurrencesOfString:@"" withString:@""];
    }
    NSInteger monthIndex = 0;
    for (int i = 0; i < lunarMonthsArr().count; i ++) {
        NSString * name = lunarMonthsArr()[i];
        if ([name isEqualToString:monthName]) {
            monthIndex = i;
            break;
        }
    }
    monthIndex = monthIndex + 1;
    return monthIndex;
}
@end
