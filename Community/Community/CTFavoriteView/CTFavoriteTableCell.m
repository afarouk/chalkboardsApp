//
//  CTFavoriteTableCell.m
//  Community
//
//  Created by dinesh on 26/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFavoriteTableCell.h"

@implementation CTFavoriteTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
-(void)layoutSubviews {
    [super layoutSubviews];
    [self sendSubviewToBack:self.contentView];

}
@end