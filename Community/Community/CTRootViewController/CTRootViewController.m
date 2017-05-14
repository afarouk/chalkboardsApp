//
//  CTRootViewController.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRootViewController.h"
#import "CTOutOfNetworkViewController.h"
#import "MBProgressHUD.h"
#import "CTRestaurantHomeViewController.h"
#import "CTAppDelegate.h"
#import "CTNavigationBar.h"
#import "Constants.h"
#import "CTCommonMethods.h"
#import "NSArray+RestaurantSummaryByUIDAndLocation.h"
#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+MarkerDetails.h"
#import "NSArray+SASLSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "MKMapView+ZoomLevel.h"
#import "CTRootControllerDataModel.h"
#import "ImageNamesFile.h"
#import "CTCommonBarButtons.h"
#import "CTParentViewController.h"
#import "CTTileViewController.h"
#import "CTWebviewDetailsViewController.h"
#import "CTCommonMethods.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTLoginViewController.h"
#import "CTDataModel_FilterViewController.h"
#import "CTCreateViewController.h"
#import "CTMenuViewController.h"
#import "CTFilterViewController.h"



#define ZoomSpanDelta 0.006



// Completion Blocks
typedef void(^AnnotationsBlock)(NSArray *annotations);
typedef void(^DataToJSONCompletionBlock)(id object, NSError *error);

@interface Multitasking: NSObject

+(Multitasking*)sharedInstance;
-(void)addAnnotationsFromRestSummaryArray:(NSArray*)restaurantSASLSummary andSelectedCategory:(NSString*)selectedCategory parent:(id)parent completionBlock:(AnnotationsBlock)block;
-(void)getJSONFromData:(NSData*)data completionBlock:(DataToJSONCompletionBlock)block;
@end

@implementation Multitasking
static Multitasking *sharedInstance;
+(Multitasking*)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[Multitasking alloc]init];
    return sharedInstance;
}


-(void)addAnnotationsFromRestSummaryArray:(NSArray*)restaurantSASLSummary andSelectedCategory:(NSString*)selectedCategory parent:(id)parent completionBlock:(AnnotationsBlock)block {
    // make it in separate queue.
//    NSLog(@"restaurantSASLSummary = %@",restaurantSASLSummary);
    [[NSOperationQueue new]addOperationWithBlock:^{
        NSMutableArray * annotationArray=[[NSMutableArray alloc]init];
        CLLocationCoordinate2D coordinate;
        NSData *serializeObj=[NSKeyedArchiver archivedDataWithRootObject:restaurantSASLSummary];
        [[NSUserDefaults standardUserDefaults]setObject:serializeObj forKey:@"saslSummary"];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_RestaurantListData object:self];
//        NSMutableArray *sasls = [restaurantSASLSummary valueForKey:@"sasls"];
        NSMutableArray *sasls = (NSMutableArray *)restaurantSASLSummary;
//        NSLog(@"sasls = %@",sasls);
        for(int i=0;i<[sasls count];i++){
            NSMutableDictionary *restaurantDict=(NSMutableDictionary*)[sasls restaurantSASLSummary:i];
            NSMutableArray  *mapMarkers=(NSMutableArray*)[restaurantDict saslMapMarkers];
            //NSLog(@"RESTAURANT NAME %@",[restaurantDict name]);
            for(int j=0;j<[[mapMarkers copy] count];j++){
                NSMutableDictionary *mutableMarkerDictionary = [mapMarkers objectAtIndex:j];
//                NSLog(@"mutableMarkerDictionary %@",mutableMarkerDictionary);
                double latitute=[[restaurantDict latitude] doubleValue];
                double longitute=[[restaurantDict longitude]doubleValue];
//                NSLog(@"Lat Value %f",latitute);
                NSString *title=[restaurantDict name];
                NSString *subtitle=[mapMarkers category:j];
                NSString *markerURL=[mapMarkers apiMarkerURL:j];
                coordinate.latitude=latitute;
                coordinate.longitude=longitute;
//                NSLog(@"coordinate.latitude %f",coordinate.latitude);
//                NSLog(@"selected category %@",selectedCategory);
//                NSLog(@"subtitle %@",subtitle);
//                 NSLog(@"subtitle %@",subtitle);
                if([subtitle isEqualToString:selectedCategory]){
//                    NSLog(@"subtitle %@ at index %d",markerURL,j);
                    CTMapAnnotation *annotation=[[CTMapAnnotation alloc]initWithCoordinate:coordinate withTitle:title withSubTitle:subtitle withPinImageURL:markerURL andRestaurantObj:restaurantDict];
                    annotation.delegate = parent;
                    //NSLog(@"res count %d",[restaurantDict count]);
                    [annotationArray addObject:annotation];
                    // NSLog(@"Annotation count  %d",[annotationArray count]);
                    //self.annotation=nil;
//                    NSLog(@"DOWNLOAD IMAGE FOR URL %@",markerURL);
                    [annotation downloadImageForMarkerURL:markerURL restDictionary:mutableMarkerDictionary completionBlock:^(CTMapAnnotation *annotation, NSMutableDictionary *dictionary, UIImage *image, NSError *error) {
                        if(!error) {
                            annotation.pinImage = image;
                           
//                            NSLog(@"index %d",[mapMarkers indexOfObject:dictionary]);
                            [dictionary setMarkerImage:image];
//                            NSLog(@"dictionary = %@",dictionary);
                            //                            NSMutableDictionary *new = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                            //                            [new setMarkerImage:image];
                            //                            [mapMarkers replaceObjectAtIndex:[mapMarkers indexOfObject:dictionary] withObject:new];
                            

                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_MarkerImageDownloaded object:restaurantDict];
                        }
                    }];
                }
            }
            
        }
        block(annotationArray);
        
    }];
    
    
}

-(void)getJSONFromData:(NSData*)data completionBlock:(DataToJSONCompletionBlock)block {
    [[NSOperationQueue new]addOperationWithBlock:^{
        NSError *error= nil;
        //        NSLog(@"JSON STRING %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        id JSON = nil;
        if(data)
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",@"error"];
        if(!error) {
            if(JSON && (([JSON isKindOfClass:[NSArray class]] && [JSON filteredArrayUsingPredicate:predicate].count == 0) || [JSON valueForKey:@"error"] == nil)) {
                block(JSON,nil);
            }else {
                NSDictionary *errorDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"Exception thrown by server"] forKeys:[NSArray arrayWithObject:NSLocalizedDescriptionKey]];
                error = [NSError errorWithDomain:@"com.domain.JSONError" code:42 userInfo:errorDictionary];
                block(nil,error);
            }
        }else
            block(nil,error);
    }];
    
}
@end
@interface CTRootViewController () <MJSecondPopupDelegate> {
    NSMutableArray *annotationArray;
}
@property (nonatomic,strong)CTNavigationBar *ctNavigationBar;
@property (nonatomic,retain)NSDictionary *restaurantSummary;
//@property (nonatomic,retain) NSMutableArray *restaurantSASLSummary;
@property(nonatomic,strong) CLLocation *currentLocation;

@property (nonatomic,assign)BOOL isLocationServiceAllowed;
@property (nonatomic,assign)BOOL isFirstTimeFetch;
@property (weak, nonatomic) IBOutlet UIImageView *splashImage;
@property (nonatomic,retain)NSMutableArray *mapMarkersURLImageArray;

@property (nonatomic, assign) BOOL nextRegionChangeIsFromUserInteraction;


@end

@implementation CTRootViewController

@synthesize dictSelectorAndSender;
@synthesize ctNavigationBar;
@synthesize isLoggedIn, lblInfo, btnInfo, isFirstTimeLoaded;
// UI Related Methods
#define MAXIMUM_ZOOM 20
#pragma Scope methods

