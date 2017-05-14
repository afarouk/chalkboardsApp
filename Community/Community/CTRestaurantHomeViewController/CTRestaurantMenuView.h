//
//  CTRestaurantMenuView.h
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "CTReservationView.h"
#import "CTSpecialOfferView.h"
#import "CTReviewView.h"


@interface CTRestaurantMenuView : UIView <UIAlertViewDelegate>
@property(nonatomic,assign) id<CTRestaurantMenuViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *menuHolderView;
@property (nonatomic,assign)BOOL isSlideOut;
@property (nonatomic,retain)UIViewController *viewController;
@property (nonatomic,retain)UINavigationController *navigationController;
@property (nonatomic,strong)CTReservationView *reservationView;
@property (nonatomic,strong)CTSpecialOfferView *specialOfferView;
@property (nonatomic,strong)CTReviewView *reviewView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *specialOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet UIButton *takeOutButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *yelpButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *tabButton;
@property (nonatomic,retain)NSDictionary *restaurantDetailsDict;

@end
