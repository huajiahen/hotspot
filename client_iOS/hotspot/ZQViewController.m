//
//  ZQViewController.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQEvent.h"
#import "ZQEmergency.h"
#import "ZQEventCreateViewController.h"
#import "ZQEmergencyCreateViewController.h"
#import "ZQEventListViewController.h"
#import "ZQHotspot.h"

#define kCoordinateSpanDelta 0.00003895321

@interface ZQViewController ()<MKMapViewDelegate>

@property (nonatomic) CLLocationCoordinate2D originCoordinate;
@property (nonatomic, weak) UIButton *createEmergencyButton;
@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.mapView.rotateEnabled = NO;
//    self.mapView.scrollEnabled = NO;
    
    [ZQHotspot sharedHotspot].mapView = self.mapView;
    
    UIButton *createEmergencyButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    createEmergencyButton.center = CGPointMake(280, 60);
    createEmergencyButton.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [createEmergencyButton addTarget:self action:@selector(showEmergencyCreateViewController) forControlEvents:UIControlEventTouchUpInside];
    self.createEmergencyButton = createEmergencyButton;
    [self.view addSubview:createEmergencyButton];
    
    UIButton *showEventsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    showEventsButton.center = CGPointMake(40, SCREEN_HEIGHT-40);
    showEventsButton.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [showEventsButton addTarget:self action:@selector(showEventListViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showEventsButton];
    
    [self syncUI];
    
    [NNCDC addObserver:self selector:@selector(locationDidChanged:) name:kLocationDidChangedNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ZQHotspot sharedHotspot] refreshDataWithLocation:self.mapView.userLocation.location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)syncUI
{
    for (id annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[ZQEvent class]]) {
            if (![[ZQHotspot sharedHotspot].events containsObject:annotation]) {
                [self.mapView removeAnnotation:annotation];
            }
        } else if ([annotation isKindOfClass:[ZQEmergency class]]) {
            \
            if (![[ZQHotspot sharedHotspot].emergencies containsObject:annotation]) {
                [self.mapView removeAnnotation:annotation];
            }
        }
    }
    for (ZQEvent *event in [[ZQHotspot sharedHotspot] events]) {
        [self.mapView addAnnotation:event];
    }
    for (ZQEmergency *emergency in [[ZQHotspot sharedHotspot] emergencies]) {
        [self.mapView addAnnotation:emergency];
    }
    
    CLLocationCoordinate2D locationCoordinate = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan coordinateSpan =  MKCoordinateSpanMake(kCoordinateSpanDelta, kCoordinateSpanDelta);
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMake(locationCoordinate, coordinateSpan)];
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
    if ([annotation isKindOfClass:[ZQEvent class]]) {
        ZQEvent *event = annotation;
        annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"event"];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:event reuseIdentifier:@"event"];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [annotationView.rightCalloutAccessoryView addSubview:button];
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorGreen;
            
        } else {
            annotationView.annotation = event;
        }
    } else if ([annotation isKindOfClass:[ZQEmergency class]]) {
        ZQEmergency *emergency = annotation;
        annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"emergency"];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:emergency reuseIdentifier:@"emergency"];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [annotationView.rightCalloutAccessoryView addSubview:button];
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorPurple;
            
        } else {
            annotationView.annotation = emergency;
        }
    }
    return annotationView;
}


#pragma mark - View Transition

- (IBAction)showEmergencyCreateViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZQEmergencyCreateViewController *emergencyCreateViewController = [storyboard instantiateViewControllerWithIdentifier:@"EmergencyCreateViewController"];
    emergencyCreateViewController.delegate = self;

//    CLLocationCoordinate2D topCoordinate = [self.mapView convertPoint:CGPointMake(160, 92) toCoordinateFromView:self.view];
//    self.originCoordinate = self.mapView.userLocation.location.coordinate;
//    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(2*self.originCoordinate.latitude-topCoordinate.latitude, self.originCoordinate.longitude);
//    MKCoordinateSpan coordinateSpan =  MKCoordinateSpanMake(kCoordinateSpanDelta, kCoordinateSpanDelta);
//
//    MKCoordinateRegion region = MKCoordinateRegionMake(newCoordinate, coordinateSpan);
//    self.mapView.userTrackingMode = MKUserTrackingModeNone;
//    [self.mapView setRegion:region animated:NO];
//    self.createEmergencyButton.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{

        CGRect rect = CGRectMake(0, -180, 320, 568);
        self.view.frame = rect;
        [self presentViewController:emergencyCreateViewController animated:YES completion:^{
            
        }];
    } completion:^(BOOL finished) {
    
    }];
    
}

- (void)dismissEmergencyCreateViewController
{
    CGRect rect = CGRectMake(0, 0, 320, 568);
    self.view.frame = rect;

    [self dismissViewControllerAnimated:YES completion:^{
        
//        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
//        self.createEmergencyButton.hidden = NO;
    }];
}

- (IBAction)showEventListViewController
{
    ZQEventListViewController *viewController = [[ZQEventListViewController alloc] initWithStyle:UITableViewStylePlain];
    viewController.delegate = self;
    
    UINavigationController *navgationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navgationController animated:YES completion:^{
        
    }];
}

- (void)dismissEventListViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - utils

- (void)locationDidChanged:(NSNotification *)notification
{
    [self syncUI];
}

@end
