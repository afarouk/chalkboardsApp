//
//  CTSliderMenuView.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSliderMenuView.h"
#import "CTSlideMenuCell.h"
#import "ImageNamesFile.h"
#import "CTMessageViewController.h"
#import "CTAppDelegate.h"
@implementation CTSliderMenuView
@synthesize menuListArray;
-(void)didTapOnView:(UITapGestureRecognizer*)tap {
    if([self.delegate respondsToSelector:@selector(didTapOnSlideMenuView)])
        [self.delegate didTapOnSlideMenuView];
}
-(void)enableHitDetectionArea {
    self.gestureView.frame = CGRectMake(self.container.frame.size.width, 0, [UIScreen mainScreen].applicationFrame.size.width-self.container.frame.size.width, self.frame.size.height);
    NSLog(@"gesture view frame %@",NSStringFromCGRect(self.gestureView.frame));
    self.mainMenuTableView.userInteractionEnabled = YES;
    CGRect frame = self.frame;
    frame.size.width  = self.container.frame.size.width+self.gestureView.frame.size.width;
    self.frame = frame;
}
-(void)disableHitDetectionArea {
    self.gestureView.frame=CGRectMake(0, 0, 1, 1);
    CGRect frame = self.frame;
    frame.size.width  = self.container.frame.size.width;
    self.frame = frame;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTSliderMenuView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
//        CFBridgingRetain(self);
        [self observerForPostNotification];
//        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSliderMenuView" owner:self options:nil];
//        [self addSubview:[nib objectAtIndex:0]];
        self.mainMenuTableView.tableFooterView=[[UIView alloc]init];
        self.mainMenuTableView.tableFooterView=[[UIView alloc]init];
//        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.mainMenuTableView.backgroundColor=[UIColor clearColor];
        UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sliderMenuAction:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeGesture];
        [self loadMenuArray];
        NSLog(self.isMessageControllerIsOpen ? @"YES":@"NO");
        
//        container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[nib objectAtIndex:0] frame].size.width, self.frame.size.height)];
//        [self addSubview:container];
//        [container addSubview:[nib objectAtIndex:0]];
        self.container.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        // view for gesture
//        gestureView = [[UIView alloc]initWithFrame:CGRectMake(self.mainMenuTableView.frame.size.width, 0, self.frame.size.width-self.mainMenuTableView.frame.size.width, self.frame.size.height)];
        self.gestureView.backgroundColor = [UIColor clearColor];
//        [self addSubview:gestureView];
        [self disableHitDetectionArea];
        // tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
        [self.gestureView addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
#pragma mark post notification listners
-(void)observerForPostNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMainMenuControls) name:CT_Observers_LoginBackAction object:nil];
   
}
-(void)showMainMenuControls{
    [self.loginView removeFromSuperview];
    [self.favoriteView removeFromSuperview];
    [self.reservation removeFromSuperview];
    [self.mainMenuTableView reloadData];
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    [self hiddenAllMainViewControls:NO];
}
#pragma mark slide out menu
- (IBAction)sliderMenuAction:(id)sender {
    
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame, -275, 0);
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetMainMenuSlide" object:self];
}
#pragma mark Menu content
-(void)loadMenuArray{
    
    self.menuListArray=[[NSMutableArray alloc]init];
    [self.menuListArray addObject:[NSArray arrayWithObjects:@"Login", CT_LoginIcon, nil]];
    [self.menuListArray addObject:[NSArray arrayWithObjects:@"Favorite", CT_FavoriteIcon,nil]];
    [self.menuListArray addObject:[NSArray arrayWithObjects:@"Promotion", CT_PromotionIcon,nil]];
    [self.menuListArray addObject:[NSArray arrayWithObjects:@"Message", CT_MessageIcon,nil]];
    [self.menuListArray addObject:[NSArray arrayWithObjects:@"Reservation ",CT_BookingIcon, nil]];
    
}

#pragma mark Restaurant List Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuListArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTSlideMenuCell *menuCell=(CTSlideMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"SlideMenuCell"];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSliderMenuCell" owner:self options:nil];
    menuCell=[nib objectAtIndex:0];
    //menuCell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    menuCell.menuIcon.image=[UIImage imageNamed:[[self.menuListArray objectAtIndex:indexPath.row]objectAtIndex:1]];
    menuCell.menuNameLbl.text=[[self.menuListArray objectAtIndex:indexPath.row] objectAtIndex:0];

    return menuCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self showLoginView];
            break;
        case 1:
            [self showFavoriteView];
            break;
        case 2:
          
            break;
        case 3:
            if(self.isMessageControllerIsOpen){
                [self showMessageViewController];
            }
            break;
        case 4:
              [self showMyReservationView];
            break;
        default:
            break;
    }
}

#pragma mark Login View
-(void)showLoginView{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    [self.delegate didTapOnSlideMenuView];
//    [self hiddenAllMainViewControls:YES];
//    CGRect filterFrame=CGRectMake(0 ,0,275, self.sliderView.frame.size.height);
    self.loginView=[[CTLoginPopup alloc]init];
    self.loginView.center = CGPointMake(appDelegate.window.rootViewController.view.frame.size.width/2, appDelegate.window.frame.size.height/2);
//    self.backgroundColor=[UIColor clearColor];
    [appDelegate.window.rootViewController.view addSubview:self.loginView];
}
#pragma mark Favorite View
-(void)showFavoriteView{
    [self hiddenAllMainViewControls:YES];
//    CGRect filterFrame=CGRectMake(0 ,0,275, self.sliderView.frame.size.height);
//    self.favoriteView=[[CTFavoriteView alloc]initWithFrame:filterFrame];
//    self.backgroundColor=[UIColor clearColor];
//    [self.sliderView addSubview:self.favoriteView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showfavoriteView" object:self];
}
#pragma mark ReservationView
-(void)showMyReservationView{
    [self hiddenAllMainViewControls:YES];
    CGRect filterFrame=CGRectMake(0 ,0,275, self.sliderView.frame.size.height);
    self.reservation=[[CTReservation alloc]initWithFrame:filterFrame];
    self.backgroundColor=[UIColor clearColor];
    [self addSubview:self.reservation];

}
#pragma mark MessageViewController
-(void)showMessageViewController{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CTMessageViewController *messageController=[storyboard instantiateViewControllerWithIdentifier:@"CTMessageViewController"];
    [self.navigationController pushViewController:messageController animated:YES];
}
-(void)hiddenAllMainViewControls:(BOOL)isHide{
    
    self.mainMenuTableView.hidden=isHide;
    self.titleLbl.hidden=isHide;
    self.backButton.hidden=isHide;
    self.backIcon.hidden=isHide;
    
}
@end
