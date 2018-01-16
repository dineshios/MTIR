//
//  ActionPlannerDetailViewController.m
//  test
//
//  Created by ceaselez on 05/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "ActionPlannerDetailViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "CustomTableViewCell.h"
#import "MySharedManager.h"

@interface ActionPlannerDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation ActionPlannerDetailViewController
{
    int employeeType;
    NSArray *detailArray;
    MySharedManager *sharedManager;
    UIRefreshControl *refreshControl;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
    
    _dataTableView.rowHeight = UITableViewAutomaticDimension;
    sharedManager = [MySharedManager sharedManager];
    detailArray = [[NSArray alloc] init];
    [ self loadDataFromApi];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDataFromApi) forControlEvents:UIControlEventValueChanged];
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 92;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (employeeType == 1) {
        return 5;
    }
    else if(employeeType == 2) {
        return 8;
    }
    else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Employee Type" forIndexPath:indexPath];
        cell.plannerEmployeeLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"EmployeeType"];
        
    }
    else if (employeeType == 1) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
            cell.plannerStartDateLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"StartDate"];
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
            cell.plannerTargetDateLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"TargetDate"];
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
            cell.plannerActionTypeLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"ActionType"];
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
            cell.plannerActionDescriptionTV.text = [[detailArray objectAtIndex:0] objectForKey:@"ActionDescription"];
        }
      
    }
    else{
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
            cell.plannerCategoryLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"StakeHolderCategory"];
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Company" forIndexPath:indexPath];
            cell.plannerCompanyLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"CompanyName"];
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Assigned To" forIndexPath:indexPath];
            cell.plannerAssignedToLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"Assignee"];

        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Start Date" forIndexPath:indexPath];
            cell.plannerStartDateLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"StartDate"];

        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Target Date" forIndexPath:indexPath];
            cell.plannerTargetDateLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"TargetDate"];

        }
        else if (indexPath.row == 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Type" forIndexPath:indexPath];
            cell.plannerActionTypeLabel.text = [[detailArray objectAtIndex:0] objectForKey:@"ActionType"];
        }
        else if (indexPath.row == 7) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Action Description" forIndexPath:indexPath];
            cell.plannerActionDescriptionTV.text = [[detailArray objectAtIndex:0] objectForKey:@"ActionDescription"];
        }

    }
    return cell;
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@ActionPlannerListById?actionplannerid=%@", BASEURL,sharedManager.passingId];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              detailArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"actionProgressDict----%@",detailArray);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  if ([[[detailArray objectAtIndex:0] objectForKey:@"EmployeeType"] isEqualToString:@"INTERNAL"]) {

                      employeeType = 1;
                  }
                  else{
                      employeeType = 2;
                  }
                  [self hideProgress];
                  [refreshControl endRefreshing];
                  [_dataTableView reloadData];
              });
              
          }] resume];
        
        
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:_dataTableView animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:_dataTableView animated:YES];
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
