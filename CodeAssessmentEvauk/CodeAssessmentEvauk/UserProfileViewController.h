//
//  UserProfileViewController.h
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/3/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (strong, nonatomic) NSString *incomingID;

@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIButton *backToDashboardButton;

@property (strong, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@end
