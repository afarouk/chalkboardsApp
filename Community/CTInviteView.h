//
//  CTInviteView.h
//  Community
//
//  Created by My Mac on 15/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CTInviteView : UIView <UITextFieldDelegate>
{
    IBOutlet UISwitch * switchTerms;
    IBOutlet UIButton * btnCancel;
    IBOutlet UIButton * btnSubmit;
    IBOutlet UIScrollView * myView;
    BOOL isEnable;
    
    int movementDistance ;
    CGFloat animatedDistance;
}
@property(nonatomic,weak) IBOutlet UITextField *userNameField,*passField,*repassField,*inviteField,*emailField;
- (IBAction)enableValueChanged:(UISwitch *)sender;
-(IBAction)cancleBtnPressed:(id)sender;
-(IBAction)submitBtnPressed:(id)sender;
-(IBAction)termsconditonBtnPressed:(id)sender;
@end
