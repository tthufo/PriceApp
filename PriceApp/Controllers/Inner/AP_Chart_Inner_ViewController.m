//
//  AP_Chart_Inner_ViewController.m
//  PriceApp
//
//  Created by Thanh Hai Tran on 6/17/18.
//  Copyright © 2018 tthufo. All rights reserved.
//

#import "AP_Chart_Inner_ViewController.h"

#import "AP_Chart_ViewController.h"

#import "Charts-Swift.h"

#import "DateValueFormatter.h"


@interface AP_Chart_Inner_ViewController ()<ChartViewDelegate>
{
    NSMutableArray * dataSource, * titles;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation AP_Chart_Inner_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataSource = [@[] mutableCopy];

    titles = [@[] mutableCopy];

    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.noDataText = @"";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = YES;
    _chartView.pinchZoomEnabled = YES;
    
    _chartView.backgroundColor = [UIColor colorWithWhite:204/255.f alpha:0.f];
    
    ChartLegend *l = _chartView.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.textColor = UIColor.blackColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
//    xAxis.centerAxisLabelsEnabled = YES;
    
    xAxis.granularity = 3600.0;


    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    leftAxis.axisMaximum = 900.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = YES;
    leftAxis.granularity = 100;
    
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.labelTextColor = UIColor.redColor;
    rightAxis.axisMaximum = 900.0;
    rightAxis.axisMinimum = 0.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.granularityEnabled = NO;
    
    [_chartView animateWithXAxisDuration:2.5];
}

- (UIColor *)getRandomColor
{
    srand48(arc4random());
    
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (NSDate*)date:(NSString*)dateString
{
    return [[[dateString componentsSeparatedByString:@"T"] firstObject] dateWithFormat:@"yyyy-MM-dd"];
}

- (void)setData
{
    _chartView.data = nil;
    
    NSMutableArray * dataList = [NSMutableArray new];
    
    for(int o = 0; o < dataSource.count; o++)
    {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < ((NSArray*)dataSource[o][@"Data"]).count; i++)
        {
//            NSLog(@"%@", dataSource[o][@"Data"][i][@"NgayApDung"]);

            NSTimeInterval now = [[self date:dataSource[o][@"Data"][i][@"NgayApDung"]] timeIntervalSince1970];

            [arr addObject:[[ChartDataEntry alloc] initWithX:now y:[((NSArray*)dataSource[o][@"Data"])[i][@"Gia"] intValue]]];
        }
        
        LineChartDataSet *set1 = nil;

//        if (_chartView.data.dataSetCount > 0)
//        {
//            set1 = (LineChartDataSet *)_chartView.data.dataSets[o];
//
//            set1.values = arr;
//
//            [_chartView.data notifyDataChanged];
//
//            [_chartView notifyDataSetChanged];
//        }
//        else
        {
            set1 = [[LineChartDataSet alloc] initWithValues:arr label:dataSource[o][@"Ten"]];
            set1.axisDependency = AxisDependencyLeft;
            [set1 setColor:[self getRandomColor]];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
            [set1 setCircleColor:UIColor.darkGrayColor];
            set1.lineWidth = 2.0;
            set1.circleRadius = 4.0;
            set1.fillAlpha = 65/255.0;
            set1.fillColor = [self getRandomColor];//[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
            set1.highlightColor = [self getRandomColor];//[UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
            set1.drawCircleHoleEnabled = NO;
        }
        
        [dataList addObject:set1];
    }
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataList];
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    [_chartView.data notifyDataChanged];
    [_chartView notifyDataSetChanged];
    
    _chartView.data = data;
}

