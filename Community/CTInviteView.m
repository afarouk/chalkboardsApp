//
//  CTInviteView.m
//  Community
//
//  Created by My Mac on 15/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTInviteView.h"
#import "CTAppDelegate.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.6;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 200;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@implementation CTInviteView

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"InvitaionView" owner:self options:nil] objectAtIndex:0];
    self.frame = [[UIScreen mainScreen] bounds];
    self.userNameField.layer.borderColor = [UIColor blackColor].CGColor;
    self.userNameField.layer.borderWidth = 1;
    self.inviteField.layer.borderColor = [UIColor blackColor].CGColor;
    self.inviteField.layer.borderWidth = 1;
    self.passField.layer.borderColor = [UIColor blackColor].CGColor;
    self.passField.layer.borderWidth = 1;
    self.repassField.layer.borderColor = [UIColor blackColor].CGColor;
    self.repassField.layer.borderWidth = 1;
    self.emailField.layer.borderColor = [UIColor blackColor].CGColor;
    self.emailField.layer.borderWidth = 1;
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

-(void)awakeFromNib {
    [super awakeFromNib];
}
-(IBAction)cancleBtnPressed:(id)sender
{
    [self removeFromSuperview];
}
-(IBAction)submitBtnPressed:(id)sender
{
    if(isEnable == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select enable button" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![self.passField.text isEqualToString:self.repassField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password miss match" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self loginUser];
   // [self validate];
}
-(IBAction)termsconditonBtnPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sitelettes.com/termsandconditions"]];
}
- (IBAction)enableValueChanged:(UISwitch *)sender
{
    if (isEnable && [sender isOn])
        return;
    else if (!isEnable && ![sender isOn])
        return;
    isEnable = [sender isOn];
}
-(void)validate{
    
    if(self.userNameField.text.length&&self.passField.text.length&&self.inviteField&&self.emailField>0){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        //[self loginUser];
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter all value."];
    }
}
-(void)loginUser{
    
    NSString *params=[NSString stringWithFormat:@"registerNewMemberWithInvitationCode/?code=%@&username=%@&password=%@&email=%@",self.inviteField.text,self.userNameField.text,self.passField.text,self.emailField.text];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],@"authentication/",params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url String %@",urlString);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        if (JSON)
        {
            NSString * stringmessage = [JSON valueForKey:@"message"];
            [[[UIAlertView alloc] initWithTitle:stringmessage message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
        }
        [self removeFromSuperview];
       
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        if(JSON) {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }else if(error) {
            NSLog(@"FAILED");
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedDescription];
            
        }
    }];
    [operation start];
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
