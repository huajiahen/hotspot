//
//  NSDate+ZQ.h
//  WHU Mobile
//
//  Created by 黄 嘉恒 on 7/18/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

@import Foundation;

@interface NSDate (ZQ)

+ (NSCalendar *)calendar;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (NSInteger)weeksBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

- (NSDateComponents *)dateComponents;

@end
