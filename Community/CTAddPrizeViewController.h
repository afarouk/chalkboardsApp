//
//  CTAddPrizeViewController.h
//  Community
//
//  Created by My Mac on 01/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPollContestViewController.h"

@interface CTAddPrizeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,CTImageAddDelegate>
{
    IBOutlet UITextField * txtQty;
    IBOutlet UITextField * txtPrizename;
    
    IBOutlet UIButton * btnaddImage;
    IBOutlet UIButton * btnadd;
    
    IBOutlet UIImageView *img_addimage;
    
    
    
    NSMutableArray * QTY;
    NSMutableArray * PrizeName;
    NSMutableArray * Image;
    
    NSMutableArray *arrPrizes;
    CTPollContestViewController * pollcontestview;
    
    int movementDistance ;
    CGFloat animatedDistance;
    id rootNavController;
}
@property(nonatomic,retain)NSString * UUIDpoll;
@property(nonatomic,retain) IBOutlet UITableView *tbl_prize;
@property(nonatomic,strong) id listofPrize;
- (IBAction)ImagePressedButton:(id)sender;
- (IBAction)AddPressedButton:(id)sender;
- (void)reloadPollValues;

@end
