//
//  MeetingCalenderViewController.m
//  test
//
//  Created by ceaselez on 01/01/18.
//  Copyright © 2018 ceaselez. All rights reserved.
//

#import "MeetingCalenderViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MeetingDetailsTableViewCell.h"
#import "MySharedManager.h"
#import "MeetingDetailsViewController.h"

@interface MeetingCalenderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResult;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation MeetingCalenderViewController
{
    UIRefreshControl *refreshControl;
    MySharedManager *sharedManager;
    NSArray *meetingList;
    BOOL searchEnabled;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [MySharedManager sharedManager];
    meetingList = [[NSArray alloc] init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [_menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self loadDataFromApi];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDataFromApi) forControlEvents:UIControlEventValueChanged];
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self searchBarCancelButtonClicked:_searchBar];
    [self loadDataFromApi];
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchEnabled) {
        _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.searchResult count]];
        if (_searchResult.count == 0) {
            return 1;
        }
        return [self.searchResult count];
    }
    else{
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)meetingList.count];
        return meetingList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingDetailsTableViewCell *cell;
    if (searchEnabled) {
        if (_searchResult.count == 0) {
           cell= [tableView dequeueReusableCellWithIdentifier:@"no cell" forIndexPath:indexPath];
        }
        else{
        cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.calenderCountryLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"CountryName"];
        cell.calenderFrequencyLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"FrequencyDescription"];
        cell.calenderMeetingDescrictionTV.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"MeetingDescription"];
        cell.calenderMeetingDateLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"MeetingDate"];
        }
    }
    else{
    cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.calenderCountryLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"CountryName"];
    cell.calenderFrequencyLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"FrequencyDescription"];
    cell.calenderMeetingDescrictionTV.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"MeetingDescription"];
    cell.calenderMeetingDateLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"MeetingDate"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchEnabled) {
        sharedManager.passingId = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingTypeID"];
        sharedManager.passingString = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingDate"];
        
    }
    else{
    sharedManager.passingId = [[meetingList objectAtIndex:indexPath.row] objectForKey:@"MeetingTypeID"];
    sharedManager.passingString = [[meetingList objectAtIndex:indexPath.row] objectForKey:@"MeetingDate"];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingDetailsViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"MeetingDetailsViewController"];
    myNavController.update = YES;
    [self presentViewController:myNavController animated:YES completion:nil];
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@AdhocMeeting?Type=All&UserId=%@", BASEURL,[defaults objectForKey:@"UserID"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              meetingList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",meetingList);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgress];
                  if (meetingList.count == 0) {
                      _dataTableView.hidden = YES;
                  }
                  else{
                      _dataTableView.hidden = NO;
                  }
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

- (IBAction)search:(id)sender {
    _searchView.hidden = NO;
}
- (IBAction)searchBackBtn:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
}
- (void)filterContentForSearchText:(NSString*)searchText
{
    _searchResult = [meetingList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MeetingDescription contains[c] %@) OR (CountryName contains[c] %@) OR (FrequencyDescription contains[c] %@) OR (MeetingDate contains[c] %@)", searchText, searchText, searchText, searchText]];
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
- (IBAction)deleteBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure do you want to delete the meeting" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.dataTableView];
                             NSIndexPath *indexPath = [self.dataTableView indexPathForRowAtPoint:buttonPosition];
                             
                             if([Utitlity isConnectedTointernet]){
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                 [params setObject:[[meetingList objectAtIndex:indexPath.row] objectForKey:@"MeetingTypeID"]  forKey:@"meetingtypeid"];
                                 [params setObject:[[meetingList objectAtIndex:indexPath.row] objectForKey:@"MeetingDate"]  forKey:@"date"];

                                 [self showProgress];
                                 NSString* JsonString = [Utitlity JSONStringConv: params];
                                 NSLog(@"jsonstring-----%@",JsonString);
                                 [[WebServices sharedInstance]apiAuthwithJSON:PostDeleteAdhocMeeting HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                                     
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
@end
