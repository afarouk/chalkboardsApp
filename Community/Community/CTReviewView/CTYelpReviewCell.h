//
//  CTYelpReviewCell.h
//  Community
//
//  Created by dinesh on 16/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTYelpReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *reviewTxt;
@property(nonatomic,strong) IBOutletCollection(UIImageView) NSArray* ratingImageViews;

@end
