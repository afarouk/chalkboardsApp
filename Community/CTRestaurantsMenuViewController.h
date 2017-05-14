//
//  CTRestaurantsViewController.h
//  Community
//
//  Created by practice on 16/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTRestaurantsMenuViewController : UITableViewController {
    id rootNavController;
    
}
@property(nonatomic,assign) id<CTGetRestaurantsDelegate> delegate;
@property (nonatomic, retain) id callerSender;
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(BOOL)isVisible;
@end
