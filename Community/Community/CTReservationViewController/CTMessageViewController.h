//
//  CTMessageViewController.h
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTMessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
-(void)showMessageViewWithMenuView:(UIView *)_menuView;
-(IBAction)backBtnTaped:(id)sender;
@end
