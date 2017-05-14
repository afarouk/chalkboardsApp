//
//  CTBussinessLogin.m
//  Community
//
//  Created by ADMIN on 4/20/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTBussinessLogin.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.6;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 200;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@implementation CTBussinessLogin

- (id)init
{

    
    self = [[[NSBundle mainBundle]loadNibNamed:@"BussinessLogin" owner:self options:nil] objectAtIndex:0];
    self.frame = [[UIScreen mainScreen] bounds];
    
    self.txt_Email.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Email.layer.borderWidth = 1;
    
    self.txt_Pass.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Pass.layer.borderWidth = 1;
    
    self.txt_RePass.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_RePass.layer.borderWidth = 1;
    
    
    btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
    btnCancel.layer.borderWidth = 2 ;
    btnCancel.layer.cornerRadius = 5;
    btnCancel.layer.masksToBounds = YES;
    btnSubmit.layer.borderColor = [UIColor blackColor].CGColor;
    btnSubmit.layer.borderWidth = 2 ;
    btnSubmit.layer.cornerRadius = 5;
    btnSubmit.layer.masksToBounds = YES;
    myView.layer.borderColor = [UIColor blackColor].CGColor;
    myView.layer.borderWidth = 2;
    myView.layer.cornerRadius = 5;
    myView.layer.masksToBounds = YES;
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)cancleBtnPressed:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)submitBtnPressed:(id)sender
{
    [self loginUser];
}

-(void)loginUser{
    if (!_txt_Email.text.length || !_txt_Pass.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please Fillups" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [_txt_Email becomeFirstResponder];
        [_txt_Pass becomeFirstResponder];
    }
    else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Please wait...";

        NSString *promotionRequest = [NSString stringWithFormat:@"%@?email=%@&invitationCode=%@&password=%@&username=%@",@"authentication/createOwnerFromInvitation",_txt_Email.text,[CTCommonMethods sharedInstance].invitationcode,_txt_Pass.text,_txt_Email.text];
        
        NSLog(@"promotionRequest = %@",promotionRequest);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                    initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
        NSMutableURLRequest *request = [httpClient
                                        requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
        NSLog(@"request me %@",request);
        //[request setHTTPBody:imageData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"PUT"];
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *dict=(NSDictionary *)JSON;
            NSLog(@"SUCEESS = %@",dict);
            if (dict)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitleEventActivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                [alertView show];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if(error) {
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
            }else {
                NSLog(@"FAILED");
                NSError *jsonError = [CTCommonMethods validateJSON:JSON];
                if(jsonError)
                    [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
                else
                    [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
            }
            
        }];
        
        [operation start];
    }
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    return;
    CGRect textFieldRect =
    [self.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.window convertRect:self.bounds fromView:self];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }
    else
    {
        // NSLog(@"animatedDistance1=%f",animatedDistance);
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    // NSLog(@"animatedDistance2=%f",animatedDistance);
    CGRect viewFrame = self.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    return;
    CGRect viewFrame = self.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self setFrame:viewFrame];
    [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
