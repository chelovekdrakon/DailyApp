//
//  DetailsViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "ArchiveDetailsViewController.h"

@interface ArchiveDetailsViewController ()
@property (nonatomic, copy) NSDictionary *dayData;

@property (nonatomic, strong) UIView *containerView;
@end

@implementation ArchiveDetailsViewController

- (instancetype)initWithDayData:(NSDictionary *)dayData {
    self = [super init];
    if (self) {
        _dayData = dayData;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    NSString *date = [NSString stringWithFormat:@"%@", self.dayData[@"date"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = date;
    [label sizeToFit];
    
    [self.containerView addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.containerView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
        [self.containerView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
        
        [label.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
