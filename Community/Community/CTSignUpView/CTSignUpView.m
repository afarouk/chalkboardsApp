//
//  CTSignUpView.m
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSignUpView.h"

@implementation CTSignUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CFBridgingRetain(self);
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSignUpView" owner:self options:nil];
        self=[nib objectAtIndex:0];
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.signupButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        
    }
    return self;
}
- (IBAction)signup:(id)sender {
    
    [self validateTextFields];
}
-(IBAction)close:(id)sender{
    [self postNotification];
}
#pragma mark post notification
-(void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
}
#pragma mark keyboard up animation
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag>0){
    [self animateKeyboardUp:YES];
    [self hideHolderViewControls:YES];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag>0){
     [self animateKeyboardUp:NO];
    [self hideHolderViewControls:NO];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)animateKeyboardUp:(BOOL)isUP{
    
    int movementDistance=120;
    int movement= isUP?(-movementDistance):(movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.holderView.frame=CGRectOffset(self.holderView.frame, 0, movement);
    [UIView commitAnimations];
    
}
-(void)hideHolderViewControls:(BOOL)isHide{
    
    self.usernameTxtField.hidden=isHide;
    self.emailTxtField.hidden=isHide;
    self.passwordTxtField.hidden=isHide;
}
#pragma mark validate TextFields
-(void)validateTextFields{
    
    if(self.usernameTxtField.text.length&&self.passwordTxtField.text.length&&self.confirmPasswordTxtField.text.length&&self.emailTxtField.text.length&&self.promocodeTxtField.text.length>0){
        
        if(self.passwordTxtField.text.length>6){
            
            if([self.passwordTxtField.text isEqualToString:self.confirmPasswordTxtField.text]){
                
                [self registerNewUser];
            }
            else{
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password not match. Please check it"];
            }
        }
        else{
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password must 6 characters long"];
        }
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter your valid details"];
    }
}
#pragma mark Signup
-(void)registerNewUser{
    
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@&email=%@&promoCode=%@",self.usernameTxtField.text,self.passwordTxtField.text,self.emailTxtField.text,self.promocodeTxtField.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRegisterNewMember,params];
    NSLog(@"url String %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        NSDictionary *succesDict=(NSDictionary *)JSON;
        NSString *UID=[succesDict objectForKey:@"uid"];
        NSString *userName = [succesDict objectForKey:@"userName"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [CTCommonMethods setUID:UID];
        [CTCommonMethods setUserName:userName];
        
        [defaults setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
        [defaults setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
        [defaults synchronize];
        
        [self showSuccessAlert:[succesDict valueForKey:@"message"]];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
    }];
    [operation start];

/*
    NSString *urlString=[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]];
    NSURL *url=[NSURL URLWithString:urlString];
    NSDictionary *params=@{@"username":self.usernameTxtField.text,
                           @"password":self.passwordTxtField.text,
                           @"email":self.emailTxtField.text,
                           @"promoCode":@""};
    NSLog(@"param %@",params);
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                     path:CT_getRegisterNewMember
                                               parameters:params];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCESS");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAIL %@",(NSDictionary *)JSON);
    }];
    [operation start];
*/
}
-(void)showSuccessAlert:(NSString *)alertMsg{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Congratulations" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     [self postNotification];
}
@end
