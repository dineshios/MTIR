
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol alertViewBtnHandle <NSObject>
@required
-(void)alertbtn: (NSString*)btnHeading;
@end

@interface Utitlity : NSObject
+ (BOOL)isConnectedTointernet;

- (UIAlertController*)dynamicAlert:(NSString*)title :(NSString*) message :(NSArray*)dynamicBtn;
@property (nonatomic, weak)id<alertViewBtnHandle> delegate;
+ (NSString *)JSONStringConv:(NSDictionary *)dict;
+ (NSString *)timeandDateConv_timeZone:(NSString *)givenFormat input:(NSString *)inputValue reqFormat:(NSString *)reqFormat;
+ (NSString *)deviceIPAddress;
//+ (BOOL)isValidEmail:(NSString*)checkString;
+ (NSString *)nullstring:(NSString *)nullstring;
+ (BOOL)isStringNumeric:(NSString *)text;
+ (BOOL) validatePanCardNumber: (NSString *) cardNumber;
@end
