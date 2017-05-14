//
//  CTAdAlertView.h
//  Community
//
//  Created by My Mac on 23/02/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@protocol CTAdAlertViewDelegate <NSObject>
@end
@interface CTAdAlertView : UIViewController <NIDropDownDelegate>
{
    IBOutlet UITextView *textViewObj;
    IBOutlet UIButton * btnduration;
    IBOutlet UIButton * btnCreate;
    IBOutlet UIButton * btnCancel;
    NIDropDown *dropDown;
    
    NSMutableArray * durationTime;
    NSMutableArray * durationid;
    NSString * selectDuration;
    
    int movementDistance ;
    CGFloat animatedDistance;
}
@property(nonatomic,assign) id<CTAdAlertViewDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

- (IBAction)durationcall:(id)sender;
-(IBAction)btnCreatePressed:(id)sender;
-(IBAction)btnCanclePressed:(id)sender;
@end
