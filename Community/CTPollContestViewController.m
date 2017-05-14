//
//  CTPollContestViewController.m
//  Community
//
//  Created by My Mac on 01/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTPollContestViewController.h"
#import "CTAddPrizeViewController.h"
#import "CTAddAnswerViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "CTImageAddViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.45;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 180;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;


@interface CTPollContestViewController ()

@end

@implementation CTPollContestViewController

-(void)apiRetrievePollPortal
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&contestUUID=%@",[CTCommonMethods getChoosenServer],CT_RetrivePollAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,self.StoreCreatePoll[@"contestUUID"]];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Event Type == %@",JSON);
        if (JSON)
        {
            self.StoreCreatePoll = [JSON valueForKey:@"contest"];
            self.StoreCreatePollPrizes = [JSON valueForKeyPath:@"contest.prizes"];
            NSLog(@"StoreCreatePollPrizes == %@",self.StoreCreatePollPrizes);
            CTAddPrizeViewController * myprize = [[CTAddPrizeViewController alloc] init];
            myprize.listofPrize = self.StoreCreatePollPrizes;
            [myprize reloadPollValues];
            //[myprize.tbl_prize reloadData];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txt_Title.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_Title.layer.borderWidth = 2.0f;
    
    _txt_Quetion.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_Quetion.layer.borderWidth = 2.0f;
    
    _txt_Start_Dt.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_Start_Dt.layer.borderWidth = 2.0f;
    
    _txt_End_Dt.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_End_Dt.layer.borderWidth = 2.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiRetrievePollPortal)       name: NotificationReloadPollContests object:nil];
    
    [@[_btn_create,_btn_cancel,_btn_Addimage,_btn_Addanswer,_btn_Addprize,_btn_activate
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[_txt_End_Dt,_txt_Quetion,_txt_Start_Dt,_txt_Title
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    [@[_lbl_End_Date,_lbl_Quetion,_lbl_Start_Date,_lbl_Title
       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
       }];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        scroll.contentSize = CGSizeMake(320, 600);
        [scroll addSubview:_lbl_Title];
        [scroll addSubview:_txt_Title];
        [scroll addSubview:_lbl_Quetion];
        [scroll addSubview:_txt_Quetion];
        [scroll addSubview:_lbl_Start_Date];
        [scroll addSubview:_txt_Start_Dt];
        [scroll addSubview:_lbl_End_Date];
        [scroll addSubview:_txt_End_Dt];
        [scroll addSubview:_btn_Addimage];
        [scroll addSubview:_img];
        [scroll addSubview:_btn_Addanswer];
        [scroll addSubview:_btn_Addprize];
        [scroll addSubview:_btn_create];
        [scroll addSubview:_btn_cancel];
        
        scroll.autoresizesSubviews = NO;
        scroll.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [scroll addGestureRecognizer:letterTapRecognizer];
        
        [self.view addSubview:scroll];
    }
    
}


#pragma mark - AnswerButtonPressed
- (IBAction)bt_AnswerPressed:(id)sender {
    
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    [_txt_Title resignFirstResponder];
    [_txt_Quetion resignFirstResponder];
    
    CTAddAnswerViewController *answer = [[CTAddAnswerViewController alloc]initWithNibName:@"CTAddAnswerViewController" bundle:nil];
    answer.UUIDpoll = self.StoreCreatePoll[@"contestUUID"];
    [self.navigationController pushViewController:answer animated:YES];
}


#pragma mark - PrizeButtonPressed
- (IBAction)bt_PrizePressed:(id)sender {
    
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    [_txt_Title resignFirstResponder];
    [_txt_Quetion resignFirstResponder];
    
    CTAddPrizeViewController * prizeView = [[CTAddPrizeViewController alloc] initWithNibName:@"CTAddPrizeViewController" bundle:nil];
    prizeView.UUIDpoll = self.StoreCreatePoll[@"contestUUID"];
    prizeView.listofPrize = [CTCommonMethods sharedInstance].PollPrizeStore;
    [self.navigationController pushViewController:prizeView animated:YES];
}


#pragma mark - ImageButtonPressed
- (IBAction)bt_ImagePressed:(id)sender {
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    [_txt_Title resignFirstResponder];
    [_txt_Quetion resignFirstResponder];
    
    
    
    CTImageAddViewController *viewController = [[CTImageAddViewController alloc] initWithNibName:@"CTImageAddViewController" bundle:nil];
    viewController.delegate = self;
    viewController.titleForView =  @"Select Image";
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
    //                                                             delegate: self
    //                                                    cancelButtonTitle: @"Cancel"
    //                                               destructiveButtonTitle: nil
    //                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    //    [actionSheet showInView:self.view];
}

#pragma mark- Delegate for select Image

- (void)setUserSelectedImage:(UIImage*)image
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Image size width = %f & height = %f",image.size.width, image.size.height );
    self.img.image = image;
}

