//
//  MeetingDetailsTableViewCell.h
//  test
//
//  Created by ceaselez on 05/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface MeetingDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SZTextView *meetingDescriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *meetingDescriptionIV;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UIImageView *dateIV;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UIImageView *startTimeIV;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UIImageView *endTimeIV;
@property (weak, nonatomic) IBOutlet UITextField *meetingRoomTF;
@property (weak, nonatomic) IBOutlet UIImageView *meetingRoomIV;
@property (weak, nonatomic) IBOutlet UITextField *meetingModeTF;
@property (weak, nonatomic) IBOutlet UIImageView *meetingModeIV;
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *roleTF;
@property (weak, nonatomic) IBOutlet UITextField *memberTF;
@property (weak, nonatomic) IBOutlet UITextField *durationTF;
@property (weak, nonatomic) IBOutlet SZTextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UILabel *membersNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *membersRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *agendaDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *agendaRoleLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *agendaDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *agendaCancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeGapLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeZoneTF;
@property (weak, nonatomic) IBOutlet UIButton *popOverDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *popOverCancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *updateMeetingDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateActionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateResponsibleLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateMeetingDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *calenderMeetingDescrictionTV;
@property (weak, nonatomic) IBOutlet UILabel *calenderCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *calenderFrequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *calenderMeetingDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteMemberBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteAgendaBtn;

@end
