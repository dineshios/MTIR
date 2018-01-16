

#import "SearchViewController.h"
#import "MySharedManager.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"

@interface SearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResult;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation SearchViewController

{
//    NSMutableArray *tableDataArray;
    BOOL searchEnabled;
    MySharedManager *sharedManager;
    NSMutableArray *dataArray;
    NSMutableArray *mutableDataArray;
    NSString *externalStakeholderId;
    NSString *idnum;
//    NSMutableArray *idArray;
    BOOL showData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResult = [NSMutableArray arrayWithCapacity:[dataArray count]];
    sharedManager = [MySharedManager sharedManager];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
mutableDataArray = [[NSMutableArray alloc]init];
    [self getData];
}
-(void)getData{
    if([Utitlity isConnectedTointernet]){
        showData = NO;
        [_tableView reloadData];
        [self showProgress];
        NSMutableURLRequest *urlRequest;
        if ([sharedManager.passingMode isEqualToString:@"category"]) {
           urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetExternalStakeHolder",BASEURL]]];

        }
        else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetExternalStakeHolder",BASEURL]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"company"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRCompany?externalStakeholderId=%@",BASEURL,sharedManager.passingId]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRCompany?externalStakeholderId=%@&industryId=%@",BASEURL,_categoryID,sharedManager.passingId]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetActionPlannerAssignedToById?id=%@",BASEURL,sharedManager.passingId]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"role"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMeetingRoles",BASEURL]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"country"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetAllMitrCountry",BASEURL]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"location"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetAllCountryWiseLocation?countryid=%@",BASEURL,sharedManager.passingId]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRIndustrySegment",BASEURL]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRIndustrySegment",BASEURL]]];
            
        }
        else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRContact?ExternalStakeholderTypeID=%@&IndustrysegmentId=%@&ExternalStakeholderID=%@",BASEURL,_categoryID,_industryID,_companyID]]];
            NSLog(@"urlRequest-----%@",urlRequest);
            
        }
        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"dataArray---%@",dataArray);
                if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
                    NSDictionary *dict = @{ @"ExternalStakeholderTypeID" : @"00000000-0000-0000-0000-000000000000", @"Type" : @"All"};
                    mutableDataArray = [dataArray mutableCopy];
                    [mutableDataArray insertObject:dict atIndex:0];

                }
                if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
                    NSDictionary *dict = @{ @"IndustryId" : @"00000000-0000-0000-0000-000000000000", @"IndustryName" : @"All"};
                    mutableDataArray = [dataArray mutableCopy];
                    [mutableDataArray insertObject:dict atIndex:0];

                }
                if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
                    NSDictionary *dict = @{ @"ExternalStakeholderID" : @"00000000-0000-0000-0000-000000000000", @"CompanyName" : @"All"};
                    mutableDataArray = [dataArray mutableCopy];
                    [mutableDataArray insertObject:dict atIndex:0];
                    
                }

                

             
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgress];
                    showData = YES;
                    [_tableView reloadData];
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
    [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Title"
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  tableView Delagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (searchEnabled) {
        if ([self.searchResult count] == 0 && showData) {
            return  1;
        }
        else{
        return [self.searchResult count];
        }
    }
   
        if ([dataArray count] == 0 && showData) {
            return 1;
        }
        else{
            if ([sharedManager.passingMode isEqualToString:@"categoryContact"] || [sharedManager.passingMode isEqualToString:@"industryContact"] || [sharedManager.passingMode isEqualToString:@"companyContact"]) {
                return [dataArray count] + 1;
            }
            return [dataArray count];
        }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.31 green:0.58 blue:1.00 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if (searchEnabled) {
        if (_searchResult.count == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"no data found"];
            cell.userInteractionEnabled = NO;
        }
        else{
            if ([sharedManager.passingMode isEqualToString:@"category"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Type"] ;
            }
            
            else if ([sharedManager.passingMode isEqualToString:@"company"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"CompanyName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"CompanyName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"EmpName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"role"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingRoleDescription"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"country"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"CountryName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"location"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"LocationName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"IndustryName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ContactName"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"IndustryName"] ;
            }
            else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
                cell.textLabel.text =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Type"] ;
            }
        }
    }
    else{
        if (dataArray.count == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"no data found"];
        }
        else{
            if ([sharedManager.passingMode isEqualToString:@"category"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Type"] ;
            }
            
            else if ([sharedManager.passingMode isEqualToString:@"company"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"CompanyName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
                cell.textLabel.text =[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"CompanyName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"EmpName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"role"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"MeetingRoleDescription"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"country"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"CountryName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"location"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"LocationName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"IndustryName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
                cell.textLabel.text =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ContactName"] ;

            }
            else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
                cell.textLabel.text =[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"IndustryName"] ;
            }
            else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
                cell.textLabel.text =[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"Type"] ;
            }
        }
    }
    return cell;
}



#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{

        if ([sharedManager.passingMode isEqualToString:@"category"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Type contains[c] %@)", searchText]];
            }
        
        else if ([sharedManager.passingMode isEqualToString:@"company"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CompanyName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
            _searchResult = [mutableDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CompanyName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EmpName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"role"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MeetingRoleDescription contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"country"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CountryName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"location"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(LocationName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IndustryName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
            _searchResult = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ContactName contains[c] %@)", searchText]];

        }
        else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
               _searchResult = [mutableDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IndustryName contains[c] %@)", searchText]];
        }
        else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
            _searchResult = [mutableDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Type contains[c] %@)", searchText]];
        }
    

    
    [_tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
        [self.tableView reloadData];
    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
        [self.tableView reloadData];
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
    [_tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    sharedManager.passingString = selectedCell.textLabel.text;
    if (searchEnabled) {
     
            if ([sharedManager.passingMode isEqualToString:@"category"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderTypeID"] ;
            }
            
            else if ([sharedManager.passingMode isEqualToString:@"company"]) {
               sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
               sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"UserID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"role"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"MeetingRoleID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"country"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"CountryID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"location"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"LocationID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"IndustryId"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
                sharedManager.passingId  =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ContactID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
                sharedManager.passingId =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"IndustryId"] ;
            }
            else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
                sharedManager.passingId =[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderTypeID"] ;
            }
    }
    else{
       
            if ([sharedManager.passingMode isEqualToString:@"category"]) {
               sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderTypeID"] ;
            }
            
            else if ([sharedManager.passingMode isEqualToString:@"company"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"companyContact"]) {
                sharedManager.passingId  =[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"assignedTo"]) {
               sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"UserID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"role"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"MeetingRoleID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"country"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"CountryID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"location"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"LocationID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industrySegment"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"IndustryId"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"contact"]) {
                sharedManager.passingId  =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ContactID"] ;
                
            }
            else if ([sharedManager.passingMode isEqualToString:@"industryContact"]) {
                sharedManager.passingId=[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"IndustryId"] ;
            }
            else if ([sharedManager.passingMode isEqualToString:@"categoryContact"]) {
                sharedManager.passingId =[[mutableDataArray objectAtIndex:indexPath.row] objectForKey:@"ExternalStakeholderTypeID"] ;
            }
    }
//    sharedManager.passingId = [idArray objectAtIndex:indexPath.row];
    NSLog(@"passingId-------%@",sharedManager.passingId);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backBtn:(id)sender {
    sharedManager.passingString = @"";
    sharedManager.passingId = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
