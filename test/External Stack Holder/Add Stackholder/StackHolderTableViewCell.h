//
//  StackHolderTableViewCell.h
//  test
//
//  Created by ceaselez on 11/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface StackHolderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIV;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UIImageView *countryIV;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIImageView *locationIV;
@property (weak, nonatomic) IBOutlet UITextField *mobleNumberTF;
@property (weak, nonatomic) IBOutlet UIImageView *mobileNumerIV;
@property (weak, nonatomic) IBOutlet UITextField *emailIDTF;
@property (weak, nonatomic) IBOutlet UIImageView *emailIDIV;
@property (weak, nonatomic) IBOutlet UITextField *industrySegmentTF;
@property (weak, nonatomic) IBOutlet UIImageView *industrySegmentIV;
@property (weak, nonatomic) IBOutlet UITextField *popOverPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *popOverEmailID;
@property (weak, nonatomic) IBOutlet UITextField *popOverDesignation;
@property (weak, nonatomic) IBOutlet UITextField *popOverFirstName;
@property (weak, nonatomic) IBOutlet UITextField *popOverTittle;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *UpdateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactCategory;
@property (weak, nonatomic) IBOutlet UITextField *contactIndustry;
@property (weak, nonatomic) IBOutlet UITextField *contactCompany;
@property (weak, nonatomic) IBOutlet UITextField *contactContacts;
@property (weak, nonatomic) IBOutlet UILabel *noOfCompany;
@property (weak, nonatomic) IBOutlet UILabel *noOfContacts;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactDesignation;
@property (weak, nonatomic) IBOutlet UITextView *contactMailID;
@property (weak, nonatomic) IBOutlet UIButton *popOverCancelBtn;
@property (weak, nonatomic) IBOutlet SZTextView *popOverModule;
@property (weak, nonatomic) IBOutlet UIButton *popOverDoneBtn;
@property (weak, nonatomic) IBOutlet UITextView *contactPhoneNo;
@end
