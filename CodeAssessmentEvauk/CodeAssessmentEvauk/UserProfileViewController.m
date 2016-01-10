//
//  UserProfileViewController.m
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/3/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import "UserProfileViewController.h"
#import "GetUser.h"
#import <QuartzCore/QuartzCore.h>
#import "DashboardViewController.h"


@interface UserProfileViewController ()

@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSURLConnection *connection;
@property (nonatomic, strong) GetUser *user;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _user = [[GetUser alloc] init];
    UIImage *profilePH = [UIImage imageNamed:@"headshot_blank"];
    _profileImageView.image = profilePH;
    
    [self postData];
    
    [self changePhoneToWhite];
    [self changeEnvelopeToWhite];
    
    [_backToDashboardButton addTarget:self action:@selector(backToDashboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _backToDashboardButton.layer.cornerRadius = 5;
    _backToDashboardButton.layer.borderWidth = 1;
    _backToDashboardButton.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:132/255.0 blue:214/255.0 alpha:1] CGColor];
    
    _businessNameLabel.layer.cornerRadius = 3;
    _numberLabel.layer.cornerRadius = 3;

    
    [_messageButton addTarget:self action:@selector(openEmail:) forControlEvents:UIControlEventTouchUpInside];
    [_callButton addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) postData {
    
    [self startSpinner];
    
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSURL *url = [NSURL URLWithString:@"https://www.thesoloconnection.com/demo/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
//    NSString *postData = @"method=get_user&id=55";
    NSLog(@"%@", _incomingID);
    
    NSString *postData = [NSString stringWithFormat:@"method=get_user&id=%@", _incomingID];

    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    [connection start];
    
    if(connection) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}


#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    [_receivedData setLength:0];
    [self stopSpinner];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
    [self stopSpinner];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // If we get any connection error we can manage it here…
    [self stopSpinner];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                              options:kNilOptions
                                                error:&error];
    
    NSDictionary *userResponse = [json objectForKey:@"data"];
    if (userResponse != nil) {
        _user.fullname = [userResponse objectForKey:@"fullname"];
        _user.email = [userResponse objectForKey:@"email"];
        _user.amount = [userResponse objectForKey:@"amount"];
        _user.phone = [userResponse objectForKey:@"phone"];
        _user.profileimage = [userResponse objectForKey:@"profileimage"];
        
        _fullNameLabel.text = [NSString stringWithFormat:@"%@",_user.fullname];
        _emailLabel.text = [NSString stringWithFormat:@"%@",_user.email];
        _phoneLabel.text = [NSString stringWithFormat:@"%@",_user.phone];
        
        //Method to determine profile photo
        [self applyPhotoToUserWithNumber:_user.profileimage];
    }
    
    NSLog(@"%@", json);
    
    NSLog(@"%@", _user.fullname);
}

- (void) applyPhotoToUserWithNumber:(NSNumber*)photoNumber {
    UIImage *newProfilePic;
    switch ([photoNumber intValue]-1) {
        case 0:
            newProfilePic = [UIImage imageNamed:@"headshot_1"];
            _profileImageView.image = newProfilePic;
            break;
            
        case 1:
            newProfilePic = [UIImage imageNamed:@"headshot_2"];
            _profileImageView.image = newProfilePic;
            break;
            
        case 2:
            newProfilePic = [UIImage imageNamed:@"headshot_3"];
            _profileImageView.image = newProfilePic;
            break;
            
        default:
            break;
    }
    [self stopSpinner];
}

#pragma mark - Button methods

-(void) changeEnvelopeToWhite {
    UIImage *envelopeImage = [UIImage imageNamed:@"envelope"];
    UIView *overlay = [[UIView alloc] initWithFrame:[_messageButton frame]];
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:envelopeImage];
    
    [self.view insertSubview:maskImageView belowSubview:_messageButton];
    [self.view insertSubview:overlay belowSubview:maskImageView];

    [maskImageView setFrame:[overlay bounds]];
    [[overlay layer] setMask:[maskImageView layer]];
    [overlay setBackgroundColor:[UIColor whiteColor]];
    
    _messageButton = [[UIButton alloc] initWithFrame:[overlay frame]];
    [self.view insertSubview:_messageButton aboveSubview:overlay];
}

-(void) changePhoneToWhite {
    UIImage *envelopeImage = [UIImage imageNamed:@"phone"];
    UIView *overlay = [[UIView alloc] initWithFrame:[_callButton frame]];
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:envelopeImage];
    
    [self.view insertSubview:maskImageView belowSubview:_callButton];
    [self.view insertSubview:overlay belowSubview:maskImageView];
    
    [maskImageView setFrame:[overlay bounds]];
    [[overlay layer] setMask:[maskImageView layer]];
    [overlay setBackgroundColor:[UIColor whiteColor]];
    
    _callButton = [[UIButton alloc] initWithFrame:[overlay frame]];
    [self.view insertSubview:_callButton aboveSubview:overlay];
}

-(IBAction)backToDashboardButtonPressed:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    
    DashboardViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
//    [self.navigationController pushViewController:myController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController: myController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];

}

-(IBAction) openEmail:(id)sender {
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", _user.email];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

-(IBAction) openPhone:(id)sender {
    NSString *phoneNumber = [NSString stringWithFormat:@"+%@", _user.phone];
    NSMutableString *phone = [phoneNumber mutableCopy];
    [phone replaceOccurrencesOfString:@" "
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"("
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@")"
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) startSpinner {
    if (![self.view viewWithTag:12]) {
        UIView *backgroundDim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        backgroundDim.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        backgroundDim.tag = 13;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor grayColor];
        spinner.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2.5);
        spinner.tag = 12;
        [self.view addSubview:spinner];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [spinner hidesWhenStopped];
        [spinner startAnimating];
    }
}

- (void) stopSpinner {
    [[self.view viewWithTag:12] stopAnimating];
    [[self.view viewWithTag:12] removeFromSuperview];
    [[self.view viewWithTag:13] removeFromSuperview];

    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
