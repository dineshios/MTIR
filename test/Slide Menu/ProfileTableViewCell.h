//
//  ProfileTableViewCell.h
//  Ease2Lend
//
//  Created by Dineshkumar Arumugam on 02/07/17.
//  Copyright © 2017 TechnoTackle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickableBtn;

@end
