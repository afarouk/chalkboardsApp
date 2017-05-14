//
//  CTWebviewDetailsViewController.m
//  Community
//
//  Created by Ihtesham Khan on 06/05/2015.
//  Copyright (c) 2015 Community. All rights reserved.

//

#import "CTWebviewDetailsViewController.h"
#import "MBProgressHUD.h"
#import "ImageNamesFile.h"
#import "UIViewController+MJPopupViewController.h"
#import "CTAppDelegate.h"
#import "CTRootControllerDataModel.h"
#import "CTWebServicesMethods.h"
#import "CTLoginPopup.h"
#import "CTDriveMapViewController.h"
#import "CTParentViewController.h"
#import "CTMoreInfoWebViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "CTAppDelegate.h"
@interface CTWebviewDetailsViewController (){
    id parametersSentWithURL;
}
@end

@implementation CTWebviewDetailsViewController
@synthesize isFromRootView, strLoadUrl, isFavourite, animationType, webViewDetail;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void) _showBackLink {
    if (nil == self.backLinkView) {
        // Set up the view
        UIView *backLinkView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 30, 320, 40)];
        backLinkView.backgroundColor = [UIColor darkGrayColor];
        UILabel *backLinkLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(2, 2, 316, 36)];
        backLinkLabel.textColor = [UIColor whiteColor];
        backLinkLabel.textAlignment = NSTextAlignmentCenter;
        backLinkLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [backLinkView addSubview:backLinkLabel];
//        self.backLinkLabel = backLinkLabel;
        [self.view addSubview:backLinkView];
        self.backLinkView = backLinkView;
    }
    // Show the view
    self.backLinkView.hidden = NO;
    // Set up the back link label display
//    self.backLinkLabel.text = [NSString
//                               stringWithFormat:@"Touch to return to %@", self.backLinkInfo[@"app_name"]];
    // Set up so the view can be clicked
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_returnToLaunchingApp:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.backLinkView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}
- (void)makeRequestToShareLink {
    
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
}

-(void)backBtnTaped:(id)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    if (animationType > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSubViewWithAnimation)]) {
            [self.delegate dismissSubViewWithAnimation];
        }
    }
    else if (isFromRootView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSubViewWithAnimation)]) {
            [self.delegate dismissSubViewWithAnimation];
        }
        else {
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
        }
    }
    else {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    }
}

- (void)btnFavouriteTapped:(id)sender{
    NSLog(@"it's index %d",self.indexValue);
    
    if (isFavourite) {
        return;
    }
    if([CTCommonMethods isUIDStoredInDevice]){
        //MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:webViewDetail animated:YES];
        //hud.mode=MBProgressHUDModeIndeterminate;
        
        NSDictionary *restaurantDetails = [[CTRootControllerDataModel sharedInstance]selectedRestaurant];
        //NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
        //NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
        NSString *sa=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
        //NSLog(@"it's sa %@",[CTCommonMethods sharedInstance].serviceAccommodatorId);
        NSString *sl=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue]];
       // NSLog(@"it's indexvalue %d",self.indexValue);
        //NSLog(@"it's sl %@",[CTCommonMethods sharedInstance].serviceLocationId);
        NSString *url=[NSString stringWithFormat:@"%@usersasl/addSASLToFavorites?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID],sa,sl];
        NSLog(@"it's url %@",url);
        __block id btnFav = sender;
        [btnFav setUserInteractionEnabled:NO];
        
        [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_POST contentType:@"application/json" success:^(id JSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:webViewDetail animated:YES];
                //[btnFav setUserInteractionEnabled:YES];
                //isFavourite = YES;
                //[self addToolBarItems];
                if (JSON && [JSON count] > 1 && [JSON valueForKeyPath:@"messageBody"]) {
                    @try {
                        NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                        [CTCommonMethods showErrorAlertMessageWithTitle:strMessage andMessage:@""];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"exception in notifyPollingContestWinner %@",exception);
                    }
                }
                NSLog(@"notifyPollingContestWinner Response JSON = %@",JSON);
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:webViewDetail animated:YES];
                [btnFav setUserInteractionEnabled:YES];
                NSLog(@"notifyPollingContestWinner Error %@",error);
                if ([error.localizedDescription isEqualToString:@"Business is already in favorite list"]) {
                    //[btnFav setUserInteractionEnabled:YES];
                    isFavourite = YES;
                    [self addToolBarItems];
                    //NSLog(@"i'm calling");
                }
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
        }];
    }
    else {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAPIAgain:) name:@"SUBS" object:nil];
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
        CTLoginViewController * promotion = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        promotion.FavoriteMethod = @"FevoriteImg";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
        promotion.delegate = parentController;
        promotion.navigationItem.leftBarButtonItem = [self backButton];
        promotion.navigationItem.title = @"Chalkboard Login";
        promotion.FevIndex = self.indexValue;

        //            isCREATE = true;
        [UIView animateWithDuration:0.1 animations:^{
            
            [parentController presentViewController:nav animated:YES completion:nil];
            isFavourite = YES;
            [self addToolBarItems];

            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
    }
}

