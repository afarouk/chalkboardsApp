//
//  CTInvitationLoginView.h
//  Community
//
//  Created by ADMIN on 4/22/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"
#import "CustomIOSAlertView.h"
@protocol MJSecondPopupDelegate;
@interface CTInvitationLoginView : UIViewController<UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    
    IBOutlet UIButton *btncancel;
    IBOutlet UIButton *btnsubmit;
    
    IBOutlet UIScrollView *Scroll_Vw;
    
    int movementDistance ;
    CGFloat animatedDistance;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_Email_Id;
@property (strong, nonatomic) IBOutlet UITextField *txt_Password;
@property (strong, nonatomic) IBOutlet UITextField *txt_RePassword;

- (IBAction)submitBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;



@property (assign, nonatomic) id <MJSecondPopupDelegate>mjSecondPopupDelegate;



@end
