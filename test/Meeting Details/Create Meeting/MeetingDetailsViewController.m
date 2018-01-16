
#import "MeetingDetailsViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MeetingDetailsTableViewCell.h"
#import "THDatePickerViewController.h"
#import "SearchViewController.h"
#import "MySharedManager.h"

@interface MeetingDetailsViewController ()<UITextFieldDelegate,UITextViewDelegate,THDatePickerDelegate>

@end

@implementation MeetingDetailsViewController
{
    __weak IBOutlet UILabel *tittleLabel;
    __weak IBOutlet NSLayoutConstraint *memberTableViewHeight;
    __weak IBOutlet NSLayoutConstraint *agendeTableViewHeight;
    __weak IBOutlet UITableView *agendaTableView;
    __weak IBOutlet UITableView *membersPopoverTableView;
    __weak IBOutlet UIView *popOverView;
    __weak IBOutlet UITableView *dataTableView;
    __weak IBOutlet UIView *detailsBtnView;
    __weak IBOutlet UIView *membersBtnView;
    __weak IBOutlet UIView *agendaBtnView;
    __weak IBOutlet UIButton *submitBtn;
    int meetingDetails;
    __weak IBOutlet UIButton *menuBtn;
    BOOL submitButtonClicked;
    THDatePickerViewController * datePicker;
    NSDate * curDate;
    NSDate *startTime;
    NSDate *endTime;
    NSDateFormatter * formatter;
    UIDatePicker *startTimePicker;
    UIDatePicker *endTimePicker;
    NSInteger timeDifference;
    BOOL endTimeSelected;
    NSString *textViewText;
    MySharedManager *sharedManager;
    NSString *StakeholderCategory;
    NSString *Company;
    NSString *AssignedTo;
    NSString *Role;
    NSString *textViewTextAgenda;
    NSMutableArray *membersArray;
    NSMutableArray *agendaArray;
    NSString *catogeryString;
    NSString *comanyString;
    NSString *memberString;
    NSString *roleString;
    NSInteger oldDataIndex;
    BOOL companyIDBool;
    BOOL categoryIDBool;
    NSInteger sum;
    NSString *timeZone;
    BOOL roleNeed;
    BOOL olddata;
    NSString *modeString;
    NSString *roomString;
    NSDateFormatter *timeFormat;
    BOOL updatemember;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sharedManager = [MySharedManager sharedManager];
    dataTableView.rowHeight = UITableViewAutomaticDimension;
    agendaTableView.rowHeight = UITableViewAutomaticDimension;
    membersArray = [[NSMutableArray alloc] init];
    agendaArray = [[NSMutableArray alloc] init];
   
    textViewText = @"";
    textViewTextAgenda = @"";
    curDate = nil;
    startTime = nil;
    endTime = nil;
    roomString = nil;
    modeString = nil;
    tittleLabel.text = @"Meeting Details";

    membersBtnView.hidden = YES;
    agendaBtnView.hidden = YES;
    popOverView.hidden = YES;
    membersPopoverTableView.hidden = YES;
    agendaTableView.hidden = YES;
    detailsBtnView.hidden = NO;
    meetingDetails = 1;
    timeDifference = 0;
    sum = 0;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
     timeFormat= [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"hh:mm a"];
    startTimePicker=[[UIDatePicker alloc]init];
    startTimePicker.datePickerMode=UIDatePickerModeTime;
    
    endTimePicker=[[UIDatePicker alloc]init];
    endTimePicker.datePickerMode=UIDatePickerModeTime;

    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
  
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [dataTableView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [dataTableView addGestureRecognizer:swipeRight];
    if(_update){
        [self updateData];
        [menuBtn setImage:[UIImage imageNamed:@"BackBtn.png"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitle:@"Update" forState:UIControlStateNormal];
    }
    else{
        [self getData];
        NSDictionary *dict = @{ @"name" : [NSString stringWithFormat:@"%@",[defaults objectForKey:@"EmployeeName"]], @"role" : @"Secretary",@"nameID" : [defaults objectForKey:@"UserID"],@"roleID" : @"3"};
        [membersArray addObject:dict];
      
    }
}
-(void)backBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) viewWillAppear:(BOOL)animated{
    memberTableViewHeight.constant = 240;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self fillTheTF];
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
    [self viewDidLoad];
    }
    [dataTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";

    }
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (meetingDetails == 1) {
            [self membersClicked];
        }
        else if (meetingDetails == 2) {
            [self AgendaClicked];
        }
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (meetingDetails == 3) {
            [self membersClicked];
        }
        else if (meetingDetails == 2) {
            [self DetailsClicked];
        }
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == dataTableView) {
        if(meetingDetails == 1){
            return 7;
        }
        else if(meetingDetails == 2){
            return membersArray.count;
        }
        else if(meetingDetails == 3){
            if (agendaArray.count == 0) {
                return  1;
            }
            return agendaArray.count;
        }
    }
    else if (tableView == membersPopoverTableView){
        if (updatemember && [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"update"]) {
            return 3;
        }
        else if (roleNeed) {
            return 5;
        }
        else{
            return 4;
        }
    }
    else if (tableView == agendaTableView){
        return 3;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MeetingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == dataTableView) {
      if (meetingDetails == 2 || meetingDetails == 3) {
        return 60;
       }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    MeetingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (tableView == dataTableView) {

    if (meetingDetails == 1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Meeting Description" forIndexPath:indexPath];
            cell.meetingDescriptionTV.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                           textViewText = @"";
            }
            else{
            [cell.meetingDescriptionTV setText:textViewText];
            }
            if (submitButtonClicked) {
                if ([cell.meetingDescriptionTV.text isEqualToString:@""]) {
                    cell.meetingDescriptionIV.hidden = NO;
                }
            }
            else
                cell.meetingDescriptionIV.hidden =YES;
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Time Zone" forIndexPath:indexPath];
            cell.timeZoneTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.timeZoneTF.text = timeZone;
            
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Date" forIndexPath:indexPath];
            cell.dateTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            if (_update) {
                cell.dateTF.text = [formatter stringFromDate:curDate];
            }
            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                           cell.dateTF.text = @"";
            }
            if (submitButtonClicked) {
                if ([cell.dateTF.text isEqualToString:@""]) {
                    cell.dateIV.hidden = NO;
                }
            }
            else
                cell.dateIV.hidden =YES;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Time" forIndexPath:indexPath];
            cell.startTimeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            if (_update) {
            cell.startTimeTF.text = [timeFormat stringFromDate:startTime];
            }
            UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            [toolBar setTintColor:[UIColor grayColor]];
            UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(startTimeDone)];
            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
            [cell.startTimeTF setInputAccessoryView:toolBar];
            cell.startTimeTF.inputView = startTimePicker;

            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                cell.startTimeTF.text = @"";
            }
            if (submitButtonClicked) {
                if ([cell.startTimeTF.text isEqualToString:@""]) {
                    cell.startTimeIV.hidden = NO;
                }
            }
            else
                cell.startTimeIV.hidden =YES;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"End Time" forIndexPath:indexPath];
            cell.endTimeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);

            cell.endTimeTF.inputView = endTimePicker;
            UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            [toolBar setTintColor:[UIColor grayColor]];
            UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(endTimeDone)];
            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
            [cell.endTimeTF setInputAccessoryView:toolBar];
            if (_update) {
                cell.endTimeTF.text = [timeFormat stringFromDate:endTime];
            }
            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                cell.endTimeTF.text = @"";
            }
            if (submitButtonClicked) {
                if ([cell.endTimeTF.text isEqualToString:@""]) {
                    cell.endTimeIV.hidden = NO;
                }
            }
            else
                cell.endTimeIV.hidden =YES;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Meeting Room" forIndexPath:indexPath];
            cell.meetingRoomTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            if (_update) {
                cell.meetingRoomTF.text = roomString;
            }
            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                           cell.meetingRoomTF.text = @"";
            }
            if (submitButtonClicked) {
                if ([cell.meetingRoomTF.text isEqualToString:@""]) {
                    cell.meetingRoomIV.hidden = NO;
                }
            }
            else
                cell.meetingRoomIV.hidden =YES;
        }
        else if (indexPath.row == 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Meeting Mode" forIndexPath:indexPath];
            cell.meetingModeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            if (_update) {
                cell.meetingModeTF.text = modeString;
            }
            if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
                cell.meetingModeTF.text = @"";
                sharedManager.slideMenuSlected = @"no";
            }
            if (submitButtonClicked) {
                if ([cell.meetingModeTF.text isEqualToString:@""]) {
                    cell.meetingModeIV.hidden = NO;
                }
            }
            else
                cell.meetingModeIV.hidden =YES;
            
        }
    }
    else if(meetingDetails == 2){
        if ( indexPath.row != 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"updatemembersCell" forIndexPath:indexPath];
        }
        else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"membersCell" forIndexPath:indexPath];
        }

        cell.membersNameLabel.text = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.membersRoleLabel.text = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"role"];
    }
    else if(meetingDetails == 3){
        if (agendaArray.count == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"no data" forIndexPath:indexPath];
        }

        else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"updateagendaCell" forIndexPath:indexPath];

            cell.agendaDescriptionLabel.text = [[agendaArray objectAtIndex:indexPath.row] objectForKey:@"descripition"];
            cell.agendaRoleLabel.text =[NSString stringWithFormat:@"%@ (Mins)",[[agendaArray objectAtIndex:indexPath.row] objectForKey:@"duration"]];
        }
       
    }
 }
    if (tableView == membersPopoverTableView) {
     
        if (updatemember && [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"update"]) {
         
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Members" forIndexPath:indexPath];
                cell.memberTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.userInteractionEnabled = NO;
                memberTableViewHeight.constant = 180;
                cell.memberTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"name"];

            }
            if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Role" forIndexPath:indexPath];
                cell.roleTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                
                if (olddata) {
                    cell.roleTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"role"];
                }
                else{
                    cell.roleTF.text = roleString;
                }
            }
            if (indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Buttons" forIndexPath:indexPath];
                if (oldDataIndex == 5000) {
                    [cell.memberDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
                    cell.deleteMemberBtn.hidden = YES;
                }
                else{
                    [cell.memberDoneBtn setTitle:@"Update" forState:UIControlStateNormal];
                    cell.deleteMemberBtn.hidden = YES;
                }
            }
        }
        else if (roleNeed) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
                cell.categoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                
                if (olddata) {
                    cell.categoryTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"category"];
                }
                else {
                    cell.categoryTF.text = catogeryString;
                }
            }
            if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Company" forIndexPath:indexPath];
                cell.companyTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                
                
                if (olddata) {
                    cell.companyTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"company"];
                }
                else {
                    cell.companyTF.text = comanyString;
                }
                
            }
            if (indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Members" forIndexPath:indexPath];
                cell.memberTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.userInteractionEnabled = YES;

                if (olddata) {
                    cell.memberTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"name"];
                }
               
                else{
                    cell.memberTF.text = memberString;
                }
            }
            if (indexPath.row == 3) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Role" forIndexPath:indexPath];
                cell.roleTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                
                if (olddata) {
                    cell.roleTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"role"];
                }
                else{
                    cell.roleTF.text = roleString;
                }
            }
            if (indexPath.row == 4) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Buttons" forIndexPath:indexPath];
                if (oldDataIndex == 5000) {
                    [cell.memberDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
                    cell.deleteMemberBtn.hidden = YES;
                }
                else{
                    [cell.memberDoneBtn setTitle:@"Update" forState:UIControlStateNormal];
                    cell.deleteMemberBtn.hidden = YES;
                }
            }
        }
        else{
            memberTableViewHeight.constant = 240;

        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
            cell.categoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
          
            if (olddata) {
                cell.categoryTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"category"];
            }
            else{
                cell.categoryTF.text = catogeryString;
            }
        }
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Company" forIndexPath:indexPath];
            cell.companyTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
           

            if (olddata) {
                cell.companyTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"company"];
            }
            else{
                cell.companyTF.text = comanyString;
            }
        }
        if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Members" forIndexPath:indexPath];
            cell.memberTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.userInteractionEnabled = YES;

            if (olddata) {
                cell.memberTF.text = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"name"];
            }
          
            else{
                cell.memberTF.text = memberString;
            }
        }
      
        if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Buttons" forIndexPath:indexPath];
            if (oldDataIndex == 5000) {
                [cell.memberDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
                cell.deleteMemberBtn.hidden = YES;
            }
            else {
            [cell.memberDoneBtn setTitle:@"Update" forState:UIControlStateNormal];
            cell.deleteMemberBtn.hidden = YES;
            }
        }
        }
    }
    
    if (tableView == agendaTableView) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Description" forIndexPath:indexPath];
            cell.descriptionTV.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
           
            [cell.descriptionTV setText:textViewTextAgenda];
            if (olddata) {
                cell.descriptionTV.text = [[agendaArray objectAtIndex:oldDataIndex] objectForKey:@"descripition"];
            }
            else{
                cell.descriptionTV.text = @"";
            }

        }
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Duration" forIndexPath:indexPath];
            cell.durationTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
          
            cell.timeGapLabel.text = [NSString stringWithFormat:@"Remaining (%ld mins)",timeDifference-(long)sum];
            if (olddata) {
                cell.durationTF.text = [NSString stringWithFormat:@"%@",[[agendaArray objectAtIndex:oldDataIndex] objectForKey:@"duration"]];
            }
            else{
                cell.durationTF.text = @"";
            }

        }
        if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Button" forIndexPath:indexPath];
            if (oldDataIndex == 5000) {
                [cell.agendaDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
                cell.deleteAgendaBtn.hidden = YES;
            }
            else{
                [cell.agendaDoneBtn setTitle:@"Update" forState:UIControlStateNormal];
                cell.deleteAgendaBtn.hidden = YES;
            }
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dataTableView) {
        if (meetingDetails == 1) {
            if (indexPath.row == 0) {
                return [self heightForText:textViewText withFont:[UIFont systemFontOfSize:14] andWidth:320]+70;
            }
        }
        if (meetingDetails == 2 || meetingDetails == 3) {
                return 100;
        }
        return 80;
    }
    else if (tableView == agendaTableView) {
        if (meetingDetails == 3) {
            if (indexPath.row == 0) {
                agendeTableViewHeight.constant = 180 + [self heightForText:textViewTextAgenda withFont:[UIFont systemFontOfSize:14] andWidth:320];
                return [self heightForText:textViewTextAgenda withFont:[UIFont systemFontOfSize:14] andWidth:180]+50;
            }
        }

        return 60;
    }
     return 60;
}

