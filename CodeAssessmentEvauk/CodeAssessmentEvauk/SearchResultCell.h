//
//  SearchResultCell.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/3/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *custNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileUIView;


@end
