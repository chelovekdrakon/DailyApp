//
//  UILabelPaddings.h
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabelPaddings : UILabel

@property (nonatomic, assign) UIEdgeInsets paddings;
- (instancetype)initWithPaddings:(UIEdgeInsets)paddings;

@end

NS_ASSUME_NONNULL_END
