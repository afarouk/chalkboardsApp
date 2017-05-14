//
//  CTSlideMenuViewController.m
//  Community
//
//  Created by practice on 15/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSlideMenuViewController.h"
#import "ImageNamesFile.h"
#import "CTAuthPanelViewController.h"
#import "CTLoginPopup.h"
#import "CTAppDelegate.h"
#import "CTParentViewController.h"
#import "CTFavoritesMenuViewController.h"
#import "CTMyReservationsViewController.h"
#import "MBProgressHUD.h"
#import "CTMessageViewController.h"
#import "CTSearchLocationViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTInviteView.h"
#import "CTSupportviewViewController.h"
#import "RedirectNSLogs.h"

#define kAlertViewTag_Login 2
#define kAlertViewTag_Retry 1
@interface CTSlideMenuViewController ()<MFMailComposeViewControllerDelegate> {
    CTSearchLocationViewController *searchController;
}

@end

@implementation CTSlideMenuViewController
#define kAuthenticationOption_Login @"Login"
#define kAuthenticationOption_Logout @"Logout"
#pragma Scope Methods
@synthesize isAdAlertView;

- (void) authenticateUser {
    __block NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *params=[NSString stringWithFormat:@"UID=%@21",[defaults valueForKey:UIDInDefaults]];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_GetAuthenticationStatus,params];
    
    [CTWebServicesMethods sendRequestWithURL:urlString params:nil method:kHTTPMethod_GET contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (JSON) {
                @try {
//                    NSLog(@"JSON Response %@",JSON);
                    id tempObj = [JSON valueForKeyPath:@"action.enumText"];
                    if (tempObj){
                        if([tempObj isEqualToString:@"NO_ACTION"]) {
                            [CTCommonMethods setUID:[defaults valueForKey:UIDInDefaults]];
                            [CTCommonMethods setUserName:[defaults valueForKey:UserNameInDefaults]];
                            [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
                            [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
                        }
                        else if([tempObj isEqualToString:@"FORCE_LOGOUT"]) {
                            [defaults setValue:nil forKey:UIDInDefaults];
                            [defaults setValue:nil forKey:UserNameInDefaults];
                            [CTCommonMethods setUID     :[defaults valueForKey:UIDInDefaults]];
                            [CTCommonMethods setUserName:[defaults valueForKey:UserNameInDefaults]];
                        }
                    }
                    else{
                        
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in authenticateUser %@",exception);
                }
            }
//            NSLog(@"authenticateUser Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"authenticateUser Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
}

-(void)logoutUserWithUID:(NSString*)uid {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *params=[NSString stringWithFormat:@"UID=%@",uid];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_logoutUser,params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // hide hud.
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(!connectionError) {
                
                NSError *jsonError;
                id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSError *exception = [CTCommonMethods validateJSON:JSON];
                if(jsonError || exception) {
                    NSString *message = exception.localizedDescription;
                    message = [message stringByAppendingString:@"would you like to try again?"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:exception.localizedFailureReason message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                    alert.tag = kAlertViewTag_Retry;
                    [alert show];
                }else {
                    [CTCommonMethods showErrorAlertMessageWithTitle:@"Sucessfully logged out" andMessage:@"You have successfully logged out"];
                    [self hideMenu:YES withRootNavController:rootNavController];
                    [CTCommonMethods setUID:nil];
                    [CTCommonMethods setUserName:nil];
                    [CTCommonMethods sharedInstance].OWNERFLAG = NO;
                    [CTCommonMethods sharedInstance].RestaurantSASLName = [[NSMutableArray alloc] init];
                    [CTCommonMethods sharedInstance].RestaurantSA = [[NSMutableArray alloc] init];
                    [CTCommonMethods sharedInstance].RestaurantSL = [[NSMutableArray alloc] init];
                    
                    NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
                    [yourDictionary setObject:@"" forKey:@"USERNAME_KEY"];
                    [yourDictionary setObject:@"" forKey:@"PASSWORD_KEY"];
                    [yourDictionary setObject:@"" forKey:@"email"];
                    [yourDictionary setObject:@"" forKey:@"uid"];
                    [yourDictionary setObject:@"" forKey:@"isOwner"];
                    [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"DicKey"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
                    [[NSUserDefaults standardUserDefaults] setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
                    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedOut object:nil];
                    
                    
                    
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Could not connect to server" message:CT_ServerNotAccessibleMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                alert.tag = kAlertViewTag_Retry;
                [alert show];
                
            }
        });

    }];

}
-(void)didTapBackButtonOnFavorites:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)reloadTableData{
    [self.tableView reloadData];
}
#pragma Instance Methods
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)_rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    rootNavController = _rootNavController;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 20;
        _rootNavController.view.frame = rootFrame;
        
    }completion:^(BOOL finished) {
        
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
-(UITableViewCell*)configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
//    UIImage *imgFavourite = ([CTCommonMethods UID] != nil && [[CTCommonMethods UID] length] > 1) ? [UIImage imageNamed:Ct_Favourite] : [UIImage imageNamed:CT_FavoriteIcon];
    UIImage *imgFavourite = ([CTCommonMethods UID] != nil && [[CTCommonMethods UID] length] > 1) ? [UIImage imageNamed:Ct_Favourite] : [UIImage imageNamed:Ct_NotFavourite];
//    if(indexPath.row == 0 && [CTCommonMethods isUIDStoredInDevice]){
//        cell.textLabel.text = kAuthenticationOption_Logout;
//        imgFavourite = [UIImage imageNamed:Ct_Favourite];
//    }
//    else if(indexPath.row == 0 &&[CTCommonMethods isUIDStoredInDevice] == FALSE)
//        cell.textLabel.text = kAuthenticationOption_Login;
//    else
        cell.textLabel.text = [self.rows objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CT_DetailDisclosureIconWhite]];
    cell.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0f];
    // seperator
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.tableView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
    [cell.contentView addSubview:separator];
    // selected background
    UIView *selectedBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    selectedBackground.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f];
    cell.selectedBackgroundView = selectedBackground;
    cell.imageView.contentMode = UIViewContentModeCenter;
    switch (indexPath.row) {
        case 1:
            cell.imageView.image = [UIImage imageNamed:CT_LoginIcon];
            cell.textLabel.text = [@" " stringByAppendingString:cell.textLabel.text];
            break;
        case 0:
            cell.imageView.image = imgFavourite;
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:CT_SearchIcon];
            cell.textLabel.text = [@"  " stringByAppendingString:cell.textLabel.text];
            break;
