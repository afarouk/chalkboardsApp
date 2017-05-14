//
//  CTSlideRestaurantListView.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSlideRestaurantListView.h"
#import "CTOutOfNetworkViewController.h"
#import "CTSlideRestaurantCell.h"
#import "CTRestaurantHomeViewController.h"
#import "NSArray+RestaurantSummaryByUIDAndLocation.h"
#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"
#import "NSArray+SASLSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "NSMutableDictionary+MarkerDetails.h"
#import "CTRootControllerDataModel.h"
#import "MBProgressHUD.h"
typedef void(^RatingImageCompletionBlock)(UIImage *img);
@implementation CTSlideRestaurantListView{
    NSMutableArray *tempSaslSummaryArray;
}
@synthesize restaurantListTableView;
@synthesize view;
//@synthesize saslResturantSummary;
//@synthesize restaurantListArray;
#pragma Scope Methods
-(void)getRatingImageForURL:(NSString*)url dictionary:(NSMutableDictionary*)dictionary completionBlock:(RatingImageCompletionBlock)block {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError)
            block([UIImage imageWithData:data]);
    }];
}
-(void)didTapOnView:(UITapGestureRecognizer*)tap {
    if([self.delegate respondsToSelector:@selector(didTapOnSlideRestaurantListView)])
        [self.delegate didTapOnSlideRestaurantListView];
}
-(void)enableHitDetectionArea {
    gestureView.frame = CGRectMake(container.frame.size.width, 0, [UIScreen mainScreen].applicationFrame.size.width-container.frame.size.width, self.frame.size.height);
    CGRect frame = self.frame;
    frame.size.width  = container.frame.size.width+gestureView.frame.size.width;
    self.frame = frame;
}
-(void)disableHitDetectionArea {
    gestureView.frame=CGRectMake(0, 0, 1, 1);
    CGRect frame = self.frame;
    frame.size.width  = container.frame.size.width;
    self.frame = frame;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSlideRestaurantListView" owner:self options:nil];
        container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[nib objectAtIndex:0] frame].size.width, self.frame.size.height)];
        [self addSubview:container];
        [container addSubview:[nib objectAtIndex:0]];
        
        tempSaslSummaryArray = [CTRootControllerDataModel sharedInstance].saslSummaryArray;
        
        self.restaurantListTableView.tableFooterView=[[UIView alloc]init];
        self.backgroundColor = [UIColor clearColor];
        container.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.restaurantListTableView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sliderAction:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self observersOfPostNotification];
        [self addGestureRecognizer:swipeGesture];
        //[self.restaurantListTableView reloadData];
        // view for gesture
        gestureView = [[UIView alloc]initWithFrame:CGRectMake(self.restaurantListTableView.frame.size.width, 0, self.frame.size.width-self.restaurantListTableView.frame.size.width, self.frame.size.height)];
        gestureView.backgroundColor = [UIColor clearColor];
        [self addSubview:gestureView];
        [self disableHitDetectionArea];
        // tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
        [gestureView addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark observers
-(void)observersOfPostNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedCategory:) name:CT_Observers_FilterCategory object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(populatedList) name:CT_Observers_RestaurantListData object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markerImageDownloadedNotif:) name:CT_Observers_MarkerImageDownloaded object:nil];
}
-(void)markerImageDownloadedNotif:(NSNotification*)notif {
    //    @synchronized(self) {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSDictionary *restDictionary = notif.object;
        //        NSUInteger index = [tempSaslSummaryArray indexOfObject:restDictionary];
        //        @try {
        //        }
        //        @catch (NSException *exception) {
        //            NSLog(@"EXCEPTION RELOADING ROW");
        //        }
        [self.restaurantListTableView reloadData];
    });
    
}
-(void)populatedList{
    dispatch_async(dispatch_get_main_queue(), ^{
        @try{
            [self getSaslResturantSummary];
            [self setRatingStar];
            [self.restaurantListTableView reloadData];
        }@catch (NSException *exception) {
            NSLog(@"EXCEPTION %@",exception);
        }
    });
    
}
-(void)selectedCategory:(NSNotification *)notification{
    NSDictionary *categoryDic=[notification userInfo];
    
    NSLog(@"SLIDE DOMAIN %@",[[CTRootControllerDataModel sharedInstance]selectedDomain]);
    NSLog(@"SLIDE CATEGORY %@",[[CTRootControllerDataModel sharedInstance]selectedCategory]);
    [self getSaslResturantSummary];
    [self setRatingStar];
    [self.restaurantListTableView reloadData];
}
- (IBAction)sliderAction:(id)sender {
    
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame, -275, 0);
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetRestaurantSlide" object:self];
    //    [self getSaslResturantSummary];
    //    [self setRatingStar];
    //    [self.restaurantListTableView reloadData];
}
#pragma mark SASL Restaurant
// no need for this method
-(void)getSaslResturantSummary{
    
    //    NSData *deserializeObj=[[NSUserDefaults standardUserDefaults]objectForKey:@"saslSummary"];
    //    self.saslResturantSummary=[NSKeyedUnarchiver unarchiveObjectWithData:deserializeObj];
    //   // NSLog(@"SASL COUNT %d",[self.saslResturantSummary count]);
    //
    //    self.restaurantListArray=[[NSMutableArray alloc]init];
    //    self.ratingImageUrlArray=[[NSMutableArray alloc]init];
    //    self.mapIconArray=[[NSMutableArray alloc]init];
    //    int m=0;
    //    for(int i=0;i<[self.saslResturantSummary count];i++){
    //        NSDictionary *restaurantDict=[self.saslResturantSummary restaurantSASLSummary:i];
    //        NSArray  *mapMarkers=[restaurantDict saslMapMarkers];
    //        for(int j=0;j<[mapMarkers count];j++){
    //            NSString *name=[restaurantDict name];
    //            NSString *markerName=[mapMarkers marker:j];
    //            NSString *sa=[restaurantDict serviceAccommodatorId];
    //            NSString *sl=[restaurantDict serviceLocationId];
    //            NSNumber *lat=[restaurantDict latitude];
    //            NSNumber *lon=[restaurantDict longitude];
    //            NSString *rating=[restaurantDict rating_img_url];
    //            NSString *mapURL=[[mapMarkers valueForKey:@"markerURL"]objectAtIndex:j];
    //            if([[mapMarkers category:j]isEqualToString:self.selectedCategory]){
    //                NSMutableDictionary *markerDictionary = [mapMarkers objectAtIndex:j];
    //                UIImage *image=[UIImage imageNamed:@"rating-star-empty.png"];
    //                UIImage *map=[UIImage imageNamed:CT_MapPinImage_Default];
    //                if([markerDictionary markerImage])
    //                    map = [markerDictionary markerImage];
    //                NSData *data=[NSData dataWithData:UIImagePNGRepresentation(image)];
    //                NSData *mapIcondata=[NSData dataWithData:UIImagePNGRepresentation(map)];
    //                [self.restaurantListArray addObject:[NSArray arrayWithObjects:name,markerName,sa,sl,lat,lon,rating,mapURL,nil]];
    //                [self.ratingImageUrlArray insertObject:data atIndex:m];
    //                [self.mapIconArray insertObject:mapIcondata atIndex:m];
    //                m++;
    //                break;
    //            }
    //        }
    //    }
    //     NSLog(@"RESTAUTANT COUNT %d",[self.restaurantListArray count]);
    //     NSLog(@"RESTAUTANT COUNT %@",self.restaurantListArray);
    //    NSLog(@"RATING ARRAY COUNT %d",[self.ratingImageUrlArray count]);
}