- (IBAction)controlBtn:(id)sender {
    [self DetailsClicked];
}
- (IBAction)MembersBtn:(id)sender {
    [self membersClicked];
}
- (IBAction)Agenda:(id)sender {
    [self AgendaClicked];
}
-(void)DetailsClicked{
    detailsBtnView.hidden = NO;
    membersBtnView.hidden = YES;
    agendaBtnView.hidden = YES;
    popOverView.hidden = YES;
    meetingDetails = 1;
    tittleLabel.text = @"Meeting Details";
    [dataTableView reloadData];
}
-(void)membersClicked{
    detailsBtnView.hidden = YES;
    membersBtnView.hidden = NO;
    agendaBtnView.hidden = YES;
    popOverView.hidden = YES;
    meetingDetails = 2;
    tittleLabel.text = @"Meeting Members";
    [dataTableView reloadData];
}
-(void)AgendaClicked{
    detailsBtnView.hidden = YES;
    membersBtnView.hidden = YES;
    agendaBtnView.hidden = NO;
    popOverView.hidden = YES;
    meetingDetails = 3;
    tittleLabel.text = @"Meeting Agenda";
    [dataTableView reloadData];
}
- (IBAction)dateClicked:(id)sender {
    if(!datePicker)
        datePicker = [THDatePickerViewController datePicker];
    datePicker.date = [NSDate date];
    datePicker.delegate = self;
    [datePicker setAllowClearDate:NO];
    [datePicker setClearAsToday:YES];
    [datePicker setAutoCloseOnSelectDate:NO];
    [datePicker setAllowSelectionOfSelectedDate:YES];
    [datePicker setDisableYearSwitch:YES];
    [datePicker setDaysInHistorySelection:1];
    [datePicker setDaysInFutureSelection:0];
    
    [datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    [self presentSemiViewController:datePicker withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.2),
                                                              }];
}
- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
        curDate = datePicker.date;
        NSIndexPath *ip ;
        ip = [NSIndexPath indexPathForRow:2 inSection:0];
        MeetingDetailsTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];   
        
        cell.dateIV.hidden = YES;
        cell.dateTF.text = [formatter stringFromDate:curDate];
        [cell.dateTF resignFirstResponder];
        [self dismissSemiModalView];

    }


- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[formatter stringFromDate:selectedDate]);
}

- (IBAction)startBtnClicked:(id)sender {
    
    NSIndexPath *ip;
    MeetingDetailsTableViewCell *cell;
        ip = [NSIndexPath indexPathForRow:2 inSection:0];
        cell = [dataTableView cellForRowAtIndexPath:ip];
    
        if ([cell.dateTF.text isEqualToString:@""]) {
            [self showMsgAlert:@"Please select the date"];
    }
        else{

            if ([cell.dateTF.text isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
                startTimePicker.minimumDate = [NSDate date];
            }
            if (endTime != nil) {
                startTimePicker.maximumDate = endTime;
            }
            ip = [NSIndexPath indexPathForRow:3 inSection:0];
            cell = [dataTableView cellForRowAtIndexPath:ip];
            [cell.startTimeTF becomeFirstResponder];
            
        }
    
}
- (IBAction)endBtnClicked:(id)sender {
    endTimeSelected = YES;
    NSIndexPath *ip;
    MeetingDetailsTableViewCell *cell;
    ip = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [dataTableView cellForRowAtIndexPath:ip];
    if ([cell.startTimeTF.text isEqualToString:@""]) {
        [self showMsgAlert:@"Please select the Start Time"];
    }
    else{
        if (_update) {
            endTimePicker.date = curDate;
        }
        ip = [NSIndexPath indexPathForRow:4 inSection:0];
        cell = [dataTableView cellForRowAtIndexPath:ip];
        endTimePicker.minimumDate = startTime;
        [cell.endTimeTF becomeFirstResponder];
        
    }

}


- (void)startTimeDone
{
    NSIndexPath *ip;
    MeetingDetailsTableViewCell *cell;
    startTime = startTimePicker.date;
    ip = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [dataTableView cellForRowAtIndexPath:ip];
    cell.startTimeTF.text = [timeFormat stringFromDate:startTime];
    cell.startTimeIV.hidden = YES;
    [cell.startTimeTF resignFirstResponder];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute;
  
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startTime
                                                  toDate:endTime options:0];
    timeDifference = components.minute;
    NSLog(@"%ld is the time difference",timeDifference);
}
- (void)endTimeDone
{
    endTime = endTimePicker.date;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:4 inSection:0];
    MeetingDetailsTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];
    cell.endTimeTF.text = [timeFormat stringFromDate:endTime];
    cell.endTimeIV.hidden = YES;
    [cell.endTimeTF resignFirstResponder];

    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute;

    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startTime
                                                  toDate:endTime options:0];
    timeDifference = components.minute;
    NSLog(@"%ld is the time difference",timeDifference);

}


