//
//  AddActionTableViewController.m
//  test
//
//  Created by ceaselez on 29/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "AddActionTableViewController.h"
#import "CustomTableViewCell.h"
#import "SearchViewController.h"
#import "MySharedManager.h"
#import "THDatePickerViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
@interface AddActionTableViewController ()<UITextFieldDelegate,UITextViewDelegate,THDatePickerDelegate>

@end

@implementation AddActionTableViewController
{
    IBOutlet UITableView *dataTableView;
    MySharedManager *sharedManager;
    NSString *StakeholderCategory;
    NSString *Company;
    NSString *AssignedTo;
    THDatePickerViewController * datePicker2;
    NSDate * curDate;
    THDatePickerViewController * datePicker1;
    NSDate * curDate1;
    NSDateFormatter * formatter;
    int employeeType;
    int actionType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    sharedManager = [MySharedManager sharedManager];
    curDate = [NSDate date];
    curDate1 = [NSDate date];

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    

}

- (IBAction)targetDate:(id)sender {
    if(!datePicker1)
        datePicker1 = [THDatePickerViewController datePicker];
    datePicker1.date = curDate1;
    datePicker1.delegate = self;
    [datePicker1 setAllowClearDate:NO];
    [datePicker1 setClearAsToday:YES];
    [datePicker1 setAutoCloseOnSelectDate:NO];
    [datePicker1 setAllowSelectionOfSelectedDate:YES];
    [datePicker1 setDisableYearSwitch:YES];
    //[self.datePicker setDisableFutureSelection:NO];
    [datePicker1 setDaysInHistorySelection:1];
    [datePicker1 setDaysInFutureSelection:0];
    
    [datePicker1 setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker1 setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker1 setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [datePicker1 setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:datePicker1 withOptions:@{
                                                             KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                             KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                             }];
}
- (IBAction)btn:(id)sender {
    if(!datePicker2)
        datePicker2 = [THDatePickerViewController datePicker];
    datePicker2.date = curDate;
    datePicker2.delegate = self;
    [datePicker2 setAllowClearDate:NO];
    [datePicker2 setClearAsToday:YES];
    [datePicker2 setAutoCloseOnSelectDate:NO];
    [datePicker2 setAllowSelectionOfSelectedDate:YES];
    [datePicker2 setDisableYearSwitch:YES];
    //[self.datePicker setDisableFutureSelection:NO];
    [datePicker2 setDaysInHistorySelection:1];
    [datePicker2 setDaysInFutureSelection:0];
  
    [datePicker2 setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker2 setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker2 setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [datePicker2 setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:datePicker2 withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    if (datePicker == datePicker2) {
        curDate = datePicker2.date;
        NSIndexPath *ip ;
        if (employeeType == 1) {
            ip = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        else{
            ip = [NSIndexPath indexPathForRow:4 inSection:0];
        }
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
        cell.startDate.text = [formatter stringFromDate:curDate];
        [cell.startDate resignFirstResponder];

    }
    else{
        curDate1 = datePicker1.date;
        NSIndexPath *ip ;
        if (employeeType == 1) {
            ip = [NSIndexPath indexPathForRow:2 inSection:0];
        }
        else{
            ip = [NSIndexPath indexPathForRow:5 inSection:0];
        }
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
        cell.targetDateTF.text = [formatter stringFromDate:curDate1];
        [cell.targetDateTF resignFirstResponder];
    }
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[formatter stringFromDate:selectedDate]);
}
-(void)viewWillAppear:(BOOL)animated{
    [self fillTheTF];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (employeeType == 1) {
        return 6;
    }
    else if (employeeType == 2) {
        return 9;
    }
    else
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Employee Type" forIndexPath:indexPath];

    }
    else if (employeeType == 1) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
      
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
           
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"submit" forIndexPath:indexPath];
        }
    }
    else{
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Company" forIndexPath:indexPath];
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Assigned To" forIndexPath:indexPath];
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
           
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
           
        }
        else if (indexPath.row == 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
        }
        else if (indexPath.row == 7) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
        }
        else if (indexPath.row == 8) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"submit" forIndexPath:indexPath];
        }
    }
   
    
    return cell;
}
- (IBAction)actionTypeBtn:(id)sender {
    NSIndexPath *ip ;
    if (employeeType == 1) {
        ip = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    else{
        ip = [NSIndexPath indexPathForRow:6 inSection:0];
    }
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Normal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.actionTypeTF.text = @"Normal";
        actionType = 1;
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Critical" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.actionTypeTF.text = @"Critical";
        actionType = 2;
    }];
    [dataTableView reloadData];
    
    // add actions to our sheet
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    // bring up the action sheet
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)assignedBtn:(id)sender {
    NSIndexPath *ip ;
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    if ([cell.companyTF.text isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Company"];
    }
    else{
    sharedManager.passingMode = @"assignedTo";
    sharedManager.passingId = Company;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }
}
- (IBAction)companyBtn:(id)sender {
    NSIndexPath *ip ;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    if ([cell.categoryTF.text isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Catagory"];
    }
    else{
    sharedManager.passingMode = @"company";
    sharedManager.passingId = StakeholderCategory;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }
}
- (IBAction)categoryBtn:(id)sender {
   
    sharedManager.passingMode = @"category";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
}
- (IBAction)employeeTypeBtn:(id)sender {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Self" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        employeeType = 1;
        cell.employeeTypeTF.text = @"Self";
        [dataTableView reloadData];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        employeeType = 2;
        cell.employeeTypeTF.text = @"Other";
        [dataTableView reloadData];
    }];
    
    // add actions to our sheet
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    // bring up the action sheet
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (employeeType == 1) {
        if (indexPath.row == 4) {
            return 150;
        }
    }
    else{
        if (indexPath.row == 7) {
            return 150;
        }
    }
    return 80;
}
-(void)fillTheTF{
    if ([sharedManager.passingMode isEqualToString: @"category"]) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
        cell.categoryTF.text = sharedManager.passingString;
        StakeholderCategory = sharedManager.passingId;
    }
    if ([sharedManager.passingMode isEqualToString: @"company"]) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:2 inSection:0];
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
        cell.companyTF.text = sharedManager.passingString;
        Company = sharedManager.passingId;

    }
    if ([sharedManager.passingMode isEqualToString: @"assignedTo"]) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:3 inSection:0];
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];    // create an alert controller with action sheet appearance
        cell.assignedToTF.text = sharedManager.passingString;
        AssignedTo = sharedManager.passingId;

    }
    [dataTableView reloadData];
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Title"
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (IBAction)submitBtn:(id)sender {
    NSString *msg=@"";
    
//    if(![self isValidEmail:_emailTF.text])
//    {
//
//        msg=[NSString stringWithFormat:@"Enter a valid mail id"];
//    }
//
    if(msg.length==0)
        
    {
        if([Utitlity isConnectedTointernet]){
            if (employeeType == 1) {
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                CustomTableViewCell *cell;
                NSIndexPath *ip;
                ip = [NSIndexPath indexPathForRow:4 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:ip];
                [params setObject:cell.actionDescriptionTV.text forKey:@"ActionDescription"];
                ip = [NSIndexPath indexPathForRow:1 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:ip];
                [params setObject:cell.startDate.text forKey:@"ActionAssignDate"];
                ip = [NSIndexPath indexPathForRow:2 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:ip];
                [params setObject:cell.targetDateTF.text forKey:@"TargetDate"];
                [params setObject:[NSString stringWithFormat:@"%d",employeeType] forKey:@"EmployeeType"];
                [params setObject:[NSString stringWithFormat:@"%d",actionType] forKey:@"ActionType"];
               
                
                
                [self showProgress];
                NSString* JsonString = [Utitlity JSONStringConv: params];
                NSLog(@"json----%@",JsonString);
                
                [[WebServices sharedInstance]apiAuthwithJSON:PostMITRActionPlannerDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                    NSString*str = [NSString stringWithFormat:@"my dictionary is %@", json];

                    NSLog(@"str---%@",str);
//                    NSString *error=[json valueForKey:@"error"];
                    [self hideProgress];
                    
//                    if(error.length>0){
//                        [self showMsgAlert:[json valueForKey:@"error_description"]];
//                        return ;
//                    }else{
//                        if(json.count==0){
//                            [self showMsgAlert:@"Error , Try Again"];
//                        }else{
//                            if ([[json objectForKey:@"IsExists"] intValue]==1) {
//
//                                //                            SWRevealViewController *purchaseContr = (SWRevealViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                                //                            //menu is only an example
//                                //                            purchaseContr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                                //                            [self presentViewController:purchaseContr animated:YES completion:nil];
//
//                            }
//
//                            else{
//                                [self showMsgAlert:@"Invalid Credentials"];
//
//                            }
//                        }
//                    }
                    
                }];
            }
            else{
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            CustomTableViewCell *cell;
            NSIndexPath *ip;
           ip = [NSIndexPath indexPathForRow:7 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:ip];
            [params setObject:cell.actionDescriptionTV.text forKey:@"ActionDescription"];
            ip = [NSIndexPath indexPathForRow:4 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:ip];
            [params setObject:cell.startDate.text forKey:@"ActionAssignDate"];
            ip = [NSIndexPath indexPathForRow:5 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:ip];
            [params setObject:cell.targetDateTF.text forKey:@"TargetDate"];
            [params setObject:[NSString stringWithFormat:@"%d",employeeType] forKey:@"EmployeeType"];
            [params setObject:[NSString stringWithFormat:@"%d",actionType] forKey:@"ActionType"];
            [params setObject:StakeholderCategory forKey:@"StakeholderCategory"];
            [params setObject:Company forKey:@"Company"];
            [params setObject:AssignedTo forKey:@"AssignedTo"];

            
            [self showProgress];
            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            
            [[WebServices sharedInstance]apiAuthwithJSON:PostExtActionPlannerDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                
                NSLog(@"json---%@",json);
                NSString *error=[json valueForKey:@"error"];
                [self hideProgress];
                
                if(error.length>0){
                    [self showMsgAlert:[json valueForKey:@"error_description"]];
                    return ;
                }else{
                    if(json.count==0){
                        [self showMsgAlert:@"Error , Try Again"];
                    }else{
                        if ([[json objectForKey:@"IsExists"] intValue]==1) {
                          
//                            SWRevealViewController *purchaseContr = (SWRevealViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                            //menu is only an example
//                            purchaseContr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                            [self presentViewController:purchaseContr animated:YES completion:nil];
                            
                        }
                        
                        else{
                            [self showMsgAlert:@"Invalid Credentials"];
                            
                        }
                    }
                }
                
            }];
            }
        }else{
            [self showMsgAlert:NOInternetMessage];
        }
        
    }
    else
    {
        [self showMsgAlert:msg];
    }
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
