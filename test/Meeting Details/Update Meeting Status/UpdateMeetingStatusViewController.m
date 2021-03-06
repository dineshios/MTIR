//
//  UpdateMeetingStatusViewController.m
//  test
//
//  Created by ceaselez on 29/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "UpdateMeetingStatusViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MeetingDetailsTableViewCell.h"
#import "MySharedManager.h"
#import "THDatePickerViewController.h"
#import "CustomTableViewCell.h"


@interface UpdateMeetingStatusViewController ()<THDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *internalBtn;
@property (weak, nonatomic) IBOutlet UIButton *externalBtn;
@property (weak, nonatomic) IBOutlet UIView *internalBtnView;
@property (weak, nonatomic) IBOutlet UIView *externalBtnView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (nonatomic, strong) NSArray *searchResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *popOverView;
@property (weak, nonatomic) IBOutlet UITableView *popOverTableView;
@end

@implementation UpdateMeetingStatusViewController

{
    BOOL type;
    NSMutableArray *actionProgressDict;
    MySharedManager *sharedManager;
    UIRefreshControl *refreshControl;
    NSString *actionStatus;
    
    __weak IBOutlet UIButton *menuBtn;
    BOOL searchEnabled;
    __weak IBOutlet UIButton *actionStatusBtn;
    THDatePickerViewController * datePicker1;
    NSDate * curDate;
    NSDateFormatter * formatter;
    NSString *textViewText;
    __weak IBOutlet NSLayoutConstraint *popOverTableViewHeight;
    long editButtonIndex;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    textViewText = @"";
    _popOverView.hidden = YES;
    sharedManager = [MySharedManager sharedManager];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    actionProgressDict = [[NSMutableArray alloc] init];
    
    
    _internalBtnView.hidden = NO;
    _externalBtnView.hidden = YES;
    _searchBarView.hidden = YES;
    _tittleLabel.text = @"Self Update Progress";
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_dataTableView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_dataTableView addGestureRecognizer:swipeRight];
    actionStatus = @"dft";
    [self loadDataFromApi];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDataFromApi) forControlEvents:UIControlEventValueChanged];

    curDate = [NSDate date];
    
    formatter = [[NSDateFormatter alloc] init];
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        actionStatus = @"dft";
    }
    [self loadDataFromApi];
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";
    }
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self externalBtnClicked];
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self internalBtnClicked];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _popOverTableView) {
        return 3;
    }
    else{
        if (searchEnabled) {
            if (_searchResult.count == 0) {
                return 1;
            }
            return [self.searchResult count];
        }
        return actionProgressDict.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _popOverTableView) {
        CustomTableViewCell *cell;
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Completion Date" forIndexPath:indexPath];
                cell.updateCompletionDateTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.updateCompletionDateTF.text = [formatter stringFromDate:curDate];
            }
            if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Remarks" forIndexPath:indexPath];
                cell.updateRemaksTV.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.updateRemaksTV.text = textViewText;
            }
            else if (indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Button" forIndexPath:indexPath];
       
            }
        return cell;

    }
    else{
        MeetingDetailsTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"updateList"];
        if (searchEnabled) {
            if (_searchResult.count == 0) {
                UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableItem"];
                cell1.textLabel.text = @"Meetings are not found";
                cell1.backgroundColor = [UIColor clearColor];
                cell1.textLabel.textColor = [UIColor whiteColor];
                cell1.userInteractionEnabled  = NO;
                return cell1;
            }
            cell.updateMeetingDateLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingDate"];
            cell.updateMeetingDescriptionLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingDescription"];
            cell.updateResponsibleLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"EmpName"];
            cell.updateActionTypeLabel.text = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"ActionType"];
        }
        else{
            cell.updateMeetingDateLabel.text = [[actionProgressDict objectAtIndex:indexPath.row] objectForKey:@"MeetingDate"];
            cell.updateMeetingDescriptionLabel.text = [[actionProgressDict objectAtIndex:indexPath.row] objectForKey:@"MeetingDescription"];
            cell.updateResponsibleLabel.text = [[actionProgressDict objectAtIndex:indexPath.row] objectForKey:@"EmpName"];
            cell.updateActionTypeLabel.text = [[actionProgressDict objectAtIndex:indexPath.row] objectForKey:@"ActionType"];
            
            
        }
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _popOverTableView) {
        if (indexPath.row == 1) {
            NSLog(@"test");
            popOverTableViewHeight.constant = 180 + [self heightForText:textViewText withFont:[UIFont systemFontOfSize:14] andWidth:320];
            return [self heightForText:textViewText withFont:[UIFont systemFontOfSize:14] andWidth:180]+50;
        }
        return 60;
    }
    return 145;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dataTableView) {
        if (searchEnabled) {
            sharedManager.passingId = [[_searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingTypeID"];
        }
        else{
            sharedManager.passingId = [[actionProgressDict objectAtIndex:indexPath.row] objectForKey:@"MeetingTypeID"];
        }
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ActionPlannerDetailViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"ActionPlannerDetailViewController"];
//        [self presentViewController:myNavController animated:YES completion:nil];
    }
    
    
}

