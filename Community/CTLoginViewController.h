//
//  CTLoginViewController.h
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTWebviewDetailsViewController.h"
#import "UIViewController+MJPopupViewController.h"

@protocol CTLoginviewViewControllerDelegate <NSObject>
@end
@interface CTLoginViewController : UIViewController<UITextFieldDelegate,MJSecondPopupDelegate>
{
    IBOutlet UIButton *Bt_Login;
    IBOutlet UIButton *Bt_Signup;
    IBOutlet UIButton *Bt_ForgotPassword;
    
    IBOutlet UITextField *txt_Email;
    IBOutlet UITextField *txt_Password;
    
    int movementDistance ;
    CGFloat animatedDistance;
}
@property(nonatomic,strong) NSString *FavoriteMethod;
@property(nonatomic) int FevIndex;
@property(nonatomic,assign) id<CTLoginviewViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;
@property  BOOL PromotionOwner;
@property  (nonatomic,strong)NSString* TileSA;
@property  (nonatomic,strong)NSString* TileSL;
@property (nonatomic, retain) CTWebviewDetailsViewController *callerController;

- (IBAction)LoginButtonPresses:(id)sender;
- (IBAction)SignupButtonPressed:(id)sender;
- (IBAction)ForgotButtonPressed:(id)sender;

@end
