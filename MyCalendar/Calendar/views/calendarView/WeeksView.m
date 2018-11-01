//
//  WeeksView.m
//  HzCalendar
//
//  Created by 马浩 on 2018/9/26.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "WeeksView.h"

@implementation WeeksView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexRGBAlpha(0xf6f6f6, 1);
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews
{
    CGFloat itemWidth = self.frame.size.width/7;
    CGFloat itheHeight = self.frame.size.height;
    NSArray * arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < arr.count; i ++) {
        UILabel * sub = [UILabel labTextColor:HexRGBAlpha(0x333333, 1) font:FONT(12) aligent:NSTextAlignmentCenter];
        sub.frame = CGRectMake(itemWidth*i, 0, itemWidth, itheHeight);
        sub.text = arr[i];
        [self addSubview:sub];
    }
}
@end
