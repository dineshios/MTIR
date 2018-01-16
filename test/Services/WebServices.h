//
//  WebServices.h
//  Wimizi
//
//  Created by TechnoTackle on 31/10/16.
//  Copyright © 2016 TechnoTackle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject
+(WebServices*)sharedInstance;
typedef void (^JSONResponseBlock)(NSDictionary* json, NSURLResponse *headerResponse);
-(void)apiAuthwithJSON:(NSString *)urlPath HTTPmethod:(NSString* )methodName forparameters:(NSString *)params ContentType:(NSString*)content apiKey:(NSString *)APIKEY onCompletion:(JSONResponseBlock)completionBlock;

-(void)apiwithAPIKey:(NSString *)urlPath HTTPmethod:(NSString* )methodName forparameters:(NSString *)params apiKey:(NSString *)APIKEY ContentType:(NSString*)content onCompletion:(JSONResponseBlock)completionBlock;

@end
