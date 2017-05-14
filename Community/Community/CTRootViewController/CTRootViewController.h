//
//  CTRootViewController.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CTMapAnnotationCalloutView.h"
#import "CTMapAnnotation.h"
#import "CTGetRestaurantSummaryRequest.h"
#import <MessageUI/MessageUI.h>
#import "CTTileViewController.h"
#import "MISDropdownViewController.h"
#import "MISDropdownMenuView.h"
#import "CTFilterViewController.h"

@class CTParentViewController;
typedef void(^MapViewLoadedBlock)(BOOL mapViewLoaded);
typedef void(^MapViewAppearDisappearBlock)(BOOL appeared);
@interface CTRootViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,CTMapAnnotationCalloutViewDelegate,UIGestureRecognizerDelegate,CTMapAnnotationDelegate,CTGetRestaurantSummaryRequestDelegate,MFMailComposeViewControllerDelegate> {
    BOOL didPan;
    MKMapRect zoomRect;
    BOOL isRequestInProgress;
    BOOL calloutVisible;
    BOOL isLoggedIn;
    BOOL isMenu;
    BOOL isCREATE;
    CTTileViewController *tileController;
    NSMutableArray *City_List;
    NSMutableArray *Catagory_List;
    UIButton *CityListButton;
    UIButton *CatagoryListButton;
    CTFilterViewController*filterViewController;
    NSMutableArray *citysearch;
}
@property (nonatomic,retain) NSMutableArray *newarray;
@property (nonatomic,retain) NSMutableArray *getcitylist;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property(weak,nonatomic) IBOutlet UIView *hintMask;
@property (nonatomic, retain) IBOutlet UILabel *lblInfo;
@property (nonatomic, retain) IBOutlet UIButton *btnInfo;
@property(assign,nonatomic) BOOL isLoggedIn;
@property(assign,nonatomic) BOOL isFirstTimeLoaded;
@property (nonatomic, retain) NSMutableDictionary *dictSelectorAndSender;
@property(copy) MapViewLoadedBlock compBlock;
@property(copy) MapViewAppearDisappearBlock appearDisappearBlock;
@property (strong, nonatomic) MISDropdownViewController *dropdownViewController;
@property (strong, nonatomic) MISDropdownViewController *dropdownViewController1;
@property (strong, nonatomic) MISDropdownMenuView *dropdownMenuView;
@property (strong, nonatomic) MISDropdownMenuView *dropdownMenuView1;
@property BOOL navFlag;

- (void)showOrHideMaskImage;
- (void)showOrHideInfoButton;
-(IBAction)zoomBtnTaped:(id)sender;
-(IBAction)showTilesView:(id)sender;
-(IBAction)showAdAlertView:(id)sender;
-(IBAction)showListView:(id)sender;
-(IBAction)TileViewOpen:(id)sender;
-(void)searchForZipCode:(NSUInteger)zipCode street:(NSString*)street city:(NSString*)city;
@end