- (IBAction)internalBtn:(id)sender {
    [self internalBtnClicked];
}
- (IBAction)externalBtn:(id)sender {
    [self externalBtnClicked];
    
}
-(void)internalBtnClicked{
    if (type) {
        [self searchBarCancelButtonClicked:_searchBar];
        
        type = NO;
        _tittleLabel.text = @"Self Update Progress";
        _internalBtnView.hidden = NO;
        _externalBtnView.hidden = YES;
        [self loadDataFromApi];
    }
    
}
-(void)externalBtnClicked{
    if (!type) {
        [self searchBarCancelButtonClicked:_searchBar];
        
        _tittleLabel.text = @"Others Update Progress";
        _internalBtnView.hidden = YES;
        _externalBtnView.hidden = NO;
        type = YES;
        [self loadDataFromApi];
    }
    
}
-(void)loadDataFromApi{
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self showProgress];
        NSString *actionType;
        if (type) {
            actionType = @"other";
        }
        else{
            actionType = @"self";
        }
        NSString *targetUrl = [NSString stringWithFormat:@"%@GetAssignedActions?userid=%@&UnitID=1&ActCat=%@&ActionFor=%@", BASEURL,[defaults objectForKey:@"UserID"],actionStatus,actionType];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              actionProgressDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",actionProgressDict);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgress];
                  if (actionProgressDict.count == 0) {
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
- (IBAction)searchBtn:(id)sender {
    _searchBarView.hidden = NO;
}
- (IBAction)hideSearchBarView:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
    _searchBarView.hidden = YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{

    _searchResult = [actionProgressDict filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MeetingDescription contains[c] %@) OR (ActionType contains[c] %@) OR (EmpName contains[c] %@) OR (MeetingDate contains[c] %@)", searchText, searchText, searchText, searchText]];

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
    _searchBarView.hidden = YES;
    
}
- (IBAction)actionStatusBtn:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Action Status :" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Due for today" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionStatus = @"dft";
        [actionStatusBtn setTitle:@"Due for today" forState:UIControlStateNormal];
        [self loadDataFromApi];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Overdue till date" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionStatus = @"ovr";
        [actionStatusBtn setTitle:@"Overdue till date" forState:UIControlStateNormal];
        [self loadDataFromApi];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Work in progress" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionStatus = @"wip";
        [actionStatusBtn setTitle:@"Work in progress" forState:UIControlStateNormal];
        [self loadDataFromApi];
        
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
- (IBAction)editBtn:(id)sender {
    _popOverView.hidden = NO;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.popOverTableView];
    NSIndexPath *indexPath = [self.popOverTableView indexPathForRowAtPoint:buttonPosition];
    editButtonIndex = indexPath.row;
    textViewText = @"";
    curDate = nil;
    [_popOverTableView reloadData];
}
- (IBAction)popCancelBtn:(id)sender {
    _popOverView.hidden = YES;
}
- (IBAction)popDoneBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){
        
        NSString *msg=@"";
        
        if(curDate == nil){
            msg = @"Please select the complition date";
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        if ([[textViewText stringByTrimmingCharactersInSet: set] length] == 0){
            msg = @"Please enter the remarkss";
        }
        
        if(msg.length==0)
            
        {
            if([Utitlity isConnectedTointernet]){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setObject:[[actionProgressDict objectAtIndex:editButtonIndex] objectForKey:@"MeetingTypeID"] forKey:@"MeetingTypeID"];
                [params setObject:[[actionProgressDict objectAtIndex:editButtonIndex] objectForKey:@"ActionID"] forKey:@"ActionID"];
                NSString *dateString =  [[actionProgressDict objectAtIndex:editButtonIndex] objectForKey:@"MeetingDate"];
                [formatter setDateFormat:@"dd/MM/yyyy"];
                NSDate *date = [formatter dateFromString:dateString];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [params setObject:[formatter stringFromDate:date] forKey:@"MeetingDate"];
//                [params setObject:[[actionProgressDict objectAtIndex:editButtonIndex] objectForKey:@"MeetingDate"] forKey:@"MeetingDate"];
                [params setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
                [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ModifiedBy"];
                [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ApprovedBy"];
                [params setObject:[defaults objectForKey:@"UserID"] forKey:@"VerifiedBy"];
                [params setObject:[formatter stringFromDate:curDate] forKey:@"APDate"];
                [params setObject:textViewText forKey:@"Remarks"];
                
                
                [self showProgress];
                NSString* JsonString = [Utitlity JSONStringConv: params];
                NSLog(@"json----%@",JsonString);
                
                [[WebServices sharedInstance]apiAuthwithJSON:PostUpdateMeetingActionProgress HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                    
                    NSString *error=[json valueForKey:@"error"];
                    [self hideProgress];
                    
                    if(error.length>0){
                        [self showMsgAlert:[json valueForKey:@"error_description"]];
                        return ;
                    }else{
                        if(json.count==0){
                            [self showMsgAlert:@"Error , Try Again"];
                        }else{
                            NSLog(@"json-----%@",json);
                            _popOverView.hidden = YES;
//                            [self showMsgAlert:[json valueForKey:@"ActionStatusUpdateResult"]];
                            [self loadDataFromApi];
//                            [self sendMail];
                            
                        }
                    }
                    
                }];
            }else{
                [self showMsgAlert:NOInternetMessage];
            }
            
        }
        else
        {
            [self showMsgAlert:msg];
        }
    }
    else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)completionDateBtn:(id)sender {
    if(!datePicker1)
        datePicker1 = [THDatePickerViewController datePicker];
    datePicker1.date = [NSDate date];
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
                                                              KNSemiModalOptionKeys.animationDuration : @(0.2),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.2),
                                                              }];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    
    curDate = datePicker1.date;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCell *cell = [_popOverTableView cellForRowAtIndexPath:ip];
    cell.updateCompletionDateTF.text = [formatter stringFromDate:curDate];
    [cell.updateCompletionDateTF resignFirstResponder];
    
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self updateTextLabelsWithText: newString];
    return YES;
}
-(void)updateTextLabelsWithText:(NSString *)string
{
    if (![string isEqualToString:@""]) {
        textViewText = string;
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
    [_popOverTableView beginUpdates];
    textView.frame = newFrame;
    [_popOverTableView endUpdates];
    
    
}
-(void)sendMail{
    
    if([Utitlity isConnectedTointernet]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[defaults objectForKey:@"UserID"] forKey:@"Assignee"];
        if (type) {
            [params setObject:[[actionProgressDict objectAtIndex:editButtonIndex] objectForKey:@"ActionOwner"] forKey:@"Owner"];
        }
        else{
            [params setObject:[defaults objectForKey:@"UserID"] forKey:@"Owner"];
        }
        
        
        [self showProgress];
        NSString* JsonString = [Utitlity JSONStringConv: params];
        NSLog(@"json----%@",JsonString);
        
        [[WebServices sharedInstance]apiAuthwithJSON:SendActionStatusCompleteMail HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
            
            NSString *error=[json valueForKey:@"error"];
            [self hideProgress];
            
            if(error.length>0){
                [self showMsgAlert:[json valueForKey:@"error_description"]];
                return ;
            }else{
                if(json.count==0){
                    [self showMsgAlert:@"Error , Try Again"];
                }else{
                    NSLog(@"json-----%@",json);
                }
            }
            
        }];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
    
}

@end

