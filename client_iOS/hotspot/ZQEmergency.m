//
//  ZQEmergency.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQEmergency.h"

@implementation ZQEmergency

@synthesize coordinate = _coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.content = dictionary[@"content"];
        self.start = [NSDate dateWithTimeIntervalSinceReferenceDate:[dictionary[@"starttime"] integerValue]];
        self.coordinate = CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue], [dictionary[@"longitude"] doubleValue]) ;
    }
    return self;
}

- (NSString *)title
{
    return self.content;
}

@end
