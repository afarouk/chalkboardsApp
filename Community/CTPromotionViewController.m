//
//  CTPromotionViewController.m
//  Community
//
//  Created by ADMIN on 2/25/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTPromotionViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "NSDictionary+CMPortal.h"
#import "CTPromotion.h"
#import "CTImageAddViewController.h"
#import "CTActivatePromotionView.h"
#import "ImageNamesFile.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.45;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 150;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;


@interface PromotionPicutresWithData : NSObject

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) CGPoint overlayLocation;
@property (nonatomic, strong) NSString *overlayText;
@property (nonatomic, strong) NSNumber *promoPictureId;
@property (nonatomic, strong) NSString *serviceAccommodatorId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UIImage *image;

- (void)importFromDictionary:(NSDictionary*)dictionary;

@end

@implementation PromotionPicutresWithData

- (void)importFromDictionary:(NSDictionary*)dictionary
{
    self.keyword = [dictionary objectForKeyCheckingNull:@"keyword"];
    self.overlayText = [dictionary objectForKeyCheckingNull:@"overlayText"];
    self.promoPictureId = [dictionary objectForKeyCheckingNull:@"promoPictureId"];
    self.serviceAccommodatorId = [dictionary objectForKeyCheckingNull:@"serviceAccommodatorId"];
    self.status = [dictionary objectForKeyCheckingNull:@"status"];
    self.overlayLocation = CGPointMake([[dictionary valueForKeyPath:@"overlayLocation.x"] floatValue], [[dictionary valueForKeyPath:@"overlayLocation.y"] floatValue]);
}

@end




@interface CTPromotionViewController ()

@end

@implementation CTPromotionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.currentImage = -1;
    if ([CTCommonMethods sharedInstance].PromotionEventType.count == 0)
    {
        [self PromotionTypeDataFetch];
    }
    else{
        listofpromotionName = [[CTCommonMethods sharedInstance].PromotionEventType valueForKey:@"displayText"];
        listofpromotionColor = [[CTCommonMethods sharedInstance].PromotionEventType valueForKey:@"color"];
    }
    
    
}

#pragma mark - Event Type Api
-(void)PromotionTypeDataFetch
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_PromotionTypeApi_URL];
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        NSLog(@"JSON Promotion Type == %@",JSON);
        if (JSON)
        {
            
            [CTCommonMethods sharedInstance].PromotionEventType = JSON;
            listofpromotionName = [[CTCommonMethods sharedInstance].PromotionEventType valueForKey:@"displayText"];
            listofpromotionColor = [[CTCommonMethods sharedInstance].PromotionEventType valueForKey:@"color"];
        }
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark - Retrive Image Api
-(void)RetrivePromotionPicture
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait. . .";
    
    NSString *urlString = [NSString stringWithFormat:@"%@",CT_PromotionRetrive_URL];
    NSDictionary *params=@{@"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa, @"keyword":@"", @"status":@"ALL", @"startIndex":@(0), @"count":@(10)};
    AFHTTPClient *myclient= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
    
    NSMutableURLRequest *request = [myclient requestWithMethod:@"GET" path:urlString parameters:params];
    request.timeoutInterval = 20.0;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        // NSLog(@"jsons = %@",jsons);
        if (responseObject && [responseObject isKindOfClass:[NSData class]])
        {
            for (NSInteger i = 0; i < [responseObject multipartArray].count; i = i+2) {
                PromotionPicutresWithData *promotionPictureWithData = [[PromotionPicutresWithData alloc] init];
                for (NSDictionary *dict in [[responseObject multipartArray] subarrayWithRange:NSMakeRange(i, 2)]) {
                    NSString *contentType = [dict valueForKey:@"Content-Type"];
                    
                    if ([contentType hasPrefix:@"application/json"]){
                        NSDictionary *promotionMetaDatDict = [NSJSONSerialization JSONObjectWithData:dict[@"data"] options:NSJSONReadingMutableContainers error:nil];
                        [promotionPictureWithData importFromDictionary:promotionMetaDatDict];
                    }
                    else if ([contentType hasPrefix:@"image"]) {
                        UIImage *image = [UIImage imageWithData:[dict valueForKey:@"data"]];
                        promotionPictureWithData.image = image;
                    }
                }
                [self.promotionPictureList addObject:promotionPictureWithData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self loadScroll];
        }
        // NSLog(@"promotionPictureList = %d",self.promotionPictureList.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure(request, error);
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
    }];
    [operation start];
    NSLog(@"urlString =%@",urlString);
}

