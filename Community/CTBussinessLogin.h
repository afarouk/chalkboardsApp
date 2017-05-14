//
//  CTBussinessLogin.h
//  Community
//
//  Created by ADMIN on 4/20/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTBussinessLogin : UIView<UITextFieldDelegate>
{
    IBOutlet UIButton * btnCancel;
    IBOutlet UIButton * btnSubmit;
    IBOutlet UIScrollView * myView;
    
    int movementDistance ;
    CGFloat animatedDistance;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_Email;
@property (strong, nonatomic) IBOutlet UITextField *txt_Pass;
@property (strong, nonatomic) IBOutlet UITextField *txt_RePass;

-(IBAction)cancleBtnPressed:(id)sender;
-(IBAction)submitBtnPressed:(id)sender;

@end
