//
//  EM_MenuView.m
//  Emoticon
//
//  Created by thanhhaitran on 2/7/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "EM_MenuView.h"

@interface EM_MenuView ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray * dataList, * tempList;
    
    NSMutableArray * cityList, * provinceList, * wardList;
    
    NSMutableDictionary * extraInfo, * multiSection;
    
    NSTimer * timer;
    
    NSString * gName, * uName;
    
    NSMutableArray * years;
    
    NSString * fromPrice, * toPrice;
}

@end

@implementation EM_MenuView

@synthesize menuCompletion;

- (id)initWithChartMenu:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateChartMenuView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateChartMenuView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 463)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][4];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    contentView.tag = 2018;
    
    
    __block NSMutableDictionary *queryInfo = [NSMutableDictionary new];
    
    [queryInfo addEntriesFromDictionary:dict];
    
    if(![queryInfo responseForKey:@"fromDate"])
    {
        queryInfo[@"fromDate"] = [self nowDay];
    }
    
    if(![queryInfo responseForKey:@"toDate"])
    {
        queryInfo[@"toDate"] = [self nowDay];
    }
    
    DropButton * city = (DropButton*)[self withView:contentView tag:11];
    
    city.accessibilityLabel = @"1";
    
    DropButton * province = (DropButton*)[self withView:contentView tag:12];
    
    province.accessibilityLabel = @"2";

    DropButton * ward = (DropButton*)[self withView:contentView tag:14];
    
    ward.accessibilityLabel = @"3";

    
    DropButton * type = (DropButton*)[self withView:contentView tag:199];

    [type setTitle:[queryInfo[@"type"] isEqualToString:@"1"] ? @"Tỉnh thành" : [queryInfo[@"type"] isEqualToString:@"2"] ? @"Quận huyện" : @"Phường xã" forState:UIControlStateNormal];

    
    [type actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [type didDropDownWithData:@[@{@"Id":@"1", @"Ten":@"Tỉnh thành"}, @{@"Id":@"2", @"Ten":@"Quận huyện"}, @{@"Id":@"3", @"Ten":@"Phường xã"}] andCompletion:^(id object) {
            
            if(object)
            {
                [queryInfo removeObjectForKey:@"ids"];
                
                queryInfo[@"type"] = object[@"data"][@"Id"];
                
                [type setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                
                
                [queryInfo removeObjectForKey:@"cityId"];
                
                [queryInfo removeObjectForKey:@"provinceId"];

                [queryInfo removeObjectForKey:@"wardId"];
                
                
                
                
                [[ObjectInfo shareInstance] clearCityList:dict[@"dataType"]];
            
                [city setTitle:@"Chọn Tỉnh/thành phố" forState:UIControlStateNormal];
                
                
                
                [[ObjectInfo shareInstance] clearProvinceList:dict[@"dataType"]];

                [province setTitle:@"Chọn Quận/huyện" forState:UIControlStateNormal];
                
                
                
                [[ObjectInfo shareInstance] clearWardList:dict[@"dataType"]];

                [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                
                
                
                if([queryInfo[@"type"] isEqualToString:@"1"])
                {
                    ward.enabled = NO;
                    
                    province.enabled = NO;
                    
                    ward.backgroundColor = [UIColor lightGrayColor];
                    
                    province.backgroundColor = [UIColor lightGrayColor];
                }
                
                if([queryInfo[@"type"] isEqualToString:@"2"])
                {
                    ward.enabled = NO;
                    
                    province.enabled = YES;
                    
                    ward.backgroundColor = [UIColor lightGrayColor];

                    province.backgroundColor = [UIColor clearColor];
                }
                
                if([queryInfo[@"type"] isEqualToString:@"3"])
                {
                    ward.enabled = YES;
                    
                    province.enabled = YES;
                    
                    ward.backgroundColor = [UIColor clearColor];

                    province.backgroundColor = [UIColor clearColor];
                }
                
                self.menuCompletion(915, object, self);
            }
            
        }];
    }];
    

    
    if([queryInfo[@"type"] isEqualToString:@"1"])
    {
        ward.enabled = NO;
        province.enabled = NO;
        
        ward.backgroundColor = [UIColor lightGrayColor];
        province.backgroundColor = [UIColor lightGrayColor];
    }
    
    if([queryInfo[@"type"] isEqualToString:@"2"])
    {
        ward.enabled = NO;
        ward.backgroundColor = [UIColor lightGrayColor];
    }
    
    if([queryInfo[@"type"] isEqualToString:@"1"])
    {
        [city setTitle:([queryInfo responseForKey:@"names"] && ![queryInfo[@"names"] isEqualToString:@""]) ? queryInfo[@"names"] : @"Chọn Tỉnh/thành phố" forState:UIControlStateNormal];
    }
    
    if([queryInfo[@"type"] isEqualToString:@"2"])
    {
        [city setTitle:[queryInfo responseForKey:@"cityName"] ? queryInfo[@"cityName"] : @"Chọn Tỉnh/thành phố" forState:UIControlStateNormal];
        
        [province setTitle:([queryInfo responseForKey:@"names"] && ![queryInfo[@"names"] isEqualToString:@""]) ? queryInfo[@"names"] : @"Chọn Quận/huyện" forState:UIControlStateNormal];
    }
    
    if([queryInfo[@"type"] isEqualToString:@"3"])
    {
        [city setTitle:[queryInfo responseForKey:@"cityName"] ? queryInfo[@"cityName"] : @"Chọn Tỉnh/thành phố" forState:UIControlStateNormal];
        
        [province setTitle:[queryInfo responseForKey:@"provinceName"] ? queryInfo[@"provinceName"] : @"Chọn Quận/huyện" forState:UIControlStateNormal];
        
        [ward setTitle:([queryInfo responseForKey:@"names"] && ![queryInfo[@"names"] isEqualToString:@""]) ? queryInfo[@"names"] : @"Chọn Phường/xã" forState:UIControlStateNormal];
    }
    
    [city actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        if([[ObjectInfo shareInstance] cityList:dict[@"dataType"]].count == 0)
        {
            [[ObjectInfo shareInstance] didRequestCity:dict[@"dataType"] andHost:dict[@"host"]];

            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    if(![queryInfo[@"type"] isEqualToString:@"1"])
                    {
                        [city didDropDownWithData:[[ObjectInfo shareInstance] cityList:dict[@"dataType"]] andCompletion:^(id object) {
                            if(object)
                            {
                                [city setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                
                                queryInfo[@"cityId"] = object[@"data"][@"Id"];
                                
                                queryInfo[@"cityName"] = object[@"data"][@"Ten"];
                                
                                [[ObjectInfo shareInstance] clearProvinceList:dict[@"dataType"]];
                                
                                [province setTitle:@"Chọn Quận/huyện" forState:UIControlStateNormal];
                                
                                [[ObjectInfo shareInstance] clearWardList:dict[@"dataType"]];

                                [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                            }
                        }];
                    }
                    else
                    {
                        self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] cityList:dict[@"dataType"]], @"name":city}, self);
                    }
                }
                else
                {
                    [self showToast:@"Sự cố xảy ra, mời bạn thử lại sau" andPos:0];
                }
            };
        }
        else
        {
            if(![queryInfo[@"type"] isEqualToString:@"1"])
            {
                [city didDropDownWithData:[[ObjectInfo shareInstance] cityList:dict[@"dataType"]] andCompletion:^(id object) {
                    
                    if(object)
                    {
                        [city setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                        
                        queryInfo[@"cityId"] = object[@"data"][@"Id"];
                        
                        queryInfo[@"cityName"] = object[@"data"][@"Ten"];
                        
                        [[ObjectInfo shareInstance] clearProvinceList:dict[@"dataType"]];
                        
                        [province setTitle:@"Chọn Quận/huyện" forState:UIControlStateNormal];
                        
                        [[ObjectInfo shareInstance] clearWardList:dict[@"dataType"]];
                        
                        [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                        
                    }
                }];
            }
            else
            {                
                self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] cityList:dict[@"dataType"]], @"name":city}, self);
            }
        }
    }];
    
    
    
    [province actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(![queryInfo responseForKey:@"cityId"])
        {
            [self showToast:@"Bạn chưa chọn Tỉnh/thành phố" andPos:0];
            
            return;
        }
        
        if([[ObjectInfo shareInstance] provinceList:dict[@"dataType"]].count == 0)
        {
            [[ObjectInfo shareInstance] didRequestProvinceChart:[queryInfo getValueFromKey:@"cityId"] withType:dict[@"dataType"]];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    if(![queryInfo[@"type"] isEqualToString:@"2"])
                    {
                        [province didDropDownWithData:[[ObjectInfo shareInstance] provinceList:dict[@"dataType"]] andCompletion:^(id object) {
                            if(object)
                            {
                                [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                
                                queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                                
                                queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                                
                                [[ObjectInfo shareInstance] clearWardList:dict[@"dataType"]];
                                
                                [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                            }
                        }];
                    }
                    else
                    {
                        self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] provinceList:dict[@"dataType"]], @"name":province}, self);
                    }
                }
                else
                {
                    [self showToast:@"Sự cố xảy ra, mời bạn thử lại sau" andPos:0];
                }
            };
        }
        else
        {
            if(![queryInfo[@"type"] isEqualToString:@"2"])
            {
                [province didDropDownWithData:[[ObjectInfo shareInstance] provinceList:dict[@"dataType"]] andCompletion:^(id object) {
                    if(object)
                    {
                        [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                        
                        queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                        
                        queryInfo[@"provinceName"] = object[@"data"][@"Ten"];

                        [[ObjectInfo shareInstance] clearWardList:dict[@"dataType"]];
                        
                        [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                    }
                }];
            }
            else
            {
                self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] provinceList:dict[@"dataType"]], @"name":province}, self);
            }
        }
    }];
    
    
    
    
    
    [ward actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(![queryInfo responseForKey:@"provinceId"])
        {
            [self showToast:@"Bạn chưa chọn Quận/huyện" andPos:0];
            
            return;
        }
        
        if([[ObjectInfo shareInstance] wardList:dict[@"dataType"]].count == 0)
        {
            [[ObjectInfo shareInstance] didRequestWardChart:[queryInfo getValueFromKey:@"provinceId"] andType:dict[@"dataType"]];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] wardList:dict[@"dataType"]], @"name":ward}, self);
                }
                else
                {
                    [self showToast:@"Sự cố xảy ra, mời bạn thử lại sau" andPos:0];
                }
            };
        }
        else
        {
            self.menuCompletion(911, @{@"data":[[ObjectInfo shareInstance] wardList:dict[@"dataType"]], @"name":ward}, self);
        }
    }];
    
    
    
    
    UILabel * small = ((UILabel*)[self withView:contentView tag:20]);
    
    small.text = [queryInfo responseForKey:@"fromDate"] ? queryInfo[@"fromDate"] : [self nowDay];
    
    UILabel * big = ((UILabel*)[self withView:contentView tag:21]);
    
    big.text = [queryInfo responseForKey:@"toDate"] ? queryInfo[@"toDate"] : [self nowDay];

    
    
    UIButton * from = (UIButton*)[self withView:contentView tag:15];
    
    [from actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(0, @{@"dateTime":[small.text isEqualToString:[self nowDay]] ? [self nowDay] : small.text, @"obj":queryInfo}, self);
        
    }];
    
    
    UIButton * to = (UIButton*)[self withView:contentView tag:16];
    
    [to actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(1, @{@"dateTime":[big.text isEqualToString:[self nowDay]] ? [self nowDay] : big.text, @"obj":queryInfo}, self);
        
    }];
    
    
    
    UIButton * close = (UIButton*)[self withView:contentView tag:10];
    
    [close actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(199, queryInfo, self);
        
    }];
    
    
    UIButton * cancel = (UIButton*)[self withView:contentView tag:100];
    
    [cancel actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(200, queryInfo, self);
        
    }];
    

    [commentView addSubview:contentView];
    
    return commentView;
}





