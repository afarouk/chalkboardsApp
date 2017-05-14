//
//  CTFavoriteView.h
//  Community
//
//  Created by dinesh on 25/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CTFavoriteViewDelegate <NSObject>
-(void)didTapOnFavoriteView;
@end
@interface CTFavoriteView : UIView<UITableViewDelegate,UITableViewDataSource> 
@property(nonatomic,assign) id<CTFavoriteViewDelegate> delegate;
@property (nonatomic,retain)IBOutlet UITableView *favoriteRestaurantListTableView;
@property (nonatomic,weak)IBOutlet UIButton *closeButton;
@property (nonatomic,weak)IBOutlet UIImageView *closeIcon;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UIView *container,*gestureView;
@property (nonatomic,retain)NSDictionary *favoriteDict;
-(IBAction)close:(id)sender;
-(void)enableHitDetectionArea;
-(void)disableHitDetectionArea;
@end
