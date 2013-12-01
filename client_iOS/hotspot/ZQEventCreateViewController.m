//
//  ZQEventCreateViewController.m
//  hotspot
//
//  Created by 黄 嘉恒 on 11/16/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQEventCreateViewController.h"
#import "ZQEvent.h"
#import "ZQHotspot.h"
#import "UIImage+ImageEffects.h"

@interface ZQEventCreateViewController ()

@property (nonatomic, weak)IBOutlet UITextField *titleField;
@property (nonatomic, weak)IBOutlet UIDatePicker *startDatePicker;
@property (nonatomic, weak)IBOutlet UIDatePicker *endDatePicker;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

@property (nonatomic)BOOL editingStartDate;
@property (nonatomic)BOOL editingEndDate;

@end

@implementation ZQEventCreateViewController

@synthesize start = _start;
@synthesize end = _end;

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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = self.delegate.view.backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
 
    if (indexPath.row==2 || indexPath.row==4) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"picker" forIndexPath:indexPath];
//        
//        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"picker"];
//        }
        
        UIDatePicker *datePicker;
        for (UIView *view in [cell contentView].subviews) {
            if ([view isKindOfClass:[UIDatePicker class]]) {
                datePicker = (UIDatePicker *)view;
            }
        }
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] init];
            [cell.contentView addSubview:datePicker];
            [datePicker addTarget:self action:@selector(datePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        if (indexPath.row==2) {
            datePicker.date = self.start;
            self.startDatePicker = datePicker;
        } else if (indexPath.row==4) {
            datePicker.date = self.end;
            self.endDatePicker = datePicker;
        }
    } else if (indexPath.row==1 || indexPath.row==3) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"date" forIndexPath:indexPath];
//        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"date"];
//        }
        if (indexPath.row==1) {
            cell.textLabel.text = @"开始时间";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.start];
        } else if (indexPath.row==3) {
            cell.textLabel.text = @"结束时间";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.end];
        }
    } else if (indexPath.row==0&&indexPath.section==0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"主题";
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 7, 230, 30)];
        [cell.contentView addSubview:textField];
        self.titleField = textField;
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"提交活动";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            if (self.editingStartDate) {
                return 162;
            } else {
                return 0;
            }
        }
        if (indexPath.row==4) {
            if (self.editingEndDate) {
                return 162;
            } else {
                return 0;
            }
        }
    }
    return 44;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                [self.titleField becomeFirstResponder];
                self.editingStartDate = NO;
                self.editingEndDate = NO;
                break;
            case 1:
                self.editingStartDate = !self.editingStartDate;
                self.editingEndDate = NO;
                break;
            case 3:
                self.editingStartDate = NO;
                self.editingEndDate = !self.editingEndDate;
                break;
            default:
                break;
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        ZQEvent *event = [[ZQEvent alloc] init];
        event.content = self.titleField.text;
        event.start = self.startDatePicker.date;
        event.end = self.endDatePicker.date;
        [[ZQHotspot sharedHotspot] postEvent:event];
        
        [self.delegate dismissEventCreateViewController];
    }
}

- (IBAction)datePickerDidChanged:(UIDatePicker *)datePicker
{
    if (datePicker==self.startDatePicker) {
        self.start = datePicker.date;
    } else {
        self.end = datePicker.date;
    }
}

- (void)setStart:(NSDate *)start
{
    _start = start;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSDate *)start
{
    if (!_start) {
        _start = [NSDate date];
    }
    return _start;
}

-(void)setEnd:(NSDate *)end
{
    _end = end;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSDate *)end
{
    if (!_end) {
        _end = [NSDate date];
    }
    return _end;
}

@end
