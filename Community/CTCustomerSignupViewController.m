//
//  CTCustomerSignupViewController.m
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTCustomerSignupViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;



@interface CTCustomerSignupViewController ()

@end

@implementation CTCustomerSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib..
    
    //Scroll_Vw.layer.borderWidth = 2;
    //Scroll_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    
    //Btn_Create.layer.borderColor = [UIColor blackColor].CGColor;
    //Btn_Create.layer.borderWidth = 2;
    //Btn_Create.layer.cornerRadius = 5;
    
    //Btn_Cancel.layer.borderColor = [UIColor blackColor].CGColor;
    //Btn_Cancel.layer.borderWidth = 2;
    //Btn_Cancel.layer.cornerRadius = 5;
    
    txt_Email.layer.borderColor = [UIColor blackColor].CGColor;
    txt_Email.layer.borderWidth = 2;
    
    txt_Password.layer.borderColor = [UIColor blackColor].CGColor;
    txt_Password.layer.borderWidth = 2;
    
    txt_RePassword.layer.borderColor = [UIColor blackColor].CGColor;
    txt_RePassword.layer.borderWidth = 2;
    
    txt_Email.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Password.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_RePassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [@[txt_Email,txt_Password,txt_RePassword
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)CreateButtonPressed:(id)sender {
    [txt_Email resignFirstResponder];
    [txt_Password resignFirstResponder];
    [txt_RePassword resignFirstResponder];
    [self validateTextFields];
}

- (IBAction)CancelButtonPressed:(id)sender {
    [txt_Email resignFirstResponder];
    [txt_Password resignFirstResponder];
    [txt_RePassword resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(cancelButtonClicked:)]) {
    //        [self.mjSecondPopupDelegate cancelButtonClicked:self];
    //    }
}

-(void)validateTextFields
{
    if([self validateEmailWithString:txt_Email.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidMailId message:StringAlertMsgValidMailId delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(txt_Password.text.length&&txt_RePassword.text.length>0){
        
        if(txt_Password.text.length>=6){
            
            if([txt_Password.text isEqualToString:txt_RePassword.text]){
                
                [self registerNewUser];
            }
            else{
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertPassTitle andMessage:@"Password not match. Please check it"];
                return;
            }
        }
        else{
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertPassTitle andMessage:@"Password must be at least 6 characters long"];
            return;
        }
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter Password"];
        return;
    }
}

-(void)CreateCustomer
{
    NSString *urlSuffix = [NSString stringWithFormat:CT_Send_Notification,[CTCommonMethods UID]];
    NSLog(@"urlSuffix =%@",urlSuffix);
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],@"authentication/registerNewMember/"];
    
    NSURL *url=[NSURL URLWithString:urlstring];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"password\":\"%@\"}",txt_Email.text,txt_Email.text,txt_Password];
    NSLog(@"MSG TEXT %@",msgTxt);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)showSuccessAlert:(NSString *)alertMsg{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Congratulations" message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.view removeFromSuperview];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
}
-(void)registerNewUser{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@&email=%@",txt_Email.text,txt_Password.text,txt_Email.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getRegisterNewMember,params];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url String %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"SUCESS ===%@",(NSDictionary *)JSON);
        NSDictionary *succesDict=(NSDictionary *)JSON;
        NSString *UID=[succesDict objectForKey:@"uid"];
        NSString *userName = [succesDict objectForKey:@"userName"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [CTCommonMethods setUID:UID];
        [CTCommonMethods setUserName:userName];
        
        [defaults setValue:[CTCommonMethods UID] forKey:UIDInDefaults];
        [defaults setValue:[CTCommonMethods UserName] forKey:UserNameInDefaults];
        [defaults synchronize];
        
        
        NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
        [yourDictionary setObject:txt_Email.text forKey:@"USERNAME_KEY"];
        [yourDictionary setObject:txt_Password.text forKey:@"PASSWORD_KEY"];
        [yourDictionary setObject:[succesDict valueForKey:@"email"] forKey:@"email"];
        [yourDictionary setObject:[CTCommonMethods UID] forKey:@"uid"];
        [yourDictionary setObject:[NSNumber numberWithBool:[CTCommonMethods sharedInstance].OWNERFLAG] forKey:@"isOwner"];
        [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"DicKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showSuccessAlert:[succesDict valueForKey:@"message"]];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

#pragma mark - Email Validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(IBAction)textFieldEditingChanged:(id)sender {
    if(sender == txt_Password) {
        if([txt_Password.text isEqualToString:@""] && [replacementStr isEqualToString:@""] == NO)
            txt_Password.text = password;
        else
            password = txt_Password.text;
    }else if(sender == txt_RePassword) {
        if([txt_RePassword.text isEqualToString:@""] && [replacementStr isEqualToString:@""] == NO)
            txt_RePassword.text = retypePassword;
        else
            retypePassword = txt_RePassword.text;
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
    textField.layer.borderColor = [UIColor blueColor].CGColor;
    
    CGRect textFieldRect =
    [self.view convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view convertRect:self.view.bounds fromView:self.view];
    
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
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_Email resignFirstResponder];
    [txt_Password resignFirstResponder];
    [txt_RePassword resignFirstResponder];
}



@end
