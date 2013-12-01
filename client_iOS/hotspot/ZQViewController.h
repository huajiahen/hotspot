//
//  ZQViewController.h
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;

@interface ZQViewController : UIViewController

@property (nonatomic, strong)IBOutlet MKMapView *mapView;
- (void)dismissEmergencyCreateViewController;
- (void)dismissEventListViewController;

@end