#pragma mark Restaurant List Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tempSaslSummaryArray count];
}
-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTSlideRestaurantCell *restaurantCell=(CTSlideRestaurantCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSlideRestaurantCell" owner:self options:nil];
    restaurantCell=[nib objectAtIndex:0];
    //restaurantCell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    if([tempSaslSummaryArray count]!=0){
        @try{
            NSMutableDictionary *dictionary = [tempSaslSummaryArray objectAtIndex:indexPath.row];
            restaurantCell.restaurantNameLbl.text= [dictionary name];
            NSString *lat=[NSString stringWithFormat:@"%@",[dictionary latitude]];
            NSString *lon=[NSString stringWithFormat:@"%@",[dictionary longitude]];
            restaurantCell.miles.text=[NSString stringWithFormat:@"%@Km",[self calculateKilometersFromLatitude:lat andLongitude:lon]];
            restaurantCell.kilometers.text=[self calculateMilesFromLatitude:lat andLongitude:lon];
            //        NSLog(@"markers %@",[dictionary saslMapMarkers]);
            //        NSLog(@"check %@",[[dictionary saslMapMarkers]valueForKey:@"category"]);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",[[CTRootControllerDataModel sharedInstance] selectedCategory]];
            
            NSMutableDictionary *selectedMapDictoinary = [[[dictionary saslMapMarkers]filteredArrayUsingPredicate:predicate] lastObject];
            UIImage *img;
            if(selectedMapDictoinary && [selectedMapDictoinary markerImage])
                img = [selectedMapDictoinary markerImage];
            else
                img = [UIImage imageNamed:CT_MapPinImage_Default];
            
            restaurantCell.markerIcon.image=img;
            
            if([dictionary ratingImage])
                restaurantCell.ratingImgView.image=[dictionary ratingImage];
            else {
                [self getRatingImageForURL:[dictionary rating_img_url] dictionary:dictionary completionBlock:^(UIImage *img) {
                    [dictionary setRatingImage:img];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        restaurantCell.ratingImgView.image = img;
                    });
                }];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"CELL RATING URL EXCEPTION %@",exception);
        }
    }
    return restaurantCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *restaurant = [tempSaslSummaryArray objectAtIndex:indexPath.row];
    [[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
    
    //    NSLog(@"selectecd %@",[dictionary name]);
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    
    NSString *sa=[restaurant serviceAccommodatorId];
    NSString *sl=[restaurant serviceLocationId];
    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
    if([restaurant inNetwork]){
        [CTWebServicesMethods getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon completionBlock:^(NSString *errorTitle, NSString *errorMessage, id JSON) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:self animated:YES];
            }];
            if(JSON) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
                    restaurantController.restaurantDetailsDict=JSON;
                    [self.navigationController pushViewController:restaurantController animated:YES];
                    restaurantController.view.userInteractionEnabled = YES;
                    [restaurantController retriveMediaMetaDatabySaSl];
                    [self.delegate didTapOnSlideRestaurantListView];
                }];
                
            }else {
                // it's an error.
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    [CTCommonMethods showErrorAlertMessageWithTitle:errorTitle andMessage:errorMessage];
                }];
            }
        }];
        //        [self getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon];
    }
    else{
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self openOutOfNetworkviewController:restaurant];
        [self.delegate didTapOnSlideRestaurantListView];
    }
    
    
}
#pragma mark get Restaurant
-(void)getRestaurantBySa:(NSString *)sa SL:(NSString *)sl forLatitude:(NSString *)lat andLongitude:(NSString *)lon{
    
    //    [[NSOperationQueue new]addOperationWithBlock:^{
    //        int serviceAccomodationId=[sa intValue];
    //        int serviceLocationId=[sl intValue];
    double latitude=[lat doubleValue];
    double longitude=[lon doubleValue];
    //        NSString *param=[NSString stringWithFormat:@"serviceLocationId=%d&serviceAccommodatorId=%d&latitude=%f&longitude=%f",serviceLocationId,serviceAccomodationId,latitude,longitude];
    
    // V: 20-05-2015 change integer to string "SL and SA"
    NSString *param=[NSString stringWithFormat:@"serviceLocationId=%@&serviceAccommodatorId=%@&latitude=%f&longitude=%f",sl,sa,latitude,longitude];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRestaurant,param];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *requestURL=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }else {
            NSError *error;
            NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSError *jsonError = [CTCommonMethods validateJSON:dictionary];
            if(!error && !jsonError) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
                    restaurantController.restaurantDetailsDict=dictionary;
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    [self.navigationController pushViewController:restaurantController animated:YES];
                    restaurantController.view.userInteractionEnabled = YES;
                    [restaurantController retriveMediaMetaDatabySaSl];
                }];
            }else if(jsonError) {
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
                
            }
            if(error) {
                [MBProgressHUD hideHUDForView:self animated:YES];
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
            }
            
        }
    }];
    //        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:requestURL success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    ////            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ////            CTRestaurantHomeViewController *restaurantController=[storyboard instantiateViewControllerWithIdentifier:@"CTRestaurantHomeViewController"];
    //            restaurantController.restaurantDetailsDict=(NSDictionary *)JSON;
    ////            [MBProgressHUD hideHUDForView:self animated:YES];
    ////            [self.navigationController pushViewController:restaurantController animated:YES];
    //        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //            [MBProgressHUD hideHUDForView:self animated:YES];
    //            [CTCommonMethods showErrorAlertMessageWithTitle:@"Community" andMessage:@"Service is not available please try again later"];
    //        }];
    //
    //        [operation start];
    
    //    }];
}

