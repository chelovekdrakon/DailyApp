//
//  AppDelegate.m
//  Daily
//
//  Created by Фёдор Морев on 5/9/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "AppDelegate.h"
#import "LoggerMasterViewController.h"
#import "ArchiveMasterTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] init];
    window.rootViewController = [self rootViewController];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    [UIView appearance].tintColor = UIColor.systemPinkColor;
    
    return YES;
}

- (UIViewController *)rootViewController {
    // Split VC
    UISplitViewController *splitVC = [UISplitViewController new];
    splitVC.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    
    // Tab VC
    UITabBarController *tabBarVC = [UITabBarController new];
    
    // First Tab
    LoggerMasterViewController *loggerVC = [[LoggerMasterViewController alloc] initWithPersistentContainer:self.persistentContainer];
    UINavigationController *firstTabVC = [[UINavigationController alloc] initWithRootViewController:loggerVC];
    if (@available(iOS 13.0, *)) {
        firstTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Logger"
                                                           image:[UIImage systemImageNamed:@"flame"]
                                                             tag:0];
    } else {
        firstTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Logger" image:[UIImage imageNamed:@"flame"] tag:0];
    }
    [firstTabVC setNavigationBarHidden:YES];
    
    
    // Second Tab
    ArchiveMasterTableViewController *archiveVC = [[ArchiveMasterTableViewController alloc] initWithPersistentContainer:self.persistentContainer];
    UINavigationController *secondTabVC = [[UINavigationController alloc] initWithRootViewController:archiveVC];
    if (@available(iOS 13.0, *)) {
        secondTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Archive"
                                                            image:[UIImage systemImageNamed:@"tray.full"]
                                                              tag:0];
    } else {
        secondTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Archive"
                                                            image:[UIImage imageNamed:@"archive"]
                                                              tag:0];
    }
    
    tabBarVC.viewControllers = @[firstTabVC, secondTabVC];
    
    splitVC.viewControllers = @[tabBarVC];
    
    return splitVC;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Daily"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
