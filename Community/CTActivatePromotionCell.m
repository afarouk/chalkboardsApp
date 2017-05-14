//
//  CTActivatePromotionCell.m
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTActivatePromotionCell.h"
#import "CTCommonMethods.h"

@implementation CTActivatePromotionCell

- (void)awakeFromNib {
    // Initialization code
    [@[self.btnActivate
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];

    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self andSubViews:YES];
    
    
    [@[_lblFirst,_lblSecond
       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
       }];
    
    _lblback.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