- (id)initWithMenu:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateMenuView:info]];
        
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateMenuView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 432)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][0];
    
    contentView.tag = 2018;
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);

    
    __block NSMutableDictionary *queryInfo = [NSMutableDictionary new];
    
    [queryInfo addEntriesFromDictionary:dict];
    
    if(![queryInfo responseForKey:@"fromDate"])
    {
        queryInfo[@"fromDate"] = [self nowDay];
    }
    
    if(![queryInfo responseForKey:@"toDate"])
    {
        queryInfo[@"toDate"] = [self nowDay];
    }
    
    DropButton * city = (DropButton*)[self withView:contentView tag:11];
    
    DropButton * province = (DropButton*)[self withView:contentView tag:12];

    DropButton * ward = (DropButton*)[self withView:contentView tag:14];


    if([queryInfo responseForKey:@"cityName"])
    {
        [city setTitle:queryInfo[@"cityName"] forState:UIControlStateNormal];
    }
    
    if([queryInfo responseForKey:@"provinceName"])
    {
        [province setTitle:queryInfo[@"provinceName"] forState:UIControlStateNormal];
    }
    
    if([queryInfo responseForKey:@"wardName"])
    {
        [ward setTitle:queryInfo[@"wardName"] forState:UIControlStateNormal];
    }
    
    [city actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        if([ObjectInfo shareInstance].cityList.count == 0)
        {
            [[ObjectInfo shareInstance] didRequestCity:dict[@"host"]];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [city didDropDownWithData:[ObjectInfo shareInstance].cityList andCompletion:^(id object) {
                        if(object)
                        {
                            [city setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            queryInfo[@"cityId"] = object[@"data"][@"Id"];
                            
                            queryInfo[@"cityName"] = object[@"data"][@"Ten"];
                            
                            
                            [[ObjectInfo shareInstance].provinceList removeAllObjects];
                            
                            [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                            
                            [province setTitle:@"Chọn Quận/huyện" forState:UIControlStateNormal];
                            
                            [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                            
                            
                            
                            [queryInfo removeObjectForKey:@"provinceName"];
                            
                            [queryInfo removeObjectForKey:@"provinceId"];

                            [queryInfo removeObjectForKey:@"wardName"];
                            
                            [queryInfo removeObjectForKey:@"wardId"];
                            
                            
                            
                            if([ObjectInfo shareInstance].provinceList.count == 0)
                            {
                                [[ObjectInfo shareInstance] didRequestProvince:[queryInfo getValueFromKey:@"cityId"]];
                                
                                [ObjectInfo shareInstance].state = ^(BOOL state) {
                                    
                                    if(state)
                                    {
                                        [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                                            if(object)
                                            {
                                                [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                
                                                queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                                                
                                                queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                                                
                                                [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                                                
                                                [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                                                
                                                [queryInfo removeObjectForKey:@"wardName"];
                                                
                                                [queryInfo removeObjectForKey:@"wardId"];
                                                
                                                if([ObjectInfo shareInstance].wardList1.count == 0)
                                                {
                                                    [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                                                    
                                                    [ObjectInfo shareInstance].state = ^(BOOL state) {
                                                        
                                                        if(state)
                                                        {
                                                            [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                                if(object)
                                                                {
                                                                    [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                                    
                                                                    queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                                    
                                                                    queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
                                                    [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                        if(object)
                                                        {
                                                            [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                            
                                                            queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                            
                                                            queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                                                        }
                                                    }];
                                                }
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
                                [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                                    if(object)
                                    {
                                        [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                        
                                        queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                                        
                                        queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                                        
                                        [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                                        
                                        [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];

                                        [queryInfo removeObjectForKey:@"wardName"];
                                        
                                        [queryInfo removeObjectForKey:@"wardId"];
                                        
                                        if([ObjectInfo shareInstance].wardList1.count == 0)
                                        {
                                            [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                                            
                                            [ObjectInfo shareInstance].state = ^(BOOL state) {
                                                
                                                if(state)
                                                {
                                                    [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                        if(object)
                                                        {
                                                            [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                            
                                                            queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                            
                                                            queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
                                            [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                if(object)
                                                {
                                                    [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                    
                                                    queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                    
                                                    queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                                                }
                                            }];
                                        }
                                    }
                                }];
                            }
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
            [city didDropDownWithData:[ObjectInfo shareInstance].cityList andCompletion:^(id object) {
                if(object)
                {
                    [city setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    queryInfo[@"cityId"] = object[@"data"][@"Id"];
                    
                    queryInfo[@"cityName"] = object[@"data"][@"Ten"];
                    
                    [[ObjectInfo shareInstance].provinceList removeAllObjects];
                    
                    [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                    
                    [province setTitle:@"Chọn Quận/huyện" forState:UIControlStateNormal];
                    
                    [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];
                    
                    [queryInfo removeObjectForKey:@"provinceName"];
                    
                    [queryInfo removeObjectForKey:@"provinceId"];
                    
                    [queryInfo removeObjectForKey:@"wardName"];
                    
                    [queryInfo removeObjectForKey:@"wardId"];
                    
                    if([ObjectInfo shareInstance].provinceList.count == 0)
                    {
                        [[ObjectInfo shareInstance] didRequestProvince:[queryInfo getValueFromKey:@"cityId"]];
                        
                        [ObjectInfo shareInstance].state = ^(BOOL state) {
                            
                            if(state)
                            {
                                [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                                    if(object)
                                    {
                                        [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                        
                                        queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                                        
                                        queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                                        
                                        [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                                        
                                        [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];

                                        [queryInfo removeObjectForKey:@"wardName"];
                                        
                                        [queryInfo removeObjectForKey:@"wardId"];
                                        
                                        if([ObjectInfo shareInstance].wardList1.count == 0)
                                        {
                                            [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                                            
                                            [ObjectInfo shareInstance].state = ^(BOOL state) {
                                                
                                                if(state)
                                                {
                                                    [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                        if(object)
                                                        {
                                                            [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                            
                                                            queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                            
                                                            queryInfo[@"wardName"] = object[@"data"][@"Name"];
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
                                            [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                if(object)
                                                {
                                                    [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                    
                                                    queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                    
                                                    queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                                                }
                                            }];
                                        }
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
                        [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                            if(object)
                            {
                                [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                
                                queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                                
                                queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                                
                                [[ObjectInfo shareInstance].wardList1 removeAllObjects];
                                
                                [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];

                                [queryInfo removeObjectForKey:@"wardName"];
                                
                                [queryInfo removeObjectForKey:@"wardId"];
                                
                                if([ObjectInfo shareInstance].wardList1.count == 0)
                                {
                                    [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                                    
                                    [ObjectInfo shareInstance].state = ^(BOOL state) {
                                        
                                        if(state)
                                        {
                                            [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                                if(object)
                                                {
                                                    [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                    
                                                    queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                    
                                                    queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
                                    [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                        if(object)
                                        {
                                            [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                            
                                            queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                            
                                            queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                                        }
                                    }];
                                }
                            }
                        }];
                    }
                }
            }];
        }
    }];
    
    
    
    

    [province actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(![queryInfo responseForKey:@"cityId"])
        {
            [self showToast:@"Bạn chưa chọn Tỉnh/thành phố" andPos:0];
            
            return;
        }
        
        if([ObjectInfo shareInstance].provinceList.count == 0)
        {
            [[ObjectInfo shareInstance] didRequestProvince:[queryInfo getValueFromKey:@"cityId"]];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                        if(object)
                        {
                            [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                            
                            queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                            
                            [[ObjectInfo shareInstance].wardList1 removeAllObjects];

                            [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];

                            [queryInfo removeObjectForKey:@"wardName"];
                            
                            [queryInfo removeObjectForKey:@"wardId"];
                            
                            if([ObjectInfo shareInstance].wardList1.count == 0)
                            {
                                [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                                
                                [ObjectInfo shareInstance].state = ^(BOOL state) {
                                    
                                    if(state)
                                    {
                                        [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                            if(object)
                                            {
                                                [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                                
                                                queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                                
                                                queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
                                [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                    if(object)
                                    {
                                        [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                        
                                        queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                        
                                        queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                                    }
                                }];
                            }
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
            [province didDropDownWithData:[ObjectInfo shareInstance].provinceList andCompletion:^(id object) {
                if(object)
                {
                    [province setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    queryInfo[@"provinceId"] = object[@"data"][@"Id"];
                    
                    queryInfo[@"provinceName"] = object[@"data"][@"Ten"];
                    
                    [[ObjectInfo shareInstance].wardList1 removeAllObjects];

                    [ward setTitle:@"Chọn Phường/xã" forState:UIControlStateNormal];

                    [queryInfo removeObjectForKey:@"wardName"];
                    
                    [queryInfo removeObjectForKey:@"wardId"];
                    
                    if([ObjectInfo shareInstance].wardList1.count == 0)
                    {
                        [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
                        
                        [ObjectInfo shareInstance].state = ^(BOOL state) {
                            
                            if(state)
                            {
                                [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                                    if(object)
                                    {
                                        [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                        
                                        queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                        
                                        queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
                        [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                            if(object)
                            {
                                [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                                
                                queryInfo[@"wardId"] = object[@"data"][@"Id"];
                                
                                queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                            }
                        }];
                    }
                }
            }];
        }
    }];
    
    
    
    

    [ward actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(![queryInfo responseForKey:@"provinceId"])
        {
            [self showToast:@"Bạn chưa chọn Quận/huyện" andPos:0];
            
            return;
        }
        
        if([ObjectInfo shareInstance].wardList1.count == 0)
        {
            [[ObjectInfo shareInstance] didRequestWard:[queryInfo getValueFromKey:@"provinceId"]];
            
            [ObjectInfo shareInstance].state = ^(BOOL state) {
                
                if(state)
                {
                    [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                        if(object)
                        {
                            [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                            
                            queryInfo[@"wardId"] = object[@"data"][@"Id"];
                            
                            queryInfo[@"wardName"] = object[@"data"][@"Ten"];
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
            [ward didDropDownWithData:[ObjectInfo shareInstance].wardList1 andCompletion:^(id object) {
                if(object)
                {
                    [ward setTitle:object[@"data"][@"Ten"] forState:UIControlStateNormal];
                    
                    queryInfo[@"wardId"] = object[@"data"][@"Id"];
                    
                    queryInfo[@"wardName"] = object[@"data"][@"Ten"];
                }
            }];
        }
    }];

    
    
    UILabel * small = ((UILabel*)[self withView:contentView tag:20]);
    
    small.text = [queryInfo responseForKey:@"fromDate"] ? queryInfo[@"fromDate"] : [self nowDay];

    UILabel * big = ((UILabel*)[self withView:contentView tag:21]);

    big.text = [queryInfo responseForKey:@"toDate"] ? queryInfo[@"toDate"] : [self nowDay];

    
    
    if(![queryInfo responseForKey:@"fromPrice"])
    {
        queryInfo[@"fromPrice"] = @"";
    }
    
    if(![queryInfo responseForKey:@"toPrice"])
    {
        queryInfo[@"toPrice"] = @"";
    }
    
    
    
    OSTextField * fromTxt = (OSTextField*)[self withView:contentView tag:17];
    
    fromTxt.text = [queryInfo responseForKey:@"fromPrice"] ? [self formatString: queryInfo[@"fromPrice"]] : @"";

    fromTxt.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    

    OSTextField * toTxt = (OSTextField*)[self withView:contentView tag:18];

    toTxt.text = [queryInfo responseForKey:@"toPrice"] ? [self formatString: queryInfo[@"toPrice"]] : @"";

    toTxt.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    
    
    [[CustomField shareText] didDeploytextWith1:^(int index, NSString *text) {
        
        //if(![[text stringByReplacingOccurrencesOfString:@"." withString:@""] isEqualToString:@""])
        {
            queryInfo[@"fromPrice"] = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        //else
        {
            //[queryInfo removeObjectForKey:@"fromPrice"];
        }
    
        if([[self strip: queryInfo[@"fromPrice"]] intValue] % 100 == 0 &&
           [[self strip: queryInfo[@"toPrice"]] intValue] % 100 == 0 &&
           [[self strip: queryInfo[@"fromPrice"]] intValue] >= [[self strip: queryInfo[@"toPrice"]] intValue])
        {
            if([[self strip: queryInfo[@"fromPrice"]] intValue] == [[self strip: queryInfo[@"toPrice"]] intValue])
            {
                ((UILabel*)[self withView:contentView tag:9999]).text = @"=";
            }
            if([[self strip: queryInfo[@"fromPrice"]] intValue] > [[self strip: queryInfo[@"toPrice"]] intValue])
            {
                ((UILabel*)[self withView:contentView tag:9999]).text = @">";
            }
            
            ((UILabel*)[self withView:contentView tag:9999]).alpha = 1;
        }
        else
        {
            ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
        }
        
        if([[queryInfo getValueFromKey:@"fromPrice"] isEqualToString:@""] || [[queryInfo getValueFromKey:@"toPrice"] isEqualToString:@""])
        {
            ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
        }
        
        
        [fromTxt withBorder:@{@"Bcolor": [[self strip:queryInfo[@"fromPrice"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:queryInfo[@"fromPrice"]] intValue] % 100 == 0) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];

    } withTextField:fromTxt];
    
    
    
    [[CustomField shareText] didDeploytextWith:^(int index, NSString *text) {

        //if(![[text stringByReplacingOccurrencesOfString:@"." withString:@""] isEqualToString:@""])
        {
            queryInfo[@"toPrice"] = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        //else
        {
            //[queryInfo removeObjectForKey:@"toPrice"];
        }
                
        if([[self strip: queryInfo[@"fromPrice"]] intValue] % 100 == 0 &&
           [[self strip: queryInfo[@"toPrice"]] intValue] % 100 == 0)
        {
            if([[self strip: queryInfo[@"fromPrice"]] intValue] >= [[self strip: queryInfo[@"toPrice"]] intValue])
            {
                if([[self strip: queryInfo[@"fromPrice"]] intValue] == [[self strip: queryInfo[@"toPrice"]] intValue])
                {
                    ((UILabel*)[self withView:contentView tag:9999]).text = @"=";
                }
                
                if([[self strip: queryInfo[@"fromPrice"]] intValue] > [[self strip: queryInfo[@"toPrice"]] intValue])
                {
                    ((UILabel*)[self withView:contentView tag:9999]).text = @">";
                }
                
                ((UILabel*)[self withView:contentView tag:9999]).alpha = 1;
            }
            else
            {
                ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
            }
        }
        else
        {
            ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
        }
        
        if([[queryInfo getValueFromKey:@"fromPrice"] isEqualToString:@""] || [[queryInfo getValueFromKey:@"toPrice"] isEqualToString:@""])
        {
            ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
        }
        
        [toTxt withBorder:@{@"Bcolor": [[self strip:queryInfo[@"toPrice"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:queryInfo[@"toPrice"]] intValue] % 100 == 0) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];
        
    } withTextField:toTxt];

    
    
    [fromTxt withBorder:@{@"Bcolor": [[self strip:queryInfo[@"fromPrice"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:queryInfo[@"fromPrice"]] intValue] % 100 == 0) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];
    
    [toTxt withBorder:@{@"Bcolor": [[self strip:queryInfo[@"toPrice"]] isEqualToString:@""] ? [UIColor blackColor] : ([[self strip:queryInfo[@"toPrice"]] intValue] % 100 == 0) ? [UIColor greenColor] : [UIColor redColor], @"Bwidth":@(2)}];
    
    
    if([[self strip: queryInfo[@"fromPrice"]] intValue] % 100 == 0 &&
       [[self strip: queryInfo[@"toPrice"]] intValue] % 100 == 0 &&
       [[self strip: queryInfo[@"fromPrice"]] intValue] >= [[self strip: dict[@"toPrice"]] intValue])
    {
        if([[self strip: queryInfo[@"fromPrice"]] intValue] == [[self strip: queryInfo[@"toPrice"]] intValue])
        {
            ((UILabel*)[self withView:contentView tag:9999]).text = @"=";
        }
        if([[self strip: queryInfo[@"fromPrice"]] intValue] > [[self strip: queryInfo[@"toPrice"]] intValue])
        {
            ((UILabel*)[self withView:contentView tag:9999]).text = @">";
        }
        
        ((UILabel*)[self withView:contentView tag:9999]).alpha = 1;
    }
    else
    {
        ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
    }
    
    if([[queryInfo getValueFromKey:@"fromPrice"] isEqualToString:@""] || [[queryInfo getValueFromKey:@"toPrice"] isEqualToString:@""])
    {
        ((UILabel*)[self withView:contentView tag:9999]).alpha = 0;
    }
    
    
    
    
    
    UIButton * from = (UIButton*)[self withView:contentView tag:15];
    
    [from actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(0, @{@"dateTime":[small.text isEqualToString:[self nowDay]] ? [self nowDay] : small.text, @"obj":queryInfo}, self);
        
        [fromTxt resignFirstResponder];

        [toTxt resignFirstResponder];
    }];
    
    
    UIButton * to = (UIButton*)[self withView:contentView tag:16];
    
    [to actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        self.menuCompletion(1, @{@"dateTime":[big.text isEqualToString:[self nowDay]] ? [self nowDay] : big.text, @"obj":queryInfo}, self);

        [fromTxt resignFirstResponder];
        
        [toTxt resignFirstResponder];
    }];

    
    
    UIButton * close = (UIButton*)[self withView:contentView tag:10];
    
    [close actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        [self close];
        
        self.menuCompletion(99, queryInfo, self);
        
    }];
    
    UIButton * cancel = (UIButton*)[self withView:contentView tag:25];
    
    [cancel actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        [self close];
        
    }];
    
    __block EM_MenuView * mySelf = (EM_MenuView*)self;
    
    self.state = ^(BOOL state) {
        
        [close setTitle:state ? @"Thoát" : @"Chọn" forState:UIControlStateNormal];
        
        cancel.hidden = state;
        
        if(state)
        {
            [close actionForTouch:@{} and:^(NSDictionary *touchInfo) {
                
                [fromTxt resignFirstResponder];
                
                [toTxt resignFirstResponder];
                
            }];
        }
        else
        {
            [close actionForTouch:@{} and:^(NSDictionary *touchInfo) {
                
                [mySelf close];
                
                mySelf.menuCompletion(99, queryInfo, mySelf);
            }];
        }
    };
    
    [commentView addSubview:contentView];
    
    return commentView;
}

- (NSString*)strip:(NSString*)text
{
    return [text stringByReplacingOccurrencesOfString:@"." withString:@""];
}

- (NSString *)formatString:(NSString *)string
{
    // Strip out the commas that may already be here:
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



- (id)initWithLayers:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateLayersView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (UIView*)didCreateLayersView:(NSDictionary*)dict
{
    if(dataList)
    {
        [dataList removeAllObjects];
        
        dataList = nil;
    }
    
    dataList = [[NSMutableArray alloc] initWithArray:dict[@"data"]];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 371)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView* contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][1];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    ((UILabel*)[self withView:contentView tag:1111]).text = [[dict getValueFromKey:@"type"] isEqualToString:@"1"] ? @"Chọn Tỉnh/thành phố" : [[dict getValueFromKey:@"type"] isEqualToString:@"2"] ? @"Chọn Quận/huyện" : @"Chọn Phường/xã";
    
    UITableView * tableView = (UITableView*)[self withView:contentView tag:11];
    
    [tableView withCell:@"E_Empty"];
    
    [tableView withCell:@"LayerCell"];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;

    
    [(UIButton*)[self withView:contentView tag:15] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
                
        self.menuCompletion(912, dataList, self);
        
    }];
    
    
    [commentView addSubview:contentView];
    
    [tableView reloadData];
    
    return commentView;
}

- (id)initWithDate:(NSDictionary*)info
{
    self = [self init];
    
    [self setContainerView:[self didCreateDateView:info]];
    
    [self setUseMotionEffects:true];
    
    return self;
}

- (NSDate *)getDateFromDateString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (UIView*)didCreateDateView:(NSDictionary*)dict
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 247)];
    
    [commentView withBorder:@{@"Bcolor":[UIColor whiteColor],@"Bcorner":@(5),@"Bwidth":@(0)}];
    
    UIView* contentView = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:self options:nil][3];
    
    contentView.frame = CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height);
    
    UIDatePicker * datePicker = ((UIDatePicker*)[self withView:contentView tag:11]);

    
    if([dict responseForKey:@"date"])
    {
        [datePicker setDate:[self getDateFromDateString:dict[@"date"]] animated:YES];
    }

    ((UILabel*)[self withView:contentView tag:111]).text = [dict getValueFromKey: @"title"];
    
    
    
    [(UIButton*)[self withView:contentView tag:14] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [self close];
    }];
    
    
    
    [(UIButton*)[self withView:contentView tag:15] actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        
        if(self.menuCompletion)
        {            
            self.menuCompletion(0, @{@"date":[datePicker.date stringWithFormat:@"dd.MM.yyyy"], @"picker":datePicker}, self);
        }
        
    }];
    
    
    
    [commentView addSubview:contentView];
    
    return commentView;
}

- (EM_MenuView*)showWithCompletionDisable:(MenuCompletion)_completion 
{
    menuCompletion = _completion;
    
    [self show:NO];
    
    id tableView = [self withView:self tag:11];
    
    if([tableView isKindOfClass:[UITableView class]])
    {
        [self performSelector:@selector(didScroll:) withObject:tableView afterDelay:0.3];
    }
    
    return self;
}

- (EM_MenuView*)showWithCompletion:(MenuCompletion)_completion
{
    menuCompletion = _completion;
    
    [self show];
    
    id tableView = [self withView:self tag:11];

    if([tableView isKindOfClass:[UITableView class]])
    {
        [self performSelector:@selector(didScroll:) withObject:tableView afterDelay:0.3];
    }
    
    return self;
}

- (void)didScroll:(UITableView*)tableView
{
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[extraInfo[@"active"] intValue] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)close
{
    [super close];
    
    if(timer)
    {
        [timer invalidate];
        
        timer = nil;
    }
    
    self.menuCompletion(99, nil, self);
    
    self.state = nil;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [years count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [years objectAtIndex:row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? tableView.frame.size.height : tableView.tag == 11 ? 44 : 60;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty_Music" : @"LayerCell" forIndexPath:indexPath];
    
//    if(!cell)
//    {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:nil options:nil][2];
//    }

    if(dataList.count == 0)
    {
        ((UILabel*)[self withView:cell tag:11]).text = @"Danh sách trống";

        return cell;
    }
    
    NSDictionary * dict = dataList[indexPath.row];
    
    [(UILabel*)[self withView:cell tag:11] setText:dict[@"Ten"]];
    
    cell.accessoryType = [dict[@"active"] intValue] == 0 ? UITableViewCellAccessoryNone :  UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        return;
    }

    NSMutableDictionary * dict = dataList[indexPath.row];

    dict[@"active"] = [dict[@"active"] intValue] == 0 ? @"1" : @"0";
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 0 : dataList.count;
}

@end
