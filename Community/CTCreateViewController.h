//
//  CTCreateViewController.h
//  Community
//
//  Created by My Mac on 28/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CTCreateViewDelegate <NSObject>
@end
@interface CTCreateViewController : UIViewController
{
    NSMutableArray *Ownimg;
    NSMutableArray *OwnName;
    NSMutableArray *Cusimg;
    NSMutableArray *CusName;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,assign) id<CTCreateViewDelegate> delegate;
@property (nonatomic, retain) id callerSender;
@end