- (double) getZoomLevel:(MKMapView*)_mapView
{
    return 21.00 - log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width));
}
- (int)zoomLevelForMapRect:(MKMapRect)mRect withMapViewSizeInPixels:(CGSize)viewSizeInPixels
{
    NSUInteger zoomLevel = MAXIMUM_ZOOM; // MAXIMUM_ZOOM is 20 with MapKit
    MKZoomScale zoomScale = mRect.size.width / viewSizeInPixels.width; //MKZoomScale is just a CGFloat typedef
    double zoomExponent = log2(zoomScale);
    zoomLevel = (NSInteger)(MAXIMUM_ZOOM - ceil(zoomExponent));
    return zoomLevel;
}
-(void)performGetRestaurantBySASLOperationForAnnotation:(CTMapAnnotation*)annotation {
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    
    NSLog(@"selected annotation %@ -----%@",annotation.title, annotation.restaurantDictObj);
    NSMutableDictionary *restaurant=(NSMutableDictionary*)annotation.restaurantDictObj;
    [[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
    
    NSString *sa=[restaurant serviceAccommodatorId];
    NSString *sl=[restaurant serviceLocationId];
    
    id address = [restaurant valueForKey:@"address"];
    // call in web view
    //NSString *url= [NSString stringWithFormat:@"http://cmtyapps.com/?serviceAccommodatorId=%@&serviceLocationId=%@",sa,sl];
    NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    
    if ([restaurant valueForKeyPath:@"showURL"] && [[restaurant valueForKeyPath:@"showURL"] boolValue] == YES && [restaurant valueForKeyPath:@"url"]) {
        url = [restaurant valueForKeyPath:@"url"];
    }
    
    
    @try {
        CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController1" bundle:nil];
        webController.isFromRootView = NO;
        webController.strLoadUrl = url;
        webController.delegate = self;
        webController.animationType = MJPopupViewAnimationSlideBottomTop;
        webController.ListTitle = [restaurant name];
        webController.ListAddress = address;
        webController.ListLat = [restaurant valueForKey:@"latitude"];
        NSLog(@"listlat %@",webController.ListLat);
        webController.ListLog = [restaurant valueForKey:@"longitude"];;
        webController.ListCall = [restaurant valueForKey:@"contact"];;
        
        NSLog(@"addresse %@",webController.ListAddress);
        [UIView animateWithDuration:0.35f animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
        }];
        
        [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
    }
    @catch (NSException *exception) {
        NSLog(@"CTRestaurantsMenu TableViewDidSelectRow: %@", exception.name);
        NSLog(@"CTRestaurantsMenu TableViewDidSelectRow: %@", exception.reason);
    }
    @finally {
        
    }
    
    
//    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController1" bundle:nil];
//    webController.isFromRootView = YES;
//    webController.delegate = self;
//    webController.strLoadUrl = url;
//    
//    //    [UIView animateWithDuration:0.35f animations:^{
//    //        self.mapview.frame = CGRectMake(0, self.view.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
//    //    } completion:^(BOOL finished) {
//    ////        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
//    //    }];
//    
//    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
    
    //    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc]initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    //    webController.isFromRootView = YES;
    //    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //    [(UIWebView*)webController.view loadRequest:aRequest];
    //    [self.navigationController pushViewController:webController animated:YES];
    
    
    //    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
    //    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
    ////    if([restaurant inNetwork]){
    //        [CTWebServicesMethods getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon completionBlock:^(NSString *errorTitle, NSString *errorMessage, id JSON) {
    //            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    //            }];
    //            if(JSON) {
    //                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //                    CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
    //                    restaurantController.restaurantDetailsDict=JSON;
    //                    [self.navigationController pushViewController:restaurantController animated:YES];
    //                    // call view before making this request
    //                    restaurantController.view.userInteractionEnabled = YES;
    //                    [restaurantController retriveMediaMetaDatabySaSl];
    //                    [self.mapview deselectAnnotation:[self.mapview.selectedAnnotations lastObject] animated:FALSE];
    //                }];
    //
    //            }else {
    //                // it's an error.
    //                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //                    [CTCommonMethods showErrorAlertMessageWithTitle:errorTitle andMessage:errorMessage];
    //                }];
    //            }
    //        }];
    //        //        [self getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon];
    ////    }
    ////    else{
    ////        [MBProgressHUD hideHUDForView:self.view animated:YES];
    ////        [self openOutOfNetworkviewController:restaurant];
    ////        [self.mapview deselectAnnotation:[self.mapview.selectedAnnotations lastObject] animated:FALSE];
    ////    }
    
}
-(BOOL)canShowMarkerLabelForAnnot:(CTMapAnnotation*)annot {
    int fitAnnotationsZoomLevel = [self zoomLevelForMapRect:zoomRect withMapViewSizeInPixels:self.mapview.frame.size];
    //        int currentZoomLevel = [self zoomLevelForMapRect:self.mapview.visibleMapRect withMapViewSizeInPixels:self.mapview.frame.size];
    double currentZoomLevel = [self.mapview getZoomLevel];
    //    double zoomLevel = [self getZoomLevel:_mapView];
    //    NSLog(@"zoom level %d",currentZoomLevel-fitAnnotationsZoomLevel);
    CTMapAnnotationCalloutView *view_Annotation =(CTMapAnnotationCalloutView*) [self.mapview viewForAnnotation:annot];
    //            if(currentZoomLevel-fitAnnotationsZoomLevel>=kMap_ZoomDifference_To_Show_Details) {
    if(currentZoomLevel >= [CTCommonMethods zoomDifferenceToShowDetails]) {
        calloutVisible = YES;
        return YES;
    }
    else {
        calloutVisible = FALSE;
        return NO;
    }
}

#pragma instance methods
-(void)searchForZipCode:(NSUInteger)zipCode street:(NSString*)street city:(NSString*)city {
    [MBProgressHUD showHUDAddedTo:self.mapview animated:YES];
    NSString *serverName = [CTCommonMethods getChoosenServer];
    NSString *url =[NSString stringWithFormat:@"%@%@domain=ALL&UID=%@&simulate=%@",serverName,CT_getSASLSummaryByUIDAndAddress,[CTCommonMethods UID],[CTCommonMethods simulate]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:zipCode],@"zip",street,@"street",city,@"city", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.mapview animated:YES];
        });
        
        if(connectionError) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:connectionError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }else {
            NSError *jsonError;
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSError *validationError = [CTCommonMethods validateJSON:JSON];
            if(validationError) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:validationError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }else if(jsonError) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:jsonError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }else {
                // validated data.
                NSArray *array = [JSON valueForKey:@"sasls"];
                if(array.count>0) {
                    [self updateMapUIWithFetchedJson:array];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"No record exists for provided details" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }];
}
-(IBAction)zoomBtnTaped:(id)sender {
    self.nextRegionChangeIsFromUserInteraction = NO;
    self.mapview.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
    //    [self.mapview setCenterCoordinate:self.mapview.userLocation.location.coordinate animated:YES];
    printf("\n Zoom scale %f",[self.mapview getZoomLevel]);
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapview.userLocation.location.coordinate;
    mapRegion.span.latitudeDelta = ZoomSpanDelta;
    mapRegion.span.longitudeDelta = ZoomSpanDelta;
    [self.mapview setRegion:mapRegion animated: YES];
    
    if([self.currentLocation distanceFromLocation:[CTCommonMethods getLastLocation]]>0) {
        self.currentLocation = [CTCommonMethods getLastLocation];
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    }
    //    [self.mapview setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark - Control Methods

-(IBAction)MenuBtnTapped:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSLog(@"btn selected = %d",btn.selected);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    //if([CTCommonMethods isUIDStoredInDevice]){
    if (isMenu) {
        CTMenuViewController *vc = [self.childViewControllers lastObject];
        vc.btnblack.hidden = YES;
        CGRect tempRect1 = vc.view.frame;
        tempRect1.origin.x -= (self.view.frame.size.width);
        CGRect tempRect2 = self.mapview.frame;
        //tempRect2.origin.x -= (self.view.frame.size.width -50);
        
        
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(1)]) {
            vc.view.frame = tempRect1;
            self.mapview.frame = tempRect2;
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        else{
            [UIView animateWithDuration:.4 animations:^{
                vc.view.frame = tempRect1;
                self.mapview.frame = tempRect2;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            });
        }
        
        [dictSelectorAndSender removeAllObjects];
        btn.selected = FALSE;
        isMenu = NO;
        
        
    }
    else {
        [dictSelectorAndSender setValue:@(1) forKey:@"index"];
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
            //[self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
        }
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        
        //btn.selected = TRUE;
        CTMenuViewController *menu = [[CTMenuViewController alloc]init];
        
        menu.delegate = parent;
        menu.callerSender = self;
        [self addChildViewController:menu];
        [self.view addSubview:menu.view];
        
        //btn.selected = TRUE;
        
        [dictSelectorAndSender setValue:NSStringFromSelector(@selector(MenuBtnTapped:)) forKey:@"selector"];
        [dictSelectorAndSender setValue:sender forKey:@"sender"];
        [dictSelectorAndSender setValue:@(1) forKey:@"index"];
        int y;
        if (parent.btnTiles.selected)
        {
            y = 0;
        }
        else{
            y= 64;
        }
        CGRect tempRect1 = CGRectMake(-self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height+22 - y);
        
        //        if (parent.btnTiles.selected)
        //        {
        //            y = 0;
        //        }
        //        else{
        //            y= 64;
        //        }
        //        CGRect tempRect1 = CGRectMake(-self.view.frame.size.width, y, self.view.frame.size.width, self.view.frame.size.height+22 - y
        //);
        menu.view.frame = tempRect1;
        CGRect tempRect2 = self.mapview.frame;
        // tempRect2.origin.x += (self.view.frame.size.width - 50);
        tempRect1.origin.x += (self.view.frame.size.width);
        [UIView animateWithDuration:.6 animations:^{
            self.mapview.frame = tempRect2;;
            menu.view.frame = tempRect1;
            
        } completion:^(BOOL finished){
            menu.btnblack.hidden = NO;
        }];
        isMenu = YES;
    }
    
    //    }else {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
    //        alert.tag = 101;
    //        [alert show];
    //    }
}
/*
 -(IBAction)showAdAlertView:(id)sender{
 UIButton* btn = (UIButton*)sender;
 if (btn.selected) {
 UIViewController *vc = [self.childViewControllers lastObject];
 CGRect tempRect1 = vc.view.frame;
 tempRect1.origin.x += (self.view.frame.size.width);
 CGRect tempRect2 = self.mapview.frame;
 tempRect2.origin.x += (self.view.frame.size.width);
 
 
 if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(1)]) {
 vc.view.frame = tempRect1;
 self.mapview.frame = tempRect2;
 [vc.view removeFromSuperview];
 [vc removeFromParentViewController];
 }
 else{
 [UIView animateWithDuration:.4 animations:^{
 vc.view.frame = tempRect1;
 self.mapview.frame = tempRect2;
 }];
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
 [vc.view removeFromSuperview];
 [vc removeFromParentViewController];
 });
 }
 
 [dictSelectorAndSender removeAllObjects];
 btn.selected = FALSE;
 
 
 }
 else {
 [dictSelectorAndSender setValue:@(1) forKey:@"index"];
 if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
 [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
 }
 
 CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
 CTAdAlertViewController *adAlertView = [[CTAdAlertViewController alloc] init];
 adAlertView.delegate = parent;
 adAlertView.callerSender = self;
 [adAlertView reloadTableData];
 [self addChildViewController:adAlertView];
 [self.view addSubview:adAlertView.view];
 
 btn.selected = TRUE;
 
 [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showAdAlertView:)) forKey:@"selector"];
 [dictSelectorAndSender setValue:sender forKey:@"sender"];
 [dictSelectorAndSender setValue:@(1) forKey:@"index"];
 
 CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height+22 -64
 );
 adAlertView.view.frame = tempRect1;
 CGRect tempRect2 = self.mapview.frame;
 tempRect2.origin.x -= (self.view.frame.size.width);
 tempRect1.origin.x -= (self.view.frame.size.width);
 [UIView animateWithDuration:.6 animations:^{
 self.mapview.frame = tempRect2;
 adAlertView.view.frame = tempRect1;
 }];
 }
 }
 */
-(IBAction)showAdAlertView:(id)sender{
    //    UIButton* btn = (UIButton*)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    if([CTCommonMethods isUIDStoredInDevice]){
        //        if (isCREATE)
        //        {
        //            [self dismissViewControllerAnimated:YES completion:nil];
        //            isCREATE = false;
        //        }
        //        else
        //        {
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
            CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
            CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController1" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
            promotion.delegate = parentController;
            promotion.navigationItem.leftBarButtonItem = [self backButton];
            promotion.navigationItem.title = @"Create Promotion";
            //            isCREATE = true;
            [UIView animateWithDuration:0.1 animations:^{
                //                [parentController.navigationController pushViewController:mysupport animated:YES];
                //                [parentController addChildViewController:mysupport];
                //                [parentController.view addSubview:mysupport.view];
                [parentController presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        else
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSlowSasl" object:nil];
        }
        
        //        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        alert.tag = 101;
        [alert show];
    }
    /*
     if([CTCommonMethods isUIDStoredInDevice]){
     if (isCREATE) {
     UIViewController *vc = [self.childViewControllers lastObject];
     CGRect tempRect1 = vc.view.frame;
     tempRect1.origin.x += (self.view.frame.size.width);
     CGRect tempRect2 = self.mapview.frame;
     tempRect2.origin.x += (self.view.frame.size.width);
     
     
     if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(1)]) {
     vc.view.frame = tempRect1;
     self.mapview.frame = tempRect2;
     [vc.view removeFromSuperview];
     [vc removeFromParentViewController];
     }
     else{
     [UIView animateWithDuration:.4 animations:^{
     vc.view.frame = tempRect1;
     self.mapview.frame = tempRect2;
     }];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
     [vc.view removeFromSuperview];
     [vc removeFromParentViewController];
     });
     }
     
     [dictSelectorAndSender removeAllObjects];
     btn.selected = FALSE;
     isCREATE = NO;
     
     }
     else {
     
     [dictSelectorAndSender setValue:@(1) forKey:@"index"];
     if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
     [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
     }
     
     CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
     CTCreateViewController *create = [[CTCreateViewController alloc]init];
     
     create.delegate = parent;
     create.callerSender = self;
     //[adAlertView reloadTableData];
     [self addChildViewController:create];
     [self.view addSubview:create.view];
     
     btn.selected = TRUE;
     isCREATE = YES;
     [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showAdAlertView:)) forKey:@"selector"];
     [dictSelectorAndSender setValue:sender forKey:@"sender"];
     [dictSelectorAndSender setValue:@(1) forKey:@"index"];
     
     CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height+22 -64
     );
     create.view.frame = tempRect1;
     CGRect tempRect2 = self.mapview.frame;
     tempRect2.origin.x -= (self.view.frame.size.width);
     tempRect1.origin.x -= (self.view.frame.size.width);
     [UIView animateWithDuration:.6 animations:^{
     self.mapview.frame = tempRect2;
     create.view.frame = tempRect1;
     }];
     }
     
     }else {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
     alert.tag = 101;
     [alert show];
     }
     */
}
-(void)didTapBackButtonOnFavorites:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
    
}

#pragma mark - List View

-(IBAction)showListView:(id)sender{
    UIButton* btn = (UIButton*)sender;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    if (btn.selected) {
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        NSLog(@"Btn Sleected tile === %d ",parent.btnTiles.selected);
        NSLog(@"Btn Sleected List === %d ",btn.selected);
        if (tileController && parent.btnTiles.selected == NO && btn.selected == YES)
        {
            NSLog(@"condtion TRUE");
            
            
        }
        NSLog(@"List Button selected dictSelectorAndSender = %@",dictSelectorAndSender);
        UIViewController *vc = [self.childViewControllers lastObject];
        CGRect tempRect1 = vc.view.frame;
        tempRect1.origin.x += (self.view.frame.size.width);
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x += (self.view.frame.size.width);
        
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(2)]) {
            vc.view.frame = tempRect1;
            self.mapview.frame = tempRect2;
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        else{
            [UIView animateWithDuration:.4 animations:^{
                vc.view.frame = tempRect1;
                self.mapview.frame = tempRect2;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            });
        }
        
        [dictSelectorAndSender removeAllObjects];
        btn.selected = FALSE;
        
    }
    else {
        [dictSelectorAndSender setValue:@(2) forKey:@"index"];
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
            [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
        }
        
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        
        //        parent.btnTiles.selected = TRUE;
        //        [self showTilesView:parent.btnTiles];
        
        CTRestaurantsMenuViewController * restaurantsMenuView = [[CTRestaurantsMenuViewController alloc] init];
        restaurantsMenuView.delegate = parent;
//        restaurantsMenuView.view.frame =     CGRectMake(self.view.frame.size.width, 64, restaurantsMenuView.view.frame.size.width, restaurantsMenuView.view.frame.size.height+40);
        restaurantsMenuView.callerSender = self;
        [restaurantsMenuView.tableView reloadData];
        [self addChildViewController:restaurantsMenuView];
        [self.view addSubview:restaurantsMenuView.view];
        
        
        [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showListView:)) forKey:@"selector"];
        [dictSelectorAndSender setValue:sender forKey:@"sender"];
        [dictSelectorAndSender setValue:@(2) forKey:@"index"];
        int y = 0;
        if (parent.btnTiles.selected)
        {
            y = 64;
        }
        else{
            y= 64;
        }
        CGRect tempRect1 = CGRectMake(self.view.frame.size.width, y, restaurantsMenuView.view.frame.size.width, restaurantsMenuView.view.frame.size.height+20 -y);
        restaurantsMenuView.view.frame = tempRect1;
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x -= (self.view.frame.size.width);
        tempRect1.origin.x -= (self.view.frame.size.width);
        [UIView animateWithDuration:.6 animations:^{
            self.mapview.frame = tempRect2;
            restaurantsMenuView.view.frame = tempRect1;
        }];
        btn.selected = TRUE;
        //[dictSelectorAndSender removeAllObjects];
         NSLog(@"List Button Unselected dictSelectorAndSender = %@",dictSelectorAndSender);
        // restaurantsMenuView.view.frame = CGRectMake(0, 0, restaurantsMenuView.view.frame.size.width, restaurantsMenuView.view.frame.size.height);
    }
    
}

