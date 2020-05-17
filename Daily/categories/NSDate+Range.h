//
//  NSDate+Range.h
//  Daily
//
//  Created by Фёдор Морев on 5/16/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Range)

+ (NSDate *)dayStartOfDate:(NSDate *)date;
+ (NSDate *)dayEndOfDate:(NSDate *)date;

+ (NSDate *)dayBeforeDate:(NSDate *)date;
+ (NSDate *)dayAfterDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
