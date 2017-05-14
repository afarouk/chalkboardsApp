//
//  CTMenuViewController.m
//  Community
//
//  Created by My Mac on 28/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTMenuViewController.h"
#import "CTParentViewController.h"
#import "CTInviteView.h"
#import "ImageNamesFile.h"
#import "CTRootViewController.h"
#import "CTBusinessinvitatcodeView.h"
#import "CTInvitationBussinessView.h"
#import "CTCampaignViewController.h"
#import "RedirectNSLogs.h"

@interface CTMenuViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation CTMenuViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString * signin;
    NSString * signin1;
    //    NSLog(@"UID = %d",[CTCommonMethods UID].length);
    arrayIconsAndTitles = @[
                            @{
                                @"imageName": ([CTCommonMethods UID].length == 0 ? @"Sign_in1.png" : @"Sign_out1.png"),
                                @"title":@"Sign-in"
                                },
                            @{
                                @"imageName":@"Ad_alert.png",
                                //@"title":@"Ad Alert"
                                @"title":@"Breaking News"
                                },
                            @{
                                @"imageName":@"Promotion_Create.png",
                                @"title":@"Promotion"
                                },
                            @{
                                @"imageName":@"Promotion-Activate.png",
                                @"title":@"Activate Promotion"
                                },
                            @{
                                @"imageName":@"Promotion_Deactivate.png",
                                @"title":@"Deactivate Promotion"
                                },
                            @{
                                @"imageName":@"Event_Create.png",
                                @"title":@"Event"
                                },
                            @{
                                @"imageName":@"Event_Activate.png",
                                @"title":@"Activate Event"
                                },
                            @{
                                @"imageName":@"Event_Deactivate.png",
                                @"title":@"Deactivate Event"
                                },
                            @{
                                @"imageName":@"Campaign.png",
                                @"title":@"Campaign"
                                },
                            
                            //                            @{
                            //                                @"imageName":@"Contest_Poll.png",
                            //                                @"title":@"Interactive AD"
                            //                                },
                            
                            
//                            @{
//                                @"imageName":@"filter-icon.png",
//                                @"title":@"Filter"
//                                },
                            // @{
                            //  @"imageName":@"Code.png",
                            //  @"title":@"Invitation"
                            //  },
                            //                            @{
                            //                                @"imageName":@"Code.png",
                            //                                @"title":@"Invitation"
                            //                                },
                            //                            @{
                            //                                @"imageName":@"icon-with-question-mark.png",
                            //                                @"title":@"Guide"
                            //                                },
                            @{
                                @"imageName":@"180X180.png",
                                @"title":@"Legend"
                                },
                            @{
                                @"imageName":@"searchIcon.png",
                                @"title":@"Support"
                                },
                            
                            ];
    
    
    arrayIconsAndTitles2 = @[
                             @{
                                 @"imageName": ([CTCommonMethods UID].length == 0 ? @"Sign_in1.png" : @"Sign_out1.png"),
                                 @"title":@"Sign-in"
                                 
                                 },
                             
//                             @{
//                                 @"imageName":@"filter-icon.png",
//                                 @"title":@"Filter"
//                                 },
                             // @{
                             //  @"imageName":@"Code.png",
                             //  @"title":@"Invitation"
                             //  },
                             //                             @{
                             //                                 @"imageName":@"Code.png",
                             //                                 @"title":@"Invitation"
                             //                                 },
                             //                             @{
                             //                                 @"imageName":@"icon-with-question-mark.png",
                             //                                 @"title":@"Guide"
                             //                                 },
                             @{
                                 @"imageName":@"180X180.png",
                                 @"title":@"Legend"
                                 },
                             @{
                                 @"imageName":@"searchIcon.png",
                                 @"title":@"Support"
                                 }
                             //                             @{
                             //                                 @"imageName":@"Ad_alert.png",
                             //                                 @"title":@"Ad Alert"
                             //                                 },
                             //                             @{
                             //                                @"imageName":@"Event_Create.png",
                             //                                 @"title":@"Event"
                             //                                 },
                             //
                             //                             @{
                             //                                 @"imageName":@"Promotion_Create.png",
                             //                                 @"title":@"Promotion"
                             //                                 },
                             //                             @{
                             //                                 @"imageName":@"Contest_Poll.png",
                             //                                 @"title":@"Interactive AD"
                             //                                 }
                             
                             ];
        
    arrayIconsAndTitles3 = @[
                             @{
                                 @"imageName": ([CTCommonMethods UID].length == 0 ? @"Sign_in1.png" : @"Sign_out1.png"),
                                 @"title":@"Sign-in"
                                 
                                 },
                             
//                             @{
//                                 @"imageName":@"filter-icon.png",
//                                 @"title":@"Filter"
//                                 },
                             @{
                                 @"imageName":@"Code.png",
                                 @"title":@"Invitation"
                                 },
                             @{
                                 @"imageName":@"180X180.png",
                                 @"title":@"Legend"
                                 },
                             @{
                                 @"imageName":@"searchIcon.png",
                                 @"title":@"Support"
                                 }
                             
                             
                             ];
    
    if ([CTCommonMethods UID].length == 0)
    {
        signin = @"Sign_in1.png";
        signin1 = @"Sign in";
    }
    else
    {
        signin = @"Sign_out1.png";
        signin1 = @"Sign Out";
    }
    
    //imgArray = [[NSMutableArray alloc]initWithObjects:@"180X180.png", signin,@"filter-icon.png",@"Code.png",@"icon-with-question-mark.png",@"searchIcon.png",nil];
    
    imgArray = [[NSMutableArray alloc]initWithObjects:signin,@"180X180.png",@"Code.png",@"searchIcon.png",nil];
    
    //NameArray = [[NSMutableArray alloc]initWithObjects:@"Legend",signin1,@"Filter",@"Invitation",@"Business invitation code",@"Guide",@"Support", nil];
    
    NameArray = [[NSMutableArray alloc]initWithObjects:signin1,@"Invitation",@"Legend",@"Support", nil];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        
        
        [self myallnew:imgArray :NameArray :100 :100];
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        
        [self myallnew:imgArray :NameArray :135 :135];
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        
        [self myallnew:imgArray :NameArray :120 :120];
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        
        [self myallnew:imgArray :NameArray :100 :100];
    }
    
}
#pragma mark - MFMailComposer Delegate

