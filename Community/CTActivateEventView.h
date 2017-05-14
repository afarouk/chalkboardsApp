//
//  CTActivateEventView.h
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTActivateEventViewControllerDelegate <NSObject>
@end

@interface CTActivateEventView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * listofStatus;
    NSMutableArray * listofEventName;
    NSMutableArray * listofStartdate;
    NSMutableArray * listofEventId;
    
    IBOutlet UITableView * tbl_Activate;
}

@property(nonatomic,assign) id<CTActivateEventViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;


@end
