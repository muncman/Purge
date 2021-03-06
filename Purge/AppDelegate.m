//
//  AppDelegate.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        
    [TestFlight takeOff:@"3ab675c1d538a8a4e6243e86aee4e7da_NjM3OTcyMDEyLTAyLTE4IDIxOjM5OjMyLjA0MjQzMg"];
    
//    Splash *splash = [[Splash alloc] init];
    Login *login = [[Login alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [login release];
    [[nav navigationBar] setTintColor:[UIColor colorWithRed:0.368f green:0.552f blue:0.647f alpha:1]];

    if ([PFUser currentUser]) {
        MainTabView *appView = [[MainTabView alloc] init];
        [nav pushViewController:appView animated:NO];
        [appView release];
    }
    [[self window] setRootViewController:nav];
    [nav release], nav = nil;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