//        case 2:
//            cell.imageView.image = [UIImage imageNamed:CT_PromotionIcon];
//            break;
//        case 3:
//            cell.imageView.image = [UIImage imageNamed:CT_MessageIcon];
//            break;
//        case 4:
//            cell.imageView.image = [UIImage imageNamed:CT_BookingIcon];
//            break;
        default:
            break;
    }
    return cell;
}
#pragma Control Methods
-(void)didTapHideBtn:(id)sender {
    [self hideMenu:YES withRootNavController:rootNavController];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        self.rows = [NSMutableArray arrayWithObjects:@"Login",@"My Favorites",@"My Promotions",@"My Messages",@"My Reservations", nil];
        self.rows = [NSMutableArray arrayWithObjects:@"Login",@"Book marks",@"Address search", nil];
        self.rows = [NSMutableArray arrayWithObjects:@"Book marks",@"Enter invitation code",@"Support", nil];
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
    self.tableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
//    self.navigationItem.title = @"Menu";
    // frame
//    self.navigationController.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width-60, self.navigationController.view.frame.size.height);
//    self.view.frame = CGRectMake(0, 22, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height-64);
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height - 160, self.tableView.frame.size.width, 160)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapOnLabel:)];
    gesture.numberOfTapsRequired = 2;
    gesture.cancelsTouchesInView = YES;
    [lbl addGestureRecognizer:gesture];
    
    lbl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.tableView addSubview:lbl];
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(self.view.frame.size.width-img.size.width-10, (40-img.size.height)/2, img.size.width, img.size.height)];
    [btn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
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
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    return [self configureCell:cell forIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1) {
//        CTAuthPanelViewController *loginController = [[CTAuthPanelViewController alloc]initWithStyle:UITableViewStylePlain];
//        [self.navigationController pushViewController:loginController animated:YES];
        
        
        
            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
            CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
           // CTInviteViewpopupViewController *invitaionPopup = [[CTInviteViewpopupViewController alloc]init];
            [self hideMenu:YES withRootNavController:rootNavController];
            //invitaionPopup.mjSecondPopupDelegate = self;
            //[self presentPopupViewController:invitaionPopup animationType:MJPopupViewAnimationSlideBottomTop];
        
            [appDelegate.window.rootViewController.view addSubview:invitaionPopup];
        
//        if([CTCommonMethods isUIDStoredInDevice] == NO) {
//            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
//            CTLoginPopup *loginPopup = [[CTLoginPopup alloc]init];
//            [appDelegate.window.rootViewController.view addSubview:loginPopup];
//            [self hideMenu:YES withRootNavController:rootNavController];
//        }else {
//            NSLog(@"LOGOUT TAPED");
//            [self logoutUserWithUID:[CTCommonMethods UID]];
//        }
        
    }else if(indexPath.row == 0) {
        if([CTCommonMethods isUIDStoredInDevice]){
            CTFavoritesMenuViewController *favorites = [[CTFavoritesMenuViewController alloc]initWithStyle:UITableViewStylePlain];
            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
            favorites.delegate =(CTParentViewController*)appDelegate.window.rootViewController;
            [favorites retriveFavorite];
            favorites.navigationItem.leftBarButtonItem = [self backButton];
            favorites.navigationItem.title = @"Favorites";
            [self.navigationController pushViewController:favorites animated:YES];
            [favorites.hideBtn removeTarget:favorites action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [favorites.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else {
//            CTLoginPopup *login = [[CTLoginPopup alloc]init];
//            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
//            [appDelegate.window.rootViewController.view addSubview:login];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
            alert.tag = kAlertViewTag_Login;
            [alert show];
        }

    }
    else if(indexPath.row == 2) {
        CTSupportviewViewController * mysupport = [[CTSupportviewViewController alloc] initWithNibName:@"CTSupportviewViewController" bundle:nil];
        CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
        mysupport.delegate = (CTParentViewController*)appDelegate.window.rootViewController;
        mysupport.navigationItem.leftBarButtonItem = [self backButton];
        //mysupport.navigationItem.title = @"Address Search";
        mysupport.navigationItem.title = @"Support";
        [UIView animateWithDuration:0.1 animations:^{
            [self.navigationController pushViewController:mysupport animated:YES];
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [mysupport.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            
           
        }];
        /*
        searchController = [[CTSearchLocationViewController alloc]initWithStyle:UITableViewStylePlain];
//        CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
//        searchController.delegate =(CTParentViewController*)appDelegate.window.rootViewController;
        searchController.navigationItem.leftBarButtonItem = [self backButton];
        searchController.navigationItem.title = @"Address Search";
        [UIView animateWithDuration:0.1 animations:^{
            [self.navigationController pushViewController:searchController animated:YES];
        } completion:^(BOOL finished) {
//            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [searchController.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            __weak typeof (self) weakSelf = self;
            searchController.callBack = ^(NSString *street,NSString* city,NSString* zip) {
                [weakSelf submitSearchQueryForStreet:street city:city zip:zip];
            };
        }];
         */
//        searchController.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *img = [UIImage imageNamed:CT_BackIcon];
//        [searchController.hideBtn setImage:img forState:UIControlStateNormal];
//        [searchController.hideBtn setFrame:CGRectMake(0,0, img.size.width, img.size.height)];
    }
    
//    else if(indexPath.row == 3) {
////        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
////        CTMessageViewController *messageController=[storyboard instantiateViewControllerWithIdentifier:@"CTMessageViewController"];
////        [self.navigationController pushViewController:messageController animated:YES];
//    } else if(indexPath.row == 4) {
//        if([CTCommonMethods isUIDStoredInDevice]) {
//            CTMyReservationsViewController *myRes = [[CTMyReservationsViewController alloc]initWithStyle:UITableViewStylePlain];
//            myRes.navigationItem.leftBarButtonItem = [self backButton];
//            [self.navigationController pushViewController:myRes animated:YES];
//            // call viewDidLoad
//            (void)myRes.view;
//            [myRes.hideBtn removeTarget:myRes action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [myRes.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
//            alert.tag = kAlertViewTag_Login;
//            [alert show];
//      
//        }
//    }
}

- (void)cancelButtonClicked:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}
-(BOOL)submitSearchQueryForStreet:(NSString*)street city:(NSString*)city zip:(NSString*)zip {
    if(zip.length == 0 || street.length == 0 || city.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fields missing" message:@"Please fill all the fields and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else {
        [searchController resignAllTextFieldResponders];
        [self hideMenu:YES withRootNavController:rootNavController];
        for (id viewController in [rootNavController viewControllers]) {
            if ([viewController isKindOfClass:[CTRootViewController class]]) {
                [viewController searchForZipCode:[zip integerValue] street:street city:city];
            }
        }
        return YES;
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
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kAlertViewTag_Retry && buttonIndex != alertView.cancelButtonIndex) {
        [self logoutUserWithUID:[CTCommonMethods UID]];
    }else if(alertView.tag == kAlertViewTag_Login && buttonIndex!= alertView.cancelButtonIndex) {
        // login btn taped.
        CTLoginPopup *login = [[CTLoginPopup alloc]init];
        CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController.view addSubview:login];
    }
}

#pragma mark - MFMailComposer Delegate

- (void)handleDoubleTapOnLabel:(UITapGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:{
//            return;
            NSString *filePath = [[RedirectNSLogs sharedInstance]filePathForNSLogsFile];
            @try {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc]init];
                controller.mailComposeDelegate = self;
                [controller setToRecipients:@[@"rrepaka@gmail.com"]];
                [controller setSubject:@"Apploom.com Log File"];
                [controller addAttachmentData:[NSData dataWithContentsOfFile:filePath] mimeType:@"application/text" fileName:@"ApploomLogs.txt"];
                [self presentViewController:controller animated:YES completion:nil];
            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cannot Send Email" message:exception.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            printf("\n MFMailComposeResultSent \n");
            break;
        case MFMailComposeResultCancelled:
            printf("\n MFMailComposeResultCancelled \n");
            break;
        case MFMailComposeResultFailed:
            printf("\n MFMailComposeResultFailed \n");
            break;
        case MFMailComposeResultSaved:
            printf("\n MFMailComposeResultSaved \n");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
