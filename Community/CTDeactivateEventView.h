//
//  CTDeactivateEventView.h
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTDeactivateEventViewControllerDelegate <NSObject>
@end
@interface CTDeactivateEventView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * listofStatus;
    NSMutableArray * listofEventName;
    NSMutableArray * listofStartdate;
    NSMutableArray * listofEventId;
    
    IBOutlet UITableView * tbl_Activate;
}
@property(nonatomic,assign) id<CTDeactivateEventViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

@end
