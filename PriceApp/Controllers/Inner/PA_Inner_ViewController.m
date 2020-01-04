//
//  PA_Inner_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/11/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "PA_Inner_ViewController.h"

#import "AP_Price_ViewController.h"

#import "CustomField.h"

@interface PA_Inner_ViewController ()
{
    IBOutlet NSLayoutConstraint * topBar, * bottomBar, * spaceBar;
    
    IBOutlet UITableView * tableView;
    
    IBOutlet UIView * footer;
    
    NSMutableArray * dataList, * medList;
    
    NSString * tempMedId, * tempId;
    
    IBOutlet UIButton * escape, * update;
    
    IBOutlet DropButton * medType;
    
    BOOL isOn, isUp;
}

@end

@implementation PA_Inner_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];

    tempMedId = @"";

    medList = [@[] mutableCopy];
    
    topBar.constant = [info responseForKey:@"top"] ? 48 : 0;
    
    bottomBar.constant = 0;
    
    spaceBar.constant = -50;
    
    [tableView withCell:@"E_Empty"];

    [tableView withCell:@"AP_Price_Cell"];
    
    dataList = [@[] mutableCopy];
    
    [self didRequestForMedType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tableView.estimatedRowHeight = 159;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:@selector(didChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    if(![tempId isEqualToString:[self parentPetId]] && [self parentPetId])
    {
        [self didRequestForType:[self parentPetId]];
    }
}

- (IBAction)disMiss
{
    CGRect rect =  [self parentController].view.frame;
    
    rect.origin.y = 0;
    
    [self parentController].view.frame = rect;
    
    isOn = YES;
    
    [self didDisable:NO];
    
    [self.view endEditing:YES];
}

- (void)didChangeFrame:(NSNotification *)notification
{
    if(isUp)
        return;
    
    if(!isOn)
    {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        CGRect rect =  self.parentViewController.parentViewController.view.frame;
        
        rect.origin.y -= keyboardSize.height;
        
        [self parentController].view.frame = rect;
        
        [self didDisable:YES];
    }
}

- (AP_Price_ViewController*)parentController
{
    return self.parentViewController.parentViewController;
}

- (void)didHide:(NSNotification *)notification
{
    isOn = NO;
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
    
    medType.userInteractionEnabled = !isUp;
    
    escape.hidden = !isDisable;
    
    update.hidden = isDisable;
    
    bottomBar.constant = isDisable ? 40 : 0;
    
    spaceBar.constant = !isDisable ? -50 : 0;
    
    [(AP_Price_ViewController*)self.parentViewController.parentViewController disableTabView:isDisable];
}

- (NSString*)parentPetId
{
    return [(AP_Price_ViewController*)self.parentViewController.parentViewController monsterId];
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

- (void)didRequestForType:(NSString*)petId
{
    switch([info[@"type"] intValue])
    {
        case 0:
        {
            [self didRequestForMeatList:petId];
        }
            break;
        case 1:
        {
            [self didRequestForFoodList:petId];
        }
            break;
        case 2:
        {
            [self didRequestForMedList:petId];
        }
            break;
    }
}

- (NSMutableArray*)reformatData:(NSArray*)input
{
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[input arrayWithMutable]];
    
    for(NSMutableDictionary * dict in arr)
    {
        dict[@"from"] = @"";
        
        dict[@"to"] = @"";
        
        dict[@"pass"] = @"";
    }
    
    return arr;
}

- (BOOL)isValidPrice
{
    BOOL valid = NO;
    
    for(NSDictionary * dict in dataList)
    {
//        if([dict[@"from"] isEqualToString:@""] || [dict[@"to"] isEqualToString:@""])
//        {
//            continue;
//        }
//
//        if([[dict[@"from"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue] >= 100 && [[dict[@"to"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue] >= 100)
//        {
//            valid = YES;
//
//            break;
//        }
        
        if([dict[@"pass"] isEqualToString:@"1"])
        {
            valid = YES;
            
            break;
        }
    }
    
    return valid;
}

- (BOOL)isValidated
{
    BOOL valid = NO;
    
    for(NSDictionary * dict in dataList)
    {
        if(![dict[@"from"] isEqualToString:@""] && ![dict[@"to"] isEqualToString:@""])
        {
            valid = YES;
            
            break;
        }
    }
    
    return valid;
}

- (void)didRequestForUpdate
{
    if(![[self parentController] wardId] || ![[self parentController] dateTime])
    {
        [self showToast:@"Bạn chưa chọn Phường/xã" andPos:0];
        
        return;
    }
    
    if(![self isValidated])
    {
        [self showToast:@"Bạn nhập đủ giá đầu và giá cuối của ít nhất 01 loại" andPos:0];
        
        return;
    }
    
    if(![self isValidPrice])
    {
        [self showToast:@"Giá đầu và giá cuối chưa hợp lệ" andPos:0];
        
        return;
    }
    
    NSString * type = [info[@"type"] isEqualToString:@"0"] ? @"ThitId" : [info[@"type"] isEqualToString:@"1"] ? @"ThucAnId" : @"ThuocId";
    
    NSString * sendType = [info[@"type"] isEqualToString:@"0"] ? @"CapNhatGiaThits" : [info[@"type"] isEqualToString:@"1"] ? @"CapNhatGiaThucAns" : @"CapNhatGiaThuocs";

    
    NSMutableArray * arr = [NSMutableArray new];
    
    NSDictionary * uInfo = [ObjectInfo shareInstance].uInfo[@"Account"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    NSDate *now = [[self parentController].dateTime dateWithFormat:@"dd.MM.yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:now];
    
    for(NSDictionary * dict in dataList)
    {
        if(([dict[@"from"] isEqualToString:@""] || [dict[@"to"] isEqualToString:@""]) || ([[dict[@"from"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue] < 100 || [[dict[@"to"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue] < 100))
        {
            continue;
        }
        
        NSDictionary * obj  = @{type:@([[dict getValueFromKey:@"Id"] intValue]),
                                @"Id":@(0),
                                @"NgayApDung":formattedDateString,
                                @"TinhThanhId":@([uInfo[@"TinhThanhId"] intValue]),
                                @"QuanHuyenId":@([uInfo[@"QuanHuyenId"] intValue]),
                                @"XaPhuongId":@([[self parentController].wardId intValue]),
                                @"GiaTu":@([[dict[@"from"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue]),
                                @"GiaDen":@([[dict[@"to"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue])
                                };
        [arr addObject:obj];
    }
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"CMD":[NSString stringWithFormat:@"/gia/%@", sendType],
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"arr":arr,
                                                 @"overrideAlert":@(1),
                                                 @"host":self,
                                                 @"overrideLoading":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [self showToast:@"Cập nhật thành công" andPos:0];
                                                         
                                                         for(NSMutableDictionary * dict in dataList)
                                                         {
                                                             dict[@"from"] = @"";
                                                             
                                                             dict[@"to"] = @"";
                                                         }
                                                         
                                                         [tableView reloadData];
                                                     }
                                                     else
                                                     {
                                                         [self showToast:@"Lỗi xảy ra, mời bạn thử lại" andPos:0];
                                                     }
                                                     
                                                 }];
}

- (void)didRequestForMeatList:(NSString*)petId
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];

    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThit", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"vatnuoiId":@([petId intValue])},
                                                 @"overrideAlert":@(1),
                                                 @"host":self,
                                                 @"overrideLoading":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [dataList removeAllObjects];

                                                         [dataList addObjectsFromArray:[self reformatData:[responseString objectFromJSONString][@"array"]]];
                                                         
                                                         tempId = petId;
                                                         
                                                         [tableView reloadData];
                                                     }
                                                }];
}

- (void)didRequestForFoodList:(NSString*)petId
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThucAn", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"vatnuoiId":@([petId intValue])},
                                                 @"overrideAlert":@(1),
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [dataList removeAllObjects];
                                                         
                                                         [dataList addObjectsFromArray:[self reformatData:[responseString objectFromJSONString][@"array"]]];

                                                         tempId = petId;
                                                         
                                                         [tableView reloadData];
                                                     }
                                                 }];
}

