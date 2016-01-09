//
//  ChartViewController.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface ChartViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel1;
@property (strong, nonatomic) IBOutlet UILabel *userLabel2;
@property (strong, nonatomic) IBOutlet UILabel *userLabel3;
@property (strong, nonatomic) IBOutlet UILabel *userLabel4;
@property (strong, nonatomic) IBOutlet UILabel *userLabel5;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@end

