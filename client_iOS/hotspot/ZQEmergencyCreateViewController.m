//
//  ZQEmergencyCreateViewController.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQEmergencyCreateViewController.h"
#import "ZQEmergency.h"
#import "ZQHotspot.h"

@interface ZQEmergencyCreateViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) UIView *screenShot;

@end

@implementation ZQEmergencyCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.contentTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.screenShot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [self.view insertSubview:self.screenShot atIndex:0];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.screenShot removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)postEmergency:(id)sender
{
    ZQEmergency *emergency = [ZQEmergency new];
    emergency.content = self.contentTextView.text;
    [[ZQHotspot sharedHotspot] postEmergency:emergency];
    
    [self.delegate dismissEmergencyCreateViewController];
}

- (IBAction)cancelCreateEmergency:(id)sender
{
    [self.delegate dismissEmergencyCreateViewController];
}

@end
