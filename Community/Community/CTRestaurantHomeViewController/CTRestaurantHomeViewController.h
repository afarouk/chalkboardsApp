//
//  CTRestaurantHomeViewController.h
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRestaurantMenuView.h"
#import "CTOutOfNetworkMenuView.h"
#import "UrlDownloaderOperation.h"
#import "CTFavoritesDataModel.h"
#import <MessageUI/MessageUI.h>
#import "CTHomeLegendViewController.h"
@interface CTRestaurantHomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UrlDownloaderOperationDelegate,CTRestaurantMenuViewDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate> {
    NSOperationQueue *galleryImagesDownloadOperationQueue;
    CTRestaurantMenuView *menuView;
    CTHomeLegendViewController *legendController;
}
@property (nonatomic,retain)id restaurantMenuView;
@property (nonatomic,retain)NSMutableDictionary *restaurantDetailsDict;
-(void)retriveMediaMetaDatabySaSl;
@end
