//
//  CTEventViewController.h
//  Community
//
//  Created by ADMIN on 2/24/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CTImageAddViewController.h"

@protocol CTEventViewControllerDelegate <NSObject>
@end

@interface CTEventViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,NIDropDownDelegate,CTImageAddDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    id rootNavController;
    NIDropDown *dropDown;

    NSDate *minDate;
    
    NSMutableArray * listofeventName;
    NSMutableArray * listofeventId;

    NSString * activateStr;
    NSString * expireStr;
    
    int selectnumber;
    NSMutableDictionary *addressDic;
    IBOutlet UIDatePicker * datePickerActAndExp;
    
    BOOL FLAG;
    
    NSString * getEventID;
}

@property(nonatomic,assign) id<CTEventViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Start_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_End_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Detail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Type;
@property (weak, nonatomic) IBOutlet UIButton *btn_item;
@property (weak, nonatomic) IBOutlet UIButton *btn_img;
@property (weak, nonatomic) IBOutlet UIButton *btn_create;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_Start_Dt;
@property (weak, nonatomic) IBOutlet UITextField *txt_End_Dt;
@property (weak, nonatomic) IBOutlet UITextView *txt_Details;
@property (weak, nonatomic) IBOutlet UIImageView *img_eventimg;

- (IBAction)bt_Type:(id)sender;
- (IBAction)bt_Add_Img:(id)sender;
- (IBAction)bt_Create:(id)sender;
- (IBAction)bt_Cancel:(id)sender;

@end
