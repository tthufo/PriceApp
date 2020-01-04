//
//  AP_Price_ViewController.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/12/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewPagerController.h"

@interface AP_Price_ViewController : ViewPagerController

- (void)disableTabView:(BOOL)isDisable;

- (NSString*)monsterId;

- (NSString*)wardId;

- (NSString*)dateTime;

@end
