//
//  ConductMeetingTableViewCell.h
//  test
//
//  Created by ceaselez on 11/01/18.
//  Copyright © 2018 ceaselez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConductMeetingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDetailsLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTimeTF;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeSubtitleLabel;

@end
