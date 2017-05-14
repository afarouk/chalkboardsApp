//
//  CTRestaurantsViewController.m
//  Community
//
//  Created by practice on 16/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRestaurantsMenuViewController.h"
#import "CTRootControllerDataModel.h"
#import "CTSlideRestaurantCell.h"
#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "NSMutableDictionary+MarkerDetails.h"
#import "MBProgressHUD.h"
#import "ImageNamesFile.h"
#import "CTRestaurnatsMenuHeader.h"
#import "CTWebviewDetailsViewController.h"
#import "CTRootViewController.h"
@interface CTRestaurantsMenuViewController ()<MJSecondPopupDelegate>{
    NSMutableArray *tempSaslSummaryArray;
    NSInteger btnNameTag , btnDistanceTag;
}

@end

@implementation CTRestaurantsMenuViewController

@synthesize callerSender;

#pragma Instance Methods
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)_rootNavController{
    NSLog(@"NAvigation Controller  = %@",_rootNavController);
    btnNameTag = -1;
    btnDistanceTag = -1;
    NSMutableArray *sasls = [CTRootControllerDataModel sharedInstance].saslSummaryArray;
    tempSaslSummaryArray = sasls;
    [self.tableView reloadData];
    rootNavController = _rootNavController;
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 80;
        _rootNavController.view.frame = rootFrame;
        
    }completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)_rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = -frame.size.width;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 0;
        _rootNavController.view.frame = rootFrame;
    } completion:^(BOOL finished) {
    }];
}
-(BOOL)isVisible {
    if(self.navigationController.view.frame.origin.x>=0)
        return YES;
    return NO;
}
#pragma Scope Methods
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
    NSString * milesStr=[NSString stringWithFormat:@"%0.f",miles];
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
typedef void(^RatingImageCompletionBlock)(UIImage *img);
#pragma Scope Methods
-(void)getRatingImageForURL:(NSString*)url dictionary:(NSMutableDictionary*)dictionary completionBlock:(RatingImageCompletionBlock)block {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError)
            block([UIImage imageWithData:data]);
    }];
}
#pragma Control methods
-(void)didTapHideBtn:(id)sender {
    if (!callerSender)
        [self hideMenu:YES withRootNavController:rootNavController];
    else {
        if ([callerSender isKindOfClass:[CTRootViewController class]]) {
            [callerSender performSelectorOnMainThread:NSSelectorFromString([[callerSender dictSelectorAndSender] valueForKey:@"selector"]) withObject:[[callerSender dictSelectorAndSender] valueForKey:@"sender"] waitUntilDone:YES];
        }
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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f);
    
    self.tableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    btnNameTag = -1;
    btnDistanceTag = -1;
    
    NSMutableArray *sasls = [CTRootControllerDataModel sharedInstance].saslSummaryArray ;
    tempSaslSummaryArray = sasls;
    //NSLog(@"tempsasl %@",tempSaslSummaryArray);
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listviewreload:) name:@"ReloadList" object:nil];
}

