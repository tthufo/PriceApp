//
//  AppDelegate.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


@interface NSObject (XXX)

- (NSString*)nowDay;

- (BOOL)isIphoneX;

@end

@interface NSDate (datee)

- (NSString *)getISO8601String;

@end
