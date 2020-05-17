//
//  DetailsViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "ArchiveDetailsViewController.h"
#import "Activity+CoreDataClass.h"
#import "ActivityType+CoreDataClass.h"

@interface ArchiveDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) Daily *daily;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ArchiveDetailsViewController

- (instancetype)initWithDayData:(Daily *)daily {
    self = [super init];
    if (self) {
        _daily = daily;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        _dateFormatter = dateFormatter;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.tableView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
        [self.tableView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    Activity *activity = [self.daily.activities objectAtIndex:indexPath.section];
    
    cell.textLabel.text = activity.type.type;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Activity *activity = [self.daily.activities objectAtIndex:section];
    
    NSString *text = [NSString stringWithFormat:@"%@ --> %@",
                      [self.dateFormatter stringFromDate:activity.from],
                      [self.dateFormatter stringFromDate:activity.to]
                      ];
    
    return text;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.daily.activities.count;
}

@end



//UIView *containerView = [[UIView alloc] init];
//containerView.translatesAutoresizingMaskIntoConstraints = NO;
//[self.view addSubview:containerView];
//self.containerView = containerView;
//
//NSString *date = [NSString stringWithFormat:@"%@", self.dayData.date];
//
//UILabel *label = [[UILabel alloc] init];
//label.translatesAutoresizingMaskIntoConstraints = NO;
//label.text = date;
//[label sizeToFit];
//
//[self.containerView addSubview:label];
//
//[NSLayoutConstraint activateConstraints:@[
//    [self.containerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
//    [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
//    [self.containerView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
//    [self.containerView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
//
//    [label.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
//    [label.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
//]];
