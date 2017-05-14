//
//  CTNavigationBar.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSlideRestaurantListView.h"
#import "CTSliderMenuView.h"
#import "CTFilterView.h"
#import "CTFavoriteView.h"
#import <MessageUI/MessageUI.h>
enum SelectedToolBarButton {
    SelectedToolBarButton_None = 0,
    SelectedToolBarButton_Filter = 1,
    SelectedToolBarButton_Favorites = 2,
    SelectedToolBarButton_RestaurantList = 3,
    SelectedToolBarButton_ListMenu = 4
};
@interface CTNavigationBar : UIView<MFMailComposeViewControllerDelegate,CTCTSlideRestaurantListViewDelegate,CTSliderMenuViewDelegate,CTFilterViewDelegate,CTFavoriteViewDelegate,UIAlertViewDelegate> {
    NSUInteger selectedBarButton;
}
@property (nonatomic,retain)UINavigationController *navigationController;
@property (nonatomic,retain)UIView *sliderView;
@property (nonatomic,strong)CTSlideRestaurantListView *slideRestaurantListView;
@property (nonatomic,strong)CTSliderMenuView *slideMainMenu;
@property (nonatomic,strong)CTFilterView *filterView;
@property (nonatomic,strong)CTFavoriteView *favoriteView;
@property (nonatomic,retain)UIButton *filterButton;
@property (nonatomic,retain)UIButton *menuButton;
@property (nonatomic,retain)UIButton *listButton;
@property (nonatomic,retain)UIButton *backButton;
@property (nonatomic,retain)UIButton *shareButton;
@property (nonatomic,retain)UIButton *favoriteButton;
//@property (nonatomic,assign)BOOL isRestaurantSlideout;
//@property (nonatomic,assign)BOOL isMainMenuSlideOut;
//@property (nonatomic,assign)BOOL isFilterPopup;
@property (nonatomic,assign)BOOL isMessageControllerIsOpen;
//@property (nonatomic,assign)BOOL isFavoriteList;
@property (nonatomic,assign)BOOL isFavoriteFromHome;


-(UIBarButtonItem *)setFilterButton;
-(UIBarButtonItem *)setMenuButton;
-(UIBarButtonItem *)setBackButton;
-(UIBarButtonItem *)setShareButton;
-(UIBarButtonItem *)setFavotiteButton;
-(UIBarButtonItem *)spaceButton;
-(UIView *)setListButton;
-(UIImageView *)setRestaurantLogo:(NSString *)imageString;
-(UIView *)restuarantListSliderMenu;
-(UIView *)sliderMainMenu;
-(UIView *)filterPopupMenu;
-(UIView *)favoriteListView;
-(UIColor *)navColor;
-(NSData *)logoURL:(NSString *)urlString;

@end