- (void)handleDoubleTapOnLabel:(UITapGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:{
            //            return;
            NSString *filePath = [[RedirectNSLogs sharedInstance]filePathForNSLogsFile];
            @try {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc]init];
                controller.mailComposeDelegate = self;
                [controller setToRecipients:@[@"rrepaka@gmail.com"]];
                [controller setSubject:@"Apploom.com Log File"];
                [controller addAttachmentData:[NSData dataWithContentsOfFile:filePath] mimeType:@"application/text" fileName:@"ApploomLogs.txt"];
                [self presentViewController:controller animated:YES completion:nil];
            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cannot Send Email" message:exception.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            printf("\n MFMailComposeResultSent \n");
            break;
        case MFMailComposeResultCancelled:
            printf("\n MFMailComposeResultCancelled \n");
            break;
        case MFMailComposeResultFailed:
            printf("\n MFMailComposeResultFailed \n");
            break;
        case MFMailComposeResultSaved:
            printf("\n MFMailComposeResultSaved \n");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbl_username.text = [CTCommonMethods sharedInstance].EmailID;
    lbl_username.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapOnLabel:)];
    gesture.numberOfTapsRequired = 2;
    gesture.cancelsTouchesInView = YES;
    [lbl_username addGestureRecognizer:gesture];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    [@[lbl_username
       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
       }];
}

