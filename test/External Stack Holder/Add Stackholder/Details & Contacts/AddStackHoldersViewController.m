

#import "AddStackHoldersViewController.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "StackHolderTableViewCell.h"
#import "THDatePickerViewController.h"
#import "SearchViewController.h"
#import "MySharedManager.h"
#import "AddContactViewController.h"

@interface AddStackHoldersViewController ()
@property (weak, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (weak, nonatomic) IBOutlet UIView *detailsBtnView;
@property (weak, nonatomic) IBOutlet UIView *contactBtnView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIButton *updateBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;


@end

@implementation AddStackHoldersViewController
{
    int stackHolder;
    
    NSMutableArray *contactArray;
    NSMutableArray *contactDeletedArray;

    
    NSString *categoryString;
    NSString *nameString;
    NSString *countryString;
    NSString *locationString;
    NSString *mobileNumberString;
    NSString *emailIDString;
    NSString *industrySegmentString;
    
    NSString *categoryID;
    NSString *countryID;
    NSString *locationID;
    NSString *industrySegmentID;

  

    BOOL submitButtonClicked;
    
    NSIndexPath *ip;
    StackHolderTableViewCell *cell;
    
    
    MySharedManager *sharedManager;

    NSString *imageString1;
    NSString *imageString2;
    NSString *imageContent;
    NSString *imageBase64String1;
    NSString *imageBase64String2;
    BOOL update;
    UIRefreshControl *refreshControl;
    
    NSString *ExternalStakeholderID;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    stackHolder = 1;
    _detailsBtnView.hidden = NO;
    _contactBtnView.hidden = YES;
    contactArray = [[NSMutableArray alloc] init];
    contactDeletedArray = [[NSMutableArray alloc] init];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    sharedManager = [MySharedManager sharedManager];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_slideMenuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_dataTableView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_dataTableView addGestureRecognizer:swipeRight];

}
-(void)viewWillAppear:(BOOL)animated{
   
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _updateBackBtn.hidden = YES;
        _updateBtn.hidden = YES;

        categoryString = @"";
        nameString = @"";
        countryString = @"";
        locationString = @"";
        mobileNumberString = @"";
        emailIDString = @"";
        industrySegmentString = @"";
        industrySegmentID = @"00000000-0000-0000-0000-000000000000";
        [contactArray removeAllObjects];
        [contactDeletedArray removeAllObjects];

        update = NO;
        [_dataTableView reloadData];
    }
    else if ([sharedManager.slideMenuSlected isEqualToString:@"update"]){
        _updateBackBtn.hidden = NO;
        _updateBtn.hidden = NO;

        categoryString = @"";
        nameString = @"";
        countryString = @"";
        locationString = @"";
        mobileNumberString = @"";
        emailIDString = @"";
        industrySegmentString = @"";
        industrySegmentID = @"00000000-0000-0000-0000-000000000000";
        [contactArray removeAllObjects];
        [contactDeletedArray removeAllObjects];

        update = YES;
        if([Utitlity isConnectedTointernet]){
            refreshControl = [[UIRefreshControl alloc]init];
            [self.dataTableView addSubview:refreshControl];
            [refreshControl addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
        }else{
            [self showMsgAlert:NOInternetMessage];
        }
        [self updateData];
    }
    else if ([sharedManager.slideMenuSlected isEqualToString:@"contactArray"]){
        [self fillTheTF];
        contactArray = sharedManager.contactArray;
        [_dataTableView reloadData];
    }
    else{
//        _updateBackBtn.hidden = YES;
//        _updateBtn.hidden = YES;
//        update = NO;
        [self fillTheTF];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]||[sharedManager.slideMenuSlected isEqualToString:@"update"]) {
        sharedManager.slideMenuSlected = @"no";
        
    }
}
- (IBAction)detailBtn:(id)sender {
    [self detailBtnClicked];
}
- (IBAction)contactBtn:(id)sender {
    [self contactBtnClicked];
}
-(void)detailBtnClicked{
    _tittleLabel.text = @"Stack Holder Details";
    stackHolder = 1;
    _detailsBtnView.hidden = NO;
    _contactBtnView.hidden = YES;
    [_dataTableView reloadData];
}
-(void)contactBtnClicked{
    _tittleLabel.text = @"Stack Holder Contats";
    stackHolder = 2;
    _detailsBtnView.hidden = YES;
    _contactBtnView.hidden = NO;
    [_dataTableView reloadData];
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (stackHolder == 1) {
            [self contactBtnClicked];
        }
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (stackHolder == 2) {
            [self contactBtnClicked];
        }
        
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _dataTableView) {
        if(stackHolder == 1){
            return 7;
        }
        else if(stackHolder == 2){
            if(contactArray.count == 0){
                return 1;
            }
            return contactArray.count;
        }
    }
    return 7;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StackHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _dataTableView) {
        if (stackHolder == 2 ) {
            return 60;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dataTableView) {
    if (stackHolder == 1) {
            return 80;
    }
    return 120;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier ;
    
    StackHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (tableView == _dataTableView) {
        if (stackHolder == 1) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
                cell.categoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                [cell.categoryTF setText:categoryString];
                if (submitButtonClicked) {
                    if ([categoryString isEqualToString:@""]) {
                        cell.categoryIV.hidden = NO;
                    }
                }
                else
                    cell.categoryIV.hidden =YES;
            }
            else if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Name" forIndexPath:indexPath];
                cell.nameTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.nameTF.text = nameString;
            }
            else if (indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Country" forIndexPath:indexPath];
                cell.countryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.countryTF.text = countryString;
                if (submitButtonClicked) {
                    if ([countryString isEqualToString:@""]) {
                        cell.countryIV.hidden = NO;
                    }
                }
                else
                    cell.countryIV.hidden =YES;
            }
            else if (indexPath.row == 3) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Location" forIndexPath:indexPath];
                cell.locationTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.locationTF.text = locationString;
               
                if (submitButtonClicked) {
                    if ([locationString isEqualToString:@""]) {
                        cell.locationIV.hidden = NO;
                    }
                }
                else
                    cell.locationIV.hidden =YES;
            }
            else if (indexPath.row == 4) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Mobile Number" forIndexPath:indexPath];
                cell.mobleNumberTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.mobleNumberTF.text = mobileNumberString;
                if (submitButtonClicked) {
                    if ([mobileNumberString isEqualToString:@""]) {
                        cell.mobileNumerIV.hidden = NO;
                    }
                }
                else
                    cell.mobileNumerIV.hidden =YES;
            }
            else if (indexPath.row == 5) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Email ID" forIndexPath:indexPath];
                cell.emailIDTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.emailIDTF.text = emailIDString;
                if (submitButtonClicked) {
                    if ([emailIDString isEqualToString:@""]) {
                        cell.emailIDIV.hidden = NO;
                    }
                }
                else
                    cell.emailIDIV.hidden =YES;
            }
            else if (indexPath.row == 6) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Industry Segment" forIndexPath:indexPath];
                cell.industrySegmentTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
                cell.industrySegmentTF.text = industrySegmentString;
                if (submitButtonClicked) {
                    if ([industrySegmentString isEqualToString:@""]) {
                        cell.industrySegmentIV.hidden = NO;
                    }
                }
                else
                    cell.industrySegmentIV.hidden =YES;
            }
        }
        else{
            if(contactArray.count == 0){
                cell = [tableView dequeueReusableCellWithIdentifier:@"no data" forIndexPath:indexPath];
            }
            else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:indexPath.row] objectForKey:@"First Name"]];
            cell.designationLabel.text = [[contactArray objectAtIndex:indexPath.row] objectForKey:@"Phone No"];
            cell.emailLabel.text = [[contactArray objectAtIndex:indexPath.row] objectForKey:@"Email ID"];
            }
        }
    }
  
        return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dataTableView) {
        if (stackHolder == 2 && contactArray.count != 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AddContactViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"AddContactViewController"];
            sharedManager.contactArray = contactArray;
            myNavController.selectCellIndex = indexPath.row;
            myNavController.update = update;
            [self presentViewController:myNavController animated:YES completion:nil];

        }
    }
}
- (IBAction)categoryClicked:(id)sender {
    if([Utitlity isConnectedTointernet]){

    sharedManager.passingMode = @"category";
        nameString = @"";
        countryString = @"";
        locationString = @"";
        mobileNumberString = @"";
        emailIDString = @"";
        industrySegmentString = @"";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)countryClicked:(id)sender {
    if([Utitlity isConnectedTointernet]){

    locationString = @"";
    sharedManager.passingMode = @"country";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)locationClicked:(id)sender {
    if([Utitlity isConnectedTointernet]){

    if ([countryString isEqualToString:@""]) {
        [self showMsgAlert:@"Please select country"];
    }
    else{
    sharedManager.passingId = countryID;
    sharedManager.passingMode = @"location";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)industrySegmentClicked:(id)sender {
    if([Utitlity isConnectedTointernet]){

    sharedManager.passingMode = @"industrySegment";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}

-(void)fillTheTF{
    
    if (sharedManager.passingString.length != 0) {
        if ([sharedManager.passingMode isEqualToString: @"category"]) {
            
            categoryString = sharedManager.passingString;
            categoryID = sharedManager.passingId;
        }
        if ([sharedManager.passingMode isEqualToString: @"country"]) {
            
            countryString = sharedManager.passingString;
            countryID = sharedManager.passingId;
        }
        if ([sharedManager.passingMode isEqualToString: @"location"]) {
            
            locationString = sharedManager.passingString;
            locationID = sharedManager.passingId;
            
        }
        if ([sharedManager.passingMode isEqualToString: @"industrySegment"]) {
            NSLog(@"sharedManager.passingString-----%@",sharedManager.passingString);
            industrySegmentString = sharedManager.passingString;
            industrySegmentID = sharedManager.passingId;
        }
        [_dataTableView reloadData];
    }
 
}
- (IBAction)addBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddContactViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"AddContactViewController"];
    myNavController.selectCellIndex = 5000;
    sharedManager.contactArray = contactArray;
    [self presentViewController:myNavController animated:YES completion:nil];
}

- (IBAction)submitBtn:(id)sender {
    [self validateTF];
}
-(void)validateTF{
    if([Utitlity isConnectedTointernet]){
        NSString *msg;
        msg = @"";
        if (![mobileNumberString isEqualToString:@""]) {
            if (mobileNumberString.length != 10) {
                msg = @"Please Enter Valid Phone No";
            }
        }
        if (![emailIDString isEqualToString:@""]) {
            if (![self isValidEmail:emailIDString]) {
                msg = @"Please Enter Valid Email Id";
            }
        }
        if ([locationString isEqualToString:@""]) {
            msg = @"Please Select the location";
        }
        if ([countryString isEqualToString:@""]) {
            msg = @"Please Select the country";
        }
        if ([nameString isEqualToString:@""]) {
            msg = @"Please Enter Name";
        }
        if ([categoryString isEqualToString:@""]) {
            msg = @"Please Select the category";
        }
        if (msg.length !=0) {
            [self showMsgAlert:msg];
        }
        else{
            [self finalSubmitApi];
        }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
    
}
-(void)finalSubmitApi{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:categoryID forKey:@"ExternalStakeholderTypeID"];
    [params setObject:nameString forKey:@"Name"];
    [params setObject:countryID forKey:@"CountryID"];
    [params setObject:locationID forKey:@"LocationID"];
    [params setObject:@""  forKey:@"Address"];
    [params setObject:@""  forKey:@"ZipCode"];
    [params setObject:mobileNumberString forKey:@"MobileNo"];
    [params setObject:@"" forKey:@"Telephone"];
    [params setObject:emailIDString forKey:@"EmailID"];
    [params setObject:@"" forKey:@"Fax"];
    [params setObject:@"" forKey:@"Website"];
    [params setObject:industrySegmentID forKey:@"IndustryId"];
    if (update) {
        [params setObject:[defaults objectForKey:@"UserID"] forKey:@"ModifiedBy"];
        [params setObject:ExternalStakeholderID forKey:@"ExternalStakeholderID"];
    }
    else{
        [params setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
    }
    NSMutableArray *contactsArrayDict = [[NSMutableArray alloc] init];
    for (int i = 0; i < contactArray.count+contactDeletedArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        if (i < contactArray.count) {
            [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"ModifiedBy"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"First Name"]] forKey:@"Name"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"Tittle"]] forKey:@"Title"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"First Name"]] forKey:@"FirstName"];
            [dict setObject:@"" forKey:@"MiddleName"];
            [dict setObject:@"" forKey:@"LastName"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"Designation"]] forKey:@"Designation"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"Email ID"]] forKey:@"EmailId"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"Phone No"]] forKey:@"PhoneNumber"];
            [dict setObject:@"" forKey:@"CompanyAddress"];
            [dict setObject:@"" forKey:@"HomeAddress"];
            [dict setObject:@"profileimage" forKey:@"ImageName"];
            [dict setObject:@"visitingimage" forKey:@"VisitingCardName"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"imageBase64String1"]] forKey:@"ProfilePhoto"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:i] objectForKey:@"imageBase64String2"]] forKey:@"VisitingCard"];
            if (update) {
                [dict setObject:[[contactArray objectAtIndex:i] objectForKey:@"moduleAccessArray"] forKey:@"lstModule"];
                NSLog(@"test----contactArray=====%@",[contactArray objectAtIndex:i]);
                if ([[contactArray objectAtIndex:i] objectForKey:@"ContactID"]) {
                    [dict setObject:[[contactArray objectAtIndex:i] objectForKey:@"ContactID"] forKey:@"ContactID"];
                }
            }
            else{
                NSArray *arr = [[contactArray objectAtIndex:i] objectForKey:@"moduleAccessArray"];
                NSMutableArray *moduleAccessArray = [[NSMutableArray alloc] init];
                for (int j = 0; j < arr.count; j++) {
                    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
                    [dict1 setObject:[[arr objectAtIndex:j] objectForKey:@"ModuleId"] forKey:@"ModuleId"];
                    [dict1 setObject:[[arr objectAtIndex:j] objectForKey:@"Active"] forKey:@"Active"];
                    [moduleAccessArray addObject:dict1];
                }
                [dict setObject:moduleAccessArray forKey:@"lstModule"];
                [dict setObject:@0 forKey:@"IsDeleted"];

            }
        }
        else{
            [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"ModifiedBy"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"First Name"]] forKey:@"Name"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"Tittle"]] forKey:@"Title"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"First Name"]] forKey:@"FirstName"];
            [dict setObject:@"" forKey:@"MiddleName"];
            [dict setObject:@"" forKey:@"LastName"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"Designation"]] forKey:@"Designation"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"Email ID"]] forKey:@"EmailId"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"Phone No"]] forKey:@"PhoneNumber"];
            [dict setObject:@"" forKey:@"CompanyAddress"];
            [dict setObject:@"" forKey:@"HomeAddress"];
            [dict setObject:@"profileimage" forKey:@"ImageName"];
            [dict setObject:@"visitingimage" forKey:@"VisitingCardName"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"imageBase64String1"]] forKey:@"ProfilePhoto"];
            [dict setObject:[NSString stringWithFormat:@"%@",[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"imageBase64String2"]] forKey:@"VisitingCard"];
            
                if ([[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"ContactID"]) {
                    [dict setObject:[[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"ContactID"] forKey:@"ContactID"];
                }
                NSArray *arr = [[contactDeletedArray objectAtIndex:i-contactArray.count] objectForKey:@"moduleAccessArray"];
                NSMutableArray *moduleAccessArray = [[NSMutableArray alloc] init];
                for (int j = 0; j < arr.count; j++) {
                    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
                    [dict1 setObject:[[arr objectAtIndex:j] objectForKey:@"ModuleId"] forKey:@"ModuleId"];
                    [dict1 setObject:@0 forKey:@"Active"];
                    [moduleAccessArray addObject:dict1];
                }
            [dict setObject:moduleAccessArray forKey:@"lstModule"];
            [dict setObject:@1 forKey:@"IsDeleted"];

        }

        [contactsArrayDict addObject:dict];
    }
   
    [params setObject:contactsArrayDict forKey:@"lstContact"];
    
    NSLog(@"post Diict ---->%@",params);
    
    [self showProgress];
  
    if (update) {

        NSString* JsonString = [Utitlity JSONStringConv: params];
        NSLog(@"json 99999----%@",JsonString);

        [[WebServices sharedInstance]apiAuthwithJSON:PostUpdateExtStakeHolderContactDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {

            NSString *error=[json valueForKey:@"error"];
            [self hideProgress];
            
            if(error.length>0){
                [self showMsgAlert:[json valueForKey:@"error_description"]];
                return ;
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Record added successfully" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    }
    else
    {
        NSString* JsonString = [Utitlity JSONStringConv: params];
        NSLog(@"json----%@",JsonString);
    [[WebServices sharedInstance]apiAuthwithJSON:PostExtStakeHolderContactDetails HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
        
        NSString *error=[json valueForKey:@"error"];
        [self hideProgress];
        
        if(error.length>0){
            [self showMsgAlert:[json valueForKey:@"error_description"]];
            return ;
        }else{
            [self showMsgAlert:@"Record added successfully"];
            categoryString = @"";
            nameString = @"";
            countryString = @"";
            locationString = @"";
            mobileNumberString = @"";
            emailIDString = @"";
            industrySegmentString = @"";
            [contactArray removeAllObjects];
            [contactDeletedArray removeAllObjects];

            [_dataTableView reloadData];

        }
        
    }];
    }
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:_dataTableView animated:YES];
    
}

-(void)hideProgress{
    
    [MBProgressHUD hideHUDForView:_dataTableView animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ip = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.categoryTF) {
        categoryString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.nameTF) {
        nameString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.countryTF) {
        countryString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.locationTF) {
        locationString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:4 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.mobleNumberTF) {
        mobileNumberString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:5 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.emailIDTF) {
        emailIDString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    ip = [NSIndexPath indexPathForRow:6 inSection:0];
    cell = [_dataTableView cellForRowAtIndexPath:ip];
    if (textField == cell.industrySegmentTF) {
        industrySegmentString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }

   

    return YES;
}

-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(BOOL) isValidEmail:(NSString *)checkString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];

}
-(void)updateData{
    if([Utitlity isConnectedTointernet]){
        
        [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@MITRStakeholderMainDetailsByExtId?stakeholderid=%@", BASEURL,sharedManager.passingId];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",dataArray);
              ExternalStakeholderID = [[dataArray objectAtIndex:0] objectForKey:@"ExternalStakeholderID"];
              categoryString = [[dataArray objectAtIndex:0] objectForKey:@"Type"];
              nameString = [[dataArray objectAtIndex:0] objectForKey:@"Name"];
              countryString = [[dataArray objectAtIndex:0] objectForKey:@"Country"];
              locationString = [[dataArray objectAtIndex:0] objectForKey:@"Location"];
              mobileNumberString = [[dataArray objectAtIndex:0] objectForKey:@"MobileNo"];
              emailIDString = [[dataArray objectAtIndex:0] objectForKey:@"EmailID"];
              if ([[dataArray objectAtIndex:0] objectForKey:@"Industry"] == (id)[NSNull null] ){
                  industrySegmentString = @"";
              }
              else{
                  industrySegmentString = [[dataArray objectAtIndex:0] objectForKey:@"Industry"];
              }
              categoryID = [[dataArray objectAtIndex:0] objectForKey:@"ExternalStakeholderTypeID"];
              countryID = [[dataArray objectAtIndex:0] objectForKey:@"CountryID"];
              locationID = [[dataArray objectAtIndex:0] objectForKey:@"LocationID"];
              industrySegmentID = [[dataArray objectAtIndex:0] objectForKey:@"IndustryId"];
              [contactArray removeAllObjects];
              [contactDeletedArray removeAllObjects];

              imageString1 = @"";
              imageString2 = @"";
              imageBase64String1 = @"";
              imageBase64String2 = @"";
              for (int i =0; i < [[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] count]; i++){
                  NSString *tittleID;
                  if ([[[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"Title"] intValue] == 0) {
                      tittleID  = @"1";
                  }
                  else if ([[[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"Title"] intValue] == 1) {
                      tittleID  = @"2";
                  }
                  
                  NSDictionary *dict = @{ @"Tittle" : tittleID, @"ContactID" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"ContactID"],@"Tittle String" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"Prefix"], @"First Name" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"FirstName"],@"Designation" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"Designation"],@"Email ID" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"EmailId"],@"Phone No" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"PhoneNumber"],@"imageString1" : @"",@"imageString2" : @"",@"imageBase64String1" : @"",@"imageBase64String2" : @"",@"imageContent" : @"",@"moduleAccessArray" : [[[[dataArray objectAtIndex:0] objectForKey:@"lstContact"] objectAtIndex:i] objectForKey:@"lstModule"]};
                  [contactArray addObject:dict];
              }
             
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
- (IBAction)updateBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)updateBtn:(id)sender {
    [self validateTF];
}
- (IBAction)deleteContactBtn:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_dataTableView];
    NSIndexPath *indexPath = [_dataTableView indexPathForRowAtPoint:buttonPosition];
    if (update){
        [contactDeletedArray addObject:contactArray[indexPath.row]];
        [contactArray removeObjectAtIndex:indexPath.row];
        NSLog(@"contactDeletedArray----%@",contactDeletedArray);
        NSLog(@"contactArray----%@",contactArray);

    }
    else{
        [contactArray removeObjectAtIndex:indexPath.row];
        NSLog(@"contactArray----%@",contactArray);
    }
    [_dataTableView reloadData];
}

@end
