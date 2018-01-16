//
//  CustomTableViewCell.h
//  test
//
//  Created by ceaselez on 29/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *employeeTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property (weak, nonatomic) IBOutlet UITextField *assignedToTF;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *targetDateTF;
@property (weak, nonatomic) IBOutlet UITextField *actionTypeTF;
@property (weak, nonatomic) IBOutlet UITextView *actionDescriptionTV;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UIImageView *employeeIV;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIV;
@property (weak, nonatomic) IBOutlet UIImageView *companyIV;
@property (weak, nonatomic) IBOutlet UIImageView *assignedToIV;
@property (weak, nonatomic) IBOutlet UIImageView *startDateIV;
@property (weak, nonatomic) IBOutlet UIImageView *targetDateIV;
@property (weak, nonatomic) IBOutlet UIImageView *actionTypeIV;
@property (weak, nonatomic) IBOutlet UIImageView *actionDescrptionIV;
@property (weak, nonatomic) IBOutlet UILabel *plannerListDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerListHeadderLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerEmployeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerAssignedToLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerTargetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannerActionTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *plannerActionDescriptionTV;
@property (weak, nonatomic) IBOutlet SZTextView *updateRemaksTV;
@property (weak, nonatomic) IBOutlet UITextField *updateCompletionDateTF;
@property (weak, nonatomic) IBOutlet UITextView *actionListDescripition;
@property (weak, nonatomic) IBOutlet UILabel *actionListAssignee;
@property (weak, nonatomic) IBOutlet UILabel *actionListDate;
@property (weak, nonatomic) IBOutlet UILabel *actionListTargetDate;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
