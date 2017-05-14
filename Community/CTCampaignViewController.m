//
//  CTCampaignViewController.m
//  Community
//
//  Created by ADMIN on 5/3/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import "CTCampaignViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.6;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 200;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 270;

@interface CTCampaignViewController ()


@end

@implementation CTCampaignViewController

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
        
    }
    
    txt_Title.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_EndDate.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_StartDate.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Expiration.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Reward.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_CVV.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_CreditCard.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_City.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Street.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Street2.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Zip.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_CardName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_FirstName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_LastName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_ParcentOff.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_MinPurchase.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CASHBOOL = NO;
    AgreeFlag = NO;
    [@[btnCreate,btnCancel
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[txt_FirstName,txt_LastName,txt_City,txt_CreditCard,txt_CVV,txt_EndDate,txt_StartDate,txt_Expiration,txt_Reward,txt_Street,txt_Street2,txt_Title,txt_Zip,txt_MinPurchase,txt_ParcentOff
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    


    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    Lbl_Terms.text = @"I Agree to the Terms and Conditions";
    
    [self BorderTextField:txt_Title];
    [self BorderTextField:txt_EndDate];
    [self BorderTextField:txt_StartDate];
    [self BorderTextField:txt_Expiration];
    [self BorderTextField:txt_Reward];
    [self BorderTextField:txt_CVV];
    [self BorderTextField:txt_CreditCard];
    [self BorderTextField:txt_City];
    [self BorderTextField:txt_Street];
    [self BorderTextField:txt_Street2];
    [self BorderTextField:txt_Zip];
    [self BorderTextField:txt_CardName];
    [self BorderTextField:txt_ParcentOff];
    [self BorderTextField:txt_MinPurchase];
    [self BorderTextField:txt_FirstName];
    [self BorderTextField:txt_LastName];
    
    listofStateName = [[NSMutableArray alloc] initWithObjects:@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New Hampshire",@"New Jersey",@"New Mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode Island",@"South Carolina",@"South Dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming", nil];
    
    listCityName = [[NSMutableArray alloc]initWithObjects:@"USA", nil];
    
    pickeryear  = [[NSMutableArray alloc]initWithObjects:@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036", nil];
    
    pickermonth = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    imageCash.image = [UIImage imageNamed:@"RadioButtonGreen.png"];
    imageDiscount.image = [UIImage imageNamed:@"RadioButton.png"];
    SelectedReward = @"CASH";
//    NSLog(@"SelectValue Case%@",SelectedReward);
    strmonth = @"";
    stryear = @"";
    activateStr = @"";
    deactivateStr = @"";
    
    [btn_Country setTitle:listCityName[0] forState:UIControlStateNormal];
}

-(void) BorderTextField :(UITextField *)textfield
{
    textfield.layer.borderColor = [[UIColor blackColor] CGColor];
    textfield.layer.borderWidth = 2.0f;
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

- (IBAction)StateButtonPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 120;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listofStateName :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [btn_State setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)CountryButtonPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listCityName :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [btn_Country setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
    }
}

-(void)CaseAPI
{
//    NSString *urlString=[NSString stringWithFormat:@"%@promotions/createCampaignPromotion?UID=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID]];
//    NSLog(@"URL get duration %@",urlString);
//    NSURL *url=[NSURL URLWithString:urlString];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
//    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"JSON Event Type == %@",JSON);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (JSON)
//        {
////            self.listofAnswer = [JSON valueForKeyPath:@"contest.choices"];
////            [CTCommonMethods sharedInstance].PollAnswerStore = [JSON valueForKeyPath:@"contest.prizes"];
////            [self reloadPollValues];
//        }
//        
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if(error) {
//            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
//        }else {
//            NSLog(@"FAILED");
//            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
//            if(jsonError)
//                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
//            else
//                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
//        }
//    }];
//    
//    [operation start];
    NSLog(@"i'm selected %@",SelectedReward);

    
    if ([SelectedReward isEqualToString:@"CASH"])
    {
        NSString *urlString=[NSString stringWithFormat:@"%@promotions/createCampaignPromotion?UID=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID]];
        //NSString *urlString = [NSString stringWithFormat:@"%@%@&duration=%@",[CTCommonMethods getChoosenServer],urlSuffix,selectDuration];
        
        NSURL *url=[NSURL URLWithString:urlString];
        NSLog(@"case url %@",url);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        //NSString *msgTxt=[NSString stringWithFormat:@"{\"fromServiceAccommodatorId\":\"%@\",\"fromServiceLocationId\":\"%@\",\"urgent\":\"false\",\"notificationBody\":\"%@\",\"authorId\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,textViewObj.text,[CTCommonMethods UID]];
        //NSLog(@"MSG TEXT %@",msgTxt);
        
        
//        NSString * mystring = txt_CardName.text;
//        NSArray * array = [mystring componentsSeparatedByString:@" "];
//        NSString * str1;
//        NSString * str2;
//        if (array.count == 2)
//        {
//            str1 = [array objectAtIndex:0]; //123
//            str2 = [array objectAtIndex:1];
//        }
//        else
//        {
//            str1 = [array objectAtIndex:0]; //123
//            str2 = @"";
//        }
        
        
        
        NSDictionary *billingAddress = @{@"street":txt_Street.text,
                                         @"street2":txt_Street2.text,
                                         @"city":txt_City.text,
                                         @"state":btn_State.titleLabel.text,
                                         @"zip":txt_Zip.text,
                                         @"country":btn_Country.titleLabel.text,
                                         };
        
        NSDictionary *creditCard = @{@"cardType":@"VISA",
//                                     @"name":txt_CardName.text,
                                     @"cardNumber":txt_CreditCard.text,
                                     @"expirationMonth":strmonth,
                                     @"expirationYear":stryear,
                                     @"cvv":txt_CVV.text,
                                     @"firstName":txt_FirstName.text,
                                     @"lastName":txt_LastName.text,
                                     };
     
        NSDictionary *params=@{@"topic":txt_Title.text,
                               @"activation":activateStr,
                               @"expiration":deactivateStr,
                               @"rewardType":SelectedReward,
                               @"cashRewardAmount":txt_Reward.text,
                               @"billingAddress":billingAddress,
                               @"creditCard":creditCard,
                               @"discountRewardPercent":txt_ParcentOff.text,
                               @"discountRewardMinimumPurchase":txt_MinPurchase.text,
//                               @"hints":@"Promote our new Coffee",
                               @"comments":@" ",
                               @"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa,
                               @"serviceLocationId":[CTCommonMethods sharedInstance].selectSl,
                               };
        
        
        NSLog(@"params = %@",params);
        
        NSError * err;
        NSData * jsonData1 = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData1];
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Please wait...";
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"SUCEESS = %@",JSON);
            NSDictionary *dict=(NSDictionary *)JSON;
            if (dict)
            {
                //textViewObj.text = @"";
                //[btnduration setTitle:[durationTime objectAtIndex:0] forState:UIControlStateNormal];
                //selectDuration = [durationid objectAtIndex:0];
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleCampaignCreated message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
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
    else{
        NSString *urlString=[NSString stringWithFormat:@"%@promotions/createCampaignPromotion?UID=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID]];
        //NSString *urlString = [NSString stringWithFormat:@"%@%@&duration=%@",[CTCommonMethods getChoosenServer],urlSuffix,selectDuration];
        
        NSURL *url=[NSURL URLWithString:urlString];
        NSLog(@"case url %@",url);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        //NSString *msgTxt=[NSString stringWithFormat:@"{\"fromServiceAccommodatorId\":\"%@\",\"fromServiceLocationId\":\"%@\",\"urgent\":\"false\",\"notificationBody\":\"%@\",\"authorId\":\"%@\"}",[CTCommonMethods sharedInstance].selectSa,[CTCommonMethods sharedInstance].selectSl,textViewObj.text,[CTCommonMethods UID]];
        //NSLog(@"MSG TEXT %@",msgTxt);
        
//        NSDictionary *billingAddress = @{@"street":txt_Street.text,
//                                         @"street2":txt_Street2.text,
//                                         @"city":txt_City.text,
//                                         @"state":btn_State.titleLabel.text,
//                                         @"zip":txt_Zip.text,
//                                         @"country":btn_Country.titleLabel.text,
//                                         };
//        NSLog(@"billingAddress = %@",billingAddress);
//        NSDictionary *creditCard = @{@"cardType":@"VISA",
//                                     @"name":txt_CardName.text,
//                                     @"cardNumber":txt_CreditCard.text,
//                                     @"expriationMonth":txt_Expiration.text = [NSString stringWithFormat:@"%@",pickermonth[0]],
//                                     @"expirationYear":txt_Expiration.text = [NSString stringWithFormat:@"%@",pickeryear[0]],
//                                     @"cvv":txt_CVV.text,
//                                     };
//         NSLog(@"creditCard = %@",creditCard);
        NSDictionary *params=@{@"topic":txt_Title.text,
                               @"activation":activateStr,
                               @"expiration":deactivateStr,
                               @"rewardType":SelectedReward,
                               @"cashRewardAmount":txt_Reward.text,
                               @"billingAddress":[NSNull null],
                               @"creditCard":[NSNull null],
                               @"discountRewardPercent":txt_ParcentOff.text,
                               @"discountRewardMinimumPurchase":txt_MinPurchase.text,
                               @"hints":@"Promote our new Coffee",
                               @"comments":@" ",
                               @"serviceAccommodatorId":[CTCommonMethods sharedInstance].selectSa,
                               @"serviceLocationId":[CTCommonMethods sharedInstance].selectSl,
                               };
        
        
        NSLog(@"params = %@",params);
        
        NSError * err;
        NSData * jsonData1 = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData1];
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        hud.labelText=@"Please wait...";
        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"SUCEESS = %@",JSON);
            NSDictionary *dict=(NSDictionary *)JSON;
            if (dict)
            {
                //textViewObj.text = @"";
                //[btnduration setTitle:[durationTime objectAtIndex:0] forState:UIControlStateNormal];
                //selectDuration = [durationid objectAtIndex:0];
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleCampaignCreated message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
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
    
}

- (IBAction)CreateButtonPressed:(id)sender {
    
    
    if(txt_Title.text.length  == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter Title" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(txt_StartDate.text.length  == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Choose StartDate" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(txt_EndDate.text.length  == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Choose EndDate" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([SelectedReward isEqualToString:@"CASH"])
    {
        if(txt_Reward.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Reward" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_CreditCard.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter CreditCard Number" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_FirstName.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Your First Name" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_LastName.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Your Last Name" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_Expiration.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Expiration" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_CVV.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter CVC" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if(txt_Street.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter Street" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
//        if(txt_Street2.text.length == 0)
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter Street" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
//            [alert show];
//            return;
//        }
        
        if(txt_City.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter City" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if([btn_State.titleLabel.text isEqualToString:@"State"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select State" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if(txt_Zip.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter Zipcode" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if([btn_Country.titleLabel.text isEqualToString:@"Contry"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select State" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        //        if([btn_Country.titleLabel.text isEqualToString:@"Country"])
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select Country" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        //            [alert show];
        //            return;
        //    }
    }
    else
    {
        if(txt_ParcentOff.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter PercentOff" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if(txt_MinPurchase.text.length  == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter MinPurchase" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
    }

    if (AgreeFlag == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Agree Terms and Condition" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
        return;
    }

    [self CaseAPI];
    
    [self.view endEditing:YES];
}

- (IBAction)CancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DropDown Methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    [btn_State setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}


- (IBAction)CashButtonPressed:(id)sender
{
    //NSLog(@"btn Selected = %d",btnCash.selected);
    if (CASHBOOL)
    {
        //imageCash.backgroundColor = [UIColor redColor];
        imageCash.image = [UIImage imageNamed:@"RadioButtonGreen.png"];
        imageDiscount.image = [UIImage imageNamed:@"RadioButton.png"];
        //imageDiscount.backgroundColor = [UIColor yellowColor];
        CASHBOOL = NO;
        
        Discount_Vw.hidden = YES;
        Case_Vw.hidden = NO;
        
        SelectedReward = @"CASH";
//        NSLog(@"SelectValue Case%@",SelectedReward);
        
        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationCurveLinear
                         animations:^
         {
             
             CGRect frame1 = Button_Vw.frame;
             frame1.origin.y = 1150;
             Button_Vw.frame = frame1;
             
             //            CGRect frame = leftView.frame;
             //            frame.origin.y = 540;
             //            leftView.frame = frame;
             
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
        if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
        {
            NSLog(@"iphone6 + First View");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
        {
            NSLog(@"iphone6");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
        {
            NSLog(@"iphone5");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
        {
            NSLog(@"iphone4");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
            
        }

    }
    else{
        //imageDiscount.backgroundColor = [UIColor redColor];
        ///imageCash.backgroundColor = [UIColor blackColor];
        imageDiscount.image = [UIImage imageNamed:@"RadioButtonBlue.png"];
        imageCash.image = [UIImage imageNamed:@"RadioButton.png"];
        CASHBOOL = YES;
        
        SelectedReward = @"DISCOUNT";
//        NSLog(@"SelectValue Dis%@",SelectedReward);
        
        Discount_Vw.hidden = NO;
        Case_Vw.hidden = YES;
        
        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationCurveLinear
                         animations:^
         {
             
             CGRect frame1 = Button_Vw.frame;
             frame1.origin.y = 500;
             Button_Vw.frame = frame1;
             
             //            CGRect frame = leftView.frame;
             //            frame.origin.y = 540;
             //            leftView.frame = frame;
             
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
        if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
        {
            NSLog(@"iphone6 + First View");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 700);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
        {
            NSLog(@"iphone6");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 700);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
        {
            NSLog(@"iphone5");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 630);
            
        }
        
        else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
        {
            NSLog(@"iphone4");
            Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 600);
            
        }
        
        
        
    }
}

- (IBAction)AgreeButtonPressed:(id)sender {
    if (AgreeFlag == NO)
    {
        btnAgree.image = [UIImage imageNamed:@"RadioButtonRight.png"];
        AgreeFlag = YES;
    }
    else
    {
        btnAgree.image = [UIImage imageNamed:@"RadioButton.png"];
        AgreeFlag = NO;
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
    
    
    if ([textField isEqual:txt_StartDate])
    {
        [self setUpTextFieldDatePickernw];
    }
    else if ([textField isEqual:txt_EndDate])
    {
        [self setUpTextFieldDatePicker1];
    }
    else if([textField isEqual:txt_Expiration])
    {
        [self addPickerView];
    }
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //    if(range.length == 1)
    //        return YES;
    
    if(range.length == 1)
        return YES;
    
    if(textField == txt_Zip && (textField.text.length >= 5 || [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound) )
        return NO;
    
    if (textField == txt_Reward && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
    {
        return NO;
    }
    
    if (textField == txt_ParcentOff && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
    {
        return NO;
    }
    
    if (textField == txt_MinPurchase && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
    {
        return NO;
    }
    
    if (textField == txt_CreditCard && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
    {
        return NO;
    }
    
    if (textField == txt_CVV && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([txt_StartDate isFirstResponder] && [touch view] != txt_StartDate) {
        [txt_StartDate resignFirstResponder];
    }
    else
    {
        [txt_EndDate resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}

-(void)addPickerView{
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             flexButton,doneButton, nil];
    [toolBar setItems:toolbarItems];
    txt_Expiration.inputView = myPickerView;
    txt_Expiration.inputAccessoryView = toolBar;
    
    
}
-(void)done:(id)sender
{
    //[subjectField resignFirstResponder];
    if (strpickr.length == 0)
    {
        txt_Expiration.text = [NSString stringWithFormat:@"%@ / %@",pickermonth[0],pickeryear[0]];
    }
    
    [self.view endEditing:YES];
    
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if(component == 1)
    {
        return [pickeryear count];
    }
    else
    {
        return [pickermonth count];
    }
    
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if(component == 1)
    {
        //[txt_Expiration setText:[pickerdata objectAtIndex:row]];
        stryear = [pickeryear objectAtIndex:row];
    }
    else
    {
        //[txt_Expiration setText:[pickermonth objectAtIndex:row]];
        strmonth = [pickermonth objectAtIndex:row];
    }
    if (stryear.length == 0)
    {
        strpickr = [NSString stringWithFormat:@"%@ / %@",strmonth,pickeryear[0]];
        txt_Expiration.text = [NSString stringWithFormat:@"%@ / %@",strmonth,pickeryear[0]];
        stryear = pickeryear[0];
    }
    if (strmonth.length == 0)
    {
        strpickr = [NSString stringWithFormat:@"%@ / %@",pickermonth[0],stryear];
        txt_Expiration.text = [NSString stringWithFormat:@"%@ / %@",pickermonth[0],stryear];
        strmonth = pickermonth [0];
    }
    else
    {
        strpickr = [NSString stringWithFormat:@"%@ / %@",strmonth,stryear];
        txt_Expiration.text = [NSString stringWithFormat:@"%@ / %@",strmonth,stryear];
    }
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if(component == 1)
    {
        return [pickeryear objectAtIndex:row];
    }
    else
    {
        return [pickermonth objectAtIndex:row];
    }
    
}


#pragma mark Date/Time Picker
-(NSString *)getUTCFormateDate1:(NSDate *)localDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"PST"];
    //[dateFormatter setTimeZone:timeZone];
    //[dateFormatter setLocale:locale]; "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:'UTC'Z"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //[dateFormatter release];
    return dateString;
}

#pragma mark Expiration Picker
-(void)setUpTextFieldDatePicker
{
    datePickerActAndExp = [[UIDatePicker alloc]init];
    datePickerActAndExp.datePickerMode = UIDatePickerModeDateAndTime;
    datePickerActAndExp.tag = 2;
    [datePickerActAndExp setDate:[NSDate date]];
    datePickerActAndExp.minimumDate=minDate;
    
    [datePickerActAndExp addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 410, 320, 44)] ;
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    [txt_Expiration setInputAccessoryView:keyboardToolbar];
    [txt_Expiration setInputView:datePickerActAndExp];
}


-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)txt_Expiration.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    txt_Expiration.text = [NSString stringWithFormat:@"%@",dateString];
    
    expireStr =[self getUTCFormateDate1:picker.date];
    //    NSLog(@"expireStr = %@",expireStr);
}



-(void)resignKeyboard {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [outputFormatter stringFromDate:[datePickerActAndExp date]];
    NSLog(@"dateStr = %@",dateStr);
    //    if (datePickerActAndExp.tag == 1)
    //    {
    //        _txt_Start_Dt.text = [NSString stringWithFormat:@"%@",dateStr];
    //
    //        activateStr =[self getUTCFormateDate:datePickerActAndExp.date];
    //    }
    // else{
//    txt_Expiration.text = [NSString stringWithFormat:@"%@",dateStr];
//    
//    expireStr =[self getUTCFormateDate1:datePickerActAndExp.date];
    // }
    NSLog(@"datePicker = %@",dateStr);
    //[keyboardToolbar removeFromSuperview];
    
    //[_txt_Start_Dt resignFirstResponder];
    [txt_Expiration resignFirstResponder];
    //[_txt_name resignFirstResponder];
    
    ///do nescessary date calculation here
}


#pragma mark StartDate Picker

-(void)setUpTextFieldDatePickernw
{
    datePickerActAndExp = [[UIDatePicker alloc]init];
    datePickerActAndExp.datePickerMode = UIDatePickerModeDateAndTime;
    datePickerActAndExp.tag = 1;
    [datePickerActAndExp setDate:[NSDate date]];
    minDate = [NSDate date];
    datePickerActAndExp.minimumDate=minDate;
    [datePickerActAndExp addTarget:self action:@selector(updateTextFieldnw:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 410, 320, 44)] ;
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard1)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    [txt_StartDate setInputAccessoryView:keyboardToolbar];
    [txt_StartDate setInputView:datePickerActAndExp];
    
}


-(void)updateTextFieldnw:(id)sender
{
    
    UIDatePicker *picker = (UIDatePicker*)txt_StartDate.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    txt_StartDate.text = [NSString stringWithFormat:@"%@",dateString];
    
    minDate=picker.date;
//    activateStr =[self getUTCFormateDatenw:picker.date];
    activateStr = [NSString stringWithFormat:@"%@:UTC+00:00",[self getUTCFormateDate123:picker.date]];
    NSLog(@"activateStr = %@",activateStr);
    
    
}
-(NSString *)getUTCFormateDate123:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //[dateFormatter release];
    return dateString;
}

//-(NSString *)getUTCFormateDatenw:(NSDate *)localDate
//{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"PST"];
//    //[dateFormatter setTimeZone:timeZone];
//    //[dateFormatter setLocale:locale]; "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:'UTC'Z"];
//    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
//    NSString *dateString = [dateFormatter stringFromDate:localDate];
//    //[dateFormatter release];
//    return dateString;
//}

#pragma mark EndDate Picker

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
    
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard1)];               NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
    
    [keyboardToolbar setItems:itemsArray];
    
    [txt_EndDate setInputAccessoryView:keyboardToolbar];
    [txt_EndDate setInputView:datePickerActAndExp];
    
}


-(void)updateTextField1:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)txt_EndDate.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; //24hr time format
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    
    txt_EndDate.text = [NSString stringWithFormat:@"%@",dateString];
    
//    deactivateStr =[self getUTCFormateDate:picker.date];
    deactivateStr = [NSString stringWithFormat:@"%@:UTC+00:00",[self getUTCFormateDate123:picker.date]];
    //    NSLog(@"expireStr = %@",expireStr);
}

-(void)resignKeyboard1 {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSString *dateStr = [outputFormatter stringFromDate:[datePickerActAndExp date]];
    if (datePickerActAndExp.tag == 1)
    {
        txt_StartDate.text = [NSString stringWithFormat:@"%@",dateStr];
        
//        activateStr =[self getUTCFormateDatenw:datePickerActAndExp.date];
        activateStr = [NSString stringWithFormat:@"%@:UTC+00:00",[self getUTCFormateDate123:datePickerActAndExp.date]];
    }
    else{
        txt_EndDate.text = [NSString stringWithFormat:@"%@",dateStr];
        
//        deactivateStr =[self getUTCFormateDate:datePickerActAndExp.date];
        deactivateStr = [NSString stringWithFormat:@"%@:UTC+00:00",[self getUTCFormateDate123:datePickerActAndExp.date]];
    }
    NSLog(@"datePicker = %@",dateStr);
    //[keyboardToolbar removeFromSuperview];
    
    [txt_StartDate resignFirstResponder];
    [txt_EndDate resignFirstResponder];
    //[_txt_name resignFirstResponder];
    
    ///do nescessary date calculation here
}

//-(NSString *)getUTCFormateDate:(NSDate *)localDate
//{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"PST"];
//    //[dateFormatter setTimeZone:timeZone];
//    //[dateFormatter setLocale:locale]; "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:'UTC'Z"];
//    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
//    NSString *dateString = [dateFormatter stringFromDate:localDate];
//    //[dateFormatter release];
//    return dateString;
//}

@end
