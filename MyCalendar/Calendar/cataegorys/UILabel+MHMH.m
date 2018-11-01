//
//  UILabel+MHMH.m
//  MyCalendar
//
//  Created by 马浩 on 2018/10/25.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "UILabel+MHMH.h"

@implementation UILabel (MHMH)

+(UILabel *)labTextColor:(UIColor *)textColor font:(UIFont *)font aligent:(NSTextAlignment)aligent
{
    UILabel * lab = [[UILabel alloc] init];
    lab.textColor = textColor;
    lab.font = font;
    lab.textAlignment = aligent;
    lab.numberOfLines = 1;
    return lab;
}

@end
