//
//  DatePickerViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "DatePickerViewController.h"
#import "UILabelPaddings.h"

@interface DatePickerViewController ()
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation DatePickerViewController

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

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabelPaddings *timeLabel = [[UILabelPaddings alloc] initWithPaddings:UIEdgeInsetsMake(20.0f, 0, 20.0f, 0)];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = [self getTextFromDate:self.date];
    timeLabel.font = [UIFont boldSystemFontOfSize:16.0f];
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
    UIDatePicker *fromDatePicker = [[UIDatePicker alloc] init];
    [fromDatePicker setLocale:[NSLocale currentLocale]];
    fromDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    fromDatePicker.backgroundColor = [UIColor lightTextColor];
    fromDatePicker.date = self.date;

    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor lightTextColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [vc.view addSubview:fromDatePicker];
    
    [NSLayoutConstraint activateConstraints:@[
        [fromDatePicker.centerXAnchor constraintEqualToAnchor:vc.view.centerXAnchor],
        [fromDatePicker.centerYAnchor constraintEqualToAnchor:vc.view.centerYAnchor],
    ]];
    
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"");
    }];
}

#pragma mark - Helpers

- (NSString *)getTextFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (NSDateFormatter *)defaultDateFormatter {
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = @"HH:mm";
    
    return dateFormatter;
}

#pragma mark - KVC

- (void)setDate:(NSDate *)nextDate {
    _date = nextDate;
    
    self.timeLabel.text = [self getTextFromDate:nextDate];
}

@end
