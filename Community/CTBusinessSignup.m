//
//  CTBusinessSignup.m
//  Community
//
//  Created by My Mac on 22/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTBusinessSignup.h"
#import "Constants.h"
#import "MBProgressHUD.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.45;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 100;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 250;

@interface CTBusinessSignup ()

@end


@implementation CTBusinessSignup

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1100);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1100);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        Scroll.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        
    }
    
    if ([CTCommonMethods sharedInstance].StoreEventType.count == 0)
    {
        [self DomainTypeDataFetch];
    }
    else{
        listofDomainName = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"displayText"];
        listenumName = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"enumText"];
    }
    
    txt_Business.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_BusiNumber.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_City.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_ConPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Country.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Email.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Password.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Street.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Street2.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    txt_Zip.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}

#pragma mark - Domain Type Api
-(void)DomainTypeDataFetch
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_BusinessSignup_URL];
    
    NSLog(@"URL get duration %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON Domain Type == %@",JSON);
        if (JSON)
        {
            
            [CTCommonMethods sharedInstance].StoreDomain = JSON;
            listofDomainName = [[CTCommonMethods sharedInstance].StoreDomain valueForKey:@"displayText"];
            listenumName = [[CTCommonMethods sharedInstance].StoreDomain valueForKey:@"enumText"];
            //listofeventId = [[CTCommonMethods sharedInstance].StoreEventType valueForKey:@"id"];
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

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [@[btn_Cancel,btn_Create
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[txt_Business,txt_City,txt_ConPassword,txt_Email,txt_Password,txt_Street,txt_Street2,txt_Zip,txt_BusiNumber
       
       ] enumerateObjectsUsingBlock:^(UITextField *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontTextFeild:btn :@"Lato-Regular" :15.0];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    //btn_Country.titleLabel.text = @"USA";
    
    
    [self BorderTextField:txt_Business];
    [self BorderTextField:txt_City];
    [self BorderTextField:txt_ConPassword];
    [self BorderTextField:txt_Country];
    [self BorderTextField:txt_Email];
    [self BorderTextField:txt_Password];
    [self BorderTextField:txt_Street];
    [self BorderTextField:txt_Street2];
    [self BorderTextField:txt_Zip];
    [self BorderTextField:txt_BusiNumber];
    
    listofStateShort = [[NSMutableArray alloc] initWithObjects:@"AL",@"AK",@"AZ",@"AR",@"CA",@"CO",@"CT",@"DE",@"DC",@"FL",@"GA",@"HI",@"ID",@"IL",@"IN",@"IA",@"KS",@"KY",@"LA",@"ME",@"MD",@"MA",@"MI",@"MN",@"MS",@"MO",@"MT",@"NE",@"NV",@"NH",@"NJ",@"NM",@"NY",@"NC",@"ND",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VT",@"VA",@"WA",@"WV",@"WI",@"WY",nil];
    
    listofStateName = [[NSMutableArray alloc] initWithObjects:@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"District of Columbia",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New Hampshire",@"New Jersey",@"New Mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode Island",@"South Carolina",@"South Dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming", nil];
    
    
//    NSLog(@"State = %d , State sort = %d",listofStateName.count,listofStateShort.count);
    listCityName = [[NSMutableArray alloc]initWithObjects:@"USA", nil];
    // Do any additional setup after loading the view from its nib.
    

    [btn_Country setTitle:@"USA" forState:UIControlStateNormal];

 
    
}


-(void) BorderTextField :(UITextField *)textfield
{
    textfield.layer.borderColor = [[UIColor blackColor] CGColor];
    textfield.layer.borderWidth = 2.0f;
}


#pragma mark - Create Button Pressed
- (IBAction)BTN_CreatePressed:(id)sender {
    
    //    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:StringAlertTitleBusiness message:StringAlertTitleBusinessCreated delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
    //    [alert show];
    [self resigntextField];
    
    
    if (FLAG == NO)
    {
        addressDic = [NSMutableDictionary dictionary];
        
        for (int k = 0; k < listofDomainName.count; k++)
        {
            if ([listofDomainName[k] isEqualToString:btn_Domain.titleLabel.text])
            {
                // selectEventType = [CTCommonMethods sharedInstance].StoreEventType[k];
                selectnumber = k;
//                NSLog(@"hello no %d",selectnumber);
                break;
            }
        }
        if([self validateEmailWithString:txt_Email.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidMailId message:StringAlertMsgValidMailId delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if(txt_Password.text.length&&txt_ConPassword.text.length >0)
        {
            if(txt_Password.text.length>=6)
            {
                if([txt_Password.text isEqualToString:txt_ConPassword.text])
                {
                    
                }
                else{
                    [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Password not match. Please check it"];
                    return;
                }
            }
            else{
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertPassTitle andMessage:@"Password must be at least 6 characters long"];
                return;
            }
        }
        else{
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertPassTitle andMessage:@"Please enter Password"];
            return;
        }
        if (txt_Business.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertMsgReqValidBusinessName message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if([self validatePhoneNumber:txt_BusiNumber.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleInvalidPhoneNo message:StringAlertMsgReqValidPhoneNo delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return ;
        }
        if([btn_Domain.titleLabel.text isEqualToString:@"Domain"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select Business Type" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        if(txt_Street.text.length == 0 && txt_Street2.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter Street" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
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
        if([btn_Country.titleLabel.text isEqualToString:@"Country"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please select Country" message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self CreateBusinessAPI];
        
    }
    [self.view endEditing:YES];
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 180)];
    UILabel* mylabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 290, 38)];
    mylabel1.text =[NSString stringWithFormat:@"'%@' created",txt_Business.text];
    mylabel1.font = [UIFont boldSystemFontOfSize:18.0];
    mylabel1.textAlignment = NSTextAlignmentCenter;
     UILabel* mylabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 38, 285, 70)];
    mylabel2.text = @"Please login with your email/password to create";
    mylabel2.numberOfLines = 2;
    mylabel2.textAlignment = NSTextAlignmentCenter;
    UILabel* mylabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 90, 240, 90)];
    mylabel.text = [NSString stringWithFormat: @"%C Promotions/Deals \n %C Events \n %C Breaking News  ", (unichar) 0x2022, (unichar) 0x2022, (unichar) 0x2022];
    mylabel.numberOfLines = 3;
    
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    //    [imageView setImage:[UIImage imageNamed:@"demo"]];
    [demoView addSubview:mylabel2];
    [demoView addSubview:mylabel1];
    [demoView addSubview:mylabel];
    
    return demoView;
}

#pragma mark  Create Business API
-(void) CreateBusinessAPI
{
    NSString *urlSuffix = [NSString stringWithFormat:CT_Business_Post];
    NSLog(@"urlSuffix =%@",urlSuffix);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],urlSuffix];
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSLog(@"url %@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"businessEmail\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"businessName\":\"%@\",\"domain\":\"%@\",\"businessPhoneNumber\":\"%@\",\"street\":\"%@\",\"street2\":\"%@\",\"city\":\"%@\",\"state\":\"%@\",\"zip\":\"%@\",\"country\":\"%@\"}",txt_Email.text,txt_Email.text,txt_Password.text,txt_Business.text,listenumName[selectnumber],txt_BusiNumber.text,txt_Street.text,txt_Street2.text,txt_City.text,sortState,txt_Zip.text,btn_Country.titleLabel.text];
    
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
        
        
        NSMutableDictionary *yourDictionary = [[NSMutableDictionary alloc] init];
        [yourDictionary setObject:txt_Email.text forKey:@"USERNAME_KEY"];
        [yourDictionary setObject:txt_Password.text forKey:@"PASSWORD_KEY"];
        [yourDictionary setObject:[dict valueForKey:@"email"] forKey:@"email"];
        [yourDictionary setObject:[CTCommonMethods UID] forKey:@"uid"];
        [yourDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isOwner"];
        [[NSUserDefaults standardUserDefaults] setObject:yourDictionary forKey:@"DicKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        if (dict)
        {
            
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            
            // Add some custom content to the alert view
            
            [alertView setContainerView:[self createDemoView]];
            
            // Modify the parameters
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Done", nil]];
            [alertView setDelegate:self];
            
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                [alertView close];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
            
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


#pragma mark - Cancel Button Pressed
- (IBAction)BTN_CancelPressed:(id)sender {
    [self resigntextField];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Domain Button Pressed
- (IBAction)BTN_DomainPressed:(id)sender {
    [self resigntextField];
    if(dropDown == nil) {
        CGFloat f = 300;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listofDomainName :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [btn_Domain setBackgroundImage:[UIImage imageNamed:@"sel_button.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - State Button Pressed
- (IBAction)BTN_StatePressed:(id)sender {
    [self resigntextField];
    if(dropDown == nil) {
        CGFloat f = 170;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listofStateName :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag = 101;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [btn_State setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)BTN_CityPressed:(id)sender {
    [self resigntextField];
    if(dropDown == nil) {
        CGFloat f = 120;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :listCityName :nil :@"down"];
        dropDown.delegate = self;
        [dropDown bringSubviewToFront:self.view];
    }
    else {
        [dropDown hideDropDown:sender];
        
        [self rel];
        [btn_City setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)BTN_CountryPressed:(id)sender
{
    [self resigntextField];
    if(dropDown == nil) {
        CGFloat f = 120;
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
#pragma mark - DropDown Methods
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self rel];
    [btn_Domain setBackgroundImage:[UIImage imageNamed:@"sel_button.png"] forState:UIControlStateNormal];
    [btn_State setBackgroundImage:[UIImage imageNamed:@"sel_button_small.png"] forState:UIControlStateNormal];
    if (sender.tag == 101)
    {
//        NSLog(@"Sort name = %@",listofStateShort[sender.selectindex]);
        sortState = listofStateShort[sender.selectindex];
    }
    
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
-(void)resigntextField
{
    [txt_Email resignFirstResponder];
    [txt_Password resignFirstResponder];
    [txt_ConPassword resignFirstResponder];
    [txt_Business resignFirstResponder];
    [txt_Street resignFirstResponder];
    [txt_Street2 resignFirstResponder];
    [txt_City resignFirstResponder];
    [txt_Zip resignFirstResponder];
    [txt_Country resignFirstResponder];
    [txt_BusiNumber resignFirstResponder];
    
    
}
#pragma mark - Email Validation

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Phone Validation

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

/////Textkeyboard UpandDown With View/////
#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor blueColor] CGColor];
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
    
    if(textField == txt_BusiNumber && (textField.text.length >= 10 || [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound))
        return NO;
    
    if(textField == txt_Zip && (textField.text.length >= 5 || [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSNumericSearch].location == NSNotFound) )
        return NO;
    
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
