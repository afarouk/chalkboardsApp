//
//  CTFavoriteTableCell.h
//  Community
//
//  Created by dinesh on 26/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTFavoriteTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mapMarkerIcon;
@property (weak, nonatomic) IBOutlet UILabel *miles;

@property (weak, nonatomic) IBOutlet UIImageView *ratingImg;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImg;
@property (weak, nonatomic) IBOutlet UILabel *km;
@property (weak, nonatomic) IBOutlet UILabel *notificationCount;
@property(weak,nonatomic) IBOutlet UILabel *nameLabel;
@end
