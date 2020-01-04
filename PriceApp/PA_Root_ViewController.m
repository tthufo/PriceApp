//
//  PA_Root_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 7/6/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "PA_Root_ViewController.h"

#import "AP_Main_ViewController.h"

#import "AP_Price_ViewController.h"

#import "AP_Chart_ViewController.h"

@interface PA_Root_ViewController ()

@end

@implementation PA_Root_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];

    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -15)];
    
    AP_Main_ViewController * main = [AP_Main_ViewController new];

    AP_Price_ViewController * price = [AP_Price_ViewController new];

    AP_Chart_ViewController * chart = [AP_Chart_ViewController new];

    
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:price];
    
    nav1.navigationBarHidden = YES;
    
    nav1.title = @"Nhập Giá";
    

    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:main];
    
    nav.navigationBarHidden = YES;

    nav.title = @"Thông Tin";
    
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:chart];
    
    nav2.navigationBarHidden = YES;

    nav2.title = @"Biểu Đồ";
    

    
    self.viewControllers = @[nav, nav1, nav2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
