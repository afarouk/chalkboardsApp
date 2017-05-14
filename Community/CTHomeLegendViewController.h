//
//  CTHomeLegendViewController.h
//  Community
//
//  Created by practice on 02/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTReservationView.h"
#import "CTReviewView.h"
//@protocol CTRestaurantMenuViewDelegate <NSObject>
//-(void)didTapCameraBtn;
//-(void)didTapSpecialOfferView;
//-(void)didShowLegend;
//-(void)didHideLegend;
//@end
@interface CTHomeLegendViewController : UIViewController
@property(nonatomic,weak) id<CTRestaurantMenuViewDelegate> delegate;
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
@property(nonatomic,weak) IBOutlet UIView *menuHolderView;
@property(nonatomic,strong) CTReviewView* reviewView;
@property(nonatomic,strong)CTReservationView *reservationView;
@property BOOL isSlideOut;
- (IBAction)tabAction:(id)sender ;
@end
