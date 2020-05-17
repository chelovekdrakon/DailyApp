//
//  SceneDelegate.m
//  Daily
//
//  Created by Фёдор Морев on 5/9/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "LoggerMasterViewController.h"
#import "ArchiveMasterTableViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = [(AppDelegate *)UIApplication.sharedApplication.delegate rootViewController];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    if (@available(iOS 13, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    [UIView appearance].tintColor = UIColor.systemPinkColor;
}

- (void)sceneDidDisconnect:(UIScene * API_AVAILABLE(ios(13.0)))scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene * API_AVAILABLE(ios(13.0)))scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene * API_AVAILABLE(ios(13.0)))scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene * API_AVAILABLE(ios(13.0)))scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene * API_AVAILABLE(ios(13.0)))scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
