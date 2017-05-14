//
//  CTAddAnswerViewController.m
//  Community
//
//  Created by My Mac on 02/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTAddAnswerViewController.h"
#import "ImageNamesFile.h"
#import "CTAddAnswerTableViewCell.h"
#import "CTImageAddViewController.h"

@interface CTAddAnswerViewController ()

@end

@implementation CTAddAnswerViewController

#pragma mark - Back Button
-(void)didTapBackButtonOnFavorites:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Answer";
    
    Answer = [[NSMutableArray alloc]init];
    Image = [[NSMutableArray alloc]init];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    self.txt_answer.layer.borderColor = [[UIColor blackColor] CGColor];
    self.txt_answer.layer.borderWidth = 2.0f;
    
    [@[self.btn_add,self.btn_addimage
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[self.txt_answer
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    // Do any additional setup after loading the view from its nib.
    if ([CTCommonMethods sharedInstance].PollAnswerStore)
    {
        self.listofAnswer = [CTCommonMethods sharedInstance].PollAnswerStore;
        [self reloadPollValues];
    }
    UINib *cellNib = [UINib nibWithNibName:@"CTAddAnswerTableViewCell" bundle:nil];
    [self.tbl_answer registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tbl_answer addGestureRecognizer:longPress];
    
}

- (void)reloadPollValues{
    arrQuestionAnswers = [[NSMutableArray alloc] init];
    [arrQuestionAnswers removeAllObjects];
    NSArray *sortedAnswers = [self.listofAnswer sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 valueForKeyPath:@"choiceIndex"] compare:[obj2 valueForKeyPath:@"choiceIndex"]];
        //        return NSOrderedAscending;
    }];
    [arrQuestionAnswers addObjectsFromArray:sortedAnswers];
    //NSLog(@"arrPrizes = %@",arrQuestionAnswers);
    [self.tbl_answer reloadData];
    
    
}

- (IBAction)AddImageButtonPressed:(id)sender {
    
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
    self.img_addimage.image = image;
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
    self.img_addimage.image=img;
}

#pragma mark - Add Answer Button

- (IBAction)AddButtonPressed:(id)sender
{
    [self.txt_answer resignFirstResponder];
    if (self.txt_answer.text.length == 0)
    {
        UIAlertView * myalert = [[UIAlertView alloc] initWithTitle:@"Please Enter Answer" message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [myalert show];
        return;
    }
    [self createPollAddAnswer];
}

-(void)createPollAddAnswer
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    NSData *imageToUpload = UIImageJPEGRepresentation(self.img_addimage.image, 1.0);//(uploadedImgView.image);
    NSString *msgTxt=[NSString stringWithFormat:@"{\"serviceAccommodatorId\":\"%@\",\"serviceLocationId\":\"%@\",\"contestUUID\":\"%@\",\"displayText\":\"%@\",\"choiceName\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,self.UUIDpoll,self.txt_answer.text,self.txt_answer.text];
    
    NSLog(@"msgTxt = %@",msgTxt);
    NSString *path=[NSString stringWithFormat:@"%@?UID=%@",CT_CreatePollAnswerAPI_URL,[CTCommonMethods UID]];
    
    NSLog(@"path = %@",path);
    
    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
    
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        // NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSData *data=[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])];
        //[formData appendPartWithFormData:data name:@"photoCandidate" contentType:@"application/json"];
        [formData appendPartWithFormData:data name:@"pollCandidate"];
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
         
         //StoreCreatePoll = jsons;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         //NSLog(@"Create Answer : %@",jsons);
         if (jsons)
         {
             [self apiRetrievePollPortal];
             self.txt_answer.text = @"";
             self.img_addimage.image = nil;
             
         }
         
         
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
}
-(void)apiRetrievePollPortal
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&contestUUID=%@",[CTCommonMethods getChoosenServer],CT_RetrivePollAPI_URL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,self.UUIDpoll];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Event Type == %@",JSON);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (JSON)
        {
            self.listofAnswer = [JSON valueForKeyPath:@"contest.choices"];
            [CTCommonMethods sharedInstance].PollAnswerStore = [JSON valueForKeyPath:@"contest.prizes"];
            [self reloadPollValues];
        }
        
        
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

#pragma mark - RemoveAnswer API
-(void)removePollAnswer : (NSInteger)tag
{
    id contestPrizeId     = @(tag);
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    NSString *promotionRequest = [NSString stringWithFormat:CT_RemovePollAnswer_URL,[CTCommonMethods UID],_UUIDpoll,contestPrizeId];
    // NSString *url = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],promotionRequest];
    NSLog(@"promotionRequest = %@",promotionRequest);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]
                                initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    NSMutableURLRequest *request = [httpClient
                                    requestWithMethod:@"DELETE" path:promotionRequest parameters:nil];
    //[request setHTTPBody:imageData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dict=(NSDictionary *)JSON;
        NSLog(@"Romove = %@",dict);
        if (dict)
        {
            
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

#pragma mark - UITableView data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrQuestionAnswers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CTAddAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[CTAddAnswerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Update cell content from data source.
    
    cell.txt_answer.text = [@"  " stringByAppendingString:[[CTCommonMethods sharedInstance] validateString:[[arrQuestionAnswers valueForKeyPath:@"displayText"] objectAtIndex:indexPath.row]]];
    cell.txt_answer.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    cell.txt_answer.layer.borderColor = [UIColor blueColor].CGColor;
    cell.txt_answer.layer.borderWidth = 2.0;
    
    cell.lbl_number.text = [@"  " stringByAppendingString:[[CTCommonMethods sharedInstance] validateString:[[[arrQuestionAnswers valueForKeyPath:@"choiceIndex"] objectAtIndex:indexPath.row] stringValue]]];
    cell.lbl_number.layer.borderColor = [UIColor blueColor].CGColor;
    cell.lbl_number.layer.borderWidth = 2.0;
    
    NSString *strURL = [[CTCommonMethods sharedInstance] validateString:[[arrQuestionAnswers valueForKeyPath:@"imageURL"] objectAtIndex:indexPath.row]];
    if (![strURL isEqualToString:@""]) {
        NSURL *imageURL=[NSURL URLWithString:strURL];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                //[button setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
                if(image==nil)
                {
                    [cell.img_addpic setImage:[UIImage imageNamed:@"no_image.png"]];
                }
                else
                {
                    [cell.img_addpic setImage:[UIImage imageWithData:image]];
                }
            });
        });
    }
    else{
        [cell.img_addpic setImage:[UIImage imageNamed:@"no_image.png"]];
    }
    
    cell.img_addpic.layer.borderColor = [UIColor blueColor].CGColor;
    cell.img_addpic.layer.borderWidth = 2.0;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        [self removePollAnswer:[[arrQuestionAnswers valueForKeyPath:@"choiceId"][indexPath.row]integerValue]];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception in handle pan gesture %@",exception);
        printf("exception in handle pan gesture %s",[[exception description] UTF8String]);
    }
    [arrQuestionAnswers removeObjectAtIndex:indexPath.row];
    [CTCommonMethods sharedInstance].PollAnswerStore = arrQuestionAnswers;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tbl_answer];
    NSIndexPath *indexPath = [self.tbl_answer indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tbl_answer cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tbl_answer addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [arrQuestionAnswers exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tbl_answer moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tbl_answer cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
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
