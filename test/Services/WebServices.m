

#import "WebServices.h"
#import "GlobalURL.h"

@implementation WebServices

+(WebServices*)sharedInstance {
    static WebServices *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - AuthorizationwithJSONStringPOST
-(void)apiAuthwithJSON:(NSString *)urlPath HTTPmethod:(NSString* )methodName forparameters:(NSString *)params ContentType:(NSString*)content apiKey:(NSString *)APIKEY onCompletion:(JSONResponseBlock)completionBlock{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if ([methodName isEqualToString:@"POST"] || [methodName isEqualToString:@"PUT"]) {
        NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSString *pathString=[BASEURL stringByAppendingString:urlPath];
        NSURL * url = [NSURL URLWithString:[pathString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        [request setURL:url];
        [request setHTTPMethod:methodName];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //        [request setValue:auth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:postData];
    }
    else{
        NSString *pathString=[BASEURL stringByAppendingString:urlPath];
        NSURL * url = [NSURL URLWithString:[pathString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        [request setURL:url];
        [request setHTTPMethod:methodName];
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    }
    
    
    // adding header value
    if(APIKEY!=nil){
        [request addValue:APIKEY forHTTPHeaderField:HEADERSFIELD];
    }
//    
    //[request addValue:VALUE forHTTPHeaderField:@"Field You Want To Set"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"Response:%@ \n error:%@\n ", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding], error);
                                          if(error == nil)
                                          {
                                              if (data != nil) {
                                                  NSError *errorPaserJSON = nil;
                                                  
                                                  
                                                  
                                                  NSDictionary *jsonContents = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorPaserJSON];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      completionBlock(jsonContents , response);
                                                  });
                                              }
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"], response);
                                              });
                                          }
                                      }];
    [dataTask resume];
}


#pragma mark - URLWITHAPIKEY
-(void)apiwithAPIKey:(NSString *)urlPath HTTPmethod:(NSString* )methodName forparameters:(NSString *)params apiKey:(NSString *)APIKEY ContentType:(NSString*)content onCompletion:(JSONResponseBlock)completionBlock{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if ([methodName isEqualToString:@"POST"] || [methodName isEqualToString:@"PUT"]) {
        NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSString *pathString=[BASEURL stringByAppendingString:urlPath];
        NSURL * url = [NSURL URLWithString:[pathString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        [request setURL:url];
        [request setHTTPMethod:methodName];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        [request setValue:APIKEY forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:postData];
    }
    else{
        NSString *pathString=[BASEURL stringByAppendingString:urlPath];
        NSURL * url = [NSURL URLWithString:[pathString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        [request setURL:url];
        [request setHTTPMethod:methodName];
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        [request setValue:APIKEY forHTTPHeaderField:@"Authorization"];
    }
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"Response:%@ \n error:%@\n ", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding], error);
                                          if(error == nil)
                                          {
                                              if (data != nil) {
                                                  NSError *errorPaserJSON = nil;
                                                  
                                                  
                                                  
                                                  NSDictionary *jsonContents = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorPaserJSON];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      completionBlock(jsonContents , response);
                                                  });
                                              }
                                          }
                                          else{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"], response);
                                              });
                                          }
                                      }];
    [dataTask resume];
}


@end
