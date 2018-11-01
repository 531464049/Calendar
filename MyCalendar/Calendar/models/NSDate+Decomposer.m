//
//  NSDate+Decomposer.m
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "NSDate+Decomposer.h"

@implementation NSDate (Decomposer)

#pragma mark - 获取当前data对应月份的总天数
+ (NSInteger)totalDaysOfMonth:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}
#pragma mark - 获得当前 NSDate 对象对应月份当月第一天的所属星期
+ (NSInteger)firstWeekDayOfMonth:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 1; // 定位到当月第一天
    NSDate *weekDate = [calendar dateFromComponents:components];
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:weekDate] - 1;
    return firstWeekday;
}
#pragma mark - 获得当前 NSDate 对象对应周下标
+(NSInteger)weekForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSDate *firstDay = [calendar dateFromComponents:components];
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger weekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    return weekDay;
}
#pragma mark - 获得当前 NSDate 对象对应周几
+(NSString *)weekStrForDate:(NSDate *)date
{
    //0：周日，1：周一....
    NSInteger weekIndex = [NSDate weekForDate:date];
    
    return @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"][weekIndex];
}
#pragma mark - 该日期在一年中第几周
+(NSInteger )numOfWeekInYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
    NSInteger week = [components weekOfYear]; // 今年的第几周
    return week;
}
+ (NSDateComponents*)currentDateComponents:(NSCalendarUnit)calendarUnit date:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:calendarUnit fromDate:date];
}
#pragma mark - 获得当前 NSDate 对象 几分
+ (NSInteger)date_minute:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitMinute date:date];
    return components.minute;
}
#pragma mark - 获得当前 NSDate 对象几点
+ (NSInteger)date_hour:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitHour date:date];
    return components.hour;
}
#pragma mark - 获得当前 NSDate 对象几号
+ (NSInteger)date_Day:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitDay date:date];
    return components.day;
}
#pragma mark - 获得当前 NSDate 对象对应月份
+ (NSInteger)date_Month:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitMonth date:date];
    return components.month;
}
#pragma mark - 获得当前 NSDate 对象对应年
+ (NSInteger)date_Year:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitYear date:date];
    return components.year;
}
+ (NSDateComponents *)nearByDateComponents:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 15; //定位到当月中间日子
    return components;
}
#pragma mark - 获得当前 NSDate 对象上个月某一天的date
+ (NSDate *)lastMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    NSDate *lastDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    return lastDate;
}
#pragma mark - 获得当前 NSDate 对象下个月某一天的date
+ (NSDate *)nextMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    NSDate *nextDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return nextDate;
}
#pragma mark - 年月 返回date
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month
{
    return [NSDate dateWithYear:year month:month day:1];
}
#pragma mark - 年月日 返回date
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.year = year;
    components.month = month;
    components.day = day;
    
    NSDate *resultDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    return resultDate;
}
#pragma mark - 年月日 时分 返回date
+(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minate:(NSInteger)minate
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minate;
    
    NSDate *resultDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    return resultDate;
}
#pragma mark - 该date对应正点 8点
+(NSDate *)OnTimeWithYmdDate:(NSDate *)ymdDate
{
    NSDate * resultDate = [NSDate dateWithYear:[NSDate date_Year:ymdDate] month:[NSDate date_Month:ymdDate] day:[NSDate date_Day:ymdDate] hour:8 minate:0];
    return resultDate;
}
#pragma mark - 该date对应今年日期 正点 8点
+(NSDate *)OnTimeForThisYear:(NSDate *)ymdDate
{
    NSDate * resultDate = [NSDate dateWithYear:[NSDate date_Year:[NSDate date]] month:[NSDate date_Month:ymdDate] day:[NSDate date_Day:ymdDate] hour:8 minate:0];
    return resultDate;
}
#pragma mark - 根据月份偏移量，获取偏移后的月份日期
+ (NSDate *)dateFromMonthOffSet:(NSInteger)offSet
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.month = offSet;
    
    
    NSDate *resultDate = [calendar dateByAddingComponents:components toDate:date options:NSCalendarMatchStrictly];
    return resultDate;
}
#pragma mark -  当前时间 下一小时整点
+(NSDate *)dateForNextHour
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.hour = 1;
    
    NSDate *resultDate = [calendar dateByAddingComponents:components toDate:date options:NSCalendarMatchStrictly];
    
    NSDate * aDate = [NSDate dateWithYear:[NSDate date_Year:resultDate] month:[NSDate date_Month:resultDate] day:[NSDate date_Day:resultDate] hour:[NSDate date_hour:resultDate] minate:0];
    
    return aDate;
}
#pragma mark - 当前date对应前后三个月的monthModel
+(NSArray *)nearByMonthForDate:(NSDate *)date
{
    NSDate *last = [NSDate lastMonthDate:date];
    NSDate *next = [NSDate nextMonthDate:date];
    
    MonthModel *currentMonth = [MonthModel monthWithDate:date];
    MonthModel *lastMonth = [MonthModel monthWithDate:last];
    MonthModel *nextMonth = [MonthModel monthWithDate:next];
    
    return @[lastMonth,currentMonth,nextMonth];
}
#pragma mark - 当前年对应月 天数
+(NSInteger)daysNumOfMonth:(NSInteger)month andYear:(NSInteger)year
{
    if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        return 31;
    if((month == 4)||(month == 6)||(month == 9)||(month == 11))
        return 30;
    if(year%4==0 && year%100!=0)//普通年份，非100整数倍
        return 29;
    if(year%400 == 0)//世纪年份
        return 29;
    return 28;
}
#pragma mark - 根据月 日 计算星座
+(NSString *)getXingZuoWithMonth:(NSInteger )m day:(NSInteger )d
{    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return nil;
    }
    if(m==2 && d>29){
        return nil;
    }
    else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return nil;
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return [NSString stringWithFormat:@"%@座",result];;
    
}
#pragma mark - 计算日期 天干地支+农历日月
+(NSString *)LunarForSolar:(NSDate *)solarDate{
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray  arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) %12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString*)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}
#pragma mark - 将日期格式化成字符串
-(NSString *)dateToStrFor:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}
#pragma mark - 获取当前时间戳字符串
+(NSString *)getCurentTimestamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%f", time];
}
#pragma mark - 日期对比
+ (int)compareOneDay:(NSDate *)date1 withAnotherDay:(NSDate *)date2
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *currentDayStr = [dateFormatter stringFromDate:date1];
    NSString *BaseDayStr = [dateFormatter stringFromDate:date2];
    NSDate *dateA = [dateFormatter dateFromString:currentDayStr];
    NSDate *dateB = [dateFormatter dateFromString:BaseDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //NSLog(@"date1 : %@, date2 : %@", date1, date2);
    if (result == NSOrderedDescending) {
        //DLog(@"date1  大于 date2");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //DLog(@"date1  小于 date2");
        return -1;
    }
    return 0;
}
#pragma mark - 格式化时间date 2018年8月23日 周三 23:34
+(NSString *)dateFomt_Y_M_D_Week_hour_minate:(NSDate *)date
{
    NSInteger year = [NSDate date_Year:date];
    NSInteger month = [NSDate date_Month:date];
    NSInteger day = [NSDate date_Day:date];
    NSInteger hour = [NSDate date_hour:date];
    NSInteger minate = [NSDate date_minute:date];
    NSString * weekStr = [NSDate weekStrForDate:date];
    
    NSString * resultStr = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@ %02ld:%02ld",year,month,day,weekStr,hour,minate];
    return resultStr;
}
#pragma mark - 两个日期之间相隔天数
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}
#pragma mark - 当前日期 num 年后的日期
+(NSDate *)dateForYearRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.year = num;
    
    NSDate *resultDate = [calendar dateByAddingComponents:components toDate:baseDate options:NSCalendarMatchStrictly];
    return resultDate;
}
#pragma mark - 当前日期 num 年后的日期
+(NSDate *)dateForMonthRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.month = num;
    
    NSDate *resultDate = [calendar dateByAddingComponents:components toDate:baseDate options:NSCalendarMatchStrictly];
    return resultDate;
}
#pragma mark - 当前日期 num 日后的日期
+(NSDate *)dateForDayRepeatBaseDate:(NSDate *)baseDate repeatNum:(NSInteger)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.day = num;
    
    NSDate *resultDate = [calendar dateByAddingComponents:components toDate:baseDate options:NSCalendarMatchStrictly];
    return resultDate;
}
#pragma mark - 当前日期 num 天后的日期
+(NSDate *)dateForNextThreeMonth
{
    return [NSDate dateForMonthRepeatBaseDate:[NSDate date] repeatNum:3];
}
@end
