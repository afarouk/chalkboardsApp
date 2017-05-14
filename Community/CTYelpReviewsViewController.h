//
//  CTYelpReviewsViewController.h
//  Community
//
//  Created by practice on 17/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTWriteReviewViewController.h"
@interface CTYelpReviewsViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIView* menuView;
    UIView* writeMessageView;
    CTWriteReviewViewController *writeView;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSArray* reviewArray;
@property(nonatomic,strong) NSMutableArray *ratingImageUrlArray;
@property(nonatomic,strong) UITextField *messageTextField;
-(void)showYelpReviewViewWithMenuView:(UIView*)_menuView;
- (IBAction)writeReview:(id)sender;
@end
