//
//  Object.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/12/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "ObjectInfo.h"

static ObjectInfo * shareInstan = nil;

@implementation ObjectInfo

@synthesize token, uInfo, tiles, state;

@synthesize cityList, cityList2, cityList3, wardList, wardList1, provinceList, petList, provinceList1, provinceList2, provinceList3, wardList2, wardList3, wardList4, cityList1, medList, meatList, foodList;

+ (ObjectInfo*)shareInstance
{
    if(!shareInstan)
    {
        shareInstan = [ObjectInfo new];
    }
    
    return shareInstan;
}

- (void)clearDataChart
{
    [cityList1 removeAllObjects];
    
    [cityList2 removeAllObjects];

    [cityList3 removeAllObjects];

    
    [provinceList1 removeAllObjects];
    
    [provinceList2 removeAllObjects];

    [provinceList3 removeAllObjects];

    
    [wardList2 removeAllObjects];
    
    [wardList3 removeAllObjects];

    [wardList4 removeAllObjects];
}

- (void)didRequestForAll
{
    if(!cityList)
    {
        cityList = [@[] mutableCopy];
    }
    else
    {
        [cityList removeAllObjects];
    }

    if(!cityList2)
    {
        cityList2 = [@[] mutableCopy];
    }
    else
    {
        [cityList2 removeAllObjects];
    }
    
    if(!cityList3)
    {
        cityList3 = [@[] mutableCopy];
    }
    else
    {
        [cityList3 removeAllObjects];
    }

    if(!cityList1)
    {
        cityList1 = [@[] mutableCopy];
    }
    else
    {
        [cityList1 removeAllObjects];
    }
    
    if(!provinceList)
    {
        provinceList = [@[] mutableCopy];
    }
    else
    {
        [provinceList removeAllObjects];
    }

    if(!wardList)
    {
        wardList = [@[] mutableCopy];
    }
    else
    {
        [wardList removeAllObjects];
    }
    
    if(!wardList1)
    {
        wardList1 = [@[] mutableCopy];
    }
    else
    {
        [wardList1 removeAllObjects];
    }
    
    if(!petList)
    {
        petList = [@[] mutableCopy];
    }
    else
    {
        [petList removeAllObjects];
    }
    
    
    
    
    if(!provinceList1)
    {
        provinceList1 = [@[] mutableCopy];
    }
    else
    {
        [provinceList1 removeAllObjects];
    }
    
    if(!provinceList2)
    {
        provinceList2 = [@[] mutableCopy];
    }
    else
    {
        [provinceList2 removeAllObjects];
    }
    
    if(!provinceList3)
    {
        provinceList3 = [@[] mutableCopy];
    }
    else
    {
        [provinceList3 removeAllObjects];
    }
    
    
    
    
    if(!wardList2)
    {
        wardList2 = [@[] mutableCopy];
    }
    else
    {
        [wardList2 removeAllObjects];
    }
    
    if(!wardList3)
    {
        wardList3 = [@[] mutableCopy];
    }
    else
    {
        [wardList3 removeAllObjects];
    }
    
    if(!wardList4)
    {
        wardList4 = [@[] mutableCopy];
    }
    else
    {
        [wardList4 removeAllObjects];
    }
    
    
    
    
    if(!meatList)
    {
        meatList = [@[] mutableCopy];
    }
    else
    {
        [meatList removeAllObjects];
    }
    
    if(!medList)
    {
        medList = [@[] mutableCopy];
    }
    else
    {
        [medList removeAllObjects];
    }
    
    if(!foodList)
    {
        foodList = [@[] mutableCopy];
    }
    else
    {
        [foodList removeAllObjects];
    }
    
    [self didRequestCity:[NSNull null]];
    
    [self didRequestWard];
    
    [self didRequestForPet];
    
    [self didRequestForMeatList];

    [self didRequestForFoodList];

    [self didRequestForMedList];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)didRequestForMeatList
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThit", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [meatList removeAllObjects];
                                                         
                                                         [meatList addObjectsFromArray:[cacheString objectFromJSONString][@"array"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [meatList removeAllObjects];
                                                                                                                  
                                                         [meatList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                 }];
}

- (void)didRequestForFoodList
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThucAn", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [foodList removeAllObjects];
                                                         
                                                         [foodList addObjectsFromArray:[cacheString objectFromJSONString][@"array"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [foodList removeAllObjects];
                                                         
                                                         [foodList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                 }];
}

- (void)didRequestForMedList
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachThuoc", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [medList removeAllObjects];
                                                         
                                                         [medList addObjectsFromArray:[cacheString objectFromJSONString][@"array"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [medList removeAllObjects];
                         
                                                         [medList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                 }];
}