-(IBAction)TileViewOpen:(id)sender
{
    UIButton* btnnw = (UIButton*)sender;
    
    [dictSelectorAndSender setValue:@(3) forKey:@"index"];
//    if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
//        [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
//    }
    
    CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
    tileController = [[CTTileViewController alloc]initWithStyle:UITableViewStylePlain];
    tileController.delegate = parent;
    
    //btnnw.selected = TRUE;
    
    [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showTilesView1:)) forKey:@"selector"];
    //[dictSelectorAndSender setValue:sender forKey:@"sender"];
    [dictSelectorAndSender setValue:@(3) forKey:@"index"];
    
    [self addChildViewController:tileController];
    [self.view addSubview:tileController.view];
    //    CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, tileController.view.frame.size.width, tileController.view.frame.size.height-40);
    CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, tileController.view.frame.size.width, tileController.view.frame.size.height);
    // CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, tileController.view.frame.size.width, tileController.view.frame.size.height-180);
    tileController.view.frame = tempRect1;
    CGRect tempRect2 = self.mapview.frame;
    tempRect2.origin.x -= (self.view.frame.size.width);
    tempRect1.origin.x -= (self.view.frame.size.width);
    [UIView animateWithDuration:.0 animations:^{
        self.mapview.frame = tempRect2;
        tileController.view.frame = tempRect1;
    }];
    [dictSelectorAndSender removeAllObjects];
    btnnw.selected = FALSE;
    //    [self showOrHideMaskImage];
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMaskImage)];
    //    tapGesture.numberOfTapsRequired = 1;
    //    self.splashImage.userInteractionEnabled = YES;
    //    [self.splashImage addGestureRecognizer:tapGesture];
}


-(IBAction)showTilesView:(id)sender {
    
    UIButton* btn = (UIButton*)sender;
    if (btn.selected) {
        
        UIViewController *vc = [self.childViewControllers lastObject];
        [[NSNotificationCenter defaultCenter]removeObserver:vc name:CT_Observers_MarkerImageDownloaded object:nil];
        //        [[CTRootControllerDataModel sharedInstance]removeObserver:self forKeyPath:@"saslSummaryArray"];
        
        CGRect tempRect1 = vc.view.frame;
        tempRect1.origin.x += (self.view.frame.size.width);
        
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x += (self.view.frame.size.width);
        
        
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(3)]) {
            vc.view.frame = tempRect1;
            self.mapview.frame = tempRect2;
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        else{
            [UIView animateWithDuration:.4 animations:^{
                vc.view.frame = tempRect1;
                self.mapview.frame = tempRect2;
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            });
        }
        
        [dictSelectorAndSender removeAllObjects];
        btn.selected = FALSE;
    }
    else {
        [dictSelectorAndSender setValue:@(3) forKey:@"index"];
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
            [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
        }
        
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        tileController = [[CTTileViewController alloc]initWithStyle:UITableViewStylePlain];
        tileController.delegate = parent;
        
        [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showTilesView:)) forKey:@"selector"];
        [dictSelectorAndSender setValue:sender forKey:@"sender"];
        [dictSelectorAndSender setValue:@(3) forKey:@"index"];
        
        [self addChildViewController:tileController];
        [self.view addSubview:tileController.view];
        CGRect tempRect1 ;
        //        if (btn.selected)
        //        {
        //            tempRect1 = CGRectMake(self.view.frame.size.width, 64, tileController.view.frame.size.width, tileController.view.frame.size.height+40);
        //            btn.selected = TRUE;
        //        }
        //        else
        //        {
        //            tempRect1 = CGRectMake(self.view.frame.size.width, 0, tileController.view.frame.size.width, tileController.view.frame.size.height+22);
        //
        //            btn.selected = TRUE;
        //        }
        
        tempRect1 = CGRectMake(self.view.frame.size.width, 0, tileController.view.frame.size.width, tileController.view.frame.size.height+22);
        btn.selected = TRUE;
        tileController.view.frame = tempRect1;
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x -= (self.view.frame.size.width);
        tempRect1.origin.x -= (self.view.frame.size.width);
        [UIView animateWithDuration:.6 animations:^{
            self.mapview.frame = tempRect2;
            tileController.view.frame = tempRect1;
        }];
        
    }
    [self.navigationController.navigationBar setAlpha:1.];
    //    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:CT_ToolBarTransBg] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:!btn.selected];
    //    [self.navigationController.navigationBar setTranslucent:YES];
    
    //    tileController.view.frame = CGRectMake(0, 64, tileController.view.frame.size.width, tileController.view.frame.size.height-44);
}

#pragma mark - TileView Screen

-(IBAction)showTilesView1:(id)sender {
    
    //    UIButton* btn = (UIButton*)sender;
    //    if (btn.selected) {
    //           }
    //    else {
    //            }
    CTParentViewController *parent1 = (CTParentViewController*)self.navigationController.parentViewController;
    if (parent1.btnList.selected)
    {
        NSLog(@"List sleected");
        [dictSelectorAndSender removeAllObjects];
        if (tileController)
        {
                [tileController.view removeFromSuperview];
             [tileController removeFromParentViewController];
        }
//     [dictSelectorAndSender removeAllObjects];
        [self showListView:parent1.btnList];
    }
    else
    {
        NSLog(@"List sleected Not");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    UIButton* btnnw = (UIButton*)sender;
    if (btnnw.selected) {
        
        [dictSelectorAndSender setValue:@(3) forKey:@"index"];
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil) {
            [self performSelectorOnMainThread:NSSelectorFromString([dictSelectorAndSender valueForKey:@"selector"]) withObject:[dictSelectorAndSender valueForKey:@"sender"] waitUntilDone:YES];
        }
        
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        tileController = [[CTTileViewController alloc]initWithStyle:UITableViewStylePlain];
        tileController.delegate = parent;
        
        
        //btnnw.selected = TRUE;
        
        [dictSelectorAndSender setValue:NSStringFromSelector(@selector(showTilesView1:)) forKey:@"selector"];
        [dictSelectorAndSender setValue:sender forKey:@"sender"];
        [dictSelectorAndSender setValue:@(3) forKey:@"index"];
        
        [self addChildViewController:tileController];
        [self.view addSubview:tileController.view];
        CGRect tempRect1 = CGRectMake(self.view.frame.size.width, 64, tileController.view.frame.size.width, tileController.view.frame.size.height+44);
        tileController.view.frame = tempRect1;
        btnnw.selected = FALSE;
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x -= (self.view.frame.size.width);
        tempRect1.origin.x -= (self.view.frame.size.width);
        [UIView animateWithDuration:.6 animations:^{
            self.mapview.frame = tempRect2;
            tileController.view.frame = tempRect1;
        }];
        [dictSelectorAndSender removeAllObjects];
        
        //isMenu = NO;
        
        NSLog(@"tile Button Selected dictSelectorAndSender = %@",dictSelectorAndSender);
    }
    else
    {
        //        NSLog(@"hello i'm here map");
        //        if (isFirstTimeLoaded) {
        //            //self.mapview.hidden = NO;
        //
        //            [self showOrHideInfoButton];
        //            CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        //            //        [parent filterBtnTaped:nil];
        //            [parent searchBtnTaped:nil];
        //            [parent.rootViewController.locationManager stopUpdatingLocation];
        //        }
        //        else
        //        {
        //UIButton* btn = (UIButton*)sender;
        UIViewController *vc = [self.childViewControllers lastObject];
        CGRect tempRect1 = vc.view.frame;
        tempRect1.origin.x += (self.view.frame.size.width);
        CGRect tempRect2 = self.mapview.frame;
        tempRect2.origin.x += (self.view.frame.size.width);
        
        if ([dictSelectorAndSender valueForKey:@"sender"] != nil && ![[dictSelectorAndSender valueForKey:@"index"] isEqual:@(2)]   ) {
            vc.view.frame = tempRect1;
            self.mapview.frame = tempRect2;
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        else{
            [UIView animateWithDuration:.4 animations:^{
                vc.view.frame = tempRect1;
                self.mapview.frame = tempRect2;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            });
        }
        [dictSelectorAndSender removeAllObjects];
        btnnw.selected = TRUE;
        
        NSLog(@"tile Button Unselected dictSelectorAndSender = %@",dictSelectorAndSender);
        //isMenu = YES;
        //}
    }
    
    //[self.navigationController.navigationBar setAlpha:1.];
    //[self.navigationController.navigationBar setTranslucent:btnnw.selected];
    
    
}


-(void)awakeFromNib {
    [super awakeFromNib];
    [[CTRootControllerDataModel sharedInstance]setSelectedDomain:@"ALL"];
    [[CTRootControllerDataModel sharedInstance]setSelectedCategory:@"UNDEFINED"];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[CTRootControllerDataModel sharedInstance]setSelectedDomain:@"ALL"];
        [[CTRootControllerDataModel sharedInstance]setSelectedCategory:@"UNDEFINED"];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.appearDisappearBlock (YES);
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    //    self.appearDisappearBlock (NO);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CT_Observers_SearchLocation object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    dictSelectorAndSender = [[NSMutableDictionary alloc] init];
    
    if ([defaults valueForKey:UIDInDefaults] != nil && [[defaults valueForKey:UIDInDefaults] length] > 1) {
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        [parent.listMenuController authenticateUser];
    }
    
    [self showLoader];
    // initial request
    self.isFirstTimeFetch=YES;
    if(self.currentLocation == nil)
        self.currentLocation = [CTCommonMethods getLastLocation];
    // selected domain + Category.
    [self observersOfPostNotification];
    [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
    //    [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    // request
    
    // V: filter selection
    isFirstTimeLoaded = YES;
    
    [self intializeMapviewSettings];
    
    //    [self setCustomNavigationBar];
    [self checkiOS7];
    //    [self checkNetworkConnection];
    self.mapMarkersURLImageArray=[[NSMutableArray alloc]init];
    // Pan Gesture for checking map center change
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showPan:)];
    panGesture.delegate = self;
    [self.mapview addGestureRecognizer:panGesture];
    
    btnInfo.hidden = NO;
    
    btnInfo.titleLabel.numberOfLines = 0;
    btnInfo.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    btnInfo.hidden = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        //its iPhone. Find out which one?
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        //        self.splashImage.frame = CGRectMake(self.splashImage.frame.origin.x, self.splashImage.frame.origin.y, result.width, result.height - self.navigationController.toolbar.frame.size.height);
        self.splashImage.frame = CGRectMake(self.splashImage.frame.origin.x, self.splashImage.frame.origin.y, result.width, result.height);
        [self.navigationController.toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        switch ([CTCommonMethods getIPhoneVersion]) {
            case iPhone4:{
                // iPhone Classic
                [self.splashImage setImage:[UIImage imageNamed:@"Default@2x.png"]];
                [self.splashImage setImage:[UIImage imageNamed:@"mask_map.png"]];
                btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 50, 45);
                btnInfo.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:28];
            }
                break;
            case iPhone5:{
                // iPhone 5 35
                [self.splashImage setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
                [self.splashImage setImage:[UIImage imageNamed:@"mask_map_568.png"]];
                btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 60, 30, 60);
                btnInfo.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:32];
            }
                break;
            case iPhone6:{
                // iPhone 6
                [self.splashImage setImage:[UIImage imageNamed:@"Default@2x-1.png"]];
                [self.splashImage setImage:[UIImage imageNamed:@"mask_map_6.png"]];
                btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 40);
                btnInfo.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38];
            }
                break;
            case iPhone6Plus:{
                // iPhone 6 Plus
                [self.splashImage setImage:[UIImage imageNamed:@"Default@3x.png"]];
                [self.splashImage setImage:[UIImage imageNamed:@"mask_map_6plus.png"]];
                btnInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 40);
                btnInfo.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
            }
                break;
            default:
                break;
        }
    }
    
    //[self TileViewOpen];
    
    //self.mapview.hidden = YES;
    //self.splashImage.hidden = !self.splashImage.hidden;
    
    [self showOrHideMaskImage];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMaskImage)];
    tapGesture.numberOfTapsRequired = 1;
    self.splashImage.userInteractionEnabled = YES;
    [self.splashImage addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HideMenu) name:@"HideMenuScreen" object:nil];
    
    //CreateScreen
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CreateOpen) name:@"CreateScreen" object:nil];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GetCityList" object:nil];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"GetCatagoryList" object:nil];
    
    //[CTCommonMethods sharedInstance].NavFlag = NO;
    
    [self GetCityList];
    [self GetCatagoryList];
    
    
    //RightBarButton
    CatagoryListButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CatagoryListButton.hidden = YES;
    [CatagoryListButton setTitle:@"Catagory  ▼" forState:UIControlStateNormal];
    [CatagoryListButton setBackgroundImage:[UIImage imageNamed:@"chaticonNew.png"] forState:UIControlStateNormal];
    CatagoryListButton.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    CatagoryListButton.backgroundColor = [UIColor colorWithRed:19/255.0f green:90/255.0f blue:255/255.0f alpha:1];
    CatagoryListButton.layer.borderColor = [UIColor blackColor].CGColor;
    CatagoryListButton.layer.borderWidth = 2;
    CatagoryListButton.layer.cornerRadius = 4;
    CatagoryListButton.frame = CGRectMake(100, 100, 120, 25);
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc] initWithCustomView:CatagoryListButton];
    [CatagoryListButton addTarget:self action:@selector(CatagorySidedButton:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"City" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu:)];
    self.navigationItem.rightBarButtonItem = barButton;
    //RightBarButton
    
    
    //LeftBarButton
    CityListButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CityListButton.hidden = YES;
    [CityListButton setTitle:@"City         ▼" forState:UIControlStateNormal];
    [CityListButton setBackgroundImage:[UIImage imageNamed:@"chaticonNew.png"] forState:UIControlStateNormal];
    CityListButton.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    CityListButton.backgroundColor = [UIColor colorWithRed:19/255.0f green:90/255.0f blue:255/255.0f alpha:1];
    CityListButton.layer.borderColor = [UIColor blackColor].CGColor;
    CityListButton.layer.borderWidth = 2;
    CityListButton.layer.cornerRadius = 4;
    CityListButton.frame = CGRectMake(100, 100, 120, 25);
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc] initWithCustomView:CityListButton];
    [CityListButton addTarget:self action:@selector(CitySidedButton:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"City" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //NSArray *array = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", nil];
    
    
    //    self.selectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 200, CGRectGetWidth(self.view.frame), 20.0)];
    //    self.selectionLabel.textAlignment = NSTextAlignmentCenter;
    //    self.selectionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    self.selectionLabel.text = self.dropdownMenuView.items[self.dropdownMenuView.selectedItemIndex];
    //    [self.view addSubview:self.selectionLabel];
    
    //    UIBarButtonItem *barButtonItemnw = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu:)];
    //    self.navigationItem.rightBarButtonItem = barButtonItemnw;
    //LeftBarButton
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DropDownHide:) name:@"DropDownHide" object:nil];
}

