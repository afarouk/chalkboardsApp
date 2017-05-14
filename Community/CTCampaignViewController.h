//
//  CTCampaignViewController.h
//  Community
//
//  Created by ADMIN on 5/3/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface CTCampaignViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,NIDropDownDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *txt_Title;
    IBOutlet UITextField *txt_EndDate;
    IBOutlet UITextField *txt_Reward;
    IBOutlet UITextField *txt_CreditCard;
    IBOutlet UITextField *txt_Expiration;
    IBOutlet UITextField *txt_CVV;
    IBOutlet UITextField *txt_Street;
    IBOutlet UITextField *txt_Street2;
    IBOutlet UITextField *txt_City;
    IBOutlet UITextField *txt_Zip;
    IBOutlet UITextField *txt_CardName;
    IBOutlet UITextField *txt_ParcentOff;
    IBOutlet UITextField *txt_MinPurchase;
    IBOutlet UITextField *txt_StartDate;
    
    IBOutlet UITextField *txt_FirstName;
    IBOutlet UITextField *txt_LastName;
    IBOutlet UIButton *btn_State;
    IBOutlet UIButton *btn_Country;
    IBOutlet UIButton *btnCreate;
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UIImageView *btnAgree;
    IBOutlet UIScrollView *Scroll;
    
    NIDropDown *dropDown;
    
    NSMutableArray * listofStateName;
    NSMutableArray * listenumName;
    NSMutableArray * listCityName;
    
    NSMutableArray * listofArray;
    
    IBOutlet UILabel *Lbl_Terms;
    int movementDistance ;
    CGFloat animatedDistance;
    int selectnumber;
    NSMutableDictionary *addressDic;
    BOOL FLAG;
    BOOL AgreeFlag;
    
    IBOutlet UIDatePicker * datePickerActAndExp;
    NSMutableArray *pickeryear;
    NSMutableArray *pickermonth;
    NSString * strpickr;
    NSString * strmonth;
    NSString * stryear;
    UIPickerView * myPickerView;
    NSDate *minDate;
    NSString * activateStr;
    NSString * deactivateStr;
    NSString * expireStr;
    
    IBOutlet UIImageView *imageCash;
    IBOutlet UIImageView * imageDiscount;
    IBOutlet UIButton * btnCash;
    BOOL CASHBOOL;
    
    IBOutlet UIView *Case_Vw;
    IBOutlet UIView *Button_Vw;
    IBOutlet UIView *Discount_Vw;
    NSString *SelectedReward;
}
- (IBAction)StateButtonPressed:(id)sender;
- (IBAction)CountryButtonPressed:(id)sender;
- (IBAction)CreateButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)CashButtonPressed:(id)sender;
- (IBAction)AgreeButtonPressed:(id)sender;




@end
