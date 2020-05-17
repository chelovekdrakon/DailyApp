//
//  NSString+TimeInterval.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "NSString+TimeInterval.h"

@implementation NSString (TimeInterval)

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger interval = timeInterval;
//    NSInteger ms = (fmod(timeInterval, 1) * 1000);
//    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);

    return [NSString stringWithFormat:@"%0.2ld:%0.2ld", hours, minutes];
}

@end