- (void)loadScroll
{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    self.scrollView.backgroundColor = [UIColor redColor];
    NSInteger i=0;
    for(PromotionPicutresWithData *promo in self.promotionPictureList)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(5+i*141, 0, 141, 190)];
//        view.backgroundColor=[UIColor greenColor];
        view.tag=100+i++;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:promo.image];
        imageView.tag=666;
        imageView.frame=CGRectMake(2, 2, 127, 186);
        [imageView.layer setBorderWidth:3];
        [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect frame=[self getFrameSizeForImage:imageView.image inImageView:imageView];
        imageView.frame = CGRectMake(imageView.frame.origin.x+frame.origin.x, imageView.frame.origin.y+frame.origin.y - 30, frame.size.width, frame.size.height);
        [view addSubview:imageView];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapImage:)];
        [view addGestureRecognizer:gesture];
        
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize=CGSizeMake(10+i*141, 132);
}
- (void)actionTapImage:(UITapGestureRecognizer *)gesture
{
    
    UIView *view = [self.scrollView viewWithTag:100 + self.currentImage];
    [[view viewWithTag:666].layer setBorderColor:[UIColor clearColor].CGColor];
    
    //Now hightlight user selected photo.
    view = gesture.view;
    [[view viewWithTag:666].layer setBorderColor:[UIColor blueColor].CGColor];
    
    self.currentImage = view.tag-100;
    
}
- (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}

#pragma mark - ViewDodLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.promotionPictureList = [NSMutableArray array];
    [self RetrivePromotionPicture];
    _txt_title.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_title.layer.borderWidth = 2.0f;
    
    _txt_discription.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_discription.layer.borderWidth = 2.0f;
    
    _txt_FinePrint.layer.borderColor = [[UIColor blackColor] CGColor];
    _txt_FinePrint.layer.borderWidth = 2.0f;
    
    self.scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollView.layer.borderWidth = 2.0f;
    
    _txt_discription.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _txt_title.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    
    [@[_btn_addnew,_btn_create,_btn_cancel
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[_txt_discription,_txt_title
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        //_Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        _Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 736);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        //_Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        _Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 667);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        //_Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 800);
        _Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 600);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        //_Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 700);
        _Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 480);
        
    }
    
    //    [@[_lbl_Discription,_lbl_select_picture,_lbl_Title,_lbl_type
    //       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
    //           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
    //       }];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        scroll.contentSize = CGSizeMake(320, 600);
        [scroll addSubview:_lbl_type];
        [scroll addSubview:_btn_items];
        [scroll addSubview:_lbl_Title];
        [scroll addSubview:_txt_title];
        [scroll addSubview:_lbl_select_picture];
        [scroll addSubview:_img_new];
        [scroll addSubview:_lbl_Discription];
        [scroll addSubview:_txt_discription];
        [scroll addSubview:_btn_addnew];
        [scroll addSubview:_lbl_Discription];
        [scroll addSubview:_txt_discription];
        [scroll addSubview:_btn_create];
        [scroll addSubview:_btn_cancel];
        
        scroll.autoresizesSubviews = NO;
        scroll.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
        [scroll addGestureRecognizer:letterTapRecognizer];
        
        [self.view addSubview:scroll];
    }
}

#pragma mark - btnType DropDown
- (IBAction)btnTypePressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 240;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listofpromotionName :nil :@"down"];
        dropDown.delegate = self;
        dropDown.colorarray = listofpromotionColor;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
        
    }
}

#pragma mark -- DropDown Methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}


