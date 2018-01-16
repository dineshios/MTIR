//
//  MySharedManager.m
//  test
//
//  Created by ceaselez on 29/11/17.
//  Copyright © 2017 ceaselez. All rights reserved.
//

#import "MySharedManager.h"

@implementation MySharedManager

@synthesize passingMode;
@synthesize passingString;
@synthesize passingId;
@synthesize slideMenuSlected;
@synthesize imageString1;
@synthesize imageString2;
@synthesize imageBase64String1;
@synthesize imageBase64String2;
@synthesize contactArray;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MySharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
