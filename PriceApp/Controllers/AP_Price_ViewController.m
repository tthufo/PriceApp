//
//  AP_Main_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "AP_Price_ViewController.h"

#import "PA_Inner_ViewController.h"

@interface AP_Price_ViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    IBOutlet NSLayoutConstraint * topBar;
    
    NSMutableArray * controllers;
    
    NSArray * tabsName;
    
    IBOutlet DropButton * typeButton, * wardButton;
    
    IBOutlet UIButton * cal;
    
    IBOutlet UILabel * calendar, * titleLabel, * typeLabel;
    
    NSString * petId, * wardId, * dateTime;
    
    IBOutlet UIView * bar;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation AP_Price_ViewController

- (NSString*)monsterId
{
    return petId;
}

- (NSString*)wardId
{
    return wardId;
}

- (NSString*)dateTime
{
    return dateTime;
}

- (NSString*)returnTitleLabel
{
    NSDictionary * uInfo = [ObjectInfo shareInstance].uInfo[@"Account"];
    
    NSString * city = [[uInfo[@"TenTinhThanh"] stringByReplacingOccurrencesOfString:@"Thành phố" withString:@""] stringByReplacingOccurrencesOfString:@"Tỉnh" withString:@""];
    
    NSString * province = [[[[uInfo[@"TenQuanHuyen"] stringByReplacingOccurrencesOfString:@"Thị xã" withString:@""] stringByReplacingOccurrencesOfString:@"Quận" withString:@""] stringByReplacingOccurrencesOfString:@"Thành phố" withString:@""] stringByReplacingOccurrencesOfString:@"Huyện" withString:@""];
    
    return [NSString stringWithFormat:@"Bạn đang nhập giá cho:%@, %@", city, province];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = @"Nhập giá";

    titleLabel.text = [self returnTitleLabel];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11"))
    {
        topBar.constant = 44;
    }
    
    calendar.text = [self nowDay];
    
    dateTime = calendar.text;
    
    self.topHeight = [self isIphoneX] ? @"244" : @"220";
    
    self.dataSource = self;
    
    self.delegate = self;
    
    
    
    PA_Inner_ViewController * first = [PA_Inner_ViewController new];
    
    first.info = @{@"type":@"0"};

    PA_Inner_ViewController * second = [PA_Inner_ViewController new];

    second.info = @{@"type":@"1"};

    PA_Inner_ViewController * third = [PA_Inner_ViewController new];

    third.info = @{@"type":@"2", @"top":@(1)};
    
    
    
    controllers = [@[first, second, third] mutableCopy];
    
    tabsName = @[@"Thịt", @"Thức ăn", @"Thuốc"];
    
    
    bar.frame = CGRectMake(0, 0, screenWidth1, 45);
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    [typeButton actionForTouch:@{} and:^(NSDictionary *touchInfo) {

        if([ObjectInfo shareInstance].petList.count == 0)
        {
            [[ObjectInfo shareInstance] didRequestForPet];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [typeButton didDropDownWithData:[ObjectInfo shareInstance].petList andCompletion:^(id object) {
                        if(object)
                        {
                            [typeButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            petId = [object[@"data"] getValueFromKey: @"Id"];

                            [((PA_Inner_ViewController*)[((UIPageViewController*)[self.childViewControllers firstObject]).viewControllers lastObject]) didRequestForType:petId];
                        }
                    }];
                }
                else
                {
                    [self showToast:@"Sự cố xảy ra, mời bạn thử lại sau" andPos:0];
                }
            };
        }
        else
        {
            [typeButton didDropDownWithData:[ObjectInfo shareInstance].petList andCompletion:^(id object) {
                if(object)
                {
                    [typeButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    petId = [object[@"data"] getValueFromKey: @"Id"];
                    
                    [((PA_Inner_ViewController*)[((UIPageViewController*)[self.childViewControllers firstObject]).viewControllers lastObject]) didRequestForType:petId];
                }
            }];
        }
    }];
    
    [wardButton actionForTouch:@{} and:^(NSDictionary *touchInfo) {
 
        if([ObjectInfo shareInstance].wardList.count == 0)
        {
            [[ObjectInfo shareInstance] didRequestWard];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [wardButton didDropDownWithData:[ObjectInfo shareInstance].wardList andCompletion:^(id object) {
                        if(object)
                        {
                            [wardButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            wardId = [object[@"data"] getValueFromKey: @"Id"];
                        }
                    }];
                }
                else
                {
                    [self showToast:@"Sự cố xảy ra, mời bạn thử lại sau" andPos:0];
                }
            };
        }
        else
        {
            [wardButton didDropDownWithData:[ObjectInfo shareInstance].wardList andCompletion:^(id object) {
                if(object)
                {
                    [wardButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    wardId = [object[@"data"] getValueFromKey: @"Id"];
                }
            }];
        }
    }];
    
    [cal actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        NSString * date = [calendar.text isEqualToString:[self nowDay]] ? [self nowDay] : calendar.text;
        
        [[[EM_MenuView alloc] initWithDate:date ? @{@"date":date, @"title":@"Ngày cập nhật"} : @{@"title":@"Ngày cập nhật"}] showWithCompletion:^(int innerIndex, id innerObject, EM_MenuView *innerMenu) {
            
            if(innerObject)
            {
                calendar.text = innerObject[@"date"];
                
                dateTime = innerObject[@"date"];
                
                [innerMenu close];
            }
            
        }];
    }];
}

