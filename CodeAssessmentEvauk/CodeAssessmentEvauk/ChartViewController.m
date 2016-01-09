//
//  ChartViewController.m
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import "ChartViewController.h"
#import "Chart.h"
#import "UserInfo.h"
#import "UserProfileViewController.h"

@interface ChartViewController ()
@property (strong, nonatomic) IBOutlet UIView *chartView;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSString *chartTotal;
@property (strong, nonatomic) UserInfo *userOne;
@property (strong, nonatomic) UserInfo *userTwo;
@property (strong, nonatomic) UserInfo *userThree;
@property (strong, nonatomic) UserInfo *userFour;
@property (strong, nonatomic) UserInfo *userFive;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSString *tappedID;


@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userArray = [[NSMutableArray alloc] init];

    [self postData];

    _chartView = [[UIView alloc] init];
    
    self.slices = [NSMutableArray arrayWithCapacity:5];

    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];	//optional
    [self.pieChart setAnimationSpeed:1.0];	//optional
    [self.pieChart setLabelFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];	//optional
    [self.pieChart setLabelColor:[UIColor whiteColor]];	//optional, defaults to white
    [self.pieChart setLabelRadius:80];	//optional
    [self.pieChart setShowPercentage:NO];	//optional
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
    [self.pieChart setPieCenter:CGPointMake(120, 120)];	//optional
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:255/255.0 green:0/255.0 blue:38/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:144/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:192/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:71/255.0 green:200/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:0/255.0 green:178/255.0 blue:93/255.0 alpha:1],nil];
    
    [self.totalLabel.layer setCornerRadius:58];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) postData {
    
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSURL *url = [NSURL URLWithString:@"https://www.thesoloconnection.com/demo/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = @"method=chart";
    
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
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // If we get any connection error we can manage it here…
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                              options:kNilOptions
                                                error:&error];
    
    NSDictionary *chartResponse = [json objectForKey:@"data"];
    _chartTotal = [chartResponse objectForKey:@"total"];
    _totalLabel.text = [NSString stringWithFormat:@"%@",_chartTotal];

    NSInteger numberOfUsers = [chartResponse count] - 1;
    NSLog(@"%ld", (long)numberOfUsers);
    
    [self createUsers:numberOfUsers fromJSONDictionary:chartResponse];
        NSLog(@"%@", json);
    
    NSLog(@"%@", _userOne.fullname);
    _userLabel1.attributedText = [self fullnameAndAmountString:_userOne];
    
    [_slices addObjectsFromArray:_userArray];

    _userLabel1.attributedText = [self fullnameAndAmountString:_userOne];
    _userLabel2.attributedText = [self fullnameAndAmountString:_userTwo];
    _userLabel3.attributedText = [self fullnameAndAmountString:_userThree];
    _userLabel4.attributedText = [self fullnameAndAmountString:_userFour];
    _userLabel5.attributedText = [self fullnameAndAmountString:_userFive];
    
}

#pragma mark - Fill UserInfo methods

- (void) createUsers:(NSInteger)amountOfUsers fromJSONDictionary:(NSDictionary*)dictionary {
    for (int i = 0; i<=amountOfUsers; i++) {
        
        [self useNumber:i toFillUser:[self getUserAssignedToNumber:i] withDetails:dictionary];
        [self setUserColors];

    }
}

- (UserInfo*)getUserAssignedToNumber:(int)number {
    switch (number) {
        case 0:
            _userOne = [[UserInfo alloc] init];
            [_userArray addObject:_userOne];
            return _userOne;
            break;
            
        case 1:
            _userTwo = [[UserInfo alloc] init];
            [_userArray addObject:_userTwo];
            return _userTwo;
            break;
            
        case 2:
            _userThree = [[UserInfo alloc] init];
            [_userArray addObject:_userThree];
            return _userThree;
            break;
            
        case 3:
            _userFour = [[UserInfo alloc] init];
            [_userArray addObject:_userFour];
            return _userFour;
            break;
            
        case 4:
            _userFive = [[UserInfo alloc] init];
            [_userArray addObject:_userFive];
            return _userFive;
            break;
            
        default:
            break;
    }
    UserInfo *noUser = nil;
    return noUser;
}

- (void) useNumber:(int)number toFillUser:(UserInfo*)user withDetails:(NSDictionary*)json{
    
    NSDictionary *userDict = [json objectForKey:[NSString stringWithFormat:@"%d", number]];

    user.fullname = [userDict objectForKey:@"fullname"];
    user.amount = [userDict objectForKey:@"amount"];
    user.id = [userDict objectForKey:@"id"];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    UserInfo *userSlice = [[UserInfo alloc] init];
    userSlice = [self.slices objectAtIndex:index];

    int sliceValue = [userSlice.amount intValue];
    return sliceValue;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index {
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index {
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
    
    UserInfo *user  = _userArray[index];
    _tappedID = [NSString stringWithFormat:@"%@", user.id];
    NSLog(@"tappedID is: %@", _tappedID);
    
    UserProfileViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileController"];
    myController.incomingID = _tappedID;
    [self.navigationController pushViewController: myController animated:YES];
}

- (void) setUserColors {
    _userOne.color = _sliceColors[0];
    _userTwo.color = _sliceColors[1];
    _userThree.color = _sliceColors[2];
    _userFour.color = _sliceColors[3];
    _userFive.color = _sliceColors[4];
}

- (NSAttributedString *) fullnameAndAmountString:(UserInfo*)user {
    if (user.fullname != nil) {
        UIFont *italicFont = [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:20];
        UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
        
        NSString *baseString = [NSString stringWithFormat:@"\u2022 %@ - %@", user.fullname, user.amount];
        NSMutableAttributedString *mutableFullnameAndAmountString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:nil];
        
        NSRange bulletRange = [baseString rangeOfString:[NSString stringWithFormat:@"\u2022"]];
        [mutableFullnameAndAmountString addAttribute:NSFontAttributeName value:boldFont range:bulletRange];
        [mutableFullnameAndAmountString addAttribute:NSForegroundColorAttributeName value:user.color range:bulletRange];
        
        NSRange amountRange = [baseString rangeOfString:[NSString stringWithFormat:@"%@", user.amount]];
        [mutableFullnameAndAmountString addAttribute:NSFontAttributeName value:italicFont range:amountRange];
        [mutableFullnameAndAmountString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:amountRange];
        
        return mutableFullnameAndAmountString;
    } else {
        NSString *baseString = [NSString stringWithFormat:@" "];
        NSMutableAttributedString *blankString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:nil];
        return blankString;
    }
}

@end
