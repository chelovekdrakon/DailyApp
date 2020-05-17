//
//  NSString+TimeInterval.h
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TimeInterval)
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;
@end

NS_ASSUME_NONNULL_END
