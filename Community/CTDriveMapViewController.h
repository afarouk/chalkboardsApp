//
//  CTDriveMapViewController.h
//  Community
//
//  Created by ADMIN on 17/05/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "Place.h"
#import <CoreLocation/CoreLocation.h>
NSString *distance;
NSString *min;

@protocol CTDriveMapViewControllerDelegate <NSObject>
@end

@interface CTDriveMapViewController : UIViewController<CLLocationManagerDelegate>
{
    MapView* mapView;
    Place *home;
    Place* office;
    CLLocationManager *locmanager;
    
    
    IBOutlet UILabel *Lbl_distance;
    
    IBOutlet UILabel *Lbl_min;
}
@property(nonatomic,assign) id<CTDriveMapViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *MapLattitude;
@property (strong, nonatomic) NSString *MapLongitude;
@property (strong, nonatomic) NSString *MapSaSlName;
@property (strong, nonatomic) NSString *MapSaSldis;

@property (strong, nonatomic) Place* office;
@property (strong, nonatomic) Place *home;



@end
