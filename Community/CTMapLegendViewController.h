//
//  CTMapLegendViewController.h
//  Community
//
//  Created by practice on 22/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MapLegendView: UIView
@end
typedef void(^LegendCompletionBlock)(BOOL shown);
@interface CTMapLegendViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate> {
    NSMutableDictionary *legendInfo;
}
@property(weak,nonatomic) IBOutlet UIView *visibleView;
@property(weak,nonatomic) IBOutlet UIView *transparentView;
@property(weak,nonatomic) IBOutlet UIImageView *imageView;
@property(weak,nonatomic) IBOutlet UITableView *tableView;
@property (copy) LegendCompletionBlock completionBlock;
-(IBAction)legendBtnTaped:(id)sender;
-(IBAction)backBtnTaped:(id)sender;
-(void)hideLegend;
-(void)showLegendIfFirstTime;
@end