- (void)didRequestCity:(NSString*)type andHost:(id)host
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachTinh", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":host
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                     if(cacheString)
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [cityList1 removeAllObjects];
                                                             
                                                             [cityList1 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"array"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [cityList2 removeAllObjects];
                                                             
                                                             [cityList2 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"array"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [cityList3 removeAllObjects];
                                                             
                                                             [cityList3 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"array"]]];
                                                         }
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [cityList1 removeAllObjects];
                                                             
                                                             [cityList1 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"array"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [cityList2 removeAllObjects];
                                                             
                                                             [cityList2 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"array"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [cityList3 removeAllObjects];
                                                             
                                                             [cityList3 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"array"]]];
                                                         }
                                                     }
                                                     
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (void)didRequestCity:(id)host
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachTinh", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":host
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [cityList removeAllObjects];
                                                         
                                                         [cityList addObjectsFromArray:[cacheString objectFromJSONString][@"array"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [cityList removeAllObjects];
                                                         
                                                         [cityList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (void)didRequestProvince:(NSString*)provinceId
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachQuanHuyen", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"tinhthanhId":@([provinceId intValue])},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":[self topMostController]
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [provinceList removeAllObjects];
                                                         
                                                         [provinceList addObjectsFromArray:[cacheString objectFromJSONString][@"Data"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [provinceList removeAllObjects];
                                                         
                                                         [provinceList addObjectsFromArray:[responseString objectFromJSONString][@"Data"]];
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (void)didRequestWard:(NSString*)wardId
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
        
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachXaPhuong", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"quanhuyenId":@([wardId intValue])},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":[self topMostController]
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [wardList1 removeAllObjects];
                                                         
                                                         [wardList1 addObjectsFromArray:[cacheString objectFromJSONString][@"Data"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [wardList1 removeAllObjects];
                                                         
                                                         [wardList1 addObjectsFromArray:[responseString objectFromJSONString][@"Data"]];
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (void)didRequestWard
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    NSDictionary * uInfo = [ObjectInfo shareInstance].uInfo[@"Account"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachXaPhuong", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"quanhuyenId":@([[uInfo getValueFromKey:@"QuanHuyenId"] intValue])},
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [wardList removeAllObjects];
                                                         
                                                         [wardList addObjectsFromArray:[cacheString objectFromJSONString][@"Data"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [wardList removeAllObjects];
                                                         
                                                         [wardList addObjectsFromArray:[responseString objectFromJSONString][@"Data"]];
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (void)didRequestForPet
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/danhmuc/DanhSachVatNuoi", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         [petList removeAllObjects];
                                                         
                                                         [petList addObjectsFromArray:[cacheString objectFromJSONString][@"array"]];
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [petList removeAllObjects];
                                                         
                                                         [petList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
                                                     }
                                                     
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}


- (NSMutableArray*)cityList:(NSString*)type
{
    return [type isEqualToString:@"1"] ? cityList1 : [type isEqualToString:@"2"] ? cityList2 : cityList3;
}

- (NSMutableArray*)provinceList:(NSString*)type
{
    return [type isEqualToString:@"1"] ? provinceList1 : [type isEqualToString:@"2"] ? provinceList2 : provinceList3;
}

- (NSMutableArray*)wardList:(NSString*)type
{
    return [type isEqualToString:@"1"] ? wardList2 : [type isEqualToString:@"2"] ? wardList3 : wardList4;
}



- (void)clearCityList:(NSString*)type
{
    [[self cityList:type] removeAllObjects];
}

- (void)clearProvinceList:(NSString*)type
{
    [[self provinceList:type] removeAllObjects];
}

- (void)clearWardList:(NSString*)type
{
    [[self wardList:type] removeAllObjects];
}


- (void)didRequestProvinceChart:(NSString*)provinceId withType:(NSString*)type
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachQuanHuyen", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"tinhthanhId":@([provinceId intValue])},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":[self topMostController]
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [provinceList1 removeAllObjects];
                                                             
                                                             [provinceList1 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [provinceList2 removeAllObjects];
                                                             
                                                             [provinceList2 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [provinceList3 removeAllObjects];
                                                             
                                                             [provinceList3 addObjectsFromArray:[self didReformatData:[cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [provinceList1 removeAllObjects];
                                                             
                                                             [provinceList1 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [provinceList2 removeAllObjects];
                                                             
                                                             [provinceList2 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [provinceList3 removeAllObjects];
                                                             
                                                             [provinceList3 addObjectsFromArray:[self didReformatData:[responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}

- (NSMutableArray*)didReformatData:(NSArray*)results
{
    NSMutableArray * arr = [NSMutableArray new];
    
    for(NSDictionary * dict in results)
    {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc] initWithDictionary:dict];
        
        temp[@"active"] = @"0";
        
        [arr addObject:temp];
    }
    
    return arr;
}

- (void)didRequestWardChart:(NSString*)wardId andType:(NSString*)type
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/diadiem/DanhSachXaPhuong", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                                 @"Getparam":@{@"quanhuyenId":@([wardId intValue])},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":[self topMostController]
                                                 } withCache:^(NSString *cacheString) {
                                                     if(cacheString)
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [wardList2 removeAllObjects];
                                                             
                                                             [wardList2 addObjectsFromArray:[self didReformatData: [cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [wardList3 removeAllObjects];
                                                             
                                                             [wardList3 addObjectsFromArray:[self didReformatData: [cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [wardList4 removeAllObjects];
                                                             
                                                             [wardList4 addObjectsFromArray:[self didReformatData: [cacheString objectFromJSONString][@"Data"]]];
                                                         }
                                                     }
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         if([type isEqualToString:@"1"])
                                                         {
                                                             [wardList2 removeAllObjects];
                                                             
                                                             [wardList2 addObjectsFromArray:[self didReformatData: [responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"2"])
                                                         {
                                                             [wardList3 removeAllObjects];
                                                             
                                                             [wardList3 addObjectsFromArray:[self didReformatData: [responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                         
                                                         if([type isEqualToString:@"3"])
                                                         {
                                                             [wardList4 removeAllObjects];
                                                             
                                                             [wardList4 addObjectsFromArray:[self didReformatData: [responseString objectFromJSONString][@"Data"]]];
                                                         }
                                                     }
                                                     if(self.state)
                                                     {
                                                         self.state([errorCode isEqualToString:@"200"]);
                                                     }
                                                 }];
}


@end
