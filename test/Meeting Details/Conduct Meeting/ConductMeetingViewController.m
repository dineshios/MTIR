//
//  ConductMeetingViewController.m
//  test
//
//  Created by ceaselez on 02/01/18.
//  Copyright © 2018 ceaselez. All rights reserved.
//

#import "ConductMeetingViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MeetingDetailsTableViewCell.h"
#import "MySharedManager.h"
#import "MeetingDetailViewController.h"

@interface ConductMeetingViewController ()
@property (weak, nonatomic) IBOutlet UIView *todayBtnView;
@property (weak, nonatomic) IBOutlet UIView *upcomingBtnView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResult;


@end

@implementation ConductMeetingViewController

{
    UIRefreshControl *refreshControl;
    MySharedManager *sharedManager;
    NSArray *meetingList;
    BOOL searchEnabled;
    BOOL type;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _upcomingBtnView.hidden = YES;

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
    _searchView.hidden = YES;
    
    [self loadDataFromApi];
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            return 1;
        }
        return [self.searchResult count];
    }
    return meetingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingDetailsTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
            cell1.textLabel.text = @"contacts are not found";
            cell1.backgroundColor = [UIColor clearColor];
            cell1.textLabel.textColor = [UIColor whiteColor];
            return cell1;
        }
        cell.calenderCountryLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"CountryName"];
        cell.calenderFrequencyLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"FrequencyDescription"];
        cell.calenderMeetingDescrictionTV.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"MeetingDescription"];
        cell.calenderMeetingDateLabel.text = [[_searchResult objectAtIndex: indexPath.row] objectForKey:@"MeetingDate"];
    }
    else{
        cell.calenderCountryLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"CountryName"];
        cell.calenderFrequencyLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"FrequencyDescription"];
        cell.calenderMeetingDescrictionTV.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"MeetingDescription"];
        cell.calenderMeetingDateLabel.text = [[meetingList objectAtIndex: indexPath.row] objectForKey:@"MeetingDate"];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm/dd/yyyy hh:mm:ss a"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingDetailViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"MeetingDetailViewController"];
    NSDate *startDate;
    UIAlertController *alert;

    if (searchEnabled) {
        myNavController.meetingDict = [_searchResult objectAtIndex:indexPath.row];
        startDate = [dateFormatter dateFromString:[[_searchResult objectAtIndex:indexPath.row] objectForKey:@"FromTime"]];
    }
    else{
        myNavController.meetingDict = [meetingList objectAtIndex:indexPath.row];
        startDate = [dateFormatter dateFromString:[[meetingList objectAtIndex:indexPath.row] objectForKey:@"FromTime"]];
    }
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:startDate];
    if(diff>-900 && diff<900){
        alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to start the meeting on the correct time" preferredStyle:UIAlertControllerStyleAlert];
    }
    else{
        alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to start the meeting on the incorrect time" preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [self presentViewController:myNavController animated:YES completion:nil];
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self showProgress];
        NSString *typeString;
        if (type){
            typeString = @"PM";
        }
        else{
            typeString = @"TM";
        }
        NSString *targetUrl = [NSString stringWithFormat:@"%@AdhocMeeting?Type=%@&UserId=%@", BASEURL,typeString,[defaults objectForKey:@"UserID"]];
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
//    if (_searchResult.count == 0) {
//        _searchResult = [meetingList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CountryName contains[c] %@)", searchText]];
//    }
//    if (_searchResult.count == 0) {
//        _searchResult = [meetingList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FrequencyDescription contains[c] %@)", searchText]];
//    }
//    if (_searchResult.count == 0) {
//        _searchResult = [meetingList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MeetingDate contains[c] %@)", searchText]];
//    }
    
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

- (IBAction)todayBtn:(id)sender {
    _upcomingBtnView.hidden = YES;
    _todayBtnView.hidden = NO;
    type = 0;
    [self loadDataFromApi];
    [_dataTableView reloadData];
}
- (IBAction)upcomingBtn:(id)sender {
    _upcomingBtnView.hidden = NO;
    _todayBtnView.hidden = YES;
    type = 1;
    [self loadDataFromApi];
    [_dataTableView reloadData];
}



@end
