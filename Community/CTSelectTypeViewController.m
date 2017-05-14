//
//  CTSelectTypeViewController.m
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTSelectTypeViewController.h"
#import "CTSignUpPopup.h"
#import "CTCustomerSignupViewController.h"

@interface CTSelectTypeViewController ()

@end

@implementation CTSelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Scroll_Vw.layer.borderWidth = 2;
    //Scroll_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    
    //Bt_Bussiness.layer.borderColor = [UIColor blackColor].CGColor;
    //Bt_Bussiness.layer.borderWidth = 2;
    //Bt_Bussiness.layer.cornerRadius = 5;
    
    //Bt_Customer.layer.borderColor = [UIColor blackColor].CGColor;
    //Bt_Customer.layer.borderWidth = 2;
    //Bt_Customer.layer.cornerRadius = 5;
    
    Bussiness_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    Bussiness_Vw.layer.borderWidth = 2;
    
    Customer_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    Customer_Vw.layer.borderWidth = 2;
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)CloseButtonPressed:(id)sender {
    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.mjSecondPopupDelegate cancelButtonClicked:self];
    }
}

- (IBAction)CustomerButtonPressed:(id)sender {
    //    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CTSignUpPopup * Customer = [[CTSignUpPopup alloc] init];
    //    [appDelegate.window.rootViewController.view addSubview:Customer];
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CTCustomerSignupViewOpen" object:nil];
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //[self closeView];
}

- (IBAction)BussinessButtonPressed:(id)sender {
    [self closeView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BusinessOpen" object:nil];
}

-(void)closeView
{
    //[self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    //    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(Done2Success:)]) {
    //        [self.mjSecondPopupDelegate Done2Success:self];
    //    }
}



@end
