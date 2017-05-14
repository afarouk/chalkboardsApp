//
//  CTSelectTypeViewController.h
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol MJSecondPopupDelegate;
@interface CTSelectTypeViewController : UIViewController<UITextFieldDelegate,MJSecondPopupDelegate>
{
    
    //IBOutlet UIScrollView *Scroll_Vw;
    
    IBOutlet UIView *Bussiness_Vw;
    IBOutlet UIView *Customer_Vw;
    
    IBOutlet UIButton *Bt_Bussiness;
    
    IBOutlet UIButton *Bt_Customer;
}

//- (IBAction)CloseButtonPressed:(id)sender;
- (IBAction)CustomerButtonPressed:(id)sender;
- (IBAction)BussinessButtonPressed:(id)sender;
@property (assign, nonatomic) id <MJSecondPopupDelegate>mjSecondPopupDelegate;


@end