- (void)DropDownHide:(NSNotification *)note
{
    if ([CTCommonMethods sharedInstance].NavFlag == YES)
    {
        [self.dropdownViewController dismissDropdownAnimated:YES];
    }
    else
    {
        [self.dropdownViewController1 dismissDropdownAnimated:YES];
    }
}

#pragma mark - DropDown
- (void)dropMenuChanged:(MISDropdownMenuView *)dropDownMenuView
{
    [self.dropdownViewController dismissDropdownAnimated:YES];
    [self.dropdownViewController1 dismissDropdownAnimated:YES];
    
    NSInteger selectedItemIndex = [dropDownMenuView selectedItemIndex];
    
    CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
    if(parent.rootViewController.isFirstTimeLoaded){
        parent.rootViewController.isFirstTimeLoaded = NO;
        [parent.rootViewController showOrHideInfoButton];
        [parent.rootViewController.locationManager stopUpdatingLocation];
    }
 
    if ([CTCommonMethods sharedInstance].NavFlag == YES)
    {
        [CityListButton setTitle:dropDownMenuView.items[selectedItemIndex] forState:UIControlStateNormal];
        //CityListButton.titleLabel.text = dropDownMenuView.items[selectedItemIndex];
        NSLog(@"city search %@",[CTCommonMethods sharedInstance].SearchCitySelector);
        if ([CTCommonMethods sharedInstance].SearchCitySelector) {
            if ([[CTCommonMethods sharedInstance].SearchCitySelector count] > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self userInfo:[[CTCommonMethods sharedInstance].SearchCitySelector objectAtIndex:selectedItemIndex]];
                NSLog(@"indexpath %ld",(long)[dropDownMenuView selectedItemIndex]);
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self];
                NSLog(@"indexpathnw %ld",(long)[dropDownMenuView selectedItemIndex]);
            }
            //[self hideFilterPicker:YES];
            return;
        }
    }
    else
    {
        CatagoryListButton.titleLabel.text = dropDownMenuView.items[selectedItemIndex];
        
        
        NSString *filter = @"UNKNOWN";
        //    if(selectedRow <[CTDataModel_FilterViewController sharedInstance].filterOptions.count)
        
        filter = [[CTDataModel_FilterViewController sharedInstance].filterOptions category:selectedItemIndex];
        

        //NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].domains enumText:selectedDomainRow],@"domain",filter,@"category", nil];
        NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].filterOptions domain:selectedItemIndex],@"domain",filter,@"category", nil];
        NSLog(@"hello user %ld",(long)selectedItemIndex);
        NSLog(@"Print this Dict %@",selectedCategoryName);
        [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_FilterCategory object:self userInfo:selectedCategoryName];
    }
    //[CTCommonMethods sharedInstance].SearchCitySelector
    //self.dropdownMenuView.title = dropDownMenuView.items[selectedItemIndex];
    //self.dropdownViewController.title = dropDownMenuView.items[selectedItemIndex];
    //self.selectionLabel.text = dropDownMenuView.items[selectedItemIndex];
}

- (void)CitySidedButton:(id)sender
{
    [CTCommonMethods sharedInstance].NavFlag = YES;
    if (self.dropdownViewController == nil) {
        // Prepare content view
        CGFloat width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 320.0 : self.view.bounds.size.width;
        CGSize size = [self.dropdownMenuView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        self.dropdownMenuView.frame = CGRectMake(self.dropdownMenuView.frame.origin.x, self.dropdownMenuView.frame.origin.y, size.width, 300);
        NSLog(@"dropdown x %f",self.dropdownMenuView.frame.origin.x);
        NSLog(@"dropdown y %f",self.dropdownMenuView.frame.origin.y);
        
        self.dropdownViewController = [[MISDropdownViewController alloc] initWithPresentationMode:MISDropdownViewControllerPresentationModeAutomatic];
        self.dropdownViewController.contentView = self.dropdownMenuView;
    }
    
    // Show/hide dropdown view
    if ([self.dropdownViewController isDropdownVisible]) {
        [self.dropdownViewController dismissDropdownAnimated:YES];
        return;
    }
    
    // Sender is UIBarButtonItem
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [self.dropdownViewController presentDropdownFromBarButtonItem:sender inViewController:self position:MISDropdownViewControllerPositionTop];
        return;
    }
    
    // Sender is UIButton
    CGRect rect = [sender convertRect:[sender bounds] toView:self.view];
    [self.dropdownViewController presentDropdownFromRect:rect inViewController:self position:MISDropdownViewControllerPositionBottom];
    [self.dropdownViewController1 dismissDropdownAnimated:YES];
}

- (void)CatagorySidedButton:(id)sender
{
    [CTCommonMethods sharedInstance].NavFlag = NO;
    if (self.dropdownViewController1 == nil) {
        // Prepare content view
        CGFloat width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 320.0 : self.view.bounds.size.width;
        CGSize size = [self.dropdownMenuView1 sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        self.dropdownMenuView1.frame = CGRectMake(self.dropdownMenuView1.frame.origin.x, self.dropdownMenuView1.frame.origin.y, size.width, 300);
        NSLog(@"dropdown x %f",self.dropdownMenuView1.frame.origin.x);
        NSLog(@"dropdown y %f",self.dropdownMenuView1.frame.origin.y);
        
        self.dropdownViewController1 = [[MISDropdownViewController alloc] initWithPresentationMode:MISDropdownViewControllerPresentationModeAutomatic];
        self.dropdownViewController1.contentView = self.dropdownMenuView1;
    }
    
    // Show/hide dropdown view
    if ([self.dropdownViewController1 isDropdownVisible]) {
        [self.dropdownViewController1 dismissDropdownAnimated:YES];
        return;
    }
    
    // Sender is UIBarButtonItem
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [self.dropdownViewController1 presentDropdownFromBarButtonItem:sender inViewController:self position:MISDropdownViewControllerPositionTop];
        return;
    }
    
    // Sender is UIButton
    CGRect rect = [sender convertRect:[sender bounds] toView:self.view];
    [self.dropdownViewController1 presentDropdownFromRect:rect inViewController:self position:MISDropdownViewControllerPositionBottom];
    [self.dropdownViewController dismissDropdownAnimated:YES];
}

-(void)GetCityList
{
    //    NSString *urlString=[NSString stringWithFormat:@"%@sasl/retrieveClusterLatLongs",[CTCommonMethods getChoosenServer]];
    //    NSLog(@"URL get City %@",urlString);
    //    NSURL *url=[NSURL URLWithString:urlString];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    //MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    //hud.mode=MBProgressHUDModeIndeterminate;
    //    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    //        //NSLog(@"JSON Get City== %@",JSON);
    //        City_List = [JSON valueForKey:@"displayText"];
    //        NSLog(@"city selector %@",City_List);
    //
    //
    //        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //
    //        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    //        if(error) {
    //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
    //        }else {
    //            NSLog(@"FAILED");
    //            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
    //            if(jsonError)
    //                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
    //            else
    //                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
    //        }
    //    }];
    //
    //    [operation start];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    NSString *url=[NSString stringWithFormat:@"%@sasl/retrieveClusterLatLongs",[CTCommonMethods getChoosenServer]];
    NSLog(@"my url %@",url);
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_GET contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (JSON) {
                @try {
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:@{@"displayText":@"Current Location",
                                                                                          @"latitude":@(self.mapview.userLocation.coordinate.latitude),
                                                                                          @"longitude":@(self.mapview.userLocation.coordinate.longitude)
                                                                                          }, nil];
                    [tempArray addObjectsFromArray:JSON];
                    City_List = [[NSMutableArray alloc]init];
                    citysearch = [[NSMutableArray alloc]init];
                    citysearch = tempArray;
                    for (int i =0; i<tempArray.count; i++)
                    {
                        [City_List addObject: [tempArray[i] valueForKey:@"displayText"]];
                        
                    }
                    self.dropdownMenuView = [[MISDropdownMenuView alloc] initWithItems:City_List];
                    self.dropdownMenuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [self.dropdownMenuView addTarget:self action:@selector(dropMenuChanged:) forControlEvents:UIControlEventValueChanged];
                    
                    [CTCommonMethods sharedInstance].SearchCitySelector = tempArray;
                    filterViewController.searchResult = tempArray;
                    //selectedMenuController = filterViewController;
                    //hitDetectionView.userInteractionEnabled = FALSE;
                    if([filterViewController isVisible])
                        [filterViewController hideFilterPicker:YES];
                    else
                        [filterViewController showFilterPicker:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in searchBtnTaped %@",exception);
                }
            }
            //NSLog(@"searchBtnTaped Response JSON = %@",JSON);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"searchBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
    
    return;
    
    //    selectedMenuController = searchController;
    //    hitDetectionView.userInteractionEnabled = YES;
    //    if([searchController isVisible]) {
    //        panGesture.enabled = NO;
    //        [searchController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    //    }
    //    else {
    //        panGesture.enabled = YES;
    //        [searchController showMenu:YES withRootNavController:self.rootViewController.navigationController];
    //    }
}

