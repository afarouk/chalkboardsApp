//
//  CTAdAlertViewController.m
//  Community
//
//  Created by BBITS Dev on 29/06/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTAdAlertViewController.h"
#import "CTCommonMethods.h"
#import "MBProgressHUD.h"
#import "CTRootControllerDataModel.h"
#import "Constants.h"
#import "ImageNamesFile.h"
#import "CTParentViewController.h"
#import "CTAppDelegate.h"
#import "AsyncImageView.h"

#import "CTWebviewDetailsViewController.h"

@implementation ABCD



@end

@interface CTAdAlertViewController ()<MJSecondPopupDelegate>{
    int selectionAllowed;
}

@end

@implementation CTAdAlertViewController

@synthesize callerSender;

@synthesize arrAdAlertData, delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [AsyncImageLoader sharedLoader].cache = [AsyncImageLoader defaultCache];
    tblViewAdAlert.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    tblViewAdAlert.separatorColor = [UIColor clearColor];
    
    tblViewAdAlert.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    self.view.backgroundColor =  tblViewAdAlert.backgroundColor;
    self.navigationItem.rightBarButtonItem = [self backButton];
    
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 22, 22)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
}
-(void)didTapBackButtonOnFavorites:(id)sender {
    
    if (!callerSender)
        [self hideMenu:YES withRootNavController:rootController];
    else {
        if ([callerSender isKindOfClass:[CTRootViewController class]]) {
            [callerSender performSelectorOnMainThread:NSSelectorFromString([[callerSender dictSelectorAndSender] valueForKey:@"selector"]) withObject:[[callerSender dictSelectorAndSender] valueForKey:@"sender"] waitUntilDone:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

static int rowHeight = 40;

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
//    if(selectionAllowed == 0)
//        selectionAllowed = 1;
    return [[arrAdAlertData valueForKeyPath:@"notifications"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifire = @"adAlertCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
    }
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,2*rowHeight)];
    
    UILabel *lblFirst, *lblSecond;
    AsyncImageView *imgView = [[AsyncImageView alloc] initWithFrame:CGRectMake((2*(tableView.frame.size.width/3))+20, 12, (tableView.frame.size.width/2)-90, (2*rowHeight) -24)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
//    lblFirst  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (tableView.frame.size.width/2) -1,rowHeight)];
        lblFirst  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (tableView.frame.size.width/2)+10,rowHeight)];
//    lblSecond = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width/2), 0, (tableView.frame.size.width/2) -1,rowHeight)];
    lblSecond = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width/2)+11, 0, (tableView.frame.size.width/2) -12,rowHeight)];
    
    lblFirst  = [[UILabel alloc] initWithFrame:CGRectMake(8, 0,10 + 2*(tableView.frame.size.width/3),rowHeight +10)];
    lblSecond = [[UILabel alloc] initWithFrame:CGRectMake(8, rowHeight +6, (tableView.frame.size.width/2) -15,rowHeight -4)];
    lblFirst.textColor = [UIColor whiteColor];
    lblSecond.textColor = [UIColor whiteColor];
    lblFirst.numberOfLines = 0;
    
    @try {
        lblSecond.text  = [[arrAdAlertData valueForKeyPath:@"notifications.saslName"]         objectAtIndex:indexPath.row];
        lblFirst.text = [[arrAdAlertData valueForKeyPath:@"notifications.notificationBody"] objectAtIndex:indexPath.row];
        NSString *url = [[arrAdAlertData valueForKeyPath:@"notifications.appIconURL"] objectAtIndex:indexPath.row];

        imgView.showActivityIndicator = YES;
        imgView.image = nil;
        imgView.imageURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        imgView.activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            if(!connectionError && data) {
//                UIImage *image = [UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [imgView setImage:image];
//                    imgView.hidden = NO;
//                });
//            }else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    imgView.hidden = NO;
//                });
//            }
//        }];
        
//        lblFirst.text = [@"  " stringByAppendingString:lblFirst.text];
//        lblSecond.text = [@"  " stringByAppendingString:lblSecond.text];
    }
    @catch(NSException *exception) {
        
    }
    
    lblFirst.backgroundColor  = [UIColor clearColor];
    lblSecond.backgroundColor = [UIColor clearColor];
    lblFirst.textAlignment = NSTextAlignmentLeft;
    lblFirst.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    lblSecond.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:14];
    viewHeader.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    cell.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0f];
    
    // seperator
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeader.frame.size.height-1, viewHeader.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
    [viewHeader addSubview:separator];
    
    // selected background
    UIView *selectedBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    selectedBackground.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f];
