//
//  CTRestaurantMenuView.m
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRestaurantMenuView.h"
#import "CTLoginPopup.h"
#import "CTAppDelegate.h"
@implementation CTRestaurantMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CFBridgingRetain(self);
        [self observerForPostNotification];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTRestaurantMenuView" owner:self options:nil];
        self=[nib objectAtIndex:0];
        self.backgroundColor=[UIColor clearColor];
        self.frame=CGRectMake(-255, 0, self.frame.size.width, self.frame.size.height);
        self.menuHolderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    }
    return self;
}
#pragma mark observer
-(void)observerForPostNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerAction) name:CT_Observers_RestaurantMenu object:nil];
}
-(void)observerAction{
    NSLog(@"OBSERVER ACTION");
    [self hideControls:NO];
    [self.reservationView removeFromSuperview];
}
- (IBAction)tabAction:(id)sender {
    if(!self.isSlideOut){
        self.isSlideOut=YES;
        [self.delegate didShowLegend];
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.frame=CGRectOffset(self.frame, 255, 0);
        [UIView commitAnimations];

    }else{
        self.isSlideOut=NO;
        [self.delegate didHideLegend];
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.frame=CGRectOffset(self.frame, -255, 0);
        [UIView commitAnimations];
    }
}
- (IBAction)camera:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
      
        NSLog(@"UID %@",[CTCommonMethods UID]);
        [self openCamera];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)specialOffer:(id)sender {
    /* Based on Alamgir suggestion remove the login aunthentication for special offer-Dinesh*/
    [self openSpecialOfferView];
//    if([CTCommonMethods isUIDStoredInDevice]){
//        [self openSpecialOfferView];
//    }
//    else{
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
//    }
}
- (IBAction)reservation:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
        [self openReservationView];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)map:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
      
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)yelp:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
          [self openReview];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)message:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)menu:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)takOut:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
- (IBAction)call:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:1234567890"]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert show];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
    }
}
#pragma mark Camera
-(void)openCamera{
    [self.delegate didTapCameraBtn];
}

#pragma mark open reservation view
-(void)openReservationView{
    //[self hideControls:YES];
    self.reservationView=[[CTReservationView alloc]initWithFrame:self.frame];
    [self.menuHolderView addSubview:self.reservationView];
}
#pragma mark open special offer
-(void)openSpecialOfferView{
//    self.specialOfferView=[[CTSpecialOfferView alloc]initWithFrame:self.frame];
//    [self.menuHolderView addSubview:self.specialOfferView];
    [self.delegate didTapSpecialOfferView];
}
#pragma mark open Review
-(void)openReview{
    self.reviewView=[[CTReviewView alloc]initWithFrame:self.frame];
    self.reviewView.navigationController=self.navigationController;
    self.reviewView.viewController=self.viewController;
    [self.menuHolderView addSubview:self.reviewView];

}
#pragma  mark hide controls
-(void)hideControls:(BOOL)isHide{
    self.cameraButton.hidden=isHide;
    self.specialOfferButton.hidden=isHide;
    self.menuButton.hidden=isHide;
    self.reservationButton.hidden=isHide;
    self.takeOutButton.hidden=isHide;
    self.mapButton.hidden=isHide;
    self. callButton.hidden=isHide;
    self.yelpButton.hidden=isHide;
    self.messageButton.hidden=isHide;
    self.tabButton.hidden=isHide;
}
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTLoginPopup *loginPopup = [[CTLoginPopup alloc]init];
        [appDelegate.window.rootViewController.view addSubview:loginPopup];
    }
}
@end
