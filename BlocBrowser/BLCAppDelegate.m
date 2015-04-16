//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by Srikanth Narayanamohan on 02/04/2015.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCAppDelegate.h"
#import "BLCWebBrowserViewController.h"

@interface BLCAppDelegate ()

@end

@implementation BLCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLCWebBrowserViewController alloc]init]];
    
    [self.window makeKeyAndVisible];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Welcome!", @"Welcome title")
                                                    message:NSLocalizedString(@"Get excited to use the best web browser ever!", @"Welcome comment")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK, I'm excited!", @"Welcome button title") otherButtonTitles:nil];
    [alert show];
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
  
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    BLCWebBrowserViewController *browserVC = [[navigationVC viewControllers] firstObject];
    
    [browserVC resetWebView];
   
    
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

@end
