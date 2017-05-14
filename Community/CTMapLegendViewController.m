//
//  CTMapLegendViewController.m
//  Community
//
//  Created by practice on 22/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTMapLegendViewController.h"
#import "MBProgressHUD.h"
#import "RedirectNSLogs.h"

// keys for web service
#define kMapLegendKey_IconURL @"url"
#define kMapLegendKey_Title @"title"
#define kMapLegendKey_Markers @"markers"
#define kMapLegendKey_Markers_Name @"item"
#define kMapLegendKey_Markers_MarkerURL @"url"
#define kMapLegendKey_Markers_MarkerImage @"MarkerImage"

#define kOriginXToCheckMovement 0
#define kUserCheckedLegendFirstTimeUserDefaultKey @"kUserCheckedLegendFirstTime"
@implementation MapLegendView
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view =[super hitTest:point withEvent:event];
    if(self.center.x>kOriginXToCheckMovement || [view isKindOfClass:[UIControl class]]) {
        return view;
    }return nil;
}
@end
@interface CTMapLegendViewController ()

@end

@implementation CTMapLegendViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapOnLabel:)];
    gesture.numberOfTapsRequired = 2;
    gesture.cancelsTouchesInView = YES;
    [self.imageView addGestureRecognizer:gesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Scope methods
-(void)didPan:(UIPanGestureRecognizer*)paneGesture {
    static CGPoint origionalCenter;
    static BOOL moveLeft = NO;
    static BOOL initiallyHidden = YES;
    if(paneGesture.state == UIGestureRecognizerStateBegan) {
        origionalCenter = [self  view].center;
        if(self.view.center.x<kOriginXToCheckMovement)
            initiallyHidden = YES;
        else
            initiallyHidden = NO;
    }
    else if(paneGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paneGesture translationInView: self.view];
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
            if(legendInfo == nil || initiallyHidden)
                [self getLegendInfoFromServer];
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
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSString *imageURL = [legendInfo valueForKey:kMapLegendKey_IconURL];
                        imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imageView.image = [UIImage imageWithData:imageData];
                        });
                    });
                    [self.tableView reloadData];
                }
            });

        
        }else if(connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center = CGPointMake((self.view.frame.size.width/2), self.view.center.y);
    } completion:^(BOOL finished) {
        self.transparentView.hidden = NO;
        self.completionBlock(YES);
    }];
}
-(void)hideLegend {
    self.transparentView.hidden = YES;
     NSLog(@"self.view.center %@",NSStringFromCGPoint(self.view.center));
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center = CGPointMake(-((self.view.frame.size.width/2)-(self.visibleView.frame.size.width/2)), self.view.center.y);
        NSLog(@"After self.view.center %@",NSStringFromCGPoint(self.view.center));
        
        switch ([CTCommonMethods getIPhoneVersion]) {
            case iPhone6:{
                self.view.center = CGPointMake(self.view.center.x - (self.view.center.x == -81 ? 0 : 27.5), self.view.center.y);
            }
                break;
            case iPhone6Plus:{
                self.view.center = CGPointMake(self.view.center.x - (self.view.center.x == -100.5 ? 0 : 47), self.view.center.y);
            }
                break;
            default:
                break;
        }
        
        self.view.center = CGPointMake(self.view.center.x - 70
                                       , self.view.center.y);
    } completion:^(BOOL finished) {
//        self.transparentView.hidden = YES;
        self.completionBlock(NO);
    }];
}
-(void)showLegendIfFirstTime {
    if([[NSUserDefaults standardUserDefaults]objectForKey:kUserCheckedLegendFirstTimeUserDefaultKey] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:kUserCheckedLegendFirstTimeUserDefaultKey];
        [self getLegendInfoFromServer];
        [self showLegend];
    }
}
#pragma Control Methods
-(IBAction)legendBtnTaped:(id)sender {
    if(self.view.center.x>kOriginXToCheckMovement)
        [self hideLegend];
    else {
        [self getLegendInfoFromServer];
        [self showLegend];
    }
}
-(IBAction)backBtnTaped:(id)sender {
    [self hideLegend];
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [legendInfo valueForKey:kMapLegendKey_Markers];
    if(array && [array isKindOfClass:[NSArray class]])
        return array.count+1;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIDentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIDentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
    [cell.accessoryView removeFromSuperview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    short index = indexPath.row;
    
    if (index == 0) {
        cell.textLabel.text = @"Happening Now";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];;
    }
    else {
        
        index = index - 1;
        
        NSArray *array = [legendInfo valueForKey:kMapLegendKey_Markers];
        NSMutableDictionary *markerDetails = [array objectAtIndex:index];
        cell.textLabel.text = [NSString stringWithFormat:@"    %@",[markerDetails valueForKey:kMapLegendKey_Markers_Name]];
        
        if ([markerDetails valueForKey:kMapLegendKey_Markers_MarkerImage]) {
            NSData *data = [markerDetails valueForKey:kMapLegendKey_Markers_MarkerImage];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            cell.accessoryView = imageView;
            [cell setNeedsLayout];
        }
        
        else {
            // downoad icon for marker
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSString *urlStr = [markerDetails valueForKey:kMapLegendKey_Markers_MarkerURL];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                // set key for image
                [markerDetails setObject:data forKey:kMapLegendKey_Markers_MarkerImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            });
        }
    }
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section{
//    UIView *viewObj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [tableView rowHeight]+1)];
//    
//    
//}

@end
