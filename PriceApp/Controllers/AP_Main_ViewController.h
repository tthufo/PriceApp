//
//  AP_Main_ViewController.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewPagerController.h"

@interface AP_Main_ViewController : ViewPagerController

- (void)disableTabView:(BOOL)isDisable;

- (NSMutableDictionary*)parentInformation;

- (void)resetFilter;

@end
