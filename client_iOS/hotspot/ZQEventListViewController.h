//
//  ZQEventListViewController.h
//  hotspot
//
//  Created by 黄 嘉恒 on 11/17/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQViewController.h"

@interface ZQEventListViewController : UITableViewController

@property (nonatomic, weak) ZQViewController *delegate;
- (void)dismissEventCreateViewController;

@end
