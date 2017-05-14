//
//  CTLoginPopup.h
//  Community
//
//  Created by practice on 27/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTWebviewDetailsViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface CTLoginPopup : UIView <UITextFieldDelegate,MJSecondPopupDelegate>
@property(nonatomic,weak) IBOutlet UITextField *userNameField,*passField;
@property (nonatomic, retain) CTWebviewDetailsViewController *callerController;
-(IBAction)closeBtnTaped:(id)sender;
-(IBAction)loginBtnTaped:(id)sender;
-(IBAction)registerBtnTaped:(id)sender;

//+(NSString*)userUID;
@end
