//
//  MySharedManager.h
//  test
//
//  Created by ceaselez on 29/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySharedManager : NSObject{
    NSString *passingString;
    NSString *passingMode;
    NSString *passingId;
    NSString *slideMenuSlected;
    NSString *imageString1;
    NSString *imageString2;
    NSString *imageBase64String1;
    NSString *imageBase64String2;
    NSMutableArray *contactArray;
}

@property (nonatomic, retain) NSString *passingString;
@property (nonatomic, retain) NSString *passingMode;
@property (nonatomic, retain) NSString *passingId;
@property (nonatomic, retain) NSString *slideMenuSlected;
@property (nonatomic, retain) NSString *imageString1;
@property (nonatomic, retain) NSString *imageString2;
@property (nonatomic, retain) NSString *imageBase64String1;
@property (nonatomic, retain) NSString *imageBase64String2;
@property (nonatomic, retain) NSMutableArray *contactArray;



+ (id)sharedManager;

@end
