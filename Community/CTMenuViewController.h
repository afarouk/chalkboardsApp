//
//  CTMenuViewController.h
//  Community
//
//  Created by My Mac on 28/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol CTMenuViewDelegate <NSObject>
@end
@interface CTMenuViewController : UIViewController<MJSecondPopupDelegate>
{
    NSMutableArray *imgArray;
    NSMutableArray *NameArray;
    NSArray *arrayIconsAndTitles;
    NSArray *arrayIconsAndTitles2;
    NSArray *arrayIconsAndTitles3;
    
    IBOutlet UILabel *lbl_username;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UITableView *Tbl_Menu;
@property(nonatomic,assign) id<CTMenuViewDelegate> delegate;
@property (nonatomic, retain) id callerSender;
@property (nonatomic, retain) IBOutlet UIButton * btnblack;
-(IBAction)btnBackButtonPressed:(id)sender;
@end
