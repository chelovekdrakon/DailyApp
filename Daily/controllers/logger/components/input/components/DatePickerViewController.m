//
//  DatePickerViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "DatePickerViewController.h"
#import "NSDate+Range.h"

@interface DatePickerViewController ()
@property (nonatomic, copy) CompletionHandler onComplete;
@property (nonatomic, copy) ChangeHandler onChange;
@end

@implementation DatePickerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date onChange:(ChangeHandler)onChange onComplete:(CompletionHandler)onComplete {
    self = [super init];
    if (self) {
        _date = date;
        _onComplete = [onComplete copy];
        _onChange = [onChange copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor lightTextColor];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.layer.cornerRadius = 20.0f;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    ]];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setLocale:[NSLocale currentLocale]];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.date = self.date;
    datePicker.minimumDate = [NSDate dayBeforeDate:self.date];
    datePicker.maximumDate = [NSDate dayAfterDate:self.date];
    
    [datePicker addTarget:self action:@selector(handleDatePickerChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:datePicker];
    self.datePicker = datePicker;
    
    [NSLayoutConstraint activateConstraints:@[
        [datePicker.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [datePicker.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
        [datePicker.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [datePicker.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
    ]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.onComplete) {
        self.onComplete(self.date);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDatePickerChange:(UIDatePicker *)picker {
    self.date = picker.date;
    
    if (self.onChange) {
        self.onChange(picker.date);
    }
}

@end
