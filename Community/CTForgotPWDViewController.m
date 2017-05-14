//
//  CTForgotPWDViewController.m
//  Community
//
//  Created by ADMIN on 4/23/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTForgotPWDViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTForgotPWDViewController ()

@end

@implementation CTForgotPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Scroll_Vw.layer.borderWidth = 2;
    //Scroll_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    
    //Btn_Cancel.layer.borderColor = [UIColor blackColor].CGColor;
    //Btn_Cancel.layer.borderWidth = 2;
    //Btn_Cancel.layer.cornerRadius = 5;
    
    //Btn_Create.layer.borderColor = [UIColor blackColor].CGColor;
    //Btn_Create.layer.borderWidth = 2;
    //Btn_Create.layer.cornerRadius = 5;
    
    txt_EmailAdd.layer.borderColor = [UIColor blackColor].CGColor;
    txt_EmailAdd.layer.borderWidth = 2;
    
    txt_EmailAdd.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [@[txt_EmailAdd
       
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
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;//authentication/sendEmailForResetPassword?usernameOrEmail=member0
    
    NSString *url=[NSString stringWithFormat:@"%@authentication/sendEmailForResetPassword?usernameOrEmail=%@",[CTCommonMethods getChoosenServer],txt_EmailAdd.text];
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_PUT contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (JSON) {
                @try {
                    //                    NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                    if ([JSON valueForKeyPath:@"explanation"]) {
                        [CTCommonMethods showErrorAlertMessageWithTitle:[JSON valueForKeyPath:@"explanation"] andMessage:@""];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in okBtnTaped %@",exception);
                }
            }
            NSLog(@"okBtnTaped Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"okBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
}

- (IBAction)CancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(cancelButtonClicked:)]) {
    //        [self.mjSecondPopupDelegate cancelButtonClicked:self];
    //    }
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
    [txt_EmailAdd resignFirstResponder];
}

@end