#pragma mark - btnCreate
- (IBAction)btnCreatePressed:(id)sender {
    
    if ([_btn_items.titleLabel.text isEqualToString:@"Select Type"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Please select Type" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
        
    }
    if (self.txt_title.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter Title" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    if (self.txt_discription.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Please enter Description" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        return;
    }
    
    if (Flag == NO)
    {
        for (int k = 0; k < listofpromotionName.count; k++)
        {
            if ([listofpromotionName[k] isEqualToString:self.btn_items.titleLabel.text])
            {
                selectnumber = k;
                break;
            }
        }
        [self CreatePromotionAPI];
    }
    else
    {
        [self PromotionActive];
    }
    
    /*
     if (!_txt_discription.text.length || !_txt_title.text.length) {
     [[[UIAlertView alloc] initWithTitle:@"Please Fillups" message:@"Please Fillups Required Fields" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
     }
     else if ([_btn_items.titleLabel.text isEqualToString:@"Select Type"])
     {
     [[[UIAlertView alloc] initWithTitle:@"Select Type" message:@"Please Select Type" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
     
     }
     else
     {
     
     }
     */
    
}

-(void)CreatePromotionAPI
{
    PromotionPicutresWithData *selectedPictureWithData = nil;
    
    if(self.currentImage!=-1)
    {
        // NSLog(@"image new = %d",self.currentImage);
        selectedPictureWithData=self.promotionPictureList[self.currentImage];
    }
    NSData *imageToUpload = UIImageJPEGRepresentation(selectedPictureWithData.image, 1.0);
    NSString *msgTxt;
    NSString * path;
    NSData * jsonData1;
    if (!selectedPictureWithData.promoPictureId)
    {
        NSDictionary *params=@{@"displayLocation":@{@"x":@(0),
                                                    @"y":@(0)},
                               @"displayText":self.txt_discription.text,
                               @"promotionSASLName":self.txt_title.text,
                               //@"finePrint":self.txt_FinePrint.text,
                               @"promotionType":[[CTCommonMethods sharedInstance].PromotionEventType[selectnumber] valueForKey:@"enumText"],
                               @"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa,
                               @"serviceLocationId":[CTCommonMethods sharedInstance].selectSl};
        NSLog(@"params = %@",params);
        NSError * err;
        jsonData1 = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        
        NSLog(@"msgTxt = %@",msgTxt);
        
        path=[NSString stringWithFormat:@"promotions/createWNewPictureNewMetaData?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@", [CTCommonMethods UID], [CTCommonMethods sharedInstance].selectSa, [CTCommonMethods sharedInstance].selectSl];
        
        if (imageToUpload)
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDModeIndeterminate;
            
            NSLog(@"path = %@",path);
            
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[CTCommonMethods getChoosenServer]]]];
            
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                
                
                NSMutableData *concatenatedData = [NSMutableData data];
                //[concatenatedData appendData:data];
                [concatenatedData appendData:jsonData1];
                [formData appendPartWithFormData:concatenatedData name:@"photoCandidate"];
                
                //image
                
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
                 NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 
                 //self.StoreCreatePoll = jsons;
                 // NSLog(@"StoreCreatePoll: %@",jsons);
                 if (jsons)
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePromotionCreated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                     [alertView show];
                     Flag = YES;
                     //[self.btn_create setTitle:@"Activate" forState:UIControlStateNormal];
                     
                     //if ([CTCommonMethods sharedInstance].OWNERFLAG == YES) {
                     if ([CTCommonMethods sharedInstance].TILEPROMOTION == YES)
                     {
                         [self dismissViewControllerAnimated:YES completion:nil];
                         [CTCommonMethods sharedInstance].TILEPROMOTION = NO;
                     }
                     else{
                         CTActivatePromotionView *viewController = [[CTActivatePromotionView alloc] initWithNibName:@"CTActivatePromotionView" bundle:nil];
                         viewController.navigationItem.title = @"Activate Promotion";
                         viewController.navigationItem.leftBarButtonItem = [self backButton];
                         [self.navigationController pushViewController:viewController animated:YES];
                     }
                     
                     //}
                     //else{
                     // [self dismissViewControllerAnimated:YES completion:nil];
                     //}
                     
                     getPromoCode = [jsons valueForKey:@"promoUUID"];
                     [self.btn_addnew setEnabled:NO];
                     self.btn_addnew.alpha = 0.8;
                     [self.btn_items setEnabled:NO];
                     self.btn_items.alpha = 0.8;
                     [self.txt_title setEnabled:NO];
                     self.txt_title.alpha = 0.8;
                     [self.txt_discription setEditable:NO];
                     self.txt_discription.alpha = 0.8;
                     
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
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Select Picture" message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        CTPromotion *promotion = [[CTPromotion alloc] init];
        promotion.promoPictureId=selectedPictureWithData.promoPictureId;
        promotion.promoPictureServiceAccommodatorId=selectedPictureWithData.serviceAccommodatorId;
        NSDictionary *params=@{@"displayLocation":@{@"x":@(0),
                                                    @"y":@(0)},
                               @"displayText":self.txt_discription.text,
                               @"promotionSASLName":self.txt_title.text,
                               //@"finePrint":self.txt_FinePrint.text,
                               @"promotionType":[[CTCommonMethods sharedInstance].PromotionEventType[selectnumber] valueForKey:@"enumText"],
                               @"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa,
                               @"serviceLocationId":[CTCommonMethods sharedInstance].selectSl,
                               @"promoPictureId":promotion.promoPictureId,
                               @"promoPictureServiceAccommodatorId":promotion.promoPictureServiceAccommodatorId};
        
        
        NSLog(@"params = %@",params);
        
        NSError * err;
        jsonData1 = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        
        path=[NSString stringWithFormat:@"promotions/createWRecyledPictureNewMetaData?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@", [CTCommonMethods UID], [CTCommonMethods sharedInstance].selectSa, [CTCommonMethods sharedInstance].selectSl];
        
        if (imageToUpload)
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDModeIndeterminate;
            
            NSLog(@"path = %@",path);
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],path];
            NSLog(@"paturlStringh = %@",urlString);
            NSURL *url=[NSURL URLWithString:urlString];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:jsonData1];
            hud.mode=MBProgressHUDModeIndeterminate;
            hud.labelText=@"Please wait...";
            AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                NSDictionary *dict=(NSDictionary *)JSON;
                //                NSLog(@"dict = %@",dict);
                if (dict)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePromotionCreated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                    [alertView show];
                    Flag = YES;
                    // [self.btn_create setTitle:@"Activate" forState:UIControlStateNormal];
                    //if ([CTCommonMethods sharedInstance].OWNERFLAG == YES) {
                    if ([CTCommonMethods sharedInstance].TILEPROMOTION == YES)
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [CTCommonMethods sharedInstance].TILEPROMOTION = NO;
                    }
                    else{
                        CTActivatePromotionView *viewController = [[CTActivatePromotionView alloc] initWithNibName:@"CTActivatePromotionView" bundle:nil];
                        viewController.navigationItem.title = @"Activate Promotion";
                        viewController.navigationItem.leftBarButtonItem = [self backButton];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    //}
                    //else{
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                    //}
                    
                    
                    getPromoCode = [dict valueForKey:@"promoUUID"];
                    [self.btn_addnew setEnabled:NO];
                    self.btn_addnew.alpha = 0.8;
                    [self.btn_items setEnabled:NO];
                    self.btn_items.alpha = 0.8;
                    [self.txt_title setEnabled:NO];
                    self.txt_title.alpha = 0.8;
                    [self.txt_discription setEditable:NO];
                    self.txt_discription.alpha = 0.8;
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
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Select Picture" message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
    
    
    
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
-(void)PromotionActive
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    NSString *promotionRequest = [NSString stringWithFormat:CT_ACTIVATE_PROMOTION_URL,getPromoCode,[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,[CTCommonMethods UID]];
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
        NSLog(@"SUCEESS = %@",dict);
        if (dict)
        {
            if ([[dict valueForKey:@"success"] boolValue] == YES) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:StringAlertTitlePromotionActivated message:@"" delegate:self cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                [alertView show];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [self.btn_addnew setEnabled:YES];
                self.btn_addnew.alpha = 1.0;
                [self.btn_items setEnabled:YES];
                self.btn_items.alpha = 1.0;
                [self.txt_title setEnabled:YES];
                self.txt_title.alpha = 1.0;
                [self.txt_discription setEditable:YES];
                self.txt_discription.alpha = 1.0;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
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
#pragma mark - btnCancel
- (IBAction)btnCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - btnAddNewImage
- (IBAction)btnAddNewPressed:(id)sender {
    
    
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
    NSLog(@"Image size width = %f & height = %f",image.size.width, image.size.height );
    [self.navigationController popViewControllerAnimated:YES];
    if (image)
    {
        [self addNewImagetoCurrentList:image];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"Size of Image(bytes):%d",[imgData length]);
        
    }
    //self.img_addimage.image = image;
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
        controller.allowsEditing = YES;
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
    if (img)
    {
        [self addNewImagetoCurrentList:img];
    }
    //self.img_new.image=img;
}
- (void)addNewImagetoCurrentList:(UIImage*)newImage {
    PromotionPicutresWithData *newPictureWithData = [[PromotionPicutresWithData alloc] init];
    newPictureWithData.image = newImage;
    newPictureWithData.keyword = @"";
    newPictureWithData.status = @"PROPOSED";
    newPictureWithData.serviceAccommodatorId=[CTCommonMethods sharedInstance].selectSa;
    [self.promotionPictureList insertObject:newPictureWithData atIndex:0]; //insert at the top to make it visible at the begining.
    [self loadScroll];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    //viewFrame.origin.y += animatedDistance;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


/////Textkeyboard UpandDown With View/////
#pragma mark - TextView Delegate
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
    //viewFrame.origin.y = 0;
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
    //viewFrame.origin.y += animatedDistance;
    viewFrame.origin.y = 0;
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txt_title resignFirstResponder];
    [_txt_discription resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
