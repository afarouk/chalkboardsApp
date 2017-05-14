//
//  CTSupportviewViewController.m
//  Community
//
//  Created by My Mac on 16/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTSupportviewViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTSupportviewViewController ()

@end

@implementation CTSupportviewViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    pickerArray = [[NSMutableArray alloc] init];
    
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getSupportEmailTopics];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON == %@",JSON);
        pickerArray = JSON;
        NSLog(@"getdata = %@",pickerArray);
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
    emailField.layer.borderColor = [UIColor blackColor].CGColor;
    emailField.layer.borderWidth = 2;
    
    detailTextview.layer.borderColor = [UIColor blackColor].CGColor;
    detailTextview.layer.borderWidth = 2;
    
    subjectField.layer.borderColor = [UIColor blackColor].CGColor;
    subjectField.layer.borderWidth = 2;
    
    // btnWebsite.layer.borderColor = [UIColor blackColor].CGColor;
    // btnWebsite.layer.borderWidth = 2;
    //btnWebsite.layer.cornerRadius = 5;
    //btnWebsite.layer.masksToBounds = YES;
    
    //btnSubmit.layer.borderColor = [UIColor blackColor].CGColor;
    //btnSubmit.layer.borderWidth = 2;
    // btnSubmit.layer.cornerRadius = 5;
    //btnSubmit.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    
    emailField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    subjectField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    detailTextview.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    detailTextview.layer.borderColor = [UIColor blackColor].CGColor;
    detailTextview.layer.borderWidth = 2;
    //detailTextview.layer.cornerRadius = 5;
    //detailTextview.clipsToBounds = YES;
    placeholder =@"Please Enter Your Address";
    detailTextview.text = placeholder;
    detailTextview.textColor = [UIColor lightGrayColor];
    
    [@[btnWebsite
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    [@[emailField,subjectField,detailTextview
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
}
#pragma Control Methods
-(void)didTapHideBtn:(id)sender {
    [self hideMenu:YES withRootNavController:rootNavController];
}

-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)_rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = -frame.size.width;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 0;
        _rootNavController.view.frame = rootFrame;
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)submitPressed:(id)sender
{
    [detailTextview resignFirstResponder];
    if(emailField.text.length == 0 || [emailField.text isEqual:[NSNull null]])
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter email id." message:@"" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
        return;
    }
    if(subjectField.text.length == 0 || [subjectField.text isEqual:[NSNull null]])
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter subject." message:@"" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@UID=%@",[CTCommonMethods getChoosenServer],CT_sendCustomerSupportEmail,@"user1.6823441967353211558"];
    NSLog(@"URL %@",urlString);
    NSLog(@"URL %@",[CTCommonMethods UID]);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"replyToEmail\":\"%@\",\"subject\":\"%@\",\"description\":\"%@\"}",emailField.text,subjectField.text,detailTextview.text];
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
        if([[dict objectForKey:@"explanation"] isEqualToString:@"Email sent"]){
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Thanks for sent email."];
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
-(IBAction)websitePressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://chalkboards.today"]];
}
-(void)addPickerView{
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    subjectField.inputView = myPickerView;
    subjectField.inputAccessoryView = toolBar;
    
}
-(void)done:(id)sender
{
    //[subjectField resignFirstResponder];
    [self.view endEditing:YES];
    
}

-(void)done1:(id)sender
{
    [detailTextview resignFirstResponder];
}

#pragma mark - Text field delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor= [UIColor blueColor].CGColor;
    if ([subjectField isEqual:textField]) {
        [self addPickerView];
    }
    //    else
    //    {
    //        CGRect textFieldRect =
    //        [self.view convertRect:textField.bounds fromView:textField];
    //        CGRect viewRect =
    //        [self.view convertRect:self.view.bounds fromView:self.view];
    //
    //        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    //        CGFloat numerator =
    //        midline - viewRect.origin.y
    //        - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    //        CGFloat denominator =
    //        (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    //        * viewRect.size.height;
    //        CGFloat heightFraction = numerator / denominator;
    //        if (heightFraction < 0.0)
    //        {
    //            heightFraction = 0.0;
    //        }
    //        else if (heightFraction > 1.0)
    //        {
    //            heightFraction = 1.0;
    //        }
    //        UIInterfaceOrientation orientation =
    //        [[UIApplication sharedApplication] statusBarOrientation];
    //        if (orientation == UIInterfaceOrientationPortrait ||
    //            orientation == UIInterfaceOrientationPortraitUpsideDown)
    //        {
    //            animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    //
    //        }
    //        else
    //        {
    //            // NSLog(@"animatedDistance1=%f",animatedDistance);
    //            animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    //        }
    //        // NSLog(@"animatedDistance2=%f",animatedDistance);
    //        CGRect viewFrame = self.view.frame;
    //        viewFrame.origin.y -= animatedDistance;
    //        [UIView beginAnimations:nil context:NULL];
    //        [UIView setAnimationBeginsFromCurrentState:YES];
    //        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    //        [self.view setFrame:viewFrame];
    //        [UIView commitAnimations];
    //    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    
    CGRect viewFrame = self.view.frame;
    //viewFrame.origin.y += animatedDistance;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [subjectField setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor blueColor].CGColor;
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.35 * textFieldRect.size.height;
    CGFloat numerator =  midline - viewRect.origin.y
    - 0.35 * viewRect.size.height;
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
    
    if ([detailTextview.text isEqualToString: placeholder])
    {
        //NSLog(@"yooy");
        detailTextview.text = @"";
        detailTextview.textColor = [UIColor blackColor];
    }
}



-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    CGRect viewFrame = self.view.frame;
    //viewFrame.origin.y += animatedDistance;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    if ([detailTextview.text isEqualToString:@""])
    {
        detailTextview.text = placeholder;
        detailTextview.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    UITouch *touch = [[event allTouches] anyObject];
    //    if ([detailTextview isFirstResponder] && [touch view] != detailTextview) {
    //        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //        [detailTextview resignFirstResponder];
    //    }
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
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
