
#import "MenuViewController.h"
#import "ProfileTableViewCell.h"
#import "ViewController.h"
#import "UIView+Toast.h"
#import "SWRevealViewController.h"
#import "MySharedManager.h"
@implementation SWUITableViewCell

@end

@implementation MenuViewController

{
    long selectedSection;
    BOOL selectedSection1;
    BOOL selectedSection2;
    BOOL selectedSection3;
    BOOL selectedSection4;
    BOOL selectedSection5;
    BOOL selectedRow12;
    BOOL selectedRow13;
    BOOL selectedRow22;
    BOOL selectedRow30;
    BOOL selectedRow31;
    BOOL selectedRow40;
    MySharedManager *sharedManager;

 long selectedRow;
    IBOutlet UITableView *dataTable;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1 && selectedSection1) {
        if (selectedRow12 && selectedRow13) {
            return 7;
        }
        else if (selectedRow12) {
            return 5;
        }
        else if (selectedRow13) {
            return 6;
        }
        return 4;
    }
    if (section == 2 && selectedSection2) {
        if (selectedRow22) {
            return 7;
        }
        return 3;
    }
    if (section == 3 && selectedSection3) {
        if (selectedRow31 && selectedRow30) {
            return 7;
        }
        else if (selectedRow30 ) {
            return 5;
        }
        else if (selectedRow31 ) {
            return 4;
        }
        return 2;
    }
    if (section == 4 && selectedSection4) {
        if (selectedRow40) {
            return 2;
        }
        return 1;
    }
    if (section == 5 && selectedSection5) {
        return 1;
    }
    
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sharedManager = [MySharedManager sharedManager];
    sharedManager.slideMenuSlected = @"yes";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self.navigationController.view makeToast:cell.textLabel.text
                                     duration:1.0
                                     position:CSToastPositionBottom];
    if (indexPath.section == 1 && indexPath.row == 2) {
        if (selectedRow12) {
            selectedRow12 = NO;
        }
        else
        selectedRow12 = YES;
    }
    if (selectedRow12) {
        if (indexPath.section == 1 && indexPath.row == 4) {
            if (selectedRow13) {
                selectedRow13 = NO;
            }
            else
                selectedRow13 = YES;
        }
    }
    else{
    if (indexPath.section == 1 && indexPath.row == 3) {
        if (selectedRow13) {
            selectedRow13 = NO;
        }
        else
            selectedRow13 = YES;
    }
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        if (selectedRow22) {
            selectedRow22 = NO;
        }
        else
            selectedRow22 = YES;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        if (selectedRow30) {
            selectedRow30 = NO;
        }
        else
        selectedRow30 = YES;
    }
    if (selectedRow30) {
        if (indexPath.section == 3 && indexPath.row == 4) {
            if (selectedRow31) {
                selectedRow31 = NO;
            }
            else
                selectedRow31 = YES;
        }
    }
    else{
     if (indexPath.section == 3 && indexPath.row == 1) {
        if (selectedRow31) {
            selectedRow31 = NO;
        }
        else
            selectedRow31 = YES;
      }
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        if (selectedRow40) {
            selectedRow40 = NO;
        }
        else
        selectedRow40 = YES;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_AddStackHoldersViewController) {
            self.AddStackHoldersViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AddStackHoldersViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_AddStackHoldersViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_UpdateStakeHolderViewController) {
            self.UpdateStakeHolderViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateStakeHolderViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_UpdateStakeHolderViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if(selectedRow12){
        if (indexPath.section == 1 && indexPath.row == 3 ) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_ContactDirectoryViewController) {
                self.ContactDirectoryViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ContactDirectoryViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_ContactDirectoryViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 5 ) {
            sharedManager.passingMode = @"Category wise companies";
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_DashBoardPieChartViewController) {
                self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 6 ) {
            sharedManager.passingMode = @"Industry wise companies";
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_DashBoardPieChartViewController) {
                self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
    }
    else{
        if (indexPath.section == 1 && indexPath.row == 4 ) {
            sharedManager.passingMode = @"Category wise companies";
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_DashBoardPieChartViewController) {
                self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 1 && indexPath.row == 5 ) {
            sharedManager.passingMode = @"Industry wise companies";
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_DashBoardPieChartViewController) {
                self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
    }
   
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_ActionListViewController) {
            self.ActionListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ActionListViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_ActionListViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_UpdateActionProgressViewController) {
            self.UpdateActionProgressViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateActionProgressViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_UpdateActionProgressViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
        sharedManager.passingMode = @"Action Analysis(Self)";
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_DashBoardPieChartViewController) {
            self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 4) {
        sharedManager.passingMode = @"Action Analysis(Others)";
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_DashBoardPieChartViewController) {
            self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 5) {
        sharedManager.passingMode = @"Dependency Actions Analysis";
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_DashBoardPieChartViewController) {
            self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 6) {
        sharedManager.passingMode = @"Delayed Completion  Actions Analysis";
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (!_DashBoardPieChartViewController) {
            self.DashBoardPieChartViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_DashBoardPieChartViewController];
        [self.revealViewController pushFrontViewController:nc animated:YES];
    }
    if(selectedRow31 && selectedRow30){
        if (indexPath.section == 3 && indexPath.row == 1) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_MeetingDetailsViewController) {
                self.MeetingDetailsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MeetingDetailsViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_MeetingDetailsViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 3 && indexPath.row == 2) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_MeetingCalenderViewController) {
                self.MeetingCalenderViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MeetingCalenderViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_MeetingCalenderViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 3 && indexPath.row == 3) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_ConductMeetingViewController) {
                self.ConductMeetingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ConductMeetingViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_ConductMeetingViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 3 && indexPath.row == 5) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_UpdateMeetingStatusViewController) {
                self.UpdateMeetingStatusViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateMeetingStatusViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_UpdateMeetingStatusViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
    }
    else if (selectedRow30) {
        if (indexPath.section == 3 && indexPath.row == 1) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_MeetingDetailsViewController) {
                self.MeetingDetailsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MeetingDetailsViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_MeetingDetailsViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        if (indexPath.section == 3 && indexPath.row == 2) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_MeetingCalenderViewController) {
                self.MeetingCalenderViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MeetingCalenderViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_MeetingCalenderViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
       }
        if (indexPath.section == 3 && indexPath.row == 3) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_ConductMeetingViewController) {
                self.ConductMeetingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ConductMeetingViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_ConductMeetingViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
    }
    else if(selectedRow31){
        if (indexPath.section == 3 && indexPath.row == 2) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (!_UpdateMeetingStatusViewController) {
                self.UpdateMeetingStatusViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateMeetingStatusViewController"];
            }
            UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:_UpdateMeetingStatusViewController];
            [self.revealViewController pushFrontViewController:nc animated:YES];
        }
        
    }
   
    [dataTable reloadData];
    
}
-(void)logout{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"EmpID"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
    NSArray *list = [[NSArray alloc] init];
    if (indexPath.section == 1 && selectedSection1) {
        if (selectedRow13 && selectedRow12) {
            list =  [NSArray arrayWithObjects:@"    • Add stakeholder",@"    • Update stakeholder",@"    • Data Query",@"           • Contact dicrectory",@"    • DashBoard",@"           • Category wise companies",@"           • Industry wise companies",nil];
            
        }
        else if (selectedRow12) {
            list =  [NSArray arrayWithObjects:@"    • Add stakeholder",@"    • Update stakeholder",@"    • Data Query",@"           • Contact dicrectory",@"    • DashBoard",nil];
            
        }
        else if (selectedRow13) {
            list =  [NSArray arrayWithObjects:@"    • Add stakeholder",@"    • Update stakeholder",@"    • Data Query",@"    • DashBoard",@"           • Category wise companies",@"           • Industry wise companies",nil];
            
        }
        else{
        list =  [NSArray arrayWithObjects:@"    • Add stakeholder",@"    • Update stakeholder",@"    • Data Query",@"    • DashBoard",nil];
        }
    }
    if (indexPath.section == 2 && selectedSection2 ) {
        if (selectedRow22) {
        list =  [NSArray arrayWithObjects:@"    • Add Action",@"    • Update Action Progress",@"    • DashBoard",@"           • Action Analysis(Self)",@"           • Action Analysis(Others)",@"           • Dependency Actions \n             Analysis",@"           • Delayed Completion  \n             Actions Analysis",nil];
        }
        else{
            list =  [NSArray arrayWithObjects:@"    • Add Action",@"    • Update Action Progress",@"    • DashBoard",nil];
        }
    }
    if (indexPath.section == 3 && selectedSection3 ) {
        if (selectedRow30 && selectedRow31) {
             list =  [NSArray arrayWithObjects:@"    • Adhoc Meeting",@"          • Create Meeting",@"           • Meeting Calendars",@"           • Conduct Meeting",@"    • Meeting Actions",@"           • Update Progress",@"           • Approve Actions",nil];
        }
        else if (selectedRow30) {
            list =  [NSArray arrayWithObjects:@"    • Adhoc Meeting",@"          • Create Meeting",@"           • Meeting Calendars",@"           • Conduct Meeting",@"    • Meeting Actions",nil];
            
        }
        else if (selectedRow31){
            list =  [NSArray arrayWithObjects:@"    • Adhoc Meeting",@"    • Meeting Actions",@"           • Update Progress",@"           • Approve Actions",nil];
        }
        else{
        list =  [NSArray arrayWithObjects:@"    • Adhoc Meeting",@"    • Meeting Actions",nil];
        }
        
    }
        
    if (indexPath.section == 4 && selectedSection4 ) {
        if (selectedRow40) {
            list =  [NSArray arrayWithObjects:@"    • Document Management",@"           • Document Panel",nil];
            
        }
        else{
        list =  [NSArray arrayWithObjects:@"    • Document Management",nil];
        }
        
    }
    if (indexPath.section == 5 && selectedSection5 ) {
        list =  [NSArray arrayWithObjects:@"    • Action Planner",nil];
        
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = [list objectAtIndex:indexPath.row];

        return cell;
 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ProfileTableViewCell *cell;
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"profile"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        cell.nameLabel.text =[defaults objectForKey:@"EmployeeName"];
        cell.mailIDLabel.text =[defaults objectForKey:@"EmailID"];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        NSArray *list = [[NSArray alloc] initWithObjects:@"",@"External Stakeholder",@"Action Planner",@"MITR",@"DMS",@"Pending Action",@"Logout",nil];
        NSArray *list = [[NSArray alloc] initWithObjects:@"",@"External Stakeholder",@"Action Planner",@"MITR",@"Logout",nil];
        cell.textLabel.text = [list objectAtIndex:section];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];

        cell.clickableBtn.tag = section;
        
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 180;
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (IBAction)sectionBtn:(id)sender {
    UIButton *clickedButton = (UIButton*)sender;
    if (clickedButton.tag == 1) {
        if (selectedSection1) {
            selectedSection1 = NO;
        }
        else
        selectedSection1 =YES;
    }
    if (clickedButton.tag == 2) {
        if (selectedSection2) {
            selectedSection2 = NO;
        }
        else
        selectedSection2 = YES;
    }
    if (clickedButton.tag == 3) {
        if (selectedSection3) {
            selectedSection3 = NO;
        }
        else
        selectedSection3 = YES;
    }
    if (clickedButton.tag == 4) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Logout"
                                                                      message:@"Are you sure?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self logout];
                                    }];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:yesButton];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
//        if (selectedSection4) {
//            selectedSection4 = NO;
//        }
//        else
//        selectedSection4 = YES;
    }
    if (clickedButton.tag == 5) {
        if (selectedSection5) {
            selectedSection5 = NO;
        }
        else
        selectedSection5 = YES;
    }
    if (clickedButton.tag == 6) {
        
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Logout"
                                                                      message:@"Are you sure?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self logout];
                                    }];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:yesButton];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if (selectedSection == clickedButton.tag) {
        selectedRow = 0;
        if (clickedButton.tag == 1) {
            selectedRow12 = NO;
            selectedRow13 = NO;
        }
        if (clickedButton.tag == 2) {
            selectedRow22 = NO;
        }
        
        if (clickedButton.tag == 3) {
            selectedRow30 = NO;
            selectedRow31 = NO;
        }
        
//        if (clickedButton.tag == 4) {
//            selectedRow40 = NO;
//        }
    }
    selectedSection = clickedButton.tag;
    [dataTable reloadData];
}

@end
