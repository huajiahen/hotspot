//
//  ZQEventListViewController.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/17/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQEventListViewController.h"
#import "ZQHotspot.h"
#import "ZQEventCreateViewController.h"
#import "UIImage+ImageEffects.h"
#import "NSDate+ZQ.h"

@interface ZQEventListViewController ()

@end

@implementation ZQEventListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *view = self.presentingViewController.view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,
                                           YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *lightImage = [newImage applyLightEffect];
    self.view.backgroundColor = [UIColor colorWithPatternImage:lightImage];

    UIBarButtonItem *createEventBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showEventCreateViewController)];
    [self.navigationItem setRightBarButtonItem:createEventBarButton animated:NO];
    
    UIBarButtonItem *closeEventListBarButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self.delegate action:@selector(dismissEventListViewController)];
    [self.navigationItem setLeftBarButtonItem:closeEventListBarButton animated:NO];
    
    self.title = @"活动列表";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[ZQHotspot sharedHotspot].events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (!cell) {
     UITableViewCell   *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
//    }
    ZQEvent *event = [ZQHotspot sharedHotspot].events[indexPath.row];
    cell.textLabel.text = event.content;
    NSDateComponents *start = [event.start dateComponents];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i-%i   %@",start.month, start.day, event.address];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


- (IBAction)showEventCreateViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZQEventCreateViewController *eventCreateViewController = [storyboard instantiateViewControllerWithIdentifier:@"EventCreateViewController"];
    eventCreateViewController.delegate = self;
    
    [self.navigationController pushViewController:eventCreateViewController animated:YES];
}

- (void)dismissEventCreateViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
