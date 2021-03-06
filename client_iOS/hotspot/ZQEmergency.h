//
//  ZQEmergency.h
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface ZQEmergency : NSObject<MKAnnotation>

@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSDate *start;
@property (nonatomic, strong)NSArray *participators;
@property (nonatomic)CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
