#import <UIKit/UIKit.h>
#import "ActionListViewController.h"
#import "UpdateActionProgressViewController.h"
#import "MeetingDetailsViewController.h"
#import "AddStackHoldersViewController.h"
#import "UpdateStakeHolderViewController.h"
#import "ContactDirectoryViewController.h"
#import "DashBoardPieChartViewController.h"
#import "UpdateMeetingStatusViewController.h"
#import "MeetingCalenderViewController.h"
#import "ConductMeetingViewController.h"

@interface SWUITableViewCell : UITableViewCell
@end

@interface MenuViewController : UITableViewController
@property (nonatomic, strong) ActionListViewController *ActionListViewController;
@property (nonatomic, strong) UpdateActionProgressViewController *UpdateActionProgressViewController;
@property (nonatomic, strong) MeetingDetailsViewController *MeetingDetailsViewController;
@property (nonatomic, strong) AddStackHoldersViewController *AddStackHoldersViewController;
@property (nonatomic, strong) UpdateStakeHolderViewController *UpdateStakeHolderViewController;
@property (nonatomic, strong) ContactDirectoryViewController *ContactDirectoryViewController;
@property (nonatomic, strong) DashBoardPieChartViewController *DashBoardPieChartViewController;
@property (nonatomic, strong) UpdateMeetingStatusViewController *UpdateMeetingStatusViewController;
@property (nonatomic, strong) MeetingCalenderViewController *MeetingCalenderViewController;
@property (nonatomic, strong) ConductMeetingViewController *ConductMeetingViewController;

@end
