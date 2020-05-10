//
//  NavigationDailyViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/9/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "NavigationDailyViewController.h"

@interface NavigationDailyViewController ()

@end

@implementation NavigationDailyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationItems];
    
}

#pragma mark - Setup

- (void)setupNavigationItems {
    self.navigationItem.title = [NSString stringWithFormat:@"%lu", self.navigationController.viewControllers.count];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrowtriangle.right.circle"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(handleBarButtonItemPress:)];
    
    self.navigationItem.rightBarButtonItem = next;
}

#pragma mark - Handlers

- (void)handleBarButtonItemPress:(id)sender {
    NavigationDailyViewController *nextVC = [NavigationDailyViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
