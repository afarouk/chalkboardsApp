//
//  CTChooseType.m
//  Community
//
//  Created by My Mac on 21/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTChooseType.h"
#import "CTSignUpPopup.h"
@implementation CTChooseType

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTChooseType" owner:self options:nil] objectAtIndex:0];
    self.frame = [[UIScreen mainScreen] bounds];
    if (self)
    {
        
    }
    
    return self;

}

-(IBAction)BtnBusinessPressed:(id)sender
{
    [self closeView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BusinessOpen" object:nil];
}
-(IBAction)BtnCustomerPressed:(id)sender
{
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTSignUpPopup * Customer = [[CTSignUpPopup alloc] init];
    [appDelegate.window.rootViewController.view addSubview:Customer];
    [self closeView];
}
-(IBAction)closeBtnTaped:(id)sender
{
    [self removeFromSuperview];
}

-(void)closeView
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
