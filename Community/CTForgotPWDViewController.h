//
//  CTForgotPWDViewController.h
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol MJSecondPopupDelegate;
@interface CTForgotPWDViewController : UIViewController
{
    IBOutlet UITextField *txt_EmailAdd;
    IBOutlet UIButton *Btn_Create;
    IBOutlet UIButton *Btn_Cancel;
    IBOutlet UIScrollView *Scroll_Vw;
    
    int movementDistance ;
    CGFloat animatedDistance;
}

- (IBAction)CreateButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
@property (assign, nonatomic) id <MJSecondPopupDelegate>mjSecondPopupDelegate;




@end
