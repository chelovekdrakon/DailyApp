//
//  NSDate+Range.m
//  Daily
//
//  Created by Фёдор Морев on 5/16/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "NSDate+Range.h"

@implementation NSDate (Range)

+ (NSDate *)dayStartOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dayStart = [calendar startOfDayForDate:date];
    
    return dayStart;
}

+ (NSDate *)dayEndOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.second = -1;
    
    NSDate *dayEnd = [calendar dateByAddingComponents:components toDate:[NSDate dayStartOfDate:date] options:kNilOptions];
    
    return dayEnd;
}

@end