-(void)GetCatagoryList
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    [[CTDataModel_FilterViewController sharedInstance]getDomainAndFilterOptions:^(NSArray *array, NSError *error) {
        //NSLog(@"array %@",[[CTDataModel_FilterViewController sharedInstance].filterOptions valueForKey:@"displayText"]);
        Catagory_List = [[CTDataModel_FilterViewController sharedInstance].filterOptions valueForKey:@"displayText"];
        //NSLog(@"I'm Selected %@",Catagory_List);
        self.dropdownMenuView1 = [[MISDropdownMenuView alloc] initWithItems:Catagory_List];
        self.dropdownMenuView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.dropdownMenuView1 addTarget:self action:@selector(dropMenuChanged:) forControlEvents:UIControlEventValueChanged];
        //[self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
        if(array && array.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[SelectButton setTitle:@"Select Catagory" forState:UIControlStateNormal];
                //SelectButton.titleLabel.text = @"Select Category";
               // [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
                //[self.pickerView selectRow:0 inComponent:0 animated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:FALSE];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([CTDataModel_FilterViewController sharedInstance].filterOptions.count>0)
                   // [self.pickerView selectRow:0 inComponent:0 animated:NO];
                [MBProgressHUD hideHUDForView:self.view animated:FALSE];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Community" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            });
        }
    }];
}



