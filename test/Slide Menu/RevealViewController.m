//
//  RevealViewController.m
//  SWMenuOnTop
//
//  Created by Patrick BODET on 28/03/2016.
//  Copyright © 2016 Patrick BODET. All rights reserved.
//

#import "RevealViewController.h"

@interface RevealViewController ()

// Optional
@property (strong, nonatomic) UIView *coverView;

@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
        
    [self tapGestureRecognizer];
    [self panGestureRecognizer];
    
    self.coverView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _coverView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWRevealController delegate

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
    if (position == FrontViewPositionRight) {
        self.frontViewController.view.userInteractionEnabled = NO;
        
        // Optional
        [self.frontViewController.view addSubview:_coverView];
    }
    else {
        self.frontViewController.view.userInteractionEnabled = YES;
        
        // Optional
        [_coverView removeFromSuperview];
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
}

@end
