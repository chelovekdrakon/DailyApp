//
//  LoggerMasterViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// Core Date
#import "Daily+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoggerMasterViewController : UIViewController
- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer;
- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer date:(NSDate *)date;
- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer daily:(Daily *)daily;
@end

NS_ASSUME_NONNULL_END