- (void)didRequestForMedList:(NSString*)medId
{
    if([tempMedId isEqualToString:@""])
    {
        return;
    }
    
    if(![self parentController].monsterId)
    {
        return;
    }
    
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThuoc", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"vatnuoiId":@([[self parentPetId] intValue]),
                                                               @"loaithuocId":@([tempMedId intValue])},
                                                 @"overrideAlert":@(1),
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [dataList removeAllObjects];
                                                         
                                                         [dataList addObjectsFromArray:[self reformatData:[responseString objectFromJSONString][@"array"]]];

                                                         tempId = [self parentPetId];
                                                         
                                                         [tableView cellVisible];
                                                     }
                                                 }];
}

- (void)didRequestForMedType
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachLoaiThuoc", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1),
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [medList removeAllObjects];
                                                         
                                                         [medList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                 }];
}

- (IBAction)didPressUpdate:(id)sender
{
    [self didRequestForUpdate];
}

- (IBAction)didPressMedType:(DropButton*)sender
{
    if(medList.count == 0)
    {
        NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
        
        [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachLoaiThuoc", infoPlist[@"host"]],
                                                     @"method":@"GET",
                                                     @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                     @"overrideAlert":@(1),
                                                     @"host":self,
                                                     @"overrideLoading":@(1)
                                                     } withCache:^(NSString *cacheString) {
                                                         
                                                     } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                         if([errorCode isEqualToString:@"200"])
                                                         {
                                                             [medList removeAllObjects];
                                                             
                                                             [medList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                             
                                                             [sender didDropDownWithData:medList andCompletion:^(id object) {
                                                                 if(object)
                                                                 {
                                                                     [sender setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                                     
                                                                     tempMedId = [object[@"data"] getValueFromKey:@"Id"];
                                                                     
                                                                     [self didRequestForMedList: tempMedId];
                                                                 }
                                                             }];
                                                         }
                                                     }];
    }
    else
    {
        [sender didDropDownWithData:medList andCompletion:^(id object) {
            if(object)
            {
                [sender setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                
                tempMedId = [object[@"data"] getValueFromKey:@"Id"];
                
                [self didRequestForMedList: tempMedId];
            }
        }];
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return dataList.count == 0 ? -1 :  40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? tableView.frame.size.height : UITableViewAutomaticDimension;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty" : @"AP_Price_Cell" forIndexPath:indexPath];
    
    if(dataList.count == 0)
    {
        ((UILabel*)[self withView:cell tag:11]).text = @"Danh sách trống";
        
        return cell;
    }
    
    NSDictionary * dict = dataList[indexPath.row];
    
    
    OSTextField * from = ((OSTextField*)[self withView:cell tag:11]);
    
    from.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    OSTextField * to = ((OSTextField*)[self withView:cell tag:12]);

    to.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    
    [from withBorder:@{@"Bcolor": [[self strip:dict[@"from"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:dict[@"from"]] intValue] % 100 == 0/* && [[self strip:dict[@"from"]] intValue] < [[self strip:dict[@"to"]] intValue]*/) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];

    [to withBorder:@{@"Bcolor": [[self strip:dict[@"to"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:dict[@"to"]] intValue] % 100 == 0 /*&& [[self strip:dict[@"from"]] intValue] < [[self strip:dict[@"to"]] intValue]*/) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];

    
    if([[self strip: dict[@"from"]] intValue] % 100 == 0 &&
       [[self strip: dict[@"to"]] intValue] % 100 == 0 &&
       [[self strip: dict[@"from"]] intValue] >= [[self strip: dict[@"to"]] intValue])
    {
        if([[self strip: dict[@"from"]] intValue] == [[self strip: dict[@"to"]] intValue])
        {
            ((UILabel*)[self withView:cell tag:9999]).text = @"=";
        }
        if([[self strip: dict[@"from"]] intValue] > [[self strip: dict[@"to"]] intValue])
        {
            ((UILabel*)[self withView:cell tag:9999]).text = @">";
        }
        
        ((UILabel*)[self withView:cell tag:9999]).alpha = 1;
    }
    else
    {
        ((UILabel*)[self withView:cell tag:9999]).alpha = 0;
    }
    
    if([[dict getValueFromKey:@"from"] isEqualToString:@""] || [[dict getValueFromKey:@"to"] isEqualToString:@""])
    {
        ((UILabel*)[self withView:cell tag:9999]).alpha = 0;
    }
    
    from.accessibilityLabel = [@{@"Id":[dict getValueFromKey:@"Id"], @"index":@(indexPath.row)} JSONString];
    
    to.accessibilityLabel = [@{@"Id":[dict getValueFromKey:@"Id"], @"index":@(indexPath.row)} JSONString];
    

    [from addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [to addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    ((UIView*)[self withView:cell tag:999]).hidden = indexPath.row != dataList.count - 1;

    
    from.text = dict[@"from"];
    
    to.text = dict[@"to"];

    
    
    ((UILabel*)[self withView:cell tag:10]).text = dict[@"Ten"];

    
    ((UILabel*)[self withView:cell tag:14]).text = [NSString stringWithFormat:@"VNĐ/%@", dict[@"DonVi"]];

    return cell;
}

- (NSString*)strip:(NSString*)text
{
    return [text stringByReplacingOccurrencesOfString:@"." withString:@""];
}

- (void)didModifyData:(UITextField*)textField//:(int)tag andContent:(NSString*)content andId:(NSString*)info
{
    NSString * content = textField.text;
    
    NSString * iD = [textField.accessibilityLabel objectFromJSONString][@"Id"];
    
    int indexing = [[textField.accessibilityLabel objectFromJSONString][@"index"] intValue];
    
    int tag = (int)textField.tag;

    for(NSMutableDictionary* dict in dataList)
    {
        if([[dict getValueFromKey:@"Id"] isEqualToString:iD])
        {
            dict[tag == 11 ? @"from" : @"to"] = content;
            
            if([[self strip: dict[@"from"]] intValue] % 100 == 0 &&
               [[self strip: dict[@"to"]] intValue] % 100 == 0 &&
               [[self strip: dict[@"from"]] intValue] < [[self strip: dict[@"to"]] intValue])
            {
                dict[@"pass"] = @"1";
            }
            else
            {
                dict[@"pass"] = @"";
            }
            
            if([[self strip: dict[@"from"]] intValue] % 100 == 0 &&
               [[self strip: dict[@"to"]] intValue] % 100 == 0 &&
               [[self strip: dict[@"from"]] intValue] >= [[self strip: dict[@"to"]] intValue])
            {
                if([[self strip: dict[@"from"]] intValue] == [[self strip: dict[@"to"]] intValue])
                {
                    ((UILabel*)[self textFieldTag:textField andTag:9999]).text = @"=";
                }
                if([[self strip: dict[@"from"]] intValue] > [[self strip: dict[@"to"]] intValue])
                {
                    ((UILabel*)[self textFieldTag:textField andTag:9999]).text = @">";
                }
                
                ((UILabel*)[self textFieldTag:textField andTag:9999]).alpha = 1;
            }
            else
            {
                ((UILabel*)[self textFieldTag:textField andTag:9999]).alpha = 0;
            }
            
            if([[dict getValueFromKey:@"from"] isEqualToString:@""] || [[dict getValueFromKey:@"to"] isEqualToString:@""])
            {
                ((UILabel*)[self textFieldTag:textField andTag:9999]).alpha = 0;
            }
            
        }
    }
        
    [textField withBorder:@{@"Bcolor": [[self strip:content] isEqualToString:@""] ? [UIColor blackColor] : [[self strip:content] intValue] % 100 == 0 ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString * temp = textField.text;
    
    textField.text = [self formatString:temp];
    
    [self didModifyData:textField];//textField.tag andContent:textField.text andId:textField.accessibilityLabel];
}

- (id)textFieldTag:(UITextField*)txt andTag:(int)tag
{
    for(UIView * v in txt.superview.subviews)
    {
        if([v isKindOfClass:[UILabel class]] && v.tag == tag)
        {
            return v;
        }
    }
    
    return nil;
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
