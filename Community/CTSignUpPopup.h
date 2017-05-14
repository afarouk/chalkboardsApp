//
//  CTSignUpPopup.h
//  Community
//
//  Created by practice on 17/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSignUpPopup : UIView <UITextFieldDelegate> {
    NSString *password, *retypePassword;
    NSString *replacementStr;
    IBOutlet UIButton * btn_create;
    IBOutlet UIButton * btn_Cancel;
}
@property(nonatomic,weak) IBOutlet UITextField *userNameField,*emailField,*passwordField,*confirmPasswordField;
-(IBAction)closeBtnTaped:(id)sender;
-(IBAction)registerBtnTaped:(id)sender;
-(IBAction)textFieldEditingChanged:(id)sender;

- (IBAction)BTN_CreatePressed:(id)sender;
- (IBAction)BTN_CancelPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txt_Email;
@property (strong, nonatomic) IBOutlet UITextField *txt_Password;
@property (strong, nonatomic) IBOutlet UITextField *txt_ConPassword;

@end
