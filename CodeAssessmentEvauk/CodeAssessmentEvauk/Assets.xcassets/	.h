//
//  SearchResultCell.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/3/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *profileimage;
@property (nonatomic, strong) NSString *customername;
@property (nonatomic, strong) NSString *customerphone;

@end
