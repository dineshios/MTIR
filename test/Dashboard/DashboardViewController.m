//
//  DashboardViewController.m
//  test
//
//  Created by ceaselez on 27/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "DashboardViewController.h"
#import "SWRevealViewController.h"
#import "DashBoardPieChartViewController.h"
#import "MySharedManager.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *revealButtonItem;
@property (nonatomic, strong) DashBoardPieChartViewController *DashBoardPieChartViewController;

@end

@implementation DashboardViewController
{
    MySharedManager *sharedManager;
}
- (void)viewDidLoad {
    sharedManager = [MySharedManager sharedManager];
    sharedManager.slideMenuSlected = @"Dashboard";

    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    SWRevealViewController *revealViewController = self.revealViewController;
    [self.revealViewController revealToggleAnimated:YES];

    if ( revealViewController )
    {
        [self.revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}
- (IBAction)stackholderBtn:(id)sender {
    sharedManager.passingMode = @"Category wise companies";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashBoardPieChartViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
}
- (IBAction)actionplannerBtn:(id)sender {
    sharedManager.passingMode = @"Action Analysis(Self)";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashBoardPieChartViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"DashBoardPieChartViewController"];
    [self presentViewController:myNavController animated:YES completion:nil];
 
}



@end
