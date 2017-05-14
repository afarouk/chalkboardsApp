//
//  CTFavoritesViewController.m
//  Community
//
//  Created by practice on 16/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFavoritesMenuViewController.h"
#import "MBProgressHUD.h"
#import "CTFavoriteTableCell.h"
#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "NSMutableDictionary+MarkerDetails.h"
#import "NSArray+RestaurantSummaryByUIDAndLocation.h"
#import "NSArray+SASLSummaryByUIDAndLocation_Package.h"
#import "CTRootControllerDataModel.h"
#import "ImageNamesFile.h"
@interface CTFavoritesMenuViewController ()

@end

@implementation CTFavoritesMenuViewController
typedef void(^RatingImageCompletionBlock)(UIImage *img);
#pragma Scope Methods
-(void)getRatingImageForURL:(NSString*)url dictionary:(NSMutableDictionary*)dictionary completionBlock:(RatingImageCompletionBlock)block {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError)
            block([UIImage imageWithData:data]);
    }];
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
-(void)deleteFavoriteRestaurant:(NSString *)urlKey{
    
    NSString *UID=[CTCommonMethods UID];
    NSString *params=[NSString stringWithFormat:@"UID=%@&urlKey=%@",UID,urlKey];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_DeleteFavorite,params];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Item Removed from your favorite list"];
        //        [self retriveFavorite];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    //UID=user20.781305772384780045&urlKey=GBvOpikmQqKAAABQBM7Or0dPTRgmZyA
}

