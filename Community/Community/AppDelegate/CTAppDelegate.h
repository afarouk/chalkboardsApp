//
//  CTAppDelegate.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include "TargetConditionals.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CTAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL kNetworkStatus;
@property (nonatomic,assign)BOOL isLocationServiceAllowed;
@property (nonatomic,assign)double currentLatitude;
@property (nonatomic,assign)double currentLongitude;
@property (strong, nonatomic) NSDictionary *refererAppLink;
+(CTAppDelegate *)sharedNetworkStatus;
-(void)getCurrentGeoPoints;
@end
