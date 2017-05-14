//
//  CTFavoritesViewController.h
//  Community
//
//  Created by practice on 16/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTFavoritesDataModel.h"
@protocol CTFavoritesMenuViewControllerDelegate <NSObject>
-(void)didTapAndGetRestaruantDetailsFromFavoritesController:(NSString*)sa andSL:(NSString*)sl;
-(void)didTapAndGetRestaruantDetailsFromFavoritesController:(id)JSON;
@end
@interface CTFavoritesMenuViewController : UITableViewController {
    NSMutableArray *favoritesArray;
    id rootNavController;
}
@property(nonatomic,assign) id<CTFavoritesMenuViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController;
-(BOOL)isVisible;
-(void)retriveFavorite;
@end
