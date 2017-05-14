//
//  CTCommonMethods.h
//  Community
//
//  Created by dinesh on 24/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "CTAppDelegate.h"

@protocol CTRestaurantMenuViewDelegate <NSObject>
-(void)didTapCameraBtn;
-(void)didTapSpecialOfferView;
-(void)didTapReservationViewBtn;
-(void)didTapMessageBtn;
-(void)didTapYelpBtn;
-(void)didShowLegend;
-(void)didHideLegend;
@end
@protocol CTGetRestaurantsDelegate <NSObject>
-(void)didTapAndGetRestaruantDetails:(id)JSON;
-(void)didTapRestaurantDetailsForSA:(NSString*)sa andSL:(NSString*)sl;
@end
@interface NSObject (MyDeepCopy)
-(id)deepMutableCopy;
@end
@interface NSString (TrimmingAdditions)
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
-(NSString*)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet*)characterSet;
@end

@interface CTCommonMethods : NSObject
{
    MBProgressHUD *HUD;
}
@property(nonatomic,strong)NSMutableArray *RestaurantSA;
@property(nonatomic,strong)NSString *invitationcode;
@property(nonatomic,strong)NSMutableArray *RestaurantSL;
@property(nonatomic,strong)NSMutableArray *RestaurantSASLName;
@property(nonatomic,strong)NSString * selectSa;
@property(nonatomic,strong) NSString * selectSl;
@property(nonatomic,strong)NSMutableArray *friendlyURL;
@property(nonatomic,strong)NSMutableArray *tileUUIDtype;
@property(nonatomic,strong)NSMutableArray *tileUUID;
@property(nonatomic,strong)NSMutableArray *SASLTitleName;
@property(nonatomic,strong)NSMutableArray * SASLStars;
@property(nonatomic,strong)NSMutableArray *tileURL;
@property(nonatomic,strong)NSMutableArray *tileonClickURL;
@property(nonatomic,strong)NSMutableArray *serviceAccommodatorId;
@property(nonatomic,strong)NSMutableArray *serviceLocationId;
@property (nonatomic,strong) NSMutableArray * tileContactList;
@property (nonatomic,strong) NSMutableArray * tileAddressList;
@property (nonatomic,strong) NSMutableArray * tileviewLati;
@property (nonatomic,strong) NSMutableArray * tileviewLong;
@property (nonatomic,strong) NSString * IdentifierNoti;
@property (nonatomic,retain) NSMutableArray * StoreEventType;
@property (nonatomic,retain) NSMutableArray * TilePromoType;
@property (nonatomic,retain) NSMutableArray * PromotionEventType;
@property (nonatomic,retain) NSMutableArray * StoreDomain;
@property (nonatomic,retain) NSMutableArray * listofResturant;
@property (nonatomic,retain) id PollPrizeStore;
@property (nonatomic,retain) id PollAnswerStore;
@property(nonatomic) BOOL OWNERFLAG;
@property (nonatomic,retain) NSMutableArray* TileHasAlert;
@property (nonatomic,retain) NSMutableArray * TileadAlertMessage;
@property(nonatomic) int USERONFLAG;
@property (nonatomic,strong) NSString *Onuser;
@property (nonatomic) BOOL usersignout;
@property (nonatomic) BOOL PRAMOTIONFLAG;
@property (nonatomic) BOOL SPLASHIMAGE;
@property (nonatomic) BOOL TILEPROMOTION;
@property (nonatomic,strong) NSString * EmailID;
@property (nonatomic,retain) NSMutableArray * NavigationCityList;
@property (nonatomic,retain) NSMutableArray * NavigationCatagoryList;
@property(assign) CTAppDelegate *appDelegate;
@property (nonatomic) BOOL NavFlag;
@property (nonatomic, retain) NSMutableArray *SearchCitySelector;
@property (nonatomic,retain) id SelectCityFirstTime;
@property (nonatomic,retain) id SelectTileSaSL;
@property (nonatomic,strong) id SelectedSaSL;

+ (CTCommonMethods*)sharedInstance;
+(NSString *)getChoosenServer;
+(NSString *)getChoosenHttpServer;
+(NSString *)getChoosenHTMLServer;
+(NSString*)simulate;
+(void)showErrorAlertMessageWithTitle:(NSString *)titleStr andMessage:(NSString *)messageStr;
+(BOOL)isUIDStoredInDevice;
+(NSString *)getCurrentDevice;
+(CLLocation*)getLastLocation;
+(CLLocation*)getDefaultLocation;
+(NSError*)validateJSON:(id)JSON;
+(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview;
+(UIImage*)aspectFitSize:(CGSize)finalImageSize forImage:(UIImage*)image;
+(NSString*)UID;
+(void)setUID:(NSString*)_uid;
+(float)zoomDifferenceToShowDetails;
+(double)scrollUpdateDistanceKM;
+(id)getRootPlistObjects;
+(void)registerDefaultsFromSettingsBundle;
+ (iPhoneDeviceVersion) getIPhoneVersion;
+(NSString*)UserName;
+(void)setUserName:(NSString*)_userName;
+ (NSString *)extractErrorMessageFromError:(NSError *)error;
+ (UIColor *)colorWithHexString:(NSString *)str ;
- (void) applyBlackBorderAndCornersToButton: (UIButton *)button;
- (void) applyBlackBorderToButton: (UIButton *)button;
- (void)showHUD:(NSString *)text;
- (void)hideHUD;
- (NSString *)validateString:(id)string;

- (void)applyFont:(UIButton *)button :(NSString *)name :(float)fsize;
- (void)applyFontLabel :(UILabel *)label :(NSString *)name :(float)fsize;
- (void)applyFontTextFeild :(UITextField *)Text :(NSString *)name :(float)fsize;
-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;
@end