- (void) addToolBarItems{
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIButton *btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMap setFrame:CGRectMake(0, 0, toolBarDetail.frame.size.height+20, toolBarDetail.frame.size.height)];
    [btnMap addTarget:self action:@selector(backBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [btnMap setImage:[UIImage imageNamed:(isFromRootView ? CT_MapIcon : CT_TilesIcon)] forState:UIControlStateNormal];
    UIBarButtonItem *_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMap];
    
    UIButton *btnFavourite = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFavourite setFrame:CGRectMake(0, 0, toolBarDetail.frame.size.height, toolBarDetail.frame.size.height)];
    [btnFavourite addTarget:self action:@selector(btnFavouriteTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnFavourite setImage:[UIImage imageNamed:(isFavourite?Ct_Favourite : Ct_NotFavourite)] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItemFav = [[UIBarButtonItem alloc] initWithCustomView:btnFavourite];
    
    toolBarDetail.items = [NSArray arrayWithObjects:flexibleSpace,barButtonItemFav,_barButtonItem, nil];
}

- (IBAction)tapGestureHandler:(UITapGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (![toolBarDetail isHidden])
                [self hideToolBarDetail:btnHideToolBar];
        }
            break;
        default:
            break;
    }
}

- (IBAction)hideToolBarDetail:(UIButton *)sender{
    return;
    toolBarDetail.hidden = !toolBarDetail.hidden;
    if ([toolBarDetail isHidden]) {
        sender.userInteractionEnabled = NO;
        [self performSelector:@selector(hideToolBarDetail:) withObject:sender afterDelay:2.2];
    }
    else{
        sender.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LblTitle.text = _DisSASLName;
    LblMessage.text = _DisMessage;
    LblSASLName.text = _DisSASLName;
    Lbl_PromoTitle.text = _DisPromotitle;
    NSLog(@"promotitle %@",_DisPromotitle);
    
    
    if ([_Disenumtext isEqualToString:@"DISCOUNT"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"DISCOUNT.png"];
    }
    else if ([_Disenumtext isEqualToString:@"OTHER"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"OTHER.png"];
    }
    else if ([_Disenumtext isEqualToString:@"DINING_DEAL"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"DINING_DEAL.png"];
    }
    else if ([_Disenumtext isEqualToString:@"ENTERTAINMENT"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"ENTERTAINMENT.png"];
    }
    else if ([_Disenumtext isEqualToString:@"CAMPAIGN_PROMOTION"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"CAMPAIGN_PROMOTION.png"];
    }
    else if ([_Disenumtext isEqualToString:@"ACTIVITY"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"ACTIVITY.png"];
    }
    else if ([_Disenumtext isEqualToString:@"CAMPAIGN_SUBSCRIBE_FOR_NOTIFICATION"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"NOTIFICATION.png"];
    }
    else if ([_Disenumtext isEqualToString:@"HAPPYHOUR"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"HAPPYHOUR.png"];
    }
    else if ([_Disenumtext isEqualToString:@"AD_ALERT"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"AD_ALERT_Tile.png"];
    }
    else if ([_Disenumtext isEqualToString:@"EVENT"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"EVENT.png"];
    }
    else if ([_Disenumtext isEqualToString:@"PHOTO_CONTEST"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"PHOTO_CONTEST.png"];
    }
    else if ([_Disenumtext isEqualToString:@"POLL"])
    {
        Img_PromoImg.image = [UIImage imageNamed:@"POLL.png"];
    }
    
    
    Lbl_saslTitle.text = _DisTitle;
//    CGSize maximumLabelSize = CGSizeMake(3000, FLT_MAX);
//
//    CGSize expectedLabelSize = [LblMessage.text sizeWithFont:LblMessage.font constrainedToSize:maximumLabelSize lineBreakMode:LblMessage.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = LblMessage.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    LblMessage.frame = newFrame;
    
    
    //[[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    //    [@[LblTitle,LblMessage
    //
    //       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
    //           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
    //       }];
    
    //    [@[ListCity,ListNumber,ListSaslName,ListState,ListStreet,ListZipCode
    //
    //       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
    //           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
    //       }];
    
    ListSaslName.text = _ListTitle;
    //Img_Selected.image = [UIImage imageNamed:_DisImage];
    //NSLog(@"hello image %@",_DisImage);
    
    if ([_DisOnClikUrl isEqual:[NSNull null]])
    {
        _DisOnClikUrl = @"";
    }
//    if ([self.tileEnumText isEqualToString:@"CAMPAIGN_PROMOTION"])
//    {
//        Img_Selected.image = [UIImage imageNamed:@"campaign_promotion_320x240.jpg"];
//    }
//    else{
        if ([_DisImage isEqualToString:@"yourimagehere_320x240.jpg"])
        {
            Img_Selected.image = [UIImage imageNamed:_DisImage];
        }
        else
        {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            [indicator setCenter:Img_Selected.center];
            [Img_Selected addSubview:indicator];
            
            NSURL *imageURL = [NSURL URLWithString:_DisImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    [indicator removeFromSuperview];
                    Img_Selected.image = [UIImage imageWithData:imageData];
                    //[Img_Selected setContentMode:UIViewContentModeScaleAspectFill];
                });
            });
        }
   // }
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self addToolBarItems];
    self.navigationController.navigationItem.leftBarButtonItem = [self backButton];
    self.view.frame = [[UIScreen mainScreen] bounds];
    UIImage *imgNav = [UIImage imageNamed:CT_NavigationBg];
    
    switch ([CTCommonMethods getIPhoneVersion]) {
        case iPhone6:{
            imgNav = [UIImage imageNamed:@"banner_6.png"];
        }
            break;
        case iPhone6Plus:{
            imgNav = [UIImage imageNamed:@"banner_6_plus.png"];
        }
            break;
        default:
            break;
    }
    [toolBarDetail setBackgroundImage:imgNav forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self FacebookTwitter];
    
    //    float xCoordinate=8.0,yCoordinate=340.0,width=self.view.layer.frame.size.width,height=58;
    //    float ver_space=20.0;
    //
    //
    //    LblMessage.frame = CGRectMake(xCoordinate,yCoordinate,width,height);
    //    LblMessage.text = _DisMessage;
    //    //LblMessage.backgroundColor = [UIColor grayColor];
    //    [self.view addSubview:LblMessage];
    //
    //    yCoordinate=yCoordinate+height+ver_space;
    
    //    float previousLabelHeight = 0.0;
    //    CGSize theSize = [LblMessage sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(320, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap]; //can adjust width from 320 to whatever you want and system font as well
    //    float newLabelHeight = previousLabelHeight + theSize.height;
    //    LblMessage =  [[UILabel alloc] initWithFrame: CGRectMake(0,newLabelHeight,0,0)];
    //    LblMessage.text = _DisMessage;
    //    [LblMessage sizeToFit]; // resize the width and height to fit the text
    //    previousLabelHeight = newLabelHeight + 5; //adding 5 for padding
    
    
    ListState.text = [self.ListAddress valueForKey:@"state"];
    ListStreet.text = [self.ListAddress valueForKey:@"street"];
    ListCity.text = [self.ListAddress valueForKey:@"city"];
    ListNumber.text = [self.ListAddress valueForKey:@"number"];
    ListZipCode.text = [self.ListAddress valueForKey:@"zip"];
