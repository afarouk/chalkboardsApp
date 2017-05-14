//
//  CTMoreViewController.m
//  Community
//
//  Created by BBITS Dev on 28/09/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTMoreViewController.h"
#import "MBProgressHUD.h"
#import "CTAppDelegate.h"
#import "CTParentViewController.h"
#import "CTInviteView.h"
#import "ImageNamesFile.h"
#import "CTAdAlertView.h"
#import "CTEventViewController.h"
#import "CTPromotionViewController.h"
#import "CTPollContestViewController.h"
#import "CTActivatePromotionView.h"
#import "CTDeactivatePromotionView.h"
#import "CTActivateEventView.h"
#import "CTDeactivateEventView.h"

// keys for web service
//#define kMapLegendKey_IconURL @"url"
//#define kMapLegendKey_Title @"title"
//#define kMapLegendKey_Markers @"markers"
//#define kMapLegendKey_Markers_Name @"item"
//#define kMapLegendKey_Markers_MarkerURL @"url"
//#define kMapLegendKey_Markers_MarkerImage @"MarkerImage"

#define kOriginXToCheckMovement -20
#define kUserCheckedLegendFirstTimeUserDefaultKey @"kUserCheckedLegendFirstTime"


@implementation MapLegendView1
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view =[super hitTest:point withEvent:event];
    if(self.center.x>kOriginXToCheckMovement || [view isKindOfClass:[UIControl class]]) {
        return view;
    }return nil;
}
@end

@interface CTMoreViewController (){
    CGFloat imgHeight, lblHeight, topOffset;
    __block CGRect originalRect;
}

@end

@implementation CTMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // add tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnTransparentView:)];
    [self.transparentView addGestureRecognizer:tap];
    tap.delegate = self;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;

    arrayIconsAndTitles = @[
                            @{
                                @"imageName":@"180X180.png",
                                @"title":@"Legend"
                                },
                            @{
                                @"imageName": ([CTCommonMethods UID] != nil ? @"Sign_in1.png" : @"Sign_out1.png"),
                                @"title":@"Sign-in"
                                },
                            @{
                                @"imageName":@"filter-icon.png",
                                @"title":@"Filter"
                                },
                            @{
                                @"imageName":@"Code.png",
                                @"title":@"Invitation"
                                },
                            @{
                                @"imageName":@"icon-with-question-mark.png",
                                @"title":@"Guide"
                                },
                            @{
                                @"imageName":@"searchIcon.png",
                                @"title":@"Support"
                                },
                            @{
                                @"imageName":@"Ad_alert.png",
                                @"title":@"Ad Alert"
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
                                @"imageName":@"Contest_Poll.png",
                                @"title":@"Interactive AD"
                                }
                            
                            ];

    switch ([CTCommonMethods getIPhoneVersion]) {
        case iPhone6:{
            imgHeight = ([self.tableView frame].size.width / 1.8);
            lblHeight = ([self.tableView frame].size.width / 5);
            topOffset = 6;
        }
            break;
        case iPhone6Plus:{
            imgHeight = ([self.tableView frame].size.width / 1.8);
            lblHeight = ([self.tableView frame].size.width / 5);
            topOffset = 10;
        }
            break;
        case iPhone5:{
            imgHeight = ([self.tableView frame].size.width / 2);
            lblHeight = ([self.tableView frame].size.width / 6);
            topOffset = 8;
        }
            break;
        case iPhone4:{
            imgHeight = ([self.tableView frame].size.width / 2);
            lblHeight = ([self.tableView frame].size.width / 6);
            topOffset = 6;
        }
            break;
        default:
            break;
    }
    originalRect = CGRectZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSuccessfullyLoggedIn:) name:CT_Observers_SuccessfullyLogedIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSuccessfullyLoggedOut:) name:CT_Observers_SuccessfullyLogedOut object:nil];
    
    
}

