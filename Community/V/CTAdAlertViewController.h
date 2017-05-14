//
//  CTAdAlertViewController.h
//  Community
//
//  Created by BBITS Dev on 29/06/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTAdAlertViewControllerDelegate <NSObject>
-(void)didTapAndGetRestaruantDetailsFromAdAlertController:(NSString*)sa andSL:(NSString*)sl;
-(void)didTapAndGetRestaruantDetailsFromAdAlertController:(id)JSON;
-(void)didTapAndGetRestaruantDetailsFromAdAlertControllerWithURL:(NSString*)url;
@end

@interface CTAdAlertViewController : UIViewController{
    IBOutlet UITableView *tblViewAdAlert;
    id rootController;
}

@property (nonatomic, retain) id arrAdAlertData;
@property(nonatomic,assign) id<CTAdAlertViewControllerDelegate> delegate;
@property (nonatomic, retain) id callerSender;

-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController;
-(BOOL)isVisible;
-(void)reloadTableData;


@end

@interface ABCD : CTAdAlertViewController

@end