-(void)HideMenu
{
    NSLog(@"call this menu hide");
    UIButton * btn = [[UIButton alloc] init];
    btn.highlighted = YES;
    [btn setSelected:YES];
    //[btn addTarget:self action:@selector(MenuBtnTapped:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:btn];
    [self MenuBtnTapped:btn];
}
-(void)CreateOpen
{
    UIButton * btn = [[UIButton alloc] init];
    btn.highlighted = YES;
    [btn setSelected:YES];
    //    //[btn addTarget:self action:@selector(MenuBtnTapped:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:btn];
    [self showAdAlertView:btn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJPopup
- (void)dismissSubViewWithAnimation {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    [UIView animateWithDuration:0.35f animations:^{
        //        self.mapview.frame = CGRectMake(0, self.view.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
    } completion:^(BOOL finished) {
        //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
    }];
}
-(IBAction)showMapView:(id)sender {
    
    //UIButton* btn = (UIButton*)sender;
    
    NSLog(@"hello i'm here map");
    if (isFirstTimeLoaded) {
        //self.mapview.hidden = NO;
        [self showOrHideInfoButton];
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        //        [parent filterBtnTaped:nil];
        [parent searchBtnTaped:nil];
        [parent.rootViewController.locationManager stopUpdatingLocation];
    }
    
}
- (void)showOrHideMaskImage{
    //    [self showLoader];
    
    // V: filter selection
    if (isFirstTimeLoaded) {
        [self showOrHideInfoButton];
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        //        [parent filterBtnTaped:nil];
        [parent searchBtnTaped:nil];
        [parent.rootViewController.locationManager stopUpdatingLocation];
    }
    self.splashImage.hidden = !self.splashImage.hidden;
}

// V: filter selection
- (void)showOrHideInfoButton{
    [self performSelector:@selector(hideinfo) withObject:nil afterDelay:1.0];
    
    //    NSLog(@"isFirstTimeLoaded = %d",isFirstTimeLoaded);
    tileController.imageview.hidden = [CTCommonMethods sharedInstance].SPLASHIMAGE;
}
-(void)hideinfo
{
    btnInfo.hidden = !isFirstTimeLoaded;
}
#pragma mark show Loader
-(void)showLoader{
    
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.splashImage animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    //    hud.labelText=@"Please wait...";
    [self.navigationController.view addSubview:self.splashImage];
    [self.navigationController.view bringSubviewToFront:self.splashImage];
}
#pragma mark remove loader
-(void)removeLoader{
    [MBProgressHUD hideHUDForView:self.splashImage animated:YES];
    //    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    //    [self.splashImage removeFromSuperview];
    if (!self.splashImage.hidden && isFirstTimeLoaded) {
        [self showOrHideInfoButton];
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        [parent filterBtnTaped:nil];
    }
    self.splashImage.hidden = YES;
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:CT_ToolBarTransBg] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
//#pragma mark network check
//-(void)checkNetworkConnection{
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
//    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
//        NSLog(@"%d", status);
//
//        if (client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN ||
//            client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ) {
//            NSLog(@"connection");
//            [self intializeMapviewSettings];
//        }
//        else {
//            NSLog(@"fail");
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:CT_ServerNotAccessibleTitle message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
//            alertView.tag = CT_AlertTagServerNotAccessible;
//            [alertView show];
////            [CTCommonMethods showErrorAlertMessageWithTitle:@"No Network Connection" andMessage:@"Please check your internet connection settings"];
//             [MBProgressHUD hideHUDForView:self.splashImage animated:YES];
//        }
//    }];
//}

#pragma mark observers
-(void)observersOfPostNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedCategory:) name:CT_Observers_FilterCategory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchForSelectedLocation:) name:CT_Observers_SearchLocation object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSuccessfullyLoggedIn:) name:CT_Observers_SuccessfullyLogedIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSuccessfullyLoggedOut:) name:CT_Observers_SuccessfullyLogedOut object:nil];
    
}
-(void)didSuccessfullyLoggedOut:(NSNotification*)notif {
    isLoggedIn = NO;
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    //    if (isLoggedIn) {
    //
    //    }
    //    else
    //    {
    [parentController.favoriteButton setImage:[UIImage imageNamed:CT_FavoriteIcon] forState:UIControlStateNormal];
    [parentController.favoriteButton setTitle:@"Sign-in" forState:UIControlStateNormal];
    //    }
    
    [parentController favotiteButton];
}
-(void)didSuccessfullyLoggedIn:(NSNotification*)notif {
    isLoggedIn = YES;
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    NSLog(@"[parentController.favoriteButton titleForState:UIControlStateNormal] %@",[parentController.favoriteButton titleForState:UIControlStateNormal]);
    [parentController.favoriteButton setImage:[UIImage imageNamed:CT_SignOutIcon] forState:UIControlStateNormal];
    [parentController.favoriteButton setTitle:@"Sign-out" forState:UIControlStateNormal];
    [self.mapview removeAnnotations:self.mapview.annotations];
    [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    [parentController.listMenuController reloadTableData];
}
-(void)selectedCategory:(NSNotification *)notification{
    NSDictionary *categoryDic=[notification userInfo];
    //NSLog(@"catagoryDic %@",categoryDic);
    if (categoryDic == NULL)
    {
        [CatagoryListButton setTitle:@"Catagory  ▼" forState:UIControlStateNormal];
        //NSLog(@"hello null");
    }
//    else
//    {
//        [CatagoryListButton setTitle:[NSString stringWithFormat:@"%@",[categoryDic valueForKeyPath:@"domain"]] forState:UIControlStateNormal];
//       //NSLog(@"ya it's me");
//    }
    
    NSString *selectedDomain=[categoryDic objectForKey:@"domain"];
    NSLog(@"it's me dom%@",selectedDomain);
    NSString *selectedDomainw=[categoryDic objectForKey:@"displayText"];
    NSLog(@"it's me %@",selectedDomainw);
    NSString *selectedCategory=[categoryDic objectForKey:@"category"];
    if([selectedDomain isEqualToString:@"All"])
        selectedCategory = @"UNDEFINED";
    [[CTRootControllerDataModel sharedInstance]setSelectedCategory:selectedCategory];
    [[CTRootControllerDataModel sharedInstance]setSelectedDomain:selectedDomain];
    NSLog(@"ROOT DOMAIN %@",selectedCategory);
    NSLog(@"ROOT CATEGORY %@",selectedDomain);
    
    [self.mapview removeAnnotations:annotationArray];
    [self.mapview reloadInputViews];
    [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    [self.mapview reloadInputViews];
}

-(void)searchForSelectedLocation:(NSNotification *)notification{
    
    // V: filter selection
    if (isFirstTimeLoaded) {
        isFirstTimeLoaded = NO;
        CityListButton.hidden = NO;
        CatagoryListButton.hidden = NO;
        NSLog(@"FirstTime");
    }
    else{
        NSLog(@"allTime");
        
    }
    
    NSDictionary *categoryDic=[notification userInfo];
    //NSLog(@"hello dict %@",categoryDic);
    [CityListButton setTitle:[NSString stringWithFormat:@"%@",[categoryDic valueForKeyPath:@"displayText"]] forState:UIControlStateNormal];
    if ([[categoryDic valueForKeyPath:@"displayText"] isEqualToString:@"Current Location"]) {
        [self zoomBtnTaped:nil];
    }
    else{
        double latitude, longitude;
        longitude = [[categoryDic valueForKey:@"longitude"] doubleValue];
        latitude  = [[categoryDic valueForKey:@"latitude"]  doubleValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        MKCoordinateRegion mapRegion;
        mapRegion.center = loc.coordinate;
        mapRegion.span.latitudeDelta = ZoomSpanDelta;
        mapRegion.span.longitudeDelta = ZoomSpanDelta;
        [self.mapview setRegion:mapRegion animated: YES];
        [self.mapview removeAnnotations:annotationArray];
        [self.mapview reloadInputViews];
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:loc];
        [self.mapview reloadInputViews];
    }
    //    UIButton * btn = [[UIButton alloc] init];
    //    btn.highlighted = YES;
    //    [btn setSelected:YES];
    //    //[btn addTarget:self action:@selector(MenuBtnTapped:) forControlEvents:UIControlEventTouchDragInside];
    //    [self.view addSubview:btn];
    //    [self showTilesView:btn];
}

-(void)sendEmail:(id)sender {
    NSLog(@"send email");
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc]init];
    if(controller) {
        [controller setSubject:@"check app logs"];
        [controller setToRecipients:[NSArray arrayWithObject:@"SeriousDeveloper@gmail.com"]];
        NSString *logfile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/console.log"];
        [controller addAttachmentData:[[NSData alloc]initWithContentsOfFile:logfile] mimeType:@"text/plain" fileName:@"console.log"];
        controller.mailComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark create custom navigation bar
-(void)setCustomNavigationBar{
    self.ctNavigationBar=[[CTNavigationBar alloc]init];
    self.ctNavigationBar.navigationController=self.navigationController;
    self.ctNavigationBar.sliderView=self.view;
    [self.view addSubview:[self.ctNavigationBar restuarantListSliderMenu]];
    [self.view addSubview:[self.ctNavigationBar sliderMainMenu]];
    [self.view addSubview:[self.ctNavigationBar filterPopupMenu]];
    [self.view addSubview:[self.ctNavigationBar favoriteListView]];
    //    self.ctNavigationBar.isRestaurantSlideout=YES;
    //    self.ctNavigationBar.isMainMenuSlideOut=YES;
    //    self.ctNavigationBar.isFilterPopup=YES;
    //    self.ctNavigationBar.isFavoriteList=YES;
    self.ctNavigationBar.slideMainMenu.isMessageControllerIsOpen=YES;
    // self.navigationItem.leftBarButtonItem=[self.ctNavigationBar  setFilterButton];
    //    UIBarButtonItem *temp = [[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(sendEmail:)];
    UIBarButtonItem *space = [self.ctNavigationBar spaceButton];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:space,[self.ctNavigationBar setFilterButton],space,[self.ctNavigationBar setFavotiteButton] ,space,[self.ctNavigationBar setListButton],space,[self.ctNavigationBar setMenuButton],space,nil];
    //    self.navigationItem.titleView=[self.ctNavigationBar setListButton];
    //    self.navigationItem.rightBarButtonItem=[self.ctNavigationBar setMenuButton];
    
}

-(UIBarButtonItem *)setFilterButton{
    
    UIButton *filterButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setFrame:CGRectMake(0, 0, 25, 25)];
    [filterButton setImage:[UIImage imageNamed:CT_FilterIcon] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(showFilter:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:filterButton];
    return leftBarbutton;
    
}
-(UIBarButtonItem *)setMenuButton{
    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [menuButton setImage:[UIImage imageNamed:CT_MenuIcon] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showListMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    return  rightBarButton;
}

#pragma mark iOS7 check
-(void)checkiOS7{
    
    //    if(isIOS7){
    //        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                      forBarMetrics:UIBarMetricsDefault];
    //        self.navigationController.navigationBar.shadowImage = [UIImage new];
    //        self.navigationController.navigationBar.translucent = YES;
    //        self.navigationController.view.backgroundColor = [UIColor clearColor];
    //        self.edgesForExtendedLayout=UIRectEdgeNone;
    //    }
    
}

#pragma mark mapview
-(void)intializeMapviewSettings{
    if(!self.mapview) {
        self.mapview.delegate=self;
        self.mapview.mapType=MKMapTypeStandard;
        self.mapview.showsPointsOfInterest = FALSE;
        
        // show user location
        self.mapview.showsUserLocation = NO;
    }
    // load map first
    
    //self.mapview.showsUserLocation=YES;
    if(!self.locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        self.locationManager.distanceFilter =kCLLocationAccuracyKilometer;
        if([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        // V: commented out due to startup bug
        // [self.locationManager startUpdatingLocation];
    }
}

#pragma marl location manager delegate calls
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //    if(self.currentLocation == nil) {
    //        self.currentLocation = [CTCommonMethods getDefaultLocation];
    //        if([[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] && [[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude])
    //            self.currentLocation = [[CLLocation alloc]initWithLatitude:[[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue] longitude:[[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue]];
    //    }
    
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            self.isLocationServiceAllowed=YES;
            if(self.isFirstTimeFetch){
                //                self.isFirstTimeFetch=NO;
                //                [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
            }
            break;
        case kCLAuthorizationStatusDenied: {
            //            self.currentLocation = [CTCommonMethods getLastLocation];
            self.isLocationServiceAllowed=NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LocationDisabledTitle message:CT_LocationDisbaledMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter Address", nil];
            alert.tag = CT_AlertTagLocationServicesDisabled;
            [alert show];
            //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
            
            //            [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            //            self.currentLocation = [CTCommonMethods getLastLocation];
            self.isLocationServiceAllowed=NO;
            //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
            //            [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
            break;
        case kCLAuthorizationStatusRestricted: {
            //            self.currentLocation = [CTCommonMethods getLastLocation];
            self.isLocationServiceAllowed=NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LocationDisabledTitle message:CT_LocationDisbaledMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter Address", nil];
            alert.tag = CT_AlertTagLocationServicesDisabled;
            [alert show];
            //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
            //            [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
        }
            break;
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (isFirstTimeLoaded)
        return;
    CLLocationDistance meters = [[locations firstObject] distanceFromLocation:[locations lastObject]];
    meters = meters/1000;
    NSLog(@"distance is %f",meters);
    //    if(meters>=kMap_ScrollL_Update_Distance_KM || self.currentLocation == nil || self.isFirstTimeFetch) {
    self.currentLocation = [locations lastObject];
    [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
    NSLog(@"last location %@",self.currentLocation);
    //    if (btnInfo.hidden)
    [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    self.isFirstTimeFetch = NO;
    //    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if (isFirstTimeLoaded)
        return;
    
    CLLocationDistance meters = [oldLocation distanceFromLocation:newLocation];
    meters = meters/1000;
    NSLog(@"distance is %f",meters);
    //    if(meters>=kMap_ScrollL_Update_Distance_KM || self.currentLocation == nil || self.isFirstTimeFetch) {
    self.currentLocation = newLocation;
    [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
    NSLog(@"last location %@",self.currentLocation);
    //    if (btnInfo.hidden)
    [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    self.isFirstTimeFetch = NO;
    //    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (isFirstTimeLoaded)
        return;
    
    NSLog(@"failed location");
    if(self.isLocationServiceAllowed) {
        //    if(self.currentLocation == nil) {
        self.currentLocation = [CTCommonMethods getLastLocation];
        NSLog(@"last location %@",self.currentLocation);
        [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
        //        if (btnInfo.hidden)
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    }
    self.isLocationServiceAllowed = YES;
    //    }
    //    if(isRequestInProgress  == FALSE)
    //        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
}
-(void)refreshMapviewAnnotation{
    if(isRequestInProgress == FALSE) {
        
        self.restaurantSummary=nil;
        //        self.restaurantSASLSummary=nil;
        [self.mapview removeAnnotations:annotationArray];
        [self.mapview reloadInputViews];
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:[[CLLocation alloc]initWithLatitude:self.mapview.centerCoordinate.latitude longitude:self.mapview.centerCoordinate.longitude]];
        [self.mapview reloadInputViews];
    }
    
}
- (void)showPan:(UIPanGestureRecognizer*)panGesture
{
    if(panGesture.state == UIGestureRecognizerStateEnded) {
        didPan = YES;
        //        CLLocation *centerLocatoin = [[CLLocation alloc]initWithLatitude:self.mapview.region.center.latitude longitude:self.mapview.region.center.longitude];
        //        CGFloat latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue];
        //        CGFloat longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue];
        //        CLLocationDistance meters = [centerLocatoin distanceFromLocation:[[CLLocation alloc]initWithLatitude:latitude longitude:longitude]];
        //        meters = meters/1000;
        //        NSLog(@"distance is %f",meters);
        //        //        NSLog(@"TRANSLATION %@ to location %f %f",NSStringFromCGPoint(translation),mapView.region.center.latitude,mapView.region.center.longitude);
        //        if(meters>=kMap_ScrollL_Update_Distance_KM) {
        //            [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.mapview.region.center.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.mapview.region.center.longitude]];
        //            [self refreshMapviewAnnotation];
        //        }
        [panGesture setTranslation:CGPointZero inView:[panGesture.view superview]];
        
    }
}

#pragma mark getRestaurantSummaryByUIDAndLocation webservice call
-(void)getRestaurantSASLSummaryByUIDAndLocationForLocation:(CLLocation*)location{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    NSLog(@"SERVER %@",CT_Server);
    NSString *restaurantSummaryUrl=[self getLocalResaturantSASLSummaryURLForLocation:location];
    NSLog(@"Restro URL %@",restaurantSummaryUrl);
    NSURL *url=[NSURL URLWithString:restaurantSummaryUrl];
    NSURLRequest *requestUrl=[NSURLRequest requestWithURL:url];
    isRequestInProgress = YES;
    CTGetRestaurantSummaryRequest *webservice = [CTGetRestaurantSummaryRequest sharedInstance];
    webservice.delegate = self;
    [MBProgressHUD hideHUDForView:self.mapview animated:YES];
    [webservice sendRequest:requestUrl];
    //    [NSURLConnection sendAsynchronousRequest:requestUrl queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //        isRequestInProgress = FALSE;
    //        id JSON = nil;
    //        if(data)
    //            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //        if(!connectionError && JSON && [JSON valueForKey:@"error"] == nil) {
    //            [self performSelectorOnMainThread:@selector(removeLoader) withObject:nil waitUntilDone:FALSE];
    //            id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //            self.restaurantSummary=(NSDictionary *)JSON;
    //            self.restaurantSASLSummary=(NSArray *)JSON;
    //            [self performSelectorOnMainThread:@selector(updateMapViewBySASL) withObject:nil waitUntilDone:FALSE];
    ////            NSLog(@"str response is %@ %@",str,NSStringFromClass([str class]));
    //        }else {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                UIAlertView *alertView= nil;
    //                if(connectionError)
    //                    alertView = [[UIAlertView alloc]initWithTitle:connectionError.localizedDescription message:connectionError.localizedRecoverySuggestion delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    //                else
    //                    alertView = [[UIAlertView alloc]initWithTitle:CT_ServerNotAccessibleTitle message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    //                alertView.tag = CT_AlertTagServerNotAccessible;
    //                [alertView show];
    //            });
    //
    //        }
    //    }];
    //    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:requestUrl success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    //        isRequestInProgress = FALSE;
    //        [self removeLoader];
    //        self.restaurantSummary=(NSDictionary *)JSON;
    //        self.restaurantSASLSummary=(NSArray *)JSON;
    //        // this will save the last location as well i.e (Center of the map).
    ////        [self updateMapViewBySASL];
    //
    //        [self.mapview reloadInputViews];
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    ////        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_ErrorMessage_ForGetSASLSummaryByUIDAndLocation];
    ////         [self removeLoader];
    //        isRequestInProgress = FALSE;
    //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:CT_ServerNotAccessibleTitle message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    //        alertView.tag = CT_AlertTagServerNotAccessible;
    //        [alertView show];
    //    }];
    //    [operation start];
}
#pragma mark store latitude and longitude
-(void)saveToCacheLatitude:(NSString *)lat andLongitude:(NSString *)lon{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:lat forKey:CT_Latitude];
    [defaults setObject:lon forKey:CT_Longitude];
    [defaults synchronize];
}
#pragma mark parse response and update to mapview
-(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations
{
    double minLat=90.0f, maxLat=-90.0f;
    double minLon=180.0f, maxLon=-180.0f;
    
    for (id<MKAnnotation> mka in annotations) {
        if ( mka.coordinate.latitude  < minLat ) minLat = mka.coordinate.latitude;
        if ( mka.coordinate.latitude  > maxLat ) maxLat = mka.coordinate.latitude;
        if ( mka.coordinate.longitude < minLon ) minLon = mka.coordinate.longitude;
        if ( mka.coordinate.longitude > maxLon ) maxLon = mka.coordinate.longitude;
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0, (minLon+maxLon)/2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(ZoomSpanDelta, ZoomSpanDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake (center, span);
    
    return region;
}
-(void)removeMask {
    [self.hintMask removeFromSuperview];
    //    self.compBlock(YES);
}
-(void)updateMapViewBySASL{
    
    /*
     //Load map icon by URL
     [self loadMapMarkerURLFromBackgroundTask];
     NSData *serializeObj=[NSKeyedArchiver archivedDataWithRootObject:self.restaurantSASLSummary];
     [[NSUserDefaults standardUserDefaults]setObject:serializeObj forKey:@"saslSummary"];
     [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_RestaurantListData object:self];
     */
    //    [[CTRootControllerDataModel sharedInstance]setSaslSummaryArray:self.restaurantSASLSummary];
    [self.mapview removeAnnotations:self.mapview.annotations];
    [[Multitasking sharedInstance]addAnnotationsFromRestSummaryArray:[CTRootControllerDataModel sharedInstance].saslSummaryArray andSelectedCategory:[[CTRootControllerDataModel sharedInstance]selectedCategory] parent:self completionBlock:^(NSArray *annotations) {
        annotationArray = [NSMutableArray arrayWithArray:annotations];
        dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"ADDED ANNOTATIONS IN ARRAY %@",annotationArray);
            
            // save last know location.
            //            [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
            // set map's zoom level
            zoomRect = MKMapRectNull;
            for (id <MKAnnotation> annotation in annotationArray)
            {
                if([annotation isKindOfClass:[MKUserLocation class]] == FALSE) {
                    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0 , 0);
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
            }
            //    [self.mapview setRegion:region];
            // V: Change for Zoom View
            [self regionForAnnotations:annotationArray];
            //            MKCoordinateRegion region = [self regionForAnnotations:annotationArray];
            //            [self.mapview setRegion:region];
            
            //            zoomRect = [self.mapview adjustRectForZoomOut:zoomRect];
            //            [self.mapview setVisibleMapRect:zoomRect animated:FALSE];
            
            //            [self.mapview setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(100, 50, 50, 50) animated:YES];
            //            [self zoomToFitMapAnnotations:self.mapview];
            [self removeLoader];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadList" object:nil];
            // show hint mask if it's first time
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"FirstTimeMapLoaded"] == nil) {
                [self.hintMask setHidden:NO];
                [self.navigationController.parentViewController.view addSubview:self.hintMask];
                NSLog(@"hint mask %@",self.hintMask);
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"FirstTimeMapLoaded"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self performSelector:@selector(removeMask) withObject:nil afterDelay:3.0f];
            }else {
                [self.hintMask removeFromSuperview];
                //                self.compBlock(YES);
            }
            
            if(annotationArray.count>0)
                self.currentLocation = [[CLLocation alloc]initWithLatitude:self.mapview.centerCoordinate.latitude longitude:self.mapview.centerCoordinate.longitude];
            else
                self.currentLocation = [CTCommonMethods getLastLocation];
            NSLog(@"current location %@",self.currentLocation);
            
            [self.mapview reloadInputViews];
            
        
        });
    }];
}
//    annotationArray=[[NSMutableArray alloc]init];
//    CLLocationCoordinate2D coordinate;
//    NSLog(@"RESPONSE COUNT %d",[self.restaurantSASLSummary count]);
//    NSData *serializeObj=[NSKeyedArchiver archivedDataWithRootObject:self.restaurantSASLSummary];
//    [[NSUserDefaults standardUserDefaults]setObject:serializeObj forKey:@"saslSummary"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_RestaurantListData object:self];
//    for(int i=0;i<[self.restaurantSASLSummary count];i++){
//
//        NSDictionary *restaurantDict=[self.restaurantSASLSummary restaurantSASLSummary:i];
//        NSLog(@"res count %d",[restaurantDict count]);
//        NSArray  *mapMarkers=[restaurantDict saslMapMarkers];
//        NSLog(@"RESTAURANT NAME %@",[restaurantDict name]);
//        for(int j=0;j<[mapMarkers count];j++){
//
//            NSLog(@"category %@",[mapMarkers category:j]);
//            double latitute=[[restaurantDict latitude] doubleValue];
//            double longitute=[[restaurantDict longitude]doubleValue];
//
//            NSString *title=[restaurantDict name];
//            NSString *subtitle=[mapMarkers category:j];
//            NSString *markerURL=[mapMarkers markerURL:j];
//            coordinate.latitude=latitute;
//            coordinate.longitude=longitute;
//            NSLog(@"selected category %@",self.selectedCategory);
//            if([subtitle isEqualToString:self.selectedCategory]){
//            NSLog(@"subtitle %@ at index %d",markerURL,j);
//               CTMapAnnotation *annotation=[[CTMapAnnotation alloc]initWithCoordinate:coordinate withTitle:title withSubTitle:subtitle withPinImageURL:markerURL andRestaurantObj:restaurantDict];
//                annotation.delegate = self;
//                    NSLog(@"res count %d",[restaurantDict count]);
//                    [annotationArray addObject:annotation];
//                 NSLog(@"Annotation count  %d",[annotationArray count]);
//                //self.annotation=nil;
//            }
//        }
//        MKCoordinateSpan span;
//        span.latitudeDelta=0.1;
//        span.longitudeDelta=0.1;
//
//        MKCoordinateRegion region;
//        region.center=coordinate;
//        region.span=span;
////        [self.mapview setRegion:region animated:YES];
//
//    }

// set map's coordinates and center
//    if(annotationArray.count>0)
//        self.currentLocation = [[CLLocation alloc]initWithLatitude:self.mapview.centerCoordinate.latitude longitude:self.mapview.centerCoordinate.longitude];
//    else
//        self.currentLocation = [CTCommonMethods getLastLocation];
//    // save last know location.
//    [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
//    NSLog(@"current location %@",self.currentLocation);
////    [self.mapview addAnnotations:annotationArray];
////    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue], [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue]) animated:YES];
//    // set map's zoom level
//    zoomRect = MKMapRectNull;
//    for (id <MKAnnotation> annotation in annotationArray)
//    {
//        if([annotation isKindOfClass:[MKUserLocation class]] == FALSE) {
//            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//            zoomRect = MKMapRectUnion(zoomRect, pointRect);
//        }
//    }
////    [self.mapview setRegion:region];
//    [self.mapview setVisibleMapRect:zoomRect animated:FALSE];
//    [self removeLoader];
//}
/*
 -(void)updateMapView{
 
 NSMutableArray *annotationArray=[[NSMutableArray alloc]init];
 NSArray *summaryArray=[self.restaurantSummary restaurantsummary];
 CLLocationCoordinate2D coordinate;
 for(int i=0;i<[summaryArray count];i++){
 NSArray *mapMarkerArray=[[self.restaurantSummary mapmarkers]objectAtIndex:i];
 NSString *name=[summaryArray name:i];
 NSLog(@"RESTAURANT NAME %@ at index %d",name,i);
 for(int j=0;j<[mapMarkerArray count];j++){
 
 double latitute=[[summaryArray latitude:i] doubleValue];
 double longitute=[[summaryArray longitude:i]doubleValue];
 
 NSString *title=[summaryArray name:i];
 NSString *subtitle=[mapMarkerArray category:j];
 NSLog(@"subtitle %@",subtitle);
 NSString *markerName=[mapMarkerArray marker:j];
 NSLog(@"markerName %@",markerName);
 coordinate.latitude=latitute;
 coordinate.longitude=longitute;
 if([subtitle isEqualToString:@"SERVICE_STATUS"]){
 self.annotation=[[CTMapAnnotation alloc]initWithCoordinate:coordinate withTitle:title withSubTitle:subtitle withPinImageName:markerName];
 [annotationArray addObject:self.annotation];
 }
 
 }
 MKCoordinateSpan span;
 span.latitudeDelta=0.1;
 span.longitudeDelta=0.1;
 
 MKCoordinateRegion region;
 region.center=coordinate;
 region.span=span;
 [self.mapview setRegion:region animated:YES];
 [self.mapview addAnnotations:annotationArray];
 }
 }
 */
#pragma Mapview Annotation delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString *cellIdentifier= @"cellID";
    CTMapAnnotationCalloutView *pin= (CTMapAnnotationCalloutView*)[mapView dequeueReusableAnnotationViewWithIdentifier:cellIdentifier];
    if(pin==nil){
        pin=[[CTMapAnnotationCalloutView alloc]initWithAnnotation:annotation reuseIdentifier:cellIdentifier];
    }
    else{
        [pin setAnnotation:annotation];
    }
    
    UIButton *button=nil;
    if(isIOS7){
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"iOS7-detail-button.png"] forState:UIControlStateNormal];
    }
    else{
        button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    button.frame=CGRectMake(0, 0, 23, 23);
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    pin.rightCalloutAccessoryView=button;
    pin.enabled=YES;
    pin.canShowCallout=YES;
    
    if([((CTMapAnnotation *)annotation).subTitle isEqualToString:[[CTRootControllerDataModel sharedInstance]selectedCategory]]){
//        NSLog(@"image url %@",[(CTMapAnnotation*)annotation pinImageURL]);
        //       [pin setImage:[(CTMapAnnotation*)annotation pinImage] withText:[(CTMapAnnotation*)annotation title]];
        [pin setImage:[(CTMapAnnotation*)annotation pinImage] withText:[(CTMapAnnotation*)annotation title] withFlag:([(NSMutableDictionary *)(((CTMapAnnotation *)annotation).restaurantDictObj) inNetwork])];
        pin.delegate = self;
        
        if([self canShowMarkerLabelForAnnot:(CTMapAnnotation*)annotation])
            [pin showLabel:YES];
        else
            [pin hideLabel:YES];
        //         NSLog(@"ANNOTATION %@",((CTMapAnnotation *)annotation).title);
    }
    //    pin.hidden = YES;
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    CTMapAnnotation *annotation=[mapView.selectedAnnotations objectAtIndex:0];
    //    NSLog(@"selected annotation %@ -----%@",annotation.title, annotation.restaurantDictObj);
    //    NSMutableDictionary *restaurant=(NSMutableDictionary*)annotation.restaurantDictObj;
    //    NSString *sa=[restaurant serviceAccommodatorId];
    //    NSString *sl=[restaurant serviceLocationId];
    //    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
    //    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
    //    if([restaurant inNetwork]){
    //    [self getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon];
    //    }
    //    else{
    //        [self openOutOfNetworkviewController:restaurant];
    //    }
    //    [self performGetRestaurantBySASLOperationForAnnotation:annotation];
    // ui is included
    [self performGetRestaurantBySASLOperationForAnnotation:annotation];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.nextRegionChangeIsFromUserInteraction) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        //    mapRegion.span.latitudeDelta = 0.2;
        //    mapRegion.span.longitudeDelta = 0.2;
        mapRegion.span.latitudeDelta = ZoomSpanDelta;
        mapRegion.span.longitudeDelta = ZoomSpanDelta;
        
        [mapView setRegion:mapRegion animated: YES];
    }
}

