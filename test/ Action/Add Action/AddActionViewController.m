#import "AddActionViewController.h"
#import "CustomTableViewCell.h"
#import "SearchViewController.h"
#import "MySharedManager.h"
#import "THDatePickerViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "UIView+Toast.h"

@interface AddActionViewController ()<UITextFieldDelegate,UITextViewDelegate,THDatePickerDelegate>

@end

@implementation AddActionViewController
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
    BOOL dateGap;
    BOOL clearData;
    BOOL submitButtonClicked;
    
    NSString *actionForString;
    NSString *stakeholderCategoryString;
    NSString *companyString;
    NSString *assignedToString;
    NSString *startDateString;
    NSString *targetDateCategoryString;
    NSString *actionTypeString;
    NSString *textViewText;
    NSString *ActionplannerID;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataTableView.rowHeight = UITableViewAutomaticDimension;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    sharedManager = [MySharedManager sharedManager];
    curDate = [NSDate date];
    curDate1 = [NSDate date];
    formatter = [[NSDateFormatter alloc] init];
    if (_update) {
        [self loadDataFromApi];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    submitButtonClicked = NO;
    if (clearData) {
        [self clearTF];
    }
    [self fillTheTF];
  
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";
    }
}
- (IBAction)targetDate:(id)sender {
    dateGap = YES;

    if(!datePicker1)
    datePicker1 = [THDatePickerViewController datePicker];
    datePicker1.date = curDate1;
    datePicker1.delegate = self;
    [datePicker1 setAllowClearDate:NO];
    [datePicker1 setClearAsToday:YES];
    [datePicker1 setAutoCloseOnSelectDate:NO];
    [datePicker1 setAllowSelectionOfSelectedDate:YES];
    [datePicker1 setDisableYearSwitch:YES];
    [datePicker1 setDaysInHistorySelection:1];
    [datePicker1 setDaysInFutureSelection:0];

    [datePicker1 setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker1 setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker1 setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [datePicker1 setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    [self presentSemiViewController:datePicker1 withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.2),
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
    [datePicker2 setDaysInHistorySelection:1];
    [datePicker2 setDaysInFutureSelection:0];
    
    [datePicker2 setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker2 setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker2 setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [datePicker2 setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    [self presentSemiViewController:datePicker2 withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                              KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.2),
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
        CustomTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];
        NSDate *startDate = curDate1;
        NSDate *endDate = curDate;
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        if (components.day <=0 || !(dateGap)) {
            [formatter setDateFormat:@"dd-MM-yyyy"];
            startDateString= [formatter stringFromDate:curDate];
            [cell.startDate resignFirstResponder];
        }
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
        CustomTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];
        NSDate *startDate = curDate;
        NSDate *endDate = curDate1;
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        if (components.day >=0) {
            cell.targetDateIV.hidden = YES;
            [formatter setDateFormat:@"dd-MM-yyyy"];
            targetDateCategoryString = [formatter stringFromDate:curDate1];
            [cell.targetDateTF resignFirstResponder];
        }
    }
    [dataTableView reloadData];
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[formatter stringFromDate:selectedDate]);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (employeeType == 1 ) {
        return 6;
    }
    else if (employeeType == 2 ) {
        return 9;
    }
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Employee Type" forIndexPath:indexPath];
        cell.employeeIV.hidden =YES;
        cell.employeeTypeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        cell.employeeTypeTF.text = actionForString;

    }
    else if (employeeType == 1) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
            cell.startDate.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.startDate.text = startDateString;
            cell.startDateIV.hidden =YES;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
            cell.targetDateTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.targetDateTF.text = targetDateCategoryString;
            cell.targetDateIV.hidden =YES;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
            cell.actionTypeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.actionTypeTF.text = actionTypeString;
            cell.actionTypeIV.hidden =YES;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
            cell.actionDescriptionTV.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            [cell.actionDescriptionTV setText:textViewText];
            cell.actionDescrptionIV.hidden =YES;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"submit" forIndexPath:indexPath];
            if (_update) {
                [cell.submitBtn setTitle:@"Update" forState:UIControlStateNormal];
            }
            else{
                [cell.submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
            }
        }
    }
    else{
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
            cell.categoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.categoryTF.text = stakeholderCategoryString;
            cell.categoryIV.hidden =YES;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Company" forIndexPath:indexPath];
            cell.companyTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.companyTF.text = companyString;
            cell.companyIV.hidden =YES;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Assigned To" forIndexPath:indexPath];
            cell.assignedToTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.assignedToTF.text = assignedToString;
            cell.assignedToIV.hidden =YES;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
            cell.startDate.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.startDate.text = startDateString;
            cell.startDateIV.hidden =YES;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
            cell.targetDateTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.targetDateTF.text = targetDateCategoryString;
            cell.targetDateIV.hidden =YES;
        }
        else if (indexPath.row == 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
            cell.actionTypeTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.actionTypeTF.text = actionTypeString;
            cell.actionTypeIV.hidden =YES;
        }
        else if (indexPath.row == 7) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
            cell.actionDescriptionTV.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            [cell.actionDescriptionTV setText:textViewText];
            cell.actionDescrptionIV.hidden =YES;
        }
        else if (indexPath.row == 8) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"submit" forIndexPath:indexPath];
            if (_update) {
                [cell.submitBtn setTitle:@"Update" forState:UIControlStateNormal];
            }
            else{
                [cell.submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
            }
        }
    }
    
    
    return cell;
}
- (IBAction)actionTypeBtn:(id)sender {
    submitButtonClicked = NO;
      UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Normal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionTypeString = @"Normal";
        [dataTableView reloadData];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Critical" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionTypeString = @"Critical";
        [dataTableView reloadData];
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  
}
- (IBAction)assignedBtn:(id)sender {
     if([Utitlity isConnectedTointernet]){

    if ([companyString isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Company"];
    }
    else{
        sharedManager.passingMode = @"assignedTo";
        sharedManager.passingId = Company;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
        [dataTableView reloadData];
    }
     }else{
         [self showMsgAlert:NOInternetMessage];
     }
}
- (IBAction)companyBtn:(id)sender {
     if([Utitlity isConnectedTointernet]){
  
    if ([stakeholderCategoryString isEqualToString:@""]) {
        [self showMsgAlert:@"Please select Catagory"];
    }
    else{
        sharedManager.passingMode = @"company";
        sharedManager.passingId = StakeholderCategory;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
    }
    assignedToString = @"";
    [dataTableView reloadData];
     }else{
         [self showMsgAlert:NOInternetMessage];
     }
   
}
- (IBAction)categoryBtn:(id)sender {
     if([Utitlity isConnectedTointernet]){
    companyString = @"";
    assignedToString = @"";
    sharedManager.passingMode = @"category";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    [dataTableView reloadData];
     }else{
         [self showMsgAlert:NOInternetMessage];
     }
}
- (IBAction)employeeTypeBtn:(id)sender {

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
 
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Self" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        employeeType = 1;
        actionForString = @"Self";
        [self clearTF];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        employeeType = 2;
        actionForString = @"Other";
        [self clearTF];
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)clearTF{
    [dataTableView reloadData];
    if (!_update) {
        sharedManager.passingString = @"";
        textViewText =@"";
        stakeholderCategoryString= @"";
        companyString = @"";
        assignedToString= @"";
        startDateString = @"";
        targetDateCategoryString = @"";
        dateGap = NO;
        actionTypeString = @"";
    }
    [dataTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (employeeType == 1) {
        if (indexPath.row == 4) {
            return [self heightForText:textViewText withFont:[UIFont systemFontOfSize:14] andWidth:320]+70;
        }
    }
    else{
        if (indexPath.row == 7) {
            return [self heightForText:textViewText withFont:[UIFont fontWithName:@"Helvetica" size:16] andWidth:320]+70;
        }
    }
    return 80;
}
-(void)fillTheTF{
    clearData = NO;
    if ([sharedManager.passingMode isEqualToString: @"category"]) {
        stakeholderCategoryString = sharedManager.passingString;
        StakeholderCategory = sharedManager.passingId;
    }
    if ([sharedManager.passingMode isEqualToString: @"company"]) {
       companyString= sharedManager.passingString;
        Company = sharedManager.passingId;
    }
    if ([sharedManager.passingMode isEqualToString: @"assignedTo"]) {
        assignedToString= sharedManager.passingString;
        AssignedTo = sharedManager.passingId;
    }
    [dataTableView reloadData];
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)submitBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){
    submitButtonClicked = YES;
    [self validateTF];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
    
}
-(void)validateTF{
    NSString *msg=@"";
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([[textViewText stringByTrimmingCharactersInSet: set] length] == 0){
        msg=[NSString stringWithFormat:@"Action Descrtion is required"];
    }
    
    if ([actionTypeString isEqualToString:@""]) {
        msg=[NSString stringWithFormat:@"Action Type is required"];
    }
    
    
    if ([targetDateCategoryString isEqualToString:@""] ) {
        msg=[NSString stringWithFormat:@"Target Date is required"];
    }
    
    if ([startDateString isEqualToString:@""]) {
        msg=[NSString stringWithFormat:@"Start Date is required"];
    }
    
   
    if (employeeType == 2) {
        
        if ([assignedToString isEqualToString:@""]) {
            msg=[NSString stringWithFormat:@"Assigned To is required"];
        }
        
        if ([companyString isEqualToString:@""]) {
            msg=[NSString stringWithFormat:@"Company is required"];
        }

        if ([stakeholderCategoryString isEqualToString:@""]) {
            msg=[NSString stringWithFormat:@"Category is required"];
            
        }
    }
    if (![msg isEqualToString: @""]) {
        [self showMsgAlert:msg];
    }
    else{
        [self submitApiCall];
    }
}
-(void)submitApiCall{
        clearData = YES;
    [self showProgress];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:textViewText forKey:@"ActionDescription"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [params setObject:[formatter stringFromDate:curDate] forKey:@"ActionAssignDate"];
    [params setObject:[formatter stringFromDate:curDate1] forKey:@"TargetDate"];
    [params setObject:[NSString stringWithFormat:@"%d",employeeType] forKey:@"EmployeeType"];
    [params setObject:actionTypeString forKey:@"ActionType"];
    if (_update) {
        if (employeeType == 1) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ActionAsignee"];
            [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ActionOwner"];
            [params setObject:ActionplannerID forKey:@"ActionplannerID"];

            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            [[WebServices sharedInstance]apiAuthwithJSON:PostUpdateActionPlanner HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                [self hideProgress];
                [self clearTF];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Action assigned successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
        else{
            [params setObject:StakeholderCategory forKey:@"StakeholderCategory"];
            [params setObject:Company forKey:@"Company"];
            [params setObject:AssignedTo forKey:@"ActionOwner"];
            [params setObject:ActionplannerID forKey:@"ActionplannerID"];

            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            [[WebServices sharedInstance]apiAuthwithJSON:PostUpdateActionPlanner HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                [self hideProgress];
                [self clearTF];
                [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Action assigned successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
              
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
        }

    }
    else{
        if (employeeType == 1) {
            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            [[WebServices sharedInstance]apiAuthwithJSON:PostMITRActionPlannerDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                [self hideProgress];
                [self clearTF];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Action assigned successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
        else{
            [params setObject:StakeholderCategory forKey:@"StakeholderCategory"];
            [params setObject:Company forKey:@"Company"];
            [params setObject:AssignedTo forKey:@"AssignedTo"];
            [self showProgress];
            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            [[WebServices sharedInstance]apiAuthwithJSON:PostExtActionPlannerDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                [self hideProgress];
                [self clearTF];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Action assigned successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
             
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            
            }];
        }
    }
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:dataTableView animated:YES];
    
}
-(void)hideProgress{
    [MBProgressHUD hideHUDForView:dataTableView animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self updateTextLabelsWithText: newString];
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    if (![string isEqualToString:@""]) {
        NSIndexPath *ip ;
        if (employeeType == 1) {
            ip = [NSIndexPath indexPathForRow:4 inSection:0];
        }
        else{
            ip = [NSIndexPath indexPathForRow:7 inSection:0];
        }
        CustomTableViewCell *cell = [dataTableView cellForRowAtIndexPath:ip];
        cell.actionDescrptionIV.hidden = YES;
    }
    textViewText = string;
    
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
    [dataTableView beginUpdates];
    textView.frame = newFrame;
    [dataTableView endUpdates];
    if ([textView.text rangeOfString:@"\n\n"].location == NSNotFound) return;
    NSString *resultStr = [textView.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    textView.text = resultStr;
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        [self showProgress];
    
        NSString *targetUrl = [NSString stringWithFormat:@"%@GetActionPlannerByID?ActPlannerID=%@", BASEURL,sharedManager.passingId];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
             NSDictionary * actionDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",actionDict);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgress];
                  [formatter setDateFormat:@"dd/MM/yyy"];
                  textViewText  = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"ActionDescription"];
                  actionTypeString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"ActionType"];
                  assignedToString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"Assignee"];
                  AssignedTo = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"ActionOwner"];
                  if ([[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"CompanyName"]!= [NSNull null]) {
                      companyString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"CompanyName"];
                  }
                  else{
                      companyString = @"";
                  }
                  Company = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"Company"];
                  StakeholderCategory = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"StakeholderCategory"];
                  if ([[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"CategoryName"] != [NSNull null]) {
                      stakeholderCategoryString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"CategoryName"];
                  }
                  else{
                      stakeholderCategoryString = @"";
                  }
                  startDateString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"ActionAssignDate"];
                  curDate = [formatter dateFromString:startDateString];
                  targetDateCategoryString = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"TargetDate"];
                  curDate1 = [formatter dateFromString:targetDateCategoryString];
                  employeeType = [[[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"EmployeeType"] intValue];
                  ActionplannerID = [[[actionDict objectForKey:@"GetActionPlannerByIDResult"] objectAtIndex:0] objectForKey:@"ActionplannerID"];

                  if (employeeType == 1) {
                      actionForString = @"Self";
                  }
                  else{
                      actionForString = @"Other";
                  }
                  [dataTableView reloadData];
              });
              
          }] resume];
        
        
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
@end

