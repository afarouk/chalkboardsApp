//
//  CTYelpReviewCell.m
//  Community
//
//  Created by dinesh on 16/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTYelpReviewCell.h"

@implementation CTYelpReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    self = [[[NSBundle mainBundle]loadNibNamed:@"CTYelpReviewCell" owner:self options:nil] objectAtIndex:0];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
