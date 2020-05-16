//
//  DetailsViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Daily+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveDetailsViewController : UIViewController

- (instancetype)initWithDayData:(Daily *)dayData;

@end

NS_ASSUME_NONNULL_END
