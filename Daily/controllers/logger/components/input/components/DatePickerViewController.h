//
//  DatePickerViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(NSDate * _Nonnull newDate);
typedef void(^ChangeHandler)(NSDate * _Nonnull newDate);

NS_ASSUME_NONNULL_BEGIN

@interface DatePickerViewController : UIViewController

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

- (instancetype)initWithDate:(NSDate *)date onChange:(ChangeHandler)onChange onComplete:(CompletionHandler)onComplete;

@end

NS_ASSUME_NONNULL_END
