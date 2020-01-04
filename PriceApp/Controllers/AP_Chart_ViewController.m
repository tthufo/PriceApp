//
//  AP_Chart_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/17/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "AP_Chart_ViewController.h"

#import "AP_Chart_Inner_ViewController.h"

#import "MCLineChartView.h"

@interface AP_Chart_ViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    IBOutlet NSLayoutConstraint * topBar;
    
    NSMutableArray * controllers;
    
    NSArray * tabsName;
    
    IBOutlet DropButton * typeButton, * province, * city;
    
    IBOutlet UIView * bar;
    
    NSMutableDictionary * queryInfo, * foodInfo, * medInfo;
    
    NSString * petId;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation AP_Chart_ViewController

- (NSString*)monsterId
{
    return petId;
}

- (NSMutableDictionary*)parentInfo
{
    return [self.indexSelected isEqualToString:@"0"] ? queryInfo : [self.indexSelected isEqualToString:@"1"] ? foodInfo : medInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11"))
    {
        topBar.constant = 44;
    }
    
    
    
    queryInfo = [@{@"type":@"1", @"thitid":@"", @"meatName":@"Chọn loại thịt", @"dataType":@"1", @"host":self} mutableCopy];
    
    foodInfo = [@{@"type":@"1", @"thucanid":@"", @"foodName":@"Chọn loại thức ăn", @"dataType":@"2", @"host":self} mutableCopy];
    
    medInfo = [@{@"type":@"1", @"thuocid":@"", @"medName":@"Chọn loại thuốc", @"dataType":@"3", @"host":self} mutableCopy];
    
    
    
    
    self.topHeight = [self isIphoneX] ? @"140" : @"120";
    
    self.dataSource = self;
    
    self.delegate = self;
    
    
    
    AP_Chart_Inner_ViewController * first = [AP_Chart_Inner_ViewController new];
    
    first.info = @{@"type":@"0",@"height":self.topHeight};
    
    AP_Chart_Inner_ViewController * second = [AP_Chart_Inner_ViewController new];
    
    second.info = @{@"type":@"1",@"height":self.topHeight};
    
    AP_Chart_Inner_ViewController * third = [AP_Chart_Inner_ViewController new];
    
    third.info = @{@"type":@"2", @"top":@(1),@"height":self.topHeight};
    
    
    
    controllers = [@[first, second, third] mutableCopy];
    
    tabsName = @[@"Thịt", @"Thức ăn", @"Thuốc"];
    
    
    bar.frame = CGRectMake(0, 0, screenWidth1, 45);
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    
    [typeButton actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(([self.indexSelected isEqualToString:@"0"] ? [ObjectInfo shareInstance].meatList.count : [self.indexSelected isEqualToString:@"1"] ? [ObjectInfo shareInstance].foodList.count : [ObjectInfo shareInstance].medList.count) == 0)
        {
            switch ([self.indexSelected intValue]) {
                case 0:
                {
                    [[ObjectInfo shareInstance] didRequestForMeatList];
                }
                    break;
                case 1:
                {
                    [[ObjectInfo shareInstance] didRequestForFoodList];
                }
                    break;
                case 2:
                {
                    [[ObjectInfo shareInstance] didRequestForMedList];
                }
                    break;
                default:
                    break;
            }
            
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [typeButton didDropDownWithData:[self.indexSelected isEqualToString:@"0"] ? [ObjectInfo shareInstance].meatList : [self.indexSelected isEqualToString:@"1"] ? [ObjectInfo shareInstance].foodList : [ObjectInfo shareInstance].medList andCompletion:^(id object) {
                        if(object)
                        {
                            [typeButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            ((NSMutableDictionary*)[self parentInfo])[[self.indexSelected isEqualToString:@"0"] ? @"thitid" : [self.indexSelected isEqualToString:@"1"] ? @"thucanid" : @"thuocid"] = [object[@"data"] getValueFromKey: @"Id"];

                            ((NSMutableDictionary*)[self parentInfo])[[self.indexSelected isEqualToString:@"0"] ? @"meatName" : [self.indexSelected isEqualToString:@"1"] ? @"foodName" : @"medName"] = object[@"data"][@"Ten"];
                            
                            if(![[self parentInfo] responseForKey:@"ids"])
                            {
                                return;
                            }
                            
                            if(![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"fromDate"] || ![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"toDate"])
                            {
                                return;
                            }
                            
                            [[self childControl] didRequestChart];
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
            [typeButton didDropDownWithData:[self.indexSelected isEqualToString:@"0"] ? [ObjectInfo shareInstance].meatList : [self.indexSelected isEqualToString:@"1"] ? [ObjectInfo shareInstance].foodList : [ObjectInfo shareInstance].medList andCompletion:^(id object) {
                if(object)
                {
                    [typeButton setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    ((NSMutableDictionary*)[self parentInfo])[[self.indexSelected isEqualToString:@"0"] ? @"thitid" : [self.indexSelected isEqualToString:@"1"] ? @"thucanid" : @"thuocid"] = [object[@"data"] getValueFromKey: @"Id"];
                    
                    ((NSMutableDictionary*)[self parentInfo])[[self.indexSelected isEqualToString:@"0"] ? @"meatName" : [self.indexSelected isEqualToString:@"1"] ? @"foodName" : @"medName"] = object[@"data"][@"Ten"];
                    
                    if(![[self parentInfo] responseForKey:@"ids"])
                    {
                        return;
                    }
                    
                    if(![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"fromDate"] || ![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"toDate"])
                    {
                        return;
                    }
                    
                    [[self childControl] didRequestChart];
                    
                }
            }];
        }
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
    [[ObjectInfo shareInstance] clearDataChart];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDictionary*)getTitleAndValue:(NSArray*)array
{
    NSMutableArray * names = [NSMutableArray new];
    
    NSMutableArray * iDs = [NSMutableArray new];
    
    for(NSDictionary * dict in array)
    {
        if([dict[@"active"] boolValue])
        {
            [names addObject:dict[@"Ten"]];
            
            [iDs addObject:dict[@"Id"]];
        }
    }
    
    return @{@"names":[names componentsJoinedByString:@","], @"ids":iDs};
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
        
        int daysToAdd = 15;
        
        NSDate * newDate = [date1 dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        if ([date2 compare:newDate] == NSOrderedDescending) {
            
            [self showToast:@"Ngày nhập cuối không được quá 15 ngày so với ngày nhập đầu" andPos:0];
            
            [picker setDate:newDate];
            
            return NO;
        } else if ([date1 compare:date2] == NSOrderedAscending) {
            
            return YES;
            
        } else {
            return YES;
        }
    } else {
        return YES;
    }
    
    return NO;
}

- (NSString*)defaultTitle:(NSString*)type
{
    return [type isEqualToString:@"1"] ? @"Chọn Tỉnh/thành phố" : [type isEqualToString:@"2"] ? @"Chọn Quận/huyện" : @"Chọn Phường/xã";
}

- (IBAction)didPressOption:(id)sender
{
    if([((NSMutableDictionary*)[self parentInfo])[([self.indexSelected isEqualToString:@"0"] ? @"thitid" : [self.indexSelected isEqualToString:@"1"] ? @"thucanid" : @"thuocid")] isEqualToString:@""])
    {
        [self showToast:[NSString stringWithFormat:@"Bạn chưa chọn %@", [self.indexSelected isEqualToString:@"0"] ? @"loại thịt" : [self.indexSelected isEqualToString:@"1"] ? @"loại thức ăn" : @"loại thuốc"] andPos:0];
        
        return;
    }
    
    [[[EM_MenuView alloc] initWithChartMenu:[self parentInfo]] showWithCompletionDisable:^(int index, id object, EM_MenuView *menu) {
        
        if(index == 915)
        {
            if(object)
            {
                [((NSMutableDictionary*)[self parentInfo]) removeObjectForKey:@"ids"];
                
                ((NSMutableDictionary*)[self parentInfo])[@"type"] = object[@"data"][@"Id"];
            }
        }
        
        
        if(index == 911)
        {
            [[[EM_MenuView alloc] initWithLayers:@{@"data":object[@"data"], @"type":[self parentInfo][@"type"]}] showWithCompletion:^(int innerIndex, id innerObject, EM_MenuView *innerMenu) {
                
                if(innerIndex == 912)
                {
                    NSDictionary * data = [self getTitleAndValue:innerObject];
                    
                    [((DropButton*)object[@"name"]) setTitle:((NSString*)data[@"names"]).length == 0 ?  [self defaultTitle:((DropButton*)object[@"name"]).accessibilityLabel] : data[@"names"] forState:UIControlStateNormal];
                    
                    if(((NSArray*)data[@"ids"]).count != 0)
                    {
                        ((NSMutableDictionary*)[self parentInfo])[@"ids"] = data[@"ids"];
                    }
                    else
                    {
                        [(NSMutableDictionary*)[self parentInfo] removeObjectForKey:@"ids"];
                    }
                    
                    ((NSMutableDictionary*)[self parentInfo])[@"names"] = data[@"names"];

                    [innerMenu close];
                }
            }];
        }
        
        if(index == 0 || index == 1)
        {
            if(![object[@"obj"] responseForKey:@"fromDate"] && index == 1)
            {
                [self showToast:@"Bạn chưa chọn ngày bắt đầu thống kê" andPos:0];
                
                return;
            }
            
            [[[EM_MenuView alloc] initWithDate:[object[@"obj"] responseForKey:index == 0 ? @"fromDate" : @"toDate"] ? @{@"date":object[@"obj"][index == 0 ? @"fromDate" : @"toDate"], @"title": index == 0 ? @"Ngày đầu" : @"Ngày cuối"} : @{@"title": index == 0 ? @"Ngày đầu" : @"Ngày cuối"}] showWithCompletion:^(int dateIndex, id dateObject, EM_MenuView *dateMenu) {
                
                if(dateObject)
                {
                    if(index == 1 && ![self isDateValid:object[@"obj"] andDate:dateObject andPicker:dateObject[@"picker"]])
                    {
                        return;
                    }
                    
                    if(index == 0 && [object[@"obj"] responseForKey:@"toDate"])
                    {
                        NSDate * date1 = [dateObject[@"date"] dateWithFormat:@"dd.MM.yyyy"];
                        
                        NSDate * date2 = [object[@"obj"][@"toDate"] dateWithFormat:@"dd.MM.yyyy"];

                        if ([date1 compare:date2] == NSOrderedDescending) {
                            
                            [self showToast:@"Ngày nhập cuối nhỏ hơn ngày nhập đầu" andPos:0];
                            
                            [(UIDatePicker*)dateObject[@"picker"] setDate:[NSDate date]];
                            
                            return ;
                            
                        } else if ([date1 compare:date2] == NSOrderedAscending) {
                            
                            int daysToAdd = 15;
                            
                            NSDate * newDate = [date1 dateByAddingTimeInterval:60*60*24*daysToAdd];
                            
                            if ([date2 compare:newDate] == NSOrderedDescending) {
                                
                                [self showToast:@"Ngày nhập đầu không được quá 15 ngày so với ngày nhập cuối" andPos:0];
                                
                                int daysToSubtract = -15;
                                
                                NSDate * backWardDate = [date2 dateByAddingTimeInterval:60*60*24*daysToSubtract];
                                
                                [(UIDatePicker*)dateObject[@"picker"] setDate:backWardDate];
                                
                                return ;
                            }
                        }
                    }
                    
                    ((UILabel*)[self withView:[self withView:menu.containerView tag:2018] tag:20 + index]).text = dateObject[@"date"];
                    
                    object[@"obj"][index == 0 ? @"fromDate" : @"toDate"] = dateObject[@"date"];
                    
                    [dateMenu close];
                }
                
            }];
        }
        
        if(index == 199)
        {
            [((NSMutableDictionary*)[self parentInfo]) removeObjectForKey:@"type"];
            
            [object removeObjectForKey:@"ids"];
            
            [object removeObjectForKey:@"names"];

            [((NSMutableDictionary*)[self parentInfo]) addEntriesFromDictionary:object];
            
            
            NSLog(@"------>%@", [self parentInfo]);
            
            
            [self didRequestChart:menu];
        }
        
        if(index == 200)
        {
            [((NSMutableDictionary*)[self parentInfo]) removeObjectForKey:@"type"];
            
            [object removeObjectForKey:@"ids"];
            
            [object removeObjectForKey:@"names"];
            
            [((NSMutableDictionary*)[self parentInfo]) addEntriesFromDictionary:object];
                        
            [menu close];
        }
        
    }];
}

- (void)didRequestChart:(EM_MenuView*)menu
{
    if(![[self parentInfo] responseForKey:@"ids"])
    {
        NSString * type = [((NSMutableDictionary*)[self parentInfo])[@"type"] isEqualToString:@"1"] ? @"tỉnh/thành phố" : [((NSMutableDictionary*)[self parentInfo])[@"type"] isEqualToString:@"2"] ? @"tỉnh/thành phố/quận/huyện" : @"tỉnh/thành phố/quận/huyện/phường/xã";
        
        [self showToast:[NSString stringWithFormat:@"Bạn phải chọn %@", type] andPos:0];
        
        return;
    }
    
    if(![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"fromDate"] || ![((NSMutableDictionary*)[self parentInfo]) responseForKey:@"toDate"])
    {
        [self showToast:@"Bạn phải chọn ngày bắt đầu và kết thúc" andPos:0];
        
        return;
    }
    
    [[self childControl] didRequestChart];
    
    [menu close];
}

- (AP_Chart_Inner_ViewController*)childControl
{
    return ((AP_Chart_Inner_ViewController*)[((UIPageViewController*)[self.childViewControllers firstObject]).viewControllers lastObject]);
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
    
    [typeButton setTitle:[self.indexSelected isEqualToString:@"0"] ? ((NSMutableDictionary*)[self parentInfo])[@"meatName"] : [self.indexSelected isEqualToString:@"1"] ? ((NSMutableDictionary*)[self parentInfo])[@"foodName"] : ((NSMutableDictionary*)[self parentInfo])[@"medName"] forState:UIControlStateNormal];
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
    

