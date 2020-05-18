//
//  DetailsViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Daily+CoreDataClass.h"

typedef NS_ENUM(NSInteger, DetailsSegment) {
    DetailsSegmentActivities = 0,
    DetailsSegmentPlanned = 1,
};

typedef void(^SegmentChangeHandler)(DetailsSegment segmentState);

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveDetailsViewController : UIViewController

- (instancetype)initWithDayData:(Daily *)daily;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) DetailsSegment segmentedControlState;
@property (nonatomic, copy) SegmentChangeHandler onSegmentStateChange;

@end

NS_ASSUME_NONNULL_END
