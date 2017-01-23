//
//  RTAppDelegate.m
//  InteractivePush
//
//  Created by Ricky Tan on 01/19/2017.
//  Copyright (c) 2017 Ricky Tan. All rights reserved.
//

#import "RTAppDelegate.h"
#import "RTViewController.h"

@interface RTAppDelegate () <UINavigationControllerDelegate>

@end

@implementation RTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[RTViewController alloc] init]];
    nav.delegate = self;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

@end