static MKCoordinateRegion mapRegion;
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    mapRegion = self.mapview.region;
    
    UIView* view = mapView.subviews.firstObject;
    //	Look through gesture recognizers to determine
    //	whether this region change is from user interaction
    for(UIGestureRecognizer* recognizer in view.gestureRecognizers) {
        //	The user caused of this...
        if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded) {
            self.nextRegionChangeIsFromUserInteraction = YES;
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}
- (void)mapView:(MKMapView *)_mapView regionDidChangeAnimated:(BOOL)animated {
    //    MKCoordinateRegion newRegion = self.mapview.region;
    if(didPan == FALSE) {
        
        // V: old code to
        //        NSLog(@"zoom level %f --> %f --> %f",[self.mapview getZoomLevel],[CTCommonMethods zoomDifferenceToShowDetails],self.mapview.region.span.latitudeDelta);
        
        NSLog(@"zoom level %f --> %f --> %f",[self.mapview getZoomLevel],[CTCommonMethods zoomDifferenceToShowDetails],[self getZoomLevel:self.mapview]);
        
        //       int fitAnnotationsZoomLevel = [self zoomLevelForMapRect:zoomRect withMapViewSizeInPixels:self.mapview.frame.size];
        
        //        int currentZoomLevel = [self zoomLevelForMapRect:self.mapview.visibleMapRect withMapViewSizeInPixels:self.mapview.frame.size];
        double currentZoomLevel = [self.mapview getZoomLevel];
        //    double zoomLevel = [self getZoomLevel:_mapView];
        //    NSLog(@"zoom level %d",currentZoomLevel-fitAnnotationsZoomLevel);
        for(CTMapAnnotation *annot in _mapView.annotations) {
            if([annot isKindOfClass:[MKUserLocation class]] == FALSE) {
                CTMapAnnotationCalloutView *view_Annotation =(CTMapAnnotationCalloutView*) [_mapView viewForAnnotation:annot];
                
                //            if(currentZoomLevel-fitAnnotationsZoomLevel>=kMap_ZoomDifference_To_Show_Details) {
                if(currentZoomLevel>=[CTCommonMethods zoomDifferenceToShowDetails]) {
                    calloutVisible = YES;
                    [view_Annotation showLabel:YES];
                }
                else {
                    calloutVisible = FALSE;
                    [view_Annotation hideLabel:YES];
                }
                
            }
        }
    }else {
        // after panning.
        CLLocation *centerLocatoin = [[CLLocation alloc]initWithLatitude:self.mapview.region.center.latitude longitude:self.mapview.region.center.longitude];
        CGFloat latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue];
        CGFloat longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue];
        CLLocationDistance meters = [centerLocatoin distanceFromLocation:self.currentLocation];
        meters = meters/1000;
        //        NSLog(@"distance is %f --> %f",meters,[CTCommonMethods scrollUpdateDistanceKM]);
        if(meters>=[CTCommonMethods scrollUpdateDistanceKM]) {
            [self refreshMapviewAnnotation];
        }
        didPan = FALSE;
    }
}

//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    // in case hit detection area is taped, then only show callout, otherwise deselect.
//    CTMapAnnotationCalloutView *pin = (CTMapAnnotationCalloutView*)view;
//    if(pin.didTapHitDetectionArea == FALSE)
//        [mapView deselectAnnotation:view.annotation animated:FALSE];
//}
//-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    CTMapAnnotationCalloutView *pin = (CTMapAnnotationCalloutView*)view;
//    pin.didTapHitDetectionArea = FALSE;
//}
-(void)getRestaurantBySa:(NSString *)sa SL:(NSString *)sl forLatitude:(NSString *)lat andLongitude:(NSString *)lon{
    
    //    int serviceAccomodationId=[sa intValue];
    //    int serviceLocationId=[sl intValue];
    double latitude=[lat doubleValue];
    double longitude=[lon doubleValue];
    //    NSString *param=[NSString stringWithFormat:@"serviceLocationId=%d&serviceAccommodatorId=%d&latitude=%f&longitude=%f",serviceLocationId,serviceAccomodationId,latitude,longitude];
    
    // V: 20-05-2015 change integer to string "SL and SA"
    NSString *param=[NSString stringWithFormat:@"serviceLocationId=%@&serviceAccommodatorId=%@&latitude=%f&longitude=%f",sl,sa,latitude,longitude];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRestaurant,param];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *requestURL=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:requestURL success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
        restaurantController.restaurantDetailsDict=(NSDictionary *)JSON;
        [self.navigationController pushViewController:restaurantController animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
}
-(void)openOutOfNetworkviewController:(NSDictionary *)dict{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CTOutOfNetworkViewController *outOfnetwork=[storyboard instantiateViewControllerWithIdentifier:@"CTOutOfNetworkViewController"];
    outOfnetwork.restaurantDetailsDict=dict;
    [self.navigationController pushViewController:outOfnetwork animated:YES];
}
- (IBAction)refreshAction:(id)sender {
    
}