//    cell.selectedBackgroundView = selectedBackground;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = viewHeader.frame;
    button.backgroundColor = [UIColor clearColor];
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(cellDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    imgView.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblFirst];
    [viewHeader addSubview:lblSecond];
    [viewHeader addSubview:imgView];
    [cell addSubview:viewHeader];
    [cell addSubview:button];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(IBAction)cellDidSelected:(UIButton *)sender{
    
    
    id restaurant = [[arrAdAlertData valueForKeyPath:@"notifications"]
                     objectAtIndex:sender.tag];
//    [self.delegate didTapAndGetRestaruantDetailsFromAdAlertControllerWithURL:[restaurant valueForKeyPath:@"url"]];

//    @synchronized(self){
//        if (selectionAllowed == 2) {
//            selectionAllowed = 1;
//            return;
//        }
//        selectionAllowed = 2;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//
//            if (selectionAllowed == 2) {
//                selectionAllowed = 1;
//                return;
//            }
//            selectionAllowed = 2;
            CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
            webController.isFromRootView = YES;
            webController.delegate = self;
            webController.strLoadUrl = [restaurant valueForKeyPath:@"url"];
//            [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
    
//        });
//    }
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (2*rowHeight);
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    if (selectionAllowed == 2) {
//        return;
//    }
//    selectionAllowed = 2;

    id restaurant = [[arrAdAlertData valueForKeyPath:@"notifications"]
                     objectAtIndex:indexPath.row];
    //    [[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
    //    NSString *sa=[restaurant valueForKeyPath:@"fromServiceAccommodatorId"];
    //    NSString *sl=[restaurant valueForKeyPath:@"fromServiceLocationId"];
    //    [self.delegate didTapAndGetRestaruantDetailsFromAdAlertController:sa andSL:sl];
    
    //    [self.delegate didTapAndGetRestaruantDetailsFromAdAlertControllerWithURL:[restaurant valueForKeyPath:@"url"]];
    
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.isFromRootView = YES;
    webController.delegate = self;
    webController.strLoadUrl = [restaurant valueForKeyPath:@"url"];
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
    
}


//- (CGFloat)tableView:(UITableView *)tableView
//heightForHeaderInSection:(NSInteger)section{
//    return 1;
//    return rowHeight+1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section{
//    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,rowHeight)];
//    
//    UILabel *lblFirst, *lblSecond;
//    
//    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setFrame:CGRectMake(tableView.frame.size.width-30, 10, 25, 25)];
//    [backButton setImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    lblFirst = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (tableView.frame.size.width/2) -1,rowHeight)];
//    lblSecond = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width/2), 0, (tableView.frame.size.width/2) -1,rowHeight)];
//    
//    lblFirst.textColor = [UIColor whiteColor];
//    lblFirst.text = @"Business name";
//    
//    lblSecond.textColor = [UIColor whiteColor];
//    lblSecond.text = @"Alert";
//    
//    lblSecond.textAlignment = NSTextAlignmentCenter;
//    lblFirst.textAlignment  = NSTextAlignmentCenter;
//    
//    viewHeader.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
//    
//    // seperator
//    UILabel *separator = [[UILabel alloc]initWithFrame:CGRectMake((tableView.frame.size.width/2)+10, -1, 2, rowHeight + 1)];
//    separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
//    
//    [viewHeader addSubview:lblFirst];
//    [viewHeader addSubview:lblSecond];
//    [viewHeader addSubview:backButton];
//    [viewHeader addSubview:separator];
//    
//    return viewHeader;
//}

#pragma mark - 
- (void)adAlertWebServiceCall {
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    
    //    NSDictionary *restaurantDetails = [[CTRootControllerDataModel sharedInstance]selectedRestaurant];
    //    NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
    //    NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
    //    localhost:8080/apptsvc/rest/communication/getNotificationsByUIDAndLocation?UID=user20.781305772384780045&latitude=37.317673&longitude=-122.003089
    
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CLLocationCoordinate2D tempCord = parentController.rootViewController.mapview.centerCoordinate;
    
    NSString *url=[NSString stringWithFormat:@"%@communication/getNotificationsByUIDAndLocation?UID=%@&latitude=%f&longitude=%f",[CTCommonMethods getChoosenServer],[CTCommonMethods UID],tempCord.latitude,tempCord.longitude];
    
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_GET contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (JSON) {
                @try {
                    //                    NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                    
                    
                    //                    [CTCommonMethods showErrorAlertMessageWithTitle:@"Work in progress" andMessage:@""];
                    arrAdAlertData = @{
                                       @"hasNext": @"0",
                                       @"hasPrevious": @"0",
                                       @"notifications":  @[
                                               @{
                                                   @"saslName": @"Le Food Truck",
                                                   @"notificationBody": @"Today only, salmon dinners, half-price!",
                                                   @"appIconURL": @"http://localhost:8080/apptsvc/rest/sasl/retrieveATC60bySASL?serviceAccommodatorId=FTRFCD1&serviceLocationId=FTRFCD1"
                                                   }
                                               ],
                                       @"totalAvailableCount": @"0"
                                       };
                    arrAdAlertData = JSON;
                    [tblViewAdAlert reloadData];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in viewDidLoad %@",exception);
                }
            }
            NSLog(@"viewDidLoad Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"adAlertBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
}

-(void)reloadTableData{
    arrAdAlertData = nil;
    [tblViewAdAlert reloadData];
    [self adAlertWebServiceCall];
    [tblViewAdAlert reloadData];
}

-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController{
    rootController = rootNavController;
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = rootNavController.view.frame;
        rootFrame.origin.x = 130;
        rootNavController.view.frame = rootFrame;
        
    }completion:^(BOOL finished) {
        //        [self.tableView reloadData];
    }];
}

-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController{
    rootController = rootNavController;
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

-(BOOL)isVisible{
    if(self.navigationController.view.frame.origin.x>=0)
        return YES;
    return NO;
}

-(IBAction)backButtonPressed:(UIButton *)btn{
    
    if (!callerSender)
        [self hideMenu:YES withRootNavController:rootController];
    else {
        if ([callerSender isKindOfClass:[CTRootViewController class]]) {
            [callerSender performSelectorOnMainThread:NSSelectorFromString([[callerSender dictSelectorAndSender] valueForKey:@"selector"]) withObject:[[callerSender dictSelectorAndSender] valueForKey:@"sender"] waitUntilDone:YES];
        }
    }
}

@end
