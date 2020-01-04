//
//  PA_Main_Inner_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/13/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "PA_Main_Inner_ViewController.h"

#import "AP_Main_ViewController.h"

@interface PA_Main_Inner_ViewController ()
{
    IBOutlet NSLayoutConstraint * bottomBar , * spaceBar;
    
    IBOutlet UITableView * tableView;
    
    IBOutlet UIView * header;
    
    NSMutableArray * dataList, * tempList;
    
    IBOutlet UIButton * escape;
    
    int pageIndex, pageSize;
    
    BOOL isOn, isUp, isLoadMore;
    
    UIRefreshControl * refreshControl;
    
    NSMutableDictionary * tempInfo;
}

@end

@implementation PA_Main_Inner_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bottomBar.constant = 0;
    
    spaceBar.constant = -50;

    pageIndex = 1;
    
    [tableView withCell:@"E_Empty"];
    
    [tableView withCell:@"AP_Main_Cell"];
    
    dataList = [@[] mutableCopy];
    
    tempList = [@[] mutableCopy];

    tempInfo = [@{} mutableCopy];
    

    __block PA_Main_Inner_ViewController * mySelf = self;
    
    __block UITableView * myTable = tableView;

    refreshControl = [[UIRefreshControl alloc]init];
    
    [tableView addSubview:refreshControl];
    
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    [tableView addFooterWithBlock:^{
        
        isLoadMore = YES;

        if(pageIndex >= pageSize)
        {
            [myTable footerEndRefreshing];

            return;
        }
        
        pageIndex += 1;
        
        [mySelf didRequestForUpdate];
    }];
    
//    [mySelf didRequestForUpdate];
}

- (void)refreshTable
{
    [refreshControl endRefreshing];
    
    [self didReloadUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    

//    if(![tempInfo isEqualToDictionary:[[self parentController] parentInformation]])
//    {
//        [self didReloadUpdate];
//    }
}

- (void)didReloadUpdate
{
    pageIndex = 1;
    
    isLoadMore = NO;
    
    [[self parentController] resetFilter];
    
    [self didRequestForUpdate];
}

- (void)didUpdateParentInfo
{
    [tempInfo removeAllObjects];
    
    [tempInfo addEntriesFromDictionary: [[self parentController] parentInformation]];
}

- (NSMutableDictionary*)childTempInfo
{
    return tempInfo;
}

- (IBAction)disMiss
{
    CGRect rect =  [self parentController].view.frame;
    
    rect.origin.y = 0;
    
    [self parentController].view.frame = rect;
    
    isOn = YES;
    
    [self didDisable:NO];
    
    [[self parentController].view endEditing:YES];
}

- (void)didChangeFrame:(NSNotification *)notification
{
    if(isUp)
        return;
    
    if(!isOn)
    {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        CGRect rect =  self.parentViewController.parentViewController.view.frame;
        
        rect.origin.y -= keyboardSize.height - ([self isIphoneX] ? 140 + 55 : 60 + 55);
        
        [self parentController].view.frame = rect;
        
        [self didDisable:YES];
    }
}

- (AP_Main_ViewController*)parentController
{
    return self.parentViewController.parentViewController;
}

- (void)didHide:(NSNotification *)notification
{
    isOn = NO;
}

- (void)reInitKeyBoard:(BOOL)isEnable
{
    if(isEnable)
    {
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didHide:) name:UIKeyboardDidHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    return YES;
}

- (void)didDisable:(BOOL)isDisable
{
    for (UIScrollView *view in ((UIPageViewController*)self.parentViewController).view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = !isDisable;
        }
    }
    
    isUp = isDisable;
    
    escape.hidden = !isDisable;
    
    bottomBar.constant = isDisable ? 40 : 0;
    
    spaceBar.constant = !isDisable ? -50 : 0;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, isDisable ? ([self isIphoneX] ? 70 + 55 : 30 + 55) : 0, 0);
    
    [[self parentController] disableTabView:isDisable];
}

- (NSString*)isoDate:(NSString*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    NSDate *now = [date dateWithFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter stringFromDate:now];
}

