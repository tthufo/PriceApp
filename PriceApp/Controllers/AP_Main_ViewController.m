//
//  AP_Main_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "AP_Main_ViewController.h"

#import "PA_Main_Inner_ViewController.h"

#import "AP_Price_ViewController.h"

#import "AP_Chart_ViewController.h"

@interface AP_Main_ViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    IBOutlet NSLayoutConstraint * topBar;
    
    NSMutableArray * controllers;

    NSArray * tabsName;
        
    IBOutlet DropButton * typeButton;
    
    IBOutlet UITextField * txt1;
    
    IBOutlet UIView * bar;
    
    NSString * petId;
    
    NSMutableDictionary * parentinfo;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation AP_Main_ViewController

- (NSString*)monsterId
{
    return petId;
}

- (NSMutableDictionary*)parentInformation
{
    return parentinfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11"))
    {
        topBar.constant = 44;
    }
    
    self.topHeight = [self isIphoneX] ? @"194" : @"170" ;
    
    self.dataSource = self;
    
    self.delegate = self;
    
    
    PA_Main_Inner_ViewController * first = [PA_Main_Inner_ViewController new];
    
    first.info = @{@"type":@"0"};
    
    PA_Main_Inner_ViewController * second = [PA_Main_Inner_ViewController new];
    
    second.info = @{@"type":@"1"};
    
    PA_Main_Inner_ViewController * third = [PA_Main_Inner_ViewController new];
    
    third.info = @{@"type":@"2"};
    
    
    
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
                            
                            parentinfo[@"petId"] = petId;
                            
                            [[self childControl] didReloadUpdate];
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
                    
                    parentinfo[@"petId"] = petId;

                    [[self childControl] didReloadUpdate];
                }
            }];
        }
    }];
    
    NSDictionary * uInfo = [ObjectInfo shareInstance].uInfo[@"Account"];

    parentinfo = [@{@"cityId":uInfo[@"TinhThanhId"], @"provinceId":uInfo[@"QuanHuyenId"], @"cityName":uInfo[@"TenTinhThanh"], @"provinceName":uInfo[@"TenQuanHuyen"]} mutableCopy];
    
    [txt1 removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [txt1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)isDateValid:(NSDictionary*)curentDate andDate:(NSDictionary*)inputDate andPicker:(UIDatePicker*)picker
{
    NSDate * date1 = [curentDate[@"fromDate"] dateWithFormat:@"dd.MM.yyyy"];
    
    NSDate * date2 = [inputDate[@"date"] dateWithFormat:@"dd.MM.yyyy"];
    
    if ([date1 compare:date2] == NSOrderedDescending) {
        
        [self showToast:@"Ngày nhập cuối nhỏ hơn ngày nhập đầu" andPos:0];
        
        [picker setDate:[NSDate date]];

        return NO;
        
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        
        return YES;
        
    } else {
        
        return YES;
        
    }
    
    return NO;
}

- (IBAction)didPressMenu:(id)sender
{
    [[self childControl] reInitKeyBoard:NO];

    [[[EM_MenuView alloc] initWithMenu:parentinfo] showWithCompletionDisable:^(int index, id object, EM_MenuView * menu) {
        
        [[self childControl] reInitKeyBoard:YES];
        
        if(![object[@"obj"] responseForKey:@"fromDate"] && index == 1)
        {
            [self showToast:@"Bạn chưa chọn ngày bắt đầu" andPos:0];
            
            return;
        }
        
        if(index == 1 || index == 0)
        {
            [[[EM_MenuView alloc] initWithDate:[object[@"obj"] responseForKey:index == 0 ? @"fromDate" : @"toDate"] ? @{@"date":object[@"obj"][index == 0 ? @"fromDate" : @"toDate"], @"title": index == 0 ? @"Ngày đầu" : @"Ngày cuối"} : @{@"title": index == 0 ? @"Ngày đầu" : @"Ngày cuối"}] showWithCompletion:^(int innerIndex, id innerObject, EM_MenuView * innerMenu) {
                
                if(innerObject)
                {
                    if(index == 1 && ![self isDateValid:object[@"obj"] andDate:innerObject andPicker:innerObject[@"picker"]])
                    {
                        return;
                    }
                    
                    if(index == 0 && [object[@"obj"] responseForKey:@"toDate"])
                    {
                        NSDate * date1 = [innerObject[@"date"] dateWithFormat:@"dd.MM.yyyy"];
                        
                        NSDate * date2 = [object[@"obj"][@"toDate"] dateWithFormat:@"dd.MM.yyyy"];
                        
                        if ([date1 compare:date2] == NSOrderedDescending) {
                            
                            [self showToast:@"Ngày nhập cuối nhỏ hơn ngày nhập đầu" andPos:0];
                            
                            [(UIDatePicker*)innerObject[@"picker"] setDate:[NSDate date]];
                            
                            return ;
                            
                        } 
                    }
                    
                    ((UILabel*)[self withView:[self withView:menu.containerView tag:2018] tag:20 + index]).text = innerObject[@"date"];
                    
                    object[@"obj"][index == 0 ? @"fromDate" : @"toDate"] = innerObject[@"date"];
                    
                    [innerMenu close];
                }
                
            }];
        }
        
        if(object && index == 99)
        {
            [parentinfo removeAllObjects];
            
            [parentinfo addEntriesFromDictionary:object];
            
            [[self childControl] didReloadUpdate];
        }
        
    }];
}

- (PA_Main_Inner_ViewController*)childControl
{
    return ((PA_Main_Inner_ViewController*)[((UIPageViewController*)[self.childViewControllers firstObject]).viewControllers lastObject]);
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

- (IBAction)didPressUpdate:(id)sender
{
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:[AP_Price_ViewController new] animated:YES];
}

- (IBAction)didPressChart:(id)sender
{
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:[AP_Chart_ViewController new] animated:YES];
}

- (IBAction)didPressPower:(id)sender
{
    NSDictionary * uInfo = [ObjectInfo shareInstance].uInfo[@"Account"];
    
    [[DropAlert shareInstance] alertWithInfor:@{@"title":@"Thông báo", @"message":[NSString stringWithFormat:@"Bạn có muốn đăng xuất khỏi tài khoản %@", uInfo[@"UserName"]], @"buttons":@[@"Đăng xuất", @"Thoát"], @"cancel":@"Không"} andCompletion:^(int indexButton, id object) {
        
        if(indexButton == 0)
        {
            [self removeValue:@"name"];
            
            [self removeValue:@"pass"];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else if(indexButton == 1)
        {
            exit(0);
        }
        
    }];
}

- (IBAction)didPressBack:(id)sender
{
    exit(0);
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
    
    if(![[[self childControl] childTempInfo] isEqualToDictionary:parentinfo])
    {
        [[self childControl] didReloadUpdate];
    }
    
    self.indexSelected = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    
    txt1.placeholder = [self.indexSelected isEqualToString:@"0"] ? @"Loại thịt" : [self.indexSelected isEqualToString:@"1"] ? @"Loại thức ăn" : @"Loại thuốc";
}

- (void)resetFilter
{
    txt1.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self childControl] disMiss];
    
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
- (void)textFieldDidChange:(UITextField*)txtField
{
//    NSString * update = [textField.text stringByReplacingCharactersInRange:range withString:string];

    [[self childControl] didReloadFilter:txtField.text];
    
//    return YES;
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
