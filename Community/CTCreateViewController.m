//
//  CTCreateViewController.m
//  Community
//
//  Created by My Mac on 28/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTCreateViewController.h"
#import "CTCommonMethods.h"
#import "CTParentViewController.h"
#import "CTAdAlertView.h"
#import "ImageNamesFile.h"


@interface CTCreateViewController ()

@end

@implementation CTCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Ownimg = [[NSMutableArray alloc]initWithObjects:@"Ad_alert.png", @"Event_Create.png",@"Event_Activate.png",@"Event_Deactivate.png",@"Promotion_Create.png",@"Promotion-Activate.png",@"Promotion_Deactivate.png",@"Contest_Poll.png",nil];
    OwnName = [[NSMutableArray alloc]initWithObjects:@"Ad Alert",@"Event",@"Activate Event",@"Deactivate Event",@"Promotion",@"Activate Promotion",@"Deactivate Promotion",@"Intractive AD(poll)", nil];
    
    
    Cusimg = [[NSMutableArray alloc]initWithObjects:@"Ad_alert.png", @"Event_Create.png",@"Promotion_Create.png",@"Contest_Poll.png",nil];
    
    CusName = [[NSMutableArray alloc]initWithObjects:@"Ad Alert",@"Event",@"Promotion",@"Intractive AD(poll)", nil];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.0f)
    {
        NSLog(@"iphone4");
        
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            [self myallnew:Ownimg :OwnName :100 :100];
        }
        
        else
        {
            [self myallnew:Cusimg :CusName :100 :100];
        }
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 736.0f)
    {
        NSLog(@"iphone6 + First View");
        
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            [self myallnew:Ownimg :OwnName :135 :135];
        }
        
        else
        {
            [self myallnew:Cusimg :CusName :135 :135];
        }
        
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0f)
    {
        NSLog(@"iphone6");
        
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            [self myallnew:Ownimg :OwnName :120 :120];
        }
        
        else
        {
            [self myallnew:Cusimg :CusName :120 :120];
        }
    }
    
    else if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        NSLog(@"iphone5");
        
        if ([CTCommonMethods sharedInstance].OWNERFLAG == YES)
        {
            [self myallnew:Ownimg :OwnName :100 :100];
        }
        
        else
        {
            [self myallnew:Cusimg :CusName :100 :100];
        }
        
    }

    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];


    // Do any additional setup after loading the view from its nib.
}

-(void)myallnew :(NSMutableArray *)ImageArray1 :(NSMutableArray *)DisplayName1 :(int)p : (int)q
{
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
        
        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
            
        {
            
            [btn addTarget:self action:@selector(btnSelectedNew:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        else
            
        {
            
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
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

-(IBAction)btnSelected:(UIButton *)sender
{
    //NSLog(@"hello");
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    switch (sender.tag)
    {
        case 0:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
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
                    myadalert.navigationItem.title = @"Ad Alert";
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        
                        [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
        }
            break;
            
        case 1:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
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
            
        case 2:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"2";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivateEventViewOpen:) name:@"ActivateEventViewOpen" object:nil];
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                
                [parentController loginPopUpOpen];
            }
            else{
                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                {
                    [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                }
                else{
                    CTActivateEventView * activateEvent = [[CTActivateEventView alloc] initWithNibName:@"CTActivateEventView" bundle:nil];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activateEvent];
                    activateEvent.delegate = parentController;
                    activateEvent.navigationItem.leftBarButtonItem = [self backButton];
                    activateEvent.navigationItem.title = @"Activate Event";
                    [UIView animateWithDuration:0.1 animations:^{
                        
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        
                        [activateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
        }
            break;
            
        case 3:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
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
            
        case 4:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
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
            
        case 5:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
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
            
        case 6:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"6";
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
            
        case 7:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"7";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PollContestViewOpen:) name:@"PollViewOpen" object:nil];
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                
                [parentController loginPopUpOpen];
            }
            else{
                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
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

-(IBAction)btnSelectedNew:(UIButton *)sender

{
    
    //NSLog(@"hello");
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    switch (sender.tag)
    
    {
            
        case 0:
            
        {
            
            [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdAlertViewOpen:) name:@"AdAlertViewOpen" object:nil];
            
            //            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
            
            //
            
            //                [parentController loginPopUpOpen];
            
            //            }
            
            //else{
            
            //                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
            
            //                {
            
            //                    [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
            
            //                }
            
            //                else{
            
            CTAdAlertView * myadalert = [[CTAdAlertView alloc] initWithNibName:@"CTAdAlertView" bundle:nil];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myadalert];
            
            
            
            myadalert.delegate = parentController;
            
            myadalert.navigationItem.leftBarButtonItem = [self backButton];
            
            myadalert.navigationItem.title = @"Ad Alert";
            
            [UIView animateWithDuration:0.1 animations:^{
                
                
                
                [parentController presentViewController:nav animated:YES completion:nil];
                
                
                
            } completion:^(BOOL finished) {
                
                
                
                [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                
            }];
            
            //}
            
            
            
            //}
            
        }
            
            break;
            
            
            
        case 1:
            
        {
            
            [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventViewOpen:) name:@"CreateEventViewOpen" object:nil];
            
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                
                
                
                [parentController loginPopUpOpen];
                
            }
            
            else{
                
                //                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                
                //                {
                
                //                    [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                
                //                }
                
                //                else{
                
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
                
                //}
                
                
                
            }
            
        }
            
            break;
            
            
            
        case 2:
            
        {
            
            [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PromotionViewOpen:) name:@"PromotionViewOpen" object:nil];
            
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                
                
                
                [parentController loginPopUpOpen];
                
            }
            
            else{
                
                //                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                
                //                {
                
                //                    [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                
                //                }
                
                //                else{
                
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
                
                //}
                
                
                
            }
            
        }
            
            break;
            
            
            
            
            
        case 3:
            
        {
            
            [CTCommonMethods sharedInstance].IdentifierNoti = @"7";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PollContestViewOpen:) name:@"PollViewOpen" object:nil];
            
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                
                
                
                [parentController loginPopUpOpen];
                
            }
            
            else{
                
                //                if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
                
                //                {
                
                //                    [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
                
                //                }
                
                //                else{
                
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
                
                //}
                
                
                
            }
            
        }
            
            break;
            
            
            
        default:
            
            break;
            
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