-(IBAction)btnBackButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
    {
        return arrayIconsAndTitles3.count;
    }
    else
    {
        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
        {
            return arrayIconsAndTitles2.count;
        }
        else
        {
            return arrayIconsAndTitles.count;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font=[UIFont fontWithName:@"Lato-Bold" size:15.0];
    }
    else{
        [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.accessoryView removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont fontWithName:@"Lato-Bold" size:15.0];
    }
    
    id objAtRow;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
    {
        objAtRow = [arrayIconsAndTitles3 objectAtIndex:indexPath.row];
    }
    else
    {
        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
        {
            objAtRow = [arrayIconsAndTitles2 objectAtIndex:indexPath.row];
        }
        else
        {
            objAtRow = [arrayIconsAndTitles objectAtIndex:indexPath.row];
        }
        
    }
    UIImageView * imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15,7,45,45)];
    imgViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIcon.image = [UIImage imageNamed:[objAtRow valueForKey:@"imageName"]];
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Bold" size:15.0];
    //    imgViewIcon.backgroundColor = [UIColor redColor];
    
    
    //    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //    cell.textLabel.text = [objAtRow valueForKey:@"title"];
    //    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    //    cell.textLabel.textColor = [UIColor blackColor];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(70,14,194,28)];
    lblTitle.text = [objAtRow valueForKey:@"title"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.font = [UIFont boldSystemFontOfSize:15];
    lblTitle.textColor = [UIColor blackColor];
    [cell addSubview:lblTitle];
    
    if ([lblTitle.text isEqualToString:@"Sign-in"]) {
        if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
            imgViewIcon.image = [UIImage imageNamed:@"Sign_in1.png"];
            lblTitle.text = @"Sign-in";
            lbl_username.text = @"";
        }
        else{
            imgViewIcon.image = [UIImage imageNamed:@"Sign_out1.png"];
            lblTitle.text = @"Sign-out";
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:imgViewIcon];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""])
    {
        switch (indexPath.row) {
                //    Login
            case 0:{
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                
                [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                    [btn setTitle:@"Sign-in" forState:UIControlStateNormal];
                    lbl_username.text = @"";
                }
                else {
                    [btn setTitle:@"Sign-out" forState:UIControlStateNormal];
                }
                btn.frame = CGRectMake(1, 1, 1, 1);
                [parentController favoritesBtnTaped:btn];
            }
                break;
                
                
                
//                //    Filter
//            case 1:{
//                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
//                [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
//                [parentController addFilterPickerController];
//                [parentController filterBtnTaped:nil];
//            }
//                break;
                
                //                //    Invitation
                //            case 3:{
                //
                //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                //                CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
                //                [appDelegate.window.rootViewController.view addSubview:invitaionPopup];
                //            }
                //                break;
                
                //    Business invitation code
                
            case 1:{
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                
                //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                //                CTBusinessinvitatcodeView *BussinessinvitPopup = [[CTBusinessinvitatcodeView alloc]init];
                //                [appDelegate.window.rootViewController.view addSubview:BussinessinvitPopup];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"InvitationBussiness" object:nil];
                
            }
                break;
                
                //                //    Guide
                //            case 5:{
                //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                //                [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
                //                [parentController showMaskImage:nil];
                //            }
                //                break;
                
            case 2:{
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                [parentController didTapOnShowLegend];
                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                
            }
                break;
                
                //    Support
            case 3:{
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
                CTSupportviewViewController * mysupport = [[CTSupportviewViewController alloc] initWithNibName:@"CTSupportviewViewController" bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mysupport];
                mysupport.delegate = parentController;
                mysupport.navigationItem.leftBarButtonItem = [self backButton];
                //mysupport.navigationItem.title = @"Address Search";
                mysupport.navigationItem.title = @"Support";
                [UIView animateWithDuration:0.1 animations:^{
                    
                    [parentController presentViewController:nav animated:YES completion:nil];
                    
                } completion:^(BOOL finished) {
                    
                    [mysupport.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            switch (indexPath.row) {
                    //Login
                case 0:{
                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        [btn setTitle:@"Sign-in" forState:UIControlStateNormal];
                        lbl_username.text = @"";
                    }
                    else {
                        
                        [btn setTitle:@"Sign-out" forState:UIControlStateNormal];
                    }
                    btn.frame = CGRectMake(1, 1, 1, 1);
                    [parentController favoritesBtnTaped:btn];
                    
                }
                    break;
                    
                    //    Ad Alert
                case 1:{
                    
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdAlertViewOpen:) name:@"AdAlertViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTAdAlertView * myadalert = [[CTAdAlertView alloc] initWithNibName:@"CTAdAlertView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myadalert];
                            
                            myadalert.delegate = parentController;
                            myadalert.navigationItem.leftBarButtonItem = [self backButton];
                            //myadalert.navigationItem.title = @"Ad Alert";
                            myadalert.navigationItem.title = @"Breaking News";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                    //    Promotion
                case 2:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"2";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PromotionViewOpen:) name:@"PromotionViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController1" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
                            promotion.delegate = parentController;
                            promotion.navigationItem.leftBarButtonItem = [self backButton];
                            promotion.navigationItem.title = @"Create Promotion";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    //    Promotion Activate
                case 3:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivtePromotionViewOpen:) name:@"ActivePromotionViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTActivatePromotionView * activepromotion = [[CTActivatePromotionView alloc] initWithNibName:@"CTActivatePromotionView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activepromotion];
                            activepromotion.delegate = parentController;
                            activepromotion.navigationItem.leftBarButtonItem = [self backButton];
                            activepromotion.navigationItem.title = @"Activate Promotion";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [activepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                    }
                }
                    break;
                    //    Promotion DeActivate
                case 4:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DectivatePromotionViewOpen:) name:@"DeactivePromotionViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTDeactivatePromotionView * deactivatepromotion = [[CTDeactivatePromotionView alloc] initWithNibName:@"CTDeactivatePromotionView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deactivatepromotion];
                            deactivatepromotion.delegate = parentController;
                            deactivatepromotion.navigationItem.leftBarButtonItem = [self backButton];
                            deactivatepromotion.navigationItem.title = @"Deactivate Promotion";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [deactivatepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                    //    Event
                case 5:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventViewOpen:) name:@"CreateEventViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTEventViewController * Event = [[CTEventViewController alloc] initWithNibName:@"CTEventViewController" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Event];
                            Event.delegate = parentController;
                            Event.navigationItem.leftBarButtonItem = [self backButton];
                            Event.navigationItem.title = @"Create Event";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    //    Event Activate
                case 6:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"6";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PromotionViewOpen:) name:@"PromotionViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTActivateEventView * activate = [[CTActivateEventView alloc] initWithNibName:@"CTActivateEventView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activate];
                            activate.delegate = parentController;
                            activate.navigationItem.leftBarButtonItem = [self backButton];
                            activate.navigationItem.title = @"Activate Event";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [activate.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                    }
                }
                    break;
                    //    Event DeActivate
                case 7:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"7";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeactivateEventViewOpen:) name:@"DeactivateEventViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTDeactivateEventView * deactivateEvent = [[CTDeactivateEventView alloc] initWithNibName:@"CTDeactivateEventView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deactivateEvent];
                            deactivateEvent.delegate = parentController;
                            deactivateEvent.navigationItem.leftBarButtonItem = [self backButton];
                            deactivateEvent.navigationItem.title = @"Deactivate Event";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [deactivateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                    //    Campaign
                case 8:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"8";
                    CTCampaignViewController * Campaign = [[CTCampaignViewController alloc] initWithNibName:@"CTCampaignViewController" bundle:nil];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Campaign];
                    Campaign.navigationItem.leftBarButtonItem = [self backButton];
                    //Campaign.delegate = parentController;
                    Campaign.navigationItem.title = @"Create campaign";
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        
                        //[Campaign.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                    break;
                    
                    
                    //    Poll
                    //            case 8:{
                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"8";
                    //                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PollContestViewOpen:) name:@"PollViewOpen" object:nil];
                    //                if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                    //
                    //                    [parentController loginPopUpOpen];
                    //                }
                    //                else{
                    //                    if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                    //                    {
                    //                        [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                    //                    }
                    //                    else{
                    //                        CTPollContestViewController * pollView = [[CTPollContestViewController alloc] initWithNibName:@"CTPollContestViewController" bundle:nil];
                    //                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pollView];
                    //                        pollView.delegate = parentController;
                    //                        pollView.navigationItem.leftBarButtonItem = [self backButton];
                    //                        pollView.navigationItem.title = @"Interactive AD";
                    //                        [UIView animateWithDuration:0.1 animations:^{
                    //
                    //                            [parentController presentViewController:nav animated:YES completion:nil];
                    //
                    //                        } completion:^(BOOL finished) {
                    //
                    //                            [pollView.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    //                        }];
                    //                    }
                    //
                    //                }
                    //            }
                    //                break;
                    
                    
                    