- (void)disableTabView:(BOOL)isDisable
{
    if(isDisable)
    {
        [self.tabsView addSubview:bar];
    }
    else
    {
        [bar removeFromSuperview];
    }
    
    self.tabsView.userInteractionEnabled = !isDisable;
}

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    for(UIView * v in viewPager.tabsView.subviews)
    {
        if(v.tag != 9999)
        {
            [v withBorder:@{@"Bcolor":[UIColor blackColor],@"Bwidth":@(0.5),@"Bcorner":@(5)}];
            
            v.backgroundColor = [viewPager.tabsView.subviews indexOfObject:v] == index ? [AVHexColor colorWithHexString:@"#1246AA"] : [AVHexColor colorWithHexString:@"F5F5F5"];
            
            for(UIView * tab in v.subviews)
            {
                if([tab isKindOfClass:[UILabel class]])
                {
                    ((UILabel*)tab).textColor = [viewPager.tabsView.subviews indexOfObject:v] == index ? [UIColor whiteColor] : [UIColor blackColor];
                }
            }
        }
    }
    
    self.indexSelected = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    
    typeLabel.text = [self.indexSelected isEqualToString:@"0"] ? @"Loại thịt" : [self.indexSelected isEqualToString:@"1"] ? @"Loại thức ăn" : @"Loại thuốc";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - Setters

- (void)setNumberOfTabs:(NSUInteger)numberOfTabs
{
    _numberOfTabs = numberOfTabs;
    
    [self reloadData];
}

#pragma mark - Helpers

- (void)loadContent
{
    self.numberOfTabs = [tabsName count];
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return self.numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    return [self modelLabel:index];
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    UIViewController * control = controllers[index];
    
    return control;
}

- (UILabel*)modelLabel:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    [self boldFontForLabel:label];
    label.text = tabsName[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

#pragma mark - ViewPagerDelegate

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case ViewPagerOptionStartFromSecondTab:
            return 0;
        case ViewPagerOptionCenterCurrentTab:
            return 0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 45.0;
        case ViewPagerOptionTabOffset:
            return 0;
        case ViewPagerOptionTabWidth:
            return ((self.view.frame.size.width) / 3) + 0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component)
    {
        case ViewPagerIndicator:
            return [UIColor clearColor];
        case ViewPagerTabsView:
            return [UIColor colorWithRed:207.0/255.0 green:209.0/255.0 blue:211.0/255.0 alpha:0];
        case ViewPagerContent:
            [[UIColor clearColor] colorWithAlphaComponent:1];
        default:
            return color;
    }
}

-(void)boldFontForLabel:(UILabel *)label
{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) ? 15 : 15];
    label.font = newFont;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