- (IBAction)MeetingModeClicked:(id)sender {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:6 inSection:0];
    MeetingDetailsTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    cell.meetingModeIV.hidden = YES;
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Remote" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.meetingModeTF.text = @"Remote";
        modeString = @"Remote";
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"FaceToFace" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.meetingModeTF.text = @"FaceToFace";
        modeString = @"FaceToFace";

        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Both" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.meetingModeTF.text = @"Both";
        modeString = @"Both";
        
    }];
    
    // add actions to our sheet
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    // bring up the action sheet
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self updateTextLabelsWithText: newString];
    return YES;
}
-(void)updateTextLabelsWithText:(NSString *)string
{
    if (meetingDetails == 1) {
        if (![string isEqualToString:@""]) {
            NSIndexPath *ip ;
            ip = [NSIndexPath indexPathForRow:0 inSection:0];
            MeetingDetailsTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];
            cell.meetingDescriptionIV.hidden = YES;
        }
        textViewText = string;
    }
    else{
        textViewTextAgenda = string;
    }
   
    
}
-(CGFloat)heightForText:(NSString*)text withFont:(UIFont *)font andWidth:(CGFloat)width
{
    CGSize constrainedSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0,0,width, requiredHeight.size.height);
    }
    return requiredHeight.size.height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (meetingDetails == 1) {
        [dataTableView beginUpdates];
        textView.frame = newFrame;
        [dataTableView endUpdates];
    }
    else{
        [agendaTableView beginUpdates];
        textView.frame = newFrame;
        [agendaTableView endUpdates];
    }
    
}
- (IBAction)addBtn:(id)sender {
    roleNeed = NO;
    companyIDBool = NO;
    categoryIDBool = NO;
    olddata = NO;
    updatemember = NO;
    oldDataIndex = 5000;
    if (meetingDetails == 2) {
        comanyString = @"";
        catogeryString = @"";
        memberString = @"";
        memberTableViewHeight.constant = 240;

        popOverView.hidden = NO;
        membersPopoverTableView.hidden = NO;
        agendaTableView.hidden = YES;
        [membersPopoverTableView reloadData];
    }
    else if (meetingDetails == 3) {
        popOverView.hidden = NO;
        membersPopoverTableView.hidden = YES;
        agendaTableView.hidden = NO;
        [agendaTableView reloadData];

    }
}
- (IBAction)membereCategoryBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    olddata = NO;

    NSIndexPath *ip ;
    MeetingDetailsTableViewCell *cell;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    comanyString = @"";
    
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    memberString = @"";
    

    sharedManager.passingMode = @"category";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    categoryIDBool = NO;
    companyIDBool = NO;
}else{
    [self showMsgAlert:NOInternetMessage];
}
}
- (IBAction)membersCompanyBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    olddata = NO;

    NSIndexPath *ip ;
    MeetingDetailsTableViewCell *cell ;
    ip = [NSIndexPath indexPathForRow:0 inSection:0];
    
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    if ([cell.categoryTF.text isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Catagory"];
    }
    else{
        sharedManager.passingMode = @"company";
        if (!categoryIDBool) {
            sharedManager.passingId = StakeholderCategory;
        }
        else{
            sharedManager.passingId = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"categoryID"];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
    }
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    memberString = @"";
    
  
    categoryIDBool = NO;
    companyIDBool = NO;
}else{
    [self showMsgAlert:NOInternetMessage];
}
}
- (IBAction)membersFindBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    olddata = NO;

    NSIndexPath *ip ;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    
    MeetingDetailsTableViewCell *cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([comanyString isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Company"];
    }
    else{
        sharedManager.passingMode = @"assignedTo";
        if (!companyIDBool) {
            sharedManager.passingId = Company;
        }
        else{
            sharedManager.passingId = [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"companyID"];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
    }
    ip = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    roleString = @"";
    companyIDBool = NO;
}else{
    [self showMsgAlert:NOInternetMessage];
}
}
- (IBAction)membersRoleBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    olddata = NO;
    NSIndexPath *ip ;
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    
    MeetingDetailsTableViewCell *cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([cell.memberTF.text isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Member"];
    }
    else{
        sharedManager.passingMode = @"role";
        sharedManager.passingId = Company;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
    }
}else{
    [self showMsgAlert:NOInternetMessage];
}
}
-(void)fillTheTF{
   
    if (sharedManager.passingString.length != 0) {
        if ([sharedManager.passingMode isEqualToString: @"category"]) {
            catogeryString = sharedManager.passingString;
            StakeholderCategory = sharedManager.passingId;
        }
        if ([sharedManager.passingMode isEqualToString: @"company"]) {
            comanyString = sharedManager.passingString;
            Company = sharedManager.passingId;
        }
        if ([sharedManager.passingMode isEqualToString: @"assignedTo"]) {
            memberString = sharedManager.passingString;
            AssignedTo = sharedManager.passingId;
        }
        if ([sharedManager.passingMode isEqualToString: @"role"]) {
            roleString = sharedManager.passingString;
            Role = sharedManager.passingId;
        }
        [self roleCell];
        [membersPopoverTableView reloadData];
       
    }

}
-(void)roleCell{
    if (updatemember && [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"update"]) {
        memberTableViewHeight.constant = 180;
    }
  else  if (memberString.length == 0) {
        if (roleNeed) {
            memberTableViewHeight.constant = 240;
            roleNeed = NO;
        }
    }
    else{
        memberTableViewHeight.constant = 300;
        roleNeed = YES;
    }

}
- (IBAction)membersDoneBtn:(id)sender {
    NSIndexPath *ip ;
    MeetingDetailsTableViewCell *cell ;
    NSString *msg = @"";
    
    ip = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([cell.roleTF.text isEqualToString:@""]) {
        msg = @"Please select role";
    }
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([cell.memberTF.text isEqualToString:@""]) {
        msg = @"Please select member";
    }
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([cell.companyTF.text isEqualToString:@""]) {
        msg = @"Please select Company";
    }
    ip = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = [membersPopoverTableView cellForRowAtIndexPath:ip];
    if ([cell.categoryTF.text isEqualToString:@""]) {
        msg = @"Please select Catagory";
    }

    if (msg.length != 0) {
        [self showMsgAlert:msg];
    }
    else{
        NSDictionary *dict;
        if (updatemember && [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"update"]) {
            dict= @{ @"name" : [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"name"], @"role" : [NSString stringWithFormat:@"%@",roleString], @"roleID" : Role,@"nameID" : [[membersArray objectAtIndex:oldDataIndex] objectForKey:@"nameID"],@"update":@"yes"};
        }
        else{
             dict = @{ @"name" : [NSString stringWithFormat:@"%@",memberString],@"nameID" : AssignedTo, @"role" : [NSString stringWithFormat:@"%@",roleString],@"roleID" : Role,@"company" : [NSString stringWithFormat:@"%@",comanyString],@"companyID" : Company ,@"category" : [NSString stringWithFormat:@"%@",catogeryString],@"categoryID" : StakeholderCategory};
        }
        if (oldDataIndex == 5000) {
            [membersArray addObject:dict];
        }
        else{
            [membersArray replaceObjectAtIndex:oldDataIndex withObject:dict];
        }
        [dataTableView reloadData];
        popOverView.hidden=YES;
    }
}
- (IBAction)cancelBtn:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    membersPopoverTableView.hidden = YES;
    popOverView.hidden = YES;
}
- (IBAction)agendaCancelBtn:(id)sender {
    agendaTableView.hidden = YES;
    popOverView.hidden = YES;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (IBAction)agendaDoneBtn:(id)sender {
    NSIndexPath *ip ;
    MeetingDetailsTableViewCell *cell ;
    NSString *msg = @"";
    NSString *description;
    NSString *duration;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [agendaTableView cellForRowAtIndexPath:ip];
    [cell.durationTF resignFirstResponder];
    if ([cell.durationTF.text isEqualToString:@""]) {
        msg = @"Please enter the duration";
    }
    else{
        duration = cell.durationTF.text;
    }
    ip = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = [agendaTableView cellForRowAtIndexPath:ip];
    if ([cell.descriptionTV.text isEqualToString:@""]) {
        msg = @"Please enter the discription";
    }
    
    else{
        description = cell.descriptionTV.text;
    }
    sum= 0;
    for (int i =0 ; i<agendaArray.count; i++) {
        sum += [[[agendaArray objectAtIndex:i] objectForKey:@"duration"] intValue];
    }
    if (oldDataIndex == 5000) {
        if ([duration integerValue] > (timeDifference-sum)) {
            msg = @"Duration of agenda is not equal";
        }
    }
    else{
        if ([duration integerValue] > (timeDifference-sum+[[[agendaArray objectAtIndex:oldDataIndex] objectForKey:@"duration"] intValue])) {
            msg = @"Duration of agenda is not equal";
        }
    }

    if (msg.length != 0) {
        [self showMsgAlert:msg];
    }
    else{
        NSDictionary *dict = @{ @"descripition" : description,@"duration" : duration};
        if (oldDataIndex == 5000) {
            [agendaArray addObject:dict];
        }
        else{
            [agendaArray replaceObjectAtIndex:oldDataIndex withObject:dict];
        }
        sum= 0;
        for (int i =0 ; i<agendaArray.count; i++) {
            sum += [[[agendaArray objectAtIndex:i] objectForKey:@"duration"] intValue];
        }
       
        [dataTableView reloadData];
        popOverView.hidden=YES;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dataTableView) {
        
        if (meetingDetails == 2 || meetingDetails == 3) {
            if (meetingDetails == 2 && indexPath.row == 0) {
                NSLog(@"test");
            }
            else if( meetingDetails == 3 && agendaArray.count == 0){
                NSLog(@"test 1");
            }
            else{
                if (_update) {
                    updatemember = YES;
                }
                
                olddata = YES;
                oldDataIndex = indexPath.row;
                companyIDBool = YES;
                categoryIDBool = YES;
                popOverView.hidden = NO;
                if (meetingDetails == 2) {

                    memberTableViewHeight.constant = 240;
                    if (!updatemember && ![[membersArray objectAtIndex:oldDataIndex] objectForKey:@"update"]) {
                    catogeryString = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"category"];
                    StakeholderCategory = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"categoryID"];
                    comanyString = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"company"];
                    Company = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"companyID"];
                        memberTableViewHeight.constant = 300;
                    }
                    memberString = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"name"];
                    AssignedTo = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"nameID"];
                    roleString = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"role"];
                    Role = [[membersArray objectAtIndex:indexPath.row] objectForKey:@"roleID"];
                    membersPopoverTableView.hidden = NO;
                    agendaTableView.hidden = YES;
                    [membersPopoverTableView reloadData];
                }
                if (meetingDetails == 3 ) {
                    textViewTextAgenda = [[agendaArray objectAtIndex:oldDataIndex] objectForKey:@"descripition"];

                    membersPopoverTableView.hidden = YES;
                    agendaTableView.hidden = NO;
                    [agendaTableView reloadData];
                }
            }
        }
    }
}

