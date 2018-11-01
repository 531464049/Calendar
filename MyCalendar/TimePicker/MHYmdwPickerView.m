//
//  MHYmdwPickerView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/10/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MHYmdwPickerView.h"
#import "LunarSolarModel.h"
#import "MHYmdwPicker.h"

@interface MHYmdwPickerView ()

@property(nonatomic,copy)YmdwPickerCallBack callBack;

@property(nonatomic,strong)UIControl * hidenControl;//灰色遮罩
@property(nonatomic,strong)UIView * contentView;//内容容器
@property(nonatomic,strong)UISegmentedControl * segMent;//分段选择器
@property(nonatomic,strong)MHYmdwPicker * picker;//时间选择器
@property(nonatomic,strong)UIButton * cancleBtn;//取消按钮
@property(nonatomic,strong)UIButton * sureBtn;//确定按钮

@property(nonatomic,strong)NSDate * curentSelectedDate;//当前选中日期
@property(nonatomic,assign)DayPickerType  pickType;//日期选择格式


@end

@implementation MHYmdwPickerView

-(instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date callBack:(YmdwPickerCallBack)callBack;
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!date) {
            date = [NSDate date];
        }
        self.callBack = callBack;
        self.curentSelectedDate = date;
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
    CGFloat topHeight = Width(10) + Width(30) + Width(15);
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

    
    self.picker = [[MHYmdwPicker alloc] initWithFrame:CGRectMake(0, Width(55), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - Width(55) - Width(50)) date:self.curentSelectedDate];
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
#pragma mark - 确定按钮点击
-(void)sure_sure
{
    NSDate * date = self.picker.curentSelectedDate;
    if (self.callBack) {
        self.callBack(self.pickType, date);
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
+(void)showYmdwPickerWithDate:(NSDate *)date callBack:(YmdwPickerCallBack)callback
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    MHYmdwPickerView * picker = [[MHYmdwPickerView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) date:date callBack:callback];
    [keywindow addSubview:picker];
}
@end
