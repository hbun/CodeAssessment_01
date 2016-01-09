//
//  DashboardViewController.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DashboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIButton *chartsButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *recSentScope;
@property (strong, nonatomic) IBOutlet UISwitch *extraSwitch;


@end

