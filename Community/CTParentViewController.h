//
//  CTParentViewController.h
//  Community
//
//  Created by practice on 15/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRootViewController.h"
#import "CTFilterViewController.h"
#import "CTSlideMenuViewController.h"
#import "CTRestaurantsMenuViewController.h"
#import "CTFavoritesMenuViewController.h"
#import "CTMapLegendViewController.h"
#import "CTSearchLocationViewController.h"
#import "CTLocationSearchPopup.h"
#import "CTAdAlertViewController.h"
#import "CTSupportviewViewController.h"
#import "CTAdAlertView.h"
#import "CTEventViewController.h"
#import "CTPromotionViewController.h"
#import "CTPollContestViewController.h"
#import "CTActivatePromotionView.h"
#import "CTDeactivatePromotionView.h"
#import "CTActivateEventView.h"
#import "CTDeactivateEventView.h"
// V: More
#import "CTMoreViewController.h"
#import "CTBusinessSignup.h"
#import "CTCreateViewController.h"
#import "CTMenuViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTLoginViewController.h"
#import "CTDriveMapViewController.h"
#import "CTLoadCityList.h"
#import "NIDropDown.h"

@interface CTParentViewController : UIViewController <CTGetRestaurantsDelegate,CTFavoritesMenuViewControllerDelegate,CTAdAlertViewControllerDelegate,CTSupportviewViewControllerDelegate,CTAdAlertViewDelegate,CTEventViewControllerDelegate,CTPromotionViewControllerDelegate,CTPollContestViewControllerDelegate,CTActivatePromotionViewControllerDelegate,CTDeactivatePromotionViewControllerDelegate,CTActivateEventViewControllerDelegate,CTDeactivateEventViewControllerDelegate,CTBusinessSignupDelegate,CTCreateViewDelegate,CTMenuViewDelegate,MJSecondPopupDelegate,CTLoginviewViewControllerDelegate,CTDriveMapViewControllerDelegate,NIDropDownDelegate>{
    CTSlideMenuViewController       *listMenuController;
    CTRestaurantsMenuViewController *restaurantsController;
    CTFavoritesMenuViewController   *favoritesController;
    CTFilterViewController          *filterViewController;
    CTSearchLocationViewController  *searchController;
    CTAdAlertViewController         *adAlertViewController;
    CTLoadCityList * cityLoad;
    UIView *hitDetectionView;
    UIViewController *selectedMenuController;
    // pan gesture
    UIPanGestureRecognizer *panGesture;
    
    NIDropDown *dropDown;
    UIButton *CityListButton;
    UIButton *CatagoryListButton;
    NSMutableArray *listofeventName;
    NSMutableArray *City_List;
    NSMutableArray *Catagory_List;
    
    UIButton * btnDropDown;
    
}
@property (nonatomic, retain) id searchCityResult;
@property (nonatomic,strong)  CTRootViewController *rootViewController;

@property (nonatomic,strong)  CTMapLegendViewController *mapLegendController;
@property (nonatomic, retain) CTMoreViewController *moreViewController;

@property (nonatomic, retain) CTSlideMenuViewController *listMenuController;

@property (nonatomic,strong) UIButton* favoriteButton;
@property (nonatomic,strong) UIButton* btnTiles;
@property (nonatomic,strong) UIButton* btnTilesnw;
@property (nonatomic,strong) UIButton* btnLogin;
@property (nonatomic,strong) UIButton * btnList;
-(UIBarButtonItem*)listMenuBtn ;
-(void)showLocationSearchPopup;
-(UIBarButtonItem *)favotiteButton;
-(void)filterBtnTaped:(id)sender;
-(void)searchBtnTaped:(id)sender;
-(void)favoritesBtnTaped:(id)sender;
- (IBAction)showMaskImage:(id)sender;
- (void)didTapOnShowLegend;
- (void) dismissSubViewWithAnimation;
- (void)loginPopUpOpen;
-(void)addFilterPickerController;
-(IBAction)showSigninOut:(UIButton *)sender;
@end
