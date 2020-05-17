//
//  LoggerInputViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Daily+CoreDataClass.h"

typedef void(^CompletionHandler)(
                                 NSDate * _Nonnull fromDate,
                                 NSDate * _Nonnull toDate,
                                 NSString * _Nonnull activityDescription
                                 );

NS_ASSUME_NONNULL_BEGIN

@interface LoggerInputViewController : UIViewController
- (instancetype)initForDaily:(Daily *)daily completionHandler:(CompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
