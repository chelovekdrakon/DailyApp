//
//  LoggerMasterViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "LoggerMasterViewController.h"

// Controllers
#import "LoggerInputViewController.h"
#import "ArchiveDetailsViewController.h"

// Core Date
#import "Daily+CoreDataClass.h"
#import "Activity+CoreDataClass.h"
#import "PlannedActivity+CoreDataClass.h"
#import "ActivityType+CoreDataClass.h"

#import "NSDate+Range.h"
#import "Constants.h"

@interface LoggerMasterViewController ()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Daily *daily;
@property (nonatomic, strong) Daily *nextDaily;
@property (nonatomic, strong) Daily *previousDaily;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *logButton;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) ArchiveDetailsViewController *detailsTableViewController;
@end

@implementation LoggerMasterViewController

#pragma mark - Initialization

- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer {
    self = [super init];
    if (self) {
        _date = [NSDate date];
        _persistentContainer = persistentContainer;
        _daily = [self getDailyForDate:_date];
    }
    return self;
}

- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer date:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        _persistentContainer = persistentContainer;
        _daily = [self getDailyForDate:_date];
    }
    return self;
}

- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer daily:(Daily *)daily {
    self = [super init];
    if (self) {
        _date = daily.date;
        _persistentContainer = persistentContainer;
        _daily = daily;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = @"EEEE, d MMMM";
    
    self.navigationItem.title = [dateFormatter stringFromDate:self.daily.date];
    
    // Right Bar
    self.nextDaily = [self fetchNextDailyFromDaily:self.daily];
    if (self.nextDaily) {
        UIImage *rightButtonImage;
        if (@available(iOS 13.0, *)) {
            rightButtonImage = [UIImage systemImageNamed:@"chevron.right"];
        } else {
            rightButtonImage = [UIImage imageNamed:@"chevronRight"];
        }
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(handleNextPress:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    // Left Bar
    self.previousDaily = [self fetchPreviousDailyFromDaily:self.daily];
        if (self.previousDaily) {
        UIImage *leftButtonImage;
        if (@available(iOS 13.0, *)) {
            leftButtonImage = [UIImage systemImageNamed:@"chevron.left"];
        } else {
            leftButtonImage = [UIImage imageNamed:@"chevronLeft"];
        }
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(handleBackPress:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
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
    logButton.translatesAutoresizingMaskIntoConstraints = NO;
    logButton.backgroundColor = UIColor.blackColor;
    
    [logButton addTarget:self action:@selector(handleLogButtonPress:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:logButton];
    self.logButton = logButton;
    
    CGSize buttonSize = CGSizeMake(115, 115);
    logButton.layer.cornerRadius = buttonSize.width / 2;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        
        [logButton.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:70.0f],
        [logButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-120.0f],
        [logButton.heightAnchor constraintEqualToConstant:buttonSize.height],
        [logButton.widthAnchor constraintEqualToConstant:buttonSize.width],
    ]];
    
    ArchiveDetailsViewController *detailsTableViewController = [[ArchiveDetailsViewController alloc] initWithDayData:self.daily];
    detailsTableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    detailsTableViewController.onSegmentStateChange = ^(DetailsSegment segmentState) {
        if (segmentState == DetailsSegmentActivities) {
            [self.logButton setTitle:@"Log Activity" forState:UIControlStateNormal];
        } else {
            [self.logButton setTitle:@"Plan Activity" forState:UIControlStateNormal];
        }
    };
    
    [self addChildViewController:detailsTableViewController];
    [self.containerView addSubview:detailsTableViewController.view];
    [detailsTableViewController didMoveToParentViewController:self];
    self.detailsTableViewController = detailsTableViewController;
    
    [NSLayoutConstraint activateConstraints:@[
        [detailsTableViewController.view.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [detailsTableViewController.view.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [detailsTableViewController.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [detailsTableViewController.view.bottomAnchor constraintEqualToAnchor:logButton.topAnchor constant:-20.0f],

    ]];
}

#pragma mark - Buttons

- (void)handleLogButtonPress:(id)sender {
    LoggingPurpose loggingPurpose = (self.detailsTableViewController.segmentedControlState == DetailsSegmentPlanned)
        ? LoggingPurposePlan
        : LoggingPurposeLog;
    
    LoggerInputViewController *inputVC = [[LoggerInputViewController alloc] initForDaily:self.daily
                                                                                 purpose:loggingPurpose
                                                                       completionHandler:^(NSDate * _Nonnull fromDate, NSDate * _Nonnull toDate, NSString * _Nonnull activityDescription) {
        NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
        // Activity Type
        ActivityType *activityType = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_ACITIVTY_TYPE inManagedObjectContext:context];
        activityType.type = activityDescription;
        activityType.clarification = activityDescription;
        
        // Activity
        
        // Add Activity
        if (loggingPurpose == LoggingPurposeLog) {
            Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_ACITIVTY inManagedObjectContext:context];
            activity.type = activityType;
            activity.from = fromDate;
            activity.to = toDate;
            activity.spentTime = [toDate timeIntervalSinceDate:fromDate];
            
            [self.daily addActivitiesObject:activity];
        } else {
            PlannedActivity *plannedActivity = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_ACITIVTY_PLANNED inManagedObjectContext:context];
            plannedActivity.type = activityType;
            plannedActivity.from = fromDate;
            plannedActivity.to = toDate;
            plannedActivity.spentTime = [toDate timeIntervalSinceDate:fromDate];
            plannedActivity.isDone = NO;
            
            [self.daily addPlannedActivitiesObject:plannedActivity];
        }
        
        // Save Core Data Update
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        
        if (loggingPurpose == LoggingPurposeLog) {
            for(Activity *activity in self.daily.activities) {
                NSLog(@"Activity: %@", activity.type.clarification);
            }
        } else {
            for(PlannedActivity *activity in self.daily.plannedActivities) {
                NSLog(@"Activity: %@", activity.type.clarification);
            }
        }
    }];
    
    inputVC.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:inputVC animated:YES completion:nil];
}

- (void)handleBackPress:(id)sender {
    LoggerMasterViewController *nextVC = [[LoggerMasterViewController alloc] initWithPersistentContainer:self.persistentContainer daily:self.previousDaily];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs insertObject:nextVC atIndex:[vcs count]-1];
    [self.navigationController setViewControllers:vcs animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleNextPress:(id)sender {
    LoggerMasterViewController *nextVC = [[LoggerMasterViewController alloc] initWithPersistentContainer:self.persistentContainer daily:self.nextDaily];
    [self.navigationController pushViewController:nextVC animated:YES];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs removeObjectAtIndex:0];
    [self.navigationController setViewControllers:vcs animated:NO];
}

#pragma mark - Helpers

- (Daily *)getDailyForDate:(NSDate *)date {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
    // Today's Daily request (if exists already)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
    [request setEntity:entity];


    NSDate *startDate = [NSDate dayStartOfDate:date];
    NSDate *endDate = [NSDate dayEndOfDate:date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    [request setPredicate:predicate];
    
    NSError *errorFetch = nil;
    NSArray *arrayOfTodayDailies = [context executeFetchRequest:request error:&errorFetch];
    if (errorFetch) {
        NSLog(@"Failed to fetch daily! %@", [errorFetch localizedDescription]);
    }
    
    // Daily
    if (arrayOfTodayDailies.count > 0) {
        Daily *daily = arrayOfTodayDailies[0];
        return daily;
    } else {
        Daily *daily = [NSEntityDescription insertNewObjectForEntityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
        daily.date = date;
        return daily;
    }
}

- (Daily *)fetchPreviousDailyFromDaily:(Daily *)daily {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
    // Today's Daily request (if exists already)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
    [request setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@", daily.date];
    [request setPredicate:predicate];
    
    NSError *errorFetch = nil;
    NSArray *arrayOfDailies = [context executeFetchRequest:request error:&errorFetch];
    if (errorFetch) {
        NSLog(@"Failed to fetch daily! %@", [errorFetch localizedDescription]);
    }
    
    return arrayOfDailies.lastObject;
}

- (Daily *)fetchNextDailyFromDaily:(Daily *)daily {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
    // Today's Daily request (if exists already)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
    [request setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date > %@", daily.date];
    [request setPredicate:predicate];
    
    NSError *errorFetch = nil;
    NSArray *arrayOfDailies = [context executeFetchRequest:request error:&errorFetch];
    if (errorFetch) {
        NSLog(@"Failed to fetch daily! %@", [errorFetch localizedDescription]);
    }
    
    return arrayOfDailies.firstObject;
}

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
