//
//  MHCalendarManager.m
//  HzCalendar
//
//  Created by 马浩 on 2018/8/30.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHCalendarManager.h"

@interface MHCalendarManager()

@property(nonatomic,strong)NSArray * chineseYears;
@property(nonatomic,strong)NSArray * chineseMonths;
@property(nonatomic,strong)NSArray * chineseDays;
@property(nonatomic,strong)NSDictionary * Holidays;//公历节日

@property (nonatomic, strong) NSDateFormatter * strDateFormatter;
@property (nonatomic, strong) NSDate * baseDate;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@end

@implementation MHCalendarManager

+ (instancetype)defaultManager
{
    static MHCalendarManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[MHCalendarManager alloc]init];
    });
    return obj;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentDate = [NSDate date];
        _currentDay = [NSDate date_Day:self.currentDate];
        _currentMonth = [NSDate date_Month:self.currentDate];
        _currentYear = [NSDate date_Year:self.currentDate];
    }
    return self;
}
- (NSArray *)lunarYearArr
{
    if (!_lunarYearArr) {
        _lunarYearArr = [MHCalendarManager readLunarYearJson];
    }
    return _lunarYearArr;
}
- (NSDateFormatter *)strDateFormatter
{
    if (!_strDateFormatter) {
        _strDateFormatter = [[NSDateFormatter alloc] init];
        [_strDateFormatter setDateFormat:@"MM-dd"];
    }
    return _strDateFormatter;
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}
- (NSDate *)baseDate
{
    if (!_baseDate) {
        _baseDate = [self.dateFormatter dateFromString:@"1900-1-1"];
    }
    return _baseDate;
}
- (NSArray *)chineseYears
{
    if (!_chineseYears) {
        _chineseYears = @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
    }
    return _chineseYears;
}
- (NSArray *)chineseMonths
{
    if (!_chineseMonths) {
        _chineseMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                           @"九月", @"十月", @"冬月", @"腊月"];
    }
    return _chineseMonths;
}
- (NSArray *)chineseDays
{
    if (!_chineseDays) {
        _chineseDays = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    }
    return _chineseDays;
}
- (NSDictionary *)Holidays
{
    if (!_Holidays) {
        _Holidays = @{@"01-01":@"元旦",@"02-14":@"情人节",@"03-08":@"妇女节",@"03-12":@"植树节",@"04-01":@"愚人节",@"05-01":@"劳动节",@"05-04":@"青年节",@"06-01":@"儿童节",@"07-01":@"建党节",@"08-01":@"建军节",@"09-10":@"教师节",@"10-01":@"国庆节",@"12-24":@"平安夜",@"12-25":@"圣诞节"};
    }
    return _Holidays;
}
#pragma mark - 计算二十四节气的具体日期
/**
 * @param year 年份
 * @param index 节气索引，0代表小寒，1代表大寒，其它节气按照顺序类推
 */
