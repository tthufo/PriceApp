//
//  Object.h
//  MapApp
//
//  Created by Thanh Hai Tran on 4/12/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ObjectInfoCompletion)(BOOL state);

@interface ObjectInfo : NSObject

+ (ObjectInfo*)shareInstance;

@property(nonatomic, retain) NSString * token;

@property(nonatomic, retain) NSMutableDictionary * uInfo;

@property(nonatomic, retain) NSArray * tiles;

@property(nonatomic, retain) NSMutableArray * cityList3, * cityList2, * cityList1, * cityList, * provinceList, * provinceList1, * provinceList2 , * provinceList3, * wardList2, * wardList3, * wardList4, * wardList, * wardList1, * petList, * medList, * meatList, * foodList;

@property (nonatomic,copy) ObjectInfoCompletion state;

- (void)didRequestForAll;

- (void)didRequestForPet;

- (void)didRequestCity:(id)host;

- (void)didRequestCity:(NSString*)type andHost:(id)host;

- (void)didRequestWard;

- (void)didRequestWard:(NSString*)wardId;

- (void)didRequestProvince:(NSString*)provinceId;

- (void)clearDataChart;

- (void)didRequestWardChart:(NSString*)wardId andType:(NSString*)type;

- (void)didRequestProvinceChart:(NSString*)provinceId withType:(NSString*)type;



- (NSMutableArray*)provinceList:(NSString*)type;

- (NSMutableArray*)cityList:(NSString*)type;

- (NSMutableArray*)wardList:(NSString*)type;

- (void)clearCityList:(NSString*)type;

- (void)clearProvinceList:(NSString*)type;

- (void)clearWardList:(NSString*)type;



- (void)didRequestForMeatList;

- (void)didRequestForFoodList;

- (void)didRequestForMedList;

@end
