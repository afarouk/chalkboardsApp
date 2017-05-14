//
//  CTBusinessinvitatcodeView.h
//  Community
//
//  Created by ADMIN on 4/19/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTBusinessinvitatcodeView : UIView<UITextFieldDelegate>
{
    IBOutlet UIButton * btnCancel;
    IBOutlet UIButton * btnSubmit;
    IBOutlet UIScrollView * myView;
    
    int movementDistance ;
    CGFloat animatedDistance;
}



@property (strong, nonatomic) IBOutlet UITextField *txt_Invitation;

-(IBAction)cancleBtnPressed:(id)sender;
-(IBAction)submitBtnPressed:(id)sender;

@end
