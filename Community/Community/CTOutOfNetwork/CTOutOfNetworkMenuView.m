//
//  CTOutOfNetworkMenuView.m
//  Community
//
//  Created by dinesh on 12/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTOutOfNetworkMenuView.h"

@implementation CTOutOfNetworkMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTOutOfNeworkMenuView" owner:self options:nil];
        self=[nib objectAtIndex:0];
        self.backgroundColor=[UIColor clearColor];
        self.frame=CGRectMake(-90, 0, self.frame.size.width, self.frame.size.height);
        self.menuHolderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    }
    return self;
}

- (IBAction)tabAction:(id)sender {
    if(!self.isSlideOut){
        self.isSlideOut=YES;
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.frame=CGRectOffset(self.frame, 90, 0);
        [UIView commitAnimations];
        
    }else{
        self.isSlideOut=NO;
        [UIView beginAnimations:@"slideAnim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.frame=CGRectOffset(self.frame, -90, 0);
        [UIView commitAnimations];
    }
}
- (IBAction)map:(id)sender {
}

- (IBAction)call:(id)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:1234567890"]];
}
@end