//    NSLog(@"log %@",[self.ListAddress valueForKey:@"state"]);
    
    
    NSString *myListadd = [NSString stringWithFormat:@"%@, %@ \n \n %@, %@",[self.ListAddress valueForKey:@"number"],[self.ListAddress valueForKey:@"street"],[self.ListAddress valueForKey:@"city"],[self.ListAddress valueForKey:@"state"]];
    //NSLog(@"my list add %@",myListadd);
    
    
    Lbl_ListAddress.text = myListadd;
    
    
    NSString * phonenumber = [self.listofContact valueForKey:@"telephoneMain"];
    NSString * ListPhone = [_ListCall valueForKey:@"telephoneMain"];
        
    
    NSString *MapAddress = [NSString stringWithFormat:@"%@, %@ \n%@,%@",[self.MapAddress valueForKey:@"number"],[self.MapAddress valueForKey:@"street"],[self.MapAddress valueForKey:@"city"],[self.MapAddress valueForKey:@"state"]];
    Lbl_Location.text = MapAddress;
    //Lbl_Location.text = [_MapAddress valueForKey:@"street"];
    
    Lbl_ListDrive.text = [_ListAddress valueForKey:@"street"];
    
       
    if ([phonenumber isEqual:[NSNull null]])
    {
        btnCall.enabled = NO;
        leftView.alpha = 0.5;
    }
    else
    {
        callNumber = phonenumber;
        Lbl_PhoneNumber.text = phonenumber;
    }
    
    if ([ListPhone isEqual:[NSNull null]])
    {
        Lbl_ListCall.text = @"";
        callNumbernw = @"";
    }
    else
    {
        Lbl_ListCall.text = ListPhone;
        callNumbernw = ListPhone;
    }
    
    btnShareURL.layer.cornerRadius = 5;
    btnShareURL.layer.borderColor = [UIColor whiteColor].CGColor;
    btnShareURL.layer.borderWidth = 1;
    
    
    if (self.showURL == FALSE && [_tileEnumText isEqual:@"CAMPAIGN_PROMOTION"])
    {
        btnPromotion.hidden = NO;
    }
    else
    {
        btnPromotion.hidden = YES;
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options:UIViewAnimationCurveLinear
                         animations:^
         {
             
             CGRect frame1 = LblTitle.frame;
             frame1.origin.y = 300;
             LblTitle.frame = frame1;
             
             CGRect frame2 = Lbl_saslTitle.frame;
             frame2.origin.y = 340;
             Lbl_saslTitle.frame = frame2;
             
             CGRect frame3 = LblMessage.frame;
             frame3.origin.y = 380;
             LblMessage.frame = frame3;
             
             CGRect frame4 = btnInfoURL.frame;
             frame4.origin.y = 460;
             btnInfoURL.frame = frame4;
             
             CGRect frame5 = rightView.frame;
             frame5.origin.y = 460;
             rightView.frame = frame5;
             
             CGRect frame6 = leftView.frame;
             frame6.origin.y = 600;
             leftView.frame = frame6;
             
             CGRect frame7 = btnShareURL.frame;
             frame7.origin.y = 730;
             btnShareURL.frame = frame7;
             
         }
             completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
    }
    
    
    if (btnInfoURL.hidden == YES)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveLinear
                         animations:^
         {
             
             CGRect frame = rightView.frame;
             frame.origin.y = 530;
             rightView.frame = frame;
             
             CGRect frame1 = leftView.frame;
             frame1.origin.y = 650;
             leftView.frame = frame1;
             
             CGRect frame7 = btnShareURL.frame;
             frame7.origin.y = 750;
             btnShareURL.frame = frame7;
             
//             if(btnPromotion.hidden == NO)
//             {
//                 CGRect frame = rightView.frame;
//                 frame.origin.y = 540;
//                 rightView.frame = frame;
//                 
//                 CGRect frame1 = leftView.frame;
//                 frame1.origin.y = 660;
//                 leftView.frame = frame1;
//                 
//                 CGRect frame7 = btnShareURL.frame;
//                 frame7.origin.y = 760;
//                 btnShareURL.frame = frame7;
//             }
//             else{
//                 CGRect frame = rightView.frame;
//                 frame.origin.y = 520;
//                 rightView.frame = frame;
//                 
//                 CGRect frame1 = leftView.frame;
//                 frame1.origin.y = 640;
//                 leftView.frame = frame1;
//                 
//                 CGRect frame7 = btnShareURL.frame;
//                 frame7.origin.y = 740;
//                 btnShareURL.frame = frame7;
//
//             }
             
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
    }
    
    
    
    if (self.showURL == TRUE)
    {
        //NSLog(@"show url is %hhd",self.showURL);
        //Lbl_MoreInfo.hidden = NO;
        [btnInfoURL setTitle:@"For More Info" forState:UIControlStateNormal];
        //[btnShareURL setTitle:_DisOnClikUrl forState:UIControlStateNormal];
        //        if (_DisOnClikUrl.length == 0)
        //        {
        //
        //        }
        //        else
        //        {
        //            [UIView animateWithDuration:0.5
        //                                  delay:0.1
        //                                options: UIViewAnimationCurveLinear
        //                             animations:^
        //             {
        //
        //                 CGRect frame1 = rightView.frame;
        //                 frame1.origin.y = 480;
        //                 rightView.frame = frame1;
        //
        //                 CGRect frame = leftView.frame;
        //                 frame.origin.y = 540;
        //                 leftView.frame = frame;
        //
        //
        //
        //             }
        //                             completion:^(BOOL finished)
        //             {
        //                 NSLog(@"Completed");
        //
        //             }];
        //        }
        
        //btnPromotion.hidden = NO;
        btnEmail.hidden = self.showURL;
        btnSMS.hidden = self.showURL;
        btnfacebook.hidden = self.showURL;
        btnTwitter.hidden =  self.showURL;
        btnShareURL.hidden = YES;
        btnInfoURL.hidden = !self.showURL;
        
       //NSLog(@"showurl %d",self.showURL); 
        
    }
    else
    {
        btnShareURL.hidden = NO;
        //NSLog(@"show url is123 %hhd",self.showURL);
        //[btnShareURL setTitle:[NSString stringWithFormat:@"http://Server/finePrint?uuid=%@",_DisUDID] forState:UIControlStateNormal];
        [btnShareURL setTitle:[NSString stringWithFormat:@"Terms and Conditions"] forState:UIControlStateNormal];
        //NSLog(@"hyy %@",_DisUDID);
        // Lbl_MoreInfo.hidden = NO;
        Lbl_MoreInfo.text = @"Terms and Conditions";
        
        //[btnShareURL setTitle:[NSString stringWithFormat:@"HTTP_SERVER://finePrint?uuid=%@",_DisUDID] forState:UIControlStateNormal];
        //NSLog(@"hyy %@",_DisUDID);
        
    }
    
    //    NSLog(@"%@",[toolBarDetail subviews]);
    //[self reloadWebView:NO];
    
