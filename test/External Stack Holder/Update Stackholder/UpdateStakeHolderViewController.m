//
//  UpdateStakeHolderViewController.m
//  test
//
//  Created by ceaselez on 14/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "UpdateStakeHolderViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "StackHolderTableViewCell.h"
#import "MySharedManager.h"
#import "AddStackHoldersViewController.h"

@interface UpdateStakeHolderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation UpdateStakeHolderViewController
{
    NSArray *stakeholderListArray;
    MySharedManager *sharedManager;
    UIRefreshControl *refreshControl;
    BOOL searchEnabled;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchView.hidden = YES;
    sharedManager = [MySharedManager sharedManager];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [_menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self loadDataFromApi];
    if([Utitlity isConnectedTointernet]){
    refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDataFromApi) forControlEvents:UIControlEventValueChanged];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadDataFromApi];
    [_searchBar resignFirstResponder];
    [_searchBar setText:@""];
    _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
    searchEnabled = NO;
    [_dataTableView reloadData];
    _searchView.hidden = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            return 1;
        }
        return [self.searchResult count];
    }
    return stakeholderListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"updateList";
    
    StackHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
            cell1.textLabel.text = @"contacts are not found";
            cell1.backgroundColor = [UIColor clearColor];
            cell1.textLabel.textColor = [UIColor whiteColor];
            cell1.userInteractionEnabled = NO;
            return cell1;
        }
        cell.UpdateNameLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.updateTypeLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"Type"];
    }
    else{
        cell.UpdateNameLabel.text = [[stakeholderListArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.updateTypeLabel.text = [[stakeholderListArray objectAtIndex:indexPath.row] objectForKey:@"Type"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([Utitlity isConnectedTointernet]){
    if (searchEnabled) {
        sharedManager.passingId = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"];
    }
    else{
        sharedManager.passingId = [[stakeholderListArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"];
    }
    sharedManager.slideMenuSlected = @"update";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddStackHoldersViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"AddStackHoldersViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}

- (IBAction)searchBtn:(id)sender {
    _searchView.hidden = NO;
}
- (IBAction)searchBarBackBtn:(id)sender {
    [_searchBar resignFirstResponder];
    [_searchBar setText:@""];
    _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
    searchEnabled = NO;
    [_dataTableView reloadData];
    _searchView.hidden = YES;
    
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
         [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@MITRStakeholderMainList", BASEURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              stakeholderListArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",stakeholderListArray);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgress];
//                  if ([stakeholderListArray count] == 0) {
//                      _dataTableView.hidden = YES;
//                  }
//                  else{
                  _dataTableView.hidden = NO;
                  _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
                  [refreshControl endRefreshing];
                  [_dataTableView reloadData];
//                  }
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
- (void)filterContentForSearchText:(NSString*)searchText
{
    _searchResult = [stakeholderListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name contains[c] %@) OR (Type contains[c] %@)", searchText,searchText]];
    _countLabel.text = [NSString stringWithFormat:@"%ld",[_searchResult count]];
    [_dataTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[searchBar.text stringByTrimmingCharactersInSet: set] length] == 0) {
        searchEnabled = NO;
        _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
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
        _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
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
    _countLabel.text = [NSString stringWithFormat:@"%ld",[stakeholderListArray count]];
    searchEnabled = NO;
    [_dataTableView reloadData];
    _searchView.hidden = YES;
    
}
- (IBAction)updateBackBtn:(id)sender {
}
- (IBAction)deleteBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure Delete the contact" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.dataTableView];
                             NSIndexPath *indexPath = [self.dataTableView indexPathForRowAtPoint:buttonPosition];
                             
                             if([Utitlity isConnectedTointernet]){
                                 
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                 [params setObject:[[stakeholderListArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"]  forKey:@"externalstakeholderid"];
                                 
                                 [self showProgress];
                                 NSString* JsonString = [Utitlity JSONStringConv: params];
                                 NSLog(@"json----%@",JsonString);
                                 
                                 [[WebServices sharedInstance]apiAuthwithJSON:PostDeleteExtStakeHolder HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                                     
                                     NSString *error=[json valueForKey:@"error"];
                                     [self hideProgress];
                                     
                                     if(error.length>0){
                                         [self showMsgAlert:[json valueForKey:@"error_description"]];
                                         return ;
                                     }else{
//                                         if(json.count==0){
                                             [self showMsgAlert:@"Deleted successfully"];
//                                         }else{
                                             NSLog(@"json-----%@",json);
                                             [self loadDataFromApi];
//                                         }
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
@end
