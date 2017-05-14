//
//  CTCommonMethods.m
//  Community
//
//  Created by dinesh on 24/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTCommonMethods.h"
#import "Constants.h"
#import "CTAppDelegate.h"



#define kShowErrorAlertForUser NO
static CTCommonMethods *applicationData = nil;
static id rootPlistFile = nil;
@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}
-(NSString*)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet*)characterSet {
    NSString *str = [self stringByTrimmingLeadingCharactersInSet:characterSet];
    str= [str stringByTrimmingTrailingCharactersInSet:characterSet];
    return str;
}
@end
@implementation  NSObject (MyDeepCopy)
-(id)deepMutableCopy
{
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *oldArray = (NSArray *)self;
        NSMutableArray *newArray = [NSMutableArray array];
        for (id obj in oldArray) {
            [newArray addObject:[obj deepMutableCopy]];
        }
        return newArray;
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *oldDict = (NSDictionary *)self;
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        for (id obj in oldDict) {
            [newDict setObject:[oldDict[obj] deepMutableCopy] forKey:obj];
        }
        return newDict;
    } else if ([self isKindOfClass:[NSSet class]]) {
        NSSet *oldSet = (NSSet *)self;
        NSMutableSet *newSet = [NSMutableSet set];
        for (id obj in oldSet) {
            [newSet addObject:[obj deepMutableCopy]];
        }
        return newSet;
#if MAKE_MUTABLE_COPIES_OF_NONCOLLECTION_OBJECTS
    } else if ([self conformsToProtocol:@protocol(NSMutableCopying)]) {
        // e.g. NSString
        return [self mutableCopy];
    } else if ([self conformsToProtocol:@protocol(NSCopying)]) {
        // e.g. NSNumber
        return [self copy];
#endif
    } else {
        return self;
    }
}
@end
@implementation CTCommonMethods
@synthesize RestaurantSA;
@synthesize RestaurantSASLName;
@synthesize RestaurantSL;
@synthesize selectSa;
@synthesize selectSl;
@synthesize friendlyURL;
@synthesize TileHasAlert;
@synthesize tileUUIDtype;
@synthesize TilePromoType;
@synthesize tileonClickURL;
@synthesize tileURL;
@synthesize tileUUID;
@synthesize serviceAccommodatorId;
@synthesize serviceLocationId;
@synthesize SASLTitleName;
@synthesize SASLStars;
@synthesize IdentifierNoti;
@synthesize StoreEventType;
@synthesize invitationcode;
@synthesize PromotionEventType;
@synthesize appDelegate;
@synthesize OWNERFLAG;
@synthesize EmailID;
@synthesize USERONFLAG;
@synthesize Onuser;
@synthesize usersignout;
@synthesize PollPrizeStore;
@synthesize PollAnswerStore;
@synthesize StoreDomain;
@synthesize listofResturant;
@synthesize PRAMOTIONFLAG;
@synthesize tileContactList;
@synthesize tileviewLati;
@synthesize tileviewLong;
@synthesize TileadAlertMessage;
@synthesize tileAddressList;
@synthesize NavigationCityList;
@synthesize NavigationCatagoryList;
@synthesize SearchCitySelector;
@synthesize SelectCityFirstTime;
@synthesize TILEPROMOTION;
@synthesize SelectedSaSL;


