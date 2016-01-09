//
//  SearchResult.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/3/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResult : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *userFullname;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userAmount;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSNumber *userProfileImage;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *customerPhone;

@end
