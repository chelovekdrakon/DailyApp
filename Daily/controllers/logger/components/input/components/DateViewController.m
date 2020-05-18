//
//  DatePickerViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "DateViewController.h"
#import "UILabelPaddings.h"
#import "DatePickerViewController.h"

@interface DateViewController ()
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation DateViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _date = [NSDate date];
        _dateFormatter = [self defaultDateFormatter];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        _dateFormatter = [self defaultDateFormatter];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        _date = date;
        _dateFormatter = dateFormatter;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter onDateChange:(DateChangeHandler)onDateChange {
    self = [super init];
    if (self) {
        _date = date;
        _onDateChange = onDateChange;
        _dateFormatter = dateFormatter;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabelPaddings *timeLabel = [[UILabelPaddings alloc] initWithPaddings:UIEdgeInsetsMake(20.0f, 0, 20.0f, 0)];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = [self getTextFromDate:self.date];
    timeLabel.font = [UIFont boldSystemFontOfSize:26.0f];
    timeLabel.textColor = [UIColor blackColor];
    
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    [NSLayoutConstraint activateConstraints:@[
        [timeLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [timeLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
        [timeLabel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [timeLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.timeLabel.layer.cornerRadius = self.timeLabel.frame.size.height;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    __weak DateViewController *weakSelf = self;
    
    DatePickerViewController *datePickerModal = [[DatePickerViewController alloc] initWithDate:self.date onChange:^(NSDate * _Nonnull newDate) {
        weakSelf.date = newDate;
    } onComplete:^(NSDate * _Nonnull newDate) {
        weakSelf.date = newDate;
        if (weakSelf.onDateChange) {
            weakSelf.onDateChange(newDate);
        }
    }];
    
    datePickerModal.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:datePickerModal animated:YES completion:nil];
}

#pragma mark - Helpers

- (NSString *)getTextFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (NSDateFormatter *)defaultDateFormatter {
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return dateFormatter;
}

#pragma mark - KVC

- (void)setDate:(NSDate *)nextDate {
    _date = nextDate;
    
    self.timeLabel.text = [self getTextFromDate:nextDate];
}

@end
