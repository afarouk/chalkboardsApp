//
//  CTAddPrizeTableViewCell.m
//  Community
//
//  Created by My Mac on 02/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTAddPrizeTableViewCell.h"

@implementation CTAddPrizeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.txt_prizename setEnabled:NO];

    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self andSubViews:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
