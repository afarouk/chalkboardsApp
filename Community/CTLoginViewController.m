//
//  CTLoginViewController.m
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTLoginViewController.h"
#import "MBProgressHUD.h"
#import "CTAppDelegate.h"
#import "CTSignUpPopup.h"
#import "CTForgotPWD.h"
#import "CTChooseType.h"
#import "CTSelectTypeViewController.h"
#import "CTForgotPWDViewController.h"
#import "CTParentViewController.h"
#import "ImageNamesFile.h"
#import "KeychainItemWrapper.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTLoginViewController ()
{
    KeychainItemWrapper * keychainItem;
}

@end

@implementation CTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    txt_Email.layer.borderColor = [UIColor blackColor].CGColor;
    txt_Email.layer.borderWidth = 2;
    
    txt_Password.layer.borderColor = [UIColor blackColor].CGColor;
    txt_Password.layer.borderWidth = 2;
    
    //Bt_ForgotPassword.layer.cornerRadius = 5;
    //Bt_Login.layer.cornerRadius = 5;
    //Bt_Signup.layer.cornerRadius = 5;
    
    txt_Email.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Password.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [@[txt_Email,txt_Password
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    
    
//    NSString *emailAdress = txt_Email.text;
//    NSString *password = txt_Password.text;
//    //because keychain saves password as NSData object
//    NSData *pwdData = [password dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //Save item
//    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
//    [keychainItem setObject:emailAdress forKey:(__bridge id)(kSecAttrAccount)];
//    [keychainItem setObject:pwdData forKey:(__bridge id)(kSecValueData)];
    
}

#pragma Scope Methods
-(void)closeLoginView{
    //[self.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.parentViewController removeFromParentViewController];
    
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
    
    if (_callerController) {
        [_callerController loginCallBack];
    }
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_LoginBackAction object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_SuccessfullyLogedIn object:nil];
}

-(void)loginUser
{
    NSString *params=[NSString stringWithFormat:@"username=%@&password=%@",txt_Email.text,txt_Password.text];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_loginUser,params];
    NSLog(@"url %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        

        NSDictionary *successDict=(NSDictionary *)JSON;
        NSString *UID=[successDict objectForKey:@"uid"];
        [CTCommonMethods sharedInstance].OWNERFLAG = [[successDict valueForKey:@"isOwner"] boolValue];
        NSString *userName = [successDict objectForKey:@"userName"];
        NSLog(@"username is %@",userName);
        [CTCommonMethods sharedInstance].Onuser =[successDict objectForKey:@"userName"];
        [CTCommonMethods sharedInstance].EmailID =[successDict objectForKey:@"email"];
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
        
        NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
        [yourDictionary setObject:txt_Email.text forKey:@"USERNAME_KEY"];
        [yourDictionary setObject:txt_Password.text forKey:@"PASSWORD_KEY"];
        [yourDictionary setObject:[successDict valueForKey:@"email"] forKey:@"email"];
        [yourDictionary setObject:[CTCommonMethods UID] forKey:@"uid"];
        [yourDictionary setObject:[NSNumber numberWithBool:[CTCommonMethods sharedInstance].OWNERFLAG] forKey:@"isOwner"];
        [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"DicKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [CTCommonMethods showErrorAlertMessageWithTitle:@"Successfully Logged In" andMessage:[NSString stringWithFormat:@"You have successfully logged in as %@",txt_Email.text]];
        NSLog(@"Succuss Login %@",_FavoriteMethod);
        if ([_FavoriteMethod isEqualToString:@"FevoriteImg"])
        {
            CTWebviewDetailsViewController *detail = [[CTWebviewDetailsViewController alloc]init];
            detail.indexValue = _FevIndex;
            [detail btnFavouriteTapped:NULL];
        
        }
        [self closeLoginView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSignImage" object:nil];
        
        if (_PromotionOwner == YES)
        {
            NSLog(@"SA Value get = %@",_TileSA);
            NSLog(@"SA Value get = %@",_TileSL);
            [CTCommonMethods sharedInstance].selectSa = _TileSA;
            [CTCommonMethods sharedInstance].selectSl = _TileSL;
            [CTCommonMethods sharedInstance].TILEPROMOTION = _PromotionOwner;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPramotion" object:nil];
            
        }
        else
        {
            NSLog(@"call this for SASL");
            NSLog(@"isOwner %d",[CTCommonMethods sharedInstance].OWNERFLAG);
            if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
            {
                
                NSLog(@"Condition True");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFastSasl" object:nil];
            }
            else
            {
                 NSLog(@"Condition False");
                if ([CTCommonMethods sharedInstance].PRAMOTIONFLAG == YES && [CTCommonMethods UID])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSlowSasl" object:nil];
                }
            }
        }
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SUBS" object:nil];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    if(txt_Email.text.length&&txt_Password.text.length>0){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        [self loginUser];
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter your user name and password"];
    }
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

- (IBAction)LoginButtonPresses:(id)sender {
    [self validate];
}

- (IBAction)SignupButtonPressed:(id)sender {
    
    //    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CTChooseType * ChooseType = [[CTChooseType alloc] init];
    //    [appDelegate.window.rootViewController.view addSubview:ChooseType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CTLoginViewOpen" object:self];
    
    //[self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
    
    
    
    //    CTSignUpPopup *popup = [[CTSignUpPopup alloc]init];
    //    [appDelegate.window.rootViewController.view addSubview:popup];
    
    
    
    
}

- (IBAction)ForgotButtonPressed:(id)sender {
    //[self.view removeFromSuperview];
    //    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CTForgotPWD * popup = [[CTForgotPWD alloc] init];
    //    //    [self addSubview:popup];
    //    [appDelegate.window.rootViewController.view addSubview:popup];
    
    //    CTForgotPWDViewController * myemailpopup = [[CTForgotPWDViewController alloc] initWithNibName:@"CTForgotPWDViewController" bundle:nil];
    //    myemailpopup.mjSecondPopupDelegate = self;
    //    [self presentPopupViewController:myemailpopup animationType:MJPopupViewAnimationSlideBottomTop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CTForgotViewOpen" object:self];
    
    
}

-(void)didTapBackButtonOnFavorites:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
    
}

#pragma mark - PopUP Delegate method

-(void) Done2Success:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

- (void)cancelButtonClicked:(id)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
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
}
@end