-(void)listviewreload : (NSNotification *)note
{
//    NSLog(@"----------------------");
    NSMutableArray *sasls = [CTRootControllerDataModel sharedInstance].saslSummaryArray ;
    tempSaslSummaryArray = sasls;
//    NSLog(@"sasl name = %@",[tempSaslSummaryArray valueForKey:@"name"]);
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    //    [btn setImage:img forState:UIControlStateNormal];
    //    [btn setFrame:CGRectMake(self.view.frame.size.width-img.size.width-10, (40-img.size.height)/2, img.size.width, img.size.height)];
    //    [btn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [view addSubview:btn];
    
    
    CTRestaurnatsMenuHeader *view =[[CTRestaurnatsMenuHeader alloc]init];
    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    
    if (btnDistanceTag == -1)
        view.btnDistance.tag = 0;
    else
        view.btnDistance.tag = btnDistanceTag;
    
    if (btnNameTag == -1)
        view.btnName.tag     = 0;
    else
        view.btnName.tag     = btnNameTag;
    
    [view.btnName setImage:nil forState:UIControlStateNormal];
    [view.btnDistance setImage:nil forState:UIControlStateNormal];
    [self setImageForSortButton:view.btnName ForTag:btnNameTag];
    [self setImageForSortButton:view.btnDistance ForTag:btnDistanceTag];
    
    [view.backBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view.btnName addTarget:self action:@selector(btnSortByNamePressed:) forControlEvents:UIControlEventTouchUpInside];
    [view.btnDistance addTarget:self action:@selector(btnSortByDistancePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)setImageForSortButton:(UIButton *)btn ForTag:(NSInteger)tag{
    switch (tag) {
        case 1:{
            [btn setImage:[UIImage imageNamed:@"sort_down_arrow.png"] forState:UIControlStateNormal];
        }
            break;
        case 2:{
            [btn setImage:[UIImage imageNamed:@"sort_up_arrow.png"] forState:UIControlStateNormal];
        }
            break;
        default:{
            //            [btn setImage:nil forState:UIControlStateNormal];tex
        }
            break;
    }
}

- (IBAction)btnSortByNamePressed:(UIButton *)sender{
    switch (sender.tag) {
        case 2:
            tempSaslSummaryArray = [NSMutableArray arrayWithArray:[CTRootControllerDataModel sharedInstance].saslSummaryArray];
            btnNameTag = 0;
            break;
        case 0:
            tempSaslSummaryArray = [[CTRootControllerDataModel sharedInstance].saslSummaryArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary * obj1,NSMutableDictionary * obj2) {
                NSComparisonResult resultName = [[obj1 name] compare:[obj2 name]];
                return resultName;
            }].mutableCopy;
            btnNameTag = sender.tag + 1;
            break;
        case 1:
            tempSaslSummaryArray = [[CTRootControllerDataModel sharedInstance].saslSummaryArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary * obj1, NSMutableDictionary * obj2) {
                NSComparisonResult resultName = [[obj2 name] compare:[obj1 name]];
                return resultName;
            }].mutableCopy;
            btnNameTag = sender.tag + 1;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (IBAction)btnSortByDistancePressed:(UIButton *)sender{
    switch (sender.tag) {
        case 2:
            tempSaslSummaryArray = [NSMutableArray arrayWithArray:[CTRootControllerDataModel sharedInstance].saslSummaryArray];
            btnDistanceTag = 0;
            break;
        case 0:{
            tempSaslSummaryArray = [[CTRootControllerDataModel sharedInstance].saslSummaryArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary * obj1, NSMutableDictionary * obj2) {
                NSComparisonResult result;
                float dist1, dist2;
                
                dist1 = [[obj1 valueForKeyPath:@"distanceInMiles"] floatValue];
                dist2 = [[obj2 valueForKeyPath:@"distanceInMiles"] floatValue];
                
                if (dist1 > dist2)
                    result = NSOrderedDescending;
                else if (dist1 < dist2)
                    result = NSOrderedAscending;
                else
                    result = NSOrderedSame;
                
                return result;
            }].mutableCopy;
            btnDistanceTag = sender.tag + 1;
        }
            break;
        case 1:{
            btnDistanceTag = sender.tag + 1;
            tempSaslSummaryArray = [[CTRootControllerDataModel sharedInstance].saslSummaryArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary * obj1, NSMutableDictionary * obj2) {
                NSComparisonResult result;
                double dist1, dist2;
                
                dist1 = [[obj2 valueForKeyPath:@"distanceInMiles"] floatValue];
                dist2 = [[obj1 valueForKeyPath:@"distanceInMiles"] floatValue];
                
                if (dist1 > dist2)
                    result = NSOrderedDescending;
                else if (dist1 < dist2)
                    result = NSOrderedAscending;
                else
                    result = NSOrderedSame;
                
                return result;
            }].mutableCopy;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
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
    return [tempSaslSummaryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTSlideRestaurantCell *restaurantCell=(CTSlideRestaurantCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSlideRestaurantCell" owner:self options:nil];
    restaurantCell.textLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    restaurantCell=[nib objectAtIndex:0];
    //restaurantCell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    if([tempSaslSummaryArray count]!=0){
        @try{
            NSMutableDictionary *dictionary = [tempSaslSummaryArray objectAtIndex:indexPath.row];
//            NSLog(@"print this dictionary %@",dictionary);
            restaurantCell.restaurantNameLbl.text= [dictionary name];
            NSString *lat=[NSString stringWithFormat:@"%@",[dictionary latitude]];
            NSString *lon=[NSString stringWithFormat:@"%@",[dictionary longitude]];
            restaurantCell.miles.text=[NSString stringWithFormat:@"%@Km",[self calculateKilometersFromLatitude:lat andLongitude:lon]];
            restaurantCell.kilometers.text=[NSString stringWithFormat:@"%@ Miles",[dictionary valueForKey:@"distanceInMiles"]];//[self calculateMilesFromLatitude:lat andLongitude:lon]
            //            restaurantCell.kilometers.font = [UIFont systemFontOfSize:12.];
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
            restaurantCell.ratingImgView.hidden = YES;
            CGRect tempRect = restaurantCell.kilometers.frame;
            tempRect.origin.x -= 30;
            restaurantCell.kilometers.frame = tempRect;
            if (![dictionary inNetwork]) {
                //                restaurantCell.ratingImgView.image = [UIImage imageNamed:@"yourimagehere_320x240.jpg"];
                //                restaurantCell.restaurantNameLbl.backgroundColor = [UIColor colorWithWhite:1. alpha:.5];
                restaurantCell.restaurantNameLbl.textColor = [UIColor colorWithWhite:1. alpha:.5];
                //                restaurantCell.restaurantNameLbl.alpha = .5;
            }
            else{
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
        }
        @catch (NSException *exception) {
            NSLog(@"CELL RATING URL EXCEPTION %@",exception);
        }
    }
    restaurantCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    restaurantCell.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0f];
    // seperator
//    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, restaurantCell.frame.size.height-1, self.tableView.frame.size.width, 1)];
//    separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
//    [restaurantCell.contentView addSubview:separator];
    // selected background
    UIView *selectedBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    selectedBackground.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f];
    //    restaurantCell.selectedBackgroundView = selectedBackground;
    
    restaurantCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return restaurantCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *restaurant = [tempSaslSummaryArray objectAtIndex:indexPath.row];
    [[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
    //    NSLog(@"selectecd %@",[dictionary name]);
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    NSLog(@"get ddict %@",restaurant);
    NSString *sa=[restaurant serviceAccommodatorId];
    NSString *sl=[restaurant serviceLocationId];
    
    id address = [restaurant valueForKey:@"address"];
    //NSLog(@"hello dict add %@",address);
    // call delegate
    //    [self.delegate didTapRestaurantDetailsForSA:sa andSL:sl];
    
    NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    //    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
    //    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
    //    if([restaurant inNetwork]){
    //        [CTWebServicesMethods getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon completionBlock:^(NSString *errorTitle, NSString *errorMessage, id JSON) {
    //            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    //            }];
    //            if(JSON) {
    //                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                    [self.delegate didTapAndGetRestaruantDetails:JSON];
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
    //    }
    //    else{
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    ////        [self openOutOfNetworkviewController:restaurant];
    //        [self.delegate didTapAndGetRestaruantDetails:nil];
    //    }
    //
    
}

- (void)dismissSubViewWithAnimation {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    [UIView animateWithDuration:0.35f animations:^{
        //        self.mapview.frame = CGRectMake(0, self.view.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
    }];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
