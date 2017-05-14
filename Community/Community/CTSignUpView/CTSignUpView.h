//
//  CTSignUpView.h
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSignUpView : UIView<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *promocodeTxtField;
@property (weak, nonatomic) IBOutlet UIView *holderView;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end
