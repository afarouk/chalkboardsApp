//
//  CTWebviewDetailsViewController.h
//  Community
//
//  Created by Ihtesham Khan on 06/05/2015.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

// MJPopup
#import "UIViewController+MJPopupViewController.h"
@protocol MJSecondPopupDelegate;
// ---

@interface CTWebviewDetailsViewController : UIViewController <UIWebViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {
    //    IBOutlet UIWebView *webViewDetail;
    NSMutableDictionary *imageDownloadedDictionary;
    
    IBOutlet UIToolbar *toolBarDetail;
    IBOutlet UIButton  *btnHideToolBar;
    
    IBOutlet UILabel *LblTitle;
    IBOutlet UILabel *LblMessage;
    
    IBOutlet UIImageView *Img_Selected;
    
    IBOutlet UILabel *LblSASLName;
    IBOutlet UIButton * btnCall;
    IBOutlet UIButton * btnSMS;
    IBOutlet UIButton * btnEmail;
    IBOutlet UIButton * btnfacebook;
    IBOutlet UIButton * btnTwitter;
    IBOutlet UIButton * btnShareURL;

    IBOutlet UIButton *btnInfoURL;
    IBOutlet UIButton *btnPromotion;
    
    IBOutlet UIView * leftView;
    IBOutlet UIView * rightView;
    
    NSString *FbUrl;
    UITextField *Email;
    UITextField *SMS;
    
    NSString * callNumber;
    NSString * callNumbernw;
    NSString * TeliPhoneNo;
    
    IBOutlet UIScrollView *Scroll_Vw;
    
    SLComposeViewController *slComposeViewController;
    
    
    IBOutlet UILabel *ListSaslName;
    IBOutlet UILabel *ListNumber;
    IBOutlet UILabel *ListStreet;
    IBOutlet UILabel *ListCity;
    IBOutlet UILabel *ListState;
    IBOutlet UILabel *ListZipCode;
    
    IBOutlet UILabel *Lbl_ListDrive;
    IBOutlet UILabel *Lbl_ListCall;
    
    IBOutlet UILabel *Lbl_PhoneNumber;
    IBOutlet UILabel *Lbl_Location;
    IBOutlet UILabel *Lbl_saslTitle;
    IBOutlet UILabel *Lbl_MoreInfo;
    
    IBOutlet UILabel *Lbl_PromoTitle;
    
    IBOutlet UILabel *Lbl_ListAddress;
    
    IBOutlet UIImageView *Img_PromoImg;
}

// For MJPopup
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
// ---
@property (nonatomic,retain) id listofContact;
@property (nonatomic, retain) IBOutlet UIWebView *webViewDetail;
@property (assign , nonatomic) MJPopupViewAnimation animationType;
@property (nonatomic, retain) NSString *strLoadUrl;
@property BOOL isFromRootView;
@property BOOL isFavourite;
@property (nonatomic,strong)NSString *DisTitle;
@property (nonatomic,strong)NSString *DisSASLName;
@property (nonatomic,strong)NSString *DisMessage;
@property (nonatomic,strong)NSString *DisImage;
@property (nonatomic,strong)NSString *DisLattitude;
@property (nonatomic,strong)NSString *DisLongitude;
@property (nonatomic,strong)NSString *DisOnClikUrl;
@property (nonatomic,strong)NSString *DisUDID;
@property (nonatomic,strong)NSString *DisPromotitle;
@property (nonatomic,strong)NSString *Disenumtext;
@property (nonatomic,retain) id MapAddress;
@property (nonatomic) int indexValue;
@property (nonatomic) BOOL showURL;
@property (nonatomic,strong) NSString * tileEnumText;
@property (nonatomic,strong) NSString * tileClickUrl;

@property (nonatomic,strong) NSString *ListTitle;
@property (nonatomic,retain) id ListAddress;
@property (nonatomic,strong) NSString *ListLat;
@property (nonatomic,strong) NSString *ListLog;
@property (nonatomic,strong) NSString * tileSA;
@property (nonatomic,strong) NSString * tileSL;
@property (nonatomic,strong) id ListCall;
@property (weak, nonatomic) UIView *backLinkView;

- (IBAction)Fb_ButtonPressed:(id)sender;
- (IBAction)Twitter_ButtonPressed:(id)sender;
- (IBAction)Email_ButtonPressed:(id)sender;
- (IBAction)SMS_ButtonPressed:(id)sender;
- (IBAction)Call_ButtonPressed:(id)sender;
- (IBAction)Drive_ButtonPressed:(id)sender;
- (IBAction)Promotion_ButtonPressed:(id)sender;
- (IBAction)Call_ButtonNwPressed:(id)sender;

- (IBAction)MoreInfo_ButtonPressed:(id)sender;
- (IBAction)ListDrive_ButtonPressed:(id)sender;
- (void)btnFavouriteTapped:(id)sender;
- (void) reloadWebView: (BOOL)flag;
- (void) loginCallBack;
@end
