//
//  CTInvitationBussinessView.m
//  Community
//
//  Created by ADMIN on 4/22/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTInvitationBussinessView.h"
#import "CTInviteView.h"
#import "MBProgressHUD.h"
#import "CTBussinessLogin.h"
#import "CTInvitationLoginView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTInvitationBussinessView ()

@end

@implementation CTInvitationBussinessView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.Scroll_Vw.layer.borderWidth = 2;
    //self.Scroll_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    //self.Scroll_Vw.layer.cornerRadius = 8;
    
    Invite_Vw.layer.borderWidth = 2;
    Invite_Vw.layer.borderColor = [UIColor blackColor].CGColor;
    
    //self = [[[NSBundle mainBundle]loadNibNamed:@"BussinessInviteCode" owner:self options:nil] objectAtIndex:0];
    //self.frame = [[UIScreen mainScreen] bounds];
    
    self.txt_Invitation.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_Invitation.layer.borderWidth = 2;
    
    
    
    //btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
    //btnCancel.layer.borderWidth = 2 ;
    btnCancel.layer.cornerRadius = 5;
    //btnCancel.layer.masksToBounds = YES;
    //btnSubmit.layer.borderColor = [UIColor blackColor].CGColor;
    //btnSubmit.layer.borderWidth = 2 ;
    btnSubmit.layer.cornerRadius = 5;
    //btnSubmit.layer.masksToBounds = YES;
    
    self.txt_Invitation.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    if (self) {
        // Initialization code
    }
    
    [@[btnCancel,btnSubmit
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
}

-(IBAction)cancleBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(Done2Success:)]) {
//        [self.mjSecondPopupDelegate Done2Success:self];
//    }
}

-(IBAction)submitBtnPressed:(id)sender
{
    [self loginUser];
}

-(void)loginUser{
    
    if (![_txt_Invitation.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter a valid invitation code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [_txt_Invitation becomeFirstResponder];
    }
    else
    {
        NSString *params=[NSString stringWithFormat:@"verifyInvitationCode?invitationCode=%@",self.txt_Invitation.text];
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],@"authentication/",params];
        NSLog(@"url %@",urlString);
        NSURL *url=[NSURL URLWithString:urlString];
        //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"url String %@",urlString);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"GET"];
        //[request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"SUCESS %@",(NSDictionary *)JSON);
            if (JSON)
            {
                NSString * stringmessage = [JSON valueForKey:@"explanation"];
                [[[UIAlertView alloc] initWithTitle:stringmessage message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
                
                [CTCommonMethods sharedInstance].invitationcode =_txt_Invitation.text;
                //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
                [self dismissViewControllerAnimated:YES completion:nil];
               
                [[NSNotificationCenter defaultCenter]postNotificationName:@"InvitationLogin" object:nil];
                
                
                
//                if (self.mjSecondPopupDelegate && [self.mjSecondPopupDelegate respondsToSelector:@selector(Done2Success:)]) {
//                    [self.mjSecondPopupDelegate Done2Success:self];
//                }

                
//                CTBussinessLogin *bussiness = [[CTBussinessLogin alloc]init];
//                
//                [CTCommonMethods sharedInstance].invitationcode =_txt_Invitation.text;
//                //CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
//                CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
//                [appDelegate.window.rootViewController.view addSubview:bussiness];
                
            }
            
            
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
    
    [_txt_Invitation resignFirstResponder];
}

//#pragma mark - PopUP Delegate method
//
//-(void) ResignSuccess:(id)aSecondDetailViewController
//{
//    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
//}
//
//- (void)cancelButtonClicked:(id)aSecondDetailViewController
//{
//    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
//}

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
    [_txt_Invitation resignFirstResponder];
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

@end
