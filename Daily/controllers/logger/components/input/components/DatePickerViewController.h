//
//  DatePickerViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatePickerViewController : UIViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (instancetype)initWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
