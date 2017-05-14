//
//  CTActivateEventCell.m
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTActivateEventCell.h"

@implementation CTActivateEventCell

- (void)awakeFromNib {
    // Initialization code
    [@[self.btnActivate
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [@[_lblEventDate,_lblEventName,_lblStatus
       ] enumerateObjectsUsingBlock:^(UILabel *btn, NSUInteger idx, BOOL *stop) {
            [[CTCommonMethods sharedInstance]applyFontLabel:btn :@"Lato-Regular" :15.0];
      }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self andSubViews:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
