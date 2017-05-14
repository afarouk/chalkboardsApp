//
//  CTSlideRestaurantListView.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CTSlideRestaurantListView.h"
#import <CoreLocation/CoreLocation.h>
@protocol CTCTSlideRestaurantListViewDelegate <NSObject>
-(void)didTapOnSlideRestaurantListView;
@end
@interface CTSlideRestaurantListView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    UIView *container;
    UIView *gestureView;
}
@property(nonatomic,assign) id<CTCTSlideRestaurantListViewDelegate> delegate;
@property (nonatomic,retain)IBOutlet UIView *view;
@property (nonatomic,retain)IBOutlet UITableView *restaurantListTableView;
@property (nonatomic,strong)UINavigationController *navigationController;
@property (nonatomic,strong)CTSlideRestaurantListView *slideRestaurantListView;
//@property (nonatomic,retain)NSMutableArray *ratingImageUrlArray;
//@property (nonatomic,retain)NSMutableArray *mapIconArray;
//@property (nonatomic,retain)NSArray *saslResturantSummary;
//@property (nonatomic,retain)NSMutableArray *restaurantListArray;


-(void)getSaslResturantSummary;
-(void)enableHitDetectionArea;
-(void)disableHitDetectionArea;
@end
