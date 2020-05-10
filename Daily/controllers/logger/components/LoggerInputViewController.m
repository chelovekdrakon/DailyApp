//
//  LoggerInputViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "LoggerInputViewController.h"

@interface LoggerInputViewController ()
@property (nonatomic, copy) CompletionHandler completionHandler;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *modalView;
@end

@implementation LoggerInputViewController

- (instancetype)initWithCompletionHandler:(CompletionHandler)completionHandler {
    self = [super init];
    if (self) {
        _completionHandler = [completionHandler copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor blackColor];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    ]];
    
    [self drawModal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.modalView.layer.cornerRadius = 20.0f;
}

- (void)drawModal {
    // Container init
    UIView *modalView = [[UIView alloc] init];
    modalView.backgroundColor = [UIColor whiteColor];
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    modalView.layoutMargins = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
    [self.containerView addSubview:modalView];
    self.modalView = modalView;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.modalView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
        [self.modalView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        
        [self.modalView.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor],
        [self.modalView.heightAnchor constraintEqualToAnchor:self.containerView.heightAnchor multiplier:1],
    ]];
    
    
    // Title init
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"Log your Recent Activity";
    [titleLabel sizeToFit];
    
    [self.modalView addSubview:titleLabel];
    
    UIView *titleLabelDividerView = [[UIView alloc] init];
    titleLabelDividerView.backgroundColor = [UIColor darkTextColor];
    titleLabelDividerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.modalView addSubview:titleLabelDividerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.modalView.centerXAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:self.modalView.topAnchor constant:self.modalView.layoutMargins.top],
        
        [titleLabelDividerView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:self.modalView.layoutMargins.top],
        [titleLabelDividerView.widthAnchor constraintEqualToAnchor:titleLabel.widthAnchor constant:40.0f],
        [titleLabelDividerView.centerXAnchor constraintEqualToAnchor:titleLabel.centerXAnchor],
        [titleLabelDividerView.heightAnchor constraintEqualToConstant:0.5f],
    ]];
    
    
    // Date Pickers init
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    
    // From... Date picker init
    UILabel *fromDatePickerLabel = [[UILabel alloc] init];
    fromDatePickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    fromDatePickerLabel.text = @"The Time Activity was started";
    [fromDatePickerLabel sizeToFit];
    
    UIDatePicker *fromDatePicker = [[UIDatePicker alloc] init];
    [fromDatePicker setLocale:locale];
    fromDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    fromDatePicker.date = [NSDate date];
    fromDatePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.modalView addSubview:fromDatePickerLabel];
    [self.modalView addSubview:fromDatePicker];
    
    [NSLayoutConstraint activateConstraints:@[
        [fromDatePickerLabel.topAnchor constraintEqualToAnchor:titleLabelDividerView.bottomAnchor constant:20.0f],
        [fromDatePickerLabel.leadingAnchor constraintEqualToAnchor:self.modalView.leadingAnchor constant:self.modalView.layoutMargins.left],
        
        [fromDatePicker.topAnchor constraintEqualToAnchor:fromDatePickerLabel.bottomAnchor constant:10.0f],
        [fromDatePicker.centerXAnchor constraintEqualToAnchor:self.modalView.centerXAnchor],
    ]];
    
    
    // To... Date picker init
    UILabel *toDatePickerLabel = [[UILabel alloc] init];
    toDatePickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    toDatePickerLabel.text = @"The Time Activity was finished";
    [toDatePickerLabel sizeToFit];
    
    UIDatePicker *toDatePicker = [[UIDatePicker alloc] init];
    [toDatePicker setLocale:locale];
    toDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    toDatePicker.date = [NSDate date];
    toDatePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.modalView addSubview:toDatePickerLabel];
    [self.modalView addSubview:toDatePicker];
    
    [NSLayoutConstraint activateConstraints:@[
        [toDatePickerLabel.topAnchor constraintEqualToAnchor:fromDatePicker.bottomAnchor constant:20.0f],
        [toDatePickerLabel.leadingAnchor constraintEqualToAnchor:self.modalView.leadingAnchor constant:self.modalView.layoutMargins.left],
        
        [toDatePicker.topAnchor constraintEqualToAnchor:toDatePickerLabel.bottomAnchor constant:10.0f],
        [toDatePicker.centerXAnchor constraintEqualToAnchor:self.modalView.centerXAnchor],
    ]];
}

@end
