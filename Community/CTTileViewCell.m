//
//  CTTileViewCell.m
//  Community
//
//  Created by practice on 09/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTTileViewCell.h"
#import "CTTileViewController.h"

@implementation CTTileViewCell

@synthesize parentTableView,startview;
@synthesize tileImageView,markerImageView,iconImageView,titleLabel,messageLabel,saslNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTTileViewCell111" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        
        self.tileImageView.cellObj = self;
        self.iconImageView.cellObj = self;
        self.tileImageView.asyncImageViewType = AsyncImageViewTypeTileImage;
        self.iconImageView.asyncImageViewType = AsyncImageViewTypeIconImage;
        //self.saslNameLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
        self.bgLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
       // self.PromoLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
        
        
        //[[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self andSubViews:YES];
        
        
        [@[titleLabel,messageLabel,_bgLabel,_PromoLabel
           ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
               [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :14.0];
           }];
        
    }
    return self;
}

-(void)setRating :(NSString *)rate
{
   // UIView * startview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 105, 44)];
    NSInteger getrating = 2 * [rate integerValue];
    int x = 2;
    getrating = [rate integerValue];
    for (int k = 0; k < 10 ; k+=2)
    {
        UIImageView * mystarimage = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 20, 20)];
        if (getrating - k == 1) {
            mystarimage.image = [UIImage imageNamed:@"half-star.png"];
        }
        else if (getrating - k > 1)
        {
            mystarimage.image = [UIImage imageNamed:@"star.png"];
        }
        else
        {
            mystarimage.image = [UIImage imageNamed:@"grey-star.png"];
        }
        [startview addSubview:mystarimage];
        x = x + 22;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

}

@end
