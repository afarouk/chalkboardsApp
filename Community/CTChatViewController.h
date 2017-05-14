//
//  CTChatViewController.h
//  Community
//
//  Created by practice on 10/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTChatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UIView *writeMessageView;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *messagesArray;
@property(nonatomic,strong) UITextField *messageTextField;
@property(nonatomic,strong) UIButton *sendBtn;
-(void)showMessageViewWithMenuView:(UIView *)_menuView;
@end