#pragma mark - Notification Method
#pragma mark ----------- Ad Alert --------------
-(void)AdAlertViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTAdAlertView * myadalert = [[CTAdAlertView alloc] initWithNibName:@"CTAdAlertView" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myadalert];
        
        myadalert.delegate = parentController;
        myadalert.navigationItem.leftBarButtonItem = [self backButton];
        myadalert.navigationItem.title = @"Ad Alert";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

#pragma mark ----------- Event --------------
-(void)EventViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTEventViewController * Event = [[CTEventViewController alloc] initWithNibName:@"CTEventViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Event];
        Event.delegate = parentController;
        Event.navigationItem.leftBarButtonItem = [self backButton];
        Event.navigationItem.title = @"Create Event";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

-(void)ActivateEventViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTActivateEventView * activateEvent = [[CTActivateEventView alloc] initWithNibName:@"CTActivateEventView" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activateEvent];
        activateEvent.delegate = parentController;
        activateEvent.navigationItem.leftBarButtonItem = [self backButton];
        activateEvent.navigationItem.title = @"Activate Event";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [activateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

-(void)DeactivateEventViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTDeactivateEventView * deactivateEvent = [[CTDeactivateEventView alloc] initWithNibName:@"CTDeactivateEventView" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deactivateEvent];
        deactivateEvent.delegate = parentController;
        deactivateEvent.navigationItem.leftBarButtonItem = [self backButton];
        deactivateEvent.navigationItem.title = @"Deactivate Event";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [deactivateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

#pragma mark ----------- Promotion --------------
-(void)PromotionViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTPromotionViewController * promotion = [[CTPromotionViewController alloc] initWithNibName:@"CTPromotionViewController1" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
        promotion.delegate = parentController;
        promotion.navigationItem.leftBarButtonItem = [self backButton];
        promotion.navigationItem.title = @"Create Promotion";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

-(void)ActivtePromotionViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
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
                //                [parentController.navigationController pushViewController:mysupport animated:YES];
                //                [parentController addChildViewController:mysupport];
                //                [parentController.view addSubview:mysupport.view];
                [parentController presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [activepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        
    }
}

-(void)DectivatePromotionViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        if ([CTCommonMethods sharedInstance].OWNERFLAG == NO)
        {
            [[[UIAlertView alloc] initWithTitle:StringAlertTitleNoBusinessImage message:nil delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
        }
        else{
            CTDeactivatePromotionView * deactivepromotion = [[CTDeactivatePromotionView alloc] initWithNibName:@"CTDeactivatePromotionView" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deactivepromotion];
            deactivepromotion.delegate = parentController;
            deactivepromotion.navigationItem.leftBarButtonItem = [self backButton];
            deactivepromotion.navigationItem.title = @"Deactivate Promotion";
            [UIView animateWithDuration:0.1 animations:^{
                //                [parentController.navigationController pushViewController:mysupport animated:YES];
                //                [parentController addChildViewController:mysupport];
                //                [parentController.view addSubview:mysupport.view];
                [parentController presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [deactivepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        
    }
}

#pragma mark ----------- Poll Contest --------------
-(void)PollContestViewOpen :(NSNotification *)note
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
        
        [parentController loginPopUpOpen];
    }
    else{
        CTPollContestViewController * pollView = [[CTPollContestViewController alloc] initWithNibName:@"CTPollContestViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pollView];
        pollView.delegate = parentController;
        pollView.navigationItem.leftBarButtonItem = [self backButton];
        pollView.navigationItem.title = @"Interactive AD";
        [UIView animateWithDuration:0.1 animations:^{
            //                [parentController.navigationController pushViewController:mysupport animated:YES];
            //                [parentController addChildViewController:mysupport];
            //                [parentController.view addSubview:mysupport.view];
            [parentController presentViewController:nav animated:YES completion:nil];
            
        } completion:^(BOOL finished) {
            //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            [pollView.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CT_Observers_SuccessfullyLogedIn object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CT_Observers_SuccessfullyLogedOut object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Scope methods
-(void)didPan:(UIPanGestureRecognizer*)paneGesture {
    static CGPoint origionalCenter;
    static CGPoint originalOrigin;
    static BOOL moveLeft = NO;
    static BOOL initiallyHidden = YES;
    if(paneGesture.state == UIGestureRecognizerStateBegan) {
        origionalCenter = [self  view].center;
        originalOrigin = [self  view].frame.origin;
        if(self.view.center.x<kOriginXToCheckMovement)
            initiallyHidden = YES;
        else
            initiallyHidden = NO;
    }
    else if(paneGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paneGesture translationInView: self.view];

//        switch ([CTCommonMethods getIPhoneVersion]) {
//            case iPhone6:{
//                if(origionalCenter.x+translation.x<=[self view].frame.size.width/2 && [self view].center.x < -40) {
//                    [self view].center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
//                }
//            }
//                break;
//            case iPhone6Plus:{
//                if(origionalCenter.x+translation.x<=[self view].frame.size.width/2 && [self view].center.x < -40) {
//                    [self view].center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
//                }
//            }
//                break;
//            case iPhone5:{
//                if(origionalCenter.x+translation.x<=[self view].frame.size.width/2) {
//                    [self view].center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
//                }
//            }
//                break;
//            case iPhone4:{
//            }
//                break;
//            default:
//                break;
//        }
        if(origionalCenter.x+translation.x<=[self view].frame.size.width/2) {
            [self view].center = CGPointMake(origionalCenter.x+translation.x, origionalCenter.y);
        }
        
        // check direction.
        CGPoint velocity = [paneGesture velocityInView:self.navigationController.view];
        if(velocity.x > kOriginXToCheckMovement)
            moveLeft = NO;
        else
            moveLeft = YES;
    } else if (paneGesture.state == UIGestureRecognizerStateEnded ||
               paneGesture.state == UIGestureRecognizerStateFailed ||
               paneGesture.state == UIGestureRecognizerStateCancelled)
    {
        if(moveLeft)
            [self hideLegend];
        else {
//            if(legendInfo == nil || initiallyHidden)
//                [self getLegendInfoFromServer];
            [self showLegend];
        }
    }
    
    
}
-(void)didTapOnTransparentView:(UITapGestureRecognizer*)tap {
    [self hideLegend];
}
-(void)getLegendInfoFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",[CTCommonMethods getChoosenServer],CT_getLegendInfo];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // validate json
                NSError *jsonError = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSError *validationError = [CTCommonMethods validateJSON:dictionary];
                if(validationError) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:validationError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }else if(jsonError) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:jsonError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }else {
                    // all checks marked
                    legendInfo = [dictionary deepMutableCopy];
                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                        NSString *imageURL = [legendInfo valueForKey:kMapLegendKey_IconURL];
//                        imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.imageView.image = [UIImage imageWithData:imageData];
//                        });
//                    });
                    [self.tableView reloadData];
                }
            });
            
            
        }else if(connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *description = connectionError.localizedDescription;
                if(description.length == 0)
                    description = connectionError.description;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            });
            
        }
    }];
}
-(void)showLegend {
    NSLog(@"self.view.center %@",NSStringFromCGPoint(self.view.center));
    [[self tableView] reloadData];
    if (CGRectEqualToRect(originalRect, CGRectZero)) {
        originalRect = self.view.frame;
    }
    [UIView animateWithDuration:0.3f animations:^{
        //self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.center.y);
        CGRect tempRect = originalRect;
        tempRect.origin.x -= self.visibleView.frame.origin.x;
        self.view.frame = tempRect;
        
        
        switch ([CTCommonMethods getIPhoneVersion]) {
            case iPhone6:{
                CGRect tempRect = originalRect;
                tempRect.origin.x -= (self.visibleView.frame.origin.x +10 + self.btnLegend.frame.size.width/2 - self.visibleView.frame.size.width/2);
                self.view.frame = tempRect;
            }
                break;
            case iPhone6Plus:{
                CGRect tempRect = originalRect;
                tempRect.origin.x -= (self.visibleView.frame.origin.x -10 + self.btnLegend.frame.size.width/2  - self.visibleView.frame.size.width/2);
                self.view.frame = tempRect;
            }
                break;
            case iPhone5:{
                CGRect tempRect = originalRect;
                tempRect.origin.x -= self.visibleView.frame.origin.x;
                self.view.frame = tempRect;
            }
                break;
            case iPhone4:
                break;
            default:
                break;
        }
        
//        NSLog(@"Before self.view.center %@",NSStringFromCGPoint(self.view.center));
    } completion:^(BOOL finished) {
        self.transparentView.hidden = NO;
        self.transparentView.hidden = YES;
        self.completionBlock(YES);
    }];
}
-(void)hideLegend {
    self.transparentView.hidden = YES;
    if (CGRectEqualToRect(originalRect, CGRectZero)) {
        originalRect = self.view.frame;
    }
//    NSLog(@"self.view.center %@",NSStringFromCGPoint(self.view.center));
    [UIView animateWithDuration:0.3f animations:^{
        //self.view.center = CGPointMake(-((self.view.frame.size.width/2)-(self.visibleView.frame.size.width/2)), self.view.center.y);
        CGRect tempRect = originalRect;
//        tempRect.origin.x -= (self.view.frame.size.width - self.btnLegend.frame.origin.x - (self.btnLegend.frame.size.width / 2));
        tempRect.origin.x -= self.btnLegend.frame.origin.x;
        self.view.frame = tempRect;
//        self.view.center = CGPointMake(0+self.btnLegend.frame.size.width, self.view.center.y);
        
        switch ([CTCommonMethods getIPhoneVersion]) {
            case iPhone6:{
//                self.view.center = CGPointMake(self.view.center.x - (self.view.center.x == -81 ? 0 : 27.5), self.view.center.y);
                CGRect tempRect = originalRect;
                tempRect.origin.x -= (self.btnLegend.frame.origin.x - self.btnLegend.frame.size.width/2);
                self.view.frame = tempRect;
            }
                break;
            case iPhone6Plus:{
                CGRect tempRect = originalRect;
                tempRect.origin.x -= (self.btnLegend.frame.origin.x - self.btnLegend.frame.size.width);
                self.view.frame = tempRect;
            }
                break;
            case iPhone5:{
                CGRect tempRect = originalRect;
                tempRect.origin.x -= (8+self.btnLegend.frame.origin.x);
                self.view.frame = tempRect;
            }
                break;
            case iPhone4:
                break;
            default:
                break;
        }
//        NSLog(@"After self.view.center %@",NSStringFromCGPoint(self.view.center));
    } completion:^(BOOL finished) {
        //        self.transparentView.hidden = YES;
        self.completionBlock(NO);
    }];
}
-(void)showLegendIfFirstTime {
    if([[NSUserDefaults standardUserDefaults]objectForKey:kUserCheckedLegendFirstTimeUserDefaultKey] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:kUserCheckedLegendFirstTimeUserDefaultKey];
//        [self getLegendInfoFromServer];
        [self showLegend];
    }
}
#pragma mark - Control Methods