-(void)CancelViewMethod
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

//Tack PhotoFrom Camara
- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            controller.allowsEditing = NO;
            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            controller.delegate = self;
            [self.navigationController presentViewController: controller animated: YES completion: nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//Choose PhotoFrom Existing Image
-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        // [self.navigationController presentViewController: controller animated: YES completion: nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:controller animated:YES completion:nil];
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img=info[UIImagePickerControllerOriginalImage];
    self.img.image=img;
}


#pragma mark - CreateButtonPressed
- (IBAction)bt_CreatePressed:(id)sender {
    NSString * activationDate, * expirationDate;
    activationDate        = self.txt_Start_Dt.text;
    expirationDate        = self.txt_End_Dt.text;
    if([activationDate isEqualToString:@""] && [expirationDate isEqualToString:@""]){
        ShowAlertWithTitle(StringAlertMessageBothDateReq);
    }
    else if(!activationDate || [activationDate isEqualToString:@""]){
        ShowAlertWithTitle(StringAlertMessageActDateReq);
    }
    else if(!expirationDate || [expirationDate isEqualToString:@""]){
        ShowAlertWithTitle(StringAlertMessageExpDateReq);
    }
    else {
        NSDate *date1, *date2;
        date1 = [self getDateFromDateString:activationDate];
        date2 = [self getDateFromDateString:expirationDate];
        
        switch ([date1 compare:date2]) {
            case NSOrderedAscending:{
                if(![self.img image]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleNoImage message:StringAlertMsgSelectImage  delegate:self cancelButtonTitle:StringAlertButtonCancel otherButtonTitles:StringAlertButtonCreateContest, nil]
                    ;
                    alert.tag = 2;
                    [alert show];
                }
                
                else
                    [self createPollContentAPI];
            }
                
                break;
            default:{
                ShowAlertWithTitle(StringAlertContestDate);
                return;
            }
                break;
        }
    }
    
}

