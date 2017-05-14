//
//  CTPollContestViewController.h
//  Community
//
//  Created by My Mac on 01/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTImageAddViewController.h"

@protocol CTPollContestViewControllerDelegate <NSObject>
@end

@interface CTPollContestViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,CTImageAddDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    id rootNavController;
    
    NSDate *minDate;
    NSString * activateStr;
    NSString * expireStr;
    
    IBOutlet UIDatePicker * datePickerActAndExp;
    
}

@property(nonatomic,assign) id<CTPollContestViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;
@property (nonatomic, retain) id StoreCreatePoll;
@property (nonatomic, retain) id StoreCreatePollPrizes;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Start_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_End_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Quetion;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UIButton *btn_create;
@property (weak, nonatomic) IBOutlet UIButton *btn_activate;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_Addimage;
@property (weak, nonatomic) IBOutlet UIButton *btn_Addanswer;
@property (weak, nonatomic) IBOutlet UIButton *btn_Addprize;

@property (weak, nonatomic) IBOutlet UITextField *txt_Start_Dt;
@property (weak, nonatomic) IBOutlet UITextField *txt_End_Dt;
@property (weak, nonatomic) IBOutlet UITextField *txt_Title;
@property (weak, nonatomic) IBOutlet UITextField *txt_Quetion;

- (IBAction)bt_CreatePressed:(id)sender;
- (IBAction)bt_CancelPressed:(id)sender;
- (IBAction)bt_ActivePressed:(id)sender;
- (IBAction)bt_AnswerPressed:(id)sender;
- (IBAction)bt_PrizePressed:(id)sender;
- (IBAction)bt_ImagePressed:(id)sender;

@end
