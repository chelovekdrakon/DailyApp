//
//  SceneDelegate.m
//  Daily
//
//  Created by Фёдор Морев on 5/9/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "NavigationDailyViewController.h"
#import "MasterTableViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = [self rootViewController];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    [UIView appearance].tintColor = UIColor.systemPinkColor;
}

- (UIViewController *)rootViewController {
    UISplitViewController *splitVC = [UISplitViewController new];
    splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    UITabBarController *tabBarVC = [UITabBarController new];
    
    UINavigationController *firstVC = [[UINavigationController alloc] initWithRootViewController:[NavigationDailyViewController new]];
    firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Logger"
                                                       image:[UIImage systemImageNamed:@"flame"]
                                                         tag:0];
    
    
    UINavigationController *secondVC = [[UINavigationController alloc] initWithRootViewController:[MasterTableViewController new]];
    secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Archive"
                                                       image:[UIImage systemImageNamed:@"tray.full"]
                                                         tag:0];
    
    tabBarVC.viewControllers = @[firstVC, secondVC];
    
    splitVC.viewControllers = @[tabBarVC];
    
    return splitVC;
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