-(void)createPollContentAPI
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    NSData *imageToUpload = UIImageJPEGRepresentation(self.img.image, 1.0);
    
    NSString *msgTxt=[NSString stringWithFormat:@"{\"serviceAccommodatorId\":\"%@\",\"serviceLocationId\":\"%@\",\"contestName\":\"%@\",\"displayText\":\"%@\",\"activationDate\":\"%@\",\"expirationDate\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,self.txt_Title.text,self.txt_Quetion.text,self.txt_Start_Dt.text,self.txt_End_Dt.text];
    NSLog(@"msgTxt = %@",msgTxt);
    NSString *path=[NSString stringWithFormat:@"%@?UID=%@",CT_CreatePollAPI_URL,[CTCommonMethods UID]];
    
    
    NSLog(@"path = %@",path);
    
    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
    
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        // NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSData *data=[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])];
        //[formData appendPartWithFormData:data name:@"photoCandidate" contentType:@"application/json"];
        [formData appendPartWithFormData:data name:@"photoCandidate"];
        //image
        
        if(imageToUpload)
        {
            [formData appendPartWithFileData:imageToUpload name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
        //[formData appendPartWithFileData: imageToUpload name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         hud.labelText = [NSString stringWithFormat:@"%.0f%%", (percentDone * 100)];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         
         self.StoreCreatePoll = jsons;
         NSLog(@"StoreCreatePoll: %@",self.StoreCreatePoll);
         if (jsons)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePollCreated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
             [alertView show];
             self.btn_create.hidden = YES;
             self.btn_activate.hidden = NO;
             self.StoreCreatePollPrizes = [self.StoreCreatePoll valueForKeyPath:@"prizes"];
             [CTCommonMethods sharedInstance].PollPrizeStore = [self.StoreCreatePoll valueForKeyPath:@"prizes"];
             NSLog(@"StoreCreatePollPrizes: %@",self.StoreCreatePollPrizes);
             self.btn_Addanswer.enabled = YES;
             self.btn_Addanswer.alpha = 1.0f;
             self.btn_Addprize.enabled = YES;
             self.btn_Addprize.alpha = 1.0f;
             
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if([operation.response statusCode] == 403)
         {
             NSLog(@"Upload Failed");
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
             [alert show];
             
             return;
         }
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
         [alert show];
         NSLog(@"error: %@", [operation error]);
         
     }];
    
    [operation start];
    //        [operation waitUntilFinished];
    //    }
}
- (NSDate *)getDateFromDateString:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}
#pragma mark - ActiveButtonPressed
- (IBAction)bt_ActivePressed:(id)sender
{
    [self PollContestActivate];
}
-(void)PollContestActivate
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    NSString *promotionRequest = [NSString stringWithFormat:CT_ActivePollAPI_URL,[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,[CTCommonMethods UID],self.StoreCreatePoll[@"contestUUID"],@"true"];
    // NSString *url = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],promotionRequest];
    NSLog(@"promotionRequest = %@",promotionRequest);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
    //[request setHTTPBody:imageData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict=(NSDictionary *)JSON;
        // NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            if ([[dict valueForKey:@"success"] boolValue] == YES) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePromotionActivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                [alertView show];
            }
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(error) {
            if ([JSON valueForKeyPath:@"error.message"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:[JSON valueForKeyPath:@"error.message"] message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil] show];
                });
            }
        }else {
            NSLog(@"FAILED");
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
            {
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
            }
            
        }
        
    }];
    
    [operation start];
}
#pragma mark - CancelButtonPressed
- (IBAction)bt_CancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 2:{
            switch (buttonIndex) {
                case 0:{
                }
                    break;
                case 1:{
                    [self createPollContentAPI];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/////Textkeyboard UpandDown With View/////
#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor blueColor].CGColor;
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
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
    
    
    if ([textField isEqual:_txt_Start_Dt])
    {
        [self setUpTextFieldDatePicker];
    }
    else if ([textField isEqual:_txt_End_Dt])
    {
        [self setUpTextFieldDatePicker1];
    }
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
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
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_txt_Start_Dt isFirstResponder] && [touch view] != _txt_Start_Dt) {
        [_txt_Start_Dt resignFirstResponder];
        
    }
    else
    {
        [_txt_End_Dt resignFirstResponder];
        [_txt_Title resignFirstResponder];
    }
    [_txt_Quetion resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark Date/Time Picker

-(void)setUpTextFieldDatePicker
{
    datePickerActAndExp = [[UIDatePicker alloc]init];
    datePickerActAndExp.datePickerMode = UIDatePickerModeDate;
    [datePickerActAndExp setDate:[NSDate date]];
    minDate = [NSDate date];
    datePickerActAndExp.tag = 1;
    datePickerActAndExp.minimumDate=minDate;
    [datePickerActAndExp addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 410, 320, 44)] ;
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    [_txt_Start_Dt setInputAccessoryView:keyboardToolbar];
    [_txt_Start_Dt setInputView:datePickerActAndExp];
    
}


-(void)updateTextField:(id)sender
{
    
    UIDatePicker *picker = (UIDatePicker*)_txt_Start_Dt.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    _txt_Start_Dt.text = [NSString stringWithFormat:@"%@",dateString];
    
    minDate=picker.date;
    activateStr =[self getUTCFormateDate:picker.date];
    //    NSLog(@"activateStr = %@",activateStr);
    
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"PST"];
    //[dateFormatter setTimeZone:timeZone];
    //[dateFormatter setLocale:locale]; "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:'UTC'Z"];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //[dateFormatter release];
    return dateString;
}
#pragma mark Date/Time Picker

-(void)setUpTextFieldDatePicker1
{
    datePickerActAndExp = [[UIDatePicker alloc]init];
    datePickerActAndExp.datePickerMode = UIDatePickerModeDate;
    datePickerActAndExp.tag = 2;
    [datePickerActAndExp setDate:[NSDate date]];
    datePickerActAndExp.minimumDate=minDate;
    
    [datePickerActAndExp addTarget:self action:@selector(updateTextField1:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 410, 320, 44)] ;
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];               NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    [_txt_End_Dt setInputAccessoryView:keyboardToolbar];
    [_txt_End_Dt setInputView:datePickerActAndExp];
    
}


-(void)updateTextField1:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)_txt_End_Dt.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    _txt_End_Dt.text = [NSString stringWithFormat:@"%@",dateString];
    
    expireStr =[self getUTCFormateDate:picker.date];
    //    NSLog(@"expireStr = %@",expireStr);
}



-(void)resignKeyboard {
    
    //[keyboardToolbar removeFromSuperview];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [outputFormatter stringFromDate:[datePickerActAndExp date]];
    if (datePickerActAndExp.tag == 1)
    {
        _txt_Start_Dt.text = [NSString stringWithFormat:@"%@",dateStr];
        
        activateStr =[self getUTCFormateDate:datePickerActAndExp.date];
    }
    else{
        _txt_End_Dt.text = [NSString stringWithFormat:@"%@",dateStr];
        
        expireStr =[self getUTCFormateDate:datePickerActAndExp.date];
    }
    
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    [_txt_Title resignFirstResponder];
    [_txt_Quetion resignFirstResponder];
    ///do nescessary date calculation here
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
