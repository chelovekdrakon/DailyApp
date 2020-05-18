//
//  LoggerInputViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "LoggerInputViewController.h"
#import "DateViewController.h"

// Core Date
#import "Activity+CoreDataClass.h"
#import "ActivityType+CoreDataClass.h"

@interface LoggerInputViewController() <UITextViewDelegate>
@property (nonatomic, strong) Daily *daily;
@property (nonatomic, copy) CompletionHandler completionHandler;
@property (nonatomic, assign) LoggingPurpose logginPurpose;

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) DateViewController *fromDatePicker;
@property (nonatomic, strong) DateViewController *toDatePicker;
@property (nonatomic, strong) UITextView *descriptionTextView;
@end

@implementation LoggerInputViewController

- (instancetype)initForDaily:(Daily *)daily purpose:(LoggingPurpose)logginPurpose completionHandler:(CompletionHandler)completionHandler {
    self = [super init];
    if (self) {
        _completionHandler = [completionHandler copy];
        _daily = daily;
        _logginPurpose = logginPurpose;
    }
    return self;
}


#pragma mark - Lifecycle

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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.modalView.layer.cornerRadius = 20.0f;
}


#pragma mark - Keyboard | off for now

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

        CGRect newFrame = self.containerView.frame;
        newFrame.origin.y -= (keyboardRect.size.height / 2);

        [self.containerView setFrame:newFrame];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

        CGRect newFrame = self.containerView.frame;
        newFrame.origin.y += (keyboardRect.size.height / 2);

        [self.containerView setFrame:newFrame];
    } completion:nil];
}

#pragma mark - Button

- (void)handleLogPress:(id)sender {
    __weak LoggerInputViewController *weakSelf = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL isFromBeforeTo = [calendar compareDate:self.fromDatePicker.date toDate:self.toDatePicker.date toUnitGranularity:NSCalendarUnitSecond] == NSOrderedAscending;
    
    if (!isFromBeforeTo) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Based on provided info, your activity was finished before even started :) \nCheck dates!"
                                       message:nil
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
         
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (self.descriptionTextView.hasText == NO) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Provide Activity Description"
                                       message:nil
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
            [weakSelf.descriptionTextView becomeFirstResponder];
        }];
         
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.completionHandler(weakSelf.fromDatePicker.date, weakSelf.toDatePicker.date, weakSelf.descriptionTextView.text);
    }];
}


#pragma mark - UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.containerView endEditing:YES];
}


