//
//  FourSqaureAPIManager.h
//  ButtonApp
//
//  Created by Mesfin Bekele Mekonnen on 3/27/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface FourSqaureAPIManager : NSObject

+ (void)findSomething:(NSString *)query
           atLocation:(CLLocation *)location
           completion:(void(^)(NSArray *data))completion;

@end
