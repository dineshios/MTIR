//
//  ActionListViewController.m
//  test
//
//  Created by ceaselez on 29/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "ActionListViewController.h"
#import "CustomTableViewCell.h"
#import "MySharedManager.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "AddActionViewController.h"
@interface ActionListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResult;
@property (weak, nonatomic) IBOutlet UIView *searchView;



@end

@implementation ActionListViewController
{
    NSArray *actionList;
    UIRefreshControl *refreshControl;
    MySharedManager *sharedManager;
    BOOL searchEnabled;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    actionList = [[NSArray alloc] init];
    SWRevealViewController *revealViewController = self.revealViewController;
    sharedManager = [MySharedManager sharedManager];
    
    if ( revealViewController )
    {
        [self.menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self loadDataFromApi];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDataFromApi) forControlEvents:UIControlEventValueChanged];

}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadDataFromApi];
    [self searchBarCancelButtonClicked:_searchBar];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            return 1;
        }
        NSLog(@"searchResult------%ld",[self.searchResult count]);
        return [self.searchResult count];
    }
    else{
    if (actionList.count == 0) {
        return 1;
    }
    else{
        return actionList.count;
    }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell ;
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
            cell1.textLabel.text = @"Actoios are not found";
            cell1.backgroundColor = [UIColor clearColor];
            cell1.textLabel.textColor = [UIColor whiteColor];
            cell.userInteractionEnabled = NO;
            return cell1;
        }
        else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
        cell.actionListDate.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"StartDate"];
        cell.actionListTargetDate.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"EndDate"];
        cell.actionListAssignee.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"Assignee"];
        cell.actionListDescripition.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"ActionDescription"];
        }
    }
    else{
    if (actionList.count == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
        cell.actionListDate.text = [[actionList objectAtIndex:indexPath.row] objectForKey:@"StartDate"];
        cell.actionListTargetDate.text = [[actionList objectAtIndex:indexPath.row] objectForKey:@"EndDate"];
        cell.actionListAssignee.text = [[actionList objectAtIndex:indexPath.row] objectForKey:@"Assignee"];
        cell.actionListDescripition.text = [[actionList objectAtIndex:indexPath.row] objectForKey:@"ActionDescription"];
    }
    }
    return  cell;
    }
- (IBAction)addBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddActionViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"AddActionViewController"];
    myNavController.update = NO;
    [self presentViewController:myNavController animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchEnabled) {
        sharedManager.passingId = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"ActionPlannerID"];

    }
      sharedManager.passingId = [[actionList objectAtIndex:indexPath.row] objectForKey:@"ActionPlannerID"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddActionViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"AddActionViewController"];
    myNavController.update = YES;
    [self presentViewController:myNavController animated:YES completion:nil];
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self showProgress];
    
        NSString *targetUrl = [NSString stringWithFormat:@"%@GetAddedActionList?userid=%@", BASEURL,[defaults objectForKey:@"UserID"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              actionList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",actionList);
              
              dispatch_async(dispatch_get_main_queue(), ^{
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
- (IBAction)deleteBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the action" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.dataTableView];
                             NSIndexPath *indexPath = [self.dataTableView indexPathForRowAtPoint:buttonPosition];
                             
                             if([Utitlity isConnectedTointernet]){
                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                 [params setObject:[[actionList objectAtIndex:indexPath.row] objectForKey:@"ActionPlannerID"]  forKey:@"ActionplannerID"];
                                 [params setObject:[defaults objectForKey:@"UserID"]  forKey:@"ModifiedBY"];
                                 [self showProgress];
                                 NSString* JsonString = [Utitlity JSONStringConv: params];
                                 NSLog(@"jsonstring-----%@",JsonString);
                                 [[WebServices sharedInstance]apiAuthwithJSON:PostDeleteActionPlanner HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                                     
                                     NSString *error=[json valueForKey:@"error"];
                                     [self hideProgress];
                                     
                                     if(error.length>0){
                                         [self showMsgAlert:[json valueForKey:@"error_description"]];
                                         return ;
                                     }else{
                                         [self showMsgAlert:@"Deleted successfully"];
                                         NSLog(@"json-----%@",json);
                                         [self loadDataFromApi];
                                     }
                                     
                                 }];
                             }else{
                                 [self showMsgAlert:NOInternetMessage];
                             }
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)search:(id)sender {
    _searchView.hidden = NO;
}
- (IBAction)searchBackBtn:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
}
- (void)filterContentForSearchText:(NSString*)searchText
{
    
    _searchResult = [actionList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ActionDescription contains[c] %@) OR (Assignee contains[c] %@) OR (StartDate contains[c] %@) OR (EndDate contains[c] %@) ", searchText, searchText, searchText, searchText]];

    NSLog(@"_searchResult-------%@",_searchResult);

    [_dataTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[searchBar.text stringByTrimmingCharactersInSet: set] length] == 0) {
        searchEnabled = NO;
        [_dataTableView reloadData];
    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[searchBar.text stringByTrimmingCharactersInSet: set] length] == 0) {
        searchEnabled = NO;
        [self.dataTableView reloadData];
    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchEnabled = NO;
    [_dataTableView reloadData];
    _searchView.hidden = YES;
    
}
@end
