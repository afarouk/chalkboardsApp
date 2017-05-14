//
//  CTLocationSearchPopup.m
//  Community
//
//  Created by practice on 27/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTLocationSearchPopup.h"

@implementation CTLocationSearchPopup
-(void)hideKeyboard:(id)sender {
    [self endEditing:YES];
}
-(UINavigationBar*)navBarForKeyboard {
    UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@""];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    navItem.rightBarButtonItem = done;
    [nav setItems:[NSArray arrayWithObject:navItem]];
    return nav;
}
- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTLocationSearchPopup" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.streetTextField.inputAccessoryView = [self navBarForKeyboard];
        self.cityTextField.inputAccessoryView = [self navBarForKeyboard];
        self.zipTextField.inputAccessoryView = [self navBarForKeyboard];
        
        if([self.streetTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
            self.streetTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street" attributes:@{NSForegroundColorAttributeName: color}];
            self.cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName: color}];
            self.zipTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip" attributes:@{NSForegroundColorAttributeName: color}];
        }
    }
    return self;
}
#pragma Control Methods
-(IBAction)submitBtnTaped:(id)sender {
    self.callBack(self.streetTextField.text,self.cityTextField.text,self.zipTextField.text);
}
-(IBAction)closeBtnTaped:(id)sender {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
