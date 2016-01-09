//
//  Chart.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface Chart : NSObject

@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *notifications;

@property (nonatomic, strong) UserInfo *userInfo;



@end
