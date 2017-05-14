//
//  CTSliderMenuView.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLoginPopup.h"
#import "CTFavoriteView.h"
#import "CTReservation.h"
@protocol CTSliderMenuViewDelegate <NSObject>
-(void)didTapOnSlideMenuView;
@end
@interface CTSliderMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) id<CTSliderMenuViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *mainMenuTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property(weak,nonatomic) IBOutlet UIView *container,*gestureView;
@property (nonatomic,strong)UINavigationController *navigationController;

@property (nonatomic,retain)NSMutableArray *menuListArray;
@property (nonatomic,strong)CTLoginPopup *loginView;
@property (nonatomic,strong)CTFavoriteView *favoriteView;
@property (nonatomic,strong)CTReservation *reservation;
@property (nonatomic,retain)UIView *sliderView;
@property (nonatomic,assign)BOOL isMessageControllerIsOpen;
-(void)enableHitDetectionArea;
-(void)disableHitDetectionArea;
@end
