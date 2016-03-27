//
//  AppDelegate.m
//  ButtonApp
//
//  Created by Mesfin Bekele Mekonnen on 3/26/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Button/Button.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Button configuration
    [[Button sharedButton] configureWithApplicationId:@"app-01994c4a97f0db2b" completion:NULL];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Button Appearance Proxy Styling

//- (void)applyButtonAppearance {
//    
//    BTNDropinButton *appearance = [BTNDropinButton appearance];
//    appearance.highlightedTextColor = [UIColor lightGrayColor];
//    appearance.iconSize     = 20.0;
//    appearance.borderColor  = [UIColor blueColor];
//    appearance.borderWidth  = 1.0;
//    appearance.cornerRadius = 5.0;
//    
//    appearance = [BTNDropinButton appearanceWhenContainedIn:
//                  [ViewController class], nil];
//    appearance.borderWidth = 0.0;
//}

@end
