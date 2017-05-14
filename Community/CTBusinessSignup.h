//
//  CTBusinessSignup.h
//  Community
//
//  Created by My Mac on 22/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CustomIOSAlertView.h"

@protocol CTBusinessSignupDelegate <NSObject>
@end
@interface CTBusinessSignup : UIViewController<UITextFieldDelegate,UITextViewDelegate,NIDropDownDelegate,UIGestureRecognizerDelegate,CustomIOSAlertViewDelegate>
{
    NIDropDown *dropDown;
    NSMutableArray * listofDomainName;
    NSMutableArray * listofStateName;
    NSMutableArray * listofStateShort;
    NSMutableArray * listenumName;
    NSMutableArray * listCityName;
    
    NSMutableArray * listofArray;
    NSString * sortState;
    int movementDistance ;
    CGFloat animatedDistance;
    int selectnumber;
    NSMutableDictionary *addressDic;
    BOOL FLAG;
    
    
    IBOutlet UITextField *txt_Email;
    
    IBOutlet UITextField *txt_Password;
    
    IBOutlet UITextField *txt_ConPassword;
    
    IBOutlet UITextField *txt_Business;
    
    IBOutlet UIButton *btn_Domain;
    
    IBOutlet UITextField *txt_Street;
    
    IBOutlet UITextField *txt_Street2;
    
    IBOutlet UITextField *txt_City;
    
    IBOutlet UIButton *btn_State;
    
    IBOutlet UITextField *txt_Zip;
    
    IBOutlet UITextField *txt_Country;
    
    IBOutlet UITextField *txt_BusiNumber;
    
    IBOutlet UIScrollView *Scroll;
    
    IBOutlet UIButton * btn_Cancel;
    
    IBOutlet UIButton * btn_Create;
    
    IBOutlet UIButton *btn_City;
    IBOutlet UIButton * btn_Country;
    
    NSMutableArray * listofcountry;
}
@property(nonatomic,assign) id<CTBusinessSignupDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

- (IBAction)BTN_CreatePressed:(id)sender;

- (IBAction)BTN_CancelPressed:(id)sender;

- (IBAction)BTN_DomainPressed:(id)sender;

- (IBAction)BTN_StatePressed:(id)sender;

- (IBAction)BTN_CityPressed:(id)sender;
- (IBAction)BTN_CountryPressed:(id)sender;


@end
