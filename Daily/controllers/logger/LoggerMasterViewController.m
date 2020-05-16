//
//  LoggerMasterViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "LoggerMasterViewController.h"
#import "LoggerInputViewController.h"

#import "Daily+CoreDataClass.h"
#import "Activity+CoreDataClass.h"
#import "ActivityType+CoreDataClass.h"

#import "NSDate+Range.h"
#import "Constants.h"

@interface LoggerMasterViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@end

@implementation LoggerMasterViewController

- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer {
    self = [super init];
    if (self) {
        _persistentContainer = persistentContainer;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.persistentContainer == nil) {
        NSException *exception = [[NSException alloc] initWithName:@"wrong-init"
                                                            reason:@"LoggerMasterViewController should be initialized with initWithPersistentContainer method"
                                                          userInfo:nil];
        @throw exception;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [logButton setTitle:@"Log Activity" forState:UIControlStateNormal];
    [logButton setTitleColor:UIColor.yellowColor forState:UIControlStateSelected];
    logButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [logButton sizeToFit];
    logButton.translatesAutoresizingMaskIntoConstraints = NO;
    logButton.backgroundColor = UIColor.blackColor;
    
    [logButton addTarget:self action:@selector(handleLogButtonPress:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:logButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        
        [logButton.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:70.0f],
        [logButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-120.0f],
        [logButton.heightAnchor constraintEqualToAnchor:logButton.widthAnchor],
    ]];
    
    logButton.layer.cornerRadius = logButton.frame.size.width / 2;
}

#pragma mark - Button

- (void)handleLogButtonPress:(id)sender {
    LoggerInputViewController *inputVC = [[LoggerInputViewController alloc] initWithCompletionHandler:^(NSDate * _Nonnull fromDate, NSDate * _Nonnull toDate, NSString * _Nonnull activityDescription) {
        
        NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
        // Today's Daily request (if exists already)
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSDate *now = [NSDate date];
    
        NSDate *startDate = [NSDate dayStartOfDate:now];
        NSDate *endDate = [NSDate dayEndOfDate:now];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
        [request setPredicate:predicate];
        
        NSError *errorFetch = nil;
        NSArray *arrayOfTodayDailies = [context executeFetchRequest:request error:&errorFetch];
        if (errorFetch) {
            NSLog(@"Failed to fetch daily!");
        }
        
        // Daily
        Daily *daily = arrayOfTodayDailies.count > 0
            ? arrayOfTodayDailies[0]
            : [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
        
        if (arrayOfTodayDailies.count == 0) {
            daily.date = now;
        }
        
        // Activity Type
        ActivityType *activityType = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_ACITIVTY_TYPE inManagedObjectContext:context];
        activityType.type = activityDescription;
        activityType.clarification = activityDescription;
        
        // Activity
        Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_ACITIVTY inManagedObjectContext:context];
        activity.type = activityType;
        activity.from = fromDate;
        activity.to = toDate;
        activity.spentTime = [toDate timeIntervalSinceDate:fromDate];
        
        // Activities
        NSMutableOrderedSet *activities = [daily.activities mutableCopy];
        [activities addObject:activity];

        // Update Daily
        daily.activities = activities;
        
        
        // Save Core Data Update
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        
        for(Activity *activity in daily.activities) {
            NSLog(@"Activity: %@", activity.type.clarification);
        }
        

    }];
    inputVC.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:inputVC animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)cleanUpCoreData {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSError *error;
    
    if (true) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
        [request setEntity:entity];

        NSError *errorFetch = nil;
        NSArray *array = [context executeFetchRequest:request error:&errorFetch];

        for (Daily *daily in array) {
            [context deleteObject:daily];
        }
    }

    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }

    if (true) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_ACITIVTY_TYPE inManagedObjectContext:context];
        [request setEntity:entity];

        NSError *errorFetch = nil;
        NSArray *array = [context executeFetchRequest:request error:&errorFetch];

        for(ActivityType *activityType in array) {
            [context deleteObject:activityType];
        }
    }

    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }

    if (true) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_ACITIVTY inManagedObjectContext:context];
        [request setEntity:entity];

        NSError *errorFetch = nil;
        NSArray *array = [context executeFetchRequest:request error:&errorFetch];

        for(Activity *activity in array) {
            [context deleteObject:activity];
        }
    }

    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

@end
