//
//  ZQHotspot.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQHotspot.h"
#import "APService.h"

@interface ZQHotspot ()<CLLocationManagerDelegate>

@end

@implementation ZQHotspot

+ (ZQHotspot *)sharedHotspot
{
    static ZQHotspot *sharedHotspot;
    if (!sharedHotspot) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedHotspot = [ZQHotspot new];
        });
    }
    return sharedHotspot;
}

- (id)init
{
    self = [super init];
    if (self) {
        [_locationManager startUpdatingLocation];
        
        [NNCDC addObserver:self selector:@selector(receiveRemoteNotification:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    }
    return self;
}

#pragma mark - Loaction Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self refreshDataWithLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

- (void)refreshData
{
    CLLocation *location = self.locationManager.location;
    [self refreshDataWithLocation:location];
}

- (void)refreshDataWithLocation:(CLLocation *)location
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/updatelocation",kHostIP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *postBody = [NSString stringWithFormat:@"id=%@&latitude=%lf&longitude=%lf", kUserIdentifier, location.coordinate.latitude, location.coordinate.longitude];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    AFJSONRequestOperation *jsonRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict = JSON;
        NSLog(@"%@",dict);
        
        NSMutableArray *emergencies = [@[] mutableCopy];
        for (NSDictionary *emergencyJson in dict[@"near_emergency"]) {
            ZQEmergency *emergency = [[ZQEmergency alloc] initWithDictionary:emergencyJson];
            [emergencies addObject:emergency];
        }
        self.emergencies = [emergencies copy];

        NSMutableArray *events = [@[] mutableCopy];
        for (NSDictionary *eventJson in dict[@"near_event"]) {
            ZQEvent *event = [[ZQEvent alloc] initWithDictionary:eventJson];
            [events addObject:event];
        }
        self.events = [events copy];
        
        [NNCDC postNotificationName:kLocationDidChangedNotification object:self];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];
    [self.operationQueue addOperation:jsonRequestOperation];
}

- (void)postEmergency:(ZQEmergency *)emergency
{
    CLLocationCoordinate2D locationCoordinate = self.mapView.userLocation.location.coordinate;
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/emergency",kHostIP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *postBody = [NSString stringWithFormat:@"id=%@&latitude=%lf&longitude=%lf&content=%@", kUserIdentifier, locationCoordinate.latitude, locationCoordinate.longitude, emergency.content];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self refreshData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

    [self.operationQueue addOperation:requestOperation];
}

- (void)postEvent:(ZQEvent *)event
{
    CLLocationCoordinate2D locationCoordinate = self.mapView.userLocation.location.coordinate;
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/event",kHostIP];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *postBody = [NSString stringWithFormat:@"id=%@&latitude=%f&longitude=%f&content=%@&starttime=%f&endtime=%f", kUserIdentifier, locationCoordinate.latitude, locationCoordinate.longitude, event.content, [event.start timeIntervalSinceReferenceDate], [event.end timeIntervalSinceReferenceDate]];
    NSLog(@"%@",postBody);
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self refreshData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

#pragma mark - utilis


- (void)receiveRemoteNotification:(NSNotification *)notification
{
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.alertBody = @"有人在广场唱杀马特！";
    [APPSHAREAPP presentLocalNotificationNow:noti];
}

- (void)setMonitoringType:(ZQHotspotMonitoringType)monitoringType
{
    _monitoringType = monitoringType;
    if (monitoringType==ZQHotspotMonitoringTypeDefault) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    } else if (monitoringType==ZQHotspotMonitoringTypeSignificant) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

@end
