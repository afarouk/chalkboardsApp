//
//  CTSlideRestaurantCell.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CTSlideRestaurantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *miles;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImgView;
@property (weak, nonatomic) IBOutlet UILabel *kilometers;
@property (weak, nonatomic) IBOutlet UIImageView *markerIcon;

@end
