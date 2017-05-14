//
//  CTSignUpPopup.m
//  Community
//
//  Created by practice on 17/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSignUpPopup.h"
#import "MBProgressHUD.h"
@implementation CTSignUpPopup

#pragma Scope Methods
-(void)showSuccessAlert:(NSString *)alertMsg{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Congratulations" message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self removeFromSuperview];
//    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
}
-(void)registerNewUser{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@&email=%@",self.txt_Email.text,self.txt_Password.text,self.txt_Email.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRegisterNewMember,params];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url String %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
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
-(void)validateTextFields{
    
    if(self.txt_Password.text.length&&self.txt_ConPassword.text.length&&self.txt_Email.text.length>0){
        
        if(self.txt_Password.text.length>=6){
            
            if([self.txt_Password.text isEqualToString:self.txt_ConPassword.text]){
                
                [self registerNewUser];
            }
            else{
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password not match. Please check it"];
            }
        }
        else{
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password must be at least 6 characters long"];
        }
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter your valid details"];
    }
}

-(void)CreateCustomer
{
    NSString *urlSuffix = [NSString stringWithFormat:CT_Send_Notification,[CTCommonMethods UID]];
    NSLog(@"urlSuffix =%@",urlSuffix);
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],@"authentication/registerNewMember/"];
    
    NSURL *url=[NSURL URLWithString:urlstring];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"password\":\"%@\"}",self.txt_Email.text,self.txt_Email.text,self.txt_Password];
    NSLog(@"MSG TEXT %@",msgTxt);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCEESS = %@",JSON);
        NSDictionary *dict=(NSDictionary *)JSON;
        if (dict)
        {
//            textViewObj.text = @"";
//            [btnduration setTitle:[durationTime objectAtIndex:0] forState:UIControlStateNormal];
//            selectDuration = [durationid objectAtIndex:0];
//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleAlertCreated message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
//            [alert show];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self animated:YES];
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
#pragma Control Methods
-(IBAction)closeBtnTaped:(id)sender {
    [self removeFromSuperview];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [@[btn_Cancel,btn_create
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    self.txt_Email.delegate = self;
    self.txt_Password.delegate = self;
    self.txt_ConPassword.delegate = self;
    self.txt_Email.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txt_Password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txt_ConPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
}
- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTSignUpPopup" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)BTN_CreatePressed:(id)sender {
    NSLog(@"register api now");
    NSLog(@"pasword is  = %@",self.txt_Password.text);
    [self validateTextFields];
}

- (IBAction)BTN_CancelPressed:(id)sender {
    [self removeFromSuperview];
   // [self CreateCustomer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(IBAction)textFieldEditingChanged:(id)sender {
    if(sender == self.passwordField) {
        if([self.passwordField.text isEqualToString:@""] && [replacementStr isEqualToString:@""] == NO)
            self.passwordField.text = password;
        else
            password = self.passwordField.text;
    }else if(sender == self.confirmPasswordField) {
        if([self.confirmPasswordField.text isEqualToString:@""] && [replacementStr isEqualToString:@""] == NO)
            self.confirmPasswordField.text = retypePassword;
        else
            retypePassword = self.confirmPasswordField.text;
    }
}
#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//-(BOOL)textFieldShouldClear:(UITextField*)textField
//{
//    return NO;
//}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    replacementStr = string;
    return YES;
}
@end
