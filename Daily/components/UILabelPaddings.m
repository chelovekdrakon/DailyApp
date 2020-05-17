//
//  UILabelPaddings.m
//  Daily
//
//  Created by Фёдор Морев on 5/17/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "UILabelPaddings.h"

@implementation UILabelPaddings

- (instancetype)initWithPaddings:(UIEdgeInsets)paddings {
    self = [super init];
    if (self) {
        _paddings = paddings;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.paddings)];
}

- (CGSize)intrinsicContentSize {
    CGSize superContntSize = [super intrinsicContentSize];
    
    CGFloat width = superContntSize.width + self.paddings.left + self.paddings.right;
    CGFloat height = superContntSize.height + self.paddings.top + self.paddings.bottom;
    
    return CGSizeMake(width, height);
}

@end
