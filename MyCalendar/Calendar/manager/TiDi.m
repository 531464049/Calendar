//
//  TiDi.m
//  HzCalendar
//
//  Created by 马浩 on 2018/10/19.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "TiDi.h"

@interface TiDi ()

@property(nonatomic,strong)NSCalendar * gregorianCalendar;

@property (nonatomic, strong) NSArray *arrTian;
@property (nonatomic, strong) NSArray *arrDi;
@property (nonatomic, strong) NSArray *arrShengxiao;
@property (nonatomic, strong) NSMutableDictionary *tian;
@property (nonatomic, strong) NSMutableDictionary *di;

@end

@implementation TiDi
+(TiDi *)sharedInstance
{
    static TiDi * _app;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _app = [[TiDi alloc] init];
    });
    
    return _app;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.gregorianCalendar = calendar;
    }
    return self;
}
- (NSString *)getShengxiao:(NSDate *)date{
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    comps = [self.gregorianCalendar components:unitFlags fromDate:date];
    NSInteger year = [comps year];
    NSInteger index = (year - 4)%12;
    return self.arrShengxiao[index];
}
-(NSArray *)getTiDi:(NSDate *)date
{
    return [self tianDiDay:date];
}
- (NSArray *)tianDiDay:(NSDate *)time{
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    comps = [self.gregorianCalendar components:unitFlags fromDate:time];
    NSInteger days = [comps day];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    
    NSInteger last_year = year%100;
    NSInteger first_year = year / 100;
    NSInteger indexTian = (year - 3) % 10; //天
    NSInteger indexDi = (year - 3) % 12;    //地
    NSString * yearOfTianDi = [NSString stringWithFormat:@"%@%@", [self.tian valueForKey:[NSString stringWithFormat:@"%ld",indexTian]], [self.di valueForKey:[NSString stringWithFormat:@"%ld", indexDi]]];
    //日的天
    int g = (int) (4 * first_year + (first_year / 4) + 5 * last_year + (last_year / 4) + (3 * (month + 1) / 5) + days - 3);
    g = g % 10;
    //日的地
    int i = 0;
    if (month % 2 == 0) {
        i = 6;
    }
    int z = (int) (8 * first_year + (first_year / 4) + 5 * last_year + (last_year / 4)
                   + (3 * (month + 1) / 5) + days + 7 + i);
    z = z % 12;
    NSString * c = [NSString stringWithFormat:@"%@%@", [self.tian valueForKey:[NSString stringWithFormat:@"%d", g]], [self.di valueForKey:[NSString stringWithFormat:@"%d", z]]];//得到日的天干地支
    //计算月的天干地支
    NSString *strMonth = [NSString stringWithFormat:@"%ld月", month];
    NSString *tianGanOfYear = [self.tian valueForKey:[NSString stringWithFormat:@"%ld", indexTian]]; //获取年的天干
    //判断输入日期年的天干对应月地支的位置
    NSInteger indexOfmonth = [self indexOfmonthTable:tianGanOfYear];
    
    if ([self.monthTable.allKeys containsObject:strMonth]) {
        NSDictionary *stmpMonth = [(NSDictionary *) self.monthTable valueForKey:strMonth];
        
        NSString * yearTD = yearOfTianDi;
        NSString * monthTD = [stmpMonth valueForKey:[NSString stringWithFormat:@"%ld", indexOfmonth]];
        NSString * dayTD = c;
        
        return @[yearTD,monthTD,dayTD];
    } else {
        return nil;
    }
}


////将天干、地支数组添加到Map集合
-(void)tianDiPut:(NSMutableDictionary *)tiandi arr:(NSArray *)arr{
    for (int i = 0; i < arr.count; i++) {
        if (i != arr.count - 1) {
            
            [tiandi setValue:arr[i] forKey:[NSString stringWithFormat:@"%d", (i + 1)]];
        } else {
            [tiandi setValue:arr[arr.count - 1] forKey:@"0"];
        }
    }
}
-(NSMutableDictionary *)tian{
    if (!_tian) {
        _tian = [[NSMutableDictionary alloc] init];
        [self tianDiPut:_tian arr:self.arrTian];
    }
    return _tian;
}
-(NSMutableDictionary *)di{
    if (!_di) {
        _di = [[NSMutableDictionary alloc] init];
        [self tianDiPut:_di arr:self.arrDi];
    }
    return _di;
}

//月地支表
- (NSDictionary *)monthTable{
    NSArray <NSArray *>*arr = @[
                                @[@"丙寅月", @"戊寅月", @"庚寅月", @"壬寅月", @"甲寅月"],
                                @[@"丁卯月", @"己卯月", @"辛卯月", @"癸卯月", @"乙卯月"],
                                @[@"戊辰月", @"庚辰月", @"壬辰月", @"甲辰月", @"丙辰月"],
                                @[@"己巳月", @"辛巳月", @"癸巳月", @"乙巳月", @"丁巳月"],
                                @[@"庚午月", @"壬午月", @"甲午月", @"丙午月", @"戊午月"],
                                @[@"辛未月", @"癸未月", @"乙未月", @"丁未月", @"己未月"],
                                @[@"壬申月", @"甲申月", @"丙申月", @"戊申月", @"庚申月"],
                                @[@"癸酉月", @"乙酉月", @"丁酉月", @"己酉月", @"辛酉月"],
                                @[@"甲戌月", @"丙戌月", @"戊戌月", @"庚戌月", @"壬戌月"],
                                @[@"乙亥月", @"丁亥月", @"己亥月", @"辛亥月", @"癸亥月"],
                                @[@"丙子月", @"戊子月", @"庚子月", @"壬子月", @"甲子月"],
                                @[@"丁丑月", @"己丑月", @"辛丑月", @"癸丑月", @"乙丑月"]
                                ];
    NSArray *monthNum = @[@"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月", @"1月"];
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < arr.count; i++) {
        NSMutableDictionary *map1 = [[NSMutableDictionary alloc] init];
        for (int j = 0; j < arr[i].count; j++) {
            
            [map1 setValue:arr[i][j] forKey:[NSString stringWithFormat:@"%d", (j + 1)]];
        }
        [map setValue:map1 forKey:monthNum[i]];
    }
    return map;
}


//年的天干对应月地支的位置
- (NSInteger)indexOfmonthTable:(NSString *)tianGanOfYear{
    NSArray *tmp = @[@"", @"甲己", @"乙庚", @"丙辛", @"丁壬", @"戊癸"];
    int num = 0;
    for (int i = 0; i < tmp.count; i++) {
        if ([tmp[i] rangeOfString:tianGanOfYear].location !=NSNotFound) {
            num = i;
        }
    }
    return num;
}

-(NSArray *)arrTian{
    if (!_arrTian) {
        _arrTian = @[@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"];
    }
    return _arrTian;
}
-(NSArray *)arrDi{
    if (!_arrDi) {
        _arrDi = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    }
    return _arrDi;
}
-(NSArray *)arrShengxiao{
    if (!_arrShengxiao) {
        _arrShengxiao = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    }
    return _arrShengxiao;
}

@end