- (id)init {
    if(self = [super init])
    {
        RestaurantSL = [[NSMutableArray alloc] init];
        RestaurantSA = [[NSMutableArray alloc] init];
        RestaurantSASLName = [[NSMutableArray alloc] init];
        StoreEventType = [[NSMutableArray alloc] init];
        PromotionEventType = [[NSMutableArray alloc] init];
        StoreDomain = [[NSMutableArray alloc] init];
        listofResturant = [[NSMutableArray alloc] init];
        appDelegate = (CTAppDelegate *)[[UIApplication sharedApplication]delegate];
        tileUUID = [[NSMutableArray alloc] init];
        tileUUIDtype = [[NSMutableArray alloc] init];
        friendlyURL = [[NSMutableArray alloc] init];
        serviceAccommodatorId = [[NSMutableArray alloc]init];
        serviceLocationId = [[NSMutableArray alloc]init];
        SASLTitleName = [[NSMutableArray alloc]init];
        tileURL = [[NSMutableArray alloc]init];
        SASLStars = [[NSMutableArray alloc]init];
        tileContactList= [[NSMutableArray alloc] init];
        tileviewLati = [[NSMutableArray alloc] init];
        tileviewLong = [[NSMutableArray alloc] init];
        tileAddressList = [[NSMutableArray alloc] init];
        tileonClickURL = [[NSMutableArray alloc]init];
        TileHasAlert = [[NSMutableArray alloc]init];
        TileadAlertMessage = [[NSMutableArray alloc]init];
        TilePromoType = [[NSMutableArray alloc]init];
        NavigationCityList = [[NSMutableArray alloc]init];
        NavigationCatagoryList = [[NSMutableArray alloc]init];
        SearchCitySelector = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)initialize {
}
+ (CTCommonMethods*)sharedInstance
{
    if (applicationData == nil)
    {
        applicationData = [[super allocWithZone:NULL] init];
        [applicationData initialize];
    }
    return applicationData;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark- Color

+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [CTCommonMethods colorWithHex:x];
}

+ (NSString *)getHexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

- (void)initHUD
{
    HUD=[[MBProgressHUD alloc] init];
    HUD.dimBackground=YES;
    [appDelegate.window.rootViewController.view addSubview:HUD];
}

- (void)hideHUD
{
    [HUD hide:YES];
}

- (void)showHUD:(NSString *)text
{
    if(!HUD)
        [self initHUD];
    HUD.labelText=text;
    NSLog(@"HUD.labelText = %@",HUD.labelText);
    [appDelegate.window.rootViewController.view bringSubviewToFront:HUD];
    [HUD show:YES];
}


+(NSString*)simulate {
    BOOL demoMode = [[[NSUserDefaults standardUserDefaults]objectForKey:CT_Simulate]boolValue];
    if(demoMode)
        return @"true";
    return @"false";
}
- (NSString *)validateString:(id)string{
    if (string && [string isKindOfClass:[NSString class]]) {
        return string;
    }
    else {
        return @"";
    }
}
- (void) applyBlackBorderAndCornersToButton: (UIButton *)button{
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 3;
    button.layer.cornerRadius = 6;
    //button.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:15.0];
}

- (void)applyFont:(UIButton *)button :(NSString *)name :(float)fsize
{
    button.titleLabel.font = [UIFont fontWithName:name size:fsize];
}

- (void)applyFontTextFeild :(UITextField *)Text :(NSString *)name :(float)fsize;
{
    [Text setFont:[UIFont fontWithName:name size:fsize]];
}


- (void)applyFontLabel :(UILabel *)label :(NSString *)name :(float)fsize
{
    label.font = [UIFont fontWithName:name size:fsize];
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *lbl = (UIButton *)view;
        //[lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
        [lbl.titleLabel setFont:[UIFont fontWithName:fontFamily size:[[lbl.titleLabel font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

- (void) applyBlackBorderToButton: (UIButton *)button
{
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2;
}

+(NSString *)getChoosenHttpServer
{
    if ([[CTCommonMethods simulate] isEqualToString:@"true"]) {
        return CT_DemoHTTPServer_BaseURL;
    }
    else {
        return CT_ProdHTTPServer_BaseURL;
    }
    
    if ([CT_Server isEqualToString:CT_ProdServer]){
        return CT_ProdHTTPServer_BaseURL;
    }
    else if ([CT_Server isEqualToString:CT_DemoServer]){
        return CT_DemoHTTPServer_BaseURL;
    }
    else{
        return CT_No_Server_Choosen;
    }
}

+(NSString *)getChoosenServer{
    
    if ([[CTCommonMethods simulate] isEqualToString:@"true"]) {
        return CT_DemoServer_BaseURL;
    }
    else {
        return CT_ProdServer_BaseURL;
    }
    
    if ([CT_Server isEqualToString:CT_ProdServer]){
        return CT_ProdServer_BaseURL;
    }
    else if ([CT_Server isEqualToString:CT_Localhost]){
        return CT_Localhost_BaseURL;
    }
    else{
        return CT_No_Server_Choosen;
    }
}


+(NSString *)getChoosenHTMLServer{
    
    if ([[CTCommonMethods simulate] isEqualToString:@"true"]) {
        return CT_DemoHTMLServer;
    }
    else {
        return CT_ProdHTMLServer;
    }
    
    if ([CT_Server isEqualToString:CT_ProdServer]){
        return CT_ProdHTMLServer;
    }
    else if ([CT_Server isEqualToString:CT_DemoServer]){
        return CT_DemoHTMLServer;
    }
    else{
        return CT_No_Server_Choosen;
    }
}
+(void)showErrorAlertMessageWithTitle:(NSString *)titleStr andMessage:(NSString *)messageStr{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
+(BOOL)isUIDStoredInDevice{
    if([self UID] && [self UID].length>0)
        return YES;
    return NO;
    //    if([[NSUserDefaults standardUserDefaults]objectForKey:CT_UID]){
    //        return YES;
    //    }
    //    else{
    //        return NO;
    //    }
}
+(NSString *)getCurrentDevice{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
        
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
            
            CGSize result=[UIScreen mainScreen].bounds.size;
            CGFloat scale=[UIScreen mainScreen].scale;
            result=CGSizeMake(result.width*scale, result.height*scale);
            
            if(result.height==480){
                
                return iPHONE_3GS;
            }
            else if(result.height==640){
                
                return iPHONE4_4S;
            }
            else if (result.height==1136){
                
                return iPHONE5;
            }
            else{
                
                return iPHONE5;
            }
        }
    }
    return @"";
}
+(CLLocation*)getDefaultLocation {
    return [[CLLocation alloc]initWithLatitude:37.4464863 longitude:-122.1612654];
    
}
+(CLLocation*)getLastLocation {
    if([[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] && [[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude])
        return   [[CLLocation alloc]initWithLatitude:[[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude] floatValue] longitude:[[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude] floatValue]];
    return [self getDefaultLocation];
}

+(NSError*)validateJSON:(id)JSON {
    NSDictionary *errorDictionary = [JSON valueForKey:@"error"];
    if(errorDictionary && errorDictionary.count>0) {
        NSError *error= nil;
        if(kShowErrorAlertForUser)
            error = [NSError errorWithDomain:@"com.community.exception" code:42 userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:CT_AlertTitle,CT_DefaultAlertMessage, nil] forKeys:[NSArray arrayWithObjects:NSLocalizedFailureReasonErrorKey,NSLocalizedDescriptionKey, nil]]];
        else
            error = [NSError errorWithDomain:@"com.community.exception" code:42 userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[errorDictionary valueForKey:@"type"],[errorDictionary valueForKey:@"message"], nil] forKeys:[NSArray arrayWithObjects:NSLocalizedFailureReasonErrorKey,NSLocalizedDescriptionKey, nil]]];
        return error;
    }
    return nil;
}
//+(BOOL)validateJSON:(id)JSON {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",@"error"];
//    if(JSON && (([JSON isKindOfClass:[NSArray class]] && [JSON filteredArrayUsingPredicate:predicate].count == 0) || [JSON valueForKey:@"error"] == nil))
//        return YES;
//    return NO;
//}
+(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    
    
    float newwidth;
    float newheight;
    
    UIImage *image=imgview.image;
    
    if (image.size.height>=image.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(image.size.width/image.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
        
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(image.size.height/image.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    
    NSLog(@"image after aspect fit: width=%f height=%f",newwidth,newheight);
    
    
    //adapt UIImageView size to image size
    //imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake(newwidth, newheight);
    
}
+(UIImage*)aspectFitSize:(CGSize)finalImageSize forImage:(UIImage*)image {
    CGImageRef sourceImageRef = image.CGImage;
    
    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(sourceImageRef);
    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(sourceImageRef);
    CGFloat ratio = MAX(horizontalRatio, verticalRatio); //AspectFill
    CGSize aspectFillSize = CGSizeMake(CGImageGetWidth(sourceImageRef) * ratio, CGImageGetHeight(sourceImageRef) * ratio);
    
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 finalImageSize.width,
                                                 finalImageSize.height,
                                                 CGImageGetBitsPerComponent(sourceImageRef),
                                                 0,
                                                 CGImageGetColorSpace(sourceImageRef),
                                                 CGImageGetBitmapInfo(sourceImageRef));
    
    //Draw our image centered vertically and horizontally in our context.
    CGContextDrawImage(context,
                       CGRectMake((finalImageSize.width-aspectFillSize.width)/2,
                                  (finalImageSize.height-aspectFillSize.height)/2,
                                  aspectFillSize.width,
                                  aspectFillSize.height),
                       sourceImageRef);
    
    //Start cleaning up..
    CGImageRelease(sourceImageRef);
    
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
    
    CGContextRelease(context);
    CGImageRelease(finalImageRef);
    return finalImage;
}

+ (iPhoneDeviceVersion) getIPhoneVersion{
    iPhoneDeviceVersion iPhoneVersion = iPhone4;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        const int result = [[UIScreen mainScreen] bounds].size.height;
        switch(result){
                
            case 480:{
                // iPhone 4
                iPhoneVersion = iPhone4;
            }
                break;
            case 568:{
                // iPhone 5
                iPhoneVersion = iPhone5;
            }
                break;
            case 667:{
                // iPhone 6
                iPhoneVersion = iPhone6;
            }
                break;
            case 736:{
                // iPhone 6 Plus
                iPhoneVersion = iPhone6Plus;
            }
                break;
                
        }
    }
    return iPhoneVersion;
}

+ (id) getRootPlistObjects{
    if (!rootPlistFile) {
        NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        if(!settingsBundle) {
            NSLog(@"Could not find Settings.bundle");
            return nil;
        }
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        rootPlistFile = [settings objectForKey:@"PreferenceSpecifiers"];
    }
    return rootPlistFile;
}

+(float)zoomDifferenceToShowDetails{
    float zoomDiff = 0.0;
    zoomDiff = [[[NSUserDefaults standardUserDefaults] valueForKey:CT_ZoomThreshold] doubleValue];
    //    printf("\n Zoom Threshold %f \n",zoomDiff);
    return zoomDiff;
}

+(double)scrollUpdateDistanceKM{
    double scrollUpdateDistance = 2.;
    scrollUpdateDistance = [[[NSUserDefaults standardUserDefaults] valueForKey:CT_DistanceThreshold] doubleValue];
    //    printf("\n Distance Threshold %f \n",scrollUpdateDistance);
    return scrollUpdateDistance;
}

+ (void)registerDefaultsFromSettingsBundle
{
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    for(NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            if ([@[CT_ZoomThreshold,
                   CT_DistanceThreshold,
                   CT_Simulate         ] containsObject:key] && [[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
                [[NSUserDefaults standardUserDefaults] setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
    }
}

+ (NSString *)extractErrorMessageFromError:(NSError *)error{
    NSString *errorMessage = @"";
    if (error.localizedRecoverySuggestion) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dictError=dict[@"Error"];
        
        errorMessage = dictError[@"message"];
    }
    else {
        errorMessage = error.localizedDescription;
    }
    return errorMessage;
}

static NSString *uid;
+(NSString*)UID {
    if(uid == nil)
        return @"";
    return uid;
}
+(void)setUID:(NSString*)_uid {
    uid = _uid;
}

static NSString *userName;
+(NSString*)UserName {
    if(userName == nil)
        return @"";
    return userName;
}
+(void)setUserName:(NSString*)_userName {
    userName = _userName;
}
@end