-(IBAction)legendBtnTaped:(id)sender {
    CGFloat xOffset = kOriginXToCheckMovement;
    switch ([CTCommonMethods getIPhoneVersion]) {
        case iPhone6Plus:{
            xOffset = -80;
        }
            break;
            
        case iPhone6:{
            xOffset = -100;
        }
            break;
            
        default:
            break;
    }
    if(self.view.center.x>xOffset)
        [self hideLegend];
    else {
//        [self getLegendInfoFromServer];
        [self showLegend];
    }
}

-(IBAction)backBtnTaped:(id)sender {
    [self hideLegend];
}

-(void)didSuccessfullyLoggedOut:(NSNotification*)notif {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)didSuccessfullyLoggedIn:(NSNotification*)notif {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayIconsAndTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIDentifier = @"Cell";

    CGFloat xOffset = ([tableView frame].size.width - imgHeight)/2;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIDentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
    else
        [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.accessoryView removeFromSuperview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    id objAtRow = [arrayIconsAndTitles objectAtIndex:indexPath.row];
    
    UIImageView * imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset+5, topOffset+5, imgHeight-10, imgHeight-10)];
    imgViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIcon.image = [UIImage imageNamed:[objAtRow valueForKey:@"imageName"]];
    //    imgViewIcon.backgroundColor = [UIColor redColor];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, imgViewIcon.frame.origin.y + imgViewIcon.frame.size.height, imgHeight, lblHeight)];
    lblTitle.text = [objAtRow valueForKey:@"title"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13.];
    lblTitle.textColor = [UIColor whiteColor];
    [cell addSubview:lblTitle];
    
    if ([lblTitle.text isEqualToString:@"Sign-in"]) {
        if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
            imgViewIcon.image = [UIImage imageNamed:@"Sign_in1.png"];
            lblTitle.text = @"Sign-in";
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

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = (topOffset + imgHeight + lblHeight);
    return height;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    
    switch (indexPath.row) {
            
        //    Legend
        case 0:{
            [parentController didTapOnShowLegend];
            [CTCommonMethods sharedInstance].IdentifierNoti = @"0";
        }
            break;
            
        //    Login
        case 1:{
            [CTCommonMethods sharedInstance].IdentifierNoti = @"1";
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([CTCommonMethods UID]==nil || [[CTCommonMethods UID] isEqualToString:@""]) {
                [btn setTitle:@"Sign-in" forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:@"Sign-out" forState:UIControlStateNormal];
            }
            btn.frame = CGRectMake(1, 1, 1, 1);
            [parentController favoritesBtnTaped:btn];
        }
            break;
            
        //    Filter
        case 2:{
            [CTCommonMethods sharedInstance].IdentifierNoti = @"2";
            [parentController filterBtnTaped:nil];
        }
            break;
            
        //    Invitation
        case 3:{
            [CTCommonMethods sharedInstance].IdentifierNoti = @"3";
            CTInviteView *invitaionPopup = [[CTInviteView alloc]init];
            [appDelegate.window.rootViewController.view addSubview:invitaionPopup];
        }
            break;
            
        //    Guide
        case 4:{
            [CTCommonMethods sharedInstance].IdentifierNoti = @"4";
            [parentController showMaskImage:nil];
        }
            break;
            
        //    Support
        case 5:{
            [CTCommonMethods sharedInstance].IdentifierNoti = @"5";
            CTSupportviewViewController * mysupport = [[CTSupportviewViewController alloc] initWithNibName:@"CTSupportviewViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mysupport];
            mysupport.delegate = parentController;
            mysupport.navigationItem.leftBarButtonItem = [self backButton];
            //mysupport.navigationItem.title = @"Address Search";
            mysupport.navigationItem.title = @"Support";
            [UIView animateWithDuration:0.1 animations:^{
//                [parentController.navigationController pushViewController:mysupport animated:YES];
//                [parentController addChildViewController:mysupport];
//                [parentController.view addSubview:mysupport.view];
                [parentController presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [mysupport.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
            break;
            case 6:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"6";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [myadalert.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 7:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"7";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [Event.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 8:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"8";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [activateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 9:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"9";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [deactivateEvent.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 10:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"10";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 11:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"11";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [activepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 12:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"12";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [deactivatepromotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        case 13:
        {
            [CTCommonMethods sharedInstance].IdentifierNoti = @"13";
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
                        //                [parentController.navigationController pushViewController:mysupport animated:YES];
                        //                [parentController addChildViewController:mysupport];
                        //                [parentController.view addSubview:mysupport.view];
                        [parentController presentViewController:nav animated:YES completion:nil];
                        
                    } completion:^(BOOL finished) {
                        //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [pollView.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                    }];
                }
                
            }
            
            
        }
            break;
        default:
            break;
    }
//    if(indexPath.row > 0)
    [self hideLegend];
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

@end
