//
//  CTAddPrizeViewController.m
//  Community
//
//  Created by My Mac on 01/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTAddPrizeViewController.h"
#import "ImageNamesFile.h"
#import "CTAddPrizeTableViewCell.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.45;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 180;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTAddPrizeViewController ()

@end

@implementation CTAddPrizeViewController
@synthesize UUIDpoll,tbl_prize;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QTY = [[NSMutableArray alloc]init];
    PrizeName = [[NSMutableArray alloc]init];
    Image = [[NSMutableArray alloc]init];
    self.tbl_prize.delegate = self;
    self.tbl_prize.dataSource = self;
    self.navigationItem.leftBarButtonItem = [self backButton];
    txtQty.layer.borderColor = [[UIColor blackColor] CGColor];
    txtQty.layer.borderWidth = 2.0f;
    
    txtPrizename.layer.borderColor = [[UIColor blackColor] CGColor];
    txtPrizename.layer.borderWidth = 2.0f;
    
    [@[btnadd,btnaddImage
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[txtPrizename,txtQty
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Prize";
    NSLog(@"PollPrizeStore = %@",[CTCommonMethods sharedInstance].PollPrizeStore);
    
    if ([CTCommonMethods sharedInstance].PollPrizeStore)
    {
        self.listofPrize = [CTCommonMethods sharedInstance].PollPrizeStore;
        [self reloadPollValues];
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"CTAddPrizeTableViewCell" bundle:nil];
    [tbl_prize registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [tbl_prize addGestureRecognizer:longPress];
    
}
- (void)reloadPollValues{
    //reloadCount = 0;
    arrPrizes = [[NSMutableArray alloc] init];
    [arrPrizes removeAllObjects];
    id prizes = self.listofPrize;
    if (prizes && [prizes count] > 0) {
        NSArray *sortedAnswers = [self.listofPrize sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 valueForKeyPath:@"contestPrizeIndex"] compare:[obj2 valueForKeyPath:@"contestPrizeIndex"]];
        }];
        [arrPrizes addObjectsFromArray:sortedAnswers];
    }
    //    NSLog(@"arrPrizes = %lu",(unsigned long)arrPrizes.count);
    [tbl_prize reloadData];
    [tbl_prize reloadInputViews];
}

#pragma mark - ImagePressedButton
- (IBAction)ImagePressedButton:(id)sender {
    
    
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
    img_addimage.image = image;
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
    img_addimage.image=img;
}


#pragma mark - AddPressedButton
- (IBAction)AddPressedButton:(id)sender {
    
    //    [QTY addObject:txtQty.text];
    //    [PrizeName addObject:txtPrizename.text];
    //    [Image addObject:img_addimage.image];
    [self createPollAddPrize];
    //[tbl_prize reloadData];
}

-(void)createPollAddPrize
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    NSData *imageToUpload = UIImageJPEGRepresentation(img_addimage.image, 1.0);//(uploadedImgView.image);
    int quantity = [txtQty.text intValue];
    if (quantity <= 0)
    {
        quantity = 1;
    }
    NSString *msgTxt=[NSString stringWithFormat:@"{\"serviceAccommodatorId\":\"%@\",\"serviceLocationId\":\"%@\",\"contestUUID\":\"%@\",\"contestPrizeName\":\"%@\",\"quantity\":\"%d\",\"displayText\":\"%@\",\"hiddenText\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,self.UUIDpoll,txtPrizename.text,quantity,txtPrizename.text,@"Employees not eligible"];
    
    NSLog(@"msgTxt = %@",msgTxt);
    NSString *path=[NSString stringWithFormat:@"%@?UID=%@",CT_CreatePollPrizeAPI_URL,[CTCommonMethods UID]];
    
    
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
         
         //StoreCreatePoll = jsons;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"StoreCreatePoll: %@",jsons);
         if (jsons)
         {
             [self apiRetrievePollPortal];
             txtQty.text = @"";
             txtPrizename.text = @"";
             img_addimage.image = nil;
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
        if (JSON)
        {
            self.listofPrize = [JSON valueForKeyPath:@"contest.prizes"];
            [CTCommonMethods sharedInstance].PollPrizeStore = [JSON valueForKeyPath:@"contest.prizes"];
            [self reloadPollValues];
            txtQty.text = @"";
            txtPrizename.text = @"";
            pollcontestview =[[CTPollContestViewController alloc] init];
            pollcontestview.StoreCreatePollPrizes = self.listofPrize;
            [CTCommonMethods sharedInstance].PollPrizeStore =  self.listofPrize;
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

-(void)removePollPrize : (NSInteger)tag
{
    id contestPrizeId     = @(tag);
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    NSString *promotionRequest = [NSString stringWithFormat:CT_RemovePollPrize_URL,[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,[CTCommonMethods UID],UUIDpoll,contestPrizeId];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //    if(range.length == 1)
    //        return YES;
    
    if(range.length == 1)
        return YES;
    
    if(textField == txtQty && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
        return NO;
    
    
    return YES;
}

#pragma mark - UITableView data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"arrPrizes = %d",arrPrizes.count);
    return [arrPrizes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CTAddPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[CTAddPrizeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Update cell content from data source.
    // NSLog(@"data is name = %@",[@"  " stringByAppendingString:[[CTCommonMethods sharedInstance] validateString:[[arrPrizes valueForKeyPath:@"contestPrizeName"] objectAtIndex:indexPath.row]]]);
    
    cell.txt_prizename.text = [@"  " stringByAppendingString:[[CTCommonMethods sharedInstance] validateString:[[arrPrizes valueForKeyPath:@"contestPrizeName"] objectAtIndex:indexPath.row]]];;
    
    cell.txt_prizename.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    cell.txt_prizename.layer.borderColor = [UIColor blueColor].CGColor;
    cell.txt_prizename.layer.borderWidth = 2.0;
    
    cell.lbl_QTY.text = [NSString stringWithFormat:@"%@",[[arrPrizes valueForKeyPath:@"quantity"] objectAtIndex:indexPath.row]];
    cell.lbl_QTY.layer.borderColor = [UIColor blueColor].CGColor;
    cell.lbl_QTY.layer.borderWidth = 2.0;
    
    NSString *strURL = [[CTCommonMethods sharedInstance] validateString:[[arrPrizes valueForKeyPath:@"imageUrl"] objectAtIndex:indexPath.row]];
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
    //cell.img_addpic.image = NSString *strURL = [[CommonMethods sharedInstance] validateString:[[arrPrizes valueForKeyPath:@"imageUrl"] objectAtIndex:index]];;
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
        [self removePollPrize:[[arrPrizes valueForKeyPath:@"contestPrizeId"][indexPath.row]integerValue]];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception in handle pan gesture %@",exception);
        printf("exception in handle pan gesture %s",[[exception description] UTF8String]);
    }
    [arrPrizes  removeObjectAtIndex:indexPath.row];
    [CTCommonMethods sharedInstance].PollPrizeStore = arrPrizes;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:tbl_prize];
    NSIndexPath *indexPath = [tbl_prize indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [tbl_prize cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [tbl_prize addSubview:snapshot];
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
                [arrPrizes exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [tbl_prize moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [tbl_prize cellForRowAtIndexPath:sourceIndexPath];
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
