//
//  FourSqaureAPIManager.m
//  ButtonApp
//
//  Created by Mesfin Bekele Mekonnen on 3/27/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "FourSqaureAPIManager.h"
#import <AFNetworking/AFNetworking.h>

#define kFoursquareAPIClientID     @"GWKJBVWFYBJQ02T3TRBB4VBL24AIO4TCMJCGIQ5ADKVKJXGP"
#define kFoursquareAPIClientSecret @"2WMEZCDQNKNB5XAE5F4BY1VHBK1HITYRU1JEVCOAD2QRLXDJ"

@implementation FourSqaureAPIManager

+(void)findSomething:(NSString *)query atLocation:(CLLocation *)location completion:(void (^)(NSArray *))completion {
    
    NSString *baseURL = @"https://api.foursquare.com/v2/venues/search";
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20160215&ll=%f,%f&query=%@", baseURL, kFoursquareAPIClientID, kFoursquareAPIClientSecret, location.coordinate.latitude, location.coordinate.longitude, query];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
     {
         NSDictionary *response = responseObject[@"response"];
         NSArray *venues = response[@"venues"];
         
         completion(venues);
         
     } failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error.localizedDescription);
     }];

}

@end
