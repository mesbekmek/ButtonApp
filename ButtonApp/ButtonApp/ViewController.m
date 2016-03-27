//
//  ViewController.m
//  ButtonApp
//
//  Created by Mesfin Bekele Mekonnen on 3/26/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "ViewController.h"
#import "FourSqaureAPIManager.h"
#import <Button/Button.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()<
CLLocationManagerDelegate,
MKMapViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIAppearanceContainer
>

@property (strong, nonatomic) IBOutlet BTNDropinButton *airbnbButton;
@property (strong, nonatomic) IBOutlet BTNDropinButton *uberButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) BOOL mapIsSetup;
@property (nonatomic) NSArray *venues;


@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setuplocationManager];
    [self setupmapView];
    [self setupButtons];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - MapView Methods

- (void)setupmapView {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}

- (void)setupMapRegion {
    if (self.latitude && self.longitude) {
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.05f,0.05f);
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        
        MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMake(coordinates, span)];
        [self.mapView setRegion:region];
        self.mapIsSetup = YES;
    }
}

- (void)showPins
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (NSDictionary *venue in self.venues) {
        double lat = [venue[@"location"][@"lat"] doubleValue];
        double lng = [venue[@"location"][@"lng"] doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(lat, lng);
        [self.mapView addAnnotation:point];
    }
}


#pragma mark - CLLocationManger setup

- (void)setuplocationManager {
    
    if(!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark - BTNButtons setup

- (void)setupButtons {
    
    //Location and Context
    BTNLocation *location = [BTNLocation locationWithName:@"Sushi" latitude:self.latitude  longitude:self.longitude];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    //Uber
    self.uberButton.buttonId = @"btn-0fdbec44cbe6ef8b";
    [self.uberButton addTarget:self action:@selector(uberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.uberButton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (isDisplayable) {
            NSLog(@"Displayable");
        }
    }];
    
    //Airbnb
    self.airbnbButton.buttonId = @"btn-576ecb18092adc6c";
    [self.airbnbButton addTarget:self action:@selector(airbnbButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.airbnbButton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            NSLog(@"Something wrong");
        }
    }];
    
    [Button allowButtonToRequestLocationPermission:YES];
}

#pragma mark - BTNDropinButton IBActions

- (void)uberButtonTapped:(BTNDropinButton *)sender {
    NSLog(@"Working");
}

- (void)airbnbButtonTapped:(BTNDropinButton *)sender {
    NSLog(@"Working");
}

#pragma mark - CLLocationManagerDelegate


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations.lastObject;
    if (location != nil) {
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        
        [self fetchVenuesAtLocation:location];
        if (!self.mapIsSetup) {
            [self setupMapRegion];
            
        }
    }
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - TableView Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsCellIdentifier"];
    
    NSDictionary *venue = self.venues[indexPath.row];
    NSString *name = venue[@"name"];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark - Foursquare Method

- (void)fetchVenuesAtLocation:(CLLocation *)location {
    
    __weak typeof(self) weakSelf = self;
    [FourSqaureAPIManager findSomething:@"sushi" atLocation:location
                             completion:^(NSArray *data) {
                                 
                                 weakSelf.venues = data;
                                 [weakSelf.tableView reloadData];
                                 [weakSelf showPins];
                             }];
}

@end