//    if ([_tileEnumText isEqual:@"CAMPAIGN_PROMOTION"]) {
//        btnPromotion.hidden = NO;
//    }
    
}



-(void)FacebookTwitter
{
    
    FbUrl=[NSString stringWithFormat:@"%@%@?t=%@&u=%@",[CTCommonMethods getChoosenHttpServer],[CTCommonMethods sharedInstance].friendlyURL[self.indexValue],[CTCommonMethods sharedInstance].tileUUIDtype[self.indexValue],[CTCommonMethods sharedInstance].tileUUID[self.indexValue]];
    // NSLog(@"helllo tileUUIDtype %@",[CTCommonMethods sharedInstance].tileUUIDtype);
    // NSLog(@"helllo tileUUID %@",[CTCommonMethods sharedInstance].tileUUID);
    NSLog(@"fb url %@",FbUrl);
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
-(IBAction)didTapBackButtonOnFavorites:(id)sender {
    [self backBtnTaped:sender];
}

-(UIBarButtonItem *)backButtonnw{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavoritesnw:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
}
-(IBAction)didTapBackButtonOnFavoritesnw:(id)sender {
    //[self backBtnTaped:sender];
    
    NSLog(@"Call this  dfg dsf gd sdgsdfsgsdfgsdf");
    [self dismissViewControllerAnimated:YES completion:nil];
   //[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    CTAppDelegate *delegate = (CTAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.refererAppLink) {
        //        self.backLinkView = delegate.refererAppLink;
        //        [self _showBackLink];
    }
    delegate.refererAppLink = nil;
    
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 800);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        Scroll_Vw.contentSize = CGSizeMake(self.view.frame.size.width, 700);
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    self.navigationController.toolbarHidden = NO;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        
        NSLog(@"added failure requirement to: %@", otherGestureRecognizer);
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([request.URL.absoluteString rangeOfString:@"js2ios://community_login"].location != NSNotFound){
        if([CTCommonMethods isUIDStoredInDevice] == NO) {
            //             NSLog(@"Login Callback %@",[NSJSONSerialization JSONObjectWithData:[@"{\"key1\":\"value1\",\"key2\":\"value2\"}" dataUsingEncoding:NSUTF16StringEncoding] options:0 error:nil]);
            
            //            parametersSentWithURL = [[self decodeFromPercentEscapeString:request.URL.absoluteString] stringByReplacingOccurrencesOfString:@"js2ios://community_login" withString:@""];
            
            parametersSentWithURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"js2ios://community_login?" withString:@""];
            CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
            CTLoginPopup *loginPopup = [[CTLoginPopup alloc]init];
            loginPopup.callerController = self;
            [appDelegate.window.rootViewController.view addSubview:loginPopup];
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MBProgressHUD showHUDAddedTo:webViewDetail animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:webViewDetail animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:webViewDetail animated:YES];
}

