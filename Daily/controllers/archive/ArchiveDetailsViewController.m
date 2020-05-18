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
#import "NSString+TimeInterval.h"

@interface ArchiveDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) Daily *daily;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) NSArray<Activity *> *dataSource;

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation ArchiveDetailsViewController

- (instancetype)initWithDayData:(Daily *)daily {
    self = [super init];
    if (self) {
        _daily = daily;
        _segmentedControlState = DetailsSegmentActivities;
        
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Activities", @"Planned"]];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [segmentedControl setSelectedSegmentIndex:(NSInteger)self.segmentedControlState];
    
    [segmentedControl addTarget:self action:@selector(handleSegmentSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    [NSLayoutConstraint activateConstraints:@[
        [segmentedControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [segmentedControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [segmentedControl.heightAnchor constraintEqualToConstant:40.0f]
    ]];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:segmentedControl.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

#pragma mark - UITableViewDataSource

// Section

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.segmentedControlState == DetailsSegmentActivities)
        ? self.daily.activities.count
        : self.daily.plannedActivities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Activity *activity = (self.segmentedControlState == DetailsSegmentActivities)
        ? [self.daily.activities objectAtIndex:section]
        : [self.daily.plannedActivities objectAtIndex:section];
    
    NSString *text = [NSString stringWithFormat:@"%@ --> %@ | %@",
                      [self.dateFormatter stringFromDate:activity.from],
                      [self.dateFormatter stringFromDate:activity.to],
                      [NSString stringFromTimeInterval:activity.spentTime]
                      ];
    
    return text;
}

// Row

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    Activity *activity = (self.segmentedControlState == DetailsSegmentActivities)
        ? [self.daily.activities objectAtIndex:indexPath.section]
        : [self.daily.plannedActivities objectAtIndex:indexPath.section];
    
    cell.textLabel.text = activity.type.type;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Controls

- (void)handleSegmentSwitch:(UISegmentedControl *)control {
    self.segmentedControlState = (DetailsSegment)control.selectedSegmentIndex;
}

#pragma mark - KVC

- (void)setSegmentedControlState:(DetailsSegment)state {    
    _segmentedControlState = state;
    
    if (self.onSegmentStateChange) {
        self.onSegmentStateChange(state);
    }
    
    [self.tableView reloadData];
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
