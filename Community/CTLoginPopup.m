//
//  CTLoginPopup.m
//  Community
//
//  Created by practice on 27/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTLoginPopup.h"
#import "MBProgressHUD.h"
#import "CTAppDelegate.h"
#import "CTSignUpPopup.h"
#import "CTForgotPWD.h"
#import "CTChooseType.h"
#import "CTSelectTypeViewController.h"

@implementation CTLoginPopup

@synthesize callerController;

#pragma Scope Methods
-(void)closeLoginView{
    [self removeFromSuperview];
//    if (callerController) {
//        NSString *strJS = [NSString stringWithFormat:@"IOSLoginSucceeded('%@')",[CTCommonMethods UID]];
//        [callerController.webViewDetail stringByEvaluatingJavaScriptFromString:strJS];
//        
////        [callerController reloadWebView:YES];
//        
//        NSString *parameterOne = [CTCommonMethods UID];
//        NSString *parameterTwo = [CTCommonMethods UserName];
//        
//        NSString *suppliedFunctionName = @"variable_from_lauri, e.g. 'y'";
//        NSString *defaultLoginCallback = @"IOSLoginSucceeded";
//        [self performSelector:@selector(doIt) withObject:nil afterDelay:6.];
//        NSString *javascriptString1 = [NSString stringWithFormat:@"%@('%@','%@')",defaultLoginCallback , parameterOne , parameterTwo];
//        [callerController.webViewDetail stringByEvaluatingJavaScriptFromString:javascriptString1];
//        
////        if( suppliedFunctionName is not null) {
////            NSString *javascriptString2 = [NSString stringWithFormat:@"%@('%@','%@')",suppliedFunctionName , parameterOne , parameterTwo ];
////            [callerController.webViewDetail stringByEvaluatingJavaScriptFromString:javascriptString2];
////        }
//    }
    
    if (callerController) {
        [callerController loginCallBack];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
}

//- (void)doIt{
//    if (callerController) {
//        [callerController.webViewDetail stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
//        [callerController reloadWebView:YES];
//    }
//}

-(void)loginUser{
    
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@",self.userNameField.text,self.passField.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_loginUser,params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        NSDictionary *successDict=(NSDictionary *)JSON;
        NSString *UID=[successDict objectForKey:@"uid"];
        [CTCommonMethods sharedInstance].OWNERFLAG = [[successDict valueForKey:@"isOwner"] boolValue];
        [CTCommonMethods sharedInstance].USERONFLAG = [[successDict valueForKey:@"isOwner"] integerValue];
        NSString *userName = [successDict objectForKey:@"userName"];
        [CTCommonMethods sharedInstance].Onuser =[successDict objectForKey:@"userName"];
        NSString *email = [successDict objectForKey:@"email"];
        [CTCommonMethods sharedInstance].EmailID =[successDict objectForKey:@"email"];
        NSLog(@"i'm user %@",userName);
        NSLog(@"UID %@",UID);
        NSLog(@"isOwner %d",[CTCommonMethods sharedInstance].OWNERFLAG);
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:UID forKey:CT_UID];
//        [defaults synchronize];
        [CTCommonMethods setUID:UID];
        [CTCommonMethods setUserName:userName];
        
        [defaults setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
        [defaults setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
        [defaults synchronize];
        [CTCommonMethods showErrorAlertMessageWithTitle:@"Successfully Logged In" andMessage:[NSString stringWithFormat:@"You have successfully logged in as %@",self.userNameField.text]];
        [self closeLoginView];
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFastSasl" object:nil];
        }
        else
        {
            if ([CTCommonMethods sharedInstance].PRAMOTIONFLAG == YES && [CTCommonMethods UID])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSlowSasl" object:nil];
            }
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        NSString *alertMsg = [jsonObj valueForKeyPath:@"error.message"];
        if (alertMsg) {
            [CTCommonMethods showErrorAlertMessageWithTitle:@"Error" andMessage:alertMsg];
        }
        else if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:@"Error" andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:@"Error" andMessage:CT_DefaultAlertMessage];
        }
    }];
    [operation start];
    
}
-(void)validate{
    
    if(self.userNameField.text.length&&self.passField.text.length>0){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        [self loginUser];
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter your user name and password"];
    }
}
-(void)awakeFromNib {
    [super awakeFromNib];
//    if ([self.userNameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
//        self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: color}];
//        self.passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
//    } else {
//        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//        // TODO: Add fall-back code to set placeholder color.
//    }
}
- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"LoginPopup" owner:self options:nil] objectAtIndex:0];
    self.frame = [[UIScreen mainScreen] bounds];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)closeBtnTaped:(id)sender {
    [self removeFromSuperview];
}
-(IBAction)loginBtnTaped:(id)sender {
    [self validate];
}
-(IBAction)forgotPwdBtnTaped:(id)sender{
    [self removeFromSuperview];
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTForgotPWD * popup = [[CTForgotPWD alloc] init];
//    [self addSubview:popup];
    [appDelegate.window.rootViewController.view addSubview:popup];
}
-(IBAction)registerBtnTaped:(id)sender {
    [self removeFromSuperview];
//    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
//    CTChooseType * ChooseType = [[CTChooseType alloc] init];
//    [appDelegate.window.rootViewController.view addSubview:ChooseType];
    
    CTSelectTypeViewController * myemailpopup = [[CTSelectTypeViewController alloc] initWithNibName:@"CTSelectTypeViewController" bundle:nil];
    myemailpopup.mjSecondPopupDelegate = self;
    //[self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
//    CTSignUpPopup *popup = [[CTSignUpPopup alloc]init];
//    [appDelegate.window.rootViewController.view addSubview:popup];
}

#pragma mark - PopUP Delegate method

-(void) DoneSuccess:(id)aSecondDetailViewController
{
    
}

- (void)cancelButtonClicked:(id)aSecondDetailViewController
{
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
