//
//  LoggerMasterViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "LoggerMasterViewController.h"
#import "LoggerInputViewController.h"

@interface LoggerMasterViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation LoggerMasterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [logButton setTitle:@"Log Activity" forState:UIControlStateNormal];
    [logButton setTitleColor:UIColor.yellowColor forState:UIControlStateSelected];
    logButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [logButton sizeToFit];
    logButton.translatesAutoresizingMaskIntoConstraints = NO;
    logButton.backgroundColor = UIColor.blackColor;
    
    [logButton addTarget:self action:@selector(handleLogButtonPress:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:logButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        
        [logButton.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:70.0f],
        [logButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-120.0f],
        [logButton.heightAnchor constraintEqualToAnchor:logButton.widthAnchor],
    ]];
    
    logButton.layer.cornerRadius = logButton.frame.size.width / 2;
}

- (void)handleLogButtonPress:(id)sender {
    LoggerInputViewController *inputVC = [[LoggerInputViewController alloc] initWithCompletionHandler:^(NSDate * _Nonnull fromDate, NSDate * _Nonnull toDate, NSString * _Nonnull activityDescription) {
        NSLog(@"");
    }];
    inputVC.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:inputVC animated:YES completion:nil];
}

@end