-(void)retriveFavorite{
    
    NSString *param=[NSString stringWithFormat:@"UID=%@",[CTCommonMethods UID] ];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_RetriveFavorite,param];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //        NSError *jsonError;
    //        id JSON =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    //        if([CTCommonMethods validateJSON:JSON] == FALSE ) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                NSDictionary *errorDict=(NSDictionary *)JSON;
    //                NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
    //                NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    //                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:errorMsgStr];
    //            });
    //
    //        }else {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                favoritesArray=[(NSArray*)JSON deepMutableCopy];
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    //                [self.tableView reloadData];
    //            });
    //
    //        }
    //
    //    }];
    //    [[CTFavoritesDataModel sharedInstance] retriveFavoritesWithCompletionBlock:^(NSError *error, id JSON) {
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        if(!error) {
    //            favoritesArray=[(NSArray*)JSON deepMutableCopy];
    //            [self.tableView reloadData];
    //        }else {
    //            NSDictionary *errorDict=(NSDictionary *)JSON;
    //            NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
    //            NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
    //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:errorMsgStr];
    //        }
    //    }];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCCESS");
        favoritesArray=[(NSArray*)JSON deepMutableCopy];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
-(void)setMarkerImageForCell:(CTFavoriteTableCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    @try{
        NSMutableDictionary *restaurantDict=(NSMutableDictionary*)[favoritesArray restaurantSASLSummary:indexPath.row];
        NSMutableArray  *mapMarkers=(NSMutableArray*)[restaurantDict saslMapMarkers];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",[CTRootControllerDataModel sharedInstance].selectedCategory];
        NSMutableDictionary *mutableMarkerDictionary = [[mapMarkers filteredArrayUsingPredicate:predicate] lastObject];
        if([mutableMarkerDictionary markerImage]) {
            cell.mapMarkerIcon.image =[mutableMarkerDictionary markerImage];
            return;
        }
        if(mutableMarkerDictionary) {
            NSLog(@"marker dictionary %@",mutableMarkerDictionary);
            NSString *markerURL=[mutableMarkerDictionary apiMarkerURL];
            
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:markerURL]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if(!connectionError) {
                    UIImage *img = [[UIImage alloc]initWithData:data];
                    if(img) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.mapMarkerIcon.image = img;
                        });
                        [mutableMarkerDictionary setMarkerImage:img];
                    }else {
                        NSLog(@"data is %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                        // pass default image
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.mapMarkerIcon.image = [UIImage imageNamed:CT_MapPinImage_Default];
                        });
                    }
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.mapMarkerIcon.image = [UIImage imageNamed:CT_MapPinImage_Default];
                        
                    });
                }
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"CELL RATING URL EXCEPTION %@",exception);
    }
    
    
}
#pragma Instance Methods
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)_rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    rootNavController= _rootNavController;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 190;
        _rootNavController.view.frame = rootFrame;
        
    }completion:^(BOOL finished) {
    }];
}
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = -frame.size.width;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = rootNavController.view.frame;
        rootFrame.origin.x = 0;
        rootNavController.view.frame = rootFrame;
    } completion:^(BOOL finished) {
    }];
    
}
-(BOOL)isVisible {
    if(self.navigationController.view.frame.origin.x>=0)
        return YES;
    return NO;
}
#pragma Control Methods
-(void)didTapHideBtn:(id)sender {
    [self hideMenu:YES withRootNavController:rootNavController];
}
-(void)didPan:(UIPanGestureRecognizer*)paneGesture {
    static CGPoint origionalCenter;
    static CGPoint rootControllerOrigionalCenter;
    static BOOL moveLeft = NO;
    if(paneGesture.state == UIGestureRecognizerStateBegan) {
        origionalCenter = self.navigationController.view.center;
        rootControllerOrigionalCenter = [rootNavController view].center;
    }
    else if(paneGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paneGesture translationInView:self.navigationController.view];
        if(origionalCenter.x+translation.x<=self.navigationController.view.frame.size.width/2) {
            paneGesture.view.center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
            if(rootControllerOrigionalCenter.x+translation.x>=[rootNavController view].frame.size.width/2)
                [rootNavController view].center= CGPointMake(rootControllerOrigionalCenter.x+translation.x, rootControllerOrigionalCenter.y);
        }
        NSLog(@"root controller translation %f",rootControllerOrigionalCenter.x+translation.x);
        
        // check direction.
        CGPoint velocity = [paneGesture velocityInView:self.navigationController.view];
        if(velocity.x > 0)
            moveLeft = NO;
        else
            moveLeft = YES;
    } else if (paneGesture.state == UIGestureRecognizerStateEnded ||
               paneGesture.state == UIGestureRecognizerStateFailed ||
               paneGesture.state == UIGestureRecognizerStateCancelled)
    {
        if(moveLeft)
            [self hideMenu:YES withRootNavController:rootNavController];
        else
            [self showMenu:YES withRootNavController:rootNavController];
    }
    
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // hide btn
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    [self.hideBtn setImage:img forState:UIControlStateNormal];
    [self.hideBtn setFrame:CGRectMake(0,0, img.size.width, img.size.height)];
    [self.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    // pan gesture
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    //    [self.navigationController.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    self.hideBtn.center = CGPointMake(self.view.frame.size.width-(self.hideBtn.frame.size.width/2)-10, self.hideBtn.imageView.image.size.height/2);
    [view addSubview:self.hideBtn];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [favoritesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFavoriteTableCell *restaurantCell=(CTFavoriteTableCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTFavoriteTableCell" owner:self options:nil];
    restaurantCell=[nib objectAtIndex:0];
    @try {
        
        NSMutableDictionary *dictionary = [favoritesArray objectAtIndex:indexPath.row];
        //    NSString *icon=[favoriteDict icon:indexPath.row];
        NSString *messagecount=[NSString stringWithFormat:@"%@",[favoritesArray messageFromSASLCount:indexPath.row]];
        //    restaurantCell.restaurantImg.image=[UIImage imageWithData:[NSData dataFromBase64String:icon]];
        restaurantCell.notificationCount.text=messagecount;
        restaurantCell.nameLabel.text = [favoritesArray name:indexPath.row];
        NSString *lat=[NSString stringWithFormat:@"%@",[dictionary latitude]];
        NSString *lon=[NSString stringWithFormat:@"%@",[dictionary longitude]];
        restaurantCell.km.text = [NSString stringWithFormat:@"%@Km",[self calculateKilometersFromLatitude:lat andLongitude:lon]];
        [self setMarkerImageForCell:restaurantCell forIndexPath:indexPath];
        if([dictionary ratingImage])
            restaurantCell.ratingImg.image=[dictionary ratingImage];
        else {
            [self getRatingImageForURL:[dictionary rating_img_url] dictionary:dictionary completionBlock:^(UIImage *img) {
                [dictionary setRatingImage:img];
                dispatch_async(dispatch_get_main_queue(), ^{
                    restaurantCell.ratingImg.image = img;
                });
            }];
            
        }
        // seperator
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, restaurantCell.frame.size.height-1, self.tableView.frame.size.width, 1)];
        separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
        [restaurantCell.contentView addSubview:separator];
        // selected background
        UIView *selectedBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        selectedBackground.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f];
        restaurantCell.selectedBackgroundView = selectedBackground;
        
    }
    @catch (NSException *exception) {
        NSLog(@"--> Exception %@",exception
              );
    }
    return restaurantCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *restaurant = [favoritesArray objectAtIndex:indexPath.row];
    [[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
    
    //    NSLog(@"selectecd %@",[dictionary name]);
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    
    NSString *sa=[restaurant serviceAccommodatorId];
    NSString *sl=[restaurant serviceLocationId];
    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
    
    [self.delegate didTapAndGetRestaruantDetailsFromFavoritesController:sa andSL:sl];
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    return;
    if([restaurant inNetwork]){
        [CTWebServicesMethods getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon completionBlock:^(NSString *errorTitle, NSString *errorMessage, id JSON) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            if(JSON) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self.delegate didTapAndGetRestaruantDetailsFromFavoritesController:JSON];
                }];
                
            }else {
                // it's an error.
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [CTCommonMethods showErrorAlertMessageWithTitle:errorTitle andMessage:errorMessage];
                }];
            }
        }];
        //        [self getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [self openOutOfNetworkviewController:restaurant];
        [self.delegate didTapAndGetRestaruantDetailsFromFavoritesController:nil];
    }
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *pURL = [favoritesArray permanentURL:indexPath.row];
        [favoritesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //        [self deleteFavoriteRestaurant:pURL];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[CTFavoritesDataModel sharedInstance] deleteFavoriteRestaurant:pURL completionBlock:^(NSError *error, id JSON) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!error) {
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Item Removed from your favorite list"];
            }else {
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
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