#pragma mark - Render Modal

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
    titleLabel.text = (self.logginPurpose == LoggingPurposeLog) ? @"Log your Recent Activity" : @"Plan your Next Activity";
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
    
    // From... Date picker init
    UILabel *fromDatePickerLabel = [[UILabel alloc] init];
    fromDatePickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    fromDatePickerLabel.text = @"From";
    fromDatePickerLabel.textAlignment = NSTextAlignmentCenter;
    [self.modalView addSubview:fromDatePickerLabel];
    
    NSDate *now = [NSDate date];
    NSOrderedSet *activities = (self.logginPurpose == LoggingPurposeLog) ? self.daily.activities : self.daily.plannedActivities;
    
    NSDate *initFromDatePickerDate = activities > 0
        ? self.daily.activities.lastObject.to
        : now;
    
    DateViewController *fromDatePicker = [[DateViewController alloc] initWithDate:initFromDatePickerDate];
    fromDatePicker.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:fromDatePicker];
    [self.view addSubview:fromDatePicker.view];
    [fromDatePicker didMoveToParentViewController:self];
    self.fromDatePicker = fromDatePicker;
    
    [NSLayoutConstraint activateConstraints:@[
        [fromDatePickerLabel.topAnchor constraintEqualToAnchor:titleLabelDividerView.bottomAnchor constant:20.0f],
        [fromDatePickerLabel.widthAnchor constraintEqualToAnchor:self.modalView.widthAnchor multiplier:0.5 constant:-(self.modalView.layoutMargins.left + self.modalView.layoutMargins.right)],
        [fromDatePickerLabel.leadingAnchor constraintEqualToAnchor:self.modalView.leadingAnchor constant:self.modalView.layoutMargins.left],
        
        [fromDatePicker.view.topAnchor constraintEqualToAnchor:fromDatePickerLabel.bottomAnchor],
        [fromDatePicker.view.leadingAnchor constraintEqualToAnchor:fromDatePickerLabel.leadingAnchor],
        [fromDatePicker.view.widthAnchor constraintEqualToAnchor:fromDatePickerLabel.widthAnchor],
    ]];
    
    // Divider --- From | To
    UIView *datePickersDivider = [[UIView alloc] init];
    datePickersDivider.backgroundColor = [UIColor darkTextColor];
    datePickersDivider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.modalView addSubview:datePickersDivider];
    
    [NSLayoutConstraint activateConstraints:@[
        [datePickersDivider.topAnchor constraintEqualToAnchor:fromDatePickerLabel.topAnchor],
        [datePickersDivider.leadingAnchor constraintEqualToAnchor:fromDatePickerLabel.trailingAnchor constant:5.0f],
        [datePickersDivider.bottomAnchor constraintEqualToAnchor:fromDatePicker.view.bottomAnchor],
        [datePickersDivider.widthAnchor constraintEqualToConstant:1.0f],
    ]];
    
    // To... Date picker init
    UILabel *toDatePickerLabel = [[UILabel alloc] init];
    toDatePickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    toDatePickerLabel.text = @"To";
    toDatePickerLabel.textAlignment = NSTextAlignmentCenter;
    [self.modalView addSubview:toDatePickerLabel];
    
    NSDate *initToDatePickerDate = (self.logginPurpose == LoggingPurposeLog)
        ? now
        : initFromDatePickerDate;
    
    DateViewController *toDatePicker = [[DateViewController alloc] initWithDate:initToDatePickerDate];
    toDatePicker.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:toDatePicker];
    [self.view addSubview:toDatePicker.view];
    [toDatePicker didMoveToParentViewController:self];
    self.toDatePicker = toDatePicker;
    
    [NSLayoutConstraint activateConstraints:@[
        [toDatePickerLabel.topAnchor constraintEqualToAnchor:fromDatePickerLabel.topAnchor],
        [toDatePickerLabel.leadingAnchor constraintEqualToAnchor:datePickersDivider.trailingAnchor constant:5.0f],
        [toDatePickerLabel.trailingAnchor constraintEqualToAnchor:self.modalView.trailingAnchor constant:-self.modalView.layoutMargins.right],
        
        [toDatePicker.view.topAnchor constraintEqualToAnchor:fromDatePicker.view.topAnchor],
        [toDatePicker.view.leadingAnchor constraintEqualToAnchor:toDatePickerLabel.leadingAnchor],
        [toDatePicker.view.trailingAnchor constraintEqualToAnchor:toDatePickerLabel.trailingAnchor],
        [toDatePicker.view.bottomAnchor constraintEqualToAnchor:fromDatePicker.view.bottomAnchor],
    ]];
    
    
    // Description Input
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.text = (self.logginPurpose == LoggingPurposeLog) ? @"Describe what you have been done below" : @"Describe what is your plan below";
    [descriptionLabel sizeToFit];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.modalView addSubview:descriptionLabel];
    
    UITextView *descriptionTextView = [[UITextView alloc] init];
    descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionTextView.scrollEnabled = NO;
    descriptionTextView.layer.borderWidth = 1.0f;
    descriptionTextView.layer.borderColor = [UIColor systemPinkColor].CGColor;
    descriptionTextView.layer.cornerRadius = 5.0f;
    descriptionTextView.font = [UIFont systemFontOfSize:15.0f];
    descriptionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.modalView addSubview:descriptionTextView];
    self.descriptionTextView = descriptionTextView;
    
    [NSLayoutConstraint activateConstraints:@[
        [descriptionLabel.topAnchor constraintEqualToAnchor:datePickersDivider.bottomAnchor constant:20.0f],
        [descriptionLabel.centerXAnchor constraintEqualToAnchor:self.modalView.centerXAnchor],
        
        [descriptionTextView.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:10.0f],
        [descriptionTextView.leadingAnchor constraintEqualToAnchor:self.modalView.leadingAnchor constant:self.modalView.layoutMargins.left],
        [descriptionTextView.trailingAnchor constraintEqualToAnchor:self.modalView.trailingAnchor constant:-self.modalView.layoutMargins.right],
    ]];
    
    
    // Log Button
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [logButton setTitle:@"Log Activity" forState:UIControlStateNormal];
    logButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [logButton sizeToFit];
    logButton.translatesAutoresizingMaskIntoConstraints = NO;
    logButton.backgroundColor = UIColor.blackColor;
    [logButton addTarget:self action:@selector(handleLogPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.modalView addSubview:logButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [logButton.topAnchor constraintEqualToAnchor:descriptionTextView.bottomAnchor constant:20.0f],
        [logButton.centerXAnchor constraintEqualToAnchor:self.modalView.centerXAnchor],
        [logButton.heightAnchor constraintEqualToAnchor:logButton.widthAnchor],
    ]];
    logButton.layer.cornerRadius = logButton.frame.size.width / 2;
}


@end
