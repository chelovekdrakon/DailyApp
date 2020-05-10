//
//  LoggerInputViewController.h
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionHandler)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LoggerInputViewController : UIViewController
- (instancetype)initWithCompletionHandler:(CompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
