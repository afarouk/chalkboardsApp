//
//  CTParentViewController.m
//  Community
//
//  Created by practice on 15/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTParentViewController.h"
#import "ImageNamesFile.h"
#import "CTRestaurantHomeViewController.h"
#import "CTLoginPopup.h"
#import "CTTileViewController.h"
#import "CTWebviewDetailsViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTCommonMethods.h"
#import "MBProgressHUD.h"
#import "CTRootControllerDataModel.h"
#import "Constants.h"
#import "CTSelectSASLView.h"
#import "CTInvitationBussinessView.h"
#import "CTInvitationLoginView.h"
#import "CTSelectTypeViewController.h"
#import "CTForgotPWDViewController.h"
#import "CTCustomerSignupViewController.h"
#import "CTLearnMoreView.h"
#import "CTDataModel_FilterViewController.h"
#import "MISDropdownViewController.h"
#import "MISDropdownMenuView.h"
#import "RedirectNSLogs.h"

#define kAlertViewTag_Login 11

#define DEBUGGING YES    //or YES
#define NSLog if(DEBUGGING)NSLog

@interface CTParentViewController (){
}
@property (strong, nonatomic) MISDropdownViewController *dropdownViewController;
@property (strong, nonatomic) MISDropdownMenuView *dropdownMenuView;

@end


