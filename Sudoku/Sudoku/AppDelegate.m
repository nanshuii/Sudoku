//
//  AppDelegate.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "AppDelegate.h"
#import "LENMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setRootViewController];
    return YES;
}

- (void)setRootViewController{
    LENMainViewController *vc = [LENMainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, kFullScreenHeight)];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:LENNotificationNameDidBecomeActive object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:LENNotificationNameWillResignActive object:nil];
}


@end
