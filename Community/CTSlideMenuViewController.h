//
//  CTSlideMenuViewController.h
//  Community
//
//  Created by practice on 15/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CTSlideMenuViewController : UITableViewController <UIAlertViewDelegate>{
    id rootNavController;
}
@property(nonatomic,strong) NSMutableArray *rows;

@property (nonatomic, readwrite) BOOL isAdAlertView;

-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController;
-(BOOL)isVisible;
-(void)logoutUserWithUID:(NSString*)uid;
- (void) reloadTableData;
- (void) authenticateUser;
@end