@implementation CTParentViewController
const short int WidthFactor = 0;
@synthesize favoriteButton, btnTiles, listMenuController, moreViewController ;
-(void)didPan:(UIPanGestureRecognizer*)paneGesture {
    static CGPoint origionalCenter;
    static CGPoint rootControllerOrigionalCenter;
    static BOOL moveLeft = NO;
    if(paneGesture.state == UIGestureRecognizerStateBegan) {
        origionalCenter = [[selectedMenuController navigationController] view].center;
        rootControllerOrigionalCenter = self.rootViewController.navigationController.view.center;
    }
    else if(paneGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paneGesture translationInView: self.rootViewController.navigationController.view];
        if(origionalCenter.x+translation.x<=[[selectedMenuController navigationController] view].frame.size.width/2) {
            [[selectedMenuController navigationController] view].center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
            if(rootControllerOrigionalCenter.x+translation.x>self.rootViewController.view.frame.size.width/2)
                self.rootViewController.navigationController.view.center= CGPointMake(rootControllerOrigionalCenter.x+translation.x, rootControllerOrigionalCenter.y);
        }
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
        if([selectedMenuController isKindOfClass:[CTSlideMenuViewController class]]) {
            if(moveLeft) {
                [(CTSlideMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = NO;
                hitDetectionView.userInteractionEnabled = NO;
            }
            else {
                [[(CTSlideMenuViewController*)selectedMenuController tableView] reloadData];
                [(CTSlideMenuViewController*)selectedMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = YES;
                hitDetectionView.userInteractionEnabled = YES;
            }
        }else if([selectedMenuController isKindOfClass:[CTRestaurantsMenuViewController class]]) {
            if(moveLeft) {
                [(CTRestaurantsMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = NO;
                hitDetectionView.userInteractionEnabled = NO;
            }
            else {
                [[(CTRestaurantsMenuViewController*)selectedMenuController tableView] reloadData];
                [(CTRestaurantsMenuViewController*)selectedMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = YES;
                hitDetectionView.userInteractionEnabled = YES;
            }
        }else if([selectedMenuController isKindOfClass:[CTFavoritesMenuViewController class]]){
            if(moveLeft) {
                [(CTFavoritesMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = NO;
                hitDetectionView.userInteractionEnabled = NO;
            }
            else {
                [(CTFavoritesMenuViewController*)selectedMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
                [[(CTFavoritesMenuViewController*)selectedMenuController tableView] reloadData];
                paneGesture.enabled = YES;
                hitDetectionView.userInteractionEnabled = YES;
            }
        }else if([selectedMenuController isKindOfClass:[CTSearchLocationViewController class]]){
            if(moveLeft) {
                [(CTSearchLocationViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = NO;
                hitDetectionView.userInteractionEnabled = NO;
            }
            else {
                [(CTSearchLocationViewController*)selectedMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = YES;
                hitDetectionView.userInteractionEnabled = YES;
            }
        }
        else if([selectedMenuController isKindOfClass:[CTAdAlertViewController class]]) {
            if(moveLeft) {
                [(CTAdAlertViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = NO;
                hitDetectionView.userInteractionEnabled = NO;
            }
            else {
                [(CTAdAlertViewController*)selectedMenuController reloadTableData];
                [(CTAdAlertViewController*)selectedMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
                paneGesture.enabled = YES;
                hitDetectionView.userInteractionEnabled = YES;
            }
        }
    }
}
-(UIPanGestureRecognizer*)paneGesture {
    if(panGesture)
        return panGesture;
    panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    panGesture.enabled = NO;
    return panGesture;
}

#pragma mark - Button Actions

-(void)didTapBackButtonOnFavorites:(id)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)listBtnTaped:(id)sender {
    selectedMenuController = listMenuController;
    hitDetectionView.userInteractionEnabled = YES;
    if([listMenuController isVisible]) {
        panGesture.enabled = NO;
        [listMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
    else {
        panGesture.enabled = YES;
        [listMenuController.navigationController popToRootViewControllerAnimated:FALSE];
        [listMenuController.tableView reloadData];
        [listMenuController showMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
}

-(void)restaruantListBtnTaped:(id)sender {
    selectedMenuController = restaurantsController;
    hitDetectionView.userInteractionEnabled = YES;
    if([restaurantsController isVisible]) {
        panGesture.enabled = NO;
        [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
    else {
        panGesture.enabled = YES;
        [restaurantsController.tableView reloadData];
        [restaurantsController showMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
}

-(void)loginPopUpOpen
{
    //[self.view addSubview:[[CTLoginPopup alloc]init]];
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
}
-(void)SignOutClick:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice])
    {
        //selectedMenuController = favoritesController;
        UIButton *btn = (UIButton *)sender;
        //NSLog(@"sender title %@",[btn titleForState:UIControlStateNormal]);
        // hitDetectionView.userInteractionEnabled = YES;
        //        if ([@"Sign-out" isEqualToString:[self.btnLogin titleForState:UIControlStateSelected]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] ;
        alert.tag = 111;
        [alert show];
        //        }
        //        else if([favoritesController isVisible]) {
        //            panGesture.enabled = NO;
        //            [favoritesController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
        //        }
        //        else {
        //            panGesture.enabled = YES;
        //            [favoritesController.tableView reloadData];
        //            [favoritesController retriveFavorite];
        //            [favoritesController showMenu:YES withRootNavController:self.rootViewController.navigationController];
        //        }
    }
    else
    {
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
        //[self.view addSubview:[[CTLoginPopup alloc]init]];
    }
}

-(void)favoritesBtnTaped:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        selectedMenuController = favoritesController;
        UIButton *btn = (UIButton *)sender;
        NSLog(@"sender title %@",[btn titleForState:UIControlStateNormal]);
        hitDetectionView.userInteractionEnabled = YES;
        if ([@"Sign-out" isEqualToString:[btn titleForState:UIControlStateNormal]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] ;
            alert.tag = 111;
            [alert show];
        }
        else if([favoritesController isVisible]) {
            panGesture.enabled = NO;
            [favoritesController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
        }
        else {
            panGesture.enabled = YES;
            [favoritesController.tableView reloadData];
            [favoritesController retriveFavorite];
            [favoritesController showMenu:YES withRootNavController:self.rootViewController.navigationController];
        }
    }else {
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
        //[self.view addSubview:[[CTLoginPopup alloc]init]];
    }
}

-(void)filterBtnTaped:(id)sender {
    
    filterViewController.searchResult = nil;
    //    selectedMenuController = favoritesController;
    selectedMenuController = filterViewController;
    hitDetectionView.userInteractionEnabled = FALSE;
    if([filterViewController isVisible])
        [filterViewController hideFilterPicker:YES];
    else
        [filterViewController showFilterPicker:YES];
}

-(void)adAlertBtnTaped:(id)sender{
    selectedMenuController = adAlertViewController;
    hitDetectionView.userInteractionEnabled = YES;
    if([adAlertViewController isVisible]) {
        panGesture.enabled = NO;
        [adAlertViewController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
    else {
        panGesture.enabled = YES;
        [adAlertViewController.navigationController popToRootViewControllerAnimated:FALSE];
        [adAlertViewController reloadTableData];
        [adAlertViewController showMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
}

-(void)searchBtnTaped:(id)sender {
    
//    NSLog(@"------------------ Kaushal ==================");
    
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
                                                                                          @"latitude":@(self.rootViewController.mapview.userLocation.coordinate.latitude),
                                                                                          @"longitude":@(self.rootViewController.mapview.userLocation.coordinate.longitude)
                                                                                          }, nil];
                    [tempArray addObjectsFromArray:JSON];
                    _searchCityResult = tempArray;
//                    NSLog(@"_searchCityResult 123 = %@",_searchCityResult);
                    [self LoadCityView];
                    self.rootViewController.getcitylist = tempArray;
                    [CTCommonMethods sharedInstance].SearchCitySelector = tempArray;
                    filterViewController.searchResult = tempArray;
                    selectedMenuController = filterViewController;
                    hitDetectionView.userInteractionEnabled = FALSE;
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
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"searchBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
    
    return;
    
    selectedMenuController = searchController;
    hitDetectionView.userInteractionEnabled = YES;
    if([searchController isVisible]) {
        panGesture.enabled = NO;
        [searchController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
    else {
        panGesture.enabled = YES;
        [searchController showMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
}

- (void)bookmarkBtnTapped:(id)sender{
    if([CTCommonMethods isUIDStoredInDevice]){
        //        CTFavoritesMenuViewController *favorites = [[CTFavoritesMenuViewController alloc]initWithStyle:UITableViewStylePlain];
        //        favorites.delegate =self;
        //        [favorites retriveFavorite];
        //        favorites.navigationItem.leftBarButtonItem = [self backButton];
        //        favorites.navigationItem.title = @"Favorites";
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:favoritesController];
        //        [self.navigationController pushViewController:favorites animated:YES];
        //        [favorites.hideBtn removeTarget:favorites action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //        [favorites.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if([favoritesController isVisible]) {
            panGesture.enabled = NO;
            [favoritesController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
        }
        else {
            panGesture.enabled = YES;
            [favoritesController.tableView reloadData];
            [favoritesController retriveFavorite];
            [favoritesController showMenu:YES withRootNavController:self.rootViewController.navigationController];
        }
    }else {
        //            CTLoginPopup *login = [[CTLoginPopup alloc]init];
        //            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
        //            [appDelegate.window.rootViewController.view addSubview:login];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        alert.tag = kAlertViewTag_Login;
        [alert show];
    }
}

-(BOOL)submitSearchQueryForStreet:(NSString*)street city:(NSString*)city zip:(NSString*)zip {
    if(zip.length == 0 || street.length == 0 || city.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fields missing" message:@"Please fill all the fields and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else {
        [searchController resignAllTextFieldResponders];
        [searchController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
        [self.rootViewController searchForZipCode:[zip integerValue] street:street city:city];
        return YES;
    }
}

- (IBAction)showMaskImage:(id)sender{
    [self.rootViewController showOrHideMaskImage];
}

- (void) dismissSubViewWithAnimation{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
}

#pragma mark - Bar Buttons


-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
}

-(UIBarButtonItem*)bookmarkButton {
    UIButton *bookmarkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[bookmarkButton setFrame:CGRectMake(0, 0, 44, 40)];
    [bookmarkButton setFrame:CGRectMake(0, 0, 44, 44)];
    UIImage *imgFavourite = ([CTCommonMethods UID] != nil && [[CTCommonMethods UID] length] > 1) ? [UIImage imageNamed:Ct_Favourite] : [UIImage imageNamed:Ct_NotFavourite];
    [bookmarkButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    //[bookmarkButton addTarget:self action:@selector(bookmarkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bookmarkButton addTarget:self.rootViewController action:@selector(MenuBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [bookmarkButton setTitle:@"Menu" forState:UIControlStateNormal];
    [bookmarkButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -35.0, 0.0, -10.0);
    bookmarkButton.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 10.0, 0.0, 0.0);
    bookmarkButton.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:bookmarkButton];
    return  rightBarButton;
}

-(UIBarButtonItem*)listMenuBtn {
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 40, 40)];
    
    [menuButton setImage:[UIImage imageNamed:CT_MenuIcon] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(listBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [menuButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    menuButton.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    menuButton.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    return  rightBarButton;
}

-(UIBarButtonItem *)showMaskButton{
    UIButton *maskButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [maskButton setFrame:CGRectMake(-10, 0, 40, 40)];
    [maskButton setImage:[UIImage imageNamed:CT_ShowMask] forState:UIControlStateNormal];
    [maskButton addTarget:self action:@selector(showMaskImage:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [maskButton setTitle:@"List" forState:UIControlStateNormal];
    [maskButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    //    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    //maskButton.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-10.0, 7.0, 0.0, -7.0);
    maskButton.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:maskButton];
    return leftBarbutton;
}
-(UIBarButtonItem *)restaurantListButton{
    self.btnList=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnList setFrame:CGRectMake(0, 0, 40, 40)];
    [self.btnList setImage:[UIImage imageNamed:CT_ListIcon] forState:UIControlStateNormal];
    //     V: Regular flow
    //    [listButton addTarget:self action:@selector(restaruantListBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnList addTarget:self.rootViewController action:@selector(showListView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnList setTitle:@"List" forState:UIControlStateNormal];
    [self.btnList.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    //    [listButton setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateSelected];
    //    [listButton setTitle:@"Map" forState:UIControlStateSelected];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    self.btnList.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    self.btnList.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:self.btnList];
    return leftBarbutton;
}
-(UIBarButtonItem *)filterButton{
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setFrame:CGRectMake(0, 0, 40, 40)];
    [filterButton setImage:[UIImage imageNamed:CT_FilterIcon] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [filterButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    filterButton.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    filterButton.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:filterButton];
    return leftBarbutton;
}
-(UIBarButtonItem *)favotiteButton{
    //    UIButton*
    if(!favoriteButton)
        favoriteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteButton setFrame:CGRectMake(50, 0, 40, 40)];
    [favoriteButton setImage:[UIImage imageNamed:CT_FavoriteIcon] forState:UIControlStateNormal];
    [favoriteButton addTarget:self action:@selector(favoritesBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [favoriteButton setTitle:@"Sign-in" forState:UIControlStateNormal];
    [favoriteButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    favoriteButton.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    favoriteButton.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:favoriteButton];
    return leftBarbutton;
    
}
-(UIBarButtonItem*)searchButton {
    UIButton* searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 65, 65)];
    [searchBtn setImage:[UIImage imageNamed:CT_CitySearch] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtn addTarget:self action:@selector(filterBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.numberOfLines = 0;
    [searchBtn setTitle:@"City" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    searchBtn.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-15.0, 17.0, 0.0, 0.0);
    searchBtn.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton= [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    leftBarbutton.tag = 111;
    //    [searchBtn.titleLabel  setMinimumScaleFactor:0.2f];
    //    [searchBtn.titleLabel sizeToFit];
    //    [searchBtn.titleLabel adjustsFontSizeToFitWidth];
    //    searchBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    return leftBarbutton;
}

-(UIBarButtonItem*)SignInOut {
    //    UIButton* searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [searchBtn setFrame:CGRectMake(0, 0, 65, 65)];
    //    //[searchBtn setImage:[UIImage imageNamed:@"Sign_in1.png"] forState:UIControlStateNormal];
    //    //[searchBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtn setImage:[UIImage imageNamed:@"Sign_in1.png"] forState:UIControlStateNormal];
    //    [searchBtn addTarget:self action:@selector(showSigninOut:) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtn setTitle:@"Sign-in" forState:UIControlStateNormal];
    //
    //    [searchBtn setImage:[UIImage imageNamed:@"Sign_out1.png"] forState:UIControlStateSelected];
    //    [searchBtn setTitle:@"Sign-out" forState:UIControlStateSelected];
    //
    //    searchBtn.titleLabel.numberOfLines = 0;
    //    //[searchBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    //    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
    //
    //    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    //    searchBtn.titleEdgeInsets = titleInsets;
    //
    //    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-15.0, 17.0, 0.0, 0.0);
    //    searchBtn.imageEdgeInsets = imageInsets;
    //
    //    UIBarButtonItem *leftBarbutton= [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    //    leftBarbutton.tag = 111;
    //    [searchBtn.titleLabel  setMinimumScaleFactor:0.2f];
    //    [searchBtn.titleLabel sizeToFit];
    //    [searchBtn.titleLabel adjustsFontSizeToFitWidth];
    //    searchBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLogin setFrame:CGRectMake(0, 0, 65 , 65)];
    
    
    [_btnLogin setImage:[UIImage imageNamed:CT_SignInIcon] forState:UIControlStateNormal];
    [_btnLogin addTarget:self action:@selector(showSigninOut:) forControlEvents:UIControlEventTouchUpInside];
    _btnLogin.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    
    [_btnLogin setTitle:@"Sign In" forState:UIControlStateNormal];
    
    [_btnLogin setImage:[UIImage imageNamed:CT_SignOutIcon] forState:UIControlStateSelected];
    [_btnLogin setTitle:@"Sign Out" forState:UIControlStateSelected];
    
    [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:9]];
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    _btnLogin.titleEdgeInsets = titleInsets;
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 16.0, 0.0, 0.0);
    _btnLogin.imageEdgeInsets = imageInsets;
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithCustomView:_btnLogin];

    
    if([CTCommonMethods isUIDStoredInDevice])
    {
        [_btnLogin addTarget:self action:@selector(showSigninOut:) forControlEvents:UIControlEventTouchUpInside];
        _btnLogin.selected = YES;
        NSLog(@"hello button");
    }
    
    return leftBarbutton;
}


-(IBAction)showSigninOut:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    if (sender.selected)
    {
        if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
        {
            [sender setImage:[UIImage imageNamed:CT_SignInIcon] forState:UIControlStateNormal];
            [sender setSelected:NO];
        }
        else{
            [self SignOutClick:sender];
        }
    }
    else
    {
        if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
        {
            [self SignOutClick:sender];
        }
        else
        {
            [sender setImage:[UIImage imageNamed:CT_SignOutIcon] forState:UIControlStateSelected];
            [sender setSelected:YES];
        }
        
    }
    
    /*
     if (sender.selected)
     {
     sender = btnLogin;
     sender.selected = YES;
     NSLog(@"111");
     [sender setImage:[UIImage imageNamed:CT_SignOutIcon] forState:UIControlStateSelected];
     [sender setTitle:@"Sign Out" forState:UIControlStateSelected];
     [sender setSelected:!sender.selected];
     }
     else
     {
     NSLog(@"222 === ");
     
     if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
     {
     // [sender setTitle:@"Sign-in" forState:UIControlStateNormal];
     //            [sender setImage:[UIImage imageNamed:CT_SignInIcon] forState:UIControlStateNormal];
     //            [sender addTarget:self action:@selector(showSigninOut:) forControlEvents:UIControlEventTouchUpInside];
     [self favoritesBtnTaped:sender];
     }
     else
     {
     NSLog(@"222 === 123123 ");
     [sender setSelected:!sender.selected];
     //            [btnLogin setImage:[UIImage imageNamed:CT_SignOutIcon] forState:UIControlStateSelected];
     //            [btnLogin setTitle:@"Sign Out" forState:UIControlStateSelected];
     }
     
     
     }
     */
    
    
}

/*
 -(UIBarButtonItem*)adAlertButton {
 UIButton* searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
 [searchBtn setFrame:CGRectMake(0, 0, 40, 40)];
 [searchBtn setImage:[UIImage imageNamed:CT_AdAlert] forState:UIControlStateNormal];
 //    [searchBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
 
 // V: Regular flow
 //    [searchBtn addTarget:self action:@selector(adAlertBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
 
 [searchBtn addTarget:self.rootViewController action:@selector(showAdAlertView:) forControlEvents:UIControlEventTouchUpInside];
 searchBtn.titleLabel.numberOfLines = 0;
 [searchBtn setTitle:@"Ad-Alert" forState:UIControlStateNormal];
 [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
 
 //    [searchBtn setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateSelected];
 //    [searchBtn setTitle:@"Map" forState:UIControlStateSelected];
 
 UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
 searchBtn.titleEdgeInsets = titleInsets;
 
 UIEdgeInsets imageInsets = UIEdgeInsetsMake(-15.0, 5.0, 0.0, 0.0);
 searchBtn.imageEdgeInsets = imageInsets;
 
 UIBarButtonItem *leftBarbutton= [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
 return leftBarbutton;
 }
 */
-(UIBarButtonItem*)createMenu {
    UIButton* searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [searchBtn setImage:[UIImage imageNamed:@"Create_menu.png"] forState:UIControlStateNormal];
    //    [searchBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    // V: Regular flow
    //    [searchBtn addTarget:self action:@selector(adAlertBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchBtn addTarget:self.rootViewController action:@selector(showAdAlertView:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.numberOfLines = 0;
    [searchBtn setTitle:@"Create" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
    
    //    [searchBtn setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateSelected];
    //    [searchBtn setTitle:@"Map" forState:UIControlStateSelected];
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    searchBtn.titleEdgeInsets = titleInsets;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-15.0, 5.0, 0.0, 0.0);
    searchBtn.imageEdgeInsets = imageInsets;
    
    UIBarButtonItem *leftBarbutton= [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    return leftBarbutton;
}


-(UIBarButtonItem *)tilesButton{
    btnTiles = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTiles setFrame:CGRectMake(0, 0, 40, 40)];
    
    [btnTiles setImage:[UIImage imageNamed:CT_TilesIcon] forState:UIControlStateSelected];
    //[btnTiles addTarget:self.rootViewController action:@selector(showTilesView:) forControlEvents:UIControlEventTouchUpInside];
    [btnTiles addTarget:self.rootViewController action:@selector(showTilesView1:) forControlEvents:UIControlEventTouchUpInside];
    
    //btnTiles.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    //[btnTiles addTarget:self.rootViewController action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
    
    //[btnTiles setTitle:@"Tiles" forState:UIControlStateNormal];
    
    [btnTiles setTitle:@"Deals" forState:UIControlStateSelected];
    
    [btnTiles setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateNormal];
    [btnTiles setTitle:@"Map" forState:UIControlStateNormal];

    //    [btnTiles setTitle:@"Deals" forState:UIControlStateNormal];
    //
    //
    //    [btnTiles setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateSelected];
    //    [btnTiles setTitle:@"Map" forState:UIControlStateSelected];
    
    [btnTiles.titleLabel setFont:[UIFont systemFontOfSize:9]];
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    btnTiles.titleEdgeInsets = titleInsets;
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    btnTiles.imageEdgeInsets = imageInsets;
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithCustomView:btnTiles];
    return leftBarbutton;
}

#pragma mark - Add Menu Options

// add root view controller
-(void)addRootController {
    self.rootViewController = [[CTRootViewController alloc]initWithNibName:@"CTRootViewController" bundle:nil];
    UINavigationController *rootNavController = [[UINavigationController alloc]initWithRootViewController:self.rootViewController];
    rootNavController.toolbarHidden = NO;
    [rootNavController.navigationBar setTranslucent:YES];
    //    [rootNavController.toolbar setTranslucent:YES];
    //    [rootNavController.toolbar setOpaque:NO];
    //    rootNavController.navigationBarHidden = YES;
    rootNavController.toolbar.tintColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    rootNavController.toolbar.barTintColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    [self addChildViewController:rootNavController];
    [self.view addSubview:rootNavController.view];
    self.rootViewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    if([self.rootViewController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [self.rootViewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f]];
    // list menu button
    //    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexibleSpace;
    UIBarButtonItem *flexibleSpace1;
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace.width = 40.0f;
        
        flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace1.width = 10.0f;
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace.width = 30.0f;
        
        flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace1.width = 7.0f;
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace.width = 10.0f;
        
        flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace1.width = -5.0f;
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace.width = 10.0f;
        
        flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexibleSpace1.width = -5.0f;
    }
    
    
    
    
    //    self.rootViewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexibleSpace,[self filterButton],flexibleSpace,[self favotiteButton],flexibleSpace,[self searchButton],flexibleSpace,[self restaurantListButton],flexibleSpace,[self listMenuBtn],flexibleSpace, nil];
    //    self.rootViewController.toolbarItems = [NSArray arrayWithObjects:flexibleSpace,[self filterButton],flexibleSpace,[self favotiteButton],flexibleSpace,[self searchButton],flexibleSpace,[self restaurantListButton],flexibleSpace,[self listMenuBtn],flexibleSpace, nil];
    
    //[self.rootViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:CT_NavigationBg] forBarMetrics:UIBarMetricsDefault];
    
    
    //ButtonRight//
    //    UIButton *btnNext1 =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnNext1 setTitle:@"Learn More" forState:UIControlStateNormal];
    //    //[btnNext1 setBackgroundImage:[UIImage imageNamed:@"chaticonNew.png"] forState:UIControlStateNormal];
    //    btnNext1.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    //    btnNext1.backgroundColor = [UIColor colorWithRed:19/255.0f green:90/255.0f blue:255/255.0f alpha:1];
    //    btnNext1.layer.borderColor = [UIColor whiteColor].CGColor;
    //    btnNext1.layer.borderWidth = 2;
    //    btnNext1.layer.cornerRadius = 4;
    //
    //
    //    btnNext1.frame = CGRectMake(100, 100, 110, 35);
    //    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    //    [btnNext1 addTarget:self action:@selector(LearnMore:) forControlEvents:UIControlEventTouchUpInside];
    //    self.rootViewController.self.navigationItem.rightBarButtonItem = btnNext;
    //ButtonRight//
    
    //    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu:)];
    //    self.rootViewController.self.navigationItem.rightBarButtonItem = barButtonItem;
    //
    //    self.dropdownMenuView = [[MISDropdownMenuView alloc] initWithItems:@[@"Item1", @"Item2", @"Item3"]];
    //    self.dropdownMenuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    [self.dropdownMenuView addTarget:self action:@selector(dropMenuChanged:) forControlEvents:UIControlEventValueChanged];
    //
    ////    self.selectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 200, CGRectGetWidth(self.view.frame), 20.0)];
    ////    self.selectionLabel.textAlignment = NSTextAlignmentCenter;
    ////    self.selectionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    ////    self.selectionLabel.text = self.dropdownMenuView.items[self.dropdownMenuView.selectedItemIndex];
    ////    [self.view addSubview:self.selectionLabel];
    //
    //    UIBarButtonItem *barButtonItemnw = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu:)];
    //    self.rootViewController.self.navigationItem.rightBarButtonItem = barButtonItemnw;
    
    
    //ButtonRight//
    //    CatagoryListButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [CatagoryListButton setTitle:@"Category  ▼" forState:UIControlStateNormal];
    //    //[Rightsidebt setBackgroundImage:[UIImage imageNamed:@"sel_button.png"] forState:UIControlStateNormal];
    //    CatagoryListButton.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    //    CatagoryListButton.backgroundColor = [UIColor colorWithRed:19/255.0f green:90/255.0f blue:255/255.0f alpha:1];
    //    CatagoryListButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    CatagoryListButton.layer.borderWidth = 2;
    //    CatagoryListButton.layer.cornerRadius = 4;
    //
    //
    //    CatagoryListButton.frame = CGRectMake(100, 100, 120, 25);
    //    UIBarButtonItem *btn =[[UIBarButtonItem alloc] initWithCustomView:CatagoryListButton];
    //    [CatagoryListButton addTarget:self action:@selector(CatagorySidedButton:) forControlEvents:UIControlEventTouchUpInside];
    //    self.rootViewController.self.navigationItem.rightBarButtonItem = btn;
    //ButtonRight//
    
    
    //    //ButtonLeft//
    //    CityListButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //    [CityListButton setTitle:@"City  ▼" forState:UIControlStateNormal];
    //    [CityListButton setBackgroundImage:[UIImage imageNamed:@"chaticonNew.png"] forState:UIControlStateNormal];
    //    CityListButton.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
    //    CityListButton.backgroundColor = [UIColor colorWithRed:19/255.0f green:90/255.0f blue:255/255.0f alpha:1];
    //    CityListButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    CityListButton.layer.borderWidth = 2;
    //    CityListButton.layer.cornerRadius = 4;
    //    CityListButton.frame = CGRectMake(100, 100, 120, 25);
    //        UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:CityListButton];
    //    [CityListButton addTarget:self action:@selector(CitySidedButton:) forControlEvents:UIControlEventTouchUpInside];
    //    self.rootViewController.self.navigationItem.leftBarButtonItem = btnNext;
    //    //ButtonLeft//
    
    UIImageView * centerimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    centerimage.image = [UIImage imageNamed:@"ChalkboardsIcon.png"];
    centerimage.userInteractionEnabled = YES;
    self.rootViewController.navigationItem.titleView = centerimage;
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapOnLabel:)];
//    gesture.numberOfTapsRequired = 2;
//    gesture.cancelsTouchesInView = YES;
//    [centerimage addGestureRecognizer:gesture];
//    self.rootViewController.self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChalkboardsIcon.png"]];
    
    //self.rootViewController.self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    
    
    listofeventName = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"displayText"];
    
    //    [self GetCityList];
    //    [self GetCatagoryList];
    
    
    //[self.rootViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:CT_NavigationBg] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    switch ([CTCommonMethods getIPhoneVersion]) {
        case iPhone6:{
            //[self.rootViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:CT_NavigationBg] forBarMetrics:UIBarMetricsDefault];
        }
            break;
        case iPhone6Plus:{
            //[self.rootViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:CT_NavigationBg] forBarMetrics:UIBarMetricsDefault];
        }
            break;
        default:
            break;
    }
    
    //    self.rootViewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self tilesButton],[self restaurantListButton], nil];
    
    // V: To hide navigation items
    //    self.rootViewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self tilesButton],[self restaurantListButton],[self showMaskButton], nil];
    
    // V: To hide old toolbar items
    //    self.rootViewController.toolbarItems = [NSArray arrayWithObjects:flexibleSpace,[self listMenuBtn],flexibleSpace,[self filterButton],flexibleSpace,[self searchButton], flexibleSpace,[self adAlertButton],flexibleSpace,[self favotiteButton],flexibleSpace, nil];
    
    // V: New toolbar items
    //self.rootViewController.toolbarItems = [NSArray arrayWithObjects:[self bookmarkButton],flexibleSpace,[self createMenu], flexibleSpace1,[self searchButton],flexibleSpace1,[self restaurantListButton],flexibleSpace,[self tilesButton], nil];
    
    self.rootViewController.toolbarItems = [NSArray arrayWithObjects:[self bookmarkButton],flexibleSpace,[self restaurantListButton],flexibleSpace,[self createMenu],flexibleSpace,[self tilesButton],flexibleSpace1,[self SignInOut], nil];
    
    
    //    self.rootViewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexibleSpace,[self filterButton],flexibleSpace,[self favotiteButton],flexibleSpace,[self searchButton],flexibleSpace,[self restaurantListButton],flexibleSpace,[self listMenuBtn],flexibleSpace, nil];
    // loaded completion block
    __weak typeof (self) weakSelf = self;
    self.rootViewController.compBlock = ^ (BOOL mapViewLoaded) {
        [weakSelf.mapLegendController showLegendIfFirstTime];
        
    };
    self.rootViewController.appearDisappearBlock = ^ (BOOL appeared) {
        if(appeared) {
            weakSelf.mapLegendController.view.hidden= NO;
            //            weakSelf.rootViewController.navigationController.navigationBarHidden = NO;
        }
        else {
            weakSelf.mapLegendController.view.hidden = YES;
            //            weakSelf.rootViewController.navigationController.navigationBarHidden = YES;
        }
    };
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

-(void)GetCityList
{
    NSString *urlString=[NSString stringWithFormat:@"%@sasl/retrieveClusterLatLongs",[CTCommonMethods getChoosenServer]];
//    NSLog(@"URL get City %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"JSON Get City== %@",JSON);
        City_List = [JSON valueForKey:@"displayText"];
        
        [CTCommonMethods sharedInstance].NavigationCityList = [[NSMutableArray alloc]initWithArray:City_List];
        //[CTCommonMethods sharedInstance].NavigationCityList = City_List;
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
}

-(void)GetCatagoryList
{
    NSString *urlString=[NSString stringWithFormat:@"%@sasl/getSASLFilterOptions",[CTCommonMethods getChoosenServer]];
//    NSLog(@"URL get Catagory %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"JSON Get City== %@",JSON);
        Catagory_List = [JSON valueForKey:@"displayText"];
        [CTCommonMethods sharedInstance].SASLTitleName = [JSON valueForKey:@"displayText"];
        self.rootViewController.newarray = Catagory_List;
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
}

#pragma mark - Actions
//
//- (void)dropMenuChanged:(MISDropdownMenuView *)dropDownMenuView
//{
//    [self.dropdownViewController dismissDropdownAnimated:YES];
//
//    //NSInteger selectedItemIndex = [dropDownMenuView selectedItemIndex];
//    //self.selectionLabel.text = dropDownMenuView.items[selectedItemIndex];
//}
//
//- (void)toggleMenu:(id)sender
//{
//    if (self.dropdownViewController == nil) {
//        // Prepare content view
//        CGFloat width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 320.0 : self.view.bounds.size.width;
//        CGSize size = [self.dropdownMenuView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
//        self.dropdownMenuView.frame = CGRectMake(self.dropdownMenuView.frame.origin.x, self.dropdownMenuView.frame.origin.y, size.width, size.height);
//        NSLog(@"dropdown x %f",self.dropdownMenuView.frame.origin.x);
//        NSLog(@"dropdown y %f",self.dropdownMenuView.frame.origin.y);
//
//        self.dropdownViewController = [[MISDropdownViewController alloc] initWithPresentationMode:MISDropdownViewControllerPresentationModeAutomatic];
//        self.dropdownViewController.contentView = self.dropdownMenuView;
//    }
//
//    // Show/hide dropdown view
//    if ([self.dropdownViewController isDropdownVisible]) {
//        [self.dropdownViewController dismissDropdownAnimated:YES];
//        return;
//    }
//
//    // Sender is UIBarButtonItem
//    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
//        [self.dropdownViewController presentDropdownFromBarButtonItem:sender inViewController:self position:MISDropdownViewControllerPositionTop];
//        return;
//    }
//
//    // Sender is UIButton
//    CGRect rect = [sender convertRect:[sender bounds] toView:self.view];
//    [self.dropdownViewController presentDropdownFromRect:rect inViewController:self position:MISDropdownViewControllerPositionBottom];
//}

//#pragma mark - DropDown Button Type
//- (IBAction)CitySidedButton:(id)sender {
//    UIButton *Citybutton = sender;
//    btnDropDown = sender;
//    Citybutton.frame = CGRectMake(15, 30, 120, 25);
//    //CGRect btnframe = Citybutton.frame;
//
//    //btnframe.origin.y
//    if(dropDown == nil) {
//        CGFloat f = 120;
//        dropDown = [[NIDropDown alloc]showDropDown:Citybutton :&f :City_List :nil :@"down"];
//        dropDown.delegate = self;
//        dropDown.tag = 10001;
//
//        [self.view addSubview:dropDown];
//        [dropDown bringSubviewToFront:self.view];
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        [self rel];
//    }
//}
//- (void)DropDownHide:(NSNotification *)note
//{
//    if (dropDown != nil)
//    {
//        [dropDown hideDropDown:btnDropDown];
//        NSLog(@"work dropdown");
//    }
//}
//
//#pragma mark - DropDown Button Type
//- (IBAction)CatagorySidedButton:(id)sender {
//    UIButton *Catagorybutton = sender;
//    btnDropDown = sender;
//    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
//    {
//        NSLog(@"iphone6 + First View");
//        Catagorybutton.frame = CGRectMake(230, 30, 120, 25);
//    }
//
//    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
//    {
//        NSLog(@"iphone6");
//        Catagorybutton.frame = CGRectMake(240, 30, 120, 25);
//    }
//
//    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
//    {
//        NSLog(@"iphone5");
//        Catagorybutton.frame = CGRectMake(185, 30, 120, 25);
//    }
//
//    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
//    {
//        NSLog(@"iphone4");
//
//        Catagorybutton.frame = CGRectMake(185, 30, 120, 25);
//    }
//
//    if(dropDown == nil) {
//        CGFloat f = 120;
//        dropDown = [[NIDropDown alloc]showDropDown:Catagorybutton :&f :Catagory_List :nil :@"down"];
//        dropDown.delegate = self;
//        dropDown.tag = 10002;
//
//        [self.view addSubview:dropDown];
//        [dropDown bringSubviewToFront:self.view];
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        [self rel];
//    }
//}

//#pragma mark -- DropDown Methods
//- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
//    //[self searchBtnTaped:sender];
//    //[sender addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
//    switch (sender.tag)
//    {
//        case 10001:
//        {
//            if (_searchCityResult) {
//                if ([_searchCityResult count] > 0) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self userInfo:[_searchCityResult objectAtIndex:sender.selectindex]];
//                    NSLog(@"indexpath %d",sender.selectindex);
//                }
//                else {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self];
//                    NSLog(@"indexpathnw %d",sender.selectindex);
//                }
//                //[self hideFilterPicker:YES];
//                return;
//            }
//        }
//            break;
//        case 10002:
//        {
//            NSString *filter = @"UNKNOWN";
//            //    if(selectedRow <[CTDataModel_FilterViewController sharedInstance].filterOptions.count)
//
//            filter = [[CTDataModel_FilterViewController sharedInstance].filterOptions category:sender.selectindex];
//            //    NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].domains enumText:selectedDomainRow],@"domain",filter,@"category", nil];
//            NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].filterOptions domain:sender.selectindex],@"domain",filter,@"category", nil];
//
//            [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_FilterCategory object:self userInfo:selectedCategoryName];
//        }
//            break;
//
//       default:
//            break;
//    }
//
//
//    [self rel];
//}
//
//-(void)rel{
//    //    [dropDown release];
//    dropDown = nil;
//}

-(IBAction)LearnMore:(id)sender
{
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://chalkboards.today/portalexpress"]];
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTLearnMoreView * Select = [[CTLearnMoreView alloc] initWithNibName:@"CTLearnMoreView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Select];
    //Select.delegate = parentController;
    Select.navigationItem.leftBarButtonItem = [self backButton];
    Select.navigationItem.title = @"Lean More";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[Select.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

-(void)addListMenuController {
    listMenuController = [[CTSlideMenuViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *listMenuNavController = [[UINavigationController alloc]initWithRootViewController:listMenuController];
    //    listMenuNavController.view.frame = CGRectMake(0, 0, listMenuNavController.view.frame.size.width-15, listMenuNavController.view.frame.size.height);
    listMenuNavController.view.frame = CGRectMake(0, 0, listMenuNavController.view.frame.size.width, listMenuNavController.view.frame.size.height);
    [self addChildViewController:listMenuNavController];
    [self.view addSubview:listMenuNavController.view];
    listMenuController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([listMenuController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [listMenuController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [listMenuController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [listMenuController hideMenu:FALSE withRootNavController:self.rootViewController.navigationController];
    listMenuController.navigationItem.title = @"Menu";
}
-(void)addRestaurantsMenuController {
    restaurantsController = [[CTRestaurantsMenuViewController alloc]initWithStyle:UITableViewStylePlain];
    restaurantsController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:restaurantsController];
    navController.view.frame = CGRectMake(0, 0, navController.view.frame.size.width-WidthFactor, navController.view.frame.size.height);
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    restaurantsController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([restaurantsController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [restaurantsController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [restaurantsController hideMenu:FALSE withRootNavController:self.rootViewController.navigationController];
    [restaurantsController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    restaurantsController.navigationItem.title = @"List";
}
-(void)addFavoritesMenuController {
    favoritesController = [[CTFavoritesMenuViewController alloc]initWithStyle:UITableViewStylePlain];
    favoritesController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:favoritesController];
    navController.view.frame = CGRectMake(0, 0, navController.view.frame.size.width-WidthFactor, navController.view.frame.size.height);
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    favoritesController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([favoritesController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [favoritesController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [favoritesController hideMenu:FALSE withRootNavController:self.rootViewController.navigationController];
    [favoritesController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    favoritesController.navigationItem.title = @"Favorites";
}
-(void)addFilterPickerController {
    filterViewController = [[CTFilterViewController alloc]initWithNibName:@"CTFilterViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:filterViewController];
    [self addChildViewController:navController];
    
    [self.view addSubview:navController.view];
    
    navController.navigationBarHidden = YES;
    navController.view.frame = CGRectMake(0, 0, navController.view.frame.size.width-1, navController.view.frame.size.height);
    // [filterViewController showFilterPicker:FALSE];
    
    [filterViewController hideFilterPicker:YES];
}
-(void)addLocationSearchController {
    searchController = [[CTSearchLocationViewController alloc]initWithStyle:UITableViewStylePlain];
    //    searchController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:searchController];
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    navController.view.frame = CGRectMake(0, 0, navController.view.frame.size.width-WidthFactor, navController.view.frame.size.height);
    searchController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([searchController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [searchController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [searchController hideMenu:FALSE withRootNavController:self.rootViewController.navigationController];
    [searchController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    searchController.navigationItem.title = @"Search";
    (void)searchController.view;
    //    [searchController.submitBtn addTarget:self action:@selector(submitSearchQuery:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof (self) weakSelf = self;
    
    searchController.callBack = ^(NSString *street,NSString* city,NSString* zip) {
        [weakSelf submitSearchQueryForStreet:street city:city zip:zip];
    };
}
-(void)addMapLegendController {
    
    //    [self addMoreController];
    //    return;
    // add map legend
    self.mapLegendController = [[CTMapLegendViewController alloc]initWithNibName:@"CTMapLegendViewController" bundle:nil];
    self.mapLegendController.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.mapLegendController.view.center = CGPointMake(self.mapLegendController.view.center.x, self.mapLegendController.view.frame.size.height/2);
    [self addChildViewController:self.mapLegendController];
    [self.view addSubview:self.mapLegendController.view];
    [self.mapLegendController hideLegend];
    __weak typeof (self ) weakSelf = self;
    [self.mapLegendController setCompletionBlock:^(BOOL shown) {
        if(shown) {
            [weakSelf.rootViewController.navigationItem.leftBarButtonItems makeObjectsPerformSelector:@selector(setEnabled:) withObject:[NSNumber numberWithBool:NO]];
        }else {
            for(UIBarButtonItem *item in weakSelf.rootViewController.navigationItem.leftBarButtonItems)
                [item setEnabled:YES];
        }
    }];
}

-(void)addMoreController {
    // add map legend
    self.moreViewController = [[CTMoreViewController alloc]initWithNibName:@"CTMoreViewController" bundle:nil];
    self.moreViewController.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.moreViewController.view.center = CGPointMake(self.moreViewController.view.center.x, self.moreViewController.view.frame.size.height/2);
    [self addChildViewController:self.moreViewController];
    [self.view addSubview:self.moreViewController.view];
    [self.moreViewController hideLegend];
    __weak typeof (self ) weakSelf = self;
    [self.moreViewController setCompletionBlock:^(BOOL shown) {
        if(shown) {
            [weakSelf.rootViewController.navigationItem.leftBarButtonItems makeObjectsPerformSelector:@selector(setEnabled:) withObject:[NSNumber numberWithBool:NO]];
        }else {
            for(UIBarButtonItem *item in weakSelf.rootViewController.navigationItem.leftBarButtonItems)
                [item setEnabled:YES];
        }
    }];
}

- (void)addAdAlertController{
    
    adAlertViewController = [[CTAdAlertViewController alloc]init];
    adAlertViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:adAlertViewController];
    navController.view.frame = CGRectMake(0, 0, navController.view.frame.size.width-WidthFactor, navController.view.frame.size.height);
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    adAlertViewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([adAlertViewController.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [adAlertViewController.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [adAlertViewController hideMenu:FALSE withRootNavController:self.rootViewController.navigationController];
    [adAlertViewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    adAlertViewController.navigationItem.title = @"Ad-Alert";
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    [self addRootController];
    //  [self addMoreController];
    [self addMapLegendController];
    
    // menus
    [self addListMenuController];
    [self addRestaurantsMenuController];
    [self addFavoritesMenuController];
    
    [self addLocationSearchController];
    //[self addAdAlertController];
    [self.view addSubview:[self hitDetectionView]];
    // add pane gesture
    [self.view addGestureRecognizer:[self paneGesture]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ImageChange:) name:@"ChangeSignImage" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SASLViewOpen:) name:@"OpenFastSasl" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BusinessViewOpen:) name:@"BusinessOpen" object:nil];
    //    [self.view bringSubviewToFront:self.tilesBtn];
    
    //OpenSlowSasl
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SASLViewOpen1:) name:@"OpenSlowSasl" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SASLViewAfter:) name:@"OpenPramotion" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InviteViewOpen:) name:@"InvitationBussiness" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InviteLoginViewOpen:) name:@"InvitationLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CTLoginViewOpen:) name:@"CTLoginViewOpen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CTForgotViewOpen:) name:@"CTForgotViewOpen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CTCustomerSignupViewOpen:) name:@"CTCustomerSignupViewOpen" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DropDownHide:) name:@"DropDownHide" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CityLoad) name:@"CityLoad" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTiles:) name:@"OpenTile" object:nil];
    //[self.rootViewController showTilesView:btnTiles];
    [self.rootViewController TileViewOpen:_btnTilesnw];
//    [self addFilterPickerController];
//    [self filterBtnTaped:self];
//    [self GetCityList];
//    [self GetCatagoryList];
//    [self LoadCityView];
    
}
-(void) LoadCityView
{
    cityLoad = [[CTLoadCityList alloc]initWithNibName:@"CTLoadCityList" bundle:nil];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:cityLoad];
//    NSLog(@"_searchCityResult = %@",_searchCityResult);
    cityLoad.CityResult = _searchCityResult;
    [self addChildViewController:cityLoad];
    [self.view addSubview:cityLoad.view];
    
}
-(void)CityLoad : (NSNotification *)note
{
}

-(void)ImageChange :(NSNotification *)note
{
    [self showSigninOut:self.btnLogin];
}
-(void)showTiles : (NSNotification *)note
{
    //[self.rootViewController showTilesView:btnTiles];
}

-(void)CTCustomerSignupViewOpen:(NSNotification *)note
{
    //    CTCustomerSignupViewController * viewController = [[CTCustomerSignupViewController alloc] initWithNibName:@"CTCustomerSignupViewController" bundle:nil];
    //    viewController.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomTop];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTCustomerSignupViewController * Customer = [[CTCustomerSignupViewController alloc] initWithNibName:@"CTCustomerSignupViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Customer];
    //Customer.delegate = parentController;
    Customer.navigationItem.leftBarButtonItem = [self backButton];
    Customer.navigationItem.title = @"Customer Signup";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[Customer.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}
-(void)CTForgotViewOpen:(NSNotification *)note
{
    //    CTForgotPWDViewController * myemailpopup = [[CTForgotPWDViewController alloc] initWithNibName:@"CTForgotPWDViewController" bundle:nil];
    //    myemailpopup.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTForgotPWDViewController * ForgotPass = [[CTForgotPWDViewController alloc] initWithNibName:@"CTForgotPWDViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ForgotPass];
    //ForgotPass.delegate = parentController;
    ForgotPass.navigationItem.leftBarButtonItem = [self backButton];
    ForgotPass.navigationItem.title = @"Forgot Password";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[ForgotPass.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)CTLoginViewOpen:(NSNotification *)note
{
    //    CTSelectTypeViewController * myemailpopup = [[CTSelectTypeViewController alloc] initWithNibName:@"CTSelectTypeViewController" bundle:nil];
    //    myemailpopup.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTSelectTypeViewController * Select = [[CTSelectTypeViewController alloc] initWithNibName:@"CTSelectTypeViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Select];
    //Select.delegate = parentController;
    Select.navigationItem.leftBarButtonItem = [self backButton];
    Select.navigationItem.title = @"Select Type";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[Select.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)InviteLoginViewOpen:(NSNotification *)note
{
    //    CTInvitationLoginView * myemailpopup = [[CTInvitationLoginView alloc] initWithNibName:@"CTInvitationLoginView" bundle:nil];
    //    myemailpopup.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTInvitationLoginView * Invitelogin = [[CTInvitationLoginView alloc] initWithNibName:@"CTInvitationLoginView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Invitelogin];
    //Invitelogin.delegate = parentController;
    Invitelogin.navigationItem.leftBarButtonItem = [self backButton];
    Invitelogin.navigationItem.title = @"Create Account";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[Invitelogin.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)InviteViewOpen:(NSNotification *)note
{
    //    CTInvitationBussinessView * myemailpopup = [[CTInvitationBussinessView alloc] initWithNibName:@"CTInvitationBussinessView" bundle:nil];
    //    myemailpopup.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    CTInvitationBussinessView * Invitebussiness = [[CTInvitationBussinessView alloc] initWithNibName:@"CTInvitationBussinessView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Invitebussiness];
    //Invitebussiness.delegate = parentController;
    Invitebussiness.navigationItem.leftBarButtonItem = [self backButton];
    Invitebussiness.navigationItem.title = @"Invitation code";
    //            isCREATE = true;
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[Invitebussiness.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - PopUP Delegate method

-(void) DoneSuccess:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"InvitationLogin" object:nil];
}

-(void) Done2Success:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
}

- (void)cancelButtonClicked:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

- (void)BusinessViewOpen:(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    CTBusinessSignup * myadalert = [[CTBusinessSignup alloc] initWithNibName:@"CTBusinessSignup" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myadalert];
    
    myadalert.delegate = parentController;
    myadalert.navigationItem.leftBarButtonItem = [self backButton];
    myadalert.navigationItem.title = @"Business Signup";
    [UIView animateWithDuration:0.1 animations:^{
        //                [parentController.navigationController pushViewController:mysupport animated:YES];
        //                [parentController addChildViewController:mysupport];
        //                [parentController.view addSubview:mysupport.view];
        [parentController presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}
- (void)SASLViewOpen:(NSNotification *)note
{
    NSLog(@"Received Notification - Someone seems to have logged in");
    [self getdataForBusiness];
    
}
-(void)SASLViewOpen1 :(NSNotification * )note
{
    //NSLog(@"log is  =%@",[CTCommonMethods sharedInstance].listofResturant);
    //NSArray *restaurants = [CTCommonMethods sharedInstance].listofResturant;
    
    NSURL *url = [NSURL URLWithString:[CTCommonMethods sharedInstance].SelectTileSaSL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray * tiles = [dict valueForKey:@"tiles"];
    if (tiles.count > 0)
    {
        for (int i = 0; i<tiles.count; i++)
        {
            NSLog(@"tiles sows %@",tiles[i]);
            NSDictionary * fetdata = tiles[i];
            [[CTCommonMethods sharedInstance].RestaurantSA addObject:[fetdata valueForKey:@"serviceAccommodatorId"]];
            NSString * serviceAccommodatorId = [tiles[i] valueForKey:@"serviceAccommodatorId"];
            [[CTCommonMethods sharedInstance].RestaurantSL addObject:serviceAccommodatorId];
            
            NSString * saslName = [tiles[i] valueForKey:@"saslName"];
            [[CTCommonMethods sharedInstance].RestaurantSASLName addObject:saslName];
        }
        //[CTCommonMethods sharedInstance].OWNERFLAG = YES;
    }
    [self.view addSubview:[[CTSelectSASLView alloc] init] ];
}

- (void)SASLViewAfter:(NSNotification *)note
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


-(void)getdataForBusiness
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@UID=%@",[CTCommonMethods getChoosenServer],CT_GetUserCommunity,[CTCommonMethods UID]];
    NSLog(@"helooooooo URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON == %@",JSON);
        for(NSDictionary *communityType in JSON[@"community"])
        {
            NSDictionary *type=[communityType objectForKey:@"type"];
            NSLog(@"type = %@",type);
            if([type[@"enumText"] isEqualToString:@"OWNER"])
            {
                NSArray *restaurants = [communityType objectForKey:@"sasls"];
                NSLog(@"restaurants = %@",restaurants);
                if(![restaurants count])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        [CTCommonMethods sharedInstance].OWNERFLAG = NO;
                    });
                }
                else
                {
                    if (restaurants.count > 0)
                    {
                        for (int i = 0; i<restaurants.count; i++)
                        {
                            NSDictionary * fetdata = restaurants[i];
                            [[CTCommonMethods sharedInstance].RestaurantSA addObject:[fetdata valueForKey:@"sa"]];
                            [[CTCommonMethods sharedInstance].RestaurantSL addObject:[fetdata valueForKey:@"sl"]];
                            [[CTCommonMethods sharedInstance].RestaurantSASLName addObject:[fetdata valueForKey:@"saslName"]];
                        }
                        [CTCommonMethods sharedInstance].OWNERFLAG = YES;
                    }
                    if ([CTCommonMethods sharedInstance].RestaurantSASLName.count == 1)
                    {
                        [CTCommonMethods sharedInstance].selectSa = [CTCommonMethods sharedInstance].RestaurantSA[0];
                        [CTCommonMethods sharedInstance].selectSl = [CTCommonMethods sharedInstance].RestaurantSL[0];
                        NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
                        [yourDictionary setObject:[CTCommonMethods sharedInstance].selectSa forKey:@"SelectSA"];
                        [yourDictionary setObject:[CTCommonMethods sharedInstance].selectSl forKey:@"SelectSL"];
                        [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"SASLSelect"];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                    }
                    else
                    {
                        [self.view addSubview:[[CTSelectSASLView alloc] init] ];
                    }
                    
                    
                    
                }
            }
            // NSLog(@"[CTCommonMethods sharedInstance].RestaurantSL = %@",[CTCommonMethods sharedInstance].RestaurantSL);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    
    [operation start];
}

-(UIView*)hitDetectionView {
    if(!hitDetectionView) {
        hitDetectionView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-45, 0, 45, self.view.frame.size.height)];
        hitDetectionView.backgroundColor = [UIColor clearColor];
        hitDetectionView.userInteractionEnabled = FALSE;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHitDetectionArea:)];
        [hitDetectionView addGestureRecognizer:tap];
    }
    return hitDetectionView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didTapAndGetRestaruantDetailsFromAdAlertControllerWithURL:(NSString*)url{
    panGesture.enabled = NO;
    [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    if ([[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] && [[[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] boolValue] == YES && [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"]) {
        url = [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"];
    }
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.isFromRootView = YES;
    webController.delegate = nil;
    webController.strLoadUrl = url;
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideRightLeft];
}

-(void)didTapAndGetRestaruantDetailsFromAdAlertController:(NSString*)sa andSL:(NSString*)sl{
    panGesture.enabled = NO;
    [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    if ([[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] && [[[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] boolValue] == YES && [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"]) {
        url = [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"];
    }
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.isFromRootView = YES;
    webController.delegate = nil;
    webController.strLoadUrl = url;
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideRightLeft];
}

-(void)didTapAndGetRestaruantDetailsFromAdAlertController:(id)JSON{
    
}

-(void)didTapHitDetectionArea:(UITapGestureRecognizer*)tap {
    panGesture.enabled = NO;
    if([selectedMenuController isKindOfClass:[CTSlideMenuViewController class]]) {
        [(CTSlideMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }else if([selectedMenuController isKindOfClass:[CTRestaurantsMenuViewController class]]) {
        [(CTRestaurantsMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }else if([selectedMenuController isKindOfClass:[CTFavoritesMenuViewController class]]){
        [(CTFavoritesMenuViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }else if([selectedMenuController isKindOfClass:[CTFilterViewController class]]) {
        [(CTFilterViewController*)selectedMenuController hideFilterPicker:YES];
    }else if([selectedMenuController isKindOfClass:[CTSearchLocationViewController class]]) {
        [(CTSearchLocationViewController*)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }else if([selectedMenuController isKindOfClass:[CTAdAlertViewController class]]){
        [(CTAdAlertViewController *)selectedMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    }
    hitDetectionView.userInteractionEnabled = FALSE;
}

- (void)didTapOnShowLegend{
    [self.mapLegendController legendBtnTaped:nil];
}

#pragma mark - CTRestaurantsMenuViewController
-(void)didTapRestaurantDetailsForSA:(NSString*)sa andSL:(NSString*)sl {
    panGesture.enabled = NO;
    [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    // call in web view
    
    //NSString *url= [NSString stringWithFormat:@"http://cmtyapps.com/?serviceAccommodatorId=%@&serviceLocationId=%@",sa,sl];
    NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
    
    //    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc]initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    //    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //    [(UIWebView*)webController.view loadRequest:aRequest];
    //    [self.rootViewController.navigationController pushViewController:webController animated:YES];
    
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    if ([[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] && [[[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] boolValue] == YES && [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"]) {
        url = [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"];
    }
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.isFromRootView = YES;
    webController.delegate = self;
    webController.strLoadUrl = url;
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
}
-(void)didTapAndGetRestaruantDetails:(id)JSON {
    panGesture.enabled = NO;
    [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
    restaurantController.restaurantDetailsDict=JSON;
    [self.rootViewController.navigationController pushViewController:restaurantController animated:YES];
    restaurantController.view.userInteractionEnabled = YES;
    [restaurantController retriveMediaMetaDatabySaSl];
}
#pragma mark - CTFavoritesMenuViewControllerDelegate
-(void)didTapAndGetRestaruantDetailsFromFavoritesController:(NSString*)sa andSL:(NSString*)sl {
    panGesture.enabled = NO;
    [restaurantsController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    // call in web view
    
    //NSString *url= [NSString stringWithFormat:@"http://cmtyapps.com/?serviceAccommodatorId=%@&serviceLocationId=%@",sa,sl];
    NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
    
    //    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc]initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    //    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //    [(UIWebView*)webController.view loadRequest:aRequest];
    //    [self.rootViewController.navigationController pushViewController:webController animated:YES];
    
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    
    if ([[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] && [[[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] boolValue] == YES && [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"]) {
        url = [[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"url"];
    }
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.isFromRootView = YES;
    webController.delegate = nil;
    webController.strLoadUrl = url;
    webController.isFavourite = YES;
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideRightLeft];
}
-(void)didTapAndGetRestaruantDetailsFromFavoritesController:(id)JSON {
    panGesture.enabled = NO;
    [favoritesController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    [listMenuController hideMenu:YES withRootNavController:self.rootViewController.navigationController];
    CTRestaurantHomeViewController *restaurantController=[[CTRestaurantHomeViewController alloc]initWithNibName:@"CTRestaurantHomeViewController" bundle:nil];
    restaurantController.restaurantDetailsDict=JSON;
    [self.rootViewController.navigationController pushViewController:restaurantController animated:YES];
    restaurantController.view.userInteractionEnabled = YES;
    [restaurantController retriveMediaMetaDatabySaSl];
}
#pragma mark - Instance Methods
-(void)showLocationSearchPopup {
    CTLocationSearchPopup *popup =[[CTLocationSearchPopup alloc]init];
    __weak typeof (CTLocationSearchPopup*) weakPopup = popup;
    __weak typeof (self) weakSelf = self;
    popup.callBack = ^(NSString *street,NSString* city,NSString* zip) {
        if([weakSelf submitSearchQueryForStreet:street city:city zip:zip])
            [weakPopup removeFromSuperview];
    };
    [self.view addSubview:popup];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 111:{
            switch (buttonIndex) {
                case 1:{
                    [listMenuController logoutUserWithUID:[CTCommonMethods UID]];
                    self.btnLogin.selected = NO;
                    [_btnLogin setImage:[UIImage imageNamed:CT_SignInIcon] forState:UIControlStateNormal];
                    //[self showSigninOut:self.btnLogin];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    if(alertView.tag == kAlertViewTag_Login && buttonIndex!= alertView.cancelButtonIndex) {
        // login btn taped.
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
    }
}
@end
