//
//  UIDatePickerLimited.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "UIDatePickerLimited.h"

@interface UIDatePickerLimited() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *availableDates;
@end

@implementation UIDatePickerLimited

- (instancetype)initWithMinimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.availableDates = @[
            @[
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
            ],
            @[
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
            ],
            @[
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
                [NSDate date],
            ],
        ];
    }
    
    return self;
}

#pragma mark - UIPickerView Data Source and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.availableDates.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.availableDates[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 28;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE, MMMM d";

    label.text = [dateFormatter stringFromDate:self.availableDates[component][row]];

    [label sizeToFit];

    return label;
}

@end