//                    //    Filter
//                case 9:{
//                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
//                    [CTCommonMethods sharedInstance].IdentifierNoti = @"9";
//                    [parentController filterBtnTaped:nil];
//                }
//                    break;
                    
                    //                //    Invitation
                    //            case 3:{
                    //
                    //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    //                CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
                    //                [appDelegate.window.rootViewController.view addSubview:invitaionPopup];
                    //            }
                    //                break;
                    
                    //    Business invitation code
                    //                case 9:{
                    //
                    //                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //
                    //                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    //                    //                CTBusinessinvitatcodeView *BussinessinvitPopup = [[CTBusinessinvitatcodeView alloc]init];
                    //                    //                [appDelegate.window.rootViewController.view addSubview:BussinessinvitPopup];
                    //
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InvitationBussiness" object:nil];
                    //
                    //                }
                    //                    break;
                    
                    
                    //                //    Guide
                    //            case 5:{
                    //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
                    //                [parentController showMaskImage:nil];
                    //            }
                    //                break;
                    //    Legend
                case 9:{
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    [parentController didTapOnShowLegend];
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"10";
                    
                }
                    break;
                    
                    //    Support
                case 10:{
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"11";
                    CTSupportviewViewController * mysupport = [[CTSupportviewViewController alloc] initWithNibName:@"CTSupportviewViewController" bundle:nil];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mysupport];
                    mysupport.delegate = parentController;
                    mysupport.navigationItem.leftBarButtonItem = [self backButton];
                    //mysupport.navigationItem.title = @"Address Search";
                    mysupport.navigationItem.title = @"Support";
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        
                        [mysupport.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row) {
                    //    Login
                case 0:{
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        [btn setTitle:@"Sign-in" forState:UIControlStateNormal];
                        lbl_username.text = @"";
                    }
                    else {
                        [btn setTitle:@"Sign-out" forState:UIControlStateNormal];
                    }
                    btn.frame = CGRectMake(1, 1, 1, 1);
                    [parentController favoritesBtnTaped:btn];
                }
                    break;
                    
                    
                    
