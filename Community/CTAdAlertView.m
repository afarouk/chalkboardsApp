//
//  CTAdAlertView.m
//  Community
//
//  Created by My Mac on 23/02/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTAdAlertView.h"
#import "Constants.h"
#import "CTRootControllerDataModel.h"
#import "MBProgressHUD.h"



static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 300;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 500;

@interface CTAdAlertView ()

@end

@implementation CTAdAlertView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"UID -- > %@",[CTCommonMethods UID]);
    
    [self GetdataForDuration];
}
-(void)GetdataForDuration
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],CT_getDurationTimesForAdAlert_URL,[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON == %@",JSON);
        durationTime = [[NSMutableArray alloc] init];
        durationTime = [JSON valueForKey:@"displayText"];
        durationid = [[NSMutableArray alloc] init];
        durationid = [JSON valueForKey:@"enumText"];
        [btnduration setTitle:[durationTime objectAtIndex:0] forState:UIControlStateNormal];
        selectDuration = [durationid objectAtIndex:0];
        
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    btnduration.layer.borderColor = [[UIColor blackColor] CGColor];
    btnduration.layer.borderWidth = 2.0f;
    
    textViewObj.layer.borderColor = [[UIColor blackColor] CGColor];
    textViewObj.layer.borderWidth = 2.0f;
    
    [@[btnCancel,btnCreate
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    // Do any additional setup after loading the view from its nib.
    
    [@[textViewObj
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
}

#pragma mark - Btn Duration
- (IBAction)durationcall:(id)sender
{
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :durationTime :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

#pragma mark - Create Duration
-(IBAction)btnCreatePressed:(id)sender
{
    [textViewObj resignFirstResponder];
    
    if (textViewObj.text == nil || textViewObj.text.length == 0 || [textViewObj.text isEqual:[NSNull null]])
    {
        [[[UIAlertView alloc] initWithTitle:StringAlertTitleError message:StringAlertMsgEnterMsg delegate:nil cancelButtonTitle:StringAlertButtonDone otherButtonTitles: nil] show];
        return;
    }
    
    NSString * getselect = btnduration.titleLabel.text;
    int k = [durationTime indexOfObject:getselect];
    NSLog(@"select id = %@",durationid[k]);
    [self sendNotificationAPI];
}

-(void) sendNotificationAPI
{
    NSString *urlSuffix = [NSString stringWithFormat:CT_Send_Notification,[CTCommonMethods UID]];
    NSLog(@"urlSuffix =%@",urlSuffix);
    NSString *urlString = [NSString stringWithFormat:@"%@%@&duration=%@",[CTCommonMethods getChoosenServer],urlSuffix,selectDuration];
    NSLog(@"urlString =%@",urlString);
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"fromServiceAccommodatorId\":\"%@\",\"fromServiceLocationId\":\"%@\",\"urgent\":\"false\",\"notificationBody\":\"%@\",\"authorId\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,textViewObj.text,[CTCommonMethods UID]];
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
            textViewObj.text = @"";
            [btnduration setTitle:[durationTime objectAtIndex:0] forState:UIControlStateNormal];
            selectDuration = [durationid objectAtIndex:0];
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleAlertCreated message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - Cancle Duration
-(IBAction)btnCanclePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- DropDown Methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    selectDuration = [durationid objectAtIndex:sender.selectindex];
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.35 * textFieldRect.size.height;
    CGFloat numerator =  midline - viewRect.origin.y
    - 0.35 * viewRect.size.height;
    CGFloat denominator =
    (0.35 - MINIMUM_SCROLL_FRACTION)
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

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [textViewObj resignFirstResponder];
        
    }
}


- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    NSString *fullText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    //    NSLog(@"length = %lu",(unsigned long)newLength);
    if (newLength > 160)
    {
        
        ShowAlertWithTitleAndMessage(StringAlertTitleWarning, StringAlertMsg160CharOnly);
        [textView resignFirstResponder];
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        return NO;
    }
    else
    {
        //textViewPreview.text = fullText;
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return YES;
        }
        
    }
    return YES;
    //    if (fullText.length <= 160) {
    //        textViewPreview.text = fullText;
    //        return YES;
    //    }
    
    //    return NO;
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
