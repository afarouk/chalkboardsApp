//
//  CTEventViewController.m
//  Community
//
//  Created by ADMIN on 2/24/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTEventViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "CTActivateEventView.h"
#import "ImageNamesFile.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.45;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 180;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTEventViewController ()

@end

@implementation CTEventViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([CTCommonMethods sharedInstance].StoreEventType.count == 0)
    {
        [self EventTypeDataFetch];
    }
    else{
        listofeventName = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"displayText"];
        listofeventId = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"id"];
    }
    
}

#pragma mark - Event Type Api
-(void)EventTypeDataFetch
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],CT_EventTypeAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Event Type == %@",JSON);
        if (JSON)
        {
            [CTCommonMethods sharedInstance].StoreEventType = JSON;
 
            listofeventName = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"displayText"];
            listofeventId = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"id"];
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
    _txt_name.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_name.layer.borderWidth = 2.0f;
    
    _txt_Start_Dt.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_Start_Dt.layer.borderWidth = 2.0f;
    
    _txt_End_Dt.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_End_Dt.layer.borderWidth = 2.0f;
    
    _txt_Details.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_Details.layer.borderWidth = 2.0f;
    
    _txt_Details.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _txt_End_Dt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _txt_Start_Dt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _txt_name.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    //self.title = @"Create New Event";
    [@[_btn_create,_btn_cancel,_btn_img
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    
    [@[_txt_Details,_txt_End_Dt,_txt_name,_txt_Start_Dt
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    //    [@[LblTitle,LblMessage,LblSASLName
    //
    //       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
    //           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
    //       }];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        scroll.contentSize = CGSizeMake(320, 600);
        [scroll addSubview:_lbl_name];
        [scroll addSubview:_txt_name];
        [scroll addSubview:_lbl_Start_Date];
        [scroll addSubview:_txt_Start_Dt];
        [scroll addSubview:_lbl_End_Date];
        [scroll addSubview:_txt_End_Dt];
        [scroll addSubview:_lbl_Detail];
        [scroll addSubview:_txt_Details];
        [scroll addSubview:_lbl_Type];
        [scroll addSubview:_btn_item];
        [scroll addSubview:_btn_img];
        [scroll addSubview:_img_eventimg];
        [scroll addSubview:_btn_create];
        [scroll addSubview:_btn_cancel];
        
        scroll.autoresizesSubviews = NO;
        scroll.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [scroll addGestureRecognizer:letterTapRecognizer];
        
        [self.view addSubview:scroll];
    }
    
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    
    [_txt_name resignFirstResponder];
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    
}


#pragma mark - DropDown Button Type
- (IBAction)bt_Type:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 240;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listofeventName :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [self.btn_item setBackgroundImage:[UIImage imageNamed:@"sel_button.png"] forState:UIControlStateNormal];
    }
}

#pragma mark -- DropDown Methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    [self.btn_item setBackgroundImage:[UIImage imageNamed:@"sel_button.png"] forState:UIControlStateNormal];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

#pragma mark - AddImg
- (IBAction)bt_Add_Img:(id)sender {
    
    CTImageAddViewController *viewController = [[CTImageAddViewController alloc] initWithNibName:@"CTImageAddViewController" bundle:nil];
    viewController.delegate = self;
    viewController.titleForView =  @"Select Image";
    [self.navigationController pushViewController:viewController animated:YES];
    
    /*
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
     delegate: self
     cancelButtonTitle: @"Cancel"
     destructiveButtonTitle: nil
     otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
     [actionSheet showInView:self.view];
     */
    
}

#pragma mark- Delegate for select Image

