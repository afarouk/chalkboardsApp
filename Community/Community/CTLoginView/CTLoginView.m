//
//  CTLoginView.m
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTLoginView.h"
@implementation CTLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CFBridgingRetain(self);
        [self observerForPostNotification];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTLoginView" owner:self options:nil];
        self=[nib objectAtIndex:0];
        UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
        swipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeGesture];
         self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.loginButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.signUpButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
       
    }
    return self;
}
#pragma mark post notification listners
-(void)observerForPostNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginView) name:CT_Observers_SignupCloseAction object:nil];
}
#pragma mark reset controls
-(void)showLoginView{
    
   // [self.signupView removeFromSuperview];
    [self hiddenLoginViewControls:NO];
}
-(IBAction)cancel:(id)sender{
    
}
-(IBAction)login:(id)sender{
    [self validate];
}
-(IBAction)signUp:(id)sender{
    
    [self showSignUpView];
}
-(IBAction)close:(id)sender{
    [self closeLoginView];
}
#pragma mark close login view
-(void)closeLoginView{
    [UIView beginAnimations:@"slideAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.frame=CGRectOffset(self.frame,-275, 0);
    [UIView commitAnimations];
    [self postNotification];

}
#pragma mark post notification
-(void)postNotification{
   [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
}
#pragma mark Signup view
-(void)showSignUpView{
    [self hiddenLoginViewControls:YES];
    CGRect filterFrame=CGRectMake(0 ,0,275, self.frame.size.height);
    self.signupView=[[CTSignUpView alloc]initWithFrame:filterFrame];
    self.backgroundColor=[UIColor clearColor];
    [self addSubview:self.signupView];
}
#pragma mark hide login view
-(void)hiddenLoginViewControls:(BOOL)isHide{
    self.titleLbl.hidden=isHide;
    self.closeIcon.hidden=isHide;
    self.closeButton.hidden=isHide;
    self.usernameTxtField.hidden=isHide;
    self.passwordTxtField.hidden=isHide;
    self.loginLabel.hidden=isHide;
    self.loginButton.hidden=isHide;
    self.signUpButton.hidden=isHide;
    self.signupLabel.hidden=isHide;
    self.joinUsLabel.hidden=isHide;
}

#pragma mark validate input fileds
-(void)validate{
    
    if(self.usernameTxtField.text.length&&self.passwordTxtField.text.length>0){
        [self loginUser];
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter your name and password"];
    }
}
#pragma mark loginuser
-(void)loginUser{
   
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@",self.usernameTxtField.text,self.passwordTxtField.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_loginUser,params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        NSDictionary *successDict=(NSDictionary *)JSON;
        NSString *UID=[successDict objectForKey:@"uid"];
        NSString *userName = [successDict objectForKey:@"userName"];
        NSLog(@"UID %@ \n userName %@",UID,userName);
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [CTCommonMethods setUID:UID];
        [CTCommonMethods setUserName:userName];
        
        [defaults setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
        [defaults setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
        [defaults synchronize];
        [self closeLoginView];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAILED %@",(NSDictionary *)JSON);
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
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