-(NSString *)calculateMilesFromLatitude:(NSString *)lat andLongitude:(NSString *)lon{
    
    NSString *currentLat=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude];
    NSString *currentLon=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude];
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude=[currentLat doubleValue];
    coordinate1.longitude=[currentLon doubleValue];
    
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude=[lat doubleValue];
    coordinate2.longitude=[lon doubleValue];
    
    CLLocation *location1=[[CLLocation alloc]initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    
    CLLocation *location2=[[CLLocation alloc]initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    
    CLLocationDistance distance=[location1 distanceFromLocation:location2];
    double miles=distance * 0.000621371;
    NSString * milesStr=[NSString stringWithFormat:@"%0.2f",miles];
    return milesStr;
}
-(NSString *)calculateKilometersFromLatitude:(NSString *)lat andLongitude:(NSString *)lon{
    
    NSString *currentLat=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude];
    NSString *currentLon=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude];
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude=[currentLat doubleValue];
    coordinate1.longitude=[currentLon doubleValue];
    
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude=[lat doubleValue];
    coordinate2.longitude=[lon doubleValue];
    
    CLLocation *location1=[[CLLocation alloc]initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    
    CLLocation *location2=[[CLLocation alloc]initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    
    CLLocationDistance distance=[location1 distanceFromLocation:location2];
    double km=distance * 0.001;
    NSString * kmStr=[NSString stringWithFormat:@"%0.2f",km];
    return kmStr;
}

-(void)openOutOfNetworkviewController:(NSDictionary *)dict{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CTOutOfNetworkViewController *outOfnetwork=[storyboard instantiateViewControllerWithIdentifier:@"CTOutOfNetworkViewController"];
    outOfnetwork.restaurantDetailsDict=dict;
    [self.navigationController pushViewController:outOfnetwork animated:YES];
}

-(void)setRatingStar{
    //    NSOperationQueue *backgroundQueue=[[NSOperationQueue alloc]init];
    //    [backgroundQueue addOperationWithBlock:^{
    //        for(int i=0;i<[self.restaurantListArray count];i++){
    //            NSString *rating=[NSString stringWithFormat:@"%@",[[self.restaurantListArray objectAtIndex:i]objectAtIndex:6]];
    //            NSURL *ratingUrl=[NSURL URLWithString:rating];
    //            NSData *ratingData=[NSData dataWithContentsOfURL:ratingUrl];
    //            //Load map icon by URL
    ////            NSString *map=[NSString stringWithFormat:@"%@",[[self.restaurantListArray objectAtIndex:i]objectAtIndex:7]];
    ////            NSURL *mapUrl=[NSURL URLWithString:map];
    ////            NSData *mapData=[NSData dataWithContentsOfURL:mapUrl];
    //            if(ratingData!=NULL){
    //                NSLog(@"REPLACE INDEX %d",i);
    //                @try{
    //                [self.ratingImageUrlArray replaceObjectAtIndex:i withObject:ratingData];
    //               // [self.mapIconArray replaceObjectAtIndex:i withObject:mapData];
    //                }@catch (NSException *exception) {
    //                    NSLog(@"Replace exception %@",exception);
    //                }
    //            }else{
    //                NSLog(@"NULL DATA AT INDEX %d",i);
    //            }
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                [self.restaurantListTableView reloadData];
    //            }];
    //        }
    //    }];
    
}

@end
