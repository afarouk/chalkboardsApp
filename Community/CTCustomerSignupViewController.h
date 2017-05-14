//
//  CTCustomerSignupViewController.h
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol MJSecondPopupDelegate;
@interface CTCustomerSignupViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txt_Email;
    IBOutlet UITextField *txt_Password;
    IBOutlet UITextField *txt_RePassword;
    IBOutlet UIButton *Btn_Create;
    IBOutlet UIButton *Btn_Cancel;
    IBOutlet UIScrollView *Scroll_Vw;
    
    NSString *password, *retypePassword;
    NSString *replacementStr;
    
    int movementDistance ;
    CGFloat animatedDistance;
}

- (IBAction)CreateButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;

@property (assign, nonatomic) id <MJSecondPopupDelegate>mjSecondPopupDelegate;

@end
