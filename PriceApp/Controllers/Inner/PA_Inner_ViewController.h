//
//  PA_Inner_ViewController.h
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PA_Inner_ViewController : UIViewController

@property (nonatomic, retain) NSDictionary * info;

- (void)didRequestForType:(NSString*)petId;

@end