- (void)didRequestForUpdate
{
//    NSString * type = [info[@"type"] isEqualToString:@"0"] ? @"thitId" : [info[@"type"] isEqualToString:@"1"] ? @"thucanId" : @"thuocId";
    
    NSString * sendType = [info[@"type"] isEqualToString:@"0"] ? @"DanhSachGiaThit" : [info[@"type"] isEqualToString:@"1"] ? @"DanhSachGiaThucAn" : @"DanhSachGiaThuoc";
    
    NSDictionary * parInfo = [[self parentController] parentInformation];
    
    NSMutableDictionary * allInfo = [@{} mutableCopy];
    
    if([parInfo responseForKey:@"petId"])
    {
        allInfo[@"vatnuoiId"] = [parInfo getValueFromKey: @"petId"];
    }
    
    if([parInfo responseForKey:@"cityId"])
    {
        allInfo[@"tinhthanhId"] = [parInfo getValueFromKey: @"cityId"];
    }
    
    if([parInfo responseForKey:@"provinceId"])
    {
        allInfo[@"quanhuyenId"] = [parInfo getValueFromKey: @"provinceId"];
    }

    if([parInfo responseForKey:@"wardId"])
    {
        allInfo[@"xaphuongId"] = [parInfo getValueFromKey: @"wardId"];
    }
    
    
    
    if([parInfo responseForKey:@"fromDate"])
    {
        allInfo[@"batdau"] = [self isoDate:[parInfo getValueFromKey: @"fromDate"]];
    }
    
    if([parInfo responseForKey:@"toDate"])
    {
        allInfo[@"ketthuc"] = [self isoDate:[parInfo getValueFromKey: @"toDate"]];
    }
    
    if([parInfo responseForKey:@"fromPrice"] && ![[parInfo getValueFromKey:@"fromPrice"] isEqualToString:@""])
    {
        allInfo[@"GiaTu"] = @([[[parInfo getValueFromKey: @"fromPrice"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue]);
    }
    
    if([parInfo responseForKey:@"toPrice"] && ![[parInfo getValueFromKey:@"toPrice"] isEqualToString:@""])
    {
        allInfo[@"GiaDen"] = @([[[parInfo getValueFromKey: @"toPrice"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue]);
    }
    
    
    
    if([[parInfo getValueFromKey:@"fromPrice"] intValue] > [[parInfo getValueFromKey:@"toPrice"] intValue])
    {
        [allInfo removeObjectForKey:@"fromPrice"];
        
        [allInfo removeObjectForKey:@"toPrice"];
    }
    
    
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    NSMutableDictionary * constant = [@{@"absoluteLink":[NSString stringWithFormat:@"%@/gia/%@",infoPlist[@"host"], sendType],
                                @"method":@"GET",
                                @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                @"page_size":@(20),
                                @"page_index":@(pageIndex),
                                @"overrideAlert":@(1),
                                @"host":self,
                                @"overrideLoading":@(1)
                                } mutableCopy] ;
    
    constant[@"Getparam"] = allInfo;
    
    [[LTRequest sharedInstance] didRequestInfo:constant withCache:^(NSString *cacheString) {

                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     
                                                     [tableView headerEndRefreshing];
                                                     
                                                     [tableView footerEndRefreshing];
                                                     
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         NSDictionary * result = [responseString objectFromJSONString];
                                                                                                                  
                                                         if(![result[@"Result"] boolValue])
                                                         {
                                                             [self showToast:result[@"Message"] andPos:0];
                                                             
                                                             return ;
                                                         }
                                                         
                                                         pageSize = [result[@"total_page"] intValue];
                                                         
                                                         if(!isLoadMore)
                                                         {
                                                             [dataList removeAllObjects];
                                                             
                                                             [tempList removeAllObjects];
                                                         }
                                                         
                                                         [dataList addObjectsFromArray:result[@"Data"]];
                                                         
                                                         [tempList addObjectsFromArray:dataList];

                                                         [self didUpdateParentInfo];
                                                         
                                                         [tableView cellVisible];
                                                     }
                                                     else
                                                     {
                                                         [self showToast:@"Lỗi xảy ra, mời bạn thử lại" andPos:0];
                                                     }

                                                 }];
}

- (void)didReloadFilter:(NSString*)filter
{
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"(Ten contains[c] %@)", filter];
    
    [dataList removeAllObjects];
    
//    NSLog(@"%@", filter);
    
    if([filter isEqualToString:@""])
    {        
        [dataList addObjectsFromArray:tempList];
    }
    else
    {
        [dataList addObjectsFromArray:[tempList filteredArrayUsingPredicate:predicateString]];
    }
    
    [tableView cellVisible];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 59;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ((UILabel*)[self withView:header tag:10]).text = [NSString stringWithFormat:@"Loại %@", [info[@"type"] isEqualToString:@"0"] ? @"thịt" : [info[@"type"] isEqualToString:@"1"] ? @"thức ăn" : @"thuốc"];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? tableView.frame.size.height - 30 : 74;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty" : @"AP_Main_Cell" forIndexPath:indexPath];
    
    if(dataList.count == 0)
    {
        ((UILabel*)[self withView:cell tag:11]).text = @"Danh sách trống";
        
        return cell;
    }
    
    
    NSDictionary * dict = dataList[indexPath.row];

    
    
    ((UILabel*)[self withView:cell tag:10]).text = dict[@"Ten"];
    
    ((UILabel*)[self withView:cell tag:11]).text = [self formatString: [dict getValueFromKey: @"Gia"]];

    ((UILabel*)[self withView:cell tag:12]).text = [NSString stringWithFormat:@"%@", [self formatString: [dict getValueFromKey: @"GiaTu"]]];

    ((UILabel*)[self withView:cell tag:13]).text = [NSString stringWithFormat:@"%@", [self formatString: [dict getValueFromKey: @"GiaDen"]]];
    
    ((UILabel*)[self withView:cell tag:14]).text = [[[[[dict getValueFromKey: @"NgayApDung"] componentsSeparatedByString:@"T"] firstObject] dateWithFormat:@"yyyy-MM-dd"] stringWithFormat:@"dd.MM.yyyy"];
    
    return cell;
}

- (NSString *)formatString:(NSString *)string
{
    NSString *newString = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([newString length] == 0) {
        return nil;
    }
    
    // Check for illegal characters
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSRange charRange = [newString rangeOfCharacterFromSet:disallowedCharacters];
    if ( charRange.location != NSNotFound) {
        return nil;
    }
    
    // Split the string into the integer and decimal portions
    NSArray *numberArray = [newString componentsSeparatedByString:@"."];
    if ([numberArray count] > 2) {
        // There is more than one decimal point
        return nil;
    }
    
    // Get the integer
    NSString *integer           = [numberArray objectAtIndex:0];
    NSUInteger integerDigits    = [integer length];
    if (integerDigits == 0) {
        return nil;
    }
    
    // Format the integer.
    // You can do this by first converting to a number and then back to a string,
    // but I would rather keep it as a string instead of doing the double conversion.
    // If performance is critical, I would convert this to a C string to do the formatting.
    NSMutableString *formattedString = [[NSMutableString alloc] init];
    if (integerDigits < 4) {
        [formattedString appendString:integer];
    } else {
        // integer is 4 or more digits
        NSUInteger startingDigits = integerDigits % 3;
        if (startingDigits == 0) {
            startingDigits = 3;
        }
        [formattedString setString:[integer substringToIndex:startingDigits]];
        for (NSUInteger index = startingDigits; index < integerDigits; index = index + 3) {
            [formattedString appendFormat:@".%@", [integer substringWithRange:NSMakeRange(index, 3)]];
        }
    }
    
    // Add the decimal portion if there
    if ([numberArray count] == 2) {
        [formattedString appendString:@"."];
        NSString *decimal = [numberArray objectAtIndex:1];
        if ([decimal length] > 0) {
            [formattedString appendString:decimal];
        }
    }
    
    return formattedString;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 1 : dataList.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