#pragma mark - Custom

- (NSString*) decodeFromPercentEscapeString:(NSString *) string {
    return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                         (__bridge CFStringRef) string,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
}

- (IBAction)Fb_ButtonPressed:(id)sender {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
//        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        [slComposeViewController addURL:[NSURL URLWithString:FbUrl]];
//        [slComposeViewController addImage:Img_Selected.image];
//        //[slComposeViewController setInitialText:FbUrl];
//        
//        [self presentViewController:slComposeViewController animated:YES completion:nil];
//    }
//    else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
//        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        [slComposeViewController addURL:[NSURL URLWithString:FbUrl]];
//        [slComposeViewController addImage:Img_Selected.image];
//       //[slComposeViewController setInitialText:FbUrl];
//        
//        [self presentViewController:slComposeViewController animated:YES completion:nil];
//    }
    // Check if the Facebook app is installed and we can present the share dialog
    
    
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:FbUrl];
    params.picture = [NSURL URLWithString:_DisImage];
    params.name = [NSString stringWithFormat:@"%@",_DisSASLName];
    params.caption = [NSString stringWithFormat:@"%@",_DisSASLName];
    params.linkDescription = [NSString stringWithFormat:@"%@",_DisMessage];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog

        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _DisImage, @"picture",
                                       _DisSASLName, @"name",
                                       _DisSASLName, @"caption",
                                       _DisMessage, @"description",
                                       FbUrl, @"link",
                                       nil];
        NSLog(@"_DisImage %@",_DisImage);
        NSLog(@"disname %@",params);

        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)Twitter_ButtonPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController setInitialText:FbUrl];
        [slComposeViewController addImage:Img_Selected.image];
        [slComposeViewController addURL:[NSURL URLWithString:FbUrl]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    }
    else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        //[slComposeViewController setInitialText:FbUrl];
        [slComposeViewController addImage:Img_Selected.image];
        [slComposeViewController addURL:[NSURL URLWithString:FbUrl]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    }
}

- (IBAction)Email_ButtonPressed:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Email Adrees"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:StringAlertButtonCancel
                                            otherButtonTitles:StringAlertButtonOK, nil];
    message.tag = 1111;
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    Email = [message textFieldAtIndex:0];
    Email.placeholder=@"Please Enter Your Email Address";
    
    [message show];
}

