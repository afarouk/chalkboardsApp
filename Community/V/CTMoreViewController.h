//
//  CTMoreViewController.h
//  Community
//
//  Created by BBITS Dev on 28/09/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapLegendView1: UIView
@end
typedef void(^LegendCompletionBlock12)(BOOL shown);
@interface CTMoreViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSMutableDictionary *legendInfo;
    NSArray *arrayIconsAndTitles;
}
@property(weak,nonatomic) IBOutlet UIView *visibleView;
@property(weak,nonatomic) IBOutlet UIView *transparentView;
@property(weak,nonatomic) IBOutlet UIImageView *imageView;
@property(weak,nonatomic) IBOutlet UITableView *tableView;
@property(weak,nonatomic) IBOutlet UIButton *btnLegend;
@property (copy) LegendCompletionBlock12 completionBlock;
-(IBAction)legendBtnTaped:(id)sender;
-(IBAction)backBtnTaped:(id)sender;
-(void)hideLegend;
-(void)showLegendIfFirstTime;
@end