#pragma mark - ChartViewDelegate
    
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    NSLog(@"chartValueSelected");
//
//    //[_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
//    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
//
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    NSLog(@"chartValueNothingSelected");
//}
//
//
//

    
    
    
- (void)didRequestChart
{
    NSDictionary * dict = [[self parentController] parentInfo];
    
    NSString * type = [info[@"type"] isEqualToString:@"0"] ? @"thitid" : [info[@"type"] isEqualToString:@"1"] ? @"thucanid" : @"thuocid";
    
    NSString * requestID = dict[type];
    
    NSString * sendType = [self requestType];
    
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    NSMutableDictionary * constant = [@{@"absoluteLink":[NSString stringWithFormat:@"%@/thongke/%@",infoPlist[@"host"], sendType],
                                        @"method":@"GET",
                                        @"header":@{@"Authorization":[NSString stringWithFormat:@"%@ %@",@"oak_token", [ObjectInfo shareInstance].token]},
                                        @"Getparam":@{type:requestID, @"batdau":[self isoDate: dict[@"fromDate"]], @"ketthuc":[self isoDate: dict[@"toDate"]], @"arr":[(NSArray*)dict[@"ids"] componentsJoinedByString:@","]},
                                        @"overrideAlert":@(1),
                                        @"host":self,
                                        @"overrideLoading":@(1)
                                        } mutableCopy] ;

    
    [[LTRequest sharedInstance] didRequestInfo:constant withCache:^(NSString *cacheString) {
        
    } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
        
        if([errorCode isEqualToString:@"200"])
        {
            NSDictionary * result = [responseString objectFromJSONString];
            
            if(![result[@"Result"] boolValue])
            {
                [self showToast:result[@"Message"] andPos:0];
                
                return ;
            }
            
            [dataSource removeAllObjects];
            
            [dataSource addObjectsFromArray:result[@"Data"]];
            
            NSMutableArray * arr = [NSMutableArray new];
            
            for(NSDictionary * dict in result[@"Data"])
            {
                [arr addObject:@([self getMaxValueFromArrayofDictonaries:dict[@"Data"]])];
            }
            
            NSNumber *maxNumber = [arr valueForKeyPath:@"@max.self"];

            ((ChartYAxis*)_chartView.leftAxis).axisMaximum = [maxNumber doubleValue] * 2;

            ((ChartYAxis*)_chartView.rightAxis).axisMaximum = [maxNumber doubleValue] * 2;

            [self setData];

        }
        else
        {
            [self showToast:@"Lỗi xảy ra, mời bạn thử lại" andPos:0];
        }
        
    }];
}

-(int)getMaxValueFromArrayofDictonaries:(NSArray *)paramArray
{
    int MaxValue=0;
    NSMutableDictionary  *dic=[[NSMutableDictionary alloc]init];
    for ( int i=0; i<[paramArray count]; i++ )
    {
        dic=[paramArray objectAtIndex:i];
        if ([[dic valueForKey:@"GiaDen"] intValue] > MaxValue)
        {
            MaxValue=[[dic valueForKey:@"GiaDen"] intValue];
        }
        else
        {
            MaxValue=MaxValue;
        }
    }
    return MaxValue;
}


- (NSString*)isoDate:(NSString*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    NSDate *now = [date dateWithFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter stringFromDate:now];
}

- (NSString*)requestType
{
    NSString * urlType = @"";
    
    NSDictionary * dict = [[self parentController] parentInfo];
    
    if([info[@"type"] isEqualToString:@"0"])
        urlType = [dict[@"type"] isEqualToString:@"1"] ? @"GiaThitTheoTinhThanh" : [dict[@"type"] isEqualToString:@"2"] ? @"GiaThitTheoQuanHuyen" : @"GiaThitTheoXaPhuong";
    
    if([info[@"type"] isEqualToString:@"1"])
        urlType = [dict[@"type"] isEqualToString:@"1"] ? @"GiaThucAnTheoTinhThanh" : [dict[@"type"] isEqualToString:@"2"] ? @"GiaThucAnTheoQuanHuyen" : @"GiaThucAnTheoXaPhuong";
    
    if([info[@"type"] isEqualToString:@"2"])
        urlType = [dict[@"type"] isEqualToString:@"1"] ? @"GiaThuocTheoTinhThanh" : [dict[@"type"] isEqualToString:@"2"] ? @"GiaThuocTheoQuanHuyen" : @"GiaThuocTheoXaPhuong";
    
    return urlType;
}

- (AP_Chart_ViewController*)parentController
{
    return (AP_Chart_ViewController*)self.parentViewController.parentViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
