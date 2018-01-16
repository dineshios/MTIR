

#import "Utitlity.h"
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@implementation Utitlity

+ (BOOL)isConnectedTointernet{
    BOOL status = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    int networkStatus = reachability.currentReachabilityStatus;
    status = (networkStatus != NotReachable)? YES:NO;
    return status;
}


- (UIAlertController*)dynamicAlert:(NSString*)title :(NSString*) message :(NSArray*)dynamicBtn
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString * btnTitle in dynamicBtn) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           //you can check here on what button is pressed using title
                                                           if ([self.delegate respondsToSelector:@selector(alertbtn:)])
                                                           {
                                                               [self.delegate alertbtn:btnTitle];
                                                           }
                                                       }];
        [alert addAction:action];
    }
    
    
    return alert;
}

+ (NSString *)JSONStringConv:(NSDictionary *)dict{
    NSError * errortest;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&errortest];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}
+ (NSString *)nullstring:(NSString *)nullstring{
    if ([nullstring isEqualToString:@"<null>"]) {
        NSString* str = @"NA";
        return str;
    }
    else
    {
        return nullstring;
    }
}


+ (NSString *)timeandDateConv_timeZone:(NSString *)givenFormat input:(NSString *)inputValue reqFormat:(NSString *)reqFormat
{
    NSString *myDateString = inputValue;
    
    NSDateFormatter *DateFormatter= [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:givenFormat];
    
    NSDate *date = [DateFormatter dateFromString:myDateString];
    [DateFormatter setDateFormat:reqFormat];
    NSString *dateString2 = [DateFormatter stringFromDate:date];
    return dateString2;
}

+ (NSString *)deviceIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
#if TARGET_IPHONE_SIMULATOR
//#error Specify network interface for computer(iPhone simulator) below and then remove this line
    NSString *networkInterface = @"en1";
#else
    NSString *networkInterface = @"en0";
#endif
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:networkInterface]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
+ (BOOL)isStringNumeric:(NSString *)text
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphaNums isSupersetOfSet:inStringSet];
}
+ (BOOL) validatePanCardNumber: (NSString *) cardNumber {
    NSString *emailRegex = @"^[A-Z]{5}[0-9]{4}[A-Z]$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [cardTest evaluateWithObject:cardNumber];
}


@end
