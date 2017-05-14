//
//  CTLoginView.h
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSignUpView.h"

@interface CTLoginView : UIView<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak,nonatomic)IBOutlet UIButton *loginButton;
@property (weak,nonatomic)IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (nonatomic,strong)CTSignUpView *signupView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinUsLabel;

-(IBAction)cancel:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)signUp:(id)sender;
-(IBAction)close:(id)sender;
@end
