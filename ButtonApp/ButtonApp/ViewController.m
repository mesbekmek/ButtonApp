//
//  ViewController.m
//  ButtonApp
//
//  Created by Mesfin Bekele Mekonnen on 3/26/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import "ViewController.h"
#import <Button/Button.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()<
CLLocationManagerDelegate,
MKMapViewDelegate,
UIAppearanceContainer
>

@property (strong, nonatomic) IBOutlet BTNDropinButton *airbnbButton;
@property (strong, nonatomic) IBOutlet BTNDropinButton *uberButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) BOOL mapIsSetup;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setuplocationManager];
    [self setupmapView];
    [self setupButtons];
}

#pragma mark - MapView Methods

- (void)setupmapView {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}

- (void)setupMapRegion {
    if (self.latitude && self.longitude) {
        
        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        
        MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMake(coordinates, span)];
        [self.mapView setRegion:region];
        self.mapIsSetup = YES;
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
    BTNLocation *location = [BTNLocation locationWithName:@"Shoutout-pad" latitude:self.latitude  longitude:self.longitude];
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
    self.airbnbButton.buttonId = @"btn-6d7aff7a12c15cf3";
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
        
        if (!self.mapIsSetup) {
            [self setupMapRegion];
            
        }
    }
    [self.locationManager stopUpdatingLocation];
}


@end
