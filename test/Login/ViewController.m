//
//  ViewController.m
//  test
//
//  Created by ceaselez on 27/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "ViewController.h"
#import "ACFloatingTextField.h"
#import "Utitlity.h"
#import "Reachability.h"
#import "WebServices.h"
#import "GlobalURL.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet ACFloatingTextField *emailTF;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *passwordTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   

}
- (IBAction)loginBtn:(id)sender {
    if([Utitlity isConnectedTointernet]){

    NSString *msg=@"";
    
    if(![self isValidEmail:_emailTF.text])
    {
        msg=[NSString stringWithFormat:@"Enter a valid mail id"];
    }
    
    if(msg.length==0)
        
    {
        if([Utitlity isConnectedTointernet]){
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:_emailTF.text forKey:@"EmailID"];
            [params setObject:_passwordTF.text forKey:@"Password"];
            
            [self showProgress];
            NSString* JsonString = [Utitlity JSONStringConv: params];
            NSLog(@"json----%@",JsonString);
            
            [[WebServices sharedInstance]apiAuthwithJSON:Login HTTPmethod:@"POST" forparameters:JsonString ContentType:APICONTENTTYPE apiKey:nil onCompletion:^(NSDictionary *json, NSURLResponse * headerResponse) {
                
                NSString *error=[json valueForKey:@"error"];
                [self hideProgress];
                
                if(error.length>0){
                    [self showMsgAlert:[json valueForKey:@"error_description"]];
                    return ;
                }else{
                    if(json.count==0){
                        [self showMsgAlert:@"Error , Try Again"];
                    }else{
                        if ([[json objectForKey:@"IsExists"] intValue]==1) {
                            NSLog(@"json-----%@",json);
                            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                            [defaults setObject:[json objectForKey:@"CountryName"] forKey:@"CountryName"];
                            [defaults setObject:[json objectForKey:@"EmailID"] forKey:@"EmailID"];
                            [defaults setObject:[json objectForKey:@"EmployeeName"] forKey:@"EmployeeName"];
                            [defaults setObject:[json objectForKey:@"EmpID"] forKey:@"EmpID"];
                            [defaults setObject:[json objectForKey:@"UserID"] forKey:@"UserID"];
                            [defaults setObject:[json objectForKey:@"CountryID"] forKey:@"CountryID"];
                            [defaults setObject:[json objectForKey:@"LocationID"] forKey:@"LocationID"];

                            SWRevealViewController *purchaseContr = (SWRevealViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                            //menu is only an example
                            purchaseContr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                            [self presentViewController:purchaseContr animated:YES completion:nil];
                            
                        }
                        
                        else{
                            [self showMsgAlert:@"Invalid Credentials"];
                            
                        }
                    }
                }
                
            }];
        }else{
            [self showMsgAlert:NOInternetMessage];
        }
        
    }
    else
    {
        [self showMsgAlert:msg];
    }
 }
    else{
        [self showMsgAlert:NOInternetMessage];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showProgress{
    [self hideProgress];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

-(void)hideProgress{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)showMsgAlert:(NSString *)msg{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                  message:msg
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)showBtn:(id)sender {
    if ([sender isSelected]) {
        [_passwordTF setSecureTextEntry:YES] ;
        [sender setSelected:NO];
    }
    else{
        [_passwordTF setSecureTextEntry:NO] ;
        [sender setSelected:YES];
    }
}

@end
