//
//  DashboardViewController.m
//  CodeAssessmentEvauk
//
//  Created by Husam Al-Ziab on 1/2/16.
//  Copyright © 2016 Husam Al-Ziab. All rights reserved.
//

#import "DashboardViewController.h"
#import "Dashboard.h"
#import "UIBarButtonItem+Badge.h"
#import "UserProfileViewController.h"
#import "SearchResultCell.h"
#import "SearchResult.h"

@interface DashboardViewController () <UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedNotifData;
@property (retain, nonatomic) NSURLConnection *connectionNotif;

@property (nonatomic, strong) Dashboard *dashboard;
@property (nonatomic, assign) NSString *notificationAmount;
@property (strong, nonatomic) IBOutlet UIButton *buttonA;
@property (strong, nonatomic) IBOutlet UIButton *buttonB;

@property (strong, nonatomic) NSString *filter;
@property int extra;
@property (strong, nonatomic) NSString *direction;
@property int row_start;
@property int row_offset;


@property (nonatomic, strong) NSString *tappedID;


@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _profileButton.layer.cornerRadius = 1;
    _profileButton.layer.borderWidth = 1;
    _profileButton.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:132/255.0 blue:214/255.0 alpha:1] CGColor];
    
    _chartsButton.layer.cornerRadius = 1;
    _chartsButton.layer.borderWidth = 1;
    _chartsButton.layer.borderColor = [[UIColor colorWithRed:58/255.0 green:164/255.0 blue:0/255.0 alpha:1] CGColor];
    
    NSLocale* currentLocale = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentLocale];
    
    _filter = @"";
    [self adjustExtraParamToSwitch];
    [self adjustDirectionParamToScope];
    _row_start = 0;
    _row_offset = 3;
    
    [self postData];
    [self postSearchResultsWithFilter:_filter];
    
    self.navigationItem.hidesBackButton = YES;
    
    _dashboard = [[Dashboard alloc] init];
    
    UIButton *barBt =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [barBt setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    barBt.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [barBt setTitle:@"Notifications" forState:UIControlStateNormal];
    [barBt addTarget:self action: @selector(notificationsRefreshed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem =  [[UIBarButtonItem alloc]init];
    [barItem setCustomView:barBt];
    self.navigationItem.rightBarButtonItem = barItem;
    self.navigationItem.rightBarButtonItem.badgeValue = nil;
    self.navigationItem.rightBarButtonItem.badgeOriginX = -9;
    self.navigationItem.rightBarButtonItem.badgeOriginY = -2;
    
    [_buttonA addTarget:self action:@selector(buttonATapped:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonB addTarget:self action:@selector(buttonBTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_extraSwitch addTarget:self action:@selector(changeExtraSwitch) forControlEvents:UIControlEventValueChanged];
    [_recSentScope addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];

    _profileButton.layer.cornerRadius = 1;
    _chartsButton.layer.cornerRadius = 1;
    
    _searchResults = [NSMutableArray arrayWithCapacity:[self.searchResults count]];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    // The searchcontroller's searchResultsUpdater property will contain our tableView.
//    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.searchBar.placeholder = NSLocalizedString(@"Search", @"Search placeholder text");
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor lightGrayColor];
    self.searchController.searchBar.tintColor = [UIColor blackColor];
    
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) postData {
        [self startSpinner];
    
    [self.connectionNotif cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedNotifData = data;
    NSURL *url = [NSURL URLWithString:@"https://www.thesoloconnection.com/demo/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = @"method=dashboard";

    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connectionNotif = connection;
    
    [connection start];
    
    if(connection) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }

}

-(void) postSearchResultsWithFilter:(NSString*)filter {

    [self startSpinner];
    
    _filter = filter;
    
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSURL *url = [NSURL URLWithString:@"https://www.thesoloconnection.com/demo/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"method=search&filter=%@&direction=%@&extra=%d&row_start=%d&row_offset=%d", _filter, _direction, _extra, _row_start, _row_offset];
    NSLog(@"POSTDATA: %@", postData);
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    NSDictionary *result = _searchResults[indexPath.row];
    
    if (result != nil ) {
    
        cell.userFullNameLabel.text = [result objectForKey:@"fullname"];
        
        cell.userFullNameLabel.text = [result objectForKey:@"fullname"];
        cell.userAmountLabel.text = [NSString stringWithFormat:@"$ %@",[result objectForKey:@"amount"]];
        cell.userPhoneLabel.text = [result objectForKey:@"phone"];
        cell.custNameLabel.text = [result objectForKey:@"customer_name"];
        cell.customerPhoneLabel.text = [result objectForKey:@"customer_phone"];
        
        cell.userProfileUIView.image = [self applyPhotoToUserWithNumber:[result objectForKey:@"profileimage"]];
        
        cell.userAmountLabel.layer.cornerRadius = 2;
        cell.dateLabel.text = [self getDateTime];
        
    }
    
    return cell;
}

- (UIImage*) applyPhotoToUserWithNumber:(NSNumber*)photoNumber {
    UIImage *newProfilePic;
    switch ([photoNumber intValue]-1) {
        case 0:
            newProfilePic = [UIImage imageNamed:@"headshot_1"];
            return newProfilePic;
            break;
            
        case 1:
            newProfilePic = [UIImage imageNamed:@"headshot_2"];
            return newProfilePic;
            break;
            
        case 2:
            newProfilePic = [UIImage imageNamed:@"headshot_3"];
            return newProfilePic;
            break;
            
        default:
            break;
    }
    return nil;

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
//    [_searchResults removeAllObjects];
//    [_tableView reloadData];
    _row_offset = 3;
    _row_start = 0;
    [self updateSearchResultsForSearchController:_searchController];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = searchController.searchBar.text;
    
    [self postSearchResultsWithFilter:searchString];
    [_tableView reloadData];

    
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == _connectionNotif) {
        [_receivedNotifData setLength:0];
        [self stopSpinner];
    } else if (connection == _connection) {
        [_receivedData setLength:0];
        [self stopSpinner];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == _connectionNotif) {
        [_receivedNotifData appendData:data];
        [self stopSpinner];
    } else if (connection == _connection) {
        [_receivedData appendData:data];
        [self stopSpinner];
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // If we get any connection error we can manage it here…
    [self stopSpinner];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    if (connection == _connectionNotif) {
        id json = [NSJSONSerialization JSONObjectWithData:_receivedNotifData
                                                  options:kNilOptions
                                                    error:&error];

        if ([json objectForKey:@"notifications"] != nil ) {
            NSString *notificationCount = [json objectForKey:@"notifications"];
            
            _dashboard.notifications = [NSString stringWithFormat:@"%@", notificationCount];
            _notificationAmount = _dashboard.notifications;
            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@", _notificationAmount];
            [self stopSpinner];
        }
        
    } else if (connection == _connection) {
        id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                                  options:kNilOptions
                                                    error:&error];

        
        if ([json objectForKey:@"data"] != nil) {
            NSMutableArray *searchResponse = [json objectForKey:@"data"];
            
            _searchResults = searchResponse ;
            NSLog(@"SearchResults: %@",_searchResults);
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [_tableView reloadData];
            [self stopSpinner];
        }
        
    }
}


#pragma mark - Button methods

-(void) notificationsRefreshed {
    [self postData];
}

-(IBAction)buttonATapped:(id)sender {
    UIAlertController *buttonAAlert = [UIAlertController alertControllerWithTitle:@"Alert!"
                                                                          message:@"These are not the droids you are looking for."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                          }];

    [buttonAAlert addAction:defaultAction];
    
    [self presentViewController:buttonAAlert animated:YES completion:nil];
    
}

-(IBAction)buttonBTapped:(id)sender {
    UIAlertController *buttonBAlert = [UIAlertController alertControllerWithTitle:@"Yes or No?"
                                                                          message:@"The aardvark (/ˈɑrd.vɑrk/ ard-vark; Orycteropus afer) is a medium-sized, burrowing, nocturnal mammal native to Africa.[2] It is the only living species of the order Tubulidentata,[3][4] although other prehistoric species and genera of Tubulidentata are known. Unlike other insectivores, it has a long pig-like snout, which is used to sniff out food. It roams over most of the southern two-thirds of the African continent, avoiding mainly rocky areas. A nocturnal feeder, it subsists on ants and termites, which it will dig out of their hills using its sharp claws and powerful legs. It also digs to create burrows in which to live and rear its young. It receives a least concern rating from the IUCN, although its numbers seem to be decreasing. The aardvark is sometimes colloquially called African ant bear,[5] anteater, or the Cape anteater[5] after the Cape of Good Hope. The name aardvark (Afrikaans pronunciation: [ˈɑːrtfɐrk]) comes from earlier Afrikaans (erdvark)[5] and means earth pig or ground pig (aarde earth/ground, vark pig), because of its burrowing habits[6] (similar origin to the name groundhog). The name Orycteropus means burrowing foot, and the name afer refers to Africa.[7] The name of the aardvarks's order, Tubulidentata comes from the tubule style teeth. The aardvark is not closely related to the pig; rather, it is the sole extant representative of the obscure mammalian order Tubulidentata,[7] in which it is usually considered to form one variable species of the genus Orycteropus, the sole surviving genus in the family Orycteropodidae. The aardvark is not closely related to the South American anteater, despite sharing some characteristics and a superficial resemblance.[9] The similarities are based on convergent evolution.[10] The closest living relatives of the aardvark are the elephant shrews, tenrecs and golden moles.[11] Along with the sirenians, hyraxes, elephants,[12] and their extinct relatives, these animals form the superorder Afrotheria.[13] Studies of the brain have shown the similarities with Condylarthra,[10] and given the clade's status as a wastebasket taxon it may mean some species traditionally classified as condylarths are actually stem-aardvarks."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                            }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"No"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                          }];
    [buttonBAlert addAction:firstAction];
    [buttonBAlert addAction:secondAction];
    
    [self presentViewController:buttonBAlert animated:YES completion:nil];
    
}

- (void) adjustExtraParamToSwitch {
    if (_extraSwitch.on == NO) {
        _extra = 0;
    } else if (_extraSwitch.on == YES) {
        _extra = 1;
    }
}

-(void) changeExtraSwitch {
    [self adjustExtraParamToSwitch];
    NSLog(@"Extra Param is: %d", _extra);
}

- (void) adjustDirectionParamToScope {
    if (_recSentScope.selectedSegmentIndex == 0) {
        _direction = @"received";
    } else {
        _direction = @"sent";
    }
}

-(void) changeDirectionScope {
    [self adjustDirectionParamToScope];
    NSLog(@"Scope is: %@", _direction);
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {

        _direction = @"received";
        NSLog(@"Scope is: %@", _direction);
        [self postSearchResultsWithFilter:_filter];

    }
    else {
        _direction = @"sent";
        NSLog(@"Scope is: %@", _direction);
        [self postSearchResultsWithFilter:_filter];


    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    _row_start = _row_start +3;
        [self postSearchResultsWithFilter:_filter];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (_row_start  >=1 ) {
        
        _row_start = _row_start -3;
        [self postSearchResultsWithFilter:_filter];

    } else {
        NSLog(@"You're at the beginning");
    }
}


- (NSString*) getDateTime {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (void) startSpinner {
    if (![self.view viewWithTag:12]) {
        UIView *backgroundDim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        backgroundDim.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        backgroundDim.tag = 13;
        [self.view addSubview:backgroundDim];
        
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToUserFromSliceSegue"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        
        destViewController.incomingID = @"1";
        NSLog(@"The grabbed id is: %@", destViewController.incomingID);
        
    }
}

@end
