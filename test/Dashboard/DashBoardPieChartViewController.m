//
//  DashBoardPieChartViewController.m
//  test
//
//  Created by ceaselez on 19/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "DashBoardPieChartViewController.h"
#import "MySharedManager.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "DashBoardCollectionViewCell.h"
#import "SWRevealViewController.h"
#import "XYPieChart.h"
#import "SearchViewController.h"

#define PIE_HEIGHT 250

@interface DashBoardPieChartViewController ()<XYPieChartDelegate, XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (weak, nonatomic) IBOutlet UIView *colorIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@end

@implementation DashBoardPieChartViewController

{
    MySharedManager *sharedManager;
    NSArray *dataArray;
    NSMutableArray *colorArray;
    __weak IBOutlet UICollectionView *dataCollectionView;
    __weak IBOutlet UIButton *menuBtn;
    NSString *categoryString;
    NSString *categoryID;
    NSString *industrySegmentString;
    NSString *industrySegmentID;
    int dependent;
    __weak IBOutlet UILabel *tittleLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    [self.pieChartRight setAnimationSpeed:1.0];
    [self.pieChartRight setShowLabel:YES];
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    sharedManager = [MySharedManager sharedManager];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [menuBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

   
}
-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
    colorArray = [[NSMutableArray alloc] init];
    _selectBtn.hidden = YES;
    _selectLabel.hidden = YES;
    self.colorIndicator.backgroundColor = [_sliceColors objectAtIndex:0];
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]) {
        _backBtn.hidden = YES;
        dependent = 2;
        _selectLabel.text = @"All";
        categoryID = @"00000000-0000-0000-0000-000000000000";
        industrySegmentID = @"00000000-0000-0000-0000-000000000000";
    }
    else if ([sharedManager.slideMenuSlected isEqualToString:@"Dashboard"]) {
        dependent = 2;
        _selectLabel.text = @"All";
        categoryID = @"00000000-0000-0000-0000-000000000000";
        industrySegmentID = @"00000000-0000-0000-0000-000000000000";
    }
    else{
        [self fillTheTF];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadDataFromApi];
   
}
-(void)viewDidAppear:(BOOL)animated{
    if ([sharedManager.slideMenuSlected isEqualToString:@"yes"]||[sharedManager.slideMenuSlected isEqualToString:@"update"] || [sharedManager.slideMenuSlected isEqualToString:@"Dashboard"]) {
        sharedManager.slideMenuSlected = @"no";
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    CGSize calCulateSizze = CGSizeMake(150, 44);
    return calCulateSizze;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    DashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([[dataArray objectAtIndex:indexPath.row] objectForKey:@"Status"] != [NSNull null]) {
        cell.titleLabel.text = [NSString stringWithFormat: @"%@-%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Status"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Count"]];
        cell.colorView.backgroundColor = [_sliceColors objectAtIndex:indexPath.row];
    }
    else{
        cell.titleLabel.text = @"";
        cell.colorView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}



-(void)loadDataFromApi{
   
    if([Utitlity isConnectedTointernet]){
      
        [self showProgress];
        NSMutableURLRequest *urlRequest;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([sharedManager.passingMode isEqualToString:@"Action Analysis(Self)"]) {
            _selectBtn.hidden = NO;
            _selectLabel.hidden = NO;
            tittleLabel.text = @"Action Analysis(Self)";
            if ( dependent == 2) {
                 urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetActionAnalysidChart?userid=%@",BASEURL,[defaults objectForKey:@"UserID"]]]];
            }
            else{
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetActionAnalysidChart?userid=%@&dependency=%d",BASEURL,[defaults objectForKey:@"UserID"],dependent]]];
            }

        }
        if ([sharedManager.passingMode isEqualToString:@"Action Analysis(Others)"]) {
            tittleLabel.text = @"Action Analysis(Others)";
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetActionAnalysisOthersChart?userid=%@",BASEURL,[defaults objectForKey:@"UserID"]]]];
        }
        if ([sharedManager.passingMode isEqualToString:@"Dependency Actions Analysis"]) {
            tittleLabel.text = @"Dependency Actions Analysis";
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetDependencyActionAnalysisChart?userid=%@",BASEURL,[defaults objectForKey:@"UserID"]]]];
        }
        if ([sharedManager.passingMode isEqualToString:@"Delayed Completion  Actions Analysis"]) {
            tittleLabel.text = @"Delayed Completion  Actions Analysis";
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetDelayedCompletionActionAnalysisChart?userid=%@",BASEURL,[defaults objectForKey:@"UserID"]]]];
        }
        if ([sharedManager.passingMode isEqualToString:@"Industry wise companies"]) {
            tittleLabel.text = @"Industry wise companies";
            _selectBtn.hidden = NO;
            _selectLabel.hidden = NO;
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetCategoryAndIndustryWiseChart?userid=%@&type=Industry&categoryOrindustryid=%@",BASEURL,[defaults objectForKey:@"UserID"],industrySegmentID]]];
        }
        if ([sharedManager.passingMode isEqualToString:@"Category wise companies"]) {
            tittleLabel.text = @"Category wise companies";
            _selectBtn.hidden = NO;
            _selectLabel.hidden = NO;
            urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@GetCategoryAndIndustryWiseChart?userid=%@&type=Category&categoryOrindustryid=%@",BASEURL,[defaults objectForKey:@"UserID"],categoryID]]];
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
                                                  _slices = [[NSMutableArray alloc] init];
                                                  for (int i = 0; i<dataArray.count; i++) {
                                                      [_slices addObject:[[dataArray objectAtIndex:i] objectForKey:@"Count"]];
                                                     
                                                  }
                                                
                                                  dispatch_async(dispatch_get_main_queue(), ^{

                                                      [self hideProgress];
                                                      if (dataArray.count != 0) {
                                                          _colorIndicator.hidden = NO;
                                                          [_pieChartRight reloadData];
                                                          [self pieChart:_pieChartRight didSelectSliceAtIndex:0];
                                                          [dataCollectionView reloadData];
                                                      }
                                                      else{
                                                          [_pieChartRight reloadData];
                                                          [dataCollectionView reloadData];
                                                          _colorIndicator.hidden = YES;
                                                          self.selectedSliceLabel.text = @"No data found";
                                                      }
                                                    
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


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:index];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    if (index != 0) {
        [_pieChartRight setSliceDeselectedAtIndex:0];
    }
    if ([[dataArray objectAtIndex:index] objectForKey:@"Status"] != [NSNull null]) {
        self.colorIndicator.backgroundColor = [_sliceColors objectAtIndex:index];

    self.selectedSliceLabel.text = [NSString stringWithFormat:@"%@ - %@",[[dataArray objectAtIndex:index] objectForKey:@"Status"],[self.slices objectAtIndex:index]];
    }
    else{
        self.selectedSliceLabel.text = [NSString stringWithFormat:@"No of Companies - %@",[self.slices objectAtIndex:index]];
    }
}


-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:self.pieChartRight animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:self.pieChartRight animated:YES];
}


-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Title"
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)slectBtn:(id)sender {
    if ([sharedManager.passingMode isEqualToString:@"Action Analysis(Self)"]) {

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _selectLabel.text = @"All";
        dependent = 2;
        [self loadDataFromApi];

    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Dependent" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _selectLabel.text = @"Dependent";
        dependent = 1;
        [self loadDataFromApi];

    }];
        
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Independent" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _selectLabel.text = @"Independent";
        dependent = 0;
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
    if ([sharedManager.passingMode isEqualToString:@"Category wise companies"]) {

    if([Utitlity isConnectedTointernet]){
        
        sharedManager.passingMode = @"categoryContact";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
     }else{
        [self showMsgAlert:NOInternetMessage];
     }
    }
    if ([sharedManager.passingMode isEqualToString:@"Industry wise companies"]) {

    if([Utitlity isConnectedTointernet]){
        
        sharedManager.passingMode = @"industryContact";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
     }else{
        [self showMsgAlert:NOInternetMessage];
     }
    }
}

-(void)fillTheTF{
    
        if ([sharedManager.passingMode isEqualToString: @"categoryContact"]) {
            sharedManager.passingMode = @"Category wise companies";
            if (sharedManager.passingString.length != 0) {
            categoryString = sharedManager.passingString;
            categoryID = sharedManager.passingId;
            _selectLabel.text = categoryString;
            [self loadDataFromApi];
            }
        }
      
        if ([sharedManager.passingMode isEqualToString: @"industryContact"]) {
            sharedManager.passingMode = @"Industry wise companies";
            if (sharedManager.passingString.length != 0) {
            industrySegmentString = sharedManager.passingString;
            industrySegmentID = sharedManager.passingId;
            _selectLabel.text = industrySegmentString;
            [self loadDataFromApi];
            }
          
        }
    
}
- (IBAction)backBtn:(id)sender {
    NSLog(@"test---0000000");
    [self  dismissViewControllerAnimated:YES completion:nil];
}

@end
