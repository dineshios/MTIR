//
//  MeetingDetailViewController.m
//  test
//
//  Created by ceaselez on 11/01/18.
//  Copyright © 2018 ceaselez. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "ConductMeetingTableViewCell.h"

@interface MeetingDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation MeetingDetailViewController
{
    NSArray *subTitleArray;
    NSArray *contentArray;
    NSDateFormatter *dateFormatter;
    NSDate *startDate;
    NSDate *endDate;
    NSDateFormatter *timeFormat;
    UIDatePicker *startTimePicker;
    UIDatePicker *endTimePicker;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_meetingDict);
    subTitleArray = [NSArray arrayWithObjects:@"Date :",@"Meeting Description :",@"Country :",@"Frequency :",@"From Time :",@"To Time :",@"Place :",@"Time Zone :",@"Duration (Mins) :",@"Planned/Adhoc :", nil];
    dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm/dd/yyyy hh:mm:ss a"];
    startDate =[dateFormatter dateFromString:[_meetingDict objectForKey:@"FromTime"]];
    endDate =[dateFormatter dateFromString:[_meetingDict objectForKey:@"ToTime"]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    contentArray = [NSArray arrayWithObjects:[_meetingDict objectForKey:@"MeetingDate"],[_meetingDict objectForKey:@"MeetingDescription"],[_meetingDict objectForKey:@"CountryName"],[_meetingDict objectForKey:@"FrequencyDescription"],[dateFormatter stringFromDate:startDate],[dateFormatter stringFromDate:endDate],[_meetingDict objectForKey:@"MeetingPlace"],[_meetingDict objectForKey:@"TimeZone"],[[_meetingDict objectForKey:@"Duration"] stringValue] ,[_meetingDict objectForKey:@"Adhoc"],nil];
    
    timeFormat= [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"hh:mm a"];
    startTimePicker=[[UIDatePicker alloc]init];
    startTimePicker.datePickerMode=UIDatePickerModeTime;
    endTimePicker=[[UIDatePicker alloc]init];
    endTimePicker.datePickerMode=UIDatePickerModeTime;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return 13;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConductMeetingTableViewCell *cell;
    if (indexPath.row == 0) {
    cell= [tableView dequeueReusableCellWithIdentifier:@"start" forIndexPath:indexPath];
    }
    else if (indexPath.row  == 1) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"timeContent" forIndexPath:indexPath];
        cell.detailTimeSubtitleLabel.text  = @"Actual Start Time :";
        cell.detailTimeTF.text = [dateFormatter stringFromDate:startDate];
        cell.detailTimeTF.inputView = startTimePicker;
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        startTimePicker.maximumDate = endDate;
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(startTimeDone)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [cell.detailTimeTF setInputAccessoryView:toolBar];

    }
    else if (indexPath.row  == 2) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"timeContent" forIndexPath:indexPath];
        cell.detailTimeSubtitleLabel.text  = @"Actual End Time :";
        cell.detailTimeTF.text = [dateFormatter stringFromDate:endDate];
        cell.detailTimeTF.inputView = endTimePicker;
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        endTimePicker.minimumDate = startDate;
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(endTimeDone)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [cell.detailTimeTF setInputAccessoryView:toolBar];
    }
    else{
    cell= [tableView dequeueReusableCellWithIdentifier:@"content" forIndexPath:indexPath];
    cell.detailSubtitleLabel.text = [subTitleArray objectAtIndex:indexPath.row - 3];
        cell.detailDetailsLabel.text = [contentArray objectAtIndex:indexPath.row - 3];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 44;
}
- (void)startTimeDone
{
    startDate = startTimePicker.date;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_dataTableView reloadData];
}
- (void)endTimeDone
{
    endDate = endTimePicker.date;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_dataTableView reloadData];
}
- (IBAction)startBtn:(id)sender {
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
