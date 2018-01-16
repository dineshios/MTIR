//
//  AddContactViewController.m
//  test
//
//  Created by ceaselez on 27/12/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "AddContactViewController.h"
#import "StackHolderTableViewCell.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MySharedManager.h"
#import "TakePhotoViewController.h"
#import "GlobalURL.h"



@interface AddContactViewController ()
@property (weak, nonatomic) IBOutlet UITableView *popOverTableView;

@end

@implementation AddContactViewController
{
    NSMutableArray *contactArray;

    NSString *tittleString;
    NSString *firstNameString;
    NSString *designationString;
    NSString *emailIdString;
    NSString *phoneNoString;
    int title;
    NSMutableArray *moduleAccessArray;
    
    NSString *imageString1;
    NSString *imageString2;
    NSString *imageContent;
    NSString *imageBase64String1;
    NSString *imageBase64String2;
    NSString *moduleString;
    NSString *contactID;
    NSArray *dataArray;
    
    MySharedManager *sharedManager;
    
    NSIndexPath *ip;
    StackHolderTableViewCell *cell;

    __weak IBOutlet UIView *moduleAccessView;
    __weak IBOutlet UITableView *moduleAccessTableView;
    __weak IBOutlet NSLayoutConstraint *moduleAccessHeight;
    
    NSMutableArray *selectedIndexArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [MySharedManager sharedManager];
    contactArray = [[NSMutableArray alloc] init];
    selectedIndexArray = [[NSMutableArray alloc] init];
    dataArray = [[NSArray alloc] init];



    moduleAccessArray = [[NSMutableArray alloc] init];
        tittleString = @"";
        firstNameString = @"";
        designationString = @"";
        emailIdString = @"";
        phoneNoString = @"";
        imageString1 = @"";
        imageString2 = @"";
        imageBase64String1 = @"";
        imageBase64String2 = @"";
        moduleString = @"";
        contactID = @"";

    contactArray = sharedManager.contactArray;

    if (_selectCellIndex != 5000 && _selectCellIndex != 5001) {
        NSLog(@"contactArray---->%@",contactArray);
        tittleString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"Tittle String"];
        firstNameString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"First Name"];
        designationString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"Designation"];
        emailIdString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"Email ID"];
        phoneNoString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"Phone No"];
        moduleAccessArray =[[[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"moduleAccessArray"] mutableCopy];
        dataArray =[[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"moduleAccessArray"];
        if ([[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"ContactID"]) {
            contactID = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"ContactID"];
        }
        NSArray *ModuleNameArray = [dataArray valueForKey:@"ModuleName"];
        if ([ModuleNameArray containsObject:@"External Stakeholder Management"]) {
            NSUInteger index = [ModuleNameArray indexOfObject:@"External Stakeholder Management"];
            [moduleAccessArray removeObjectAtIndex:index];
        }
        

    }
    moduleAccessView.hidden = YES;
    [_popOverTableView reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    if ([sharedManager.passingMode isEqualToString: @"takePhoto"]) {
        [self fillTheTF];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == moduleAccessTableView) {
        return moduleAccessArray.count+1;
    }
   
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == moduleAccessTableView) {
        if (indexPath.row == moduleAccessArray.count) {
            return 44;
        }
        else{
        NSString *cellText = [[moduleAccessArray objectAtIndex:indexPath.row] objectForKey:@"ModuleName"];
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        return labelSize.height + 20;
        }
    }
    else if(indexPath.row == 5){
            return [self heightForText:moduleString withFont:[UIFont fontWithName:@"Helvetica" size:14] andWidth:self.view.bounds.size.width-133]+45;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier ;
   
    StackHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (tableView == moduleAccessTableView) {
        
        if (indexPath.row == moduleAccessArray.count) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"button" forIndexPath:indexPath];
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
            cell.textLabel.text = [[moduleAccessArray objectAtIndex:indexPath.row] objectForKey:@"ModuleName"];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];

        }
        if ( indexPath.row != moduleAccessArray.count) {
            if ([[[moduleAccessArray objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue] == 1) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check"]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [selectedIndexArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }
            else{
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
                cell.accessoryType = UITableViewCellAccessoryNone;

            }
        }
    }
    else{
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Tittle" forIndexPath:indexPath];
            cell.popOverTittle.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            [cell.popOverTittle setText:tittleString];
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"First Name" forIndexPath:indexPath];
            cell.popOverFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.popOverFirstName.text = firstNameString;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Designation" forIndexPath:indexPath];
            cell.popOverDesignation.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.popOverDesignation.text = designationString;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Email Id" forIndexPath:indexPath];
            cell.popOverEmailID.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.popOverEmailID.text = emailIdString;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Phone No" forIndexPath:indexPath];
            cell.popOverPhoneNo.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            cell.popOverPhoneNo.text = phoneNoString;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Module Access" forIndexPath:indexPath];
            cell.popOverModule.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
            moduleString = @"";
            for (int i = 0; i<moduleAccessArray.count; i++) {
                if ([[[moduleAccessArray objectAtIndex:i] objectForKey:@"Active"] intValue] == 1) {
                    if (moduleString.length == 0) {
                        moduleString = [NSString stringWithFormat:@"%@",[[moduleAccessArray objectAtIndex:i] objectForKey:@"ModuleName"]];
                    }
                    else{
                    moduleString = [NSString stringWithFormat:@"%@,\n%@",moduleString,[[moduleAccessArray objectAtIndex:i] objectForKey:@"ModuleName"]];
                    }
                }
            }
            cell.popOverModule.text = moduleString;
        }
        else if (indexPath.row == 6) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Buttons" forIndexPath:indexPath];
            if (_selectCellIndex != 5000 && !_update && _selectCellIndex != 5001) {
                [cell.popOverDoneBtn setTitle:@"Update" forState:UIControlStateNormal];
                [cell.popOverCancelBtn setTitle:@"Delete" forState:UIControlStateNormal];
            }
            else{
                [cell.popOverDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
                [cell.popOverCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            }
        }
    }
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    if (tableView == moduleAccessTableView) {
        if (path.row <moduleAccessArray.count) {
            StackHolderTableViewCell *cell = [tableView cellForRowAtIndexPath:path];
           
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
                cell.accessoryType = UITableViewCellAccessoryNone;
                [selectedIndexArray removeObject:[NSString stringWithFormat:@"%ld",(long)path.row]];
            } else {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check"]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [selectedIndexArray addObject:[NSString stringWithFormat:@"%ld",(long)path.row]];

            }
        }
        
    }
    
}
- (IBAction)titleTFClicked:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Mr" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tittleString = @"Mr";
        firstNameString = @"";
        designationString = @"";
        emailIdString = @"";
        phoneNoString = @"";
        title = 1;
        
        [_popOverTableView reloadData];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Ms" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tittleString = @"Ms";
        firstNameString = @"";
        designationString = @"";
        emailIdString = @"";
        phoneNoString = @"";
        title = 2;
        
        
        [_popOverTableView reloadData];
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)cancelBtn:(id)sender {
    if (_selectCellIndex != 5000 && !_update && _selectCellIndex != 5001) {
        [contactArray removeObjectAtIndex:_selectCellIndex];
        }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)popOverDoneBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){
        
        if ([tittleString isEqualToString:@""]) {
            [self showMsgAlert:@"Please Select the Title"];
        }
        else if ([firstNameString isEqualToString:@""]) {
            [self showMsgAlert:@"Please Enter First Name"];
        }
        
        else if ([emailIdString isEqualToString:@""]) {
            [self showMsgAlert:@"Please Enter Email ID"];
        }
        else if ([phoneNoString isEqualToString:@""]) {
            [self showMsgAlert:@"Please Enter Phone No"];
        }
        else if (![self isValidEmail:emailIdString]) {
            [self showMsgAlert:@"Please Enter Valid Email Id"];
        }
        else if (phoneNoString.length != 10) {
            [self showMsgAlert:@"Please Enter Valid Phone No"];
        }
        
        else{
            NSArray *ModuleNameArray = [dataArray valueForKey:@"ModuleName"];
            if ([ModuleNameArray containsObject:@"External Stakeholder Management"]) {
            NSDictionary *External =  @{
                @"AccessId" : @"00000000-0000-0000-0000-000000000000",
                @"Active" : @"0",
                @"ModuleId" : @"3",
                @"ModuleName" : @"External Stakeholder Management",
            };
            [moduleAccessArray addObject:External];
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:tittleString forKey:@"Tittle String"];
            [dict setObject:[NSString stringWithFormat:@"%d",title] forKey:@"Tittle"];
            [dict setObject:firstNameString forKey:@"First Name"];
            [dict setObject:designationString forKey:@"Designation"];
            [dict setObject:emailIdString forKey:@"Email ID"];
            [dict setObject:phoneNoString forKey:@"Phone No"];
            [dict setObject:imageString1 forKey:@"imageString1"];
            [dict setObject:imageString2 forKey:@"imageString2"];
            [dict setObject:imageBase64String1 forKey:@"imageBase64String1"];
            [dict setObject:imageBase64String1 forKey:@"imageBase64String2"];
            [dict setObject:moduleAccessArray forKey:@"moduleAccessArray"];
            if (contactID.length != 0) {
                [dict setObject:contactID forKey:@"ContactID"];
            }
         
            if (_selectCellIndex != 5000 && _selectCellIndex != 5001) {
                [contactArray replaceObjectAtIndex:_selectCellIndex withObject:dict];
            }
            else{

                [contactArray addObject:dict];
            }
            sharedManager.contactArray = contactArray;
            sharedManager.slideMenuSlected = @"contactArray";
            NSLog(@"test-1------%@",sharedManager.contactArray);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
- (IBAction)takePhotoBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){
        
        if(_selectCellIndex != 5000 && _selectCellIndex != 5001){
            sharedManager.imageString1 = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"imageString1"];
            sharedManager.imageString2 = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"imageString2"];
            sharedManager.passingString = [[contactArray objectAtIndex:_selectCellIndex] objectForKey:@"imageContent"];
          
        }
        else{
            sharedManager.imageString1 = @"";
            sharedManager.imageString2 = @"";
            sharedManager.passingString = @"";
        }
        sharedManager.passingMode = @"takePhoto";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TakePhotoViewController *myNavController = [storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
        [self presentViewController:myNavController animated:YES completion:nil];
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
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        ip = [NSIndexPath indexPathForRow:0 inSection:0];
        cell = [_popOverTableView cellForRowAtIndexPath:ip];
        if (textField == cell.popOverTittle) {
            tittleString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
        ip = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = [_popOverTableView cellForRowAtIndexPath:ip];
        if (textField == cell.popOverFirstName) {
            firstNameString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
        ip = [NSIndexPath indexPathForRow:2 inSection:0];
        cell = [_popOverTableView cellForRowAtIndexPath:ip];
        if (textField == cell.popOverDesignation) {
            designationString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
        ip = [NSIndexPath indexPathForRow:3 inSection:0];
        cell = [_popOverTableView cellForRowAtIndexPath:ip];
        if (textField == cell.popOverEmailID) {
            emailIdString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
        ip = [NSIndexPath indexPathForRow:4 inSection:0];
        cell = [_popOverTableView cellForRowAtIndexPath:ip];
        if (textField == cell.popOverPhoneNo) {
            phoneNoString  = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
    return YES;
}
-(void)fillTheTF{
    if ([sharedManager.passingMode isEqualToString: @"takePhoto"]) {
        imageString1 = sharedManager.imageString1;
        imageString2 = sharedManager.imageString2;
        imageContent = sharedManager.passingString;
        imageBase64String1 = sharedManager.imageBase64String1;
        imageBase64String2 = sharedManager.imageBase64String2;
      
    }
}
- (IBAction)moduleAccessViewBtn:(id)sender {
    if (_selectCellIndex == 5000) {
        [self updateData];
    }
    else{
        NSLog(@"test clicked");
        [moduleAccessTableView reloadData];
        moduleAccessView.hidden = NO;
    }
}
-(void)updateData{
    if([Utitlity isConnectedTointernet]){
        
        [self showProgress];
        NSString *targetUrl = [NSString stringWithFormat:@"%@GetModules",BASEURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:targetUrl]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  
              NSLog(@"%@",dataArray);
              moduleAccessArray = [dataArray mutableCopy];
              NSArray *ModuleNameArray = [dataArray valueForKey:@"ModuleName"];
              if ([ModuleNameArray containsObject:@"External Stakeholder Management"]) {
                  NSUInteger index = [ModuleNameArray indexOfObject:@"External Stakeholder Management"];
                  [moduleAccessArray removeObjectAtIndex:index];
              }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  _selectCellIndex = 5001;
                  [self hideProgress];
                  [moduleAccessTableView reloadData];
                  moduleAccessView.hidden = NO;

              });
              
          }] resume];
        
        
    }else{
        [self showMsgAlert:NOInternetMessage];
    }
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

-(void)hideProgress{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)accessDoneBtn:(id)sender {
    for (int i = 0; i<moduleAccessArray.count; i++) {
        NSMutableDictionary *mutableDict = [[moduleAccessArray objectAtIndex:i] mutableCopy];
        [mutableDict setObject:@0 forKey:@"Active"];
        [moduleAccessArray replaceObjectAtIndex:i withObject:mutableDict];
    }
    for (int j = 0 ; j < selectedIndexArray.count; j++) {
        NSMutableDictionary *mutableDict = [[moduleAccessArray objectAtIndex:[selectedIndexArray[j] intValue]] mutableCopy];
        [mutableDict setObject:@1 forKey:@"Active"];
        [moduleAccessArray replaceObjectAtIndex:[selectedIndexArray[j] intValue] withObject:mutableDict];
    }
    NSLog(@"moduleAccessArray------->%@",moduleAccessArray);
    [_popOverTableView reloadData];
    moduleAccessView.hidden = YES;

}
- (IBAction)accessCancelBtn:(id)sender {
    moduleAccessView.hidden = YES;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self updateTextLabelsWithText: newString];
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{

    moduleString = string;

}
-(CGFloat)heightForText:(NSString*)text withFont:(UIFont *)font andWidth:(CGFloat)width
{
    CGSize constrainedSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0,0,width, requiredHeight.size.height);
    }
    return requiredHeight.size.height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    [_popOverTableView beginUpdates];
    textView.frame = newFrame;
    [_popOverTableView endUpdates];

}

@end
