//
//  CTDriveMapViewController.m
//  Community
//
//  Created by ADMIN on 17/05/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTDriveMapViewController.h"

@interface CTDriveMapViewController ()
{
    CLLocationManager *locationManager;
    //CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@end

@implementation CTDriveMapViewController
@synthesize home,office;

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    locmanager = [[CLLocationManager alloc] init];
    [locmanager setDelegate:self];
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        mapView = [[MapView alloc] initWithFrame:
                   CGRectMake(0, 0, 414,736)] ;
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        mapView = [[MapView alloc] initWithFrame:
                   CGRectMake(0, 0, 375,667)] ;
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        mapView = [[MapView alloc] initWithFrame:
                   CGRectMake(0, 0, 320,568)] ;
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        mapView = [[MapView alloc] initWithFrame:
                   CGRectMake(0, 0, 320,480)] ;
    }
    
    [self.view addSubview:mapView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Distancemy:) name:@"dist" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Minmy:) name:@"min" object:nil];
    
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAct:)];
    longPress.minimumPressDuration = 1;
    [mapView addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Distancemy:) name:@"dist" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Minmy:) name:@"min" object:nil];
    
}

-(void)Distancemy:(NSNotification *)not
{
    Lbl_distance.text = distance;
}

-(void)Minmy:(NSNotification *)noti
{
    Lbl_min.text = min;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)longPressAct:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"longlonglonglonglong");
        CGPoint touchPoint = [recognizer locationInView:mapView.mapView];
        CLLocationCoordinate2D coordinate = [mapView.mapView convertPoint:touchPoint toCoordinateFromView:mapView.mapView];
        office.longitude = coordinate.longitude;
        office.latitude = coordinate.latitude;
        [mapView showRouteFrom:home to:office];
    }
}

#pragma mark - CLLocationManager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            home = [[Place alloc] init] ;
            home.name = @"Currunt Location";
            //home.description = @"Sweet home";
            home.latitude = newLocation.coordinate.latitude;
            home.longitude = newLocation.coordinate.longitude;
            
            if ([self.MapLattitude isEqual: [NSNull null]])
            {
                self.MapLattitude = @"0.000000";
            }
            if ([self.MapLongitude isEqual: [NSNull null]]) {
                self.MapLongitude = @"0.000000";
            }
            office = [[Place alloc] init] ;
            office.name = _MapSaSlName;
            office.description = _MapSaSldis;
            office.latitude = [self.MapLattitude floatValue];
            office.longitude = [self.MapLongitude floatValue];
            
            [mapView showRouteFrom:home to:office];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
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
