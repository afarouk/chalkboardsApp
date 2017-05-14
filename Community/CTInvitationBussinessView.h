//
//  CTInvitationBussinessView.h
//  Community
//
//  Created by ADMIN on 4/22/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol MJSecondPopupDelegate;
@interface CTInvitationBussinessView : UIViewController<UITextFieldDelegate,MJSecondPopupDelegate>
{
    IBOutlet UIButton * btnCancel;
    IBOutlet UIButton * btnSubmit;
    IBOutlet UIScrollView * myView;
    
    IBOutlet UIView *Invite_Vw;
    
    int movementDistance ;
    CGFloat animatedDistance;
}
@property (assign, nonatomic) id <MJSecondPopupDelegate>mjSecondPopupDelegate;

@property (strong, nonatomic) IBOutlet UITextField *txt_Invitation;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroll_Vw;

-(IBAction)cancleBtnPressed:(id)sender;
-(IBAction)submitBtnPressed:(id)sender;

@end
