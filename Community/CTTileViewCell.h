//
//  CTTileViewCell.h
//  Community
//
//  Created by practice on 09/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CTTileViewController.h"

@interface CTTileViewCell : UITableViewCell
@property(nonatomic,weak) IBOutlet AsyncImageView *tileImageView,*markerImageView,*iconImageView,*promoimage;
@property(nonatomic,weak) IBOutlet UILabel *titleLabel,*messageLabel,*saslNameLabel,*bgLabel,*PromoLabel;
@property(nonatomic,weak) IBOutlet UIView * startview;
@property (nonatomic, weak) CTTileViewController *parentTableView;
-(void)setRating :(NSString *)rate;
@property (strong, nonatomic) IBOutlet AsyncImageView *shareImg;
@property (strong, nonatomic) IBOutlet UILabel *AdAlertMsg;
@end
