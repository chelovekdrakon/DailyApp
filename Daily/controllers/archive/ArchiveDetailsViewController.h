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

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveDetailsViewController : UIViewController

- (instancetype)initWithDayData:(Daily *)daily;

@property (nonatomic, assign) DetailsSegment segmentedControlState;

@end

NS_ASSUME_NONNULL_END