//                    //    Filter
//                case 1:{
//                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
//                    [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
//                    [parentController filterBtnTaped:nil];
//                }
//                    break;
                    
                    //                //    Invitation
                    //            case 3:{
                    //
                    //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    //                CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
                    //                [appDelegate.window.rootViewController.view addSubview:invitaionPopup];
                    //            }
                    //                break;
                    
                    //    Business invitation code
                    
                    //                case 2:{
                    //
                    //                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //
                    //                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    //                    //                CTBusinessinvitatcodeView *BussinessinvitPopup = [[CTBusinessinvitatcodeView alloc]init];
                    //                    //                [appDelegate.window.rootViewController.view addSubview:BussinessinvitPopup];
                    //
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InvitationBussiness" object:nil];
                    //
                    //                }
                    //                    break;
                    
                    //                //    Guide
                    //            case 5:{
                    //                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    //                [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
                    //                [parentController showMaskImage:nil];
                    //            }
                    //                break;
                    
                case 1:{
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    [parentController didTapOnShowLegend];
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"2";
                    
                }
                    break;
                    
                    //    Support
                case 2:{
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuScreen" object:nil];
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
                    CTSupportviewViewController * mysupport = [[CTSupportviewViewController alloc] initWithNibName:@"CTSupportviewViewController" bundle:nil];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mysupport];
                    mysupport.delegate = parentController;
                    mysupport.navigationItem.leftBarButtonItem = [self backButton];
                    //mysupport.navigationItem.title = @"Address Search";
                    mysupport.navigationItem.title = @"Support";
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        
                        [mysupport.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                    break;
                    
                case 3:{
                    
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdAlertViewOpen:) name:@"AdAlertViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTAdAlertView * myadalert = [[CTAdAlertView alloc] initWithNibName:@"CTAdAlertView" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myadalert];
                            
                            myadalert.delegate = parentController;
                            myadalert.navigationItem.leftBarButtonItem = [self backButton];
                            //myadalert.navigationItem.title = @"Ad Alert";
                            myadalert.navigationItem.title = @"Breaking News";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                case 4:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"6";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventViewOpen:) name:@"CreateEventViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTEventViewController * Event = [[CTEventViewController alloc] initWithNibName:@"CTEventViewController" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Event];
                            Event.delegate = parentController;
                            Event.navigationItem.leftBarButtonItem = [self backButton];
                            Event.navigationItem.title = @"Create Event";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                    }
                }
                    break;
                    
                case 5:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"7";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PromotionViewOpen:) name:@"PromotionViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController1" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
                            promotion.delegate = parentController;
                            promotion.navigationItem.leftBarButtonItem = [self backButton];
                            promotion.navigationItem.title = @"Create Promotion";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                case 6:{
                    [CTCommonMethods sharedInstance].IdentifierNoti = @"8";
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PollContestViewOpen:) name:@"PollViewOpen" object:nil];
                    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                        
                        [parentController loginPopUpOpen];
                    }
                    else{
                        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
                        {
                            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                        }
                        else{
                            CTPollContestViewController * pollView = [[CTPollContestViewController alloc] initWithNibName:@"CTPollContestViewController" bundle:nil];
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pollView];
                            pollView.delegate = parentController;
                            pollView.navigationItem.leftBarButtonItem = [self backButton];
                            pollView.navigationItem.title = @"Interactive AD";
                            [UIView animateWithDuration:0.1 animations:^{
                                
                                [parentController presentViewController:nav animated:YES completion:nil];
                                
                            } completion:^(BOOL finished) {
                                
                                [pollView.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }];
                        }
                        
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
}

-(void)didTapBackButtonOnFavorites:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
}

-(void)myallnew :(NSMutableArray *)ImageArray1 :(NSMutableArray *)DisplayName1 :(int)p : (int)q
{
    [[self.scroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int x=5;
    int y=5;
    
    //int l = 1;
    for (int i = 0; i<ImageArray1.count; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, p, q)];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        
        img.image =[UIImage imageNamed:ImageArray1[i]];
        
        // img.backgroundColor = [UIColor greenColor];
        
        [btn addSubview:img];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 30)];
        lbl.font = [UIFont boldSystemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 2;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.text = DisplayName1[i];
        lbl.textColor = [UIColor blackColor];
        
        [btn addSubview:lbl];
        
        //btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.tag = i;
        NSLog(@"btn %d",btn.tag);
        
        
        [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scroll addSubview:btn];
        
        if (x>150)
        {
            x=5;
            y=y+p+5;
        }
        else
        {
            x=x+q+5;
        }
    }
    
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, y);
}

-(IBAction)btnSelected:(id)sender
{
    NSLog(@"hello");
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
