//
//  PA_Main_Inner_ViewController.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/13/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PA_Main_Inner_ViewController : UIViewController

- (void)didRequestForUpdate;

- (void)reInitKeyBoard:(BOOL)isEnable;

- (void)didUpdateParentInfo;

- (void)didReloadUpdate;

- (void)didReloadFilter:(NSString*)filter;

- (NSMutableDictionary*)childTempInfo;

- (IBAction)disMiss;

@property (nonatomic, retain) NSDictionary * info;

@end