- (IBAction)SMS_ButtonPressed:(id)sender {
    UIAlertView *SMSAlert = [[UIAlertView alloc] initWithTitle:@"Enter Phone Number"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:StringAlertButtonCancel
                                             otherButtonTitles:StringAlertButtonOK, nil];
    SMSAlert.tag = 1112;
    [SMSAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    SMS = [SMSAlert textFieldAtIndex:0];
    SMS.delegate =self;
    SMS.placeholder=@"Please Enter Your Phone Number";
    
    [SMSAlert show];
}

- (IBAction)Call_ButtonNwPressed:(id)sender {
    UIAlertView *ListCalling = [[UIAlertView alloc] initWithTitle:callNumbernw
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:StringAlertButtonCancel
                                                otherButtonTitles:StringAlertButtonCall, nil];
    [ListCalling show];
    ListCalling.tag = 1113;
}

- (IBAction)Call_ButtonPressed:(id)sender
{
    UIAlertView *Calling = [[UIAlertView alloc] initWithTitle:callNumber
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:StringAlertButtonCancel
                                            otherButtonTitles:StringAlertButtonCall, nil];
    [Calling show];
    Calling.tag = 1113;
    
}

- (IBAction)Drive_ButtonPressed:(id)sender
{
    CTDriveMapViewController * Map = [[CTDriveMapViewController alloc] initWithNibName:@"CTDriveMapViewController" bundle:nil];
    NSLog(@"_DisLattitude = %@",_DisLattitude);
     NSLog(@"_DisLongitude = %@",_DisLongitude);
    Map.MapLattitude = _DisLattitude;
    Map.MapLongitude = _DisLongitude;
    Map.MapSaSlName =  _DisSASLName;
    Map.MapSaSldis = _DisTitle;
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Map];
    Map.delegate = parentController;
    Map.navigationItem.leftBarButtonItem = [self backButtonnw];
    Map.navigationItem.title = @"Drive";
    [UIView animateWithDuration:0.1 animations:^{
        
        [self presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        
        //[Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (IBAction)Promotion_ButtonPressed:(id)sender {

    if([CTCommonMethods isUIDStoredInDevice]){

        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
            CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
            CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController1" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
            promotion.delegate = parentController;
            promotion.navigationItem.leftBarButtonItem = [self backButtonnw];
            promotion.navigationItem.title = @"Create Promotion";
            //            isCREATE = true;
            [UIView animateWithDuration:0.1 animations:^{
                //                [parentController.navigationController pushViewController:mysupport animated:YES];
                //                [parentController addChildViewController:mysupport];
                //                [parentController.view addSubview:mysupport.view];
                [self presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        else
        {
            [CTCommonMethods sharedInstance].selectSa = _tileSA;
            [CTCommonMethods sharedInstance].selectSl = _tileSL;
            [CTCommonMethods sharedInstance].TILEPROMOTION = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPramotion" object:nil];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSlowSasl" object:nil];
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_LoginToAccessThisFeature_Title message:CT_LoginToAccessThisFeature_Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        alert.tag = 101;
        [alert show];
    }
    
    //    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    //
    //    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
    //
    //        [parentController loginPopUpOpen];
    //    }
    //    else{
    //        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
    //        {
    //            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
    //        }
    //        else{
    //            CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController" bundle:nil];
    //            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
    //            promotion.delegate = parentController;
    //            promotion.navigationItem.leftBarButtonItem = [self backButton];
    //            promotion.navigationItem.title = @"Create Promotion";
    //            [UIView animateWithDuration:0.1 animations:^{
    //
    //                [parentController presentViewController:nav animated:YES completion:nil];
    //
    //            } completion:^(BOOL finished) {
    //
    //                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    //            }];
    //        }
    //
    //    }
}




- (IBAction)MoreInfo_ButtonPressed:(id)sender {
    CTMoreInfoWebViewController * Moreinfo = [[CTMoreInfoWebViewController alloc] initWithNibName:@"CTMoreInfoWebViewController" bundle:nil];
    //if (self.showURL == FALSE && [_tileEnumText isEqual:@"CAMPAIGN_PROMOTION"])
    
    
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Moreinfo];
    //    Map.delegate = parentController;
    Moreinfo.navigationItem.leftBarButtonItem = [self backButtonnw];
    if (self.showURL == TRUE)
    {
        Moreinfo.WebUrl = _DisOnClikUrl;
        Moreinfo.navigationItem.title = @"More Info";
    }
    else
    {
        Moreinfo.WebUrl = [NSString stringWithFormat:@"%@finePrint?uuid=%@",@"http://chalkboards.today/",_DisUDID];
        NSLog(@"hello weburl %@",Moreinfo.WebUrl);
        Moreinfo.navigationItem.title = @"Terms and Conditions";
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [self presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        
        //[Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (IBAction)ListDrive_ButtonPressed:(id)sender {
    CTDriveMapViewController * Map = [[CTDriveMapViewController alloc] initWithNibName:@"CTDriveMapViewController" bundle:nil];
    //Map.MapLattitude = _DisLattitude;
    //Map.MapLongitude = _DisLongitude;
    Map.MapLattitude = _ListLat;
    Map.MapLongitude = _ListLog;
    Map.MapSaSlName =  _DisSASLName;
    Map.MapSaSldis = _DisTitle;
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Map];
    Map.delegate = parentController;
    Map.navigationItem.leftBarButtonItem = [self backButtonnw];
    Map.navigationItem.title = @"Drive";
    [UIView animateWithDuration:0.1 animations:^{
        
        [self presentViewController:nav animated:YES completion:nil];
        
    } completion:^(BOOL finished) {
        
        //[Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101 && buttonIndex!= alertView.cancelButtonIndex) {
        // login btn taped.
        [CTCommonMethods sharedInstance].PRAMOTIONFLAG = YES;
        
        
        //CTLoginViewController * login = [[CTLoginViewController alloc]initWithNibName:@"CTLoginViewController" bundle:nil];
        
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
        CTLoginViewController * promotion = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        promotion.PromotionOwner = YES;
        promotion.TileSA = self.tileSA;
        promotion.TileSL =  self.tileSL;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
        promotion.delegate = parentController;
        promotion.navigationItem.leftBarButtonItem = [self backButtonnw];
        promotion.navigationItem.title = @"Chalkboard Login";
        //            isCREATE = true;
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [self presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
        //CTLoginPopup *login = [[CTLoginPopup alloc]init];
        //[self.view addSubview:login];
        [CTCommonMethods sharedInstance].IdentifierNoti = @"101";
    }
    
    
    
    switch (alertView.tag) {
        case 1111:{
            switch (buttonIndex) {
                case 1:{
                    if ([self validateEmailWithString:Email.text])
                    {
                        NSString *urlString;
                        if ([self.tileEnumText isEqualToString:@"ACTIVITY"] || [self.tileEnumText isEqualToString:@"DINING_DEAL"] || [self.tileEnumText isEqualToString:@"DISCOUNT"] || [self.tileEnumText isEqualToString:@"ENTERTAINMENT"] || [self.tileEnumText isEqualToString:@"HAPPYHOUR"] || [self.tileEnumText isEqualToString:@"OTHER"]) {
                            
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&promoUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toEmail=%@",[CTCommonMethods getChoosenServer],CT_WebView_ShareEmailURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],Email.text];
                            NSLog(@"DINING_DEAL urlstring %@",urlString);
                            
                        }
                        else if ([self.tileEnumText isEqualToString:@"EVENT"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&eventUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toEmail=%@",[CTCommonMethods getChoosenServer],CT_WebView_ShareEventEmailURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],Email.text];
                            
                            NSLog(@"EVENT urlstring %@",urlString);
                            
                        }
                        else if ([self.tileEnumText isEqualToString:@"AD_ALERT"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&notificationUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toEmail=%@",CT_WebVire_ShareNotificationEmailURL,[CTCommonMethods getChoosenServer],[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],Email.text];
                            
                            NSLog(@"AD urlstring %@",urlString);
                        }
                        
                        else if ([self.tileEnumText isEqualToString:@"CAMPAIGN_PROMOTION"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&campaignUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toEmail=%@",[CTCommonMethods getChoosenServer],CT_WebVire_ShareCampaignEmailURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],Email.text];
                            
                            NSLog(@"CAMPAIGN urlstring %@",urlString);
                            NSLog(@"tile uuid %@",[CTCommonMethods sharedInstance].tileUUID[self.indexValue]);
                        }
                        
                        NSLog(@"Email URL get duration %@",urlString);
                        NSURL *url=[NSURL URLWithString:urlString];
                        NSURLRequest *request=[NSURLRequest requestWithURL:url];
                        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode=MBProgressHUDModeIndeterminate;
                        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                            //        NSLog(@"JSON Promotion Type == %@",JSON);
                            if (JSON)
                            {
                                NSLog(@"Succuss %@",JSON);
                                NSString * explanation = [JSON valueForKey:@"explanation"];
                                
                                UIAlertView *message = [[UIAlertView alloc] initWithTitle:explanation
                                                                                  message:nil
                                                                                 delegate:self
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"Done", nil];
                                [message show];
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
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidMailId message:StringAlertMsgValidMailId delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                        [alert show];
                        return ;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        
            
        case 1112:{
            switch (buttonIndex) {
                case 1:{
                    
                    if ([self validatePhoneNumber:SMS.text]  == YES)
                    {
                        //
                        NSString *urlString;
                        if ([self.tileEnumText isEqualToString:@"ACTIVITY"] || [self.tileEnumText isEqualToString:@"DINING_DEAL"] || [self.tileEnumText isEqualToString:@"DISCOUNT"] || [self.tileEnumText isEqualToString:@"ENTERTAINMENT"] || [self.tileEnumText isEqualToString:@"HAPPYHOUR"] || [self.tileEnumText isEqualToString:@"OTHER"]) {
                            
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&promoUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toTelephoneNumber=%@",[CTCommonMethods getChoosenServer],CT_WebVire_ShareSMSURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],SMS.text];
                            NSLog(@"urlstring %@",urlString);
                            NSLog(@"UID %@",[CTCommonMethods UID]);
                        }
                        else if ([self.tileEnumText isEqualToString:@"EVENT"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&eventUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toTelephoneNumber=%@",[CTCommonMethods getChoosenServer],CT_WebVire_ShreEventSMSURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],SMS.text];
                        }
                        else if ([self.tileEnumText isEqualToString:@"AD_ALERT"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&notificationUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toTelephoneNumber=%@",[CTCommonMethods getChoosenServer],CT_WebVire_ShareNotificationSMSURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],SMS.text];
                        }
                        
                        else if ([self.tileEnumText isEqualToString:@"CAMPAIGN_PROMOTION"])
                        {
                            NSLog(@"tileenumtext %@",self.tileEnumText);
                            urlString=[NSString stringWithFormat:@"%@%@?UID=%@&campaignUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&toTelephoneNumber=%@",[CTCommonMethods getChoosenServer],CT_WebVire_ShareCampaignSMSURL,[CTCommonMethods UID],[CTCommonMethods sharedInstance].tileUUID[self.indexValue],[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue],[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue],SMS.text];
                        }
                       
                        NSLog(@"SMS URL get duration %@",urlString);
                        NSURL *url=[NSURL URLWithString:urlString];
                        NSURLRequest *request=[NSURLRequest requestWithURL:url];
                        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode=MBProgressHUDModeIndeterminate;
                        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                            //        NSLog(@"JSON Promotion Type == %@",JSON);
                            if (JSON)
                            {
                                NSLog(@"Succuss %@",JSON);
                                NSString * explanation = [JSON valueForKey:@"explanation"];
                                
                                UIAlertView *message = [[UIAlertView alloc] initWithTitle:explanation
                                                                                  message:nil
                                                                                 delegate:self
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"Done", nil];
                                [message show];
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
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidPhoneNo message:StringAlertMsgReqValidPhoneNo delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
                        [alert show];
                        return ;
                    }
                }
                    break;
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callNumber]]];
                default:
                    break;
            }
        
                 break;
        }
            
        case 1113:{
            switch (buttonIndex) {
                case 1:{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callNumber]]];
                }
                    break;
        }
            break;
        }
            
        default:
            break;

    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length == 1)
        return YES;
    
    if(textField == SMS && (SMS.text.length >= 10 || [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound))
        return NO;
    
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)validatePhoneNumber:(NSString*)number {
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:&error];
    NSUInteger numberOfMatches = [detector numberOfMatchesInString:number
                                                           options:0
                                                             range:NSMakeRange(0, [number length])];
    if(numberOfMatches>0)
        return YES;
    return NO;
}


- (void) reloadWebView: (BOOL)flag{
    if ([[CTRootControllerDataModel sharedInstance].selectedRestaurant valueForKeyPath:@"showURL"] && !strLoadUrl) {
        NSLog(@"\n Webview loaded with string 'Loading external site'");
        [webViewDetail loadHTMLString:@"Loading external site" baseURL:nil];
    }
    else{
        if ([CTCommonMethods UID].length > 1 && [strLoadUrl rangeOfString:@"&UID="].location == NSNotFound)
            strLoadUrl = [strLoadUrl stringByAppendingFormat:@"&UID=%@",[CTCommonMethods UID]];
        
        if (flag && [strLoadUrl rangeOfString:@"embedded=true"].location == NSNotFound)
            strLoadUrl = [strLoadUrl stringByAppendingFormat:@"embedded=true&UID=%@",[CTCommonMethods UID]];
        
        NSLog(@"\n Webview loaded with URL \n%@",strLoadUrl);
        NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[strLoadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        //    aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strLoadUrl]];
        [webViewDetail loadRequest:aRequest];
    }
}

- (void) loginCallBack {
    
    //    NSString *strJS = [NSString stringWithFormat:@"IOSLoginSucceeded('%@')",[CTCommonMethods UID]];
    //    [webViewDetail stringByEvaluatingJavaScriptFromString:strJS];
    
    //        [callerController reloadWebView:YES];
    
    NSString *parameterOne = [CTCommonMethods UID];
    NSString *parameterTwo = [CTCommonMethods UserName];
    
    NSString *defaultLoginCallback = @"IOSLoginSucceeded";
    NSString *javascriptString1 = [NSString stringWithFormat:@"%@('%@','%@')",defaultLoginCallback , parameterOne , parameterTwo];
    [webViewDetail stringByEvaluatingJavaScriptFromString:javascriptString1];
    
    if(parametersSentWithURL != nil) {
        NSArray *tempParams = [parametersSentWithURL componentsSeparatedByString:@"&"];
        
        for (NSString *str in tempParams) {
            if ([str rangeOfString:@"functionName="].location != NSNotFound) {
                NSString *javascriptString2 = [NSString stringWithFormat:@"%@('%@','%@')",[str stringByReplacingOccurrencesOfString:@"functionName=" withString:@""] , parameterOne , parameterTwo ];
                [webViewDetail stringByEvaluatingJavaScriptFromString:javascriptString2];
                break;
            }
        }
    }
    else {
        NSString *callBack = @"window.IOSLoginExecuted";
        NSString *javascriptString2 = [NSString stringWithFormat:@"%@('%@','%@')",callBack , parameterOne , parameterTwo ];
        [webViewDetail stringByEvaluatingJavaScriptFromString:javascriptString2];
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    //    if(range.length == 1)
//    //        return YES;
//    
//    if(range.length == 1)
//        return YES;
//    
////    if(textField == SMS && (textField.text.length >= 10 || [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound))
////        return NO;
//    
//    return YES;
//}



@end
