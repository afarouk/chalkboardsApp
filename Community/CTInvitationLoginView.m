//
//  CTInvitationLoginView.m
//  Community
//
//  Created by ADMIN on 4/22/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTInvitationLoginView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;


@interface CTInvitationLoginView ()

@end

@implementation CTInvitationLoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Scroll_Vw.layer.borderWidth = 2;
    //Scroll_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    //self.Scroll_Vw.layer.cornerRadius = 8;
    
    //self = [[[NSBundle mainBundle]loadNibNamed:@"BussinessInviteCode" owner:self options:nil] objectAtIndex:0];
    //self.frame = [[UIScreen mainScreen] bounds];
    
    self.txt_Email_Id.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Email_Id.layer.borderWidth = 2;
    
    self.txt_Password.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Password.layer.borderWidth = 2;
    
    self.txt_RePassword.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_RePassword.layer.borderWidth = 2;
    
    //btncancel.layer.borderColor = [UIColor blackColor].CGColor;
    //btncancel.layer.borderWidth = 2 ;
    btncancel.layer.cornerRadius = 5;
    //btncancel.layer.masksToBounds = YES;
    //btnsubmit.layer.borderColor = [UIColor blackColor].CGColor;
    //btnsubmit.layer.borderWidth = 2 ;
    btnsubmit.layer.cornerRadius = 5;
    //btnsubmit.layer.masksToBounds = YES;
    
    self.txt_Email_Id.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.txt_Password.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.txt_RePassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [@[btncancel,btnsubmit
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[_txt_Email_Id,_txt_Password,_txt_RePassword
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
}

- (IBAction)submitBtnPressed:(id)sender {
    [_txt_Email_Id becomeFirstResponder];
    [_txt_Password becomeFirstResponder];
    [_txt_RePassword becomeFirstResponder];
    [self loginUser];
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(Done2Success:)]) {
    //        [self.mjSecondPopupDelegate Done2Success:self];
    //    }
}

-(void)loginUser{
    if([self validateEmailWithString:_txt_Email_Id.text] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidMailId message:StringAlertMsgValidMailId delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(_txt_Password.text.length&&_txt_RePassword.text.length>0){
        
        if(_txt_Password.text.length>=6){
            
            if([_txt_Password.text isEqualToString:_txt_RePassword.text]){
                
                //[self registerNewUser];
            }
            else{
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password not match. Please check it"];
                return;
            }
        }
        else{
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password must be at least 6 characters long"];
            return;
        }
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please enter Password"];
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view
                                            animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    
    NSString *promotionRequest = [NSString stringWithFormat:@"%@",CT_CreateOwnerFromInvitation];
    
    NSDictionary *params = @{
                             @"email" : _txt_Email_Id.text,
                             @"invitationCode" : [CTCommonMethods sharedInstance].invitationcode,
                             @"password" : _txt_Password.text,
                             @"username" : _txt_Email_Id.text
                             
                             };
    NSError * err;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
    NSLog(@"params = %@",params);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
    
    NSLog(@"request me %@",request);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData1];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict=(NSDictionary *)JSON;
        NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            
            // Add some custom content to the alert view
            [alertView setContainerView:[self createDemoView]];
            
            // Modify the parameters
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Done", nil]];
            [alertView setDelegate:self];
            
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                [alertView close];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    /*
     MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view
     animated:YES];
     hud.mode=MBProgressHUDModeIndeterminate;
     hud.labelText=@"Please wait...";
     
     NSString *promotionRequest = [NSString stringWithFormat:@"%@?email=%@&invitationCode=%@&password=%@&username=%@",@"authentication/createOwnerFromInvitation",_txt_Email_Id.text,[CTCommonMethods sharedInstance].invitationcode,_txt_Password.text,_txt_Email_Id.text];
     //NSLog(@"invitation %@",[CTCommonMethods sharedInstance].invitationcode);
     
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
     CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
     
     // Add some custom content to the alert view
     [alertView setContainerView:[self createDemoView]];
     
     // Modify the parameters
     [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Done", nil]];
     [alertView setDelegate:self];
     
     // You may use a Block, rather than a delegate.
     [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
     NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
     [alertView close];
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
     }];
     
     [alertView setUseMotionEffects:true];
     
     // And launch the dialog
     [alertView show];
     //                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleEventActivated message:StringAlertTitleBusinessCreated delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
     //                [alert show];
     //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitleEventActivated message:@"" delegate:self cancelButtonTitle:StringAlertTitleBusinessCreated otherButtonTitles: nil];
     //                [alertView show];
     }
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
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
     
     */
}

#pragma mark - Email Validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 135)];
    UILabel* mylabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 290, 44)];
    mylabel1.text =StringAlertTitleBusiness;
    mylabel1.font = [UIFont boldSystemFontOfSize:18.0];
    mylabel1.textAlignment = NSTextAlignmentCenter;
    UILabel* mylabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 44, 240, 90)];
    mylabel.text = [NSString stringWithFormat: @" %C Promotions/Deals \n %C Events \n %C Breaking News  ", (unichar) 0x2022, (unichar) 0x2022, (unichar) 0x2022];
    mylabel.numberOfLines = 3;
    
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    //    [imageView setImage:[UIImage imageNamed:@"demo"]];
    [demoView addSubview:mylabel1];
    [demoView addSubview:mylabel];
    
    return demoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor blueColor] CGColor];
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
    textField.layer.borderColor = [[UIColor blackColor] CGColor];
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
    [_txt_Email_Id resignFirstResponder];
    [_txt_Password resignFirstResponder];
    [_txt_RePassword resignFirstResponder];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
