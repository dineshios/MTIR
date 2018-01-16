//
//  ContactDirectoryViewController.m
//  test
//
//  Created by ceaselez on 15/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "ContactDirectoryViewController.h"
#import "StackHolderTableViewCell.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "SearchViewController.h"
#import "MySharedManager.h"

@interface ContactDirectoryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UITableView *datatableView;

@end

@implementation ContactDirectoryViewController
{
    NSString *category;
    NSString *industry;
    NSString *company;
    NSString *contact;
    NSString *noOfCompanies;
    NSString *noOfContacts;
    NSString *contactName;
    NSString *contactMailID;
    NSString *contactDesignation;
    NSString *contactPhoneNo;

    NSString *categoryID;
    NSString *industryID;
    NSString *companyID;
    NSString *contactID;
    MySharedManager *sharedManager;
    int rowCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedManager = [MySharedManager sharedManager];
    // Do any additional setup after loading the view.
    rowCount = 4;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [_menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        category =@"";
        industry= @"";
        company = @"";
        contact = @"";
        rowCount = 4;
    }
    else{
        [self fillTheTF];
    }
    [_datatableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        sharedManager.slideMenuSlected = @"no";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StackHolderTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Category"];
        cell.contactCategory.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        cell.contactCategory.text = category;
    }
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Industry"];
        cell.contactIndustry.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        cell.contactIndustry.text = industry;
    }
    if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Company"];
        cell.contactCompany.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        cell.contactCompany.text = company;
    }
    if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Contacts"];
        cell.contactContacts.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        cell.contactContacts.text = contact;
    }
    if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"noOfCompany"];
        cell.noOfCompany.text = noOfCompanies;
    }
    if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"noOfContact"];
        cell.noOfContacts.text = noOfContacts;
    }
    if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"contactDetails"];
        cell.contactName.text = contactName;
        cell.contactMailID.text = contactMailID;
        cell.contactDesignation.text = contactDesignation;
        cell.contactPhoneNo.text = contactPhoneNo;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        return 250;
    }
    return 90;
}
- (IBAction)selectCategoryBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){
        industry= @"";
        company = @"";
        contact = @"";
        sharedManager.passingMode = @"categoryContact";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}

- (IBAction)selectIndustry:(id)sender {
    if([Utitlity isConnectedTointernet] ){
        if ([category isEqualToString:@""] || category == nil) {
            [self showMsgAlert:@"Please select Category"];
        }
        else{
        company = @"";
        contact = @"";
        sharedManager.passingMode = @"industryContact";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
        }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)selectCompany:(id)sender {
    if([Utitlity isConnectedTointernet]){
        if ([category isEqualToString:@""] || category == nil) {
            [self showMsgAlert:@"Please select Category"];
        }
        else{
        contact = @"";
        sharedManager.passingMode = @"companyContact";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        myNavController.categoryID = categoryID;
        sharedManager.passingId = industryID;
            if ([industry isEqualToString:@""] || industry == nil) {
                sharedManager.passingId = @"00000000-0000-0000-0000-000000000000";
            }
        [self presentViewController:myNavController animated:YES completion:nil];
        }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)selectContact:(id)sender {
    if([Utitlity isConnectedTointernet]){
        if ([category isEqualToString:@""] || category == nil) {
            [self showMsgAlert:@"Please select Category"];
        }
        else{
        sharedManager.passingMode = @"contact";
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        if ([company isEqualToString:@""] || company == nil) {
            myNavController.companyID = @"00000000-0000-0000-0000-000000000000";
        }
        else{
            myNavController.companyID = companyID;
        }
        if ([industry isEqualToString:@""] || industry == nil) {
            myNavController.industryID = @"00000000-0000-0000-0000-000000000000";
        }
        else{
            myNavController.industryID = industryID;
        }
        if ([category isEqualToString:@""] || category == nil) {
            myNavController.categoryID = @"00000000-0000-0000-0000-000000000000";
        }
        else{
            myNavController.categoryID = categoryID;
        }
        [self presentViewController:myNavController animated:YES completion:nil];
        }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)fillTheTF{
    
    if (sharedManager.passingString.length != 0) {
        if ([sharedManager.passingMode isEqualToString: @"categoryContact"]) {
            category = sharedManager.passingString;
            categoryID = sharedManager.passingId;
            industryID = @"00000000-0000-0000-0000-000000000000";
            companyID = @"00000000-0000-0000-0000-000000000000";
            [self noOfCompanieslApi];
            [self noOfContactsApi];
            rowCount = 6;

        }
        if ([sharedManager.passingMode isEqualToString: @"industryContact"]) {
            industry = sharedManager.passingString;
            industryID = sharedManager.passingId;
            companyID = @"00000000-0000-0000-0000-000000000000";
            [self noOfContactsApi];
            [self noOfCompanieslApi];
            rowCount = 6;
        }
        if ([sharedManager.passingMode isEqualToString: @"companyContact"]) {
            company = sharedManager.passingString;
            companyID = sharedManager.passingId;
            [self noOfContactsApi];
            rowCount = 6;
        }
       
        if ([sharedManager.passingMode isEqualToString: @"contact"]) {
            contact = sharedManager.passingString;
            contactID = sharedManager.passingId;
            [self contactDetailApi];
            rowCount = 7;
        }
        [_datatableView reloadData];
    }
    
}
-(void)contactDetailApi{
    if([Utitlity isConnectedTointernet]){
        [self showProgress];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRContactDetailsById?contactid=%@",BASEURL,contactID]]];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if(httpResponse.statusCode == 200)
                                              {
                                                  NSError *parseError = nil;
                                                  NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSLog(@"dataArray---%@",dataArray);
                                                  contactDesignation = [[dataArray objectAtIndex:0] objectForKey:@"ContactDesignation"];
                                                  contactMailID = [[dataArray objectAtIndex:0] objectForKey:@"ContactEmailID"];
                                                  contactName = [[dataArray objectAtIndex:0] objectForKey:@"ContactPersonName"];
                                                  contactPhoneNo = [[dataArray objectAtIndex:0] objectForKey:@"ContactPhone"];
                                                  rowCount = 7;
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self hideProgress];
                                                      [_datatableView reloadData];
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
-(void)noOfContactsApi{
    if([Utitlity isConnectedTointernet]){
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRContact?ExternalStakeholderTypeID=%@&IndustrysegmentId=%@&ExternalStakeholderID=%@",BASEURL,categoryID,industryID,companyID]]];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if(httpResponse.statusCode == 200)
                                              {
                                                  NSError *parseError = nil;
                                                  NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSLog(@"noOfContacts---%lu",(unsigned long)dataArray.count);
                                                  noOfContacts = [NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      rowCount = 6;
                                                   
                                                      [_datatableView reloadData];
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
-(void)noOfCompanieslApi{
    if([Utitlity isConnectedTointernet]){
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetMITRCompany?externalStakeholderId=%@&industryId=%@",BASEURL,categoryID,industryID]]];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if(httpResponse.statusCode == 200)
                                              {
                                                  NSError *parseError = nil;
                                                  NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSLog(@"noOfCompanies---%lu",(unsigned long)dataArray.count);
                                                  noOfCompanies = [NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if (dataArray.count == 1) {
                                                          company = [[dataArray objectAtIndex:0] objectForKey:@"CompanyName"];
                                                          companyID = [[dataArray objectAtIndex:0] objectForKey:@"ExternalStakeholderID"];
                                                      }

                                                      [_datatableView reloadData];
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
    [MBProgressHUD showHUDAddedTo:_datatableView animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:_datatableView animated:YES];
}
@end
