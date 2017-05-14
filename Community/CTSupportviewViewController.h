//
//  CTSupportviewViewController.h
//  Community
//
//  Created by My Mac on 16/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTSupportviewViewControllerDelegate <NSObject>
@end
@interface CTSupportviewViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    IBOutlet UITextField * emailField,*subjectField;
    IBOutlet UIButton * btnWebsite;
    IBOutlet UIButton * btnSubmit;
    IBOutlet UITextView * detailTextview;
    NSString *placeholder;
    
    int movementDistance ;
    CGFloat animatedDistance;
    id rootNavController;
}
@property(nonatomic,assign) id<CTSupportviewViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;
-(IBAction)submitPressed:(id)sender;
-(IBAction)websitePressed:(id)sender;
@end
