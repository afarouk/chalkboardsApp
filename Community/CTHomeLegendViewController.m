//
//  CTHomeLegendViewController.m
//  Community
//
//  Created by practice on 02/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTHomeLegendViewController.h"
#import "CTAppDelegate.h"
#import "CTLoginPopup.h"
@interface CTHomeLegendViewController ()

@end

@implementation CTHomeLegendViewController
-(void)observerAction{
    NSLog(@"OBSERVER ACTION");
//    [self hideControls:NO];
//    [self.reservationView removeFromSuperview];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observerAction) name:CT_Observers_RestaurantMenu object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma IBAction
- (IBAction)tabAction:(id)sender {
    if(!self.isSlideOut){
        self.isSlideOut=YES;
        [self.delegate didShowLegend];
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.view.frame=CGRectOffset(self.view.frame, self.menuHolderView.frame.size.width-5, 0);
        [UIView commitAnimations];
        
    }else{
        self.isSlideOut=NO;
        [self.delegate didHideLegend];
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.view.frame=CGRectOffset(self.view.frame, -self.menuHolderView.frame.size.width+5, 0);
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
        
//        [self openReservationView];
        [self.delegate didTapReservationViewBtn];
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
//    if([CTCommonMethods isUIDStoredInDevice]){
//        [self openReview];
        [self.delegate didTapYelpBtn];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
//        [alert show];
//        //        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
//    }
}
- (IBAction)message:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        [self.delegate didTapMessageBtn];
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
    self.reservationView=[[CTReservationView alloc]initWithFrame:self.view.frame];
    [self.menuHolderView addSubview:self.reservationView];
    [self.menuHolderView bringSubviewToFront:self.reservationView];
}
#pragma mark open special offer
-(void)openSpecialOfferView{
    //    self.specialOfferView=[[CTSpecialOfferView alloc]initWithFrame:self.frame];
    //    [self.menuHolderView addSubview:self.specialOfferView];
    [self.delegate didTapSpecialOfferView];
}
#pragma mark open Review
-(void)openReview{
    self.reviewView=[[CTReviewView alloc]initWithFrame:self.view.frame];
    self.reviewView.navigationController=self.navigationController;
    self.reviewView.viewController=self;
    [self.menuHolderView addSubview:self.reviewView];
    
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
