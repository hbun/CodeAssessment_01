//
//  GetUser.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUser : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *profileimage;
@property (nonatomic, strong) NSString *notifications;


@end
