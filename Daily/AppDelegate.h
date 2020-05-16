//
//  AppDelegate.h
//  Daily
//
//  Created by Фёдор Морев on 5/9/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) UIWindow * window;

- (void)saveContext;
- (UIViewController *)rootViewController;

@end

