//
//  NSDate+ZQ.m
//  WHU Mobile
//
//  Created by 黄 嘉恒 on 7/18/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "NSDate+ZQ.h"

@implementation NSDate (ZQ)

static NSCalendar *_calendar;

+ (NSCalendar *)calendar
{
    if (!_calendar)
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return _calendar;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [self calendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return [difference day];
}

+ (NSInteger)weeksBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [self calendar];
    
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSWeekCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference week];
}

- (NSDateComponents *)dateComponents
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSQuarterCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSCalendarCalendarUnit;
    NSDateComponents *dateComponents = [[NSDate calendar] components:unitFlags fromDate:self];
    return dateComponents;
}

@end