- (void)setUserSelectedImage:(UIImage*)image
{
    [self.navigationController popViewControllerAnimated:YES];
    self.img_eventimg.image = image;
    self.img_eventimg.backgroundColor = [UIColor clearColor];
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
    
    self.img_eventimg.image=[self imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Create Button
- (IBAction)bt_Create:(id)sender {
    
    if (self.txt_name.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter Name" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    if (self.txt_Start_Dt.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter Start Date" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    if (self.txt_End_Dt.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter End Date" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    if (self.txt_Details.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter Details" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    
    if ([_btn_item.titleLabel.text isEqualToString:@"Select Event Type"]) {
        [[[UIAlertView alloc] initWithTitle:@"Please select Event Type" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    
    if (FLAG == NO)
    {
        addressDic = [NSMutableDictionary dictionary];
        for (int k = 0; k < listofeventName.count; k++)
        {
            if ([listofeventName[k] isEqualToString:self.btn_item.titleLabel.text])
            {
                // selectEventType = [CTCommonMethods sharedInstance].StoreEventType[k];
                selectnumber = k;
                break;
            }
        }
        
        [self CreateEventAPI];
    }
    else{
        [self ActivateEventAPI];
    }
    
    
    
    
}

-(void)CreateEventAPI
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    NSData *imageToUpload = UIImageJPEGRepresentation(self.img_eventimg.image, 1.0);//(uploadedImgView.image);
    NSDictionary * temp = @{@"address":[NSNull null]};
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:temp options:0 error:&err];
    NSDictionary * temp1 = @{@"latlong":[NSNull null]};
    NSData * jsonData1 = [NSJSONSerialization dataWithJSONObject:temp1 options:0 error:&err];
    
    NSString *msgTxt=[NSString stringWithFormat:@"{\"displayText\":\"%@\",\"shortDescription\":\"%@\",\"longDescription\":\"%@\",\"activation\":\"%@\",\"expiration\":\"%@\",\"startShowing\":\"%@\",\"stopShowing\":\"%@\",\"allDay\":\"false\",\"rating\":\"G\",\"type\":\"%@\",\"www\":\"%@\",\"email\":\"%@\",\"telephone\":\"%@\",\"externalId\":\"%@\"}",self.txt_name.text,@"",self.txt_Details.text,activateStr,expireStr,activateStr,expireStr,[[CTCommonMethods sharedInstance].StoreEventType[selectnumber] valueForKey:@"enumText"],@"",@"",@"",@""];
    
    NSLog(@"msgTxt = %@",msgTxt);
    
    NSString *path=[NSString stringWithFormat:@"%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",CT_CreateEventAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl];
    NSLog(@"path = %@",path);
    
    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
    
    NSLog(@"client = %@",client.baseURL);
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        
        NSData *data=[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])];
        NSMutableData *concatenatedData = [NSMutableData data];
        [concatenatedData appendData:data];
        [concatenatedData appendData:jsonData];
        [concatenatedData appendData:jsonData1];
        [formData appendPartWithFormData:concatenatedData name:@"photoCandidate" contentType:@"application/json"];
        
        
        if(imageToUpload)
        {
            [formData appendPartWithFileData:imageToUpload name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         hud.labelText = [NSString stringWithFormat:@"%.0f%%", (percentDone * 100)];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         NSLog(@"response: %@",jsons);
         //             [self.btn_create setTitle:@"Activate" forState:UIControlStateNormal];
         UIAlertView * myalert = [[UIAlertView alloc] initWithTitle:@"Successfully Event created." message:@"" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
         [myalert show];
         
         if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
         {
             CTActivateEventView *viewController = [[CTActivateEventView alloc] initWithNibName:@"CTActivateEventView" bundle:nil];
             viewController.navigationItem.title = @"Activate Event";
             viewController.navigationItem.leftBarButtonItem = [self backButton];
             [self.navigationController pushViewController:viewController animated:YES];
         }
         else
         {
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         
         
         FLAG = YES;
         
         getEventID = [jsons valueForKey:@"id"];
         
         [self.txt_name setEnabled:NO];
         self.txt_name.alpha = 0.8;
         [self.txt_Start_Dt setEnabled:NO];
         self.txt_Start_Dt.alpha = 0.8;
         [self.txt_End_Dt setEnabled:NO];
         self.txt_End_Dt.alpha = 0.8;
         [self.txt_Details setEditable:NO];
         self.txt_Details.alpha = 0.8;
         [self.btn_img setEnabled:NO];
         self.btn_img.alpha = 0.8;
         [self.btn_item setEnabled:NO];
         self.btn_item.alpha = 0.8;
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if([operation.response statusCode] == 403)
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
             [alert show];
             
             return;
         }
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleRequestFailed message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
         [alert show];
         
     }];
    
    [operation start];
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

-(void)ActivateEventAPI
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    
    NSString *promotionRequest = [NSString stringWithFormat:@"%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&eventId=%@",CT_ActivateEventAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,getEventID];
    
    
    NSLog(@"promotionRequest = %@",promotionRequest);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"PUT" path:promotionRequest parameters:nil];
    //[request setHTTPBody:imageData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict=(NSDictionary *)JSON;
        NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitleEventActivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alertView show];
            [self.txt_name setEnabled:YES];
            self.txt_name.alpha = 1.0;
            [self.txt_Start_Dt setEnabled:YES];
            self.txt_Start_Dt.alpha = 1.0;
            [self.txt_End_Dt setEnabled:YES];
            self.txt_End_Dt.alpha = 1.0;
            [self.txt_Details setEditable:YES];
            self.txt_Details.alpha = 1.0;
            [self.btn_img setEnabled:YES];
            self.btn_img.alpha = 1.0;
            [self.btn_item setEnabled:YES];
            self.btn_item.alpha = 1.0;
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
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
        
    }];
    
    [operation start];
}
#pragma mark - Cancel Button
- (IBAction)bt_Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
        animatedDistance = floor(220 * heightFraction);
        
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
        return YES;
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
        [_txt_name resignFirstResponder];
    }
    [_txt_Details resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark Date/Time Picker

-(void)setUpTextFieldDatePicker
{
    datePickerActAndExp = [[UIDatePicker alloc]init];
    datePickerActAndExp.datePickerMode = UIDatePickerModeDateAndTime;
    datePickerActAndExp.tag = 1;
    [datePickerActAndExp setDate:[NSDate date]];
    minDate = [NSDate date];
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
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; //24hr time format
    
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
    datePickerActAndExp.datePickerMode = UIDatePickerModeDateAndTime;
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
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    _txt_End_Dt.text = [NSString stringWithFormat:@"%@",dateString];
    
    expireStr =[self getUTCFormateDate:picker.date];
    //    NSLog(@"expireStr = %@",expireStr);
}



-(void)resignKeyboard {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
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
    NSLog(@"datePicker = %@",dateStr);
    //[keyboardToolbar removeFromSuperview];
    
    [_txt_Start_Dt resignFirstResponder];
    [_txt_End_Dt resignFirstResponder];
    [_txt_name resignFirstResponder];
    
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
