//
//  ZQHotspot.h
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQEmergency.h"
#import "ZQEvent.h"
@import MapKit;
@import CoreLocation;

#define kLocationDidChangedNotification @"LocationDidChanged"

typedef NS_ENUM(NSInteger, ZQHotspotMonitoringType) {
    ZQHotspotMonitoringTypeDefault = 0,
    ZQHotspotMonitoringTypeSignificant
};

@interface ZQHotspot : NSObject

@property (nonatomic, weak)MKMapView *mapView;
@property (nonatomic, strong)NSOperationQueue *operationQueue;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic)ZQHotspotMonitoringType monitoringType;

@property (nonatomic, strong)NSArray *emergencies;
@property (nonatomic, strong)NSArray *events;

+ (ZQHotspot *)sharedHotspot;

- (void)postEmergency:(ZQEmergency *)emergency;
- (void)postEvent:(ZQEvent *)event;
- (void)refreshData;
- (void)refreshDataWithLocation:(CLLocation *)location;

@end