- (NSString *)calculationSolarTermsWithYear:(NSUInteger)year solarTermsIndex:(NSUInteger)index
{
    NSString * solarTerms = @"";
    CGFloat base = 365.242 * (year - 1900) + 6.2 + (15.22 * index) - (1.9 * sinf(0.262 * index));// 计算积日
    NSInteger hours = (base - 1) * 24;// 由于基准日为1900年1月0日，所以这里需要-1
    NSDate * date = [NSDate dateWithTimeInterval:hours * 60 * 60 sinceDate:self.baseDate];
    solarTerms = [self.strDateFormatter stringFromDate:date];
    return solarTerms;
}
#pragma mark - 根据日历页面滑动偏移量 获取当前需要展示的三个月数据
+(void)getMonthsDataFromPageOffSet:(NSInteger)pageOffSet callBack:(void (^)(NSArray<MonthModel *> *))callBack
{
    NSDate * curentDate = [NSDate dateFromMonthOffSet:pageOffSet];
    NSDate * lastDate = [NSDate dateFromMonthOffSet:pageOffSet-1];
    NSDate * nextDate = [NSDate dateFromMonthOffSet:pageOffSet+1];
    NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:0];
    [MHCalendarManager getMonthDateFromDate:lastDate callBack:^(MonthModel *monthModel) {
        [resultArr addObject:monthModel];
    }];
    [MHCalendarManager getMonthDateFromDate:curentDate callBack:^(MonthModel *monthModel) {
        [resultArr addObject:monthModel];
    }];
    [MHCalendarManager getMonthDateFromDate:nextDate callBack:^(MonthModel *monthModel) {
        [resultArr addObject:monthModel];
    }];
    
    NSArray * backArr = [NSArray arrayWithArray:resultArr];
    callBack(backArr);
}
#pragma mark - 根据日期信息 获取日期对应的monthModel
+(void)getMonthDateFromDate:(NSDate *)date callBack:(void (^)(MonthModel *))callBack
{
    NSArray *nearByMonths = [NSDate nearByMonthForDate:date];
    if (nearByMonths.count != 3) {
        MonthModel *currentMonth = [MonthModel monthWithDate:date];
        callBack(currentMonth);
        return;
    }
    
    NSMutableArray *daysArray = [NSMutableArray arrayWithCapacity:2];
    //获取本月相近的前后两月信息
    MonthModel * lastMonth = [nearByMonths objectAtIndex:0];
    MonthModel * nextMonth = [nearByMonths objectAtIndex:2];
    MonthModel * currentMonth = [nearByMonths objectAtIndex:1];
    
    //显示上一月天数
    NSInteger showLastMonthDays = currentMonth.firstWeekday;
    //还剩对少天没有满一星期
    NSInteger lastWeekDays = (currentMonth.totalDays-(7-showLastMonthDays))%7;
    //显示下一月天数
    NSInteger showNextMonthDays = 7- (lastWeekDays!=0? lastWeekDays:7);
    
    //获取日历第一个星期含有上月末尾日期 lastMonth
    for(int i = 0;i < showLastMonthDays ;i++) {
        DayModel *dayModel = [[DayModel alloc]init];
        dayModel.isCurentMonth = NO;
        dayModel.isCurentDay = NO;
        dayModel.year = lastMonth.year;
        dayModel.month = lastMonth.month;
        dayModel.day = lastMonth.totalDays-showLastMonthDays+i+1;
        [daysArray addObject:dayModel];
    }
    //获取日历本月的日期  currentMonth
    for (int i = 0;i<currentMonth.totalDays ;i++) {
        DayModel *dayModel = [[DayModel alloc]init];
        dayModel.isCurentMonth = YES;
        dayModel.year = currentMonth.year;
        dayModel.month = currentMonth.month;
        dayModel.day = i+1;
        //判断日期是否为当前日期
        dayModel.isCurentDay = [MHCalendarManager isCurentDay:dayModel];
        [daysArray addObject:dayModel];
    }
    //获取日历最后一星期含有下月的日期 nextMonth
    for(int i = 0;i < showNextMonthDays ;i++) {
        DayModel *dayModel = [[DayModel alloc]init];
        dayModel.isCurentMonth = NO;
        dayModel.isCurentDay = NO;
        dayModel.year = nextMonth.year;
        dayModel.month = nextMonth.month;
        dayModel.day = i+1;
        [daysArray addObject:dayModel];
    }
    
    for (DayModel * model in daysArray) {
        [MHCalendarManager calculationChinaCalendarWithDay:model callBack:^(ChinaDayModel *chinaModel) {
            model.chinaModel = chinaModel;
        }];
    }
    currentMonth.dayModelArr = [NSArray arrayWithArray:daysArray];
    callBack(currentMonth);
}
#pragma mark - 根据dayModel 获取农历+节假日+节气信息 完整的dayModel
+(void)calculationChinaCalendarWithDay:(DayModel *)dayModel callBack:(void (^)(ChinaDayModel *))callBack
{
    if (dayModel.chinaModel && dayModel.chinaModel.chineseYear.length > 0 && dayModel.chinaModel.chineseMonth.length > 0 && dayModel.chinaModel.chineseDay.length > 0) {
        //这个model里边已经存在农历信息了，直接返回就可以
        callBack(dayModel.chinaModel);
        return;
    }
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",dayModel.year,dayModel.month,dayModel.day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
//    NSString * sss = [NSDate LunarForSolar:date];
//    NSLog(@"%@",sss);
    
    if (!date) {
        callBack(nil);
        return;
    }
    ChinaDayModel * chinaModel = [ChinaDayModel new];
    
    NSCalendar * localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents * localeComp = [localeCalendar components:unitFlags fromDate:date];


    //农历信息
    chinaModel.chineseYear = [MHCalendarManager.defaultManager.chineseYears objectAtIndex:localeComp.year - 1];
    NSString * m_str = [MHCalendarManager.defaultManager.chineseMonths objectAtIndex:localeComp.month - 1];
    NSString * d_str = [MHCalendarManager.defaultManager.chineseDays objectAtIndex:localeComp.day - 1];
    
    chinaModel.chineseMonth = m_str;
    chinaModel.chineseDay = d_str;
    
    if (localeComp.isLeapMonth) {
        //闰月 初一
        if ([d_str isEqualToString:@"初一"]) {
            chinaModel.chineseMonth = [NSString stringWithFormat:@"闰%@",m_str];
        }
    }
    
    // 农历节日
    if([MHCalendarManager.defaultManager.chineseMonths containsObject:m_str] && [d_str isEqualToString:@"初一"]) {
        if ([m_str isEqualToString:@"正月"] && [d_str isEqualToString:@"初一"]) {
            chinaModel.chineseHoliday = @"春节";
        }
    } else if ([m_str isEqualToString:@"正月"] && [d_str isEqualToString:@"十五"]) {
        chinaModel.chineseHoliday = @"元宵节";
    } else if ([m_str isEqualToString:@"五月"] && [d_str isEqualToString:@"初五"]) {
        chinaModel.chineseHoliday = @"端午节";
    } else if ([m_str isEqualToString:@"七月"] && [d_str isEqualToString:@"初七"]) {
        chinaModel.chineseHoliday = @"七夕";
    } else if ([m_str isEqualToString:@"七月"] && [d_str isEqualToString:@"十五"]) {
        chinaModel.chineseHoliday = @"中元节";
    } else if ([m_str isEqualToString:@"八月"] && [d_str isEqualToString:@"十五"]) {
        chinaModel.chineseHoliday = @"中秋节";
    } else if ([m_str isEqualToString:@"九月"] && [d_str isEqualToString:@"初九"]) {
        chinaModel.chineseHoliday = @"重阳节";
    } else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"初八"]) {
        chinaModel.chineseHoliday = @"腊八节";
    } else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"廿三"]) {
        chinaModel.chineseHoliday = @"小年";
    } else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"三十"]) {
        chinaModel.chineseHoliday = @"除夕";
    }

    
    //公历节日
    NSString * nowStr = [MHCalendarManager.defaultManager.strDateFormatter stringFromDate:date];
    NSArray * array = [MHCalendarManager.defaultManager.Holidays allKeys];
    if([array containsObject:nowStr]) {
        chinaModel.otherHoliday = [MHCalendarManager.defaultManager.Holidays objectForKey:nowStr];
    }
    // 公历礼拜节日
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    NSInteger unit = NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    comps = [calendar components:unit fromDate:date];
    NSUInteger month = [comps month];
    NSUInteger dayInMonth = [comps day];
    switch (month) {
        case 5:
            if (dayInMonth == 14) {
                chinaModel.otherHoliday = @"母亲节";
            }
            break;
        case 6:
            if (dayInMonth == 21) {
                chinaModel.otherHoliday = @"父亲节";
            }
            break;
        case 11:
            if (dayInMonth == 26) {
                chinaModel.otherHoliday = @"感恩节";
            }
            break;
        default:
            break;
    }
    
    // 二十四节气, 将节气按月份拆开计算，否则由于计算积日所需日期转换stringFromDate方法过于耗时将会造成线程卡顿
    NSString * solarTerms = @"";
    switch (dayModel.month) {// 过滤月份
        case 1:
            for (NSInteger i = 0; i < 2; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 0:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"小寒";
                        }
                        break;
                    case 1:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"大寒";
                        }
                        break;
                }
            }
            break;
        case 2:
            for (NSInteger i = 2; i < 4; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 2:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"立春";
                        }
                        break;
                    case 3:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"雨水";
                        }
                        break;
                }
            }
            break;
        case 3:
            for (NSInteger i = 4; i < 6; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 4:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"惊蛰";
                        }
                        break;
                    case 5:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"春分";
                        }
                        break;
                }
            }
            break;
        case 4:
            for (NSInteger i = 6; i < 8; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 6:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"清明";
                        }
                        break;
                    case 7:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"谷雨";
                        }
                        break;
                }
            }
            break;
        case 5:
            for (NSInteger i = 8; i < 10; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 8:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"立夏";
                        }
                        break;
                    case 9:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"小满";
                        }
                        break;
                }
            }
            break;
        case 6:
            for (NSInteger i = 10; i < 12; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 10:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"芒种";
                        }
                        break;
                    case 11:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"夏至";
                        }
                }
            }
            break;
        case 7:
            for (NSInteger i = 12; i < 14; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 12:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"小暑";
                        }
                        break;
                    case 13:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"大暑";
                        }
                    break;
                }
            }
            break;
        case 8:
            for (NSInteger i = 14; i < 16; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 14:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"立秋";
                        }
                        break;
                    case 15:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"处暑";
                        }
                        break;
                }
            }
            break;
        case 9:
            for (NSInteger i = 16; i < 18; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 16:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"白露";
                        }
                        break;
                    case 17:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"秋分";
                        }
                        break;
                }
            }
            break;
        case 10:
            for (NSInteger i = 18; i < 20; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 18:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"寒露";
                        }
                        break;
                    case 19:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"霜降";
                        }
                        break;
                }
            }
            break;
        case 11:
            for (NSInteger i = 20; i < 22; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 20:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"立冬";
                        }
                        break;
                    case 21:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"小雪";
                        }
                        break;
                }
            }
            break;
        case 12:
            for (NSInteger i = 22; i < 24; i ++) {
                solarTerms = [MHCalendarManager.defaultManager calculationSolarTermsWithYear:dayModel.year solarTermsIndex:i];
                switch (i) {
                    case 22:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"大雪";
                        }
                        break;
                    case 23:
                        if ([solarTerms isEqualToString:nowStr]) {
                            chinaModel.solarTerms = @"冬至";
                        }
                        break;
                }
            }
            break;
    }
    
    callBack(chinaModel);
}
#pragma mark - 是否是当前日期
+(BOOL)isCurentDay:(DayModel *)dayModel
{
    if (dayModel.year != [NSDate date_Year:[NSDate date]]) {
        return NO;
    }
    if (dayModel.month != [NSDate date_Month:[NSDate date]]) {
        return NO;
    }
    if (dayModel.day != [NSDate date_Day:[NSDate date]]) {
        return NO;
    }
    return YES;
}
+(NSArray *)readLunarYearJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lunarYearInfo" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!jsonString) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *yearArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return yearArr;
}
+(NSArray *)lunarMonthsArrForYear:(NSInteger)year
{
    NSInteger index = year - 1901;//最小年份是1901
    if (index < 0 || index > 148-1) {
        //最多148年的数据
        return nil;
    }
    NSDictionary * infoDic = (NSDictionary *)MHCalendarManager.defaultManager.lunarYearArr[index];
    NSInteger lunarYear = [infoDic[@"year"] integerValue];
    if (lunarYear == year) {
        NSArray * monthsArr = (NSArray *)infoDic[@"month"];
        return monthsArr;
    }
    return nil;
}
@end




























