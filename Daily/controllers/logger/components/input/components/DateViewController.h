//
//  DatePickerViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateViewController : UIViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithDate:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter;

@end

NS_ASSUME_NONNULL_END