/*
 //Load map icon by url
 -(void)loadMapMarkerURLFromBackgroundTask{
 
 [self.mapview removeAnnotations:annotationArray];
 MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
 hud.mode=MBProgressHUDModeIndeterminate;
 hud.labelText=@"Please wait...";
 hud.progress=0.0;
 NSOperationQueue *backgroundQueue=[[NSOperationQueue alloc]init];
 [backgroundQueue addOperationWithBlock:^{
 annotationArray=[[NSMutableArray alloc]init];
 CLLocationCoordinate2D coordinate;
 int m=0;
 for(int i=0;i<[self.restaurantSASLSummary count];i++){
 NSDictionary *restaurantDict=[self.restaurantSASLSummary restaurantSASLSummary:i];
 NSArray  *mapMarkers=[restaurantDict saslMapMarkers];
 for(int j=0;j<[mapMarkers count];j++){
 double latitute=[[restaurantDict latitude] doubleValue];
 double longitute=[[restaurantDict longitude]doubleValue];
 
 NSString *title=[restaurantDict name];
 NSString *subtitle=[mapMarkers category:j];
 coordinate.latitude=latitute;
 coordinate.longitude=longitute;
 
 if([subtitle isEqualToString:self.selectedCategory]){
 NSString *mapIconURL=[[mapMarkers valueForKey:@"markerURL"]objectAtIndex:j];
 //NSLog(@"map ICON URL %@",mapIconURL);
 NSURL *url=[NSURL URLWithString:mapIconURL];
 NSData *imageData=[NSData dataWithContentsOfURL:url];
 if(imageData!=nil){
 NSLog(@"subtitle %@ at index %d",subtitle,j);
 NSLog(@"map ICON URL %@",mapIconURL);
 CTMapAnnotation *annotation=[[CTMapAnnotation alloc]initWithCoordinate:coordinate withTitle:title withSubTitle:subtitle withPinImageName:imageData andRestaurantObj:restaurantDict];
 NSLog(@"res count %d",[restaurantDict count]);
 [annotationArray addObject:annotation];
 NSLog(@"Annotation count  %d",[annotationArray count]);
 //self.annotation=nil;
 
 }
 m++;
 hud.progress=(float)m;
 NSLog(@"m %d",m);
 // break;
 }
 }
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 if([restaurantDict count]==m){
 [self removeLoader];
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 }
 MKCoordinateSpan span;
 span.latitudeDelta=0.1;
 span.longitudeDelta=0.1;
 
 MKCoordinateRegion region;
 region.center=coordinate;
 region.span=span;
 [self.mapview setRegion:region animated:YES];
 [self.mapview addAnnotations:annotationArray];
 }];
 }
 }];
 }
 */

-(NSString *)getDynamicResaturantSASLSummaryURL{
    
    NSString *serverName=[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]];
    NSString *restaurantSummaryUrl=nil;
    if(self.isLocationServiceAllowed){
        
        //        if([[NSUserDefaults standardUserDefaults] boolForKey:@"simulate"]){
//        restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,[CTCommonMethods simulate]];
//        NSLog(@"restaurantarray %@",restaurantSummaryUrl);
       
        
        restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryLightByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,[CTCommonMethods simulate]];
        NSLog(@"restaurantarray %@",restaurantSummaryUrl);
        //        }else{
        //            restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=user20.781305772384780045&latitude=%f&longitude=%f",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
        //        }
        NSString *lat=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
        NSString *lon=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
        [self saveToCacheLatitude:lat andLongitude:lon];
    }
    else{
//        restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=37.4464863&longitude=-122.1612654&simulate=%@",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],[CTCommonMethods simulate]];
//        [self saveToCacheLatitude:@"37.4464863" andLongitude:@"-122.1612654"];
        
        restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=37.4464863&longitude=-122.1612654&simulate=%@",serverName,CT_getSASLSummaryLightByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],[CTCommonMethods simulate]];
        [self saveToCacheLatitude:@"37.4464863" andLongitude:@"-122.1612654"];
    }
    
    return restaurantSummaryUrl;
}
-(NSString *)getLocalResaturantSASLSummaryURLForLocation:(CLLocation*)location{
    // update info before constructing url.
    //    if([[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] == nil || [[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] == nil) {
    //        location =[[CLLocation alloc]initWithLatitude:37.4464863 longitude:-122.1612654];
    //        [self saveToCacheLatitude:@"37.4464863" andLongitude:@"-122.1612654"];
    //    }
    NSString *serverName=[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]];
    NSString *restaurantSummaryUrl=nil;
    
    NSString *TileSummaryUrl = nil;
    
    
//    NSLog(@"[CTCommonMethods UID].length ====== %lu",(unsigned long)[CTCommonMethods UID].length);
    if ([CTCommonMethods UID].length == 0)
    {
        NSMutableDictionary *mutableRetrievedDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicKey"] mutableCopy];
//        NSLog(@"mutable data %@",mutableRetrievedDictionary);
        if (![mutableRetrievedDictionary isEqual:[NSNull null]]) {
            [CTCommonMethods sharedInstance].OWNERFLAG = [[mutableRetrievedDictionary valueForKey:@"isOwner"] boolValue];
            [CTCommonMethods sharedInstance].EmailID = [mutableRetrievedDictionary valueForKey:@"email"];
            [CTCommonMethods sharedInstance].Onuser =[mutableRetrievedDictionary objectForKey:@"userName"];
            [CTCommonMethods setUID:[mutableRetrievedDictionary objectForKey:@"uid"]];
//            NSLog(@"CTCommonMethods UID = %@",[CTCommonMethods UID]);
            
            NSMutableDictionary *mutableRetrievedDictionary1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SASLSelect"] mutableCopy];
//            NSLog(@"mutable data %@",mutableRetrievedDictionary);
            
            [CTCommonMethods sharedInstance].selectSa = [mutableRetrievedDictionary1 objectForKey:@"SelectSA"];
            [CTCommonMethods sharedInstance].selectSl = [mutableRetrievedDictionary1 objectForKey:@"SelectSL"];
        }
        
    }
    
    
    
    //    if([[NSUserDefaults standardUserDefaults] boolForKey:@"simulate"] == FALSE){
    //restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],location.coordinate.latitude,location.coordinate.longitude,[CTCommonMethods simulate]];
    
//    restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],location.coordinate.latitude,location.coordinate.longitude,[CTCommonMethods simulate]];
    
    //++++++++++++++++++ Comment +++++++++++++++++++++++
      restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryLightByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],location.coordinate.latitude,location.coordinate.longitude,[CTCommonMethods simulate]];
    
    NSLog(@"restaurant ---------------------- %@",restaurantSummaryUrl);
    
    
    
    TileSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLTilesByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],location.coordinate.latitude,location.coordinate.longitude,[CTCommonMethods simulate]];
    [CTCommonMethods sharedInstance].SelectTileSaSL = TileSummaryUrl;
    NSLog(@"restaurant TitleSummaryUrl%@",[CTCommonMethods sharedInstance].SelectTileSaSL);
    
    //    }else{
    //        restaurantSummaryUrl=[NSString stringWithFormat:@"%@%@domain=%@&UID=%@&latitude=%f&longitude=%f&simulate=%@",serverName,CT_getSASLSummaryByUIDAndLocation,[[CTRootControllerDataModel sharedInstance]selectedDomain],[CTCommonMethods UID],location.coordinate.latitude,location.coordinate.longitude,[CTCommonMethods simulate]];
    //    }
    
    return restaurantSummaryUrl;
}
-(void)updateMapUIWithFetchedJson:(id)JSON {
    self.restaurantSummary=(NSDictionary *)JSON;
    //    [[CTRootControllerDataModel sharedInstance]willChangeValueForKey:@"saslSummaryArray"];
    [[CTRootControllerDataModel sharedInstance]setSaslSummaryArray:[(NSArray*)JSON deepMutableCopy]];
    [CTCommonMethods sharedInstance].listofResturant = [CTRootControllerDataModel sharedInstance].saslSummaryArray;
    if([CTRootControllerDataModel sharedInstance].saslSummaryArray.count>0) {
        //    [[CTRootControllerDataModel sharedInstance]didChangeValueForKey:@"saslSummaryArray"];
        // sort per distance
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:kDistanceInKmKey ascending:YES];
        [[[CTRootControllerDataModel sharedInstance] listofSaslData]sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        [self performSelectorOnMainThread:@selector(updateMapViewBySASL) withObject:nil waitUntilDone:FALSE];
    }
}
#pragma CTMapAnnotationCalloutViewDelegate
-(void)didTapOnCalloutView:(CTMapAnnotationCalloutView*)view {
    NSLog(@"delegate called here %@",view.annotation);
    //    [self.mapview selectAnnotation:view.annotation animated:YES];
}
-(void)didTapCalloutAccessoryView:(CTMapAnnotationCalloutView *)annotationView {
    CTMapAnnotation *annotation= (CTMapAnnotation*)annotationView.annotation;
    [self performGetRestaurantBySASLOperationForAnnotation:annotation];
}
-(void)didTapMarker:(CTMapAnnotationCalloutView *)view {
    // only in case callouts are not shown.
    if(calloutVisible == FALSE) {
        for(CTMapAnnotation *annotation in self.mapview.annotations) {
            CTMapAnnotationCalloutView *annotView =(CTMapAnnotationCalloutView*) [self.mapview viewForAnnotation:annotation];
            [annotView hideLabel:YES];
        }
    }
}
#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
#pragma CTMapAnnotationDelegate
-(void)didDownloadAnnoationImage:(UIImage*)image forAnnotation:(CTMapAnnotation *)annotation{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        CTMapAnnotationCalloutView *view = (CTMapAnnotationCalloutView*)[self.mapview viewForAnnotation:annotation];
//        NSLog(@"image Root= %@",image);
        annotation.pinImage = image;
        //        [view setImage:image withText:[(CTMapAnnotation*)annotation title]];
        [self.mapview addAnnotation:annotation];
        
        //        [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue], [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue]) animated:FALSE];
        
        //        [self.mapview setVisibleMapRect:zoomRect animated:FALSE];
    });
    
}
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == CT_AlertTagServerNotAccessible && buttonIndex != alertView.cancelButtonIndex) {
        // retry
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    }else if(alertView.tag == CT_AlertTagServerNotAccessible && buttonIndex == alertView.cancelButtonIndex) {
        [self removeLoader];
    }else if(alertView.tag == CT_AlertTagLocationServicesDisabled) {
        if(buttonIndex == alertView.cancelButtonIndex) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Default location will be used to access data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            alert.tag = CT_AlertTagDefaultLocationWillBeUsed;
            [alert show];
        }else {
            [self performSelectorOnMainThread:@selector(removeLoader) withObject:nil waitUntilDone:FALSE];
            CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
            [parent showLocationSearchPopup];
        }
    }else if(alertView.tag == CT_AlertTagDefaultLocationWillBeUsed) {
        self.currentLocation = [CTCommonMethods getLastLocation];
        NSLog(@"last location %@",self.currentLocation);
        [self saveToCacheLatitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
        [self getRestaurantSASLSummaryByUIDAndLocationForLocation:self.currentLocation];
    }
    
    if(alertView.tag == 101 && buttonIndex!= alertView.cancelButtonIndex) {
        // login btn taped.
        [CTCommonMethods sharedInstance].PRAMOTIONFLAG = YES;
        
        //CTLoginViewController * login = [[CTLoginViewController alloc]initWithNibName:@"CTLoginViewController" bundle:nil];
        
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
        CTLoginViewController * promotion = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
        promotion.delegate = parentController;
        promotion.navigationItem.leftBarButtonItem = [self backButton];
        promotion.navigationItem.title = @"Chalkboard Login";
        //            isCREATE = true;
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
        //CTLoginPopup *login = [[CTLoginPopup alloc]init];
        //[self.view addSubview:login];
        [CTCommonMethods sharedInstance].IdentifierNoti = @"101";
    }
}
#pragma CTGetRestaurantSummaryRequestDelegate
-(void)didFetchData:(NSData*)data {
    [self removeLoader];
}

-(void)didFinishFetchingData:(NSData *)data {
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    isRequestInProgress = FALSE;
    //    NSLog(@"JSON STRING %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [[Multitasking sharedInstance]getJSONFromData:data completionBlock:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized(self) {
                if(!error) {
                    [self performSelectorOnMainThread:@selector(removeLoader) withObject:nil waitUntilDone:FALSE];
                    id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    [self updateMapUIWithFetchedJson:JSON];
                }else  {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:CT_ServerNotAccessibleTitle message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                    alertView.tag = CT_AlertTagServerNotAccessible;
                    [alertView show];
                }
            }
        });
    }];
    //    id JSON = nil;
    //    if(data)
    //        JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",@"error"];
    //    if(JSON && (([JSON isKindOfClass:[NSArray class]] && [JSON filteredArrayUsingPredicate:predicate].count == 0) || [JSON valueForKey:@"error"] == nil)) {
    //        [self performSelectorOnMainThread:@selector(removeLoader) withObject:nil waitUntilDone:FALSE];
    //        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //        self.restaurantSummary=(NSDictionary *)JSON;
    //        self.restaurantSASLSummary=(NSArray *)JSON;
    //        [self performSelectorOnMainThread:@selector(updateMapViewBySASL) withObject:nil waitUntilDone:FALSE];
    //        //            NSLog(@"str response is %@ %@",str,NSStringFromClass([str class]));
    //    }else {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:CT_ServerNotAccessibleTitle message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
    //            alertView.tag = CT_AlertTagServerNotAccessible;
    //            [alertView show];
    //        });
    //    }
    
    
}
-(void)didFailWithError:(NSError*)error {
    [self removeLoader];
    isRequestInProgress = FALSE;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        alertView.tag = CT_AlertTagServerNotAccessible;
        [alertView show];
    });
    
}
@end
