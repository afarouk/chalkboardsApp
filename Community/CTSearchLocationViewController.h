//
//  CTSearchLocationViewController.h
//  Community
//
//  Created by practice on 27/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CTSearchLocationViewControllerDelegate <NSObject>
@end
typedef void(^SearchQueryCallBack)(NSString *street,NSString* city, NSString* zipCode);
@interface CTSearchLocationViewController : UITableViewController {
    NSString *streetName,*cityName,*zipCode;
    id rootNavController;
}
@property (nonatomic,copy) SearchQueryCallBack callBack;
@property(nonatomic,assign) id<CTSearchLocationViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;
@property(nonatomic,strong) NSString *streetName,*cityName,*zipCode;
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)rootNavController;
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)rootNavController;
-(BOOL)isVisible;
-(void)resignAllTextFieldResponders;
@end