-(void)getData{
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [self showProgress];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetTimeZones?countryname=%@",BASEURL,[defaults objectForKey:@"CountryName"]]]];
       
        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if(httpResponse.statusCode == 200)
                                              {
                                                  NSError *parseError = nil;
                                                  NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  timeZone = [[dataArray objectAtIndex:0] objectForKey:@"TimeZone"];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self hideProgress];
                                                      [dataTableView reloadData];
                                                  });
                                                  
                                              }
                                              else
                                              {
                                                  NSLog(@"Error");
                                              }
                                          }];
        [dataTask resume];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}

-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:dataTableView animated:YES];
    
}

-(void)hideProgress{
    
    [MBProgressHUD hideHUDForView:dataTableView animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *ip;
    MeetingDetailsTableViewCell *cell;
    ip = [NSIndexPath indexPathForRow:5 inSection:0];
    cell = [dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.meetingRoomTF) {
        roomString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"roomString---%@",roomString);
    }
    
    return YES;
}


- (IBAction)submitBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    NSString *msg;
    msg = @"";
        if (agendaArray.count == 0) {
            msg = @"Please enter agenda";
        }
    if ( modeString == nil) {
        msg = @"Please select Meeting Mode ";
    }
    if ( roomString == nil) {
        msg = @"Please enter the Meeting Room";
    }
    if ( [timeFormat stringFromDate:endTime] == nil) {
        msg = @"Please select End Time";
    }
    if ( [timeFormat stringFromDate:startTime]  == nil) {
        msg = @"Please select Start Time ";
    }
    if ([formatter stringFromDate:curDate] == nil) {
        msg = @"Please select Date ";
    }
    if ( [textViewText isEqualToString:@""]) {
        msg = @"Please enter Meeting Description";
    }
    if ([msg isEqualToString:@""]) {
            [self submitApiCall];
    }
    else{
        [self showMsgAlert:msg];
    }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }

   
}
-(void)submitApiCall{
  
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:textViewText forKey:@"MeetingDescription"];
    [params setObject:[defaults objectForKey:@"CountryID"] forKey:@"CountryID"];
    [params setObject:[defaults objectForKey:@"LocationID"] forKey:@"LocationID"];
    [params setObject:[formatter stringFromDate:curDate] forKey:@"RecurringStartDate"];
    [params setObject:[formatter stringFromDate:curDate]  forKey:@"RecurringEndDate"];
    [params setObject:[formatter stringFromDate:curDate]  forKey:@"MeetingDate"];
    [params setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
    [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ModifiedBy"];
    [params setObject:modeString forKey:@"Mode"];
    [params setObject:roomString forKey:@"MeetingPlace"];
    [params setObject:[timeFormat stringFromDate:startTime] forKey:@"FromTime"];
    [params setObject:[timeFormat stringFromDate:endTime] forKey:@"ToTime"];
    [params setObject:timeZone forKey:@"TimeZone"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)timeDifference] forKey:@"Duration"];
    NSMutableArray *agendaArrayDict = [[NSMutableArray alloc] init];
    for (int i = 0; i < agendaArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
       
        [dict setObject:[formatter stringFromDate:curDate] forKey:@"MeetingDate"];
        [dict setObject:[[agendaArray objectAtIndex:i] objectForKey:@"descripition"] forKey:@"AgendaDescription"];
        [dict setObject:[NSString stringWithFormat:@"%@",[[agendaArray objectAtIndex:i] objectForKey:@"duration"]] forKey:@"AgendaDuration"];
        [agendaArrayDict addObject:dict];
    }
    [params setObject:agendaArrayDict forKey:@"lstAdhocAgenda"];
    NSMutableArray *memberArrayDict = [[NSMutableArray alloc] init];
    for (int i = 0; i < membersArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
       
        [dict setObject:[formatter stringFromDate:curDate] forKey:@"MeetingDate"];
        [dict setObject:[[membersArray objectAtIndex:i] objectForKey:@"nameID"] forKey:@"UserID"];
        [dict setObject:[[membersArray objectAtIndex:i] objectForKey:@"roleID"] forKey:@"MeetingRoleID"];
        [memberArrayDict addObject:dict];
    }
    [params setObject:memberArrayDict forKey:@"lstAdhocMembers"];

    NSLog(@"post Diict ---->%@",params);

    [self showProgress];
    NSString* JsonString = [Utitlity JSONStringConv: params];
    NSLog(@"json----%@",JsonString);

    [[WebServices sharedInstance]apiAuthwithJSON:PostCreateAdhocMeeting HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
        
        NSString *error=[json valueForKey:@"error"];
        [self hideProgress];
        
        if(error.length>0){
            [self showMsgAlert:[json valueForKey:@"error_description"]];
            return ;
        }else{
            if(json.count==0){
                [self showMsgAlert:@"Error , Try Again"];
            }else{
                sharedManager.slideMenuSlected = @"yes";
                [self viewDidLoad];
                [dataTableView reloadData];
//                if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
//
//                }
//                    NSLog(@"json-----%@",json);

                    [self showMsgAlert:[json objectForKey:@"CreateAdhocMeetingResult"]];
//
            }
        }
        
    }];

}
-(void)updateData{
    if([Utitlity isConnectedTointernet]){
        
        [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@GETAdhocMeetingDetailsByMeetingtypeId?meetingtypeid=%@&date=%@", BASEURL,sharedManager.passingId,sharedManager.passingString];
        NSLog(@"targetUrl=====%@",targetUrl);

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",dataArray);
              
              NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];

              textViewText = [[dataArray objectAtIndex:0] objectForKey:@"MeetingDescription"];
              [dateFormatter setDateFormat:@"dd MMM yyyy"];
              curDate = [dateFormatter dateFromString:[[dataArray objectAtIndex:0] objectForKey:@"MeetingDate"]];
              modeString = [[dataArray objectAtIndex:0] objectForKey:@"Mode"];
              roomString = [[dataArray objectAtIndex:0] objectForKey:@"MeetingPlace"];
              [dateFormatter setDateFormat:@"mm/dd/yyyy hh:mm:ss a"];
              startTime = [dateFormatter dateFromString:[[dataArray objectAtIndex:0] objectForKey:@"FromTime"]];
              endTime = [dateFormatter dateFromString:[[dataArray objectAtIndex:0] objectForKey:@"ToTime"]];
              timeZone = [[dataArray objectAtIndex:0] objectForKey:@"TimeZone"];
              NSCalendar *gregorian = [[NSCalendar alloc]
                                       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
              NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute;
              
              NSDateComponents *components = [gregorian components:unitFlags
                                                          fromDate:startTime
                                                            toDate:endTime options:0];
              timeDifference = components.minute;
              NSLog(@"%ld is the time difference",timeDifference);
               for (int i = 0; i < [[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocMembers"] count]; i++) {
                   NSDictionary *dict= @{ @"name" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocMembers"] objectAtIndex:i] objectForKey:@"EmpName"], @"role" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocMembers"] objectAtIndex:i] objectForKey:@"RoleDescription"], @"roleID" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocMembers"] objectAtIndex:i] objectForKey:@"RoleID"],@"nameID" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocMembers"] objectAtIndex:i] objectForKey:@"UserID"],@"update":@"yes"};
                  [membersArray addObject:dict];
              }
              for (int i = 0; i < [[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocAgenda"] count]; i++) {
              NSDictionary *dict = @{ @"descripition" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocAgenda"] objectAtIndex:i] objectForKey:@"AgendaDescription"],@"duration" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstAdhocAgenda"] objectAtIndex:i] objectForKey:@"AgendaDuration"]};
                  [agendaArray addObject:dict];
                  }
              NSLog(@"agendaArray------%@",agendaArray);
              sum= 0;
              for (int i =0 ; i<agendaArray.count; i++) {
                  sum += [[[agendaArray objectAtIndex:i] objectForKey:@"duration"] intValue];
              }
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgress];
                  [dataTableView reloadData];
              });
              
          }] resume];
        
        
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)UpdateDeleteMemberBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the Member" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:dataTableView];
                             NSIndexPath *indexPath = [dataTableView indexPathForRowAtPoint:buttonPosition];
                             [membersArray removeObjectAtIndex:indexPath.row];
                             [dataTableView reloadData];
                             
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

 

}
- (IBAction)updateDeleteAgendaBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the Member" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:dataTableView];
                             NSIndexPath *indexPath = [dataTableView indexPathForRowAtPoint:buttonPosition];
                             [agendaArray removeObjectAtIndex:indexPath.row];
                             sum= 0;
                             for (int i =0 ; i<agendaArray.count; i++) {
                                 sum += [[[agendaArray objectAtIndex:i] objectForKey:@"duration"] intValue];
                             }
                             
                             [dataTableView reloadData];

                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)deleteMemberBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the Member" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             membersPopoverTableView.hidden = YES;
                             popOverView.hidden = YES;
                             if (olddata) {
                                 [membersArray removeObjectAtIndex:oldDataIndex];
                                 [dataTableView reloadData];
                                 [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

                             }
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
  
}
- (IBAction)deleteAgendaBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the Agenda" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             agendaTableView.hidden = YES;
                             popOverView.hidden = YES;
                             if (oldDataIndex != 5000) {
                                 [agendaArray removeObjectAtIndex:oldDataIndex];
                                 sum= 0;
                                 for (int i =0 ; i<agendaArray.count; i++) {
                                     sum += [[[agendaArray objectAtIndex:i] objectForKey:@"duration"] intValue];
                                 }
                                 [dataTableView reloadData];
                                 [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
                             }
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
   
}
@end